From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v4 04/10] scsi: Change to use list_for_each_entry_safe
Date: Thu,  1 Aug 2013 16:57:33 -0400
Message-ID: <1375390659-12495-5-git-send-email-emilne@redhat.com>
References: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab3HAU5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 16:57:45 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvjjc006217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:45 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvgvd031004
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:44 -0400
In-Reply-To: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

scsi_device_dev_release_usercontext() should be using
"list_for_each_entry_safe" instead of "list_for_each_safe".

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_sysfs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7394a77..34f7580 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -335,7 +335,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_device *sdev;
 	struct device *parent;
 	struct scsi_target *starget;
-	struct list_head *this, *tmp;
+	struct scsi_event *evt, *next;
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
@@ -352,10 +352,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	cancel_work_sync(&sdev->event_work);
 
-	list_for_each_safe(this, tmp, &sdev->event_list) {
-		struct scsi_event *evt;
-
-		evt = list_entry(this, struct scsi_event, node);
+	list_for_each_entry_safe(evt, next, &sdev->event_list, node) {
 		list_del(&evt->node);
 		kfree(evt);
 	}
-- 
1.7.11.7

