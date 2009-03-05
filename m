From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/2] cciss: kernel thread to detect changes on MSA2012
Date: Thu, 5 Mar 2009 17:26:47 -0600
Message-ID: <20090305232647.GA24830@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:31017 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbZCEX0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 18:26:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, coldwell@redhat.com
Cc: LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

PATCH 1 of 2

The MSA2000 the firmware cannot tell the driver to rescan when logical
drives are added or deleted. This patch adds a check for unit attentions and
if a change in the topology is detected a kernel thread will fire off and
call rebuild_lun_table to update the drivers view of the world.

The MSA2012 uses out of band management for configuration unlike any other
storage box we support. This is the reason for this patch.

Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d2cb67b..d745d8c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -186,6 +186,7 @@ static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 			   __u8 page_code, int cmd_type);
 
 static void fail_all_cmds(unsigned long ctlr);
+static int scan_thread(ctlr_info_t *h);
 
 #ifdef CONFIG_PROC_FS
 static void cciss_procinit(int i);
@@ -3008,6 +3009,69 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int scan_thread(ctlr_info_t *h)
+{
+	int rc;
+
+	DECLARE_COMPLETION(wait);
+	INIT_COMPLETION(wait);
+	h->rescan_wait = &wait;
+
+	for (;;) {
+		rc = wait_for_completion_timeout(&wait);
+		if (!rc)
+			continue;
+		else
+			rebuild_lun_table(h, 0);
+
+		INIT_COMPLETION(wait);
+	}
+
+	return 0;
+}
+
+static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
+{
+	if (CMD_TARGET_STATUS && (c->err_info->ScsiStatus ==
+			SAM_STAT_CHECK_CONDITION) &&
+			c->err_info->SenseInfo[2] == UNIT_ATTENTION) {
+		switch (c->err_info->SenseInfo[12]) {
+		case STATE_CHANGED:
+			printk(KERN_WARNING "cciss%d: a state change "
+				"detected, command retried\n", h->ctlr);
+			return 1;
+		break;
+		case LUN_FAILED:
+			printk(KERN_WARNING "cciss%d: LUN failure "
+				"detected, action required\n", h->ctlr);
+			return 1;
+		break;
+		case REPORT_LUNS_CHANGED:
+			printk(KERN_WARNING "cciss%d: report LUN data "
+				"changed\n", h->ctlr);
+			if (h->rescan_wait)
+				complete(h->rescan_wait);
+			return 1;
+		break;
+		case POWER_OR_RESET:
+			printk(KERN_WARNING "cciss%d: a power on "
+				"or device reset detected\n", h->ctlr);
+			return 1;
+		break;
+		case UNIT_ATTENTION_CLEARED:
+			printk(KERN_WARNING "cciss%d: unit attention "
+			    "cleared by another initiator\n", h->ctlr);
+			return 1;
+		break;
+		default:
+			printk(KERN_WARNING "cciss%d: unknown "
+				"unit attention detected\n", h->ctlr);
+				return 1;
+		}
+	}
+	return 0;
+}
+
 /*
  *  We cannot read the structure directly, for portability we must use
  *   the io functions.
@@ -3600,6 +3664,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int rc;
 	int dac, return_code;
 	InquiryData_struct *inq_buff = NULL;
+	struct task_struct *cciss_scan_thread;
 
 	if (reset_devices) {
 		/* Reset the controller with a PCI power-cycle */
@@ -3751,6 +3816,11 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	hba[i]->busy_initializing = 0;
 
 	rebuild_lun_table(hba[i], 1);
+	cciss_scan_thread = kthread((void *)scan_thread, hba[i],
+				"scan_thread");
+	if (IS_ERR(cciss_scan_thread))
+		return PTR_ERR(cciss_scan_thread);
+
 	return 1;
 
 clean4:
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 15e2b84..c85783f 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -121,6 +121,7 @@ struct ctlr_info
 	struct sendcmd_reject_list scsi_rejects;
 #endif
 	unsigned char alive;
+	struct completion *rescan_wait;
 };
 
 /*  Defining the diffent access_menthods */
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index 24e22de..40b1b92 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -25,6 +25,29 @@
 #define CMD_TIMEOUT             0x000B
 #define CMD_UNABORTABLE		0x000C
 
+/* Unit Attentions ASC's as defined for the MSA2012sa */
+#define POWER_OR_RESET			0x29
+#define STATE_CHANGED			0x2a
+#define UNIT_ATTENTION_CLEARED		0x2f
+#define LUN_FAILED			0x3e
+#define REPORT_LUNS_CHANGED		0x3f
+
+/* Unit Attentions ASCQ's as defined for the MSA2012sa */
+
+	/* These ASCQ's defined for ASC = POWER_OR_RESET */
+#define POWER_ON_RESET			0x00
+#define POWER_ON_REBOOT			0x01
+#define SCSI_BUS_RESET			0x02
+#define MSA_TARGET_RESET		0x03
+#define CONTROLLER_FAILOVER		0x04
+#define TRANSCEIVER_SE			0x05
+#define TRANSCEIVER_LVD			0x06
+
+	/* These ASCQ's defined for ASC = STATE_CHANGED */
+#define RESERVATION_PREEMPTED		0x03
+#define ASYM_ACCESS_CHANGED		0x06
+#define LUN_CAPACITY_CHANGED		0x09
+
 //transfer direction
 #define XFER_NONE               0x00
 #define XFER_WRITE              0x01
