From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 49/71] atari_NCR5380: Introduce FLAG_DTC3181E
Date: Wed, 18 Nov 2015 19:35:44 +1100
Message-ID: <20151118083510.841704164@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-FLAG_DTC3181E
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The atari_NCR5380.c core driver lacks the DTC special case found in
NCR5380.c. Add this special case. This reduces divergence between them
and allows drivers like dmx3191d to make use of atari_NCR5380.c which is
helpful for testing.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |    7 +++----
 drivers/scsi/atari_NCR5380.c |   11 ++++++++---
 2 files changed, 11 insertions(+), 7 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:08.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:08.000000000 +1100
@@ -646,12 +646,13 @@ static void prepare_info(struct Scsi_Hos
 	         "base 0x%lx, irq %d, "
 	         "can_queue %d, cmd_per_lun %d, "
 	         "sg_tablesize %d, this_id %d, "
-	         "flags { %s%s}, "
+	         "flags { %s%s%s}, "
 	         "options { %s} ",
 	         instance->hostt->name, instance->io_port, instance->n_io_port,
 	         instance->base, instance->irq,
 	         instance->can_queue, instance->cmd_per_lun,
 	         instance->sg_tablesize, instance->this_id,
+	         hostdata->flags & FLAG_DTC3181E       ? "DTC3181E "       : "",
 	         hostdata->flags & FLAG_TAGGED_QUEUING ? "TAGGED_QUEUING " : "",
 	         hostdata->flags & FLAG_TOSHIBA_DELAY  ? "TOSHIBA_DELAY "  : "",
 #ifdef DIFFERENTIAL
@@ -1416,8 +1417,12 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_write(INITIATOR_COMMAND_REG,
 		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
 
-	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
-	    hostdata->connected) {
+	/* RvC: DTC3181E has some trouble with this so we simply removed it.
+	 * Seems to work with only Mustek scanner attached.
+	 */
+	if (!(hostdata->flags & FLAG_DTC3181E) &&
+	    ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
+	     hostdata->connected)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:34:04.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:34:08.000000000 +1100
@@ -1154,11 +1154,10 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_write(INITIATOR_COMMAND_REG,
 		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
 
+	/* RvC: DTC3181E has some trouble with this so we simply removed it.
+	 * Seems to work with only Mustek scanner attached.
+	 */
 	if (!(hostdata->flags & FLAG_DTC3181E) &&
-	    /* RvC: DTC3181E has some trouble with this
-	     *      so we simply removed it. Seems to work with
-	     *      only Mustek scanner attached
-	     */
 	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
