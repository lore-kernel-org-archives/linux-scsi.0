From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/10] dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath
Date: Thu, 27 Aug 2015 14:16:55 +0200
Message-ID: <1440677823-11695-3-git-send-email-hare@suse.de>
References: <1440677823-11695-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbbH0MRL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:17:11 -0400
In-Reply-To: <1440677823-11695-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

This way we can reused the same code any attachment method, not just those
requested from dm-mpath.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c                 |  6 ------
 drivers/scsi/device_handler/scsi_dh.c | 35 ++++++++++++++++++-----------------
 include/scsi/scsi_dh.h                |  5 -----
 3 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index a9f58fd..5a67671 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -725,12 +725,6 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 		return 0;
 
 	m->hw_handler_name = kstrdup(dm_shift_arg(as), GFP_KERNEL);
-	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
-				     "scsi_dh_%s", m->hw_handler_name)) {
-		ti->error = "unknown hardware handler type";
-		ret = -EINVAL;
-		goto fail;
-	}
 
 	if (hw_argc > 1) {
 		char *p;
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 869b5bd..5bd0af6 100644
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
1.8.5.6

