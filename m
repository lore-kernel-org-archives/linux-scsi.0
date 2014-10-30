From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] scsi_dh: get module reference outside of device handler
Date: Thu, 30 Oct 2014 10:19:09 +0100
Message-ID: <1414660754-8431-2-git-send-email-hch@lst.de>
References: <1414660754-8431-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505AbaJ3JTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:19:05 -0400
In-Reply-To: <1414660754-8431-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

We need to grab a reference to the module before calling the attach
routines to avoid a small race vs module removal.  It also cleans up
the code significantly as a side effect.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c       | 31 ++++++++++++++++++++---------
 drivers/scsi/device_handler/scsi_dh_alua.c  |  4 ----
 drivers/scsi/device_handler/scsi_dh_emc.c   |  4 ----
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ----
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  4 ----
 5 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 33e422e..1a8dbf3 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -102,23 +102,36 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 
 	if (sdev->scsi_dh_data) {
 		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
-			err = -EBUSY;
-		else
-			kref_get(&sdev->scsi_dh_data->kref);
-	} else if (scsi_dh->attach) {
+			return -EBUSY;
+
+		kref_get(&sdev->scsi_dh_data->kref);
+		return 0;
+	}
+
+	if (scsi_dh->attach) {
+		if (!try_module_get(scsi_dh->module))
+			return -EINVAL;
+
 		err = scsi_dh->attach(sdev);
-		if (!err) {
-			kref_init(&sdev->scsi_dh_data->kref);
-			sdev->scsi_dh_data->sdev = sdev;
+		if (err) {
+			module_put(scsi_dh->module);
+			return err;
 		}
+
+		kref_init(&sdev->scsi_dh_data->kref);
+		sdev->scsi_dh_data->sdev = sdev;
 	}
 	return err;
 }
 
 static void __detach_handler (struct kref *kref)
 {
-	struct scsi_dh_data *scsi_dh_data = container_of(kref, struct scsi_dh_data, kref);
-	scsi_dh_data->scsi_dh->detach(scsi_dh_data->sdev);
+	struct scsi_dh_data *scsi_dh_data =
+		container_of(kref, struct scsi_dh_data, kref);
+	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
+
+	scsi_dh->detach(scsi_dh_data->sdev);
+	module_put(scsi_dh->module);
 }
 
 /*
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e99507e..45b1795 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -866,9 +866,6 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	if ((err != SCSI_DH_OK) && (err != SCSI_DH_DEV_OFFLINED))
 		goto failed;
 
-	if (!try_module_get(THIS_MODULE))
-		goto failed;
-
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
@@ -901,7 +898,6 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	if (h->buff && h->inq != h->buff)
 		kfree(h->buff);
 	kfree(scsi_dh_data);
-	module_put(THIS_MODULE);
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", ALUA_DH_NAME);
 }
 
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 8476538..153b4c3 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -692,9 +692,6 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 	if (err != SCSI_DH_OK)
 		goto failed;
 
-	if (!try_module_get(THIS_MODULE))
-		goto failed;
-
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
@@ -728,7 +725,6 @@ static void clariion_bus_detach(struct scsi_device *sdev)
 		    CLARIION_NAME);
 
 	kfree(scsi_dh_data);
-	module_put(THIS_MODULE);
 }
 
 static int __init clariion_init(void)
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 4ee2759..367e6f5 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -377,9 +377,6 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
 	if (ret != SCSI_DH_OK || h->path_state == HP_SW_PATH_UNINITIALIZED)
 		goto failed;
 
-	if (!try_module_get(THIS_MODULE))
-		goto failed;
-
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
@@ -406,7 +403,6 @@ static void hp_sw_bus_detach( struct scsi_device *sdev )
 	scsi_dh_data = sdev->scsi_dh_data;
 	sdev->scsi_dh_data = NULL;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-	module_put(THIS_MODULE);
 
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", HP_SW_NAME);
 
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 1b5bc92..b850954 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -878,9 +878,6 @@ static int rdac_bus_attach(struct scsi_device *sdev)
 	if (err != SCSI_DH_OK)
 		goto clean_ctlr;
 
-	if (!try_module_get(THIS_MODULE))
-		goto clean_ctlr;
-
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
@@ -924,7 +921,6 @@ static void rdac_bus_detach( struct scsi_device *sdev )
 		kref_put(&h->ctlr->kref, release_controller);
 	spin_unlock(&list_lock);
 	kfree(scsi_dh_data);
-	module_put(THIS_MODULE);
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", RDAC_NAME);
 }
 
-- 
1.9.1

