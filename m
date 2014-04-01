From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Tue, 01 Apr 2014 17:37:10 +0200
Message-ID: <533ADD26.1030300@suse.de>
References: <Pine.LNX.4.44L0.1403311816400.5031-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaDAPhM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Apr 2014 11:37:12 -0400
In-Reply-To: <Pine.LNX.4.44L0.1403311816400.5031-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On 04/01/2014 12:29 AM, Alan Stern wrote:
> On Mon, 31 Mar 2014, Hannes Reinecke wrote:
>=20
>>>> Ah. Correct. But that's due to the first patch being incorrect.
>>>> Cf my response to the original first patch.
>>>
>>> See my response to your response.  :-)
>>>
>> Okay, So I probably should refrain from issueing a response to
>> your response to my response lest infinite recursion happens :-)
>=20
> Indeed.
>=20
>>>>> 	What should happen if some other pathway manages to call
>>>>> 	scsi_try_to_abort_cmd() while scmd->abort_work is still
>>>>> 	sitting on the work queue?  The command would be aborted
>>>>> 	and the flag would be cleared, but the queued work would
>>>>> 	remain.  Can this ever happen?
>>>>>
>>>> Not that I could see.
>>>> A command abort is only ever triggered by the request timeout from
>>>> the block layer. And the timer is _not_ rearmed once the timeout
>>>> function (here: scsi_times_out()) is called.
>>>> Hence I fail to see how it can be called concurrently.
>>>
>>> scsi_try_to_abort_cmd() is also called (via a different pathway) wh=
en a=20
>>> command sent by the error handler itself times out.  I haven't trac=
ed=20
>>> through all the different paths to make sure none of them can run=20
>>> concurrently.  But I'm willing to take your word for it.
>>>
>> Yes, but that's not calling scsi_abort_command(), but rather invokes
>> scsi_abort_eh_cmnd().
>=20
> Sure.  But either way, we end up in scsi_try_to_abort_cmd(), which
> calls the LLDD's abort handler.  Thus leading to the possibility of
> aborting the same command more than once.
>=20
>>>> The original idea was this:
>>>>
>>>> SCSI_EH_ABORT_SCHEDULED is sticky _per command_.
>>>> Point is, any command abort is only ever send for a timed-out
>>>> command. And the main problem for a timed-out command is that we
>>>> simply _do not_ know what happened for that command. So _if_ a
>>>> command timed out, _and_ we've send an abort, _and_ the command
>>>> times out _again_ we'll be running into an endless loop between
>>>> timeout and aborting, and never returning the command at all.
>>>>
>>>> So to prevent this we should set a marker on that command telling =
it
>>>> to _not_ try to abort the command again.
>>>
>>> I disagree.  We _have_ to abort the command again -- how else can w=
e
>>> stop a running command?  To prevent the loop you described, we shou=
ld
>>> avoid _retrying_ the command after it is aborted the second time.
>>>
>> The actual question is whether it's worth aborting the same command
>> a second time.
>> In principle any reset (like LUN reset etc) should clear the
>> command, too.
>> And the EH abort functionality is geared around this.
>> If, for some reason, the transport layer / device driver
>> requires a command abort to be send then sure, we need
>> to accommodate for that.
>=20
> As James mentioned, with USB a reset does not abort a running command=
=2E =20
> Instead it waits for the command to finish.  (However, this could be
> changed in usb-storage, if required.)
>=20
>> As said, yes, in principle you are right. We should be aborting the
>> command a second time, _and then_ starting the escalation.
>>
>> So if the above reasoning is okay then this patch should be doing
>> the trick:
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 771c16b..0e72374 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -189,6 +189,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>>                 /*
>>                  * Retry after abort failed, escalate to next level.
>>                  */
>> +               scmd->eh_eflags &=3D ~SCSI_EH_ABORT_SCHEDULED;
>>                 SCSI_LOG_ERROR_RECOVERY(3,
>>                         scmd_printk(KERN_INFO, scmd,
>>                                     "scmd %p previous abort
>> failed\n", scmd));
>>
>> (Beware of line
>> breaks)
>>
>> Can you test with it?
>=20
> I don't understand.  This doesn't solve the fundamental problem (name=
ly=20
> that you escalate before aborting a running command).  All it does is=
=20
> clear the SCSI_EH_ABORT_SCHEDULED flag before escalating.
>=20
Which was precisely the point :-)

Hmm. The comment might've been clearer.

What this patch is _supposed_ to be doing is that it'll clear the
SCSI_EH_ABORT_SCHEDULED flag it it has been set.
Which means this will be the second time scsi_abort_command() has
been called for the same command.
IE the first abort went out, did its thing, but now the same command
has timed out again.

So this flag gets cleared, and scsi_abort_command() returns FAILED,
and _no_ asynchronous abort is being scheduled.
scsi_times_out() will then proceed to call scsi_eh_scmd_add().
But as we've cleared the SCSI_EH_ABORT_SCHEDULED flag
the SCSI_EH_CANCEL_CMD flag will continue to be set,
and the command will be aborted with the main SCSI EH routine.

It looks to me as if it should do what you desire, namely abort the
command asynchronously the first time, and invoking the SCSI EH the
second time.

Am I wrong?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
