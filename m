From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 03/10] NCR5380: Have NCR5380_select() return a bool
Date: Thu, 27 Sep 2018 11:17:11 +1000
Message-ID: <2b5072b0f2b9461aaa345065de91e727089841c5.1538011031.git.fthain@telegraphics.com.au>
References: <cover.1538011031.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538011031.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, Ondrey Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The return value is taken to mean "retry" or "don't retry". Change it to
bool to improve readability. Fix related comments. No functional change.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 46 +++++++++++++++++++++-------------------------
 drivers/scsi/NCR5380.h |  2 +-
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index c6d10780febe..7be1ba2b9e4e 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -902,20 +902,16 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-/*
- * Function : int NCR5380_select(struct Scsi_Host *instance,
- * struct scsi_cmnd *cmd)
- *
- * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
- * including ARBITRATION, SELECTION, and initial message out for
- * IDENTIFY and queue messages.
+/**
+ * NCR5380_select - attempt arbitration and selection for a given command
+ * @instance: the Scsi_Host instance
+ * @cmd: the scsi_cmnd to execute
  *
- * Inputs : instance - instantiation of the 5380 driver on which this
- * target lives, cmd - SCSI command to execute.
+ * This routine establishes an I_T_L nexus for a SCSI command. This involves
+ * ARBITRATION, SELECTION and MESSAGE OUT phases and an IDENTIFY message.
  *
- * Returns cmd if selection failed but should be retried,
- * NULL if selection failed and should not be retried, or
- * NULL if selection succeeded (hostdata->connected == cmd).
+ * Returns true if the operation should be retried.
+ * Returns false if it should not be retried.
  *
  * Side effects :
  * If bus busy, arbitration failed, etc, NCR5380_select() will exit
@@ -923,16 +919,15 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
  * SELECT_ENABLE will be set appropriately, the NCR5380
  * will cease to drive any SCSI bus signals.
  *
- * If successful : I_T_L or I_T_L_Q nexus will be established,
- * instance->connected will be set to cmd.
+ * If successful : the I_T_L nexus will be established, and
+ * hostdata->connected will be set to cmd.
  * SELECT interrupt will be disabled.
  *
  * If failed (no target) : cmd->scsi_done() will be called, and the
  * cmd->result host byte set to DID_BAD_TARGET.
  */
 
-static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
-                                        struct scsi_cmnd *cmd)
+static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	__releases(&hostdata->lock) __acquires(&hostdata->lock)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
@@ -940,6 +935,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	unsigned char *data;
 	int len;
 	int err;
+	bool ret = true;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
@@ -948,7 +944,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	/*
 	 * Arbitration and selection phases are slow and involve dropping the
 	 * lock, so we have to watch out for EH. An exception handler may
-	 * change 'selecting' to NULL. This function will then return NULL
+	 * change 'selecting' to NULL. This function will then return false
 	 * so that the caller will forget about 'cmd'. (During information
 	 * transfer phases, EH may change 'connected' to NULL.)
 	 */
@@ -984,7 +980,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	if (!hostdata->selecting) {
 		/* Command was aborted */
 		NCR5380_write(MODE_REG, MR_BASE);
-		return NULL;
+		return false;
 	}
 	if (err < 0) {
 		NCR5380_write(MODE_REG, MR_BASE);
@@ -1033,7 +1029,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	if (!hostdata->selecting) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		return NULL;
+		return false;
 	}
 
 	dsprintk(NDEBUG_ARBITRATION, instance, "won arbitration\n");
@@ -1119,13 +1115,13 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 
 		/* Can't touch cmd if it has been reclaimed by the scsi ML */
 		if (!hostdata->selecting)
-			return NULL;
+			return false;
 
 		cmd->result = DID_BAD_TARGET << 16;
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance,
 			"target did not respond within 250ms\n");
-		cmd = NULL;
+		ret = false;
 		goto out;
 	}
 
@@ -1158,7 +1154,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	}
 	if (!hostdata->selecting) {
 		do_abort(instance);
-		return NULL;
+		return false;
 	}
 
 	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",
@@ -1174,7 +1170,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 		cmd->result = DID_ERROR << 16;
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance, "IDENTIFY message transfer failed\n");
-		cmd = NULL;
+		ret = false;
 		goto out;
 	}
 
@@ -1189,13 +1185,13 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 
 	initialize_SCp(cmd);
 
-	cmd = NULL;
+	ret = false;
 
 out:
 	if (!hostdata->selecting)
 		return NULL;
 	hostdata->selecting = NULL;
-	return cmd;
+	return ret;
 }
 
 /*
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 31096a0b0fdd..efca509b92b0 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -275,7 +275,7 @@ static irqreturn_t NCR5380_intr(int irq, void *dev_id);
 static void NCR5380_main(struct work_struct *work);
 static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
-static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
+static bool NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_poll_politely2(struct NCR5380_hostdata *,
-- 
2.16.4
