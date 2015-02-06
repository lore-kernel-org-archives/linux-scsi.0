From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 16/36] aha1542: Merge aha1542_host_reset and aha1542_bus_reset
Date: Fri,  6 Feb 2015 23:11:37 +0100
Message-ID: <1423260717-15944-17-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56953 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107AbbBFWPh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:37 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8F-0006fF-Mn
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:11 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

aha1542_host_reset and aha1542_bus_reset are almost same, merge them
into aha1542_reset

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   82 +++++++++---------------------------------------
 1 file changed, 14 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 67fdd2f..4bfba45 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1070,7 +1070,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	return SUCCESS;
 }
 
-static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_reset(Scsi_Cmnd *SCpnt, u8 reset_cmd)
 {
 	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
 	int i;
@@ -1081,7 +1081,7 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 	 * we do this?  Try this first, and we can add that later
 	 * if it turns out to be useful.
 	 */
-	outb(SCRST, CONTROL(SCpnt->device->host->io_port));
+	outb(reset_cmd, CONTROL(SCpnt->device->host->io_port));
 
 	/*
 	 * Wait for the thing to settle down a bit.  Unfortunately
@@ -1091,7 +1091,6 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 	 * we are pretty desperate anyways.
 	 */
 	ssleep(4);
-
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	if (!wait_mask(STATUS(SCpnt->device->host->io_port),
@@ -1099,7 +1098,12 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 		spin_unlock_irq(SCpnt->device->host->host_lock);
 		return FAILED;
 	}
-
+	/*
+	 * We need to do this too before the 1542 can interact with
+	 * us again after host reset.
+	 */
+	if (reset_cmd & HRST)
+		setup_mailboxes(SCpnt->device->host->io_port, SCpnt->device->host);
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
 	 * free any internal data structures, and basically clear things
@@ -1113,7 +1117,6 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 			Scsi_Cmnd *SCtmp;
 			SCtmp = aha1542->SCint[i];
 
-
 			if (SCtmp->device->soft_reset) {
 				/*
 				 * If this device implements the soft reset option,
@@ -1134,71 +1137,14 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 	return SUCCESS;
 }
 
-static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_bus_reset(Scsi_Cmnd *SCpnt)
 {
-	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
-	int i;
-
-	/* 
-	 * This does a scsi reset for all devices on the bus.
-	 * In principle, we could also reset the 1542 - should
-	 * we do this?  Try this first, and we can add that later
-	 * if it turns out to be useful.
-	 */
-	outb(HRST | SCRST, CONTROL(SCpnt->device->host->io_port));
-
-	/*
-	 * Wait for the thing to settle down a bit.  Unfortunately
-	 * this is going to basically lock up the machine while we
-	 * wait for this to complete.  To be 100% correct, we need to
-	 * check for timeout, and if we are doing something like this
-	 * we are pretty desperate anyways.
-	 */
-	ssleep(4);
-	spin_lock_irq(SCpnt->device->host->host_lock);
-
-	if (!wait_mask(STATUS(SCpnt->device->host->io_port),
-	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
-		spin_unlock_irq(SCpnt->device->host->host_lock);
-		return FAILED;
-	}
-	/*
-	 * We need to do this too before the 1542 can interact with
-	 * us again.
-	 */
-	setup_mailboxes(SCpnt->device->host->io_port, SCpnt->device->host);
-
-	/*
-	 * Now try to pick up the pieces.  For all pending commands,
-	 * free any internal data structures, and basically clear things
-	 * out.  We do not try and restart any commands or anything - 
-	 * the strategy handler takes care of that crap.
-	 */
-	printk(KERN_WARNING "Sent BUS RESET to scsi host %d\n", SCpnt->device->host->host_no);
-
-	for (i = 0; i < AHA1542_MAILBOXES; i++) {
-		if (aha1542->SCint[i] != NULL) {
-			Scsi_Cmnd *SCtmp;
-			SCtmp = aha1542->SCint[i];
-
-			if (SCtmp->device->soft_reset) {
-				/*
-				 * If this device implements the soft reset option,
-				 * then it is still holding onto the command, and
-				 * may yet complete it.  In this case, we don't
-				 * flush the data.
-				 */
-				continue;
-			}
-			kfree(SCtmp->host_scribble);
-			SCtmp->host_scribble = NULL;
-			aha1542->SCint[i] = NULL;
-			aha1542->mb[i].status = 0;
-		}
-	}
+	return aha1542_reset(SCpnt, SCRST);
+}
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
-	return SUCCESS;
+static int aha1542_host_reset(Scsi_Cmnd *SCpnt)
+{
+	return aha1542_reset(SCpnt, HRST | SCRST);
 }
 
 static int aha1542_biosparam(struct scsi_device *sdev,
-- 
Ondrej Zary

