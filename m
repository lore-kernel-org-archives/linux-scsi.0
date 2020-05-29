Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D815C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 22:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DDED20897
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 22:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgE2WOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 18:14:52 -0400
Received: from smtp.infotech.no ([82.134.31.41]:33540 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgE2WOw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 18:14:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 6D4F020418F;
        Sat, 30 May 2020 00:14:51 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dM3OZ+jHoiRk; Sat, 30 May 2020 00:14:45 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id C514F20415B;
        Sat, 30 May 2020 00:14:44 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH 1/1] scsi: scsi_forget_host() shuffle
Date:   Fri, 29 May 2020 18:14:42 -0400
Message-Id: <20200529221442.8404-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch leaves me a bit uneasy but it does cure the crash
that occurs in this function. xarray iterators are pretty safe
_unless_ something deletes the parent node holding the
collection. The problem seems to be these nested loops do not
_explicitly_ remove the starget object. That is done magically
at the sdev level on the removal of the last sdev in a starget.
And that is half an iteration too soon! Hence the shuffle which
isn't a great solution. The magical starget removal is wrong IMO
and this will burn us elsewhere, I suspect.

Thes patch is on top of Hannes Reinecke's "[PATCHv4 0/5] scsi:
use xarray for devices and targets" patchset.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_scan.c | 47 +++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0a344653487d..e378f03d0297 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1858,25 +1858,52 @@ void scsi_scan_host(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
+static void scsi_forget_host_inner(struct Scsi_Host *shost,
+				   struct scsi_target *starg,
+				   unsigned long *flagsp)
+{
+	struct scsi_device *sdev;
+	struct scsi_device *prev_sdev = NULL;
+	unsigned long lun_id;
+
+	xa_for_each(&starg->__devices, lun_id, sdev) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
+		if (!prev_sdev) {
+			prev_sdev = sdev;
+			continue;
+		}
+		spin_unlock_irqrestore(shost->host_lock, *flagsp);
+		__scsi_remove_device(prev_sdev);
+		spin_lock_irqsave(shost->host_lock, *flagsp);
+		prev_sdev = sdev;
+	}
+	if (prev_sdev) {
+		spin_unlock_irqrestore(shost->host_lock, *flagsp);
+		__scsi_remove_device(prev_sdev);
+		spin_lock_irqsave(shost->host_lock, *flagsp);
+	}
+}
+
+/* N.B. Keeping iteration one step ahead of destruction point */
 void scsi_forget_host(struct Scsi_Host *shost)
 {
 	struct scsi_target *starget;
-	struct scsi_device *sdev;
+	struct scsi_target *prev_starget = NULL;
 	unsigned long flags;
-	unsigned long tid = 0;
+	unsigned long tid;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	xa_for_each(&shost->__targets, tid, starget) {
-		unsigned long lun_id = 0;
-
-		xa_for_each(&starget->__devices, lun_id, sdev) {
-			if (sdev->sdev_state == SDEV_DEL)
-				continue;
-			spin_unlock_irqrestore(shost->host_lock, flags);
-			__scsi_remove_device(sdev);
-			spin_lock_irqsave(shost->host_lock, flags);
+		if (!prev_starget) {
+			prev_starget = starget;
+			continue;
 		}
+		scsi_forget_host_inner(shost, prev_starget, &flags);
+		prev_starget = starget;
 	}
+	if (prev_starget)
+		scsi_forget_host_inner(shost, prev_starget, &flags);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
-- 
2.25.1

