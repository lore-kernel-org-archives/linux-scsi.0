From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 20/32] bfa: IOC recovery fix in fcmode.
Date: Thu, 25 Feb 2010 17:49:12 -0800
Message-ID: <1267148952-22989-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:59499 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934895Ab0BZBv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:51:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

	- ioc_recover failed to work in fcmode, as a result,

		bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s ioc->*ioc) will do just

		  bfa_reg_write(ioc->ioc_regs.err_set, __PSS_ERR_STATUS_SET);
		  bfa_reg_read(ioc->ioc_regs.err_set);

		However, ioc_regs.err_set is not initialized.

    - Fixed the code to initialize the ioc_regs.err_set during the notify_hbfail.
---
 drivers/scsi/bfa/bfa_ioc_ct.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index e756713..45d82d6 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -34,7 +34,7 @@ static bfa_status_t bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc);
 static bfa_boolean_t bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc);
 static uint32_t * bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc,
-											uint32_t off);
+					uint32_t off);
 static uint32_t bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc);
@@ -172,10 +172,14 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc)
 {
-
-	bfa_reg_write(ioc->ioc_regs.ll_halt, __FW_INIT_HALT_P);
-	/* Wait for halt to take effect */
-	bfa_reg_read(ioc->ioc_regs.ll_halt);
+	if (ioc->cna) {
+		bfa_reg_write(ioc->ioc_regs.ll_halt, __FW_INIT_HALT_P);
+		/* Wait for halt to take effect */
+		bfa_reg_read(ioc->ioc_regs.ll_halt);
+	} else {
+		bfa_reg_write(ioc->ioc_regs.err_set, __PSS_ERR_STATUS_SET);
+		bfa_reg_read(ioc->ioc_regs.err_set);
+	}
 }
 
 /**
@@ -255,6 +259,11 @@ bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
 	 */
 	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
 	ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CT;
+
+	/*
+	 * err set reg : for notification of hb failure in fcmode
+	 */
+	ioc->ioc_regs.err_set = (rb + ERR_SET_REG);
 }
 
 /**
-- 
1.6.5.3

