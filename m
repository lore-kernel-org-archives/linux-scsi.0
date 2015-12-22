From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 71/77] ncr5380: Cleanup whitespace and parentheses
Date: Tue, 22 Dec 2015 12:18:49 +1100
Message-ID: <20151222011757.347912867@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-fix-whitespace-and-trivia
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   30 +++++++++++++++++++-----------
 drivers/scsi/atari_NCR5380.c |   26 +++++++++++++-------------
 2 files changed, 32 insertions(+), 24 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:17:23.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:17:26.000000000 +1100
@@ -1113,7 +1113,7 @@ static struct scsi_cmnd *NCR5380_select(
 	 * the host and target ID's on the SCSI bus.
 	 */
 
-	NCR5380_write(OUTPUT_DATA_REG, (hostdata->id_mask | (1 << scmd_id(cmd))));
+	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask | (1 << scmd_id(cmd)));
 
 	/*
 	 * Raise ATN while SEL is true before BSY goes false from arbitration,
@@ -1121,7 +1121,8 @@ static struct scsi_cmnd *NCR5380_select(
 	 * phase immediately after selection.
 	 */
 
-	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_BSY | ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL));
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY |
+	              ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL);
 	NCR5380_write(MODE_REG, MR_BASE);
 
 	/*
@@ -1139,7 +1140,8 @@ static struct scsi_cmnd *NCR5380_select(
 	udelay(1);        /* wingel -- wait two bus deskew delay >2*45ns */
 
 	/* Reset BSY */
-	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL));
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA |
+	              ICR_ASSERT_ATN | ICR_ASSERT_SEL);
 
 	/*
 	 * Something weird happens when we cease to drive BSY - looks
@@ -1249,7 +1251,7 @@ static struct scsi_cmnd *NCR5380_select(
 	/* XXX need to handle errors here */
 
 	hostdata->connected = cmd;
-	hostdata->busy[cmd->device->id] |= (1 << (cmd->device->lun & 0xFF));
+	hostdata->busy[cmd->device->id] |= 1 << cmd->device->lun;
 
 	initialize_SCp(cmd);
 
@@ -1340,11 +1342,14 @@ static int NCR5380_transfer_pio(struct S
 			if (!((p & SR_MSG) && c > 1)) {
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA);
 				NCR5380_dprint(NDEBUG_PIO, instance);
-				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_ACK);
+				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
+				              ICR_ASSERT_DATA | ICR_ASSERT_ACK);
 			} else {
-				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_ATN);
+				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
+				              ICR_ASSERT_DATA | ICR_ASSERT_ATN);
 				NCR5380_dprint(NDEBUG_PIO, instance);
-				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
+				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
+				              ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
 			}
 		} else {
 			NCR5380_dprint(NDEBUG_PIO, instance);
@@ -1775,10 +1780,12 @@ static void NCR5380_information_transfer
 			if (sink && (phase != PHASE_MSGOUT)) {
 				NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
-				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
+				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN |
+				              ICR_ASSERT_ACK);
 				while (NCR5380_read(STATUS_REG) & SR_REQ)
 					;
-				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
+				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
+				              ICR_ASSERT_ATN);
 				sink = 0;
 				continue;
 			}
@@ -1848,8 +1855,9 @@ static void NCR5380_information_transfer
 #endif				/* defined(PSEUDO_DMA) || defined(REAL_DMA_POLL) */
 				{
 					spin_unlock_irq(&hostdata->lock);
-					NCR5380_transfer_pio(instance, &phase, (int *) &cmd->SCp.this_residual, (unsigned char **)
-							     &cmd->SCp.ptr);
+					NCR5380_transfer_pio(instance, &phase,
+					                     (int *)&cmd->SCp.this_residual,
+					                     (unsigned char **)&cmd->SCp.ptr);
 					spin_lock_irq(&hostdata->lock);
 				}
 				break;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:24.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:26.000000000 +1100
@@ -1314,7 +1314,7 @@ static struct scsi_cmnd *NCR5380_select(
 	 * the host and target ID's on the SCSI bus.
 	 */
 
-	NCR5380_write(OUTPUT_DATA_REG, (hostdata->id_mask | (1 << cmd->device->id)));
+	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask | (1 << scmd_id(cmd)));
 
 	/*
 	 * Raise ATN while SEL is true before BSY goes false from arbitration,
@@ -1322,8 +1322,8 @@ static struct scsi_cmnd *NCR5380_select(
 	 * phase immediately after selection.
 	 */
 
-	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_BSY |
-		      ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL ));
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY |
+	              ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL);
 	NCR5380_write(MODE_REG, MR_BASE);
 
 	/*
@@ -1341,8 +1341,8 @@ static struct scsi_cmnd *NCR5380_select(
 	udelay(1);        /* wingel -- wait two bus deskew delay >2*45ns */
 
 	/* Reset BSY */
-	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_DATA |
-		      ICR_ASSERT_ATN | ICR_ASSERT_SEL));
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA |
+	              ICR_ASSERT_ATN | ICR_ASSERT_SEL);
 
 	/*
 	 * Something weird happens when we cease to drive BSY - looks
@@ -1462,7 +1462,7 @@ static struct scsi_cmnd *NCR5380_select(
 
 	hostdata->connected = cmd;
 #ifndef SUPPORT_TAGS
-	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+	hostdata->busy[cmd->device->id] |= 1 << cmd->device->lun;
 #endif
 #ifdef SUN3_SCSI_VME
 	dregs->csr |= CSR_INTR;
@@ -1558,13 +1558,13 @@ static int NCR5380_transfer_pio(struct S
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA);
 				NCR5380_dprint(NDEBUG_PIO, instance);
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
-					      ICR_ASSERT_DATA | ICR_ASSERT_ACK);
+				              ICR_ASSERT_DATA | ICR_ASSERT_ACK);
 			} else {
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
-					      ICR_ASSERT_DATA | ICR_ASSERT_ATN);
+				              ICR_ASSERT_DATA | ICR_ASSERT_ATN);
 				NCR5380_dprint(NDEBUG_PIO, instance);
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
-					      ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
+				              ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
 			}
 		} else {
 			NCR5380_dprint(NDEBUG_PIO, instance);
@@ -1892,11 +1892,11 @@ static void NCR5380_information_transfer
 				NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN |
-					      ICR_ASSERT_ACK);
+				              ICR_ASSERT_ACK);
 				while (NCR5380_read(STATUS_REG) & SR_REQ)
 					;
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
-					      ICR_ASSERT_ATN);
+				              ICR_ASSERT_ATN);
 				sink = 0;
 				continue;
 			}
@@ -1985,8 +1985,8 @@ static void NCR5380_information_transfer
 				{
 					spin_unlock_irq(&hostdata->lock);
 					NCR5380_transfer_pio(instance, &phase,
-							     (int *)&cmd->SCp.this_residual,
-							     (unsigned char **)&cmd->SCp.ptr);
+					                     (int *)&cmd->SCp.this_residual,
+					                     (unsigned char **)&cmd->SCp.ptr);
 					spin_lock_irq(&hostdata->lock);
 				}
 #if defined(CONFIG_SUN3) && defined(REAL_DMA)
