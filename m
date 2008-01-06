From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH  4/33][SCSI] aha1542: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:03:10 +0100 (MET)
Message-ID: <20080106030310.30002.82011.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53860 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYAFDDZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:03:25 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-errors (so no '> 80 lines'-warning).


diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index bbcc2c5..5e1a17e 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -60,7 +60,7 @@ static void BAD_DMA(void *address, unsigned int length)
 	panic("Buffer at physical address > 16Mb used for aha1542");
 }
 
-static void BAD_SG_DMA(Scsi_Cmnd * SCpnt,
+static void BAD_SG_DMA(struct scsi_cmnd *SCpnt,
 		       struct scatterlist *sgp,
 		       int nseg,
 		       int badseg)
@@ -155,7 +155,7 @@ struct aha1542_hostdata {
 	int bios_translation;	/* Mapping bios uses - for compatibility */
 	int aha1542_last_mbi_used;
 	int aha1542_last_mbo_used;
-	Scsi_Cmnd *SCint[AHA1542_MAILBOXES];
+	struct scsi_cmnd *SCint[AHA1542_MAILBOXES];
 	struct mailbox mb[2 * AHA1542_MAILBOXES];
 	struct ccb ccb[AHA1542_MAILBOXES];
 };
@@ -431,11 +431,11 @@ static irqreturn_t do_aha1542_intr_handle(int irq, void *dev_id)
 /* A "high" level interrupt handler */
 static void aha1542_intr_handle(struct Scsi_Host *shost, void *dev_id)
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
@@ -589,7 +589,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost, void *dev_id)
 	};
 }
 
-static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int aha1542_queuecommand(struct scsi_cmnd *SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	unchar ahacmd = CMD_START_SCSI;
 	unchar direction;
@@ -1339,7 +1339,7 @@ static int aha1542_restart(struct Scsi_Host *shost)
  * This is a device reset.  This is handled by sending a special command
  * to the device.
  */
-static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_dev_reset(struct scsi_cmnd *SCpnt)
 {
 	unsigned long flags;
 	struct mailbox *mb;
@@ -1417,7 +1417,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (HOSTDATA(SCpnt->host)->SCint[i] &&
 		    HOSTDATA(SCpnt->host)->SCint[i]->target == SCpnt->target) {
-			Scsi_Cmnd *SCtmp;
+			struct scsi_cmnd *SCtmp;
 			SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
 			kfree(SCtmp->host_scribble);
 			SCtmp->host_scribble = NULL;
@@ -1431,7 +1431,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 #endif				/* ERIC_neverdef */
 }
 
-static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	int i;
 
@@ -1467,7 +1467,7 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (HOSTDATA(SCpnt->device->host)->SCint[i] != NULL) {
-			Scsi_Cmnd *SCtmp;
+			struct scsi_cmnd *SCtmp;
 			SCtmp = HOSTDATA(SCpnt->device->host)->SCint[i];
 
 
@@ -1495,7 +1495,7 @@ fail:
 	return FAILED;
 }
 
-static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_host_reset(struct scsi_cmnd *SCpnt)
 {
 	int i;
 
@@ -1536,7 +1536,7 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (HOSTDATA(SCpnt->device->host)->SCint[i] != NULL) {
-			Scsi_Cmnd *SCtmp;
+			struct scsi_cmnd *SCtmp;
 			SCtmp = HOSTDATA(SCpnt->device->host)->SCint[i];
 
 			if (SCtmp->device->soft_reset) {
@@ -1568,7 +1568,7 @@ fail:
  * These are the old error handling routines.  They are only temporarily
  * here while we play with the new error handling code.
  */
-static int aha1542_old_abort(Scsi_Cmnd * SCpnt)
+static int aha1542_old_abort(struct scsi_cmnd *SCpnt)
 {
 #if 0
 	unchar ahacmd = CMD_START_SCSI;
@@ -1646,7 +1646,7 @@ static int aha1542_old_abort(Scsi_Cmnd * SCpnt)
    For a first go, we assume that the 1542 notifies us with all of the
    pending commands (it does implement soft reset, after all). */
 
-static int aha1542_old_reset(Scsi_Cmnd * SCpnt, unsigned int reset_flags)
+static int aha1542_old_reset(struct scsi_cmnd *SCpnt, unsigned int reset_flags)
 {
 	unchar ahacmd = CMD_START_SCSI;
 	int i;
@@ -1689,7 +1689,7 @@ static int aha1542_old_reset(Scsi_Cmnd * SCpnt, unsigned int reset_flags)
 
 		for (i = 0; i < AHA1542_MAILBOXES; i++)
 			if (HOSTDATA(SCpnt->host)->SCint[i] != NULL) {
-				Scsi_Cmnd *SCtmp;
+				struct scsi_cmnd *SCtmp;
 				SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
 				SCtmp->result = DID_RESET << 16;
 				kfree(SCtmp->host_scribble);
@@ -1733,7 +1733,7 @@ fail:
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
+static int aha1542_bus_reset(struct scsi_cmnd *SCpnt);
+static int aha1542_dev_reset(struct scsi_cmnd *SCpnt);
+static int aha1542_host_reset(struct scsi_cmnd *SCpnt);
 #if 0
-static int aha1542_old_abort(Scsi_Cmnd * SCpnt);
-static int aha1542_old_reset(Scsi_Cmnd *, unsigned int);
+static int aha1542_old_abort(struct scsi_cmnd *SCpnt);
+static int aha1542_old_reset(struct scsi_cmnd *, unsigned int);
 #endif
 static int aha1542_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int *);
