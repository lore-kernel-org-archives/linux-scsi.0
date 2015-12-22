From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 70/77] atari_NCR5380: Merge changes from NCR5380.c
Date: Tue, 22 Dec 2015 12:18:48 +1100
Message-ID: <20151222011757.046049621@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-merge-trivia-from-NCR5380
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

In the past, atari_NCR5380.c was overlooked by those working on NCR5380.c
and this caused needless divergence. All of the changes in this patch were
taken from NCR5380.c.

This removes some unimportant discrepancies between the two core driver
forks so that 'diff' can be used to reveal the important ones, to
facilitate reunification.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |  108 +++++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 44 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:19.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:24.000000000 +1100
@@ -443,22 +443,39 @@ static struct {
 	unsigned char mask;
 	const char *name;
 } signals[] = {
-	{ SR_DBP, "PARITY"}, { SR_RST, "RST" }, { SR_BSY, "BSY" },
-	{ SR_REQ, "REQ" }, { SR_MSG, "MSG" }, { SR_CD,  "CD" }, { SR_IO, "IO" },
-	{ SR_SEL, "SEL" }, {0, NULL}
-}, basrs[] = {
-	{BASR_ATN, "ATN"}, {BASR_ACK, "ACK"}, {0, NULL}
-}, icrs[] = {
-	{ICR_ASSERT_RST, "ASSERT RST"},{ICR_ASSERT_ACK, "ASSERT ACK"},
-	{ICR_ASSERT_BSY, "ASSERT BSY"}, {ICR_ASSERT_SEL, "ASSERT SEL"},
-	{ICR_ASSERT_ATN, "ASSERT ATN"}, {ICR_ASSERT_DATA, "ASSERT DATA"},
+	{SR_DBP, "PARITY"},
+	{SR_RST, "RST"},
+	{SR_BSY, "BSY"},
+	{SR_REQ, "REQ"},
+	{SR_MSG, "MSG"},
+	{SR_CD, "CD"},
+	{SR_IO, "IO"},
+	{SR_SEL, "SEL"},
 	{0, NULL}
-}, mrs[] = {
-	{MR_BLOCK_DMA_MODE, "MODE BLOCK DMA"}, {MR_TARGET, "MODE TARGET"},
-	{MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"}, {MR_ENABLE_PAR_INTR,
-	"MODE PARITY INTR"}, {MR_ENABLE_EOP_INTR,"MODE EOP INTR"},
+},
+basrs[] = {
+	{BASR_ATN, "ATN"},
+	{BASR_ACK, "ACK"},
+	{0, NULL}
+},
+icrs[] = {
+	{ICR_ASSERT_RST, "ASSERT RST"},
+	{ICR_ASSERT_ACK, "ASSERT ACK"},
+	{ICR_ASSERT_BSY, "ASSERT BSY"},
+	{ICR_ASSERT_SEL, "ASSERT SEL"},
+	{ICR_ASSERT_ATN, "ASSERT ATN"},
+	{ICR_ASSERT_DATA, "ASSERT DATA"},
+	{0, NULL}
+},
+mrs[] = {
+	{MR_BLOCK_DMA_MODE, "MODE BLOCK DMA"},
+	{MR_TARGET, "MODE TARGET"},
+	{MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"},
+	{MR_ENABLE_PAR_INTR, "MODE PARITY INTR"},
+	{MR_ENABLE_EOP_INTR, "MODE EOP INTR"},
 	{MR_MONITOR_BSY, "MODE MONITOR BSY"},
-	{MR_DMA_MODE, "MODE DMA"}, {MR_ARBITRATE, "MODE ARBITRATION"},
+	{MR_DMA_MODE, "MODE DMA"},
+	{MR_ARBITRATE, "MODE ARBITRATION"},
 	{0, NULL}
 };
 
@@ -502,8 +519,12 @@ static struct {
 	unsigned char value;
 	const char *name;
 } phases[] = {
-	{PHASE_DATAOUT, "DATAOUT"}, {PHASE_DATAIN, "DATAIN"}, {PHASE_CMDOUT, "CMDOUT"},
-	{PHASE_STATIN, "STATIN"}, {PHASE_MSGOUT, "MSGOUT"}, {PHASE_MSGIN, "MSGIN"},
+	{PHASE_DATAOUT, "DATAOUT"},
+	{PHASE_DATAIN, "DATAIN"},
+	{PHASE_CMDOUT, "CMDOUT"},
+	{PHASE_STATIN, "STATIN"},
+	{PHASE_MSGOUT, "MSGOUT"},
+	{PHASE_MSGIN, "MSGIN"},
 	{PHASE_UNKNOWN, "UNKNOWN"}
 };
 
@@ -529,7 +550,6 @@ static void NCR5380_print_phase(struct S
 		shost_printk(KERN_DEBUG, instance, "phase %s\n", phases[i].name);
 	}
 }
-
 #endif
 
 /**
@@ -1488,9 +1508,9 @@ static int NCR5380_transfer_pio(struct S
 				unsigned char *phase, int *count,
 				unsigned char **data)
 {
-	register unsigned char p = *phase, tmp;
-	register int c = *count;
-	register unsigned char *d = *data;
+	unsigned char p = *phase, tmp;
+	int c = *count;
+	unsigned char *d = *data;
 
 	/*
 	 * The NCR5380 chip will only drive the SCSI bus when the
@@ -1557,17 +1577,17 @@ static int NCR5380_transfer_pio(struct S
 
 		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ negated, handshake complete\n");
 
-		/*
-		 * We have several special cases to consider during REQ/ACK handshaking :
-		 * 1.  We were in MSGOUT phase, and we are on the last byte of the
-		 * message.  ATN must be dropped as ACK is dropped.
-		 *
-		 * 2.  We are in a MSGIN phase, and we are on the last byte of the
-		 * message.  We must exit with ACK asserted, so that the calling
-		 * code may raise ATN before dropping ACK to reject the message.
-		 *
-		 * 3.  ACK and ATN are clear and the target may proceed as normal.
-		 */
+/*
+ * We have several special cases to consider during REQ/ACK handshaking :
+ * 1.  We were in MSGOUT phase, and we are on the last byte of the
+ * message.  ATN must be dropped as ACK is dropped.
+ *
+ * 2.  We are in a MSGIN phase, and we are on the last byte of the
+ * message.  We must exit with ACK asserted, so that the calling
+ * code may raise ATN before dropping ACK to reject the message.
+ *
+ * 3.  ACK and ATN are clear and the target may proceed as normal.
+ */
 		if (!(p == PHASE_MSGIN && c == 1)) {
 			if (p == PHASE_MSGOUT && c > 1)
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
@@ -1632,7 +1652,7 @@ static void do_reset(struct Scsi_Host *i
 
 static int do_abort(struct Scsi_Host *instance)
 {
-	unsigned char tmp, *msgptr, phase;
+	unsigned char *msgptr, phase, tmp;
 	int len;
 	int rc;
 
@@ -2091,18 +2111,18 @@ static void NCR5380_information_transfer
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					break;
 				case EXTENDED_MESSAGE:
-					/*
-					 * Extended messages are sent in the following format :
-					 * Byte
-					 * 0		EXTENDED_MESSAGE == 1
-					 * 1		length (includes one byte for code, doesn't
-					 * include first two bytes)
-					 * 2		code
-					 * 3..length+1	arguments
-					 *
-					 * Start the extended message buffer with the EXTENDED_MESSAGE
-					 * byte, since spi_print_msg() wants the whole thing.
-					 */
+/*
+ * Extended messages are sent in the following format :
+ * Byte
+ * 0            EXTENDED_MESSAGE == 1
+ * 1            length (includes one byte for code, doesn't
+ * include first two bytes)
+ * 2            code
+ * 3..length+1  arguments
+ *
+ * Start the extended message buffer with the EXTENDED_MESSAGE
+ * byte, since spi_print_msg() wants the whole thing.
+ */
 					extended_msg[0] = EXTENDED_MESSAGE;
 					/* Accept first byte by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
