From: Joe Perches <joe@perches.com>
Subject: [PATCH 09/11] drivers/scsi: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:43 -0700
Message-ID: <d6d5dc09d259cc1da0fef2b1e9c6b7588cccf0b4.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2057 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZEOSAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 14:00:05 -0400
In-Reply-To: <cover.1242407227.git.joe@perches.com>
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/aha1542.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 8059494..29d5118 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -509,9 +509,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 		if (mbistatus == 3)
 			continue;	/* Aborted command not found */
 
-#ifdef DEBUG
-		printk(KERN_DEBUG "...done %d %d\n", mbo, mbi);
-#endif
+		pr_debug("...done %d %d\n", mbo, mbi);
 
 		SCtmp = HOSTDATA(shost)->SCint[mbo];
 
@@ -654,9 +652,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	HOSTDATA(SCpnt->device->host)->aha1542_last_mbo_used = mbo;
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "Sending command (%d %x)...", mbo, done);
-#endif
+	pr_debug("Sending command (%d %x)...", mbo, done);
 
 	any2scsi(mb[mbo].ccbptr, SCSI_BUF_PA(&ccb[mbo]));	/* This gets trashed for some reason */
 
-- 
1.6.3.1.9.g95405b.dirty

