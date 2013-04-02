From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: error handler scheduling
Date: Tue, 2 Apr 2013 00:43:36 -0700
Message-ID: <515A8C28.3070603@broadcom.com>
References: <51525560.3000008@emulex.com> <515303AE.3060605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1300 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760541Ab3DBHtX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Apr 2013 03:49:23 -0400
In-Reply-To: <515303AE.3060605@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James.Smart@emulex.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/27/2013 07:35 AM, Hannes Reinecke wrote:
> On 03/27/2013 03:11 AM, James Smart wrote:
>> In looking through the error handler, if a command times out and is
>> added to the eh_cmd_q for the shost, the error handler is only
>> awakened once shost->host_busy (total number of i/os posted to the
>> shost) is equal to shost->host_failed (number of i/o that have been
>> failed and put on the eh_cmd_q).  Which means, any other i/o that
>> was outstanding must either complete or have their timeout fire.
>> Additionally, as all further i/o is held off at the block layer as
>> the shost is in recovery, new i/o cannot be submitted until the
>> error handler runs and resolves the errored i/os.
>>
>> Is this true ?
>>
> Yes.
>
>> I take it is also true that the midlayer thus expects every i/o to
>> have an i/o timeout.  True ?
>>
> Yes. But this is guaranteed by the block-layer:
>
> void blk_add_timer(struct request *req)
> {
>     struct request_queue *q = req->q;
>     unsigned long expiry;
>
>     if (!q->rq_timed_out_fn)
>         return;
>
>     BUG_ON(!list_empty(&req->timeout_list));
>     BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
>
>     /*
>      * Some LLDs, like scsi, peek at the timeout to prevent a
>      * command from being retried forever.
>      */
>     if (!req->timeout)
>         req->timeout = q->rq_timeout;
>
>
> So every request will have a timeout, either the default request_queue 
> timeout or an individual one.
>
>> The crux of this point is that when the recovery thread runs to
>> aborts the timed out i/os, is at the mercy of the last command to
>> complete or timeout. Additionally, as all further i/o is held off at
>> the block layer as the shost is in recovery, new i/o cannot be
>> submitted until the error handler runs and resolves the errored
>> i/os. So all I/O on the host is stopped until that last i/o
>> completes/times out.   The timeouts may be eons later.  Consider
>> SCSI format commands or verify commands that can take hours to
>> complete.
>>
> Yes, that's true. Unfortunately.
>
>> Specifically, I'm in a situation currently, where an application is
>> using sg to send a command to a target. The app selected no-timeout
>> - by setting timeout to MAX_INT. Effectively it's so large its
>> infinite. This I/O was one of those "lost" on the storage fabric.
>> There was another command that long ago timed out and is sitting on
>> the error handlers queue. But nothing is happening - new i/o, or
>> error handler to resolve the failed i/o, until that inifinite i/o
>> completes.
>>
> Hehe. no timeout != MAX_INT.
>
> It's easy to apply a timeout if none is set. But how do we determine 
> what constitutes a valid timeout?
>
> As mentioned, some command can literally take forever, _and_ being 
> fully legit. So who are we to decide?
>
>> I'm hoping I hear that I just misunderstand things.  If not,  is
>> there a suggestion for how to resolve this predicament ? IMHO,
>> I'm surprised we stop all i/o for error handling, and that it can be
>> so long later... I would assume there's a minimum bound we would
>> wait in the error handler (30s?) before we unconditionally run it
>> and abort anything that was outstanding.
>>
> Ah, the joys of error recovery.
>
> Incidentally, that'll be one of the topics I'll be discussing at LSF; 
> I've been bitten by this on various other occasions.
>
> AFAIK the reasoning behind the current error recovery strategy is that 
> it's modelled after SCSI parallel behaviour, where you basically have 
> to stop the entire bus, figure out which state it's in, and then take 
> corrective action.
> And you typically don't have any LUNs to deal with.
> _And_ SPI is essentially single-threaded when it comes to target 
> access, so in effect you cannot send commands over the bus when 
> resetting a target.
> So there it makes sense.
>
> Less so for modern fabrics, where target access is governed by an I_T 
> nexus, any of which is largely independent on others.
>
> Actually there is another issue with the error handler:
> The commands will only be release after eh is done.
>
> If you look at the eh sequence
> -> eh_abort
>   -> eh_lun_reset
>     -> eh_target_reset
>       -> eh_bus_reset
>         -> eh_host_reset
> the command itself is only meaningful until lun_reset() has completed; 
> after lun_reset() the command is invalided.
> Every other stage still uses the scsi command as an argument,
> but only as a place holder to figure out which device it should act upon.
>
> So we _could_ speed up things by quite a lot when we were able to call 
> ->done() on the command after lun reset; then the command would be 
> returned to the upper layers.
> And things like multipath could kick in an move I/O to other
> devices.
>
> However, this is a daunting task.
> I've tried, and it's far from easy.
> _Especially_ do to some FC HBAs insisting on using scmds for sending 
> TARGET RESET TMFs.
> If we just could do a LOGO for target reset things would become so 
> much easier ...
For FC HBAs, as per FCP-4:
"12.5.1 ABTS error recovery
If a response to an ABTS is not received within 2 times R_A_TOVELS, the 
initiator FCP_Port may transmit the ABTS again, attempt other retry 
operations allowed by FC-FS-3, or explicitly logout the target FCP_Port. 
If those retry operations attempted are unsuccessful, the initiator 
FCP_Port shall explicitly logout (i.e., transmit a LOGO ELS) the target 
FCP_Port. All outstanding Exchanges with that target FCP_Port are 
terminated at the initiatorFCP_Port."

So, for FC HBAs, if a command times out we dont have to escalate the 
error recovery from lun reset to host reset.

Thanks,
Bhanu
>
> Cheers,
>
> Hannes



