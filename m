From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 0/4] FCoE Sysfs
Date: Fri, 16 Mar 2012 12:36:40 -0700
Message-ID: <20120316193640.5369.56932.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3529 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899Ab2CPTgl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Mar 2012 15:36:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

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


 Documentation/ABI/testing/sysfs-class-fcoe |   77 +++
 drivers/scsi/bnx2fc/bnx2fc.h               |    7 
 drivers/scsi/bnx2fc/bnx2fc_els.c           |    2 
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c          |  171 ++++--
 drivers/scsi/bnx2fc/bnx2fc_hwi.c           |   39 +
 drivers/scsi/fcoe/Makefile                 |    2 
 drivers/scsi/fcoe/fcoe.c                   |  196 +++++--
 drivers/scsi/fcoe/fcoe.h                   |    8 
 drivers/scsi/fcoe/fcoe_ctlr.c              |  159 +++++
 drivers/scsi/fcoe/fcoe_sysfs.c             |  840 ++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_transport.c         |   13 
 include/scsi/fcoe_sysfs.h                  |  124 ++++
 include/scsi/libfcoe.h                     |   27 +
 13 files changed, 1532 insertions(+), 133 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fcoe
 create mode 100644 drivers/scsi/fcoe/fcoe_sysfs.c
 create mode 100644 include/scsi/fcoe_sysfs.h

-- 
Thanks, //Rob
