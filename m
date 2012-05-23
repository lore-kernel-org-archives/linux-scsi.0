From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v6 0/4] FCoE Sysfs
Date: Tue, 22 May 2012 19:06:05 -0700
Message-ID: <20120523020605.12660.73324.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47797 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933022Ab2EWCGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 22:06:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

v6: Resend, v5 was missing patch 4/4

v5: Resend to apply on current misc branch of scsi.git

* checkpatch.pl complains about patch 3/4. The lack of a final
  argument is a trick I took from scsi_transport_fc.c. I think
  that it is fine.

  ERROR: space prohibited before that close parenthesis ')'
  #369: FILE: drivers/scsi/fcoe/fcoe_sysfs.c:196:
  +     fcoe_fcf_private_show_function(field, format_string, sz, )	\

* checkpatch.pl complains about patch 3/4. I attempted to add
  parenthesis around these macros, but I created more problems
  than I resolved. I am not sure what to do about this. I belive
  these were WARNs when this series was initially submitted.

  ERROR: Macros with complex values should be enclosed in parenthesis
  #378: FILE: drivers/scsi/fcoe/fcoe_sysfs.c:205:
  +#define fcoe_fcf_private_rd_attr_cast(field, format_string, sz, cast)	\
  +	 fcoe_fcf_private_show_function(field, format_string, sz, (cast)) \
  +	 static FCOE_DEVICE_ATTR(fcf, field, S_IRUGO,	      	  	  \
  +	 			      	     show_fcoe_fcf_device_##field, NULL)

* checkpatch.pl complains about patch 4/4. This is just a WARN.
  I would fix this if I knew how to, but I don't think it should
  be a problem.

  WARNING: quoted string split across lines
  #502: FILE: drivers/scsi/fcoe/fcoe_ctlr.c:1021:
  +		printk(KERN_ERR "Failed to allocate sysfs instance "
  +					       "for FCF, fab 16.16llx mac pM\n",

v4: Minor fixes and cleanups

* Changed device_initialize/device_add to device_register
  and device_del to device_unregister. There was an imbalance
  because device_initialize was getting a reference that
  was not being released. With this update both fcoe_fcfs
  as well as fcoe_ctlrs are correctly released/free'd when
  they are to be removed from the system.

* Minor updates to commit messages so there are no
  references to 'fcoe_ctlr_attrs' and 'fcoe_fcf_attrs'
  which were both renamed in v3 of this series.

v3: Addressed Greg KH's second set of review comments

* Created a 'fcoe bus' with the fcoe_ctlr and fcoe_fcf
  instances as devices on the bus. Created bus_type(s)
  for both device types, with default attribute group
  sets for each. Now sysfs core adds/removes attributes
  which allowed the removal of sysfs_create_group calls
  before device_add. Updated Documentation/ accordingly.
  
* Renamed structures and APIs to make them less confusing.

   structs:
    fcoe_ctlr_attrs -> fcoe_ctlr_device
    fcoe_fcf_attrs -> fcoe_fcf_device

   functions:
    fcoe_ctlr_attrs_add -> fcoe_ctlr_device_add
    fcoe_ctlr_attrs_delete -> fcoe_ctlr_device_delete
    fcoe_fcf_attrs_add -> fcoe_fcf_device_add
    fcoe_fcf_attrs_delete -> fcoe_fcf_device_delete

* Removed extra get_device(parent) for both the
  fcoe_ctlr_device and fcoe_fcf_device.

* fixed 'unused variable' compilation warning that
  existed in v2.

* API symbols now exported with EXPORT_SYMBOL_GPL

* NOT ADDRESSED - idr usage vs. atomic incremeting of
  fcoe_ctlr and fcoe_fcf id enumeration. It was indicated
  that idr has not traditionally been used in drivers/scsi/.
  I will re-examine this if there is still heartburn.

---

v2: Addressed Greg KH's review comments

* moved fcoe_ctlr_attrs and fcoe_fcf_attrs attribute
  helper macros from fcoe_sysfs.h to fcoe_sysfs.c so
  that they don't temp developers to use them. They're
  intended to be used in attribute show/store routine
  generating macros, but not by drivers.

* Removed unnecessary put_device calls on parent devices.
  Also removed unnecessary de-initialization of pointers
  to parent and removed unnecessary zero'ing of memory
  before freeing it.

* Added Documentation/ABI/testing/sysfs-class-fcoe
  document.

* Changed simple_strtoul usage to kstrtoul to avoid
  checkpatch.pl warning that I missed before. There's
  a bunch of noise in checkpatch.pl due to an odd macro
  usage, but I think any remaining checkpatch.pl warnings
  are OK.

---

This patch series adds a sysfs layer to libfcoe. It adds
a sysfs instance for FIP controllers (a SW entity) and
discovered Fibre Channel Forwarders (FCFs), which are
simply FCoE switches.

The new sysfs code is used by any driver that currently
uses libfcoe, namely fcoe.ko and bnx2fc_fcoe.ko. Any other
FCoE capable device that wishes to use the high-level APIs
defined in fcoe_syfs.h may, without having to use the
the protocol processing portions of libfcoe.

The code borrows heavily from the FC Transport, but is
less complicated because it does not need to interact
with the SCSI layer directly.

I think one thing to consider with this series is that
drivers, such as traditional HBAs, which wish to use
this infrastructure will now need to depend on libfcoe.ko.
It was either this or create a superfluous kernel module;
I think libfcoe is an appropriate place for this code.

This series was created against scsi-misc + 9 patches
mailed by me to linux-scsi on 03/09/12. (Note that 10
patches were mailed, but that patch 01/10 will be dropped)

I'm not sure if there's somewhere I should cross-post
this for general sysfs review. I don't think I'm doing
anything odd; I added Greg K-H to the CC list to try and
get some sysfs eyes on this code.

---

Robert Love (4):
      fcoe: Allocate fcoe_ctlr with fcoe_interface, not as a member
      bnx2fc: Allocate fcoe_ctlr with bnx2fc_interface, not as a member
      libfcoe: Add fcoe_sysfs
      fcoe, bnx2fc, libfcoe: SW FCoE and bnx2fc use FCoE Syfs


 Documentation/ABI/testing/sysfs-bus-fcoe |   77 +++
 drivers/scsi/bnx2fc/bnx2fc.h             |    7 
 drivers/scsi/bnx2fc/bnx2fc_els.c         |    2 
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |  171 +++++-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c         |   39 +
 drivers/scsi/fcoe/Makefile               |    2 
 drivers/scsi/fcoe/fcoe.c                 |  200 +++++--
 drivers/scsi/fcoe/fcoe.h                 |    8 
 drivers/scsi/fcoe/fcoe_ctlr.c            |  159 +++++-
 drivers/scsi/fcoe/fcoe_sysfs.c           |  832 ++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_transport.c       |   13 
 include/scsi/fcoe_sysfs.h                |  124 ++++
 include/scsi/libfcoe.h                   |   27 +
 13 files changed, 1526 insertions(+), 135 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-fcoe
 create mode 100644 drivers/scsi/fcoe/fcoe_sysfs.c
 create mode 100644 include/scsi/fcoe_sysfs.h

-- 
Thanks, //Rob
