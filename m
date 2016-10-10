From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 09/12] scsi/ncr5380: Pass hostdata pointer to register
 polling routines
Date: Mon, 10 Oct 2016 00:46:53 -0400 (EDT)
Message-ID: <1f0da1fa6827b7329afdeee39161db6b51300afd.1476051962.git.fthain@telegraphics.com.au>
References: <cover.1476051961.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476051961.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Pass a NCR5380_hostdata struct pointer to the board-specific routines
instead of a Scsi_Host struct pointer. This reduces pointer chasing in
the PIO and PDMA fast paths. The old way was a mistake because it is
slow and the board-specific code is not concerned with the mid-layer.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/NCR5380.c  | 33 ++++++++++++++++-----------------
 drivers/scsi/NCR5380.h  |  6 +++---
 drivers/scsi/mac_scsi.c | 10 +++++-----
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index eb40561..3f2bfd2 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -178,7 +178,7 @@ static inline void initialize_SCp(struct scsi_cmnd *cmd)
 
 /**
  * NCR5380_poll_politely2 - wait for two chip register values
- * @instance: controller to poll
+ * @hostdata: host private data
  * @reg1: 5380 register to poll
  * @bit1: Bitmask to check
  * @val1: Expected value
@@ -195,12 +195,11 @@ static inline void initialize_SCp(struct scsi_cmnd *cmd)
  * Returns 0 if either or both event(s) occurred otherwise -ETIMEDOUT.
  */
 
-static int NCR5380_poll_politely2(struct Scsi_Host *instance,
+static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
                                   unsigned int reg1, u8 bit1, u8 val1,
                                   unsigned int reg2, u8 bit2, u8 val2,
                                   unsigned long wait)
 {
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned long n = hostdata->poll_loops;
 	unsigned long deadline = jiffies + wait;
 
@@ -561,7 +560,7 @@ static int NCR5380_maybe_reset_bus(struct Scsi_Host *instance)
 		case 3:
 		case 5:
 			shost_printk(KERN_ERR, instance, "SCSI bus busy, waiting up to five seconds\n");
-			NCR5380_poll_politely(instance,
+			NCR5380_poll_politely(hostdata,
 			                      STATUS_REG, SR_BSY, 0, 5 * HZ);
 			break;
 		case 2:
@@ -1076,7 +1075,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	 */
 
 	spin_unlock_irq(&hostdata->lock);
-	err = NCR5380_poll_politely2(instance, MODE_REG, MR_ARBITRATE, 0,
+	err = NCR5380_poll_politely2(hostdata, MODE_REG, MR_ARBITRATE, 0,
 	                INITIATOR_COMMAND_REG, ICR_ARBITRATION_PROGRESS,
 	                                       ICR_ARBITRATION_PROGRESS, HZ);
 	spin_lock_irq(&hostdata->lock);
@@ -1202,7 +1201,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	 * selection.
 	 */
 
-	err = NCR5380_poll_politely(instance, STATUS_REG, SR_BSY, SR_BSY,
+	err = NCR5380_poll_politely(hostdata, STATUS_REG, SR_BSY, SR_BSY,
 	                            msecs_to_jiffies(250));
 
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
@@ -1248,7 +1247,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 
 	/* Wait for start of REQ/ACK handshake */
 
-	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
+	err = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ);
 	spin_lock_irq(&hostdata->lock);
 	if (err < 0) {
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
@@ -1338,7 +1337,7 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 		 * valid
 		 */
 
-		if (NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
+		if (NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
 			break;
 
 		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ asserted\n");
@@ -1383,7 +1382,7 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
 		}
 
-		if (NCR5380_poll_politely(instance,
+		if (NCR5380_poll_politely(hostdata,
 		                          STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
 			break;
 
@@ -1483,7 +1482,7 @@ static int do_abort(struct Scsi_Host *instance)
 	 * the target sees, so we just handshake.
 	 */
 
-	rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, 10 * HZ);
+	rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, 10 * HZ);
 	if (rc < 0)
 		goto timeout;
 
@@ -1494,7 +1493,7 @@ static int do_abort(struct Scsi_Host *instance)
 	if (tmp != PHASE_MSGOUT) {
 		NCR5380_write(INITIATOR_COMMAND_REG,
 		              ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
-		rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 3 * HZ);
+		rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, 0, 3 * HZ);
 		if (rc < 0)
 			goto timeout;
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
@@ -1682,12 +1681,12 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 			 * byte.
 			 */
 
-			if (NCR5380_poll_politely(instance, BUS_AND_STATUS_REG,
+			if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 			                          BASR_DRQ, BASR_DRQ, HZ) < 0) {
 				result = -1;
 				shost_printk(KERN_ERR, instance, "PDMA read: DRQ timeout\n");
 			}
-			if (NCR5380_poll_politely(instance, STATUS_REG,
+			if (NCR5380_poll_politely(hostdata, STATUS_REG,
 			                          SR_REQ, 0, HZ) < 0) {
 				result = -1;
 				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
@@ -1698,7 +1697,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 			 * Wait for the last byte to be sent.  If REQ is being asserted for
 			 * the byte we're interested, we'll ACK it and it will go false.
 			 */
-			if (NCR5380_poll_politely2(instance,
+			if (NCR5380_poll_politely2(hostdata,
 			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
 			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, HZ) < 0) {
 				result = -1;
@@ -2077,7 +2076,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 			} /* switch(phase) */
 		} else {
 			spin_unlock_irq(&hostdata->lock);
-			NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
+			NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ);
 			spin_lock_irq(&hostdata->lock);
 		}
 	}
@@ -2123,7 +2122,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	 */
 
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
-	if (NCR5380_poll_politely(instance,
+	if (NCR5380_poll_politely(hostdata,
 	                          STATUS_REG, SR_SEL, 0, 2 * HZ) < 0) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		return;
@@ -2134,7 +2133,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	 * Wait for target to go into MSGIN.
 	 */
 
-	if (NCR5380_poll_politely(instance,
+	if (NCR5380_poll_politely(hostdata,
 	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
 		do_abort(instance);
 		return;
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index c2d8b78..4682baa 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -302,15 +302,15 @@ static void NCR5380_reselect(struct Scsi_Host *instance);
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
-static int NCR5380_poll_politely2(struct Scsi_Host *,
+static int NCR5380_poll_politely2(struct NCR5380_hostdata *,
                                   unsigned int, u8, u8,
                                   unsigned int, u8, u8, unsigned long);
 
-static inline int NCR5380_poll_politely(struct Scsi_Host *instance,
+static inline int NCR5380_poll_politely(struct NCR5380_hostdata *hostdata,
                                         unsigned int reg, u8 bit, u8 val,
                                         unsigned long wait)
 {
-	return NCR5380_poll_politely2(instance, reg, bit, val,
+	return NCR5380_poll_politely2(hostdata, reg, bit, val,
 						reg, bit, val, wait);
 }
 
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 9ac3822..07f956c 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -161,7 +161,7 @@ static int macscsi_pread(struct Scsi_Host *instance,
 	int n = len;
 	int transferred;
 
-	while (!NCR5380_poll_politely(instance, BUS_AND_STATUS_REG,
+	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
 	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
 		CP_IO_TO_MEM(s, d, n);
@@ -174,7 +174,7 @@ static int macscsi_pread(struct Scsi_Host *instance,
 			return 0;
 
 		/* Target changed phase early? */
-		if (NCR5380_poll_politely2(instance, STATUS_REG, SR_REQ, SR_REQ,
+		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
 		                           BUS_AND_STATUS_REG, BASR_ACK, BASR_ACK, HZ / 64) < 0)
 			scmd_printk(KERN_ERR, hostdata->connected,
 			            "%s: !REQ and !ACK\n", __func__);
@@ -264,7 +264,7 @@ static int macscsi_pwrite(struct Scsi_Host *instance,
 	int n = len;
 	int transferred;
 
-	while (!NCR5380_poll_politely(instance, BUS_AND_STATUS_REG,
+	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
 	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
 		CP_MEM_TO_IO(s, d, n);
@@ -273,7 +273,7 @@ static int macscsi_pwrite(struct Scsi_Host *instance,
 		hostdata->pdma_residual = len - transferred;
 
 		/* Target changed phase early? */
-		if (NCR5380_poll_politely2(instance, STATUS_REG, SR_REQ, SR_REQ,
+		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
 		                           BUS_AND_STATUS_REG, BASR_ACK, BASR_ACK, HZ / 64) < 0)
 			scmd_printk(KERN_ERR, hostdata->connected,
 			            "%s: !REQ and !ACK\n", __func__);
@@ -282,7 +282,7 @@ static int macscsi_pwrite(struct Scsi_Host *instance,
 
 		/* No bus error. */
 		if (n == 0) {
-			if (NCR5380_poll_politely(instance, TARGET_COMMAND_REG,
+			if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
 			                          TCR_LAST_BYTE_SENT,
 			                          TCR_LAST_BYTE_SENT, HZ / 64) < 0)
 				scmd_printk(KERN_ERR, hostdata->connected,
-- 
2.7.3
