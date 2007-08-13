From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/6] qla2xxx: Correct mailbox register dump for FWI2 capable ISPs.
Date: Sun, 12 Aug 2007 18:22:56 -0700
Message-ID: <11869681771196-git-send-email-andrew.vasquez@qlogic.com>
References: <20070813012218.GD1067@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31584 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934596AbXHMBXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 21:23:22 -0400
In-Reply-To: <20070813012218.GD1067@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 563d18f..c668034 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2050,21 +2050,18 @@ qla25xx_fw_dump_failed:
 void
 qla2x00_dump_regs(scsi_qla_host_t *ha)
 {
+	int i;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
+	uint16_t __iomem *mbx_reg;
+
+	mbx_reg = IS_FWI2_CAPABLE(ha) ? &reg24->mailbox0:
+	    MAILBOX_REG(ha, reg, 0);
 
 	printk("Mailbox registers:\n");
-	printk("scsi(%ld): mbox 0 0x%04x \n",
-	    ha->host_no, RD_MAILBOX_REG(ha, reg, 0));
-	printk("scsi(%ld): mbox 1 0x%04x \n",
-	    ha->host_no, RD_MAILBOX_REG(ha, reg, 1));
-	printk("scsi(%ld): mbox 2 0x%04x \n",
-	    ha->host_no, RD_MAILBOX_REG(ha, reg, 2));
-	printk("scsi(%ld): mbox 3 0x%04x \n",
-	    ha->host_no, RD_MAILBOX_REG(ha, reg, 3));
-	printk("scsi(%ld): mbox 4 0x%04x \n",
-	    ha->host_no, RD_MAILBOX_REG(ha, reg, 4));
-	printk("scsi(%ld): mbox 5 0x%04x \n",
-	    ha->host_no, RD_MAILBOX_REG(ha, reg, 5));
+	for (i = 0; i < 6; i++)
+		printk("scsi(%ld): mbox %d 0x%04x \n", ha->host_no, i,
+		    RD_REG_WORD(mbx_reg++));
 }
 
 
-- 
1.5.3.rc4.41.g7efe

