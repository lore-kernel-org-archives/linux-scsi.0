From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Mon, 31 Mar 2014 16:37:34 +0200
Message-ID: <53397DAE.9010801@suse.de>
References: <Pine.LNX.4.44L0.1403310907150.11739-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbaCaOhg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 10:37:36 -0400
In-Reply-To: <Pine.LNX.4.44L0.1403310907150.11739-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On 03/31/2014 03:33 PM, Alan Stern wrote:
> On Mon, 31 Mar 2014, Hannes Reinecke wrote:
>=20
>> On 03/28/2014 08:29 PM, Alan Stern wrote:
>>> On Fri, 28 Mar 2014, James Bottomley wrote:
>>>
>>>> This is a set of three patches we agreed to a while ago to elimina=
te a
>>>> USB deadlock.  I did rewrite the first patch, if it could be revie=
wed
>>>> and tested.
>>>
>>> I tested all three patches under the same conditions as before, and=
=20
>>> they all worked correctly.
>>>
>>> In the revised patch 1, the meaning of SCSI_EH_ABORT_SCHEDULED isn'=
t
>>> entirely clear.  This boils down to two questions, which I don't=20
>>> know the answers to:
>>>
>>> 	What should happen in scmd_eh_abort_handler() if
>>> 	scsi_host_eh_past_deadline() returns true and thereby
>>> 	prevents scsi_try_to_abort_cmd() from being called?
>>> 	The flag wouldn't get cleared then.
>>>
>> Ah. Correct. But that's due to the first patch being incorrect.
>> Cf my response to the original first patch.
>=20
> See my response to your response.  :-)
>=20
Okay, So I probably should refrain from issueing a response to
your response to my response lest infinite recursion happens :-)

>>> 	What should happen if some other pathway manages to call
>>> 	scsi_try_to_abort_cmd() while scmd->abort_work is still
>>> 	sitting on the work queue?  The command would be aborted
>>> 	and the flag would be cleared, but the queued work would
>>> 	remain.  Can this ever happen?
>>>
>> Not that I could see.
>> A command abort is only ever triggered by the request timeout from
>> the block layer. And the timer is _not_ rearmed once the timeout
>> function (here: scsi_times_out()) is called.
>> Hence I fail to see how it can be called concurrently.
>=20
> scsi_try_to_abort_cmd() is also called (via a different pathway) when=
 a=20
> command sent by the error handler itself times out.  I haven't traced=
=20
> through all the different paths to make sure none of them can run=20
> concurrently.  But I'm willing to take your word for it.
>=20
Yes, but that's not calling scsi_abort_command(), but rather invokes
scsi_abort_eh_cmnd().

>>> Maybe scmd_eh_abort_handler() should check the flag before doing
>>> anything.  Is there any sort of sychronization to prevent the same
>>> incarnation of a command from being aborted twice (or by two differ=
ent
>>> threads at the same time)?  If there is, it isn't obvious.
>>>
>> See above. scsi_times_out() will only ever called once.
>> What can happen, though, is that _theoretically_ the LLDD might
>> decide to call ->done() on a timed out command when
>> scsi_eh_abort_handler() is still pending.
>=20
> That's okay.  We can expect the LLDD to have sufficient locking to
> handle that sort of thing without confusion (usb-storage does, for
> example).
>=20
>>> (Also, what's going on at the start of scsi_abort_command()?  Contr=
ary
>>> to what one might expect, the first part of the function _cancels_ =
a
>>> scheduled abort.  And it does so without clearing the
>>> SCSI_EH_ABORT_SCHEDULED flag.)
>>>
>> The original idea was this:
>>
>> SCSI_EH_ABORT_SCHEDULED is sticky _per command_.
>> Point is, any command abort is only ever send for a timed-out
>> command. And the main problem for a timed-out command is that we
>> simply _do not_ know what happened for that command. So _if_ a
>> command timed out, _and_ we've send an abort, _and_ the command
>> times out _again_ we'll be running into an endless loop between
>> timeout and aborting, and never returning the command at all.
>>
>> So to prevent this we should set a marker on that command telling it
>> to _not_ try to abort the command again.
>=20
> I disagree.  We _have_ to abort the command again -- how else can we
> stop a running command?  To prevent the loop you described, we should
> avoid _retrying_ the command after it is aborted the second time.
>=20
The actual question is whether it's worth aborting the same command
a second time.
In principle any reset (like LUN reset etc) should clear the
command, too.
And the EH abort functionality is geared around this.
If, for some reason, the transport layer / device driver
requires a command abort to be send then sure, we need
to accommodate for that.

>> Which is what 'SCSI_EH_ABORT_SCHEDULED' was meant for:
>>
>> - A command times out, sets 'SCSI_EH_ABORT_SCHEDULED'
>> - abort _succeeds_
>> - The same command times out a second time, notifies
>>   that SCSI_EH_ABORT_SCHEDULED is set, and doesn't call
>>   scsi_eh_abort_command() but rather escalates directly.
>=20
> The proper time to escalate is after the command is aborted again, no=
t
> while the command is still running.  The only situation where you mig=
ht
> want to escalate while a command is still running would be if you wer=
e
> unable to abort the command.
>=20
> (Hmmm, maybe that's not true for SCSI devices in general.  It is true=
=20
> for USB mass-storage, however.  Perhaps the reset handlers in=20
> usb-storage should be changed so that they will automatically abort a=
=20
> running command before starting the reset.)
>=20
As said, yes, in principle you are right. We should be aborting the
command a second time, _and then_ starting the escalation.

So if the above reasoning is okay then this patch should be doing
the trick:

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 771c16b..0e72374 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -189,6 +189,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
                /*
                 * Retry after abort failed, escalate to next level.
                 */
+               scmd->eh_eflags &=3D ~SCSI_EH_ABORT_SCHEDULED;
                SCSI_LOG_ERROR_RECOVERY(3,
                        scmd_printk(KERN_INFO, scmd,
                                    "scmd %p previous abort
failed\n", scmd));

(Beware of line
breaks)

Can you test with it?

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
