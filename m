From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 08/16] SCSI: aha1542: remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:20:07 -0400
Message-ID: <1310710807.3184.59.camel@offbook>
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
 drivers/scsi/aha1542.c |   28 ++++++++++++++--------------
 drivers/scsi/aha1542.h |   10 +++++-----
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 195823a..8d60472 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -131,7 +131,7 @@ struct aha1542_hostdata {
 	int bios_translation;	/* Mapping bios uses - for compatibility */
 	int aha1542_last_mbi_used;
 	int aha1542_last_mbo_used;
-	Scsi_Cmnd *SCint[AHA1542_MAILBOXES];
+	struct scsi_cmnd *SCint[AHA1542_MAILBOXES];
 	struct mailbox mb[2 * AHA1542_MAILBOXES];
 	struct ccb ccb[AHA1542_MAILBOXES];
 };
@@ -400,11 +400,11 @@ static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
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
@@ -558,7 +558,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 	};
 }
 
-static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int aha1542_queuecommand_lck(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	unchar ahacmd = CMD_START_SCSI;
 	unchar direction;
@@ -1286,7 +1286,7 @@ static int aha1542_restart(struct Scsi_Host *shost)
  * This is a device reset.  This is handled by sending a special command
  * to the device.
  */
-static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_dev_reset(struct scsi_cmnd * SCpnt)
 {
 	unsigned long flags;
 	struct mailbox *mb;
@@ -1364,7 +1364,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (HOSTDATA(SCpnt->host)->SCint[i] &&
 		    HOSTDATA(SCpnt->host)->SCint[i]->target == SCpnt->target) {
-			Scsi_Cmnd *SCtmp;
+			struct scsi_cmnd *SCtmp;
 			SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
 			kfree(SCtmp->host_scribble);
 			SCtmp->host_scribble = NULL;
@@ -1378,7 +1378,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 #endif				/* ERIC_neverdef */
 }
 
-static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_bus_reset(struct scsi_cmnd * SCpnt)
 {
 	int i;
 
@@ -1414,7 +1414,7 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (HOSTDATA(SCpnt->device->host)->SCint[i] != NULL) {
-			Scsi_Cmnd *SCtmp;
+			struct scsi_cmnd *SCtmp;
 			SCtmp = HOSTDATA(SCpnt->device->host)->SCint[i];
 

@@ -1442,7 +1442,7 @@ fail:
 	return FAILED;
 }
 
-static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_host_reset(struct scsi_cmnd * SCpnt)
 {
 	int i;
 
@@ -1483,7 +1483,7 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (HOSTDATA(SCpnt->device->host)->SCint[i] != NULL) {
-			Scsi_Cmnd *SCtmp;
+			struct scsi_cmnd *SCtmp;
 			SCtmp = HOSTDATA(SCpnt->device->host)->SCint[i];
 
 			if (SCtmp->device->soft_reset) {
@@ -1515,7 +1515,7 @@ fail:
  * These are the old error handling routines.  They are only temporarily
  * here while we play with the new error handling code.
  */
-static int aha1542_old_abort(Scsi_Cmnd * SCpnt)
+static int aha1542_old_abort(struct scsi_cmnd * SCpnt)
 {
 #if 0
 	unchar ahacmd = CMD_START_SCSI;
@@ -1593,7 +1593,7 @@ static int aha1542_old_abort(Scsi_Cmnd * SCpnt)
    For a first go, we assume that the 1542 notifies us with all of the
    pending commands (it does implement soft reset, after all). */
 
-static int aha1542_old_reset(Scsi_Cmnd * SCpnt, unsigned int reset_flags)
+static int aha1542_old_reset(struct scsi_cmnd * SCpnt, unsigned int reset_flags)
 {
 	unchar ahacmd = CMD_START_SCSI;
 	int i;
@@ -1636,7 +1636,7 @@ static int aha1542_old_reset(Scsi_Cmnd * SCpnt, unsigned int reset_flags)
 
 		for (i = 0; i < AHA1542_MAILBOXES; i++)
 			if (HOSTDATA(SCpnt->host)->SCint[i] != NULL) {
-				Scsi_Cmnd *SCtmp;
+				struct scsi_cmnd *SCtmp;
 				SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
 				SCtmp->result = DID_RESET << 16;
 				kfree(SCtmp->host_scribble);
@@ -1680,7 +1680,7 @@ fail:
 				for (i = 0; i < AHA1542_MAILBOXES; i++)
 					if (HOSTDATA(SCpnt->host)->SCint[i] &&
 					    HOSTDATA(SCpnt->host)->SCint[i]->target == SCpnt->target) {
-						Scsi_Cmnd *SCtmp;
+						struct scsi_cmnd *SCtmp;
 						SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
 						SCtmp->result = DID_RESET << 16;
 						kfree(SCtmp->host_scribble);
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index b871d2b..875a78b 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -133,12 +133,12 @@ struct ccb {			/* Command Control Block 5.3 */
 
 static int aha1542_detect(struct scsi_host_template *);
 static int aha1542_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
-static int aha1542_bus_reset(Scsi_Cmnd * SCpnt);
-static int aha1542_dev_reset(Scsi_Cmnd * SCpnt);
-static int aha1542_host_reset(Scsi_Cmnd * SCpnt);
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
-- 
1.7.4.1
