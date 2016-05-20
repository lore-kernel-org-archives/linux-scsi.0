From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] scsi: use spinlock instead of mutex for RCU-protected VPD inquiry data
Date: Fri, 20 May 2016 08:56:14 -0400
Message-ID: <1463748974-31315-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932617AbcETM4V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2016 08:56:21 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 2657A552F6
	for <linux-scsi@vger.kernel.org>; Fri, 20 May 2016 12:56:16 +0000 (UTC)
Received: from emilne.csb (dhcp-25-104.bos.redhat.com [10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u4KCuFn7018479
	for <linux-scsi@vger.kernel.org>; Fri, 20 May 2016 08:56:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

A spinlock is sufficient for this purpose, and much smaller.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi.c        | 8 ++++----
 drivers/scsi/scsi_scan.c   | 2 +-
 include/scsi/scsi_device.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1deb6ad..330d807 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -829,11 +829,11 @@ retry_pg80:
 			kfree(vpd_buf);
 			goto retry_pg80;
 		}
-		mutex_lock(&sdev->inquiry_mutex);
+		spin_lock(&sdev->inquiry_lock);
 		orig_vpd_buf = sdev->vpd_pg80;
 		sdev->vpd_pg80_len = result;
 		rcu_assign_pointer(sdev->vpd_pg80, vpd_buf);
-		mutex_unlock(&sdev->inquiry_mutex);
+		spin_unlock(&sdev->inquiry_lock);
 		synchronize_rcu();
 		if (orig_vpd_buf) {
 			kfree(orig_vpd_buf);
@@ -858,11 +858,11 @@ retry_pg83:
 			kfree(vpd_buf);
 			goto retry_pg83;
 		}
-		mutex_lock(&sdev->inquiry_mutex);
+		spin_lock(&sdev->inquiry_lock);
 		orig_vpd_buf = sdev->vpd_pg83;
 		sdev->vpd_pg83_len = result;
 		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
-		mutex_unlock(&sdev->inquiry_mutex);
+		spin_unlock(&sdev->inquiry_lock);
 		synchronize_rcu();
 		if (orig_vpd_buf)
 			kfree(orig_vpd_buf);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e0a78f5..f445615 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -240,7 +240,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
-	mutex_init(&sdev->inquiry_mutex);
+	spin_lock_init(&sdev->inquiry_lock);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a6c346d..0410ed8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -115,7 +115,7 @@ struct scsi_device {
 	char type;
 	char scsi_level;
 	char inq_periph_qual;	/* PQ from INQUIRY data */	
-	struct mutex inquiry_mutex;
+	spinlock_t inquiry_lock;
 	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
 	unsigned char * inquiry;	/* INQUIRY response data */
 	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
-- 
2.1.0

