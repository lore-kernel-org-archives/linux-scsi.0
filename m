From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/11] qla2xxx: Consolidate RISC-parity enablement codes.
Date: Thu, 31 Jan 2008 12:33:49 -0800
Message-ID: <1201811634-19865-6-git-send-email-andrew.vasquez@qlogic.com>
References: <20080131203216.GB19014@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8353 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760663AbYAaUeH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:34:07 -0500
In-Reply-To: <20080131203216.GB19014@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Collapse duplicate codes called during probe() and RISC-reset
into qla2x00_setup_chip().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   70 +++++++++++++-------------------------
 drivers/scsi/qla2xxx/qla_os.c   |   12 -------
 2 files changed, 24 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 97063cb..d5c7853 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -925,6 +925,16 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 {
 	int rval;
 	uint32_t srisc_address = 0;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	unsigned long flags;
+
+	if (!IS_FWI2_CAPABLE(ha) && !IS_QLA2100(ha) && !IS_QLA2200(ha)) {
+		/* Disable SRAM, Instruction RAM and GP RAM parity.  */
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		WRT_REG_WORD(&reg->hccr, (HCCR_ENABLE_PARITY + 0x0));
+		RD_REG_WORD(&reg->hccr);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	}
 
 	/* Load firmware sequences */
 	rval = ha->isp_ops->load_risc(ha, &srisc_address);
@@ -968,6 +978,19 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 		}
 	}
 
+	if (!IS_FWI2_CAPABLE(ha) && !IS_QLA2100(ha) && !IS_QLA2200(ha)) {
+		/* Enable proper parity. */
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		if (IS_QLA2300(ha))
+			/* SRAM parity */
+			WRT_REG_WORD(&reg->hccr, HCCR_ENABLE_PARITY + 0x1);
+		else
+			/* SRAM, Instruction RAM and GP RAM parity */
+			WRT_REG_WORD(&reg->hccr, HCCR_ENABLE_PARITY + 0x7);
+		RD_REG_WORD(&reg->hccr);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	}
+
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Setup chip **** FAILED ****.\n",
 		    ha->host_no));
@@ -3344,60 +3367,15 @@ static int
 qla2x00_restart_isp(scsi_qla_host_t *ha)
 {
 	uint8_t		status = 0;
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-	unsigned long	flags = 0;
 	uint32_t wait_time;
 
 	/* If firmware needs to be loaded */
 	if (qla2x00_isp_firmware(ha)) {
 		ha->flags.online = 0;
-		if (!(status = ha->isp_ops->chip_diag(ha))) {
-			if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-				status = qla2x00_setup_chip(ha);
-				goto done;
-			}
-
-			spin_lock_irqsave(&ha->hardware_lock, flags);
-
-			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha) &&
-			    !IS_QLA25XX(ha)) {
-				/*
-				 * Disable SRAM, Instruction RAM and GP RAM
-				 * parity.
-				 */
-				WRT_REG_WORD(&reg->hccr,
-				    (HCCR_ENABLE_PARITY + 0x0));
-				RD_REG_WORD(&reg->hccr);
-			}
-
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
+		if (!(status = ha->isp_ops->chip_diag(ha)))
 			status = qla2x00_setup_chip(ha);
-
-			spin_lock_irqsave(&ha->hardware_lock, flags);
-
-			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha) &&
-			    !IS_QLA25XX(ha)) {
-				/* Enable proper parity */
-				if (IS_QLA2300(ha))
-					/* SRAM parity */
-					WRT_REG_WORD(&reg->hccr,
-					    (HCCR_ENABLE_PARITY + 0x1));
-				else
-					/*
-					 * SRAM, Instruction RAM and GP RAM
-					 * parity.
-					 */
-					WRT_REG_WORD(&reg->hccr,
-					    (HCCR_ENABLE_PARITY + 0x7));
-				RD_REG_WORD(&reg->hccr);
-			}
-
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		}
 	}
 
- done:
 	if (!status && !(status = qla2x00_init_rings(ha))) {
 		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 		if (!(status = qla2x00_fw_ready(ha))) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1249545..f129c69 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1773,18 +1773,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		WRT_REG_WORD(&reg->isp.semaphore, 0);
 		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_RISC_INT);
 		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
-
-		/* Enable proper parity */
-		if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
-			if (IS_QLA2300(ha))
-				/* SRAM parity */
-				WRT_REG_WORD(&reg->isp.hccr,
-				    (HCCR_ENABLE_PARITY + 0x1));
-			else
-				/* SRAM, Instruction RAM and GP RAM parity */
-				WRT_REG_WORD(&reg->isp.hccr,
-				    (HCCR_ENABLE_PARITY + 0x7));
-		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-- 
1.5.4.rc5.5.gab98

