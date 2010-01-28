From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 0/6] Work In Progress: FC sysfs
Date: Thu, 28 Jan 2010 17:01:31 +0100
Message-ID: <4B61B4DB.1020207@suse.de>
References: <20100127232415.10343.86703.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab0A1QBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2010 11:01:34 -0500
In-Reply-To: <20100127232415.10343.86703.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, giridhar.malavali@qlogic.com

Robert Love wrote:
> This series is the beginning of a FC sysfs reorganization. The new la=
yout
> as suggested in this post, http://marc.info/?l=3Dlinux-scsi&m=3D12440=
4278711785&w=3D2,
> creates more sysfs objects to expose FC session information and
> decouples the FC sysfs layout from SCSI until FC attaches to the SCSI
> mid-layer.
>=20
> The first four patches in this series are just preparation patches
> that have not been merged. They can mostly be ignored. The fifth patc=
h
> introduces FC sysfs and the last patch modifies libfc, libfcoe and fc=
oe
> to use the new FC sysfs interface.
>=20
> These patches move code out of scsi_transport_fc.[ch] and into indivi=
dual
> files for each of the new sysfs objects. Compilation creates a new
> fc_sysfs.ko module. I'm not sure if this is a good overall approach, =
but
> I wanted to make sure that I didn't overlook any relationships as I m=
ade
> changes. This results in a patch that doesn't show a good progression=
 of
> changes, rather a big change combined with code moving from file(s) t=
o
> other file(s). This can be addressed when the patch series is further=
 along
> in development.
>=20
> To review, it might be easier to apply the patches and look at
> drivers/scsi/fc/ and include/scsi/fc.h.
>=20
> Functionally both real and NPIV port creation and deletion is working=
 under
> libfc/fcoe, with most if not all attributes showing correct values. I=
 did
> not spend much time on error handling or cleanliness, these are thing=
s
> that I'd prefer to address once I'm further along.
>=20
> These patches create the following sysfs layout-
>=20
> Device tree:
> /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fc=
fabric_0/fcvport_0/host6/fcpinit/host6/
>=20
> LDM tree:
> /sys/class/fcport/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport=
_0/host6/fcpinit/host6/
>=20
> Each object has redistributed attributes:
> #ls /sys/devices/virtual/net/eth3.101/fcport1/
> active_fc4s  device  fcfport_2001000deca31e81  maxframe_size  power  =
serial_number  speed  subsystem  supported_classes  supported_fc4s  sup=
ported_speeds  uevent
>=20
> # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e=
81/
> fcfabric_0  power  uevent
>=20

Please don't.
Do _not_ use physical names in the path names; rather the logical names=
 should be used.
So something like
/sys/devices/virtual/net/eth3.101/fcport1/fcfport-1:0/

would be preferred.

> # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e=
81/fcfabric_0/
> fabric_name  fcvport_0  fcvport_1  max_npiv_vports  npiv_vports_inuse=
  power  uevent  vport_create  vport_delete
>=20
Consistent numbering. Either use '_' as a separator always or for none.
This mix-up doesn't make sense.

And, why doesn't the fcfport doesn't show up under the fabric?
One would assume that the fcfport is part of the fabric, too.

And what about the remote ports? Do they not participate in the fabric?

If the 'fcfabric' element is _not_ the actual fabric I would get rid of=
 it altogether as it'll only serve to confuse
the users. Like just has been happened with me :-)

> # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e=
81/fcfabric_0/fcvport_0/
> host6  node_name  port_id  port_name  port_type  power  roles  symbol=
ic_name  uevent  vport_last_state  vport_state  vport_type
>=20
> # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e=
81/fcfabric_0/fcvport_0/host6/
> bsg  fcpinit  power  rport-6:0-0  rport-6:0-2  scsi_host  subsystem  =
uevent
>=20
See above. Why are the remote ports grouped under the 'host', and not u=
nder the fabric?

> # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e=
81/fcfabric_0/fcvport_0/host6/fcpinit/
> host6
>=20
fcpinit? What's this for?

> # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e=
81/fcfabric_0/fcvport_0/host6/fcpinit/host6/
> device  issue_lip  port_state  power  statistics  subsystem  tgtid_bi=
nd_type  uevent
>=20
> VN_Ports ports show up just like N_Ports: (notice fcvport_1, not fcvp=
ort_0)
> # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e=
81/fcfabric_0/fcvport_1/
> host7  node_name  port_id  port_name  port_type  power  roles  symbol=
ic_name  uevent  vport_last_state  vport_state  vport_type
>=20

>=20
> My open questions are:
>=20
> 1) How is the FC4 choice made?
>=20
>    If FC sysfs allows an FC HBA to support other FC4 types, then how =
and
>    when is the selection made? It seems that this decision would eith=
er
>    need to be hard-coded or provided by the user. fcoe.ko requires us=
er
>    action to start a connection. It would be easy for us to also requ=
ire
>    a FC4 selection (maybe it defaults to SCSI-FCP (init)). HW adapter=
s
>    generally FLOGI on link up and do not require user interaction. Ho=
w
>    would this decision be made?
>=20
I would consider FCP only currently. Other types would be handled by
different subsystems anyway (ie net), which again have a totally differ=
ent
sysfs layout.

> 2) How do I reorder fc_host and scsi_host?
>=20
>    Previously the fc_host is attached as a child of the scsi_host. Th=
e
>    new layout has the scsi_host as a child of fcpinit. These patches
>    have the fcpinit object created by the scsi transport and attribut=
e
>    container code. I'm not sure if/how to re-order these objects, it
>    might require changes to the scsi transport and AC code.
>=20
Easiest would be to use the same counter, so that a fc_host preallocate=
s
a scsi_host id, too. Not sure if that's possible, though.
Alternatively you could create a scsi_host, but _not_ register it with
sysfs. This way you would have a number preallocated, too.
And when restricting this layout to FCP we will allocate a scsi_host
anyway...

> 3) What do I do about remote_ports?
>=20
>    Currently the remote_ports are created by the scsi transport and A=
C
>    code which places them as children of the fc_host. I believe this
>    problem is essentially the same as #2, but with remote ports inste=
ad
>    of the fc_host.
>=20
We should try to avoid separate directories for objects which ultimativ=
ely
map onto the same device. IE it should be possible to gather _all_
information from walking up the devpath only, without having to recurse
on other side directories.
This way we can match on the various attributes from udev rules; with
separate directories this is impossible without a helper script.

I'm happy to mail my 'path_id' script around, just to get you an
idea where you end up with the separate directory approach :-)

> 4) What should the FC sysfs objects be?
>=20
>    Should they be class objects? I just made them of type 'struct dev=
ice'
>    to keep them as flexible as possible. I made the fcport a class ob=
ject
>    so that it could be anchored at /sys/class/.
>=20
>    (last minute note: I just saw in the link referenced above, that t=
he
>     objects were referred to as classes. I missed that initiatlly, is
>     there no concern about adding too many classes to /sys?)
>=20
The 'class' and 'device' distinction is basically gone with the newer
sysfs code.
The elements in 'class' are just pointers into the 'device' structure.

> 5) How should the FC sysfs objects be named?
>=20
>    Currently I have two styles. The fcport, fcfabric and fcvport obje=
cts
>    are all enumerated. The fcfport is given a name from its WWPN/WWNN=
=2E
>    It's pretty ugly as is, and the naming needs more consideration.
>=20
As mentioned above, yes, it is. Please use logical names.

>    I don't really like N_Ports being referred to as vports in sysfs e=
ither.
>=20
> 6) What about complicated relationships between objects?
>=20
>    Right now this layout cannot elegantly support multiple physical
>    ports connected to the same F_Port. Each port will have it's own
>    sysfs directory tree and the two trees will not converge even if
>    they share the same F_Port/fabric/etc... vports under a physical
>    port will show up under the physical port's sysfs directory tree.
>=20
> 7) Should vport_create/destroy be under fcfabric or fcport?
>=20
>    I've currently put the vport_create/destroy attributes under the
>    fcfabric. I think this is fine for now, since there are no
>    complicated object relationships being presented. There's a one to
>    one relationship between a fcport and a fcfabric so it's fairly
>    easy to go back to the fcport, which is needed to be passed to the
>    LLD so it can create a vport. If there were more than one fcport
>    per fcfabric it would complicate this. Should the
>    vport_create/destroy be moved to be attributes of the fcport inste=
ad
>    to avoid a potential lookup if things get more complicated in the
>    future?
>=20
Once the fcfabric is consolidated with fcfport they'll end up under
fcport anyway :-)

> 8) Should the fcfport and fcfabric be consolidated?
>=20
>    The fcfport doesn't show much other than its name. The fcfabric
>    doesn't have many attributes either. Most of its attributes are
>    vport related. I could see adding some FIP information to the
>    fcfport, but I'm not sure we need two objects here, especially if
>    the vport attributes need to be moved to the fcport.
>=20
See above. Yes.

> 9) Is this change worth all of the changes that will need to happen?
>=20
>    This is probably the most difficult question. I view this change a=
s
>    positive overall, but it's very heavy lifting. Not only does the
>    FC transport need an overhaul, but it looks like the scsi transpor=
t
>    and AC code might need some additions. Every HBA will need to be
>    modified and every HBA's HBAAPI vendor library will need to change
>    too. (I hope this would be a catalyst to move to an OS library tha=
t
>    everyone shares)
>=20
>    I'd like to hear other opinions about this because this really is
>    going to be something that all HBAs will need to be involved in.
>=20
I think it's quite a valid goal.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
