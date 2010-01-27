From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 0/6] Work In Progress: FC sysfs
Date: Wed, 27 Jan 2010 15:24:15 -0800
Message-ID: <20100127232415.10343.86703.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52653 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab0A0XYQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2010 18:24:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.smart@emulex.com
Cc: giridhar.malavali@qlogic.com

This series is the beginning of a FC sysfs reorganization. The new layout
as suggested in this post, http://marc.info/?l=linux-scsi&m=124404278711785&w=2,
creates more sysfs objects to expose FC session information and
decouples the FC sysfs layout from SCSI until FC attaches to the SCSI
mid-layer.

The first four patches in this series are just preparation patches
that have not been merged. They can mostly be ignored. The fifth patch
introduces FC sysfs and the last patch modifies libfc, libfcoe and fcoe
to use the new FC sysfs interface.

These patches move code out of scsi_transport_fc.[ch] and into individual
files for each of the new sysfs objects. Compilation creates a new
fc_sysfs.ko module. I'm not sure if this is a good overall approach, but
I wanted to make sure that I didn't overlook any relationships as I made
changes. This results in a patch that doesn't show a good progression of
changes, rather a big change combined with code moving from file(s) to
other file(s). This can be addressed when the patch series is further along
in development.

To review, it might be easier to apply the patches and look at
drivers/scsi/fc/ and include/scsi/fc.h.

Functionally both real and NPIV port creation and deletion is working under
libfc/fcoe, with most if not all attributes showing correct values. I did
not spend much time on error handling or cleanliness, these are things
that I'd prefer to address once I'm further along.

These patches create the following sysfs layout-

Device tree:
/sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/fcpinit/host6/

LDM tree:
/sys/class/fcport/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/fcpinit/host6/

Each object has redistributed attributes:
#ls /sys/devices/virtual/net/eth3.101/fcport1/
active_fc4s  device  fcfport_2001000deca31e81  maxframe_size  power  serial_number  speed  subsystem  supported_classes  supported_fc4s  supported_speeds  uevent

# ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/
fcfabric_0  power  uevent

# ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/
fabric_name  fcvport_0  fcvport_1  max_npiv_vports  npiv_vports_inuse  power  uevent  vport_create  vport_delete

# ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/
host6  node_name  port_id  port_name  port_type  power  roles  symbolic_name  uevent  vport_last_state  vport_state  vport_type

# ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/
bsg  fcpinit  power  rport-6:0-0  rport-6:0-2  scsi_host  subsystem  uevent

# ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/fcpinit/
host6

# ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_0/host6/fcpinit/host6/
device  issue_lip  port_state  power  statistics  subsystem  tgtid_bind_type  uevent

VN_Ports ports show up just like N_Ports: (notice fcvport_1, not fcvport_0)
# ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/fcvport_1/
host7  node_name  port_id  port_name  port_type  power  roles  symbolic_name  uevent  vport_last_state  vport_state  vport_type


My open questions are:

1) How is the FC4 choice made?

   If FC sysfs allows an FC HBA to support other FC4 types, then how and
   when is the selection made? It seems that this decision would either
   need to be hard-coded or provided by the user. fcoe.ko requires user
   action to start a connection. It would be easy for us to also require
   a FC4 selection (maybe it defaults to SCSI-FCP (init)). HW adapters
   generally FLOGI on link up and do not require user interaction. How
   would this decision be made?

2) How do I reorder fc_host and scsi_host?

   Previously the fc_host is attached as a child of the scsi_host. The
   new layout has the scsi_host as a child of fcpinit. These patches
   have the fcpinit object created by the scsi transport and attribute
   container code. I'm not sure if/how to re-order these objects, it
   might require changes to the scsi transport and AC code.

3) What do I do about remote_ports?

   Currently the remote_ports are created by the scsi transport and AC
   code which places them as children of the fc_host. I believe this
   problem is essentially the same as #2, but with remote ports instead
   of the fc_host.

4) What should the FC sysfs objects be?

   Should they be class objects? I just made them of type 'struct device'
   to keep them as flexible as possible. I made the fcport a class object
   so that it could be anchored at /sys/class/.

   (last minute note: I just saw in the link referenced above, that the
    objects were referred to as classes. I missed that initiatlly, is
    there no concern about adding too many classes to /sys?)

5) How should the FC sysfs objects be named?

   Currently I have two styles. The fcport, fcfabric and fcvport objects
   are all enumerated. The fcfport is given a name from its WWPN/WWNN.
   It's pretty ugly as is, and the naming needs more consideration.

   I don't really like N_Ports being referred to as vports in sysfs either.

6) What about complicated relationships between objects?

   Right now this layout cannot elegantly support multiple physical
   ports connected to the same F_Port. Each port will have it's own
   sysfs directory tree and the two trees will not converge even if
   they share the same F_Port/fabric/etc... vports under a physical
   port will show up under the physical port's sysfs directory tree.

7) Should vport_create/destroy be under fcfabric or fcport?

   I've currently put the vport_create/destroy attributes under the
   fcfabric. I think this is fine for now, since there are no
   complicated object relationships being presented. There's a one to
   one relationship between a fcport and a fcfabric so it's fairly
   easy to go back to the fcport, which is needed to be passed to the
   LLD so it can create a vport. If there were more than one fcport
   per fcfabric it would complicate this. Should the
   vport_create/destroy be moved to be attributes of the fcport instead
   to avoid a potential lookup if things get more complicated in the
   future?

8) Should the fcfport and fcfabric be consolidated?

   The fcfport doesn't show much other than its name. The fcfabric
   doesn't have many attributes either. Most of its attributes are
   vport related. I could see adding some FIP information to the
   fcfport, but I'm not sure we need two objects here, especially if
   the vport attributes need to be moved to the fcport.

9) Is this change worth all of the changes that will need to happen?

   This is probably the most difficult question. I view this change as
   positive overall, but it's very heavy lifting. Not only does the
   FC transport need an overhaul, but it looks like the scsi transport
   and AC code might need some additions. Every HBA will need to be
   modified and every HBA's HBAAPI vendor library will need to change
   too. (I hope this would be a catalyst to move to an OS library that
   everyone shares)

   I'd like to hear other opinions about this because this really is
   going to be something that all HBAs will need to be involved in.

---

Robert Love (6):
      libfc, libfcoe, fcoe: Make use of FC sysfs
      fc_sysfs: Rearrange the FC transport to create FC sysfs
      libfc: Move the port_id into lport
      fcoe: move link speed checking into its own routine
      libfc: Remove extra pointer check
      libfc: Remove unused fc_get_host_port_type


 drivers/scsi/Kconfig             |    6 
 drivers/scsi/Makefile            |    1 
 drivers/scsi/fc/Makefile         |    8 
 drivers/scsi/fc/fc_sysfs.h       |   35 +
 drivers/scsi/fc/fcfabric.c       |  441 ++++++++++++
 drivers/scsi/fc/fcfport.c        |   73 ++
 drivers/scsi/fc/fcpinit.c        |   66 ++
 drivers/scsi/fc/fcport.c         |  217 ++++++
 drivers/scsi/fc/fcsysfs.c        |   41 +
 drivers/scsi/fc/fcvport.c        |  485 +++++++++++++
 drivers/scsi/fcoe/fcoe.c         |  558 ++++++++++-----
 drivers/scsi/fcoe/libfcoe.c      |   55 +
 drivers/scsi/libfc/fc_disc.c     |    6 
 drivers/scsi/libfc/fc_elsct.c    |    2 
 drivers/scsi/libfc/fc_exch.c     |    4 
 drivers/scsi/libfc/fc_fcp.c      |  145 ++--
 drivers/scsi/libfc/fc_libfc.h    |   32 -
 drivers/scsi/libfc/fc_lport.c    |  208 +++---
 drivers/scsi/libfc/fc_npiv.c     |   56 +-
 drivers/scsi/libfc/fc_rport.c    |   12 
 drivers/scsi/scsi_transport_fc.c | 1411 ++++++--------------------------------
 include/scsi/fc.h                |  460 ++++++++++++
 include/scsi/fc_encode.h         |   48 +
 include/scsi/libfc.h             |  130 ++--
 include/scsi/scsi_transport_fc.h |  329 ++-------
 25 files changed, 2893 insertions(+), 1936 deletions(-)
 create mode 100644 drivers/scsi/fc/Makefile
 create mode 100644 drivers/scsi/fc/fc_sysfs.h
 create mode 100644 drivers/scsi/fc/fcfabric.c
 create mode 100644 drivers/scsi/fc/fcfport.c
 create mode 100644 drivers/scsi/fc/fcpinit.c
 create mode 100644 drivers/scsi/fc/fcport.c
 create mode 100644 drivers/scsi/fc/fcsysfs.c
 create mode 100644 drivers/scsi/fc/fcvport.c
 create mode 100644 include/scsi/fc.h

-- 
//Rob
