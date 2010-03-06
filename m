From: <kgudipat@brocade.com>
Subject: [PATCH 11/23] bfa: IOC recovery fix in fcmode.
Date: Fri, 5 Mar 2010 19:36:56 -0800
Message-ID: <1267846616-22617-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:55939 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab0CFDhK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 22:37:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- ioc_recover failed to work in fcmode.

	- Fixed the code to initialize the ioc_regs.err_set during the notify_hbfail.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc_ct.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 0430edd..469da95 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -171,10 +171,14 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
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
@@ -254,6 +258,11 @@ bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
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

