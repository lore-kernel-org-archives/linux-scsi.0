From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] SCSI: add check for host busy in scsi_run_queue()
Date: Sun, 19 Sep 2010 20:53:58 +0800
Message-ID: <AANLkTi=jMYEsMtTQmnMSKxwYNzpwCLLkgsEvHAxWj8ui@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48171 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab0ISMx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Sep 2010 08:53:59 -0400
Received: by wwb39 with SMTP id 39so2543678wwb.1
        for <linux-scsi@vger.kernel.org>; Sun, 19 Sep 2010 05:53:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@suse.de>

It seems that check for host busy is deserved before scanning the starved list.
And list operation is simplified.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- o/linux-2.6.36-rc4/drivers/scsi/scsi_lib.c	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/drivers/scsi/scsi_lib.c	2010-09-19
20:32:34.000000000 +0800
@@ -399,18 +399,20 @@ static inline int scsi_host_is_busy(stru
  */
 static void scsi_run_queue(struct request_queue *q)
 {
-	struct scsi_device *sdev = q->queuedata;
+	struct scsi_device *sdev = q->queuedata, *safe;
 	struct Scsi_Host *shost = sdev->host;
-	LIST_HEAD(starved_list);
 	unsigned long flags;

 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);

 	spin_lock_irqsave(shost->host_lock, flags);
-	list_splice_init(&shost->starved_list, &starved_list);
-
-	while (!list_empty(&starved_list)) {
+	if (scsi_host_is_busy(shost)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return;
+	}
+	list_for_each_entry_safe(sdev, safe, &shost->starved_list,
+					starved_entry) {
 		int flagset;

 		/*
@@ -426,14 +428,10 @@ static void scsi_run_queue(struct reques
 		if (scsi_host_is_busy(shost))
 			break;

-		sdev = list_entry(starved_list.next,
-				  struct scsi_device, starved_entry);
-		list_del_init(&sdev->starved_entry);
-		if (scsi_target_is_busy(scsi_target(sdev))) {
-			list_move_tail(&sdev->starved_entry,
-				       &shost->starved_list);
+		if (scsi_target_is_busy(scsi_target(sdev)))
 			continue;
-		}
+
+		list_del_init(&sdev->starved_entry);

 		spin_unlock(shost->host_lock);

@@ -450,8 +448,6 @@ static void scsi_run_queue(struct reques

 		spin_lock(shost->host_lock);
 	}
-	/* put any unprocessed entries back */
-	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);

 	blk_run_queue(q);
