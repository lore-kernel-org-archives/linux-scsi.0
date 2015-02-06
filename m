From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 04/36] aha1542: Remove HOSTDATA macro
Date: Fri,  6 Feb 2015 23:11:25 +0100
Message-ID: <1423260717-15944-5-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56933 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbbBFWMM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:12:12 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8D-0006fF-NR
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:09 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove HOSTDATA macro and use shost_priv instead

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |  114 +++++++++++++++++++++++-------------------------
 1 file changed, 55 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 197480d..ebf54b5 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -118,8 +118,6 @@ struct aha1542_hostdata {
 	struct ccb ccb[AHA1542_MAILBOXES];
 };
 
-#define HOSTDATA(host) ((struct aha1542_hostdata *) &host->hostdata)
-
 static DEFINE_SPINLOCK(aha1542_lock);
 
 
@@ -382,6 +380,7 @@ static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
 /* A "high" level interrupt handler */
 static void aha1542_intr_handle(struct Scsi_Host *shost)
 {
+	struct aha1542_hostdata *aha1542 = shost_priv(shost);
 	void (*my_done) (Scsi_Cmnd *) = NULL;
 	int errstatus, mbi, mbo, mbistatus;
 	int number_serviced;
@@ -389,11 +388,8 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 	Scsi_Cmnd *SCtmp;
 	int flag;
 	int needs_restart;
-	struct mailbox *mb;
-	struct ccb *ccb;
-
-	mb = HOSTDATA(shost)->mb;
-	ccb = HOSTDATA(shost)->ccb;
+	struct mailbox *mb = aha1542->mb;
+	struct ccb *ccb = aha1542->ccb;
 
 #ifdef DEBUG
 	{
@@ -435,7 +431,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 		aha1542_intr_reset(shost->io_port);
 
 		spin_lock_irqsave(&aha1542_lock, flags);
-		mbi = HOSTDATA(shost)->aha1542_last_mbi_used + 1;
+		mbi = aha1542->aha1542_last_mbi_used + 1;
 		if (mbi >= 2 * AHA1542_MAILBOXES)
 			mbi = AHA1542_MAILBOXES;
 
@@ -445,7 +441,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 			mbi++;
 			if (mbi >= 2 * AHA1542_MAILBOXES)
 				mbi = AHA1542_MAILBOXES;
-		} while (mbi != HOSTDATA(shost)->aha1542_last_mbi_used);
+		} while (mbi != aha1542->aha1542_last_mbi_used);
 
 		if (mb[mbi].status == 0) {
 			spin_unlock_irqrestore(&aha1542_lock, flags);
@@ -462,7 +458,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 		mbo = (scsi2int(mb[mbi].ccbptr) - (isa_virt_to_bus(&ccb[0]))) / sizeof(struct ccb);
 		mbistatus = mb[mbi].status;
 		mb[mbi].status = 0;
-		HOSTDATA(shost)->aha1542_last_mbi_used = mbi;
+		aha1542->aha1542_last_mbi_used = mbi;
 		spin_unlock_irqrestore(&aha1542_lock, flags);
 
 #ifdef DEBUG
@@ -480,7 +476,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 		printk(KERN_DEBUG "...done %d %d\n", mbo, mbi);
 #endif
 
-		SCtmp = HOSTDATA(shost)->SCint[mbo];
+		SCtmp = aha1542->SCint[mbo];
 
 		if (!SCtmp || !SCtmp->scsi_done) {
 			printk(KERN_WARNING "aha1542_intr_handle: Unexpected interrupt\n");
@@ -533,8 +529,8 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 		}
 		DEB(if (errstatus) printk("aha1542_intr_handle: returning %6x\n", errstatus));
 		SCtmp->result = errstatus;
-		HOSTDATA(shost)->SCint[mbo] = NULL;	/* This effectively frees up the mailbox slot, as
-							   far as queuecommand is concerned */
+		aha1542->SCint[mbo] = NULL;	/* This effectively frees up the mailbox slot, as
+						   far as queuecommand is concerned */
 		my_done(SCtmp);
 		number_serviced++;
 	};
@@ -542,6 +538,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 
 static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
+	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
 	unchar ahacmd = CMD_START_SCSI;
 	unchar direction;
 	unchar *cmd = (unchar *) SCpnt->cmnd;
@@ -550,14 +547,11 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 	unsigned long flags;
 	int bufflen = scsi_bufflen(SCpnt);
 	int mbo;
-	struct mailbox *mb;
-	struct ccb *ccb;
+	struct mailbox *mb = aha1542->mb;
+	struct ccb *ccb = aha1542->ccb;
 
 	DEB(int i);
 
-	mb = HOSTDATA(SCpnt->device->host)->mb;
-	ccb = HOSTDATA(SCpnt->device->host)->ccb;
-
 	DEB(if (target > 1) {
 	    SCpnt->result = DID_TIME_OUT << 16;
 	    done(SCpnt); return 0;
@@ -593,25 +587,25 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 	   is how the host adapter will scan for them */
 
 	spin_lock_irqsave(&aha1542_lock, flags);
-	mbo = HOSTDATA(SCpnt->device->host)->aha1542_last_mbo_used + 1;
+	mbo = aha1542->aha1542_last_mbo_used + 1;
 	if (mbo >= AHA1542_MAILBOXES)
 		mbo = 0;
 
 	do {
-		if (mb[mbo].status == 0 && HOSTDATA(SCpnt->device->host)->SCint[mbo] == NULL)
+		if (mb[mbo].status == 0 && aha1542->SCint[mbo] == NULL)
 			break;
 		mbo++;
 		if (mbo >= AHA1542_MAILBOXES)
 			mbo = 0;
-	} while (mbo != HOSTDATA(SCpnt->device->host)->aha1542_last_mbo_used);
+	} while (mbo != aha1542->aha1542_last_mbo_used);
 
-	if (mb[mbo].status || HOSTDATA(SCpnt->device->host)->SCint[mbo])
+	if (mb[mbo].status || aha1542->SCint[mbo])
 		panic("Unable to find empty mailbox for aha1542.\n");
 
-	HOSTDATA(SCpnt->device->host)->SCint[mbo] = SCpnt;	/* This will effectively prevent someone else from
-							   screwing with this cdb. */
+	aha1542->SCint[mbo] = SCpnt;	/* This will effectively prevent someone else from
+					   screwing with this cdb. */
 
-	HOSTDATA(SCpnt->device->host)->aha1542_last_mbo_used = mbo;
+	aha1542->aha1542_last_mbo_used = mbo;
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 
 #ifdef DEBUG
@@ -645,7 +639,7 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 		cptr = (struct chain *) SCpnt->host_scribble;
 		if (cptr == NULL) {
 			/* free the claimed mailbox slot */
-			HOSTDATA(SCpnt->device->host)->SCint[mbo] = NULL;
+			aha1542->SCint[mbo] = NULL;
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 		scsi_for_each_sg(SCpnt, sg, sg_count, i) {
@@ -699,15 +693,13 @@ static DEF_SCSI_QCMD(aha1542_queuecommand)
 /* Initialize mailboxes */
 static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 {
+	struct aha1542_hostdata *aha1542 = shost_priv(shpnt);
 	int i;
-	struct mailbox *mb;
-	struct ccb *ccb;
+	struct mailbox *mb = aha1542->mb;
+	struct ccb *ccb = aha1542->ccb;
 
 	unchar cmd[5] = { CMD_MBINIT, AHA1542_MAILBOXES, 0, 0, 0};
 
-	mb = HOSTDATA(shpnt)->mb;
-	ccb = HOSTDATA(shpnt)->ccb;
-
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		mb[i].status = mb[AHA1542_MAILBOXES + i].status = 0;
 		any2scsi(mb[i].ccbptr, isa_virt_to_bus(&ccb[i]));
@@ -951,6 +943,7 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 	unsigned int base_io;
 	int trans;
 	struct Scsi_Host *shpnt = NULL;
+	struct aha1542_hostdata *aha1542;
 
 	DEB(printk("aha1542_detect: \n"));
 
@@ -964,6 +957,7 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 				release_region(bases[indx], 4);
 				return NULL;
 			}
+			aha1542 = shost_priv(shpnt);
 			if (!aha1542_test_port(bases[indx], shpnt))
 				goto unregister;
 
@@ -1040,12 +1034,12 @@ fail:
 			shpnt->n_io_port = 4;	/* Number of bytes of I/O space used */
 			shpnt->dma_channel = dma_chan;
 			shpnt->irq = irq_level;
-			HOSTDATA(shpnt)->bios_translation = trans;
+			aha1542->bios_translation = trans;
 			if (trans == BIOS_TRANSLATION_25563)
 				printk(KERN_INFO "aha1542.c: Using extended bios translation\n");
-			HOSTDATA(shpnt)->aha1542_last_mbi_used = (2 * AHA1542_MAILBOXES - 1);
-			HOSTDATA(shpnt)->aha1542_last_mbo_used = (AHA1542_MAILBOXES - 1);
-			memset(HOSTDATA(shpnt)->SCint, 0, sizeof(HOSTDATA(shpnt)->SCint));
+			aha1542->aha1542_last_mbi_used = (2 * AHA1542_MAILBOXES - 1);
+			aha1542->aha1542_last_mbo_used = (AHA1542_MAILBOXES - 1);
+			memset(aha1542->SCint, 0, sizeof(aha1542->SCint));
 			spin_unlock_irqrestore(&aha1542_lock, flags);
 
 			if (scsi_add_host(shpnt, pdev)) {
@@ -1083,12 +1077,13 @@ static int aha1542_release(struct Scsi_Host *shost)
 
 static int aha1542_restart(struct Scsi_Host *shost)
 {
+	struct aha1542_hostdata *aha1542 = shost_priv(shost);
 	int i;
 	int count = 0;
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++)
-		if (HOSTDATA(shost)->SCint[i] &&
-		    !(HOSTDATA(shost)->SCint[i]->device->soft_reset)) {
+		if (aha1542->SCint[i] &&
+		    !(aha1542->SCint[i]->device->soft_reset)) {
 			count++;
 		}
 	printk(KERN_DEBUG "Potential to restart %d stalled commands...\n", count);
@@ -1102,38 +1097,36 @@ static int aha1542_restart(struct Scsi_Host *shost)
  */
 static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 {
+	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
 	unsigned long flags;
-	struct mailbox *mb;
+	struct mailbox *mb = aha1542->mb;
 	unchar target = SCpnt->device->id;
 	unchar lun = SCpnt->device->lun;
 	int mbo;
-	struct ccb *ccb;
+	struct ccb *ccb = aha1542->ccb;
 	unchar ahacmd = CMD_START_SCSI;
 
-	ccb = HOSTDATA(SCpnt->device->host)->ccb;
-	mb = HOSTDATA(SCpnt->device->host)->mb;
-
 	spin_lock_irqsave(&aha1542_lock, flags);
-	mbo = HOSTDATA(SCpnt->device->host)->aha1542_last_mbo_used + 1;
+	mbo = aha1542->aha1542_last_mbo_used + 1;
 	if (mbo >= AHA1542_MAILBOXES)
 		mbo = 0;
 
 	do {
-		if (mb[mbo].status == 0 && HOSTDATA(SCpnt->device->host)->SCint[mbo] == NULL)
+		if (mb[mbo].status == 0 && aha1542->SCint[mbo] == NULL)
 			break;
 		mbo++;
 		if (mbo >= AHA1542_MAILBOXES)
 			mbo = 0;
-	} while (mbo != HOSTDATA(SCpnt->device->host)->aha1542_last_mbo_used);
+	} while (mbo != aha1542->aha1542_last_mbo_used);
 
-	if (mb[mbo].status || HOSTDATA(SCpnt->device->host)->SCint[mbo])
+	if (mb[mbo].status || aha1542->SCint[mbo])
 		panic("Unable to find empty mailbox for aha1542.\n");
 
-	HOSTDATA(SCpnt->device->host)->SCint[mbo] = SCpnt;	/* This will effectively
-							   prevent someone else from
-							   screwing with this cdb. */
+	aha1542->SCint[mbo] = SCpnt;	/* This will effectively
+					   prevent someone else from
+					   screwing with this cdb. */
 
-	HOSTDATA(SCpnt->device->host)->aha1542_last_mbo_used = mbo;
+	aha1542->aha1542_last_mbo_used = mbo;
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 
 	any2scsi(mb[mbo].ccbptr, isa_virt_to_bus(&ccb[mbo]));	/* This gets trashed for some reason */
@@ -1161,6 +1154,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 
 static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 {
+	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
 	int i;
 
 	/* 
@@ -1194,9 +1188,9 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 	printk(KERN_WARNING "Sent BUS RESET to scsi host %d\n", SCpnt->device->host->host_no);
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
-		if (HOSTDATA(SCpnt->device->host)->SCint[i] != NULL) {
+		if (aha1542->SCint[i] != NULL) {
 			Scsi_Cmnd *SCtmp;
-			SCtmp = HOSTDATA(SCpnt->device->host)->SCint[i];
+			SCtmp = aha1542->SCint[i];
 
 
 			if (SCtmp->device->soft_reset) {
@@ -1210,8 +1204,8 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 			}
 			kfree(SCtmp->host_scribble);
 			SCtmp->host_scribble = NULL;
-			HOSTDATA(SCpnt->device->host)->SCint[i] = NULL;
-			HOSTDATA(SCpnt->device->host)->mb[i].status = 0;
+			aha1542->SCint[i] = NULL;
+			aha1542->mb[i].status = 0;
 		}
 	}
 
@@ -1225,6 +1219,7 @@ fail:
 
 static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 {
+	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
 	int i;
 
 	/* 
@@ -1263,9 +1258,9 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 	printk(KERN_WARNING "Sent BUS RESET to scsi host %d\n", SCpnt->device->host->host_no);
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
-		if (HOSTDATA(SCpnt->device->host)->SCint[i] != NULL) {
+		if (aha1542->SCint[i] != NULL) {
 			Scsi_Cmnd *SCtmp;
-			SCtmp = HOSTDATA(SCpnt->device->host)->SCint[i];
+			SCtmp = aha1542->SCint[i];
 
 			if (SCtmp->device->soft_reset) {
 				/*
@@ -1278,8 +1273,8 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 			}
 			kfree(SCtmp->host_scribble);
 			SCtmp->host_scribble = NULL;
-			HOSTDATA(SCpnt->device->host)->SCint[i] = NULL;
-			HOSTDATA(SCpnt->device->host)->mb[i].status = 0;
+			aha1542->SCint[i] = NULL;
+			aha1542->mb[i].status = 0;
 		}
 	}
 
@@ -1294,10 +1289,11 @@ fail:
 static int aha1542_biosparam(struct scsi_device *sdev,
 		struct block_device *bdev, sector_t capacity, int *ip)
 {
+	struct aha1542_hostdata *aha1542 = shost_priv(sdev->host);
 	int translation_algorithm;
 	int size = capacity;
 
-	translation_algorithm = HOSTDATA(sdev->host)->bios_translation;
+	translation_algorithm = aha1542->bios_translation;
 
 	if ((size >> 11) > 1024 && translation_algorithm == BIOS_TRANSLATION_25563) {
 		/* Please verify that this is the same as what DOS returns */
-- 
Ondrej Zary

