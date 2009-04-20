From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] LSF: Multipathing and path checking question
Date: Mon, 20 Apr 2009 09:59:33 +0200
Message-ID: <49EC2B65.1050508@suse.de>
References: <49E7B845.70400@cs.wisc.edu> <49E834CD.1090306@suse.de> <49E89866.50205@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbZDTH7f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 03:59:35 -0400
In-Reply-To: <49E89866.50205@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Mike,

Mike Christie wrote:
> Hannes Reinecke wrote:
>>
>> FC Transport already maintains an attribute for the path state, and =
even
>> sends netlink events if and when this attribute changes. For iSCSI I=
 have
>=20
> Are you referring to fc_host_post_event? Is the same thing we talked
> about last year, where you wanted events? Is this in multipath tools =
now
> or just in the SLES ones?
>=20
Yep, that's the thing.

> For something like FCH_EVT_LINKDOWN, are you going to fail the path a=
t
> that time or when would the multipath path be marked failed?
>=20
This is just a notification that the path has gone down. Fast fail / de=
v_loss_tmo
still applies, ie that path won't get switched then.

>=20
>=20
>> to defer to your superior knowledge; of course it would be easiest i=
f
>> iSCSI could send out the very same message FC does.
>=20
> We can do something like fc_host_event_code for iscsi.
>=20
Oh, that'll be grand.

> Question on what you are needing:
>=20
> Do you mean you want to make fc_host_event_code more generic (there a=
re
> some FC specific ones like lip_reset)? Put them in scsi-ml and send f=
rom
> a new netlink group that just sends these events?
>=20
> Or do you just want something similar from iscsi? iscsi will hook int=
o
> the iscsi netlink code using the scsi_netlink.c and then send a
> ISCSIH_EVT_LINKUP, ISCSIH_EVT, LINKDOWN, etc.
>=20
Well, actually, I don't care. It's just if we were to go with the
proposal we'll have to fix up all transports to present the path state
to userspace; preferably with both, netlink events and sysfs attributes=
=2E

The actual implementation might well be transport-specific.

> What do the FCH_EVT_PORT_* ones means?
>=20
=46C stuff methinks. James S. should know better.

>=20
>=20
>>
>> Idea was to modify the state machine so that fast_fail_io_tmo is
>> being made mandatory, which transitions the sdev into an intermediat=
e
>> state 'DISABLED' and sends out a netlink message.
>=20
>=20
> Above when you said, "No, I already do this for FC (should be checkin=
g
> the replacement_timeout, too ...)", did you mean that you have mulitp=
ath
> tools always setting fast io fail now?
>=20
Yes, quite so. Look at
git://git.kernel.org/pub/scm/linux/kernel/git/hare/multipath-tools
branch sles11
for details.

> For iscsi the replacement_timeout is always set already. If from
> multipath tools you are going to add some code so multipth sets this =
I
> can make iscsi allow the replacement_timeout to be set from sysfs lik=
e
> is done for FC's fast io fail.
>=20
Oh, that would be awesome. Currently I think we have a mismatch / race
condition between iSCSI and multipathing, where ERL in iSCSI actually
counteracts multipathing. But I'll be investigating that one shortly.

>=20
>=20
>>
>> sdev state:   RUNNING <-> BLOCKED <-> DISABLED -> CANCEL
>> mpath state:  path up <-> <stall> <-> path down -> remove from map
>>
>> This will allow us to switch paths early, ie when it moves into
>> 'DISABLED' state. But the path structure themselves are still alive,
>> so when a path comes back between 'DISABLED' and 'CANCEL' we won't
>> have an issue reconnecting it. And we could even allow to set a
>> dev_loss_tmo to infinity thereby simulating the 'old' behaviour.
>>
>> However, this proposal didn't go through.
>=20
> You got my hopes up for a solution in the the long explanation, then =
you
> destroyed them :)
>=20
Yes, same here. I really thought this to be a sensible proposal, but
then the discussion veered off into queue_if_no_path handling.

>=20
> Was the reason people did not like this because of the scsi device
> lifetime issue?
>=20
>=20
> I think we still want someone to set the fast io fail tmo for users w=
hen
> multipath is being used, because we want IO out of the queues and
> drivers and sent to the multipath layer before dev_loss_tmo if
> dev_loss_tmo is still going to be a lot longer. fast io fail tmo is
> usually less than 10 or 5 and for dev_loss_tmo seems like we still ha=
ve
> user setting that to minutes.
>=20
Exactly. Point here is that with the current implementation we basicall=
y
_cannot_ return 'path down' anymore, as the path is either blocked (dur=
ing
which time all I/O got stalled) or failed completely (ie in state 'CANC=
EL').
Which is a bit of a detriment and we actually run into quite some conte=
ntion
when the path is removed, as we have to kill all I/O, fail over paths, =
remove
stale paths, update device-mapper tables etc.

When decoupling this by having the midlayer always return 'DID_TRANSPOR=
T_DISRUPTED'
after fast_fail_io we would be able to kill all I/O and switch paths gr=
acefully.
Path removal and device-mapper table update would then be done later on=
e when
dev_loss_tmo triggers.


>=20
> Can't the transport layers just send two events?
> 1. On the initial link down when the port/session is blocked.
> 2. When there fast io fail tmos fire.
>=20
Yes, that would be a good start.

> Today, instead of #2, the Red Hat multipath tools guy and I were talk=
ing
> about doing a probe with SG_IO. For example we would send down a path
> tester IO and then wait for it to be failed with DID_TRANSPORT_FAILFA=
ST.
>=20
No. this is exactly what you cannot do. SG_IO will be stalled when the
sdev is BLOCKED and will only return a result _after_ the sdev transiti=
ons
_out_ of the BLOCKED state.
Translated to FC this means that whenever dev_loss_tmo is _active_ (!)
no I/O will be send out neither any I/O result will be returned to user=
land.

Hence using SG_IO for path checker is a bad idea here.
Hence my proposal.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
