From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [1/15]  qla2xxx: Firmware dump fixes
Date: Thu, 6 May 2004 22:49:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507054930.GA4869@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:47336 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263171AbUEGFrr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:47:47 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1922 04/04/29 14:20:53 andrew.vasquez@apc.qlogic.com +1 -0
  ISP dump routine fixes:
  
  	o Properly release hardware_lock in failure path.
  
  	o Fix inability to complete ISP2100 dump, by properly
  	  reseting the RISC after register reads.

 drivers/scsi/qla2xxx/qla_dbg.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c	Mon May  3 15:12:51 2004
+++ b/drivers/scsi/qla2xxx/qla_dbg.c	Mon May  3 15:12:51 2004
@@ -53,7 +53,7 @@
 		qla_printk(KERN_WARNING, ha,
 		    "Firmware has been previously dumped (%p) -- ignoring "
 		    "request...\n", ha->fw_dump);
-		return;
+		goto qla2300_fw_dump_failed;
 	}
 
 	/* Allocate (large) dump buffer. */
@@ -64,7 +64,7 @@
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to allocated memory for firmware dump (%d/%Zd).\n",
 		    ha->fw_dump_order, sizeof(struct qla2300_fw_dump));
-		return;
+		goto qla2300_fw_dump_failed;
 	}
 	fw = ha->fw_dump;
 
@@ -360,7 +360,7 @@
 
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%d)!!!\n", rval);
+		    "Failed to dump firmware (%x)!!!\n", rval);
 
 		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
 		ha->fw_dump = NULL;
@@ -370,6 +370,7 @@
 		    ha->host_no, ha->fw_dump);
 	}
 
+qla2300_fw_dump_failed:
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
@@ -569,7 +570,7 @@
 {
 	int		rval;
 	uint32_t	cnt, timer;
-	uint32_t	risc_address;
+	uint16_t	risc_address;
 	uint16_t	mb0, mb2;
 
 	device_reg_t	*reg;
@@ -589,7 +590,7 @@
 		qla_printk(KERN_WARNING, ha,
 		    "Firmware has been previously dumped (%p) -- ignoring "
 		    "request...\n", ha->fw_dump);
-		return;
+		goto qla2100_fw_dump_failed;
 	}
 
 	/* Allocate (large) dump buffer. */
@@ -600,7 +601,7 @@
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to allocated memory for firmware dump (%d/%Zd).\n",
 		    ha->fw_dump_order, sizeof(struct qla2100_fw_dump));
-		return;
+		goto qla2100_fw_dump_failed;
 	}
 	fw = ha->fw_dump;
 
@@ -616,7 +617,6 @@
 		else
 			rval = QLA_FUNCTION_TIMEOUT;
 	}
-
 	if (rval == QLA_SUCCESS) {
 		dmp_reg = (uint16_t *)(reg + 0);
 		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++) 
@@ -694,18 +694,8 @@
 		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++) 
 			fw->fpm_b1_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		/* Disable ISP interrupts. */
-		WRT_REG_WORD(&reg->ictrl, 0);
-
-		/* Reset RISC module. */
-		WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-
-		/* Release RISC module. */
-		WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC); 
-
-		/* Insure mailbox registers are free. */
-		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT); 
-		WRT_REG_WORD(&reg->hccr, HCCR_CLR_HOST_INT); 
+		/* Reset the ISP. */
+		WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
 	}
 
 	for (cnt = 30000; RD_MAILBOX_REG(ha, reg, 0) != 0 &&
@@ -729,7 +719,6 @@
 			else
 				rval = QLA_FUNCTION_TIMEOUT;
 		}
-
 		if (rval == QLA_SUCCESS) {
 			/* Set memory configuration and timing. */
 			if (IS_QLA2100(ha))
@@ -750,7 +739,7 @@
 	}
 	for (cnt = 0; cnt < sizeof(fw->risc_ram) / 2 && rval == QLA_SUCCESS;
 	    cnt++, risc_address++) {
- 		WRT_MAILBOX_REG(ha, reg, 1, (uint16_t)risc_address);
+ 		WRT_MAILBOX_REG(ha, reg, 1, risc_address);
 		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
 
 		for (timer = 6000000; timer != 0; timer--) {
@@ -783,7 +772,7 @@
 
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%d)!!!\n", rval);
+		    "Failed to dump firmware (%x)!!!\n", rval);
 
 		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
 		ha->fw_dump = NULL;
@@ -793,6 +782,7 @@
 		    ha->host_no, ha->fw_dump);
 	}
 
+qla2100_fw_dump_failed:
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
