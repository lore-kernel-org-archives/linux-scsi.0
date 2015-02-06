From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 15/36] aha1542: Remove aha1542_restart
Date: Fri,  6 Feb 2015 23:11:36 +0100
Message-ID: <1423260717-15944-16-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56973 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbbBFWQP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:15 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8F-0006fF-IV
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:11 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

aha1542_restart does nothing (except useless printk), remove it

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 29ddcc9..67fdd2f 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -321,22 +321,6 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 	return 1;
 }
 
-static int aha1542_restart(struct Scsi_Host *shost)
-{
-	struct aha1542_hostdata *aha1542 = shost_priv(shost);
-	int i;
-	int count = 0;
-
-	for (i = 0; i < AHA1542_MAILBOXES; i++)
-		if (aha1542->SCint[i] &&
-		    !(aha1542->SCint[i]->device->soft_reset)) {
-			count++;
-		}
-	printk(KERN_DEBUG "Potential to restart %d stalled commands...\n", count);
-
-	return 0;
-}
-
 /* A "high" level interrupt handler */
 static void aha1542_intr_handle(struct Scsi_Host *shost)
 {
@@ -347,7 +331,6 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 	unsigned long flags;
 	Scsi_Cmnd *SCtmp;
 	int flag;
-	int needs_restart;
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
 
@@ -369,7 +352,6 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 	};
 #endif
 	number_serviced = 0;
-	needs_restart = 0;
 
 	while (1 == 1) {
 		flag = inb(INTRFLAGS(shost->io_port));
@@ -383,10 +365,8 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 				printk("MBOF ");
 			if (flag & HACC)
 				printk("HACC ");
-			if (flag & SCRD) {
-				needs_restart = 1;
+			if (flag & SCRD)
 				printk("SCRD ");
-			}
 		}
 		aha1542_intr_reset(shost->io_port);
 
@@ -406,12 +386,8 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 		if (mb[mbi].status == 0) {
 			spin_unlock_irqrestore(&aha1542_lock, flags);
 			/* Hmm, no mail.  Must have read it the last time around */
-			if (!number_serviced && !needs_restart)
+			if (!number_serviced)
 				printk(KERN_WARNING "aha1542.c: interrupt received, but no mail.\n");
-			/* We detected a reset.  Restart all pending commands for
-			   devices that use the hard reset option */
-			if (needs_restart)
-				aha1542_restart(shost);
 			return;
 		};
 
-- 
Ondrej Zary

