From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/8] qla2xxx: Don't fallback to interrupt-polling during re-initialization with MSI-X enabled.
Date: Mon,  5 Jan 2009 11:18:06 -0800
Message-ID: <1231183092-10471-3-git-send-email-andrew.vasquez@qlogic.com>
References: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22498 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbZAETSY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:18:24 -0500
In-Reply-To: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

ROMs in recent ISPs have MSI-X support, so it's no longer
necessary for the driver to fallback to interrupt polling during
ISP re-initialization.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_init.c |    3 +++
 drivers/scsi/qla2xxx/qla_mbx.c  |    5 ++---
 drivers/scsi/qla2xxx/qla_os.c   |    2 ++
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index fc50221..191c95d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2370,6 +2370,8 @@ struct qla_hw_data {
 				IS_QLA84XX(ha))
 #define IS_QLA2XXX_MIDTYPE(ha)	(IS_QLA24XX(ha) || IS_QLA84XX(ha) || \
 				IS_QLA25XX(ha))
+#define IS_NOPOLLING_TYPE(ha)	(IS_QLA25XX(ha) && \
+				(ha)->flags.msix_enabled)
 
 #define IS_IIDMA_CAPABLE(ha)    ((ha)->device_type & DT_IIDMA)
 #define IS_FWI2_CAPABLE(ha)     ((ha)->device_type & DT_FWI2)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 521d215..3ec6eac 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -570,6 +570,9 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 	}
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (IS_NOPOLLING_TYPE(ha))
+		ha->isp_ops->enable_intrs(ha);
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f03de8c..29bf8bc 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -123,8 +123,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 	/* Wait for mbx cmd completion until timeout */
 
-	if (!abort_active && io_lock_on) {
-
+	if ((!abort_active && io_lock_on) || IS_NOPOLLING_TYPE(ha)) {
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
 		if (IS_FWI2_CAPABLE(ha))
@@ -218,7 +217,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	/* Clean up */
 	ha->mcp = NULL;
 
-	if (abort_active || !io_lock_on) {
+	if ((abort_active || !io_lock_on) && !IS_NOPOLLING_TYPE(ha)) {
 		DEBUG11(printk("%s(%ld): checking for additional resp "
 		    "interrupt.\n", __func__, base_vha->host_no));
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3b1b68c..3580c03 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1329,6 +1329,8 @@ qla24xx_disable_intrs(struct qla_hw_data *ha)
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
+	if (IS_NOPOLLING_TYPE(ha))
+		return;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->interrupts_on = 0;
 	WRT_REG_DWORD(&reg->ictrl, 0);
-- 
1.6.1.28.gc32f76

