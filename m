From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] LSF: Multipathing and path checking question
Date: Fri, 17 Apr 2009 09:50:37 +0200
Message-ID: <49E834CD.1090306@suse.de>
References: <49E7B845.70400@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZDQHuk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2009 03:50:40 -0400
In-Reply-To: <49E7B845.70400@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Mike,

Mike Christie wrote:
> Hey,
>=20
> For this topic:
>=20
> -----------------------
> Next-Gen Multipathing
> ---------------------
> Dr. Hannes Reinecke
>=20
> ......
>=20
> Should path checkers use sd->state to check for errors or availabilit=
y?
> ----------------------
>=20
> What was decided?
>=20
> Could this problem be fixed or helped if multipath tools always sets =
the
> fast io fail tmo for FC or the replacement_timeout for iscsi?
>=20
No, I already do this for FC (should be checking the replacement_timeou=
t, too ...)

> If those are set then IO in the blocked queue and in the driver will =
get
> failed after fast io fail tmo/replacement_timeout seconds (driver has=
 to
> implement a terminate rport IO callback and only mptfc does not now).=
 So
> at this time, do we want to fail the path?
>=20
> Or are people thinking that we want to fail the path when the problem=
 is
> initially detected like when the LLD deletes the rport for fc for exa=
mple?
>=20
Well, the idea is the following:

The primary purpose of the path checkers is to check the availability o=
f
the paths (my, that was easy :-).

And the main problem we have with the path checkers is that they are us=
ing
actual SCSI commands to determine this, thereby incurring unrelated err=
ors
(Disk errors, delaying response due to blocked path behaviour or error =
handling
etc). So we have to invest quite a bit of logic to separate the 'true' =
path
condition from unrelated errors, simply because we're checking at the w=
rong
level; the path state is maintained by the transport layer, not by the
SCSI layer.

So the suggestion here is to check the transport layer for the path sta=
tes
and do away with the existing path_checker SG_IO mechanism.

The secondary use of the path checkers (determine inactive paths) will =
have
to be delegated to the priority callouts, which then have to arrange th=
e
paths correctly.

=46C Transport already maintains an attribute for the path state, and e=
ven
sends netlink events if and when this attribute changes. For iSCSI I ha=
ve
to defer to your superior knowledge; of course it would be easiest if
iSCSI could send out the very same message FC does.

>=20
>=20
> Also for this one:
> -----------------------
> How to communication device went away:
> 1) send event to udev (uses netlink)
> -----------------------
>=20
> Is this an event when dev_loss_tmo fires or when the LLD first detect=
s
> something like a link down (or any event it might block the rport for=
),
> or would it be for when the fast fail io tmo fires (when the fc class=
 is
> going to fail running IO and incoming IO), or would we have events fo=
r
> all of them?
>=20
Currently the event is sent when the device itself is removed from sysf=
s.
And only then can we actually update the path maps and (possibly) chang=
e
to another part. We cannot do anything when the path is blocked (ie whe=
n
dev_loss_tmo is active) as we require this interval to capture jitter o=
n
the line.

So we have this state diagram:

sdev state:   RUNNING  <-> BLOCKED -> CANCEL
mpath state:  path up  <-> <stall> -> path down / remove from map

Notice the '<stall>' here; we cannot check the path state when the
sdev is blocked as all I/O will be queued. And also note that we
now lump two different multipath path states together; a path down
is basically always followed immediately by a path remove event.

However, when all paths are down (and queue_if_no_path is active) we mi=
ght
run into a deadlock when a path comes back, as we might not have enough
memory to actually create the required structures.

Idea was to modify the state machine so that fast_fail_io_tmo is
being made mandatory, which transitions the sdev into an intermediate
state 'DISABLED' and sends out a netlink message.

sdev state:   RUNNING <-> BLOCKED <-> DISABLED -> CANCEL
mpath state:  path up <-> <stall> <-> path down -> remove from map

This will allow us to switch paths early, ie when it moves into
'DISABLED' state. But the path structure themselves are still alive,
so when a path comes back between 'DISABLED' and 'CANCEL' we won't
have an issue reconnecting it. And we could even allow to set a
dev_loss_tmo to infinity thereby simulating the 'old' behaviour.

However, this proposal didn't go through.

Instead it was proposed to do away with the unlimited queue_if_no_path
setting and _always_ have a timeout there, so that the machine is able
to recover after a certain period of time.

I still like my original proposal, though.

Maybe we can do the EU referendum thing and just ask again and again
until everyone becomes tired of it and just says 'yes' to get rid
of this issue ...

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
