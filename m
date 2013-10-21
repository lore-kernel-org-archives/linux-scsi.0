From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/19] libfc, libfcoe, and fcoe updates for 3.13
Date: Mon, 21 Oct 2013 11:00:24 -0700
Message-ID: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4959 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab3JUSAl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:00:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following series implements some fixes and enhancements.

All but the last 3 patches are a resend from
patches sent at the last (3.12) merge window.

There is no particular theme to this series, just some
code optimizations and bug fixes.

A 'request-pull' e-mail will follow this series.
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

Joe Perches (1):
      scsi: Convert uses of compare_ether_addr to ether_addr_equal

Neil Horman (4):
      fcoe: ensure that skb placed on the fip_recv_list are unshared
      fcoe: make sure fcoe frames are unshared prior to manipulating them
      fcoe: cleanup return codes from fcoe_rcv
      fcoe: Fix missing mutex_unlock in fcoe_sysfs_fcf_add error path

Robert Love (1):
      libfcoe: Make fcoe_sysfs optional / fix fnic NULL exception


 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 -
 drivers/scsi/fcoe/fcoe.c          |   25 ++--
 drivers/scsi/fcoe/fcoe_ctlr.c     |  148 ++++++++++++++--------
 drivers/scsi/fcoe/fcoe_sysfs.c    |   14 +-
 drivers/scsi/fnic/fnic_fcs.c      |    6 -
 drivers/scsi/libfc/fc_exch.c      |  251 ++++++++++++++++++++++++-------------
 drivers/scsi/libfc/fc_fcp.c       |   10 +
 drivers/scsi/libfc/fc_lport.c     |    4 -
 drivers/scsi/libfc/fc_rport.c     |    6 -
 include/scsi/fc/fc_fc2.h          |    2 
 include/scsi/libfc.h              |    9 +
 include/scsi/libfcoe.h            |    7 +
 12 files changed, 310 insertions(+), 176 deletions(-)

-- 
Thanks, //Rob
