From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: error handler scheduling
Date: Fri, 12 Apr 2013 17:42:55 +0800
Message-ID: <5167D71F.5000001@cn.fujitsu.com>
References: <51525560.3000008@emulex.com> <5153048B.20905@interlog.com> <94D0CD8314A33A4D9D801C0FE68B402950DB0D1D@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9072 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab3DLJlD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Apr 2013 05:41:03 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950DB0D1D@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "James.Smart@emulex.com" <James.Smart@emulex.com>, hare@suse.de
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/29/2013 12:02 AM, Elliott, Robert (Server Storage) wrote:
> There are several possible reasons for SCSI command timeouts:
>      a) the command request did not get to the SCSI target port and logical
>         unit (e.g., error on the wire)
>      b) logical unit is still working on the command
>      c) the command completed, but status didn't get to the SCSI initiator port
>         and application client (e.g., error on the wire)
>
> SCSI doesn't have a good way to detect case (c). For status delivery errors
> detected by the logical unit, I once proposed that the logical unit establish
> a unit attention condition and record the status delivery problem in a log
> page (T10 proposal 04-072) but this proposal didn't draw much interest. The
> QUERY TASK task management function can detect case (b) vs. the other cases.
>
> With SSDs, a lengthy timeout derived from ancient SCSI floppy drives doesn't
> make sense. Timeouts should scale automatically based on the device type
> (e.g., use microseconds for SSDs and seconds for HDDs). The REPORT
> SUPPORTED OPERATION CODES command provides some command timeout values
> to facilitate this.
>
> For Base feature set drives I'm encouraging an approach like this for
> handling command timeouts:
>
> 1) at discovery time:
>      1a) send REPORT SUPPORTED OPERATION CODES to determine the nominal
>          and maximum command timeouts
>      1b) send REPORT SUPPORTED TASK MANAGEMENT FUNCTION to determine
>          the TMF timeouts
>
> 2) send the command (e.g., READ, WRITE, FORMAT UNIT, ...)
>
> If status arrives for the command at any time, exit out of this procedure.
> If an I_T nexus loss occurs, then that handling overrides this procedure
> as well. Otherwise:
>
> 3) if the nominal command timeout is long (e.g., for a command like FORMAT
> UNIT with IMMED=0, but not for IO commands like READ and WRITE), then wait
> a short time and send QUERY TASK to ensure the command got there:
>      3a) if the command is not there (probably lost in delivery, but
>          possibly lost status), go to step (2) to resend the command
>      3b) if the command is still being processed, keep waiting
>
> 4) if the nominal command timeout is reached, send QUERY TASK to determine
> what is happening:
>      4a) if the command is not there (if step (3) was run, then this
>          probably means lost status), go to step (2) to resend the command
>      4b) if the command is still being processed, keep waiting
>
> 5) if the maximum command timeout is reached, send QUERY TASK to determine
> what is happening:
>      5a) if the command is not there (since step (4) was run, this
>           probably means lost status), go to step (2) to resend the command
>      5b) if the command is still being processed, proceed to step (6)
>          to abort the command
>
> 6) send ABORT TASK to abort the command
>
> 7) If ABORT TASK succeeds, either:
>      7a) escalate to a stronger TMF or hard reset if this command
>         keeps having repeated problems; or
>      7b) go to step (2) to resend the command
>
> 8) If the ABORT TASK timeout is reached, either:
>      8a) escalate to a stronger TMF or hard reset, then go to step (2)
>          to resend the command; or
>      8b) declare the logical unit is unavailable
>
> Doug: for ***, In addition to WSNZ bit now letting the drive not support
> the value of zero, T10 proposal 13-052 changes WRITE SAME so the NUMBER
> OF LOGICAL BLOCKS set to zero (if supported) must honor the MAXIMUM WRITE
> SAME LENGTH field, so the drive can provide a reasonable timeout value
> for the command (not worry that the entire capacity might be specified).

Please let me summarize what this thread has talked about the scsi
eh latency:

1) some scsi cmds' timemout values are inappropriate, we can avoid
    timeout by:
    a) sg_format sets the IMMED bit and use TEST UNIT READY or REQUEST
       SENSE polling to monitor - by Douglas
    b) cut big cmd into some reasonable-sized ones - by Douglas
    c) improve timeout values according to device types - by Elliott
2) call ->done() on the command after lun reset - by Hannes

And, my question is:
- could we wake up eh thread ASAP instead of waiting for all cmds
   complete to fast scheduling?

BTW: my original question is here:
http://www.spinics.net/lists/linux-scsi/msg65107.html

Thanks,
Ren

> ---
> Rob Elliott    HP Server Storage
>
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Douglas Gilbert
>> Sent: Wednesday, 27 March, 2013 9:39 AM
>> To: James.Smart@emulex.com
>> Cc: linux-scsi@vger.kernel.org
>> Subject: Re: error handler scheduling
>>
>> On 13-03-26 10:11 PM, James Smart wrote:
>>> In looking through the error handler, if a command times out and is added to
>> the
>>> eh_cmd_q for the shost, the error handler is only awakened once shost-
>>> host_busy
>>> (total number of i/os posted to the shost) is equal to shost->host_failed
>>> (number of i/o that have been failed and put on the eh_cmd_q).  Which
>> means, any
>>> other i/o that was outstanding must either complete or have their timeout
>> fire.
>>> Additionally, as all further i/o is held off at the block layer as the shost is
>>> in recovery, new i/o cannot be submitted until the error handler runs and
>>> resolves the errored i/os.
>>>
>>> Is this true ?
>>>
>>> I take it is also true that the midlayer thus expects every i/o to have an i/o
>>> timeout.  True ?
>>>
>>> The crux of this point is that when the recovery thread runs to aborts the
>> timed
>>> out i/os, is at the mercy of the last command to complete or timeout.
>>> Additionally, as all further i/o is held off at the block layer as the shost is
>>> in recovery, new i/o cannot be submitted until the error handler runs and
>>> resolves the errored i/os. So all I/O on the host is stopped until that last i/o
>>> completes/times out.   The timeouts may be eons later.  Consider SCSI format
>>> commands or verify commands that can take hours to complete.
>>>
>>> Specifically, I'm in a situation currently, where an application is using sg to
>>> send a command to a target. The app selected no-timeout - by setting
>> timeout to
>>> MAX_INT. Effectively it's so large its infinite. This I/O was one of those
>>> "lost" on the storage fabric. There was another command that long ago timed
>> out
>>> and is sitting on the error handlers queue. But nothing is happening - new i/o,
>>> or error handler to resolve the failed i/o, until that inifinite i/o completes.
>>>
>>> I'm hoping I hear that I just misunderstand things.  If not,  is there a
>>> suggestion for how to resolve this predicament ?    IMHO, I'm surprised we
>> stop
>>> all i/o for error handling, and that it can be so long later... I would assume
>>> there's a minimum bound we would wait in the error handler (30s?) before
>> we
>>> unconditionally run it and abort anything that was outstanding.
>> James,
>> After many encounters with the Linux SCSI mid-level error
>> handler I have concluded it is uncontrollable and
>> seemingly random, seen from the user space. Interestingly,
>> several attempts to add finer grained controls over
>> lu/target/host resets have been rebuffed.
>>
>> So my policy is to avoid timeout induced resets (like the
>> plague). Hence the default with sg_format is to set the IMMED
>> bit and use TEST UNIT READY or REQUEST SENSE polling to
>> monitor progress **. With commands like VERIFY, send many
>> reasonably sized commands, not one big one. And a special
>> mention for the SCSI WRITE SAME command which probably
>> has T10's silliest definition: if the NUMBER OF
>> LOGICAL BLOCKS field is set to zero it means keep writing
>> until the end of the disk *** and that might be 20 hours
>> later! The equivalent field set to zero in a SCSI VERIFY
>> or WRITE *** command means do nothing.
>>
>> Doug Gilbert
>>
>>
>> **   You can still run into problems when a SCSI FORMAT UNIT
>>        with the IMMED bit set: some other kernel subsystem or
>>        user space program may decide to send a SCSI command to the
>>        disk during format. Then said code may not comprehend why
>>        the disk in question is not ready and ends up triggering
>>        mid-level error handling which blows the format out of
>>        the water. That leaves the disk in the "format corrupt"
>>        state.
>>
>> ***  recently the Block Limits VPD has (knee-)capped this
>>        with the WSNZ bit
>>
>> **** apart from the obsolete WRITE(6) command which found
>>        another non obvious interpretation for a zero transfer
>>        length
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

