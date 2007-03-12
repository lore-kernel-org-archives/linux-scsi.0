From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/6] qla2xxx: Drop acquisition of hardware_lock during flash manipulations.
Date: Mon, 12 Mar 2007 10:41:29 -0700
Message-ID: <117372129198-git-send-email-andrew.vasquez@qlogic.com>
References: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25532 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXCLRlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 13:41:35 -0400
In-Reply-To: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

There's no need given, I/O has been quiesced, RISC
interrupts have been disabled, and finally the RISC has been
paused.  Flash manipulation on ISP21xx, ISP22xx, and ISP23xx
parts requires the RISC to go through a full reset to
recover.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 362d041..206bda0 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1453,7 +1453,6 @@ uint8_t *
 qla2x00_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
-	unsigned long flags;
 	uint32_t addr, midpoint;
 	uint8_t *data;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1462,7 +1461,6 @@ qla2x00_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	qla2x00_suspend_hba(ha);
 
 	/* Go with read. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
 	midpoint = ha->optrom_size / 2;
 
 	qla2x00_flash_enable(ha);
@@ -1477,7 +1475,6 @@ qla2x00_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 		*data = qla2x00_read_flash_byte(ha, addr);
 	}
 	qla2x00_flash_disable(ha);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Resume HBA. */
 	qla2x00_resume_hba(ha);
@@ -1491,7 +1488,6 @@ qla2x00_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 {
 
 	int rval;
-	unsigned long flags;
 	uint8_t man_id, flash_id, sec_number, data;
 	uint16_t wd;
 	uint32_t addr, liter, sec_mask, rest_addr;
@@ -1504,7 +1500,6 @@ qla2x00_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	sec_number = 0;
 
 	/* Reset ISP chip. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
 	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
 
@@ -1697,7 +1692,6 @@ update_flash:
 		}
 	} while (0);
 	qla2x00_flash_disable(ha);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Resume HBA. */
 	qla2x00_resume_hba(ha);
-- 
1.5.0.3.382.g34572

