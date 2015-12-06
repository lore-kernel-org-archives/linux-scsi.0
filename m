From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 17/72] ncr5380: Keep BSY asserted when entering SELECTION phase
Date: Sun, 06 Dec 2015 12:31:43 +1100
Message-ID: <20151206013131.165491817@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-assert-BSY-during-selection
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NCR5380.c is not compliant with the SCSI-2 standard (at least, not with
the draft revision 10L that I have to refer to). The selection algorithm
in atari_NCR5380.c is correct, so use that.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

The NCR 5380 Family datasheet has a flow chart to support this. Please see
http://pdf.datasheetarchive.com/indexerfiles/Scans-001/Scans-0031883.pdf

This is another old bug fix that was unfortunately never applied to the
original NCR5380.c core driver.

---
 drivers/scsi/NCR5380.c       |    8 +++++++-
 drivers/scsi/atari_NCR5380.c |    7 ++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:29:46.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:29:47.000000000 +1100
@@ -1236,7 +1236,13 @@ static int NCR5380_select(struct Scsi_Ho
 		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no);
 		return -1;
 	}
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_SEL);
+
+	/* After/during arbitration, BSY should be asserted.
+	 * IBM DPES-31080 Version S31Q works now
+	 * Tnx to Thomas_Roesch@m2.maus.de for finding this! (Roman)
+	 */
+	NCR5380_write(INITIATOR_COMMAND_REG,
+		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
 
 	if (!(hostdata->flags & FLAG_DTC3181E) &&
 	    /* RvC: DTC3181E has some trouble with this
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:46.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:47.000000000 +1100
@@ -1480,9 +1480,10 @@ static int NCR5380_select(struct Scsi_Ho
 		return -1;
 	}
 
-	/* after/during arbitration, BSY should be asserted.
-	   IBM DPES-31080 Version S31Q works now */
-	/* Tnx to Thomas_Roesch@m2.maus.de for finding this! (Roman) */
+	/* After/during arbitration, BSY should be asserted.
+	 * IBM DPES-31080 Version S31Q works now
+	 * Tnx to Thomas_Roesch@m2.maus.de for finding this! (Roman)
+	 */
 	NCR5380_write(INITIATOR_COMMAND_REG,
 		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
 
