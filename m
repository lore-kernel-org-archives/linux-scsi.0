From: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] scsi: eata: Remove unnecessary cpp_index check
Date: Sun,  8 Oct 2017 22:47:46 +0100
Message-ID: <1507499266-10410-1-git-send-email-chris.gekas@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38131 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdJHVrv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Oct 2017 17:47:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>

Variable spp->cpp_index is unsigned so checking whether it is less than
zero is redundant.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/scsi/eata.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 6501c33..53a8fcd 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -2332,12 +2332,11 @@ static irqreturn_t ihdlr(struct Scsi_Host *shost)
 		printk
 		    ("%s: ihdlr, spp->eoc == 0, irq %d, reg 0x%x, count %d.\n",
 		     ha->board_name, irq, reg, ha->iocount);
-	if (spp->cpp_index < 0 || spp->cpp_index >= shost->can_queue)
+	if (spp->cpp_index >= shost->can_queue)
 		printk
 		    ("%s: ihdlr, bad spp->cpp_index %d, irq %d, reg 0x%x, count %d.\n",
 		     ha->board_name, spp->cpp_index, irq, reg, ha->iocount);
-	if (spp->eoc == 0 || spp->cpp_index < 0
-	    || spp->cpp_index >= shost->can_queue)
+	if (spp->eoc == 0 || spp->cpp_index >= shost->can_queue)
 		goto handled;
 
 	/* Find the mailbox to be serviced on this board */
-- 
2.7.4
