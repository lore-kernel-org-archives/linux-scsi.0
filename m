From: James.Smart@Emulex.Com
Subject: [PATCH] shorten workqueue name length
Date: Tue, 9 Aug 2005 12:07:12 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD19@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:15598 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S964846AbVHIQHV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 12:07:21 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j79G7Dr7019367
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2005 09:07:13 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A customer passed this fix to me...

In a system with double-digit adapter counts, after a few
rmmod/insmod attempts, the system oops. It always occurs when
the scsi host number reaches 100.

What is happening is that scsi_add_host() detects a transport that
needs to allocate a workqueue, thus calls create_singlethread_workqueue().
It hits a BUG_ON() in kernel/workqueue.c:__create_workqueue() which
ensures the length of the name for the workqueue is 10 characters or less.
As the name is "scsi_wq_100", we have exceeded the 10 character max.

I assume there's good reason for the name to be 10 or less. So what I've
done is shorten the name for the workqueue. Should work until the host number
reaches 10000.

-- James S

--- scsi-misc-2.6.20050808/drivers/scsi/hosts.c	2005-08-08 16:25:30.000000000 -0400
+++ scsi-misc-2.6.20050808/drivers/scsi/hosts.c.new	2005-08-09 11:55:06.000000000 -0400
@@ -191,7 +191,7 @@ int scsi_add_host(struct Scsi_Host *shos
 		goto out_del_classdev;
 
 	if (shost->transportt->create_work_queue) {
-		snprintf(shost->work_q_name, KOBJ_NAME_LEN, "scsi_wq_%d",
+		snprintf(shost->work_q_name, KOBJ_NAME_LEN, "scsiwq%d",
 			shost->host_no);
 		shost->work_q = create_singlethread_workqueue(
 					shost->work_q_name);
