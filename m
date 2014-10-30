From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] scsi: device handlers must have attach and detach methods
Date: Thu, 30 Oct 2014 10:19:12 +0100
Message-ID: <1414660754-8431-5-git-send-email-hch@lst.de>
References: <1414660754-8431-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540AbaJ3JTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:19:05 -0400
In-Reply-To: <1414660754-8431-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 1a8dbf3..d8a8aac 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -108,19 +108,17 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 		return 0;
 	}
 
-	if (scsi_dh->attach) {
-		if (!try_module_get(scsi_dh->module))
-			return -EINVAL;
-
-		err = scsi_dh->attach(sdev);
-		if (err) {
-			module_put(scsi_dh->module);
-			return err;
-		}
+	if (!try_module_get(scsi_dh->module))
+		return -EINVAL;
 
-		kref_init(&sdev->scsi_dh_data->kref);
-		sdev->scsi_dh_data->sdev = sdev;
+	err = scsi_dh->attach(sdev);
+	if (err) {
+		module_put(scsi_dh->module);
+		return err;
 	}
+
+	kref_init(&sdev->scsi_dh_data->kref);
+	sdev->scsi_dh_data->sdev = sdev;
 	return err;
 }
 
@@ -154,7 +152,7 @@ static void scsi_dh_handler_detach(struct scsi_device *sdev,
 	if (!scsi_dh)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 
-	if (scsi_dh && scsi_dh->detach)
+	if (scsi_dh)
 		kref_put(&sdev->scsi_dh_data->kref, __detach_handler);
 }
 
@@ -343,6 +341,9 @@ int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
 	if (get_device_handler(scsi_dh->name))
 		return -EBUSY;
 
+	if (!scsi_dh->attach || !scsi_dh->detach)
+		return -EINVAL;
+
 	spin_lock(&list_lock);
 	list_add(&scsi_dh->list, &scsi_dh_list);
 	spin_unlock(&list_lock);
-- 
1.9.1

