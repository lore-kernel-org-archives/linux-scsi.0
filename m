From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/21] libfc, libfcoe and fcoe updates for 3.9
Date: Tue, 19 Feb 2013 11:30:31 -0800
Message-ID: <20130219193031.10192.33777.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39017 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933237Ab3BSTai (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 14:30:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This series is mostly a resend of previously sent patches. The primary change in this series is the addition of the fcoe_sysfs "control" interfaces. Additionally there are a few fix/cleanup patches and UAPI conversions. Almost all of these patches have already been reviewed on linux-scsi.

I will compose a pull-request and send it soon, but I wanted to make sure the most recent versions of these patches were posted to linux-scsi first.

---

Al Viro (1):
      debris left by "[SCSI] libfcoe: Remove mutex_trylock/restart_syscall checks"

Bhanu Prakash Gollapudi (1):
      libfcoe: Handle CVL while waiting to select an FCF

David Howells (1):
      UAPI: (Scripted) Disintegrate include/scsi/fc

Krishna Mohan (1):
      libfc: XenServer fails to mount root filesystem.

Neerav Parikh (1):
      fcoe: Fix deadlock while deleting FCoE interface with NPIV ports

Neil Horman (1):
      fcoe: close race on link speed detection in fcoe code

Robert Love (7):
      Documentation: Add missing devices/ to devices path
      libfcoe: Save some memory and optimize name lookups
      libfcoe: Add fcoe_sysfs debug logging level
      libfcoe, fcoe, bnx2fc: Add new fcoe control interface
      fcoe: Use the fcoe_sysfs control interface
      bnx2fc: Use the fcoe_sysfs control interface
      libfc, libfcoe, fcoe: Convert debug_logging macros to pr_info

Vasu Dev (1):
      libfc: fix REC handling

Yi Zou (7):
      fcoe: prep work to start consolidate the usage of fcoe_netdev
      fcoe: add support to the get_netdev() for fcoe_interface
      libfcoe, fcoe: move fcoe_link_speed_update() to libfcoe and export it
      libfcoe, fcoe: consolidate the fcoe_ctlr_get_lesb/fcoe_get_lesb
      bnx2fc: add support to get_netdev for bnx2f_interface
      bnx2fc: use fcoe_link_speed_update() from the exported symbol in libfcoe
      bnx2fc: use fcoe_get_lesb/fcoe_ctlr_get_lesb() directly from libfcoe


 Documentation/ABI/testing/sysfs-bus-fcoe |   45 ++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |  256 +++++----
 drivers/scsi/fcoe/fcoe.c                 |  266 ++++++----
 drivers/scsi/fcoe/fcoe.h                 |    6 
 drivers/scsi/fcoe/fcoe_ctlr.c            |   27 +
 drivers/scsi/fcoe/fcoe_sysfs.c           |  186 +++++--
 drivers/scsi/fcoe/fcoe_transport.c       |  199 +++++++
 drivers/scsi/fcoe/libfcoe.h              |   20 -
 drivers/scsi/libfc/fc_fcp.c              |    6 
 drivers/scsi/libfc/fc_libfc.h            |   38 +
 drivers/scsi/libfc/fc_rport.c            |    2 
 include/scsi/fc/Kbuild                   |    4 
 include/scsi/fc/fc_els.h                 |  831 ------------------------------
 include/scsi/fc/fc_fs.h                  |  348 -------------
 include/scsi/fc/fc_gs.h                  |   96 ---
 include/scsi/fc/fc_ns.h                  |  208 --------
 include/scsi/fcoe_sysfs.h                |   11 
 include/scsi/libfcoe.h                   |   32 +
 include/uapi/scsi/fc/Kbuild              |    4 
 include/uapi/scsi/fc/fc_els.h            |  831 ++++++++++++++++++++++++++++++
 include/uapi/scsi/fc/fc_fs.h             |  348 +++++++++++++
 include/uapi/scsi/fc/fc_gs.h             |   96 +++
 include/uapi/scsi/fc/fc_ns.h             |  208 ++++++++
 23 files changed, 2296 insertions(+), 1772 deletions(-)
 delete mode 100644 include/scsi/fc/fc_els.h
 delete mode 100644 include/scsi/fc/fc_fs.h
 delete mode 100644 include/scsi/fc/fc_gs.h
 delete mode 100644 include/scsi/fc/fc_ns.h
 create mode 100644 include/uapi/scsi/fc/fc_els.h
 create mode 100644 include/uapi/scsi/fc/fc_fs.h
 create mode 100644 include/uapi/scsi/fc/fc_gs.h
 create mode 100644 include/uapi/scsi/fc/fc_ns.h

-- 
Thanks, //Rob
