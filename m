From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/35] sym53c8xx_2: split off bus reset from host reset
Date: Fri, 23 Jun 2017 15:02:40 +0200
Message-ID: <1498222975-71858-21-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754185AbdFWND3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:29 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The current handler does both, bus reset and host reset.
So split them off into two distinct functions.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 106 ++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d32e3ba..985de9c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -581,8 +581,6 @@ static void sym53c8xx_timer(unsigned long npref)
  */
 #define SYM_EH_ABORT		0
 #define SYM_EH_DEVICE_RESET	1
-#define SYM_EH_BUS_RESET	2
-#define SYM_EH_HOST_RESET	3
 
 /*
  *  Generic method for our eh processing.
@@ -602,35 +600,11 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 
 	scmd_printk(KERN_WARNING, cmd, "%s operation started\n", opname);
 
-	/* We may be in an error condition because the PCI bus
-	 * went down. In this case, we need to wait until the
-	 * PCI bus is reset, the card is reset, and only then
-	 * proceed with the scsi error recovery.  There's no
-	 * point in hurrying; take a leisurely wait.
+	/*
+	 * Escalate to host reset if the PCI bus went down
 	 */
-#define WAIT_FOR_PCI_RECOVERY	35
-	if (pci_channel_offline(pdev)) {
-		int finished_reset = 0;
-		init_completion(&eh_done);
-		spin_lock_irq(shost->host_lock);
-		/* Make sure we didn't race */
-		if (pci_channel_offline(pdev)) {
-			BUG_ON(sym_data->io_reset);
-			sym_data->io_reset = &eh_done;
-		} else {
-			finished_reset = 1;
-		}
-		spin_unlock_irq(shost->host_lock);
-		if (!finished_reset)
-			finished_reset = wait_for_completion_timeout
-						(sym_data->io_reset,
-						WAIT_FOR_PCI_RECOVERY*HZ);
-		spin_lock_irq(shost->host_lock);
-		sym_data->io_reset = NULL;
-		spin_unlock_irq(shost->host_lock);
-		if (!finished_reset)
-			return SCSI_FAILED;
-	}
+	if (pci_channel_offline(pdev))
+		return SCSI_FAILED;
 
 	spin_lock_irq(shost->host_lock);
 	/* This one is queued in some place -> to wait for completion */
@@ -651,15 +625,6 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	case SYM_EH_DEVICE_RESET:
 		sts = sym_reset_scsi_target(np, cmd->device->id);
 		break;
-	case SYM_EH_BUS_RESET:
-		sym_reset_scsi_bus(np, 1);
-		sts = 0;
-		break;
-	case SYM_EH_HOST_RESET:
-		sym_reset_scsi_bus(np, 0);
-		sym_start_up(shost, 1);
-		sts = 0;
-		break;
 	default:
 		break;
 	}
@@ -701,12 +666,71 @@ static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
+	struct Scsi_Host *shost = cmd->device->host;
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
+
+	scmd_printk(KERN_WARNING, cmd, "BUS RESET operation started\n");
+
+	/*
+	 * Escalate to host reset if the PCI bus went down
+	 */
+	if (pci_channel_offline(pdev))
+		return SCSI_FAILED;
+
+	spin_lock_irq(shost->host_lock);
+	sym_reset_scsi_bus(np, 1);
+	spin_unlock_irq(shost->host_lock);
+
+	dev_warn(&cmd->device->sdev_gendev, "BUS RESET operation complete.\n");
+	return SCSI_SUCCESS;
 }
 
 static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
+	struct sym_data *sym_data = shost_priv(cmd->device->shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
+	struct completion eh_done;
+	int finished_reset = 1;
+
+	shost_printk(KERN_WARNING, shost, "HOST RESET operation started\n");
+
+	/* We may be in an error condition because the PCI bus
+	 * went down. In this case, we need to wait until the
+	 * PCI bus is reset, the card is reset, and only then
+	 * proceed with the scsi error recovery.  There's no
+	 * point in hurrying; take a leisurely wait.
+	 */
+#define WAIT_FOR_PCI_RECOVERY	35
+	if (pci_channel_offline(pdev)) {
+		init_completion(&eh_done);
+		spin_lock_irq(shost->host_lock);
+		/* Make sure we didn't race */
+		if (pci_channel_offline(pdev)) {
+			BUG_ON(sym_data->io_reset);
+			sym_data->io_reset = &eh_done;
+			finished_reset = 0;
+		}
+		spin_unlock_irq(shost->host_lock);
+		if (!finished_reset)
+			finished_reset = wait_for_completion_timeout
+						(sym_data->io_reset,
+						WAIT_FOR_PCI_RECOVERY*HZ);
+		spin_lock_irq(shost->host_lock);
+		sym_data->io_reset = NULL;
+		spin_unlock_irq(shost->host_lock);
+	}
+
+	if (finished_reset) {
+		sym_reset_scsi_bus(np, 0);
+		sym_start_up(shost, 1);
+	}
+
+	shost_printk(KERN_WARNING, shost, "HOST RESET operation %s.\n",
+			finished_reset==1 ? "complete" : "failed");
+	return finished_reset ? SCSI_SUCCESS : SCSI_FAILED;
 }
 
 /*
-- 
1.8.5.6
