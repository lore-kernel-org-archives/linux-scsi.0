From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/9] dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath
Date: Thu, 30 Apr 2015 19:32:26 +0200
Message-ID: <1430415151-30948-5-git-send-email-hch@lst.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbbD3ReF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 13:34:05 -0400
In-Reply-To: <1430415151-30948-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

This way we can reused the same code any attachment method, not just those
requested from dm-mpath.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c                 |  7 -------
 drivers/scsi/device_handler/scsi_dh.c | 35 ++++++++++++++++++-----------------
 include/scsi/scsi_dh.h                |  5 -----
 3 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f6d40d3..04c1a99 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -720,13 +720,6 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 	if (!m->hw_handler_name)
 		return -ENOMEM;
 
-	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
-				     "scsi_dh_%s", m->hw_handler_name)) {
-		ti->error = "unknown hardware handler type";
-		ret = -EINVAL;
-		goto fail;
-	}
-
 	if (hw_argc > 1) {
 		char *p;
 		int i, j, len = 4;
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 93fd7d4..e6ed565 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -29,7 +29,7 @@
 static DEFINE_SPINLOCK(list_lock);
 static LIST_HEAD(scsi_dh_list);
 
-static struct scsi_device_handler *get_device_handler(const char *name)
+static struct scsi_device_handler *__scsi_dh_lookup(const char *name)
 {
 	struct scsi_device_handler *tmp, *found = NULL;
 
@@ -44,6 +44,19 @@ static struct scsi_device_handler *get_device_handler(const char *name)
 	return found;
 }
 
+static struct scsi_device_handler *scsi_dh_lookup(const char *name)
+{
+	struct scsi_device_handler *dh;
+
+	dh = __scsi_dh_lookup(name);
+	if (!dh) {
+		request_module(name);
+		dh = __scsi_dh_lookup(name);
+	}
+
+	return dh;
+}
+
 /*
  * device_handler_match_function - Match a device handler to a device
  * @sdev - SCSI device to be tested
@@ -158,7 +171,7 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 		/*
 		 * Attach to a device handler
 		 */
-		if (!(scsi_dh = get_device_handler(buf)))
+		if (!(scsi_dh = scsi_dh_lookup(buf)))
 			return err;
 		err = scsi_dh_handler_attach(sdev, scsi_dh);
 	} else {
@@ -322,8 +335,7 @@ static int scsi_dh_notifier_remove(struct device *dev, void *data)
  */
 int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
 {
-
-	if (get_device_handler(scsi_dh->name))
+	if (__scsi_dh_lookup(scsi_dh->name))
 		return -EBUSY;
 
 	if (!scsi_dh->attach || !scsi_dh->detach)
@@ -350,7 +362,7 @@ EXPORT_SYMBOL_GPL(scsi_register_device_handler);
 int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 {
 
-	if (!get_device_handler(scsi_dh->name))
+	if (!__scsi_dh_lookup(scsi_dh->name))
 		return -ENODEV;
 
 	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh,
@@ -455,17 +467,6 @@ int scsi_dh_set_params(struct request_queue *q, const char *params)
 EXPORT_SYMBOL_GPL(scsi_dh_set_params);
 
 /*
- * scsi_dh_handler_exist - Return TRUE(1) if a device handler exists for
- *	the given name. FALSE(0) otherwise.
- * @name - name of the device handler.
- */
-int scsi_dh_handler_exist(const char *name)
-{
-	return (get_device_handler(name) != NULL);
-}
-EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
-
-/*
  * scsi_dh_attach - Attach device handler
  * @q - Request queue that is associated with the scsi_device
  *      the handler should be attached to
@@ -478,7 +479,7 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 	struct scsi_device_handler *scsi_dh;
 	int err = 0;
 
-	scsi_dh = get_device_handler(name);
+	scsi_dh = scsi_dh_lookup(name);
 	if (!scsi_dh)
 		return -EINVAL;
 
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 99c9196..966b921 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -57,7 +57,6 @@ enum {
 };
 #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
 extern int scsi_dh_activate(struct request_queue *, activate_complete, void *);
-extern int scsi_dh_handler_exist(const char *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern const char *scsi_dh_attached_handler_name(struct request_queue *, gfp_t);
 extern int scsi_dh_set_params(struct request_queue *, const char *);
@@ -68,10 +67,6 @@ static inline int scsi_dh_activate(struct request_queue *req,
 	fn(data, 0);
 	return 0;
 }
-static inline int scsi_dh_handler_exist(const char *name)
-{
-	return 0;
-}
 static inline int scsi_dh_attach(struct request_queue *req, const char *name)
 {
 	return SCSI_DH_NOSYS;
-- 
1.9.1

