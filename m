From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 07/10] NCR5380: Don't clear busy flag when abort fails
Date: Thu, 27 Sep 2018 11:17:11 +1000
Message-ID: <a40937ad84c336bc368acac92e9275d126d32a14.1538011031.git.fthain@telegraphics.com.au>
References: <cover.1538011031.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538011031.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, Ondrey Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When NCR5380_abort() returns FAILED, the driver forgets that the target
is still busy. Hence, further commands may be sent to the target, which
may fail during selection and produce the error message, "reselection
after won arbitration?". Prevent this by leaving the busy flag set when
NCR5380_abort() fails.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
Consistent with the rest of NCR5380.c, this patch triggers some
"line over 80 characters" messages from checkpatch.pl. I haven't
addressed those complaints because IMHO the cure is worse than
the disease. Refactoring to reduce indentation levels would be
a lot of churn.
---
 drivers/scsi/NCR5380.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 3058b68b6740..5826421146ba 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -522,8 +522,6 @@ static void complete_cmd(struct Scsi_Host *instance,
 		hostdata->sensing = NULL;
 	}
 
-	hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
-
 	cmd->scsi_done(cmd);
 }
 
@@ -1713,6 +1711,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				cmd->result = DID_ERROR << 16;
 				complete_cmd(instance, cmd);
 				hostdata->connected = NULL;
+				hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 				return;
 #endif
 			case PHASE_DATAIN:
@@ -1795,6 +1794,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					         cmd, scmd_id(cmd), cmd->device->lun);
 
 					hostdata->connected = NULL;
+					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 
 					cmd->result &= ~0xffff;
 					cmd->result |= cmd->SCp.Status;
@@ -1953,6 +1953,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
 					hostdata->connected = NULL;
+					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 					cmd->result = DID_ERROR << 16;
 					complete_cmd(instance, cmd);
 					maybe_release_dma_irq(instance);
@@ -2108,13 +2109,16 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		dsprintk(NDEBUG_RESELECTION | NDEBUG_QUEUES, instance,
 		         "reselect: removed %p from disconnected queue\n", tmp);
 	} else {
+		int target = ffs(target_mask) - 1;
+
 		shost_printk(KERN_ERR, instance, "target bitmask 0x%02x lun %d not in disconnected queue.\n",
 		             target_mask, lun);
 		/*
 		 * Since we have an established nexus that we can't do anything
 		 * with, we must abort it.
 		 */
-		do_abort(instance);
+		if (do_abort(instance) == 0)
+			hostdata->busy[target] &= ~(1 << lun);
 		return;
 	}
 
@@ -2285,8 +2289,10 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 out:
 	if (result == FAILED)
 		dsprintk(NDEBUG_ABORT, instance, "abort: failed to abort %p\n", cmd);
-	else
+	else {
+		hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 		dsprintk(NDEBUG_ABORT, instance, "abort: successfully aborted %p\n", cmd);
+	}
 
 	queue_work(hostdata->work_q, &hostdata->main_task);
 	maybe_release_dma_irq(instance);
-- 
2.16.4
