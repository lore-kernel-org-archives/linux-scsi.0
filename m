From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Mon, 13 May 2013 17:03:01 +0200
Message-ID: <519100A5.2060509@suse.de>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain> <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com> <1368194460.3319.40.camel@localhost.localdomain> <CAC9+anK-E2pok_eU2EdZxgaBY7-68rbj19C7G4w5rhTmZB7vzw@mail.gmail.com> <518D55FA.4080302@suse.de> <CAC9+anKxnDBYh15uwQQoTUzGZkwUe6wuV=8wf6NUVsC4+_TUgw@mail.gmail.com> <51907E45.7010409@suse.de> <5190FB4E.4000900@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab3EMPDD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 11:03:03 -0400
In-Reply-To: <5190FB4E.4000900@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Baruch Even <baruch@ev-en.org>, emilne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

On 05/13/2013 04:40 PM, Jeremy Linton wrote:
> On 5/13/2013 12:46 AM, Hannes Reinecke wrote:
>=20
>> True. But and the end of the day, we _do_ want to recover the failed=
 LUN.
>> If we were to disable that faulty LUN and continue running with the =
others
>> we won't have a chance of _ever_ recovering that one LUN.
>=20
> 	I don't buy this. Especially for FC devices, the vast majority of er=
rors I see
> are related to zoning, SFP and cabling problems. Once one of those ha=
ppens you
> tend to get a lot of shotgun debugging, which injects all kinds of
> further errors.	None of these errors are fixed by the linux error rec=
overy paths.
>=20
> 	That said, if the admin fixes something, for FC/SAS (and potentially=
 others)
> you _WILL_ get notification that the device is online again.
>=20

Well, yes, of course.
Sadly, these kind of errors tend to be very erratic and very hard to
diagnose. There simply is no way telling that the error you've had
is due to a bad cable or bad SFP.
Bad zoning is easy; then the device is simply not reachable anymore.

So for error recovery we first have to assume that the error is
fixable. And then we have a standard way of trying to fix this error.
The problem we have is that we lose all information about the error
once it's 'fixed' (ie after eh is done). Which is the main problem
with bad cabling: we're running the same sequence all over again,
without ever figuring out 'hey, I've done this already'.

sd.c has some _very_ limited support for this. But trying to
generalise things here will be _hard_.

So yeah, I see your point. In fact, I've been bitten by this, too.
But the error scenarios I've seen are far to complex to have them
modelled into something re-usable.

>> SET when the link is down). So we basically _have_ to escalate it to=
 the
>> next level. Even though that will mean to stop I/O to other, hithert=
o
>> unaffected instances.
>=20
> 	And a single failure, turns into performance bubbles and further err=
ors on
> other devices. Particularly if the functional devices are stateful, a=
nd the
> error recovery mechanism isn't sufficiently intelligent about that st=
ate (see
> tape drives). Think about what happens when a marginal SFP on a targe=
t causes
> a device to repeatably drop off and reappear at some random point in =
the future.
>=20
>=20
> 	Anyway, It is possible to make a determination about the topology an=
d make
> decisions about the likely-hood of any given portion being at fault. =
=46or
> example, if one lun on a target has failed and the remainder continue=
 to work,
> then its unlikely that if abort and lun reset fail that anything high=
er up in
> the stack is going to succeed.
>=20
Which is why I suggested 'ABORT TASK SET' instead of 'LUN reset'.
That will be restricted to the I_T_L nexus, and leave the rest of
the LUN alone (or so one hopes).

> 	I feel pretty strongly, at that point your better off providing good
> diagnostics about the failure and expecting user interaction rather t=
han
> muddying the waters by causing other device interruptions. If the use=
r tries
> everything and determines that a HBA reset is the right choice, provi=
de that
> option, don't do it for them.
>=20
> 	If every device attached to the HBA fails then resetting the HBA is =
a valid
> choice, not before. Same for I_T.
>=20
Hmm. Really not sure.

Take the 'target not responding' case. (which is what triggered this
whole issue anyway). Say a target port went out to lunch and don't
respond to FC commands anymore.

With our current EH it'll take _ages_, but eventually the big hammer
hits (or the device comes back) and everything is back to normal again.
So LUN reset (or ABORT TASK SET) fails.
The other LUNs haven't reported an error. But how do you know
whether they are still okay? The other LUNs might simply be idle,
and no commands have been send to them.
So the state's still good. Do we reset the I_T nexus or not?

If we do, we would find that the entire rport doesn't respond, so
the devloss_tmo mechanism would trigger, and eventually the rport
will disappear and we're back on normal operation.

If we don't the LUN will be stuck forever, until someone actually
issues I/O to the other LUNs for that rport. And only when I/O is
issued to the _last_ LUN we'll decide to reset the I_T nexus.
Not a very appealing scenario.

And 'reset I_T nexus' should be a rather fast operation; with a bit
of luck the other rports wouldn't even notice.
I've had a prototype running which would just kick off the
dev_loss_tmo mechanism; that worked like a charm.
(Agreed, as James Smart indicated 'only by luck', but nevertheless)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
