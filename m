From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/20] libfc, fcoe and fnci fixes for 2.6.32 RC
Date: Wed, 21 Oct 2009 16:26:40 -0700
Message-ID: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32805 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZJUX1b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:27:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series fixes some bugs in the 2.6.32 kernel. A few of the patches fix regressions in fcoe offloads as previously mentioned on linux-scsi.

This series reorders patches previously mailed to the list. Please disregard previously mailed patches from me. I will resend the other patches for the 2.6.33 merge window.

This series is tested against today's scsi-rc-fixes tree.

---

Abhijeet Joglekar (3):
      fnic: Pad the unused bytes of CDB to 0s
      fnic: Set max_cmd_len to driver supported CDB length
      fnic: Process all cq entries per ISR

Chris Leech (1):
      libfc: fix memory corruption caused by double frees and bad error handling

Joe Eykholt (4):
      libfc: fix free of fc_rport_priv with timer pending
      libfc: don't WARN_ON in lport_timeout for RESET state
      libfc: lport: fix minor documentation errors
      libfc: fix typo in retry check on received PRLI

Mike Christie (1):
      fcoe: initialize return value in fcoe_destroy

Robert Love (2):
      libfc: Remove unused fc_lport pointer from fc_fcp_pkt_abort
      libfc, fcoe: Don't EXPORT_SYMBOLS unnecessarily

Vasu Dev (3):
      libfc: removes unused disc_work and ex_list
      libfc: adds missing exch release for accepted RRQ
      libfc: removes initializing fc_cpu_order and fc_cpu_mask per lport

Yi Zou (6):
      fcoe: Call ndo_fcoe_enable/disable to turn FCoE feature on/off in LLD
      libfc: Fix frags in frame exceeding SKB_MAX_FRAGS in fc_fcp_send_data
      fcoe: Use NETIF_F_FCOE_MTU flag to set up max frame size (lport->mfs)
      libfc: Fix wrong scsi return status under FC_DATA_UNDRUN
      fcoe: remove redundant checking of netdev->netdev_ops
      libfc: fix ddp in fc_fcp for 0 xid


 drivers/scsi/fcoe/fcoe.c      |   34 ++++++++++++++---
 drivers/scsi/fcoe/fcoe.h      |    6 +++
 drivers/scsi/fnic/fnic.h      |    2 -
 drivers/scsi/fnic/fnic_isr.c  |   18 ++++-----
 drivers/scsi/fnic/fnic_main.c |    1 
 drivers/scsi/fnic/fnic_res.h  |    4 +-
 drivers/scsi/fnic/fnic_scsi.c |    3 +
 drivers/scsi/libfc/fc_disc.c  |    2 -
 drivers/scsi/libfc/fc_elsct.c |    4 +-
 drivers/scsi/libfc/fc_exch.c  |   35 +++++++++--------
 drivers/scsi/libfc/fc_fcp.c   |   26 +++++++------
 drivers/scsi/libfc/fc_frame.c |    1 
 drivers/scsi/libfc/fc_lport.c |   33 +++++++++-------
 drivers/scsi/libfc/fc_rport.c |   83 ++++++++++++++++++++++++++++-------------
 include/scsi/fc_frame.h       |    3 +
 include/scsi/libfc.h          |    2 -
 16 files changed, 166 insertions(+), 91 deletions(-)

-- 
//Rob
