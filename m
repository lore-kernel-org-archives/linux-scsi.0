From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 09/16] SCSI: aha1740: remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:20:11 -0400
Message-ID: <1310710811.3184.60.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/aha1740.c |    8 ++++----
 drivers/scsi/aha1740.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 1c10b79..45b7573 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -227,11 +227,11 @@ static int aha1740_test_port(unsigned int base)
 static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 {
 	struct Scsi_Host *host = (struct Scsi_Host *) dev_id;
-        void (*my_done)(Scsi_Cmnd *);
+        void (*my_done)(struct scsi_cmnd *);
 	int errstatus, adapstat;
 	int number_serviced;
 	struct ecb *ecbptr;
-	Scsi_Cmnd *SCtmp;
+	struct scsi_cmnd *SCtmp;
 	unsigned int base;
 	unsigned long flags;
 	int handled = 0;
@@ -331,7 +331,7 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-static int aha1740_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
+static int aha1740_queuecommand_lck(struct scsi_cmnd * SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	unchar direction;
 	unchar *cmd = (unchar *) SCpnt->cmnd;
@@ -540,7 +540,7 @@ static int aha1740_biosparam(struct scsi_device *sdev,
 	return 0;
 }
 
-static int aha1740_eh_abort_handler (Scsi_Cmnd *dummy)
+static int aha1740_eh_abort_handler (struct scsi_cmnd *dummy)
 {
 /*
  * From Alan Cox :
diff --git a/drivers/scsi/aha1740.h b/drivers/scsi/aha1740.h
index af23fd6..1a3fdf7 100644
--- a/drivers/scsi/aha1740.h
+++ b/drivers/scsi/aha1740.h
@@ -134,8 +134,8 @@ struct ecb {			/* Enhanced Control Block 6.1 */
 /* Hardware defined portion ends here, rest is driver defined */
 	u8 sense[MAX_SENSE];	/* Sense area */
 	u8 status[MAX_STATUS];	/* Status area */
-	Scsi_Cmnd *SCpnt;	/* Link to the SCSI Command Block */
-	void (*done) (Scsi_Cmnd *);	/* Completion Function */
+	struct scsi_cmnd *SCpnt;	/* Link to the SCSI Command Block */
+	void (*done) (struct scsi_cmnd *);	/* Completion Function */
 };
 
 #define	AHA1740CMD_NOP	 0x00	/* No OP */
-- 
1.7.4.1
