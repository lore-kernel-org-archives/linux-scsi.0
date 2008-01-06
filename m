From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH  5/33][SCSI] aha1740: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:03:16 +0100 (MET)
Message-ID: <20080106030316.30002.65144.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53866 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYAFDD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:03:27 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-errors (so no '> 80 lines'-warning).


diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index f6722fd..4fa801f 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -226,11 +226,11 @@ static int aha1740_test_port(unsigned int base)
 static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 {
 	struct Scsi_Host *host = (struct Scsi_Host *) dev_id;
-        void (*my_done)(Scsi_Cmnd *);
+	void (*my_done)(struct scsi_cmnd *);
 	int errstatus, adapstat;
 	int number_serviced;
 	struct ecb *ecbptr;
-	Scsi_Cmnd *SCtmp;
+	struct scsi_cmnd *SCtmp;
 	unsigned int base;
 	unsigned long flags;
 	int handled = 0;
@@ -330,7 +330,7 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
+static int aha1740_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	unchar direction;
 	unchar *cmd = (unchar *) SCpnt->cmnd;
@@ -537,7 +537,7 @@ static int aha1740_biosparam(struct scsi_device *sdev,
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
