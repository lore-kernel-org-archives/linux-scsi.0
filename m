From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/16] libfc, libfcoe, fcoe updates for 3.12(+)
Date: Thu, 05 Sep 2013 12:12:18 -0700
Message-ID: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21033 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab3IETMU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:12:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following series implements some fixes and enhancements.

I know this series may be a bit late for the merge window. They
have been in my tree so they could see some testing. Now that that
is done I don't want to hold them back anymore.

Please pull when appropriate.

---

Bart Van Assche (13):
      libfc: Source code comment spelling fixes
      libfc: Debug code fixes
      libfc: Micro-optimize fc_setup_exch_mgr()
      libfc: Clarify fc_exch_find()
      libfc: Fix a race in fc_exch_timer_set_locked()
      libfc: Protect ep->esb_stat changes via ex_lock
      libfc: Avoid that sending after an abort triggers a kernel warning
      libfc: Reduce exchange lock contention in fc_exch_recv_abts()
      libfc: Do not invoke the response handler after fc_exch_done()
      fcp: Do not interpret check condition as underrun
      fcoe: Declare fcoe_ctlr_mode_set() static
      fcoe: Add missing newlines in debug messages
      fcoe: Reduce fcoe_sysfs_fcf_add() stack usage

Neil Horman (3):
      fcoe: ensure that skb placed on the fip_recv_list are unshared
      fcoe: make sure fcoe frames are unshared prior to manipulating them
      fcoe: cleanup return codes from fcoe_rcv


 drivers/scsi/fcoe/fcoe.c       |   22 ++--
 drivers/scsi/fcoe/fcoe_ctlr.c  |   47 ++++---
 drivers/scsi/fcoe/fcoe_sysfs.c |   12 +-
 drivers/scsi/libfc/fc_exch.c   |  251 ++++++++++++++++++++++++++--------------
 drivers/scsi/libfc/fc_fcp.c    |   10 +-
 drivers/scsi/libfc/fc_lport.c  |    4 -
 drivers/scsi/libfc/fc_rport.c  |    6 -
 include/scsi/fc/fc_fc2.h       |    2 
 include/scsi/libfc.h           |    9 +
 9 files changed, 229 insertions(+), 134 deletions(-)

-- 
Thanks, //Rob
