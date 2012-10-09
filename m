From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v4 0/5] Add new fcoe_sysfs based control interfaces to
 libfcoe, bnx2fc and fcoe
Date: Tue, 09 Oct 2012 15:18:50 -0700
Message-ID: <20121009221850.11139.39902.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:2638 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab2JIWSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Oct 2012 18:18:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nhorman@redhat.com, bvanassche@acm.org, gregkh@linuxfoundation.org, cleech@redhat.com, bprakash@broadcom.com, devel@open-fcoe.org

v4:

@Neil:
	Policy is now:

	'mode' attribute:
	       input: "Fabric" "VN2VN" (case insensitive)
	       output: "Fabric" "VN2VN"

	'enabled' attribute:
	       input: "1" "0"
	       output: "1" "0"

@Mark:
	Initial patch now optimizes enum-to-string memory usage and
	string retreival

--

v3:

This series applies to the v3.6 kernel.

@Bart: Fixed bus_create_file -> bus_attrs
       Removed sscanf with non-NULL buffer, only checking for '1' or '0' now
       Removed unnecessary whitespace change

@Bhanu: Incorporated check in _bnx2fc_create (thanks for the code)

Additional changes: Added check for 'enabled' in reset in fcoe.c
	   	    Made mode strncmp case insensitive so user can
		    # echo "vn2vn" > /sys/.../ctlr_0/mode # or
		    # echo "VN2VN" > /sys/.../ctlr_0/mode # or even
		    # echo "FaBRiC" > /sys/.../ctlr_0/mode

--

v2:

The following series adds /sys/bus/fcoe based control interfaces to
libfcoe. A fcoe_sysfs infrastructure was added to the kernel a few
cycles ago, this series builds on that work. The patches deprecate
the old create, vn2vn_create, destroy, enable and disable interfaces
that exist in /sys/module/libfcoe/parameters/.

Another goal of this series is to change the initialization sequence for
a FCoE device. The result of this series is that interfaces created using
libfcoe.ko interfaces (i.e. fcoe.ko or bnx2fc.ko) will have the following
starting steps-

1) Create/alloc the FCoE Controller
   - Allocate kernel memory and create per-instance sysfs devices
   - The FCoE Controller is created disabled, no discovery or login
     until it is enabled.

   # echo eth3.172-fcoe > /sys/bus/fcoe/ctlr_create

2) Configure the FCoE Controller
   - Change mode, set ddp_min (future), set dcb_required (future), etc...

   # echo 2 > /sys/bus/fcoe/ctlr_0/mode #sets mode to VN2VN

3) Enable the FCoE Controller
   - Begins discovery and login in 'Fabric' mode. or
   - Begins FIP FCID claim process, discovery and login in 'VN2VN' mode

4) Destroy the FCoE Controller
   - Logout and free all memory

   # echo eth3.172-fcoe > /sys/bus/fcoe/ctlr_destroy

This series converts both fcoe.ko and bnx2fc.ko to use the new
fcoe_sysfs based interfaces. The legacy interfaces can remain in kernel
for a kernel cycle or two before being removed.

I'm looking for feedback on the use of /sys/bus/fcoe/ctlr_create and
/sys/bus/fcoe/ctlr_destroy and that those interfaces take an ifname.
I modeled it after the bonding interface, but I'm not sure if that's
acceptible.

Incorpoated v1 feedback:

@Chris:

I spent a lot of time looking into FCF selection.

I implemented a POC series where I made the 'enabled' attribute
of a fcoe_fcf_device (i.e. /sys/bus/fcoe/devices/fcf_X) writable. The
fcoe_ctlr_device (i.e. /sys/bus/fcoe/devices/ctlr_X) has a
'selection_strategy' attribute that would allow the user to toggle between
AUTO (current kernel selection algorithm) and USER (user writes to FCF's
'selection' attribute).

I also wrote a little libudev based application that listened for fcoe_fcf_device
sysfs add/remove events. My plan was to have fcoemon monitor the discovery
of FCFs and then have it write to the 'selected' attribute of the FCF the user
had chosen.

Working on this series convinced me that any FCF selection needs further
consideration. First of all, it's fairly complicated to update the fcoe_ctlr.c
functional FIP code to handle FCF/fabric selection. Some questions that arise:

What triggers FLOGI/LOGO? We would now have link, enabled/disabled, selection
strategy and FCF selection to consider.

Can a new FCF be selected when one is already selected and an FLOGI has occurred?
Can a FCF be de-selected when the FLOGI has been sent?

Maybe we can only change things when disabled, that probably makes the most sense..

When does discovery happen? When the ctlr is created (no opportunity for
mode/selection strategy to be set)? When the mode is changed (same problem)?
What about when the cltr is enabled (but that's when we were going to FLOGI)?

This isn't a complete list of considerations, just what came to mind when writing
this. Anyway, the policies started to get complicated, or maybe my lack of policies
made the POC implementation more complicated. Either way it made me think about
use cases and how valuable FCF/fabric selection is.

After further consideration I think that most of the access decisions, when
connecting to a FC fabric, should be done by the fabric services. I'm not sure
the endstations should be whitelisting or blacklisting FCFs or even making
decisions about which ones to use when they're already prioritized amongst themselves
(on the same fabric). I think it might be nice for debugging, but I don't have a
need at the moment.

I think user selection may be more valuable with VN2VN, which may interest you
more anyway, as you said that you were running a VN2VN setup. Since there
aren't fabric services to rely on I can see it useful for VN_Ports to whitelist or
blacklist other VN_Ports. I think the first step to support something like this
would be to represent the fcoe_rports in fcoe_sysfs or in the FC Transport such
that they can be selected or de-slected.

I think that's a fine goal, but with this series, I think I'd like to focus on
just getting away from using module parameters for control interfaces. I think
this current series allows for selection as I've described above since it will
now start the FCoE Controller in a DISABLED state such that configurations can
now be made before the FLOGI.

@Bhanu

I implemented the changes for bnx2fc and I think it should be mostly fine. I
wasn't able to test the code, so I'd appreciate any feedback about whether
there are bugs or not.

@Bart:

Fixed the 'const char *p' and cast issue in fcoe_parse_mode().

Now checking for string length and passing correctly NULL terminated string
to fcoe_parse_mode().

Thanks, //Rob

---

v1 covermail

The following series implements a move from using module parameters
as control interfaces to /sys/bus/fcoe based interfaces. A sysfs infrastructure
was added to the kernel a few cycles ago, this series builds on that work.

It moves the create, vn2vn_create, destroy, enable and disable interfaces
from /sys/module/libfcoe/parameters/ to various places under /sys/bus/fcoe/.
These interfaces simply are not module configurations- they are control
interfaces.

A second goal of this series is to change the initialization sequence for
a FCoE device. The result of this series is that interfaces created using
libfcoe.ko interfaces (i.e. fcoe.ko or bnx2fc.ko) will have the following
starting steps-

1) Create/alloc the port
   - Allocate kernel memory and create per-instance sysfs devices
   - No discovery or login

2) Configure the port
   - Change mode, set ddp_min, etc...

3) Start the port
   - Begins discovery and/or login (depending on mode)

4) Destroy the port
   - Logout and free all memory

I'm looking for feedback on using sysfs files as control interfaces that
the user (application) would write interface names to. I modeled this
series off of the bonding sysfs interface, but it was suggested to me that
it might not be a good example. I belive bonding uses two values per-file
a '+' or a '-" to add or delete and then the ifname apended. I am simply
writing the ifname to the ctlr_create or ctlr_destroy.

Series compiled and tested against v3.5. libfcoe.ko compile warning fixed
upstream after v3.5, anyone who compiles this can ignore section mismatch
warning. Also note that a modified fcoemon is needed to use the fcoe system
service against this kernel modification. I'd be happy to provide that
fcoemon code on request.

---

Robert Love (5):
      libfcoe: Save some memory and optimize name lookups
      libfcoe: Add fcoe_sysfs debug logging level
      libfcoe, fcoe, bnx2fc: Add new fcoe control interface
      fcoe: Use the fcoe_sysfs control interface
      bnx2fc: Use the fcoe_sysfs control interface


 Documentation/ABI/testing/sysfs-bus-fcoe |   42 +++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |  169 ++++++++++++++++++++++-----
 drivers/scsi/fcoe/fcoe.c                 |  148 +++++++++++++++++++++---
 drivers/scsi/fcoe/fcoe_ctlr.c            |   17 +--
 drivers/scsi/fcoe/fcoe_sysfs.c           |  186 +++++++++++++++++++++++++-----
 drivers/scsi/fcoe/fcoe_transport.c       |  104 +++++++++++++++++
 drivers/scsi/fcoe/libfcoe.h              |   11 +-
 include/scsi/fcoe_sysfs.h                |   11 ++
 include/scsi/libfcoe.h                   |   16 ++-
 9 files changed, 608 insertions(+), 96 deletions(-)

-- 

Thanks, //Rob
