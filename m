From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/47] qla1280: separate out host reset function from qla1280_error_action()
Date: Wed, 28 Jun 2017 10:32:38 +0200
Message-ID: <1498638793-44672-13-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53815 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751584AbdF1IdU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:20 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

There's not much in common between host reset and all other error
handlers, so use a separate function here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla1280.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 634254a..d712bfe 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -754,7 +754,6 @@ enum action {
 	ABORT_COMMAND,
 	DEVICE_RESET,
 	BUS_RESET,
-	ADAPTER_RESET,
 };
 
 
@@ -936,22 +935,9 @@ static void qla1280_mailbox_timeout(unsigned long __data)
 		}
 		break;
 
-	case ADAPTER_RESET:
 	default:
-		if (qla1280_verbose) {
-			printk(KERN_INFO
-			       "scsi(%ld): Issued ADAPTER RESET\n",
-			       ha->host_no);
-			printk(KERN_INFO "scsi(%ld): I/O processing will "
-			       "continue automatically\n", ha->host_no);
-		}
-		ha->flags.reset_active = 1;
-
-		if (qla1280_abort_isp(ha) != 0) {	/* it's dead */
-			result = FAILED;
-		}
-
-		ha->flags.reset_active = 0;
+		dprintk(1, "RESET invalid action %d\n", action);
+		return FAILED;
 	}
 
 	/*
@@ -1050,10 +1036,26 @@ static void qla1280_mailbox_timeout(unsigned long __data)
 qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
+	struct Scsi_Host *shost = cmd->device->host;
+	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = qla1280_error_action(cmd, ADAPTER_RESET);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
+	if (qla1280_verbose) {
+		printk(KERN_INFO
+		       "scsi(%ld): Issued ADAPTER RESET\n",
+		       ha->host_no);
+		printk(KERN_INFO "scsi(%ld): I/O processing will "
+		       "continue automatically\n", ha->host_no);
+	}
+	ha->flags.reset_active = 1;
+
+	if (qla1280_abort_isp(ha) != 0) {	/* it's dead */
+		rc = FAILED;
+	}
+
+	ha->flags.reset_active = 0;
+
+	spin_unlock_irq(shost->host_lock);
 
 	return rc;
 }
-- 
1.8.5.6
