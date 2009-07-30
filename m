From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/22] Open-FCoE Features for 2.6.32
Date: Wed, 29 Jul 2009 17:03:45 -0700
Message-ID: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbZG3ADo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:03:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series contains the first set of features for libfc, libfcoe and fcoe.

The largest change is to share an Exchange Manager amongst virtual interfaces (VLANs) on a physical interface. This will change will also help with NPIV support which should come in a later patch set.

Other than that, there are a lot of miscellaneous fixes and improvements to all three modules.

---

Joe Eykholt (10):
      libfc: fix: cancel rport retry timer
      libfc: fc_rport_logoff should not drop the lock
      libfc: rename rport state "NONE" to "DELETE".
      libfc: fix WARNING from fc_seq_start_next on closed exchanges
      libfc: in fc_lport_destroy, flush rports after turning off link
      libfc: stop login after fabric logoff
      libfc: rename lport NONE state to DISABLED
      fcoe: stop delivery of received frames before doing lport_destroy()
      libfc: change debug messages to give host number.
      libfc: remove extra semicolons from debug macros

Robert Love (1):
      libfc: Remove the FC_EM_DBG macro

Vasu Dev (5):
      fcoe: removes phys_dev and renames real_dev to netdev.
      fcoe, libfc: adds offload EM per eth device with only single xid range per EM
      fcoe: modifies fcoe_hostlist_lock uses as prep work to add shared offload EM
      fcoe, fnic, libfc: modifies current code paths to use EM anchor list
      fcoe, libfc: adds exchange manager(EM) anchor list per lport and related APIs

Yi Zou (6):
      libfc: Remove page flags check for sglist
      libfc: Remove FC_FRAME_SG_LEN in fc_fcp_send_data
      fcoe: Remove ifdef for NETIF_F_FCOE_CRC and NETIF_F_FSO
      fcoe: Call dev_ethtool_get_settings() in fcoe_link_ok
      libfcoe: Set fip_flags according to fcf and lport's capability of SPMA support
      fcoe: Fix validation of mac address when checking for spma support


 drivers/scsi/fcoe/fcoe.c      |  250 +++++++++++++++++++-----------
 drivers/scsi/fcoe/fcoe.h      |    8 -
 drivers/scsi/fcoe/libfcoe.c   |   14 +-
 drivers/scsi/fnic/fnic_fcs.c  |    2 
 drivers/scsi/fnic/fnic_main.c |   20 +-
 drivers/scsi/libfc/fc_exch.c  |  337 ++++++++++++++++++++++-------------------
 drivers/scsi/libfc/fc_fcp.c   |   29 ----
 drivers/scsi/libfc/fc_lport.c |   61 ++++++-
 drivers/scsi/libfc/fc_rport.c |   83 ++++++----
 include/scsi/fc_frame.h       |    7 -
 include/scsi/libfc.h          |  126 +++++++--------
 11 files changed, 518 insertions(+), 419 deletions(-)

-- 
//Rob
