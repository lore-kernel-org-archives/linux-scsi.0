From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/3] scsi_dh: Change the scsidh_activate interface to be asynchronous
Date: Mon, 27 Apr 2009 19:52:36 -0700
Message-ID: <20090428025236.11108.32014.sendpatchset@chandra-ubuntu>
References: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43345 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZD1Cvn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 22:51:43 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3S2mEDa017986
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 20:48:14 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3S2phs0099832
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 20:51:43 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3S2phLp002958
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 20:51:43 -0600
In-Reply-To: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, babu.moger@lsi.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>

Make scsi_dh_activate() function asynchronous, by taking in two additional 
parameters, one is the callback function and the other is the data to call
the callback function with.

--------------
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
 drivers/md/dm-mpath.c                       |    7 ++++---
 drivers/scsi/device_handler/scsi_dh.c       |    6 +++---
 drivers/scsi/device_handler/scsi_dh_alua.c  |    6 ++++--
 drivers/scsi/device_handler/scsi_dh_emc.c   |    6 ++++--
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    6 ++++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    6 ++++--
 include/scsi/scsi_device.h                  |    3 ++-
 include/scsi/scsi_dh.h                      |    7 +++++--
 8 files changed, 30 insertions(+), 17 deletions(-)

Index: linux-2.6.29/include/scsi/scsi_dh.h
===================================================================
--- linux-2.6.29.orig/include/scsi/scsi_dh.h
+++ linux-2.6.29/include/scsi/scsi_dh.h
@@ -55,14 +55,17 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
+
 #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
-extern int scsi_dh_activate(struct request_queue *);
+extern int scsi_dh_activate(struct request_queue *, activate_complete, void *);
 extern int scsi_dh_handler_exist(const char *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern void scsi_dh_detach(struct request_queue *);
 #else
-static inline int scsi_dh_activate(struct request_queue *req)
+static inline int scsi_dh_activate(struct request_queue *req,
+					activate_complete fn, void *data)
 {
+	fn(data, 0);
 	return 0;
 }
 static inline int scsi_dh_handler_exist(const char *name)
Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh.c
@@ -214,7 +214,7 @@ store_dh_state(struct device *dev, struc
 			 * Activate a device handler
 			 */
 			if (scsi_dh->activate)
-				err = scsi_dh->activate(sdev);
+				err = scsi_dh->activate(sdev, NULL, NULL);
 			else
 				err = 0;
 		}
@@ -414,7 +414,7 @@ EXPORT_SYMBOL_GPL(scsi_unregister_device
  * @q - Request queue that is associated with the scsi_device to be
  *      activated.
  */
-int scsi_dh_activate(struct request_queue *q)
+int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 {
 	int err = 0;
 	unsigned long flags;
@@ -433,7 +433,7 @@ int scsi_dh_activate(struct request_queu
 		return err;
 
 	if (scsi_dh->activate)
-		err = scsi_dh->activate(sdev);
+		err = scsi_dh->activate(sdev, fn, data);
 	put_device(&sdev->sdev_gendev);
 	return err;
 }
Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -516,7 +516,7 @@ done:
 	return err;
 }
 
-static int rdac_activate(struct scsi_device *sdev)
+static int rdac_activate(struct scsi_device *sdev, activate_complete fn, void *data)
 {
 	struct rdac_dh_data *h = get_rdac_data(sdev);
 	int err = SCSI_DH_OK;
@@ -539,7 +539,9 @@ static int rdac_activate(struct scsi_dev
 	if (h->lun_state == RDAC_LUN_UNOWNED)
 		err = send_mode_select(sdev, h);
 done:
-	return err;
+	if (fn)
+		fn(data, err);
+	return 0;
 }
 
 static int rdac_prep_fn(struct scsi_device *sdev, struct request *req)
Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh_alua.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -652,7 +652,7 @@ out:
  * based on a certain policy. But until we actually encounter them it
  * should be okay.
  */
-static int alua_activate(struct scsi_device *sdev)
+static int alua_activate(struct scsi_device *sdev, activate_complete fn, void *data)
 {
 	struct alua_dh_data *h = get_alua_data(sdev);
 	int err = SCSI_DH_OK;
@@ -667,7 +667,9 @@ static int alua_activate(struct scsi_dev
 		err = alua_stpg(sdev, TPGS_STATE_OPTIMIZED, h);
 
 out:
-	return err;
+	if (fn)
+		fn(data, err);
+	return 0;
 }
 
 /*
Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh_emc.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh_emc.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -528,7 +528,7 @@ retry:
 	return err;
 }
 
-static int clariion_activate(struct scsi_device *sdev)
+static int clariion_activate(struct scsi_device *sdev, activate_complete fn, void *data)
 {
 	struct clariion_dh_data *csdev = get_clariion_data(sdev);
 	int result;
@@ -559,7 +559,9 @@ done:
 		    csdev->port, lun_state[csdev->lun_state],
 		    csdev->default_sp + 'A');
 
-	return result;
+	if (fn)
+		fn(data, result);
+	return 0;
 }
 
 static const struct scsi_dh_devlist clariion_dev_list[] = {
Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh_hp_sw.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -268,7 +268,7 @@ static int hp_sw_prep_fn(struct scsi_dev
  * activate the passive path (and deactivate the
  * previously active one).
  */
-static int hp_sw_activate(struct scsi_device *sdev)
+static int hp_sw_activate(struct scsi_device *sdev, activate_complete fn, void *data)
 {
 	int ret = SCSI_DH_OK;
 	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
@@ -283,7 +283,9 @@ static int hp_sw_activate(struct scsi_de
 				    HP_SW_NAME);
 	}
 
-	return ret;
+	if (fn)
+		fn(data, ret);
+	return 0;
 }
 
 static const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
Index: linux-2.6.29/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.29.orig/include/scsi/scsi_device.h
+++ linux-2.6.29/include/scsi/scsi_device.h
@@ -174,6 +174,7 @@ struct scsi_dh_devlist {
 	char *model;
 };
 
+typedef void (*activate_complete)(void *, int);
 struct scsi_device_handler {
 	/* Used by the infrastructure */
 	struct list_head list; /* list of scsi_device_handlers */
@@ -185,7 +186,7 @@ struct scsi_device_handler {
 	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
 	int (*attach)(struct scsi_device *);
 	void (*detach)(struct scsi_device *);
-	int (*activate)(struct scsi_device *);
+	int (*activate)(struct scsi_device *, activate_complete, void *);
 	int (*prep_fn)(struct scsi_device *, struct request *);
 };
 
Index: linux-2.6.29/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.29.orig/drivers/md/dm-mpath.c
+++ linux-2.6.29/drivers/md/dm-mpath.c
@@ -1053,8 +1053,9 @@ static int pg_init_limit_reached(struct
 	return limit_reached;
 }
 
-static void pg_init_done(struct dm_path *path, int errors)
+static void pg_init_done(void *data, int errors)
 {
+	struct dm_path *path = data;
 	struct pgpath *pgpath = path_to_pgpath(path);
 	struct priority_group *pg = pgpath->pg;
 	struct multipath *m = pg->m;
@@ -1129,8 +1130,8 @@ static void activate_path(struct work_st
 	spin_unlock_irqrestore(&m->lock, flags);
 	if (!path)
 		return;
-	ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev));
-	pg_init_done(path, ret);
+	ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev),
+				pg_init_done, path);
 }
 
 /*
