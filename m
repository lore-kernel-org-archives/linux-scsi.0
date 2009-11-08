From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 04/20] scsi/aha1542: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:05 -0300
Message-ID: <1257711425.4759.110.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755329AbZKHUZz@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

--- 
drivers/scsi/aha1542.c |   30 +++++++++++++++---------------
 drivers/scsi/aha1542.h |   12 ++++++------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 8059494..77d4fb3 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -51,7 +51,7 @@
 #define SCSI_BUF_PA(address)	isa_virt_to_bus(address)
 #define SCSI_SG_PA(sgent)	(isa_page_to_bus(sg_page((sgent))) + (sgent)->offset)
 
-static void BAD_SG_DMA(Scsi_Cmnd * SCpnt,
+static void BAD_SG_DMA(struct scsi_cmnd *SCpnt,
 		       struct scatterlist *sgp,
 		       int nseg,
 		       int badseg)
@@ -146,7 +146,7 @@ struct aha1542_hostdata {
 	int bios_translation;	/* Mapping bios uses - for compatibility */
 	int aha1542_last_mbi_used;
 	int aha1542_last_mbo_used;
-	Scsi_Cmnd *SCint[AHA1542_MAILBOXES];
+	struct scsi_cmnd *SCint[AHA1542_MAILBOXES];
 	struct mailbox mb[2 * AHA1542_MAILBOXES];
 	struct ccb ccb[AHA1542_MAILBOXES];
 };
@@ -415,11 +415,11 @@ static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
 /* A "high" level interrupt handler */
 static void aha1542_intr_handle(struct Scsi_Host *shost)
 {
-	void (*my_done) (Scsi_Cmnd *) = NULL;
+	void (*my_done) (struct scsi_cmnd *) = NULL;
 	int errstatus, mbi, mbo, mbistatus;
 	int number_serviced;
 	unsigned long flags;
-	Scsi_Cmnd *SCtmp;
+	struct scsi_cmnd *SCtmp;
 	int flag;
 	int needs_restart;
 	struct mailbox *mb;
@@ -573,7 +573,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 	};
 }
 
-static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int aha1542_queuecommand(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	unchar ahacmd = CMD_START_SCSI;
 	unchar direction;
@@ -1308,7 +1308,7 @@ static int aha1542_restart(struct Scsi_Host *shost)
  * This is a device reset.  This is handled by sending a special command
  * to the device.
  */
-static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_dev_reset(struct scsi_cmnd * SCpnt)
 {
 	unsigned long flags;
 	struct mailbox *mb;
@@ -1386,7 +1386,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (HOSTDATA(SCpnt->host)->SCint[i] &&
 		    HOSTDATA(SCpnt->host)->SCint[i]->target == SCpnt->target) {
-			Scsi_Cmnd *SCtmp;
+			struct scsi_cmnd *SCtmp;
 			SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
 			kfree(SCtmp->host_scribble);
 			SCtmp->host_scribble = NULL;
@@ -1400,7 +1400,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 #endif				/* ERIC_neverdef */
 }
 
-static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_bus_reset(struct scsi_cmnd * SCpnt)
 {
 	int i;
 
@@ -1436,7 +1436,7 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (HOSTDATA(SCpnt->device->host)->SCint[i] != NULL) {
-			Scsi_Cmnd *SCtmp;
+			struct scsi_cmnd *SCtmp;
 			SCtmp = HOSTDATA(SCpnt->device->host)->SCint[i];
 

@@ -1464,7 +1464,7 @@ fail:
 	return FAILED;
 }
 
-static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_host_reset(struct scsi_cmnd * SCpnt)
 {
 	int i;
 
@@ -1505,7 +1505,7 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (HOSTDATA(SCpnt->device->host)->SCint[i] != NULL) {
-			Scsi_Cmnd *SCtmp;
+			struct scsi_cmnd *SCtmp;
 			SCtmp = HOSTDATA(SCpnt->device->host)->SCint[i];
 
 			if (SCtmp->device->soft_reset) {
@@ -1537,7 +1537,7 @@ fail:
  * These are the old error handling routines.  They are only temporarily
  * here while we play with the new error handling code.
  */
-static int aha1542_old_abort(Scsi_Cmnd * SCpnt)
+static int aha1542_old_abort(struct scsi_cmnd * SCpnt)
 {
 #if 0
 	unchar ahacmd = CMD_START_SCSI;
@@ -1615,7 +1615,7 @@ static int aha1542_old_abort(Scsi_Cmnd * SCpnt)
    For a first go, we assume that the 1542 notifies us with all of the
    pending commands (it does implement soft reset, after all). */
 
-static int aha1542_old_reset(Scsi_Cmnd * SCpnt, unsigned int reset_flags)
+static int aha1542_old_reset(struct scsi_cmnd * SCpnt, unsigned int reset_flags)
 {
 	unchar ahacmd = CMD_START_SCSI;
 	int i;
@@ -1658,7 +1658,7 @@ static int aha1542_old_reset(Scsi_Cmnd * SCpnt, unsigned int reset_flags)
 
 		for (i = 0; i < AHA1542_MAILBOXES; i++)
 			if (HOSTDATA(SCpnt->host)->SCint[i] != NULL) {
-				Scsi_Cmnd *SCtmp;
+				struct scsi_cmnd *SCtmp;
 				SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
 				SCtmp->result = DID_RESET << 16;
 				kfree(SCtmp->host_scribble);
@@ -1702,7 +1702,7 @@ fail:
 				for (i = 0; i < AHA1542_MAILBOXES; i++)
 					if (HOSTDATA(SCpnt->host)->SCint[i] &&
 					    HOSTDATA(SCpnt->host)->SCint[i]->target == SCpnt->target) {
-						Scsi_Cmnd *SCtmp;
+						struct scsi_cmnd *SCtmp;
 						SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
 						SCtmp->result = DID_RESET << 16;
 						kfree(SCtmp->host_scribble);
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index 1db5385..951590a 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -132,13 +132,13 @@ struct ccb {			/* Command Control Block 5.3 */
 };
 
 static int aha1542_detect(struct scsi_host_template *);
-static int aha1542_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int aha1542_bus_reset(Scsi_Cmnd * SCpnt);
-static int aha1542_dev_reset(Scsi_Cmnd * SCpnt);
-static int aha1542_host_reset(Scsi_Cmnd * SCpnt);
+static int aha1542_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int aha1542_bus_reset(struct scsi_cmnd * SCpnt);
+static int aha1542_dev_reset(struct scsi_cmnd * SCpnt);
+static int aha1542_host_reset(struct scsi_cmnd * SCpnt);
 #if 0
-static int aha1542_old_abort(Scsi_Cmnd * SCpnt);
-static int aha1542_old_reset(Scsi_Cmnd *, unsigned int);
+static int aha1542_old_abort(struct scsi_cmnd * SCpnt);
+static int aha1542_old_reset(struct scsi_cmnd *, unsigned int);
 #endif
 static int aha1542_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int *);
