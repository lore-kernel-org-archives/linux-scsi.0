From: Hannes Reinecke <hare@suse.de>
Subject: Re: Question: eh_abort_handler() and terminate commands
Date: Sat, 25 May 2013 11:42:23 +0200
Message-ID: <51A0877F.60601@suse.de>
References: <519F47B7.1040504@suse.de> <519FE903.6050706@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab3EYIm1 (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Sat, 25 May 2013 04:42:27 -0400
In-Reply-To: <519FE903.6050706@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: "Linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On 05/25/2013 12:26 AM, Jeremy Linton wrote:
> On 5/24/2013 5:57 AM, Hannes Reinecke wrote:
>> Which leads to the interesting question: What happens with the actual
>> command once eh_abort_handler returns?
>
> 	Well, eventually it ends up on the done_q and gets returned up the stack via
> flush_done_q(). But that wasn't what you were asking?
>
>>
>> As normally 'eh_abort_handler' is implemented as a TMF, one does assume
>> that the command itself will be returned by the target with an appropriate
>> status.
> 	Uh, well you don't get a "proper" SCSI status on a TMF or a ABTS/ABTX. So
> basically, the abort just kills processing of the commands.
>
Ah. That would explain it. I was under the impression that an ABORT TASK 
TMF would cause the target firmware to terminate the command. With the 
net effect that you'd get _two_ completions, one for the ABORT TASK TMF 
and one for the original command.

>> OTOH it also means that the HBA firmware might receive a completion for a
>> command which the upper layer has already completed.
> 	Well, I think there is some rule here (scsi_eh.txt, "everyone forgets about
> the command") that by the time the eh_abort_handler() completes you won't get
> any new scsi_done()s. This doesn't appear to mean that you won't get them
> while the abort_handler is running. Hence if you look at send_eh_cmnd() you
> see that the done completion being triggered at any time after the
> wait_for_completion_timeout() doesn't really do anything useful. The normal
> abort path completion doesn't appear to care either. Abort success/failure
> doesn't appear to fundamentally change the eventual return status of the
> commands.
>
Yes, that's what I noticed; the status of the aborted command is being 
set by midlayer, not by the LLDD or the target.

>> Will this completion ever being mirrored to the LLDD? Or discarded by the
>> firmware?
>
> 	Yes, if for some reason a status comes in for an aborted exchange the HBA
> firmware rejects it because its against an invalid exchange (or should, the
> HBA i'm most familiar with does it this way). This is fairly easy to test if
> you have a jammer, just inject a FCP_RSP_IU into an aborted exchange.
>
That's quite large 'if' statement; I'm not fortunate enough to own one 
of these ...
But yeah, if the ABTS just causes the target to abort processing of the 
command _without_ sending a status back that makes sense.

>> And how is one expected to handle the case where the TMF _failed_ on the
>> target?
> 	Doesn't the current path eventually just end up doing the lun reset? Whats
> wrong with that, stop all the IO, let the existing commands complete or
> timeout then hit the device with the big hammer?
>
> 	If the lun reset succeeds you can pretty much feel safe that everything is
> aborted. That is assuming you get the correct return from the
> bus_device_reset(). It is potentially possible for the lun reset to be
> rejected, and in the case of some of the drivers return success anyway
> (consider lpfc_sli_issue_iocb_wait). I bet I could corrupt some disk data like
> that (format unit, abts reject, lun reset reject, continue operation with
> format unit still running on the target).
>
Which is more or less the intend of the question.
We need to insure to get a correct TMF status back, otherwise we'll make 
the wrong assumptions and end up getting double completions.

>
>> I would rather prefer to have the LLDD terminate the command; this way we
>> at least have a chance of getting a decent status back ...
>
> 	Well, you might be able to simplify a few things in scsi_* if
> eh_abort_handler() were more like the windows async cancel IO IRP and didn't
> block. It simply marks the IO as being canceled and then the completion
> eventually runs as normal within the devloss timeout. You probably could abort
> right out of a function in front of scsi_times_out() and avoid the whole error
> handling queues/blocking/task/etc. Then you use the abort accept/failure out
> of scsi_done to either queue the command into the current scsi_times_out
> logic, or you complete it with a timeout.
>
> 	Pretty clean, except for the fact your going to have to rewrite a lot of
> stuff in the LLDs to assure that they get the abort status returned within a
> reasonable amount of time. OTOH, the cancel IO model in windows is one of the
> things people writing IO drivers on that platform despise.
>
Yes, that's pretty much what I've figured, too.
Design-wise it is pretty appealing, having the abort itself run like a 
normal command and using the normal command handling for that.
However, then you pretty soon end up with a tangle as you actually have 
_two_ (or more, in the case of a LUN reset) commands to worry about.
Which might terminate at any time.
Things become very nasty very fast here.

So the main worry here was in fact the question whether we get any 
status back for an aborted command. If we don't (either by design or due 
to firmware interaction) that's sorted and we can stick to the current 
eh_abort_handler() design.

Thanks for the clarification.

Cheers,

Hannes

