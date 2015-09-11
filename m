From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 16/29] cxlflash: Rescan host following link up event
Date: Fri, 11 Sep 2015 16:16:28 -0500
Message-ID: <1442006188-47038-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:46642 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbbIKVQr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:16:47 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 17:16:46 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 33ED86E8047
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:08:27 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLGhBj66060338
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 21:16:43 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLGfYV019504
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:16:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The host should be rescanned after a link up event.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  2 +-
 drivers/scsi/cxlflash/main.c   | 17 +++++++++++++----
 drivers/scsi/cxlflash/main.h   |  1 +
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index c8327ac..517da25 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -102,7 +102,7 @@ struct cxlflash_cfg {
 	enum cxlflash_init_state init_state;
 	enum cxlflash_lr_state lr_state;
 	int lr_port;
-
+	atomic_t scan_host_needed;
 	atomic_t remove_active;
 
 	struct cxl_afu *cxl_afu;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b3838af..39ad7a3 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1120,17 +1120,17 @@ static const struct asyc_intr_info ainfo[] = {
 	{SISL_ASTATUS_FC0_CRC_T, "CRC threshold exceeded", 0, LINK_RESET},
 	{SISL_ASTATUS_FC0_LOGI_R, "login timed out, retrying", 0, 0},
 	{SISL_ASTATUS_FC0_LOGI_F, "login failed", 0, CLR_FC_ERROR},
-	{SISL_ASTATUS_FC0_LOGI_S, "login succeeded", 0, 0},
+	{SISL_ASTATUS_FC0_LOGI_S, "login succeeded", 0, SCAN_HOST},
 	{SISL_ASTATUS_FC0_LINK_DN, "link down", 0, 0},
-	{SISL_ASTATUS_FC0_LINK_UP, "link up", 0, 0},
+	{SISL_ASTATUS_FC0_LINK_UP, "link up", 0, SCAN_HOST},
 	{SISL_ASTATUS_FC1_OTHER, "other error", 1, CLR_FC_ERROR | LINK_RESET},
 	{SISL_ASTATUS_FC1_LOGO, "target initiated LOGO", 1, 0},
 	{SISL_ASTATUS_FC1_CRC_T, "CRC threshold exceeded", 1, LINK_RESET},
 	{SISL_ASTATUS_FC1_LOGI_R, "login timed out, retrying", 1, 0},
 	{SISL_ASTATUS_FC1_LOGI_F, "login failed", 1, CLR_FC_ERROR},
-	{SISL_ASTATUS_FC1_LOGI_S, "login succeeded", 1, 0},
+	{SISL_ASTATUS_FC1_LOGI_S, "login succeeded", 1, SCAN_HOST},
 	{SISL_ASTATUS_FC1_LINK_DN, "link down", 1, 0},
-	{SISL_ASTATUS_FC1_LINK_UP, "link up", 1, 0},
+	{SISL_ASTATUS_FC1_LINK_UP, "link up", 1, SCAN_HOST},
 	{0x0, "", 0, 0}		/* terminator */
 };
 
@@ -1361,6 +1361,11 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 			writeq_be(reg, &global->fc_regs[port][FC_ERROR / 8]);
 			writeq_be(0, &global->fc_regs[port][FC_ERRCAP / 8]);
 		}
+
+		if (info->action & SCAN_HOST) {
+			atomic_inc(&cfg->scan_host_needed);
+			schedule_work(&cfg->work_q);
+		}
 	}
 
 out:
@@ -2320,6 +2325,7 @@ MODULE_DEVICE_TABLE(pci, cxlflash_pci_table);
  * - Link reset which cannot be performed on interrupt context due to
  * blocking up to a few seconds
  * - Read AFU command room
+ * - Rescan the host
  */
 static void cxlflash_worker_thread(struct work_struct *work)
 {
@@ -2362,6 +2368,9 @@ static void cxlflash_worker_thread(struct work_struct *work)
 	}
 
 	spin_unlock_irqrestore(cfg->host->host_lock, lock_flags);
+
+	if (atomic_dec_if_positive(&cfg->scan_host_needed) >= 0)
+		scsi_scan_host(cfg->host);
 }
 
 /**
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index cf0e809..6032456 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -99,6 +99,7 @@ struct asyc_intr_info {
 	u8 action;
 #define CLR_FC_ERROR	0x01
 #define LINK_RESET	0x02
+#define SCAN_HOST	0x04
 };
 
 #ifndef CONFIG_CXL_EEH
-- 
2.1.0

