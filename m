From: Robert Love <robert.w.love@intel.com>
Subject: Re: [RFC PATCH 0/6] Work In Progress: FC sysfs
Date: Fri, 29 Jan 2010 11:31:06 -0800
Message-ID: <1264793466.11363.120.camel@fritz>
References: <20100127232415.10343.86703.stgit@localhost.localdomain>
	 <4B61B4DB.1020207@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13841 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab0A2Tb1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2010 14:31:27 -0500
In-Reply-To: <4B61B4DB.1020207@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.smart@emulex.com" <james.smart@emulex.com>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>

On Thu, 2010-01-28 at 08:01 -0800, Hannes Reinecke wrote:
> Robert Love wrote:
> > This series is the beginning of a FC sysfs reorganization. The new layout
> > as suggested in this post, http://marc.info/?l=linux-scsi&m=124404278711785&w=2,
> > creates more sysfs objects to expose FC session information and
> > decouples the FC sysfs layout from SCSI until FC attaches to the SCSI
> > mid-layer.
> > 
> > The first four patches in this series are just preparation patches
> > that have not been merged. They can mostly be ignored. The fifth patch
> > introduces FC sysfs and the last patch modifies libfc, libfcoe and fcoe
> > to use the new FC sysfs interface.
> > 
> > These patches move code out of scsi_transport_fc.[ch] and into individual
> > files for each of the new sysfs objects. Compilation creates a new
> > fc_sysfs.ko module. I'm not sure if this is a good overall approach, but
> > I wanted to make sure that I didn't overlook any relationships as I made
> > changes. This results in a patch that doesn't show a good progression of
> > changes, rather a big change combined with code moving from file(s) to
> > other file(s). This can be addressed when the patch series is further along
> > in development.
> > 
> > To review, it might be easier to apply the patches and look at
> > drivers/scsi/fc/ and include/scsi/fc.h.
> > 
> > Functionally both real and NPIV port creation and deletion is working under
> > libfc/fcoe, with most if not all attributes showing correct values. I did
> > not spend much time on error handling or cleanliness, these are things
> > that I'd prefer to address once I'm further along.
> > 
> > These patches create the following sysfs layout-
> > 
> > Device tree:
> > /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/fcpinit/host6/
> > 
> > LDM tree:
> > /sys/class/fcport/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/fcpinit/host6/
> > 
> > Each object has redistributed attributes:
> > #ls /sys/devices/virtual/net/eth3.101/fcport1/
> > active_fc4s  device  fcfport_2001000deca31e81  maxframe_size  power  serial_number  speed  subsystem  supported_classes  supported_fc4s  supported_speeds  uevent
> > 
> > # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/
> > fcfabric_0  power  uevent
> > 
> 
> Please don't.
> Do _not_ use physical names in the path names; rather the logical names should be used.
> So something like
> /sys/devices/virtual/net/eth3.101/fcport1/fcfport-1:0/
> 
> would be preferred.
> 

Did you put "1:0" to indicate that it's the 0th fcfport on the 1st
fcport? Isn't the the relationship of the fcfport0 being a child of the
fcport1 enough?

It seems to be redundant to me, but I might be missing something.

> > # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/
> > fabric_name  fcvport_0  fcvport_1  max_npiv_vports  npiv_vports_inuse  power  uevent  vport_create  vport_delete
> > 
> Consistent numbering. Either use '_' as a separator always or for none.
> This mix-up doesn't make sense.
> 
> And, why doesn't the fcfport doesn't show up under the fabric?
> One would assume that the fcfport is part of the fabric, too.
> 
> And what about the remote ports? Do they not participate in the fabric?
> 
> If the 'fcfabric' element is _not_ the actual fabric I would get rid of it altogether as it'll only serve to confuse
> the users. Like just has been happened with me :-)
> 
Yeah, they should be under the fcfabric. This work is just incomplete in
that area.

> > # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/
> > host6  node_name  port_id  port_name  port_type  power  roles  symbolic_name  uevent  vport_last_state  vport_state  vport_type
> > 
> > # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/
> > bsg  fcpinit  power  rport-6:0-0  rport-6:0-2  scsi_host  subsystem  uevent
> > 
> See above. Why are the remote ports grouped under the 'host', and not under the fabric?
> 
> > # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/fcpinit/
> > host6
> > 
> fcpinit? What's this for?
> 
It had been suggested. I imagine having a fcptarg that hooks into stgt
at some point.

I don't have any attributes in mind for the fcpinit or fcptarg right
now. Also, I'm still allocating libfc's fcp private data with the
scsi_host, so fcpinit is pretty hollow right now. I might just leave it
as a placeholder for the short-term.

Whether fcpinit should exist or not is related to the open item below
regarding the FC4 decision. If there is eventually a fcpinit and fcptarg
there would need to be a mechanism to choose between the two.

> > # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/fcpinit/host6/
> > device  issue_lip  port_state  power  statistics  subsystem  tgtid_bind_type  uevent
> > 
> > VN_Ports ports show up just like N_Ports: (notice fcvport_1, not fcvport_0)
> > # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_1/
> > host7  node_name  port_id  port_name  port_type  power  roles  symbolic_name  uevent  vport_last_state  vport_state  vport_type
> > 
> 
> > 
> > My open questions are:
> > 
> > 1) How is the FC4 choice made?
> > 
> >    If FC sysfs allows an FC HBA to support other FC4 types, then how and
> >    when is the selection made? It seems that this decision would either
> >    need to be hard-coded or provided by the user. fcoe.ko requires user
> >    action to start a connection. It would be easy for us to also require
> >    a FC4 selection (maybe it defaults to SCSI-FCP (init)). HW adapters
> >    generally FLOGI on link up and do not require user interaction. How
> >    would this decision be made?
> > 
> I would consider FCP only currently. Other types would be handled by
> different subsystems anyway (ie net), which again have a totally different
> sysfs layout.
> 
> > 2) How do I reorder fc_host and scsi_host?
> > 
> >    Previously the fc_host is attached as a child of the scsi_host. The
> >    new layout has the scsi_host as a child of fcpinit. These patches
> >    have the fcpinit object created by the scsi transport and attribute
> >    container code. I'm not sure if/how to re-order these objects, it
> >    might require changes to the scsi transport and AC code.
> > 
> Easiest would be to use the same counter, so that a fc_host preallocates
> a scsi_host id, too. Not sure if that's possible, though.
> Alternatively you could create a scsi_host, but _not_ register it with
> sysfs. This way you would have a number preallocated, too.
> And when restricting this layout to FCP we will allocate a scsi_host
> anyway...
> 
I'll play around with this. Thanks for the suggestions.

> > 3) What do I do about remote_ports?
> > 
> >    Currently the remote_ports are created by the scsi transport and AC
> >    code which places them as children of the fc_host. I believe this
> >    problem is essentially the same as #2, but with remote ports instead
> >    of the fc_host.
> > 
> We should try to avoid separate directories for objects which ultimatively
> map onto the same device. IE it should be possible to gather _all_
> information from walking up the devpath only, without having to recurse
> on other side directories.

Sounds good.

> This way we can match on the various attributes from udev rules; with
> separate directories this is impossible without a helper script.
> 
> I'm happy to mail my 'path_id' script around, just to get you an
> idea where you end up with the separate directory approach :-)
> 
> > 4) What should the FC sysfs objects be?
> > 
> >    Should they be class objects? I just made them of type 'struct device'
> >    to keep them as flexible as possible. I made the fcport a class object
> >    so that it could be anchored at /sys/class/.
> > 
> >    (last minute note: I just saw in the link referenced above, that the
> >     objects were referred to as classes. I missed that initiatlly, is
> >     there no concern about adding too many classes to /sys?)
> > 
> The 'class' and 'device' distinction is basically gone with the newer
> sysfs code.
> The elements in 'class' are just pointers into the 'device' structure.
> 
> > 5) How should the FC sysfs objects be named?
> > 
> >    Currently I have two styles. The fcport, fcfabric and fcvport objects
> >    are all enumerated. The fcfport is given a name from its WWPN/WWNN.
> >    It's pretty ugly as is, and the naming needs more consideration.
> > 
> As mentioned above, yes, it is. Please use logical names.
> 
> >    I don't really like N_Ports being referred to as vports in sysfs either.
> > 
> > 6) What about complicated relationships between objects?
> > 
> >    Right now this layout cannot elegantly support multiple physical
> >    ports connected to the same F_Port. Each port will have it's own
> >    sysfs directory tree and the two trees will not converge even if
> >    they share the same F_Port/fabric/etc... vports under a physical
> >    port will show up under the physical port's sysfs directory tree.
> > 
> > 7) Should vport_create/destroy be under fcfabric or fcport?
> > 
> >    I've currently put the vport_create/destroy attributes under the
> >    fcfabric. I think this is fine for now, since there are no
> >    complicated object relationships being presented. There's a one to
> >    one relationship between a fcport and a fcfabric so it's fairly
> >    easy to go back to the fcport, which is needed to be passed to the
> >    LLD so it can create a vport. If there were more than one fcport
> >    per fcfabric it would complicate this. Should the
> >    vport_create/destroy be moved to be attributes of the fcport instead
> >    to avoid a potential lookup if things get more complicated in the
> >    future?
> > 
> Once the fcfabric is consolidated with fcfport they'll end up under
> fcport anyway :-)
> 
Yeah, consolidating these two should make getting to the fcport from the
fcfabric easier- just go to the parent.

However, I think #7 is just wrong. What's the patches do now is to
allocate the libfc per-instance data (the lport) with the vport (that
represents the N_Port). When the fcfabric is told to allocate a NPIV
port it just needs to look through its list of vports to find the N_Port
and pass it down to the LLD's vport_create function.

> > 8) Should the fcfport and fcfabric be consolidated?
> > 
> >    The fcfport doesn't show much other than its name. The fcfabric
> >    doesn't have many attributes either. Most of its attributes are
> >    vport related. I could see adding some FIP information to the
> >    fcfport, but I'm not sure we need two objects here, especially if
> >    the vport attributes need to be moved to the fcport.
> > 
> See above. Yes.
> 
> > 9) Is this change worth all of the changes that will need to happen?
> > 
> >    This is probably the most difficult question. I view this change as
> >    positive overall, but it's very heavy lifting. Not only does the
> >    FC transport need an overhaul, but it looks like the scsi transport
> >    and AC code might need some additions. Every HBA will need to be
> >    modified and every HBA's HBAAPI vendor library will need to change
> >    too. (I hope this would be a catalyst to move to an OS library that
> >    everyone shares)
> > 
> >    I'd like to hear other opinions about this because this really is
> >    going to be something that all HBAs will need to be involved in.
> > 
> I think it's quite a valid goal.
> 
Thanks for the comments Hannes.


