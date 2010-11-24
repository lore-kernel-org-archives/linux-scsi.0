From: madhu.iyengar@qlogic.com
Subject: [PATCH 2/5] qla2xxx: Change MSI initialization from using incorrect request_irq parameter.
Date: Tue, 23 Nov 2010 16:52:47 -0800
Message-ID: <1290559970-12123-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59500 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754410Ab0KXBCi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 20:02:38 -0500
In-Reply-To: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Mike Hernandez <michael.hernandez@qlogic.com>

From: Mike Hernandez <michael.hernandez@qlogic.com>

IRQF_SHARED flag should not be set when calling request_irq for MSI
since this interrupt mechanism cannot be shared like standard INTx.

Signed-off-by: Mike Hernandez <michael.hernandez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 -
 drivers/scsi/qla2xxx/qla_isr.c |    5 +++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3a22eff..9ce539d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2409,7 +2409,6 @@ struct qla_hw_data {
 		uint32_t	enable_target_reset	:1;
 		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_led_scheme	:1;
-		uint32_t	inta_enabled		:1;
 		uint32_t	msi_enabled		:1;
 		uint32_t	msix_enabled		:1;
 		uint32_t	disable_serdes		:1;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1f06ddd..7f77898 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2491,14 +2491,15 @@ skip_msix:
 skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
-	    IRQF_SHARED, QLA2XXX_DRIVER_NAME, rsp);
+	    ha->flags.msi_enabled ? 0 : IRQF_SHARED,
+	    QLA2XXX_DRIVER_NAME, rsp);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
 		    ha->pdev->irq);
 		goto fail;
 	}
-	ha->flags.inta_enabled = 1;
+
 clear_risc_ints:
 
 	/*
-- 
1.6.0.2

