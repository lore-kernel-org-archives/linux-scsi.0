From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: error handler scheduling
Date: Wed, 27 Mar 2013 10:39:07 -0400
Message-ID: <5153048B.20905@interlog.com>
References: <51525560.3000008@emulex.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56923 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab3C0Ojr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Mar 2013 10:39:47 -0400
In-Reply-To: <51525560.3000008@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 13-03-26 10:11 PM, James Smart wrote:
> In looking through the error handler, if a command times out and is added to the
> eh_cmd_q for the shost, the error handler is only awakened once shost->host_busy
> (total number of i/os posted to the shost) is equal to shost->host_failed
> (number of i/o that have been failed and put on the eh_cmd_q).  Which means, any
> other i/o that was outstanding must either complete or have their timeout fire.
> Additionally, as all further i/o is held off at the block layer as the shost is
> in recovery, new i/o cannot be submitted until the error handler runs and
> resolves the errored i/os.
>
> Is this true ?
>
> I take it is also true that the midlayer thus expects every i/o to have an i/o
> timeout.  True ?
>
> The crux of this point is that when the recovery thread runs to aborts the timed
> out i/os, is at the mercy of the last command to complete or timeout.
> Additionally, as all further i/o is held off at the block layer as the shost is
> in recovery, new i/o cannot be submitted until the error handler runs and
> resolves the errored i/os. So all I/O on the host is stopped until that last i/o
> completes/times out.   The timeouts may be eons later.  Consider SCSI format
> commands or verify commands that can take hours to complete.
>
> Specifically, I'm in a situation currently, where an application is using sg to
> send a command to a target. The app selected no-timeout - by setting timeout to
> MAX_INT. Effectively it's so large its infinite. This I/O was one of those
> "lost" on the storage fabric. There was another command that long ago timed out
> and is sitting on the error handlers queue. But nothing is happening - new i/o,
> or error handler to resolve the failed i/o, until that inifinite i/o completes.
>
> I'm hoping I hear that I just misunderstand things.  If not,  is there a
> suggestion for how to resolve this predicament ?    IMHO, I'm surprised we stop
> all i/o for error handling, and that it can be so long later... I would assume
> there's a minimum bound we would wait in the error handler (30s?) before we
> unconditionally run it and abort anything that was outstanding.

James,
After many encounters with the Linux SCSI mid-level error
handler I have concluded it is uncontrollable and
seemingly random, seen from the user space. Interestingly,
several attempts to add finer grained controls over
lu/target/host resets have been rebuffed.

So my policy is to avoid timeout induced resets (like the
plague). Hence the default with sg_format is to set the IMMED
bit and use TEST UNIT READY or REQUEST SENSE polling to
monitor progress **. With commands like VERIFY, send many
reasonably sized commands, not one big one. And a special
mention for the SCSI WRITE SAME command which probably
has T10's silliest definition: if the NUMBER OF
LOGICAL BLOCKS field is set to zero it means keep writing
until the end of the disk *** and that might be 20 hours
later! The equivalent field set to zero in a SCSI VERIFY
or WRITE *** command means do nothing.

Doug Gilbert


**   You can still run into problems when a SCSI FORMAT UNIT
      with the IMMED bit set: some other kernel subsystem or
      user space program may decide to send a SCSI command to the
      disk during format. Then said code may not comprehend why
      the disk in question is not ready and ends up triggering
      mid-level error handling which blows the format out of
      the water. That leaves the disk in the "format corrupt"
      state.

***  recently the Block Limits VPD has (knee-)capped this
      with the WSNZ bit

**** apart from the obsolete WRITE(6) command which found
      another non obvious interpretation for a zero transfer
      length
