From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Mon, 31 Mar 2014 09:22:31 +0200
Message-ID: <533917B7.4010808@suse.de>
References: <Pine.LNX.4.44L0.1403281438250.862-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaCaHWc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 03:22:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.1403281438250.862-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On 03/28/2014 08:29 PM, Alan Stern wrote:
> On Fri, 28 Mar 2014, James Bottomley wrote:
>=20
>> This is a set of three patches we agreed to a while ago to eliminate=
 a
>> USB deadlock.  I did rewrite the first patch, if it could be reviewe=
d
>> and tested.
>=20
> I tested all three patches under the same conditions as before, and=20
> they all worked correctly.
>=20
> In the revised patch 1, the meaning of SCSI_EH_ABORT_SCHEDULED isn't
> entirely clear.  This boils down to two questions, which I don't=20
> know the answers to:
>=20
> 	What should happen in scmd_eh_abort_handler() if
> 	scsi_host_eh_past_deadline() returns true and thereby
> 	prevents scsi_try_to_abort_cmd() from being called?
> 	The flag wouldn't get cleared then.
>=20
Ah. Correct. But that's due to the first patch being incorrect.
Cf my response to the original first patch.

> 	What should happen if some other pathway manages to call
> 	scsi_try_to_abort_cmd() while scmd->abort_work is still
> 	sitting on the work queue?  The command would be aborted
> 	and the flag would be cleared, but the queued work would
> 	remain.  Can this ever happen?
>=20
Not that I could see.
A command abort is only ever triggered by the request timeout from
the block layer. And the timer is _not_ rearmed once the timeout
function (here: scsi_times_out()) is called.
Hence I fail to see how it can be called concurrently.

> Maybe scmd_eh_abort_handler() should check the flag before doing
> anything.  Is there any sort of sychronization to prevent the same
> incarnation of a command from being aborted twice (or by two differen=
t
> threads at the same time)?  If there is, it isn't obvious.
>=20
See above. scsi_times_out() will only ever called once.
What can happen, though, is that _theoretically_ the LLDD might
decide to call ->done() on a timed out command when
scsi_eh_abort_handler() is still pending.


> (Also, what's going on at the start of scsi_abort_command()?  Contrar=
y
> to what one might expect, the first part of the function _cancels_ a
> scheduled abort.  And it does so without clearing the
> SCSI_EH_ABORT_SCHEDULED flag.)
>=20
The original idea was this:

SCSI_EH_ABORT_SCHEDULED is sticky _per command_.
Point is, any command abort is only ever send for a timed-out
command. And the main problem for a timed-out command is that we
simply _do not_ know what happened for that command. So _if_ a
command timed out, _and_ we've send an abort, _and_ the command
times out _again_ we'll be running into an endless loop between
timeout and aborting, and never returning the command at all.

So to prevent this we should set a marker on that command telling it
to _not_ try to abort the command again.
Which is what 'SCSI_EH_ABORT_SCHEDULED' was meant for:

- A command times out, sets 'SCSI_EH_ABORT_SCHEDULED'
- abort _succeeds_
- The same command times out a second time, notifies
  that SCSI_EH_ABORT_SCHEDULED is set, and doesn't call
  scsi_eh_abort_command() but rather escalates directly.

_However_, I do feel that we've gotten the wrong track with all of
this. In you original mail you stated:

> Basically, usb-storage deadlocks when the SCSI error handler
> invokes the eh_device_reset_handler callback while a command
> is running.  The command has timed out and will never complete
> normally, because the device's firmware has crashed.  But
> usb-storage's device-reset routine waits for the current command
> to finish, which brings everything to a standstill.

Question now to you as the USB god:

A command abort is only _ever_ send after a command timeout.
And the main idea of the command abort is to remove any context
the LLDD or the target might have. So by the time the command
abort returns SUCCESS we _expect_ the firmware to have cleared that
command. If for some reason the firmware isn't capable of doing so,
it should return FAILED.

So:
- Has the command timeout fired?
- If so, why hasn't it returned FAILED?
- If it had returned SUCCESS, why did the device_reset_handler
  wait for the command to complete?

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
