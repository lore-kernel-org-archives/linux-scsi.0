From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] scsi_scan.c: bug fix: starget use after free issue
Date: Thu, 15 Jun 2006 12:55:59 -0400
Message-ID: <1150390560.29774.32.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:15759 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751440AbWFOQz6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 12:55:58 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k5FGtvdA017693
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2006 09:55:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When reaping the starget, after all sdev's have been removed, the starget
was queued for deletion via usercontext, but was left on the shost's
__targets list. Another scanning thread can match the starget and use it, 
causing reference after free problems.

This patch unlinks the starget at the same time it is scheduled for deletion.

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>

diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2006-06-14 11:37:09.000000000 -0400
+++ b/drivers/scsi/scsi_scan.c	2006-06-14 16:55:58.000000000 -0400
@@ -415,7 +415,6 @@ static void scsi_target_reap_usercontext
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
 		shost->hostt->target_destroy(starget);
-	list_del_init(&starget->siblings);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(&starget->dev);
 }
@@ -439,6 +438,7 @@ void scsi_target_reap(struct scsi_target
 	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
 		BUG_ON(starget->state == STARGET_DEL);
 		starget->state = STARGET_DEL;
+		list_del_init(&starget->siblings);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		execute_in_process_context(scsi_target_reap_usercontext,
 					   starget, &starget->ew);


