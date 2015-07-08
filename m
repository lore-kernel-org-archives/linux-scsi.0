From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] scsi_dh: add 'rescan' callback
Date: Wed,  8 Jul 2015 13:09:45 +0200
Message-ID: <1436353788-104911-3-git-send-email-hare@suse.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933800AbbGHLJw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 07:09:52 -0400
In-Reply-To: <1436353788-104911-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

If a device needs to be rescanned the device_handler might need
to be rechecked, too.
So add a 'rescan' callback to the device handler and call it
upon scsi_rescan_device().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 53 +++++++++++++++++++++++-------
 drivers/scsi/scsi_lib.c                    |  1 +
 drivers/scsi/scsi_scan.c                   |  8 ++++-
 include/scsi/scsi_dh.h                     |  1 +
 4 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e4cabc8..5b52017 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -262,7 +262,8 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 	int group_id = -1;
 	char device_id_str[256], *device_id = NULL;
 	int device_id_size, device_id_type = 0;
-	struct alua_port_group *tmp_pg, *pg = NULL;
+	struct alua_port_group *tmp_pg, *pg = NULL, *old_pg = NULL;
+	bool pg_found = false;
 
 	rcu_read_lock();
 	if (!rcu_dereference(sdev->vpd_pg83)) {
@@ -407,17 +408,25 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		if (memcmp(tmp_pg->device_id, device_id,
 			   device_id_size))
 			continue;
-		kref_get(&tmp_pg->kref);
 		spin_lock(&h->pg_lock);
-		rcu_assign_pointer(h->pg, tmp_pg);
+		pg = rcu_dereference(h->pg);
+		if (pg) {
+			/*
+			 * This can happen if the VPD information changed
+			 */
+			if (tmp_pg != pg) {
+				old_pg = pg;
+				kref_get(&tmp_pg->kref);
+				rcu_assign_pointer(h->pg, tmp_pg);
+			}
+			pg_found = true;
+		}
 		spin_unlock(&h->pg_lock);
 		break;
 	}
 	spin_unlock(&port_group_lock);
-	if (h->pg) {
-		synchronize_rcu();
-		return SCSI_DH_OK;
-	}
+	if (pg_found)
+		goto out;
 
 	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
 	if (!pg) {
@@ -466,12 +475,17 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		if (memcmp(tmp_pg->device_id, pg->device_id,
 			   device_id_size))
 			continue;
-		kref_get(&tmp_pg->kref);
 		spin_lock(&h->pg_lock);
-		rcu_assign_pointer(h->pg, tmp_pg);
+		pg = rcu_dereference(h->pg);
+		if (pg) {
+			if (tmp_pg != pg) {
+				old_pg = pg;
+				kref_get(&tmp_pg->kref);
+				rcu_assign_pointer(h->pg, tmp_pg);
+			}
+			pg = NULL;
+		}
 		spin_unlock(&h->pg_lock);
-		kfree(pg);
-		pg = NULL;
 		break;
 	}
 	if (pg) {
@@ -481,6 +495,13 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		spin_unlock(&h->pg_lock);
 	}
 	spin_unlock(&port_group_lock);
+out:
+	if (old_pg) {
+		synchronize_rcu();
+		if (old_pg->rtpg_sdev)
+			flush_workqueue(old_pg->work_q);
+		kref_put(&pg->kref, release_port_group);
+	}
 
 	return SCSI_DH_OK;
 }
@@ -1011,6 +1032,8 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 			kref_get(&pg->kref);
 			rcu_read_unlock();
 		}
+	} else {
+		WARN_ON(rcu_dereference(h->pg));
 	}
 	complete(&h->init_complete);
 	if (pg) {
@@ -1195,6 +1218,13 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 
 }
 
+static void alua_rescan(struct scsi_device *sdev)
+{
+	struct alua_dh_data *h = sdev->handler_data;
+
+	alua_initialize(sdev, h);
+}
+
 /*
  * alua_bus_attach - Attach device handler
  * @sdev: device to be attached to
@@ -1256,6 +1286,7 @@ static struct scsi_device_handler alua_dh = {
 	.prep_fn = alua_prep_fn,
 	.check_sense = alua_check_sense,
 	.activate = alua_activate,
+	.rescan = alua_rescan,
 	.set_params = alua_set_params,
 };
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 18ab4ad..991b9e1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2704,6 +2704,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 		envp[idx++] = "SDEV_MEDIA_CHANGE=1";
 		break;
 	case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
+		scsi_rescan_device(&sdev->sdev_gendev);
 		envp[idx++] = "SDEV_UA=INQUIRY_DATA_HAS_CHANGED";
 		break;
 	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 190d743..5d3e2ae 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -43,6 +43,7 @@
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
+#include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
 
 #include "scsi_priv.h"
@@ -1516,9 +1517,14 @@ EXPORT_SYMBOL(scsi_add_device);
 
 void scsi_rescan_device(struct device *dev)
 {
+	struct scsi_device *sdev = to_scsi_device(dev);
+
 	device_lock(dev);
 
-	scsi_attach_vpd(to_scsi_device(dev));
+	scsi_attach_vpd(sdev);
+
+	if (sdev->handler && sdev->handler->rescan)
+		sdev->handler->rescan(sdev);
 
 	if (dev->driver && try_module_get(dev->driver->owner)) {
 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 85d7317..5c73062 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -70,6 +70,7 @@ struct scsi_device_handler {
 	int (*activate)(struct scsi_device *, activate_complete, void *);
 	int (*prep_fn)(struct scsi_device *, struct request *);
 	int (*set_params)(struct scsi_device *, const char *);
+	void (*rescan)(struct scsi_device *);
 };
 
 #ifdef CONFIG_SCSI_DH
-- 
1.8.5.2

