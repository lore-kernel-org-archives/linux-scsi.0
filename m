From: Ondrej Zary <linux@zary.sk>
Subject: [PATCH] wd719x: Fix resets and aborts
Date: Sat,  1 Jun 2019 12:08:57 +0200
Message-ID: <20190601100857.22917-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, David Rientjes <rientjes@google.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Host reset oopses because it calls wd719x_chip_init, which calls
request_firmware, under a spinlock. Stop the RISC first, then flush
active SCBs under a spinlock. Finally call wd719x_chip_init unlocked.

Also found and fixed more bugs during tests:

Affected active SCBs were not flushed during abort, bus and device
reset. This caused problems in a following host reset (hang or oops).

Device and bus reset failed under load because the result of the reset
command is WD719X_SUE_TERM or WD719X_SUE_RESET. Don't treat these codes
as error in wd719x_wait_done.

wd719x_direct_cmd for RESET/ABORT commands didn't work properly,
causing timeouts. Looks like it was caused by the WD719X_DISABLE_INT
bit. Not setting it for RESET/ABORT commands seems to fix the probem.
Also lower the log level of the corresponding "direct command
completed" message to debug.

Unfortunately, my documentation is missing some pages, including page
67 (SPIDER67.gif) about resets :(

Reported-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/wd719x.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index e3310e9488d2..2b44b0be2e00 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -107,8 +107,15 @@ static inline int wd719x_wait_done(struct wd719x *wd, int timeout)
 	}
 
 	if (status != WD719X_INT_NOERRORS) {
+		u8 sue = wd719x_readb(wd, WD719X_AMR_SCB_ERROR);
+		/* we get this after wd719x_dev_reset, it's not an error */
+		if (sue == WD719X_SUE_TERM)
+			return 0;
+		/* we get this after wd719x_bus_reset, it's not an error */
+		if (sue == WD719X_SUE_RESET)
+			return 0;
 		dev_err(&wd->pdev->dev, "direct command failed, status 0x%02x, SUE 0x%02x\n",
-			status, wd719x_readb(wd, WD719X_AMR_SCB_ERROR));
+			status, sue);
 		return -EIO;
 	}
 
@@ -127,8 +134,10 @@ static int wd719x_direct_cmd(struct wd719x *wd, u8 opcode, u8 dev, u8 lun,
 	if (wd719x_wait_ready(wd))
 		return -ETIMEDOUT;
 
-	/* make sure we get NO interrupts */
-	dev |= WD719X_DISABLE_INT;
+	/* disable interrupts except for RESET/ABORT (it breaks them) */
+	if (opcode != WD719X_CMD_BUSRESET && opcode != WD719X_CMD_ABORT &&
+	    opcode != WD719X_CMD_ABORT_TAG && opcode != WD719X_CMD_RESET)
+		dev |= WD719X_DISABLE_INT;
 	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM, dev);
 	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM_2, lun);
 	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM_3, tag);
@@ -464,6 +473,7 @@ static int wd719x_abort(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(wd->sh->host_lock, flags);
 	result = wd719x_direct_cmd(wd, action, cmd->device->id,
 				   cmd->device->lun, cmd->tag, scb->phys, 0);
+	wd719x_finish_cmd(scb, DID_ABORT);
 	spin_unlock_irqrestore(wd->sh->host_lock, flags);
 	if (result)
 		return FAILED;
@@ -476,6 +486,7 @@ static int wd719x_reset(struct scsi_cmnd *cmd, u8 opcode, u8 device)
 	int result;
 	unsigned long flags;
 	struct wd719x *wd = shost_priv(cmd->device->host);
+	struct wd719x_scb *scb, *tmp;
 
 	dev_info(&wd->pdev->dev, "%s reset requested\n",
 		 (opcode == WD719X_CMD_BUSRESET) ? "bus" : "device");
@@ -483,6 +494,12 @@ static int wd719x_reset(struct scsi_cmnd *cmd, u8 opcode, u8 device)
 	spin_lock_irqsave(wd->sh->host_lock, flags);
 	result = wd719x_direct_cmd(wd, opcode, device, 0, 0, 0,
 				   WD719X_WAIT_FOR_SCSI_RESET);
+	/* flush all SCBs (or all for a device if dev_reset) */
+	list_for_each_entry_safe(scb, tmp, &wd->active_scbs, list) {
+		if (opcode == WD719X_CMD_BUSRESET ||
+		    scb->cmd->device->id == device)
+			wd719x_finish_cmd(scb, DID_RESET);
+	}
 	spin_unlock_irqrestore(wd->sh->host_lock, flags);
 	if (result)
 		return FAILED;
@@ -505,22 +522,23 @@ static int wd719x_host_reset(struct scsi_cmnd *cmd)
 	struct wd719x *wd = shost_priv(cmd->device->host);
 	struct wd719x_scb *scb, *tmp;
 	unsigned long flags;
-	int result;
 
 	dev_info(&wd->pdev->dev, "host reset requested\n");
 	spin_lock_irqsave(wd->sh->host_lock, flags);
-	/* Try to reinit the RISC */
-	if (wd719x_chip_init(wd) == 0)
-		result = SUCCESS;
-	else
-		result = FAILED;
+	/* stop the RISC */
+	if (wd719x_direct_cmd(wd, WD719X_CMD_SLEEP, 0, 0, 0, 0,
+			      WD719X_WAIT_FOR_RISC))
+		dev_warn(&wd->pdev->dev, "RISC sleep command failed\n");
+	/* disable RISC */
+	wd719x_writeb(wd, WD719X_PCI_MODE_SELECT, 0);
 
 	/* flush all SCBs */
 	list_for_each_entry_safe(scb, tmp, &wd->active_scbs, list)
-		wd719x_finish_cmd(scb, result);
+		wd719x_finish_cmd(scb, DID_RESET);
 	spin_unlock_irqrestore(wd->sh->host_lock, flags);
 
-	return result;
+	/* Try to reinit the RISC */
+	return wd719x_chip_init(wd) == 0 ? SUCCESS : FAILED;
 }
 
 static int wd719x_biosparam(struct scsi_device *sdev, struct block_device *bdev,
@@ -672,7 +690,7 @@ static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
 			else
 				dev_err(&wd->pdev->dev, "card returned invalid SCB pointer\n");
 		} else
-			dev_warn(&wd->pdev->dev, "direct command 0x%x completed\n",
+			dev_dbg(&wd->pdev->dev, "direct command 0x%x completed\n",
 				 regs.bytes.OPC);
 		break;
 	case WD719X_INT_PIOREADY:
-- 
Ondrej Zary
