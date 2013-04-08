From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] [SCSI] scsi_dh: add scsi_dh_alloc_data
Date: Mon,  8 Apr 2013 17:50:15 -0400
Message-ID: <1365457816-31475-1-git-send-email-snitzer@redhat.com>
References: <20130404131631.GA10208@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934149Ab3DHVvM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Apr 2013 17:51:12 -0400
In-Reply-To: <20130404131631.GA10208@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: hare@suse.de, mpatocka@redhat.com

Factor scsi_dh_data allocation out from scsi_dh_attach to the
optional scsi_dh_alloc_data interface.  scsi_dh_attach will still
allocate the the appropriate scsi_dh_data if a NULL scsi_dh_data struct
is passed to it.  In that case, all scsi_dh will now use GFP_NOIO to
allocate scsi_dh_data.

This change will allow DM multipath to preallocate the scsi_dh_data
during the multipath table load but then defer the scsi_dh_attach until
the multipath table resume (memory allocation is not allowed during DM
table resume).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c                       |    4 +-
 drivers/scsi/device_handler/scsi_dh.c       |   42 +++++++++++++++++++++-----
 drivers/scsi/device_handler/scsi_dh_alua.c  |   18 ++++++++---
 drivers/scsi/device_handler/scsi_dh_emc.c   |   18 ++++++++---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   18 ++++++++---
 drivers/scsi/device_handler/scsi_dh_rdac.c  |   18 ++++++++---
 include/scsi/scsi_device.h                  |    3 +-
 include/scsi/scsi_dh.h                      |    4 ++-
 8 files changed, 93 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 51bb816..37d9ead 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -616,14 +616,14 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		 * Increments scsi_dh reference, even when using an
 		 * already-attached handler.
 		 */
-		r = scsi_dh_attach(q, m->hw_handler_name);
+		r = scsi_dh_attach(q, m->hw_handler_name, NULL);
 		if (r == -EBUSY) {
 			/*
 			 * Already attached to different hw_handler:
 			 * try to reattach with correct one.
 			 */
 			scsi_dh_detach(q);
-			r = scsi_dh_attach(q, m->hw_handler_name);
+			r = scsi_dh_attach(q, m->hw_handler_name, NULL);
 		}
 
 		if (r < 0) {
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 33e422e..034b394 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -94,19 +94,24 @@ device_handler_match(struct scsi_device_handler *scsi_dh,
  * scsi_dh_handler_attach - Attach a device handler to a device
  * @sdev - SCSI device the device handler should attach to
  * @scsi_dh - The device handler to attach
+ * @scsi_dh_data - if not NULL it is either assigned to sdev->scsi_dh_data
+ *                 on attach or free'd if the scsi_dh is already attached.
  */
 static int scsi_dh_handler_attach(struct scsi_device *sdev,
-				  struct scsi_device_handler *scsi_dh)
+				  struct scsi_device_handler *scsi_dh,
+				  struct scsi_dh_data *scsi_dh_data)
 {
 	int err = 0;
 
 	if (sdev->scsi_dh_data) {
 		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
 			err = -EBUSY;
-		else
+		else {
 			kref_get(&sdev->scsi_dh_data->kref);
+			kfree(scsi_dh_data);
+		}
 	} else if (scsi_dh->attach) {
-		err = scsi_dh->attach(sdev);
+		err = scsi_dh->attach(sdev, scsi_dh_data);
 		if (!err) {
 			kref_init(&sdev->scsi_dh_data->kref);
 			sdev->scsi_dh_data->sdev = sdev;
@@ -166,7 +171,7 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 		 */
 		if (!(scsi_dh = get_device_handler(buf)))
 			return err;
-		err = scsi_dh_handler_attach(sdev, scsi_dh);
+		err = scsi_dh_handler_attach(sdev, scsi_dh, NULL);
 	} else {
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 		if (!strncmp(buf, "detach", 6)) {
@@ -262,7 +267,7 @@ static int scsi_dh_notifier(struct notifier_block *nb,
 		/* don't care about err */
 		devinfo = device_handler_match(NULL, sdev);
 		if (devinfo)
-			err = scsi_dh_handler_attach(sdev, devinfo);
+			err = scsi_dh_handler_attach(sdev, devinfo, NULL);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		device_remove_file(dev, &scsi_dh_state_attr);
 		scsi_dh_handler_detach(sdev, NULL);
@@ -287,7 +292,7 @@ static int scsi_dh_notifier_add(struct device *dev, void *data)
 	sdev = to_scsi_device(dev);
 
 	if (device_handler_match(scsi_dh, sdev))
-		scsi_dh_handler_attach(sdev, scsi_dh);
+		scsi_dh_handler_attach(sdev, scsi_dh, NULL);
 
 	put_device(dev);
 
@@ -466,13 +471,34 @@ int scsi_dh_handler_exist(const char *name)
 }
 EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
 
+struct scsi_dh_data *scsi_dh_alloc_data(const char *name, gfp_t flags)
+{
+	struct scsi_device_handler *scsi_dh;
+	struct scsi_dh_data *scsi_dh_data;
+	size_t scsi_dh_data_size = sizeof(sizeof(*scsi_dh_data));
+
+	scsi_dh = get_device_handler(name);
+	if (!scsi_dh)
+		return ERR_PTR(-EINVAL);
+
+	if (scsi_dh->get_dh_data_size)
+		scsi_dh_data_size += scsi_dh->get_dh_data_size();
+	scsi_dh_data = kzalloc(scsi_dh_data_size, flags);
+	if (!scsi_dh_data)
+		return ERR_PTR(-ENOMEM);
+
+	return scsi_dh_data;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_alloc_data);
+
 /*
  * scsi_dh_attach - Attach device handler
  * @q - Request queue that is associated with the scsi_device
  *      the handler should be attached to
  * @name - name of the handler to attach
  */
-int scsi_dh_attach(struct request_queue *q, const char *name)
+int scsi_dh_attach(struct request_queue *q, const char *name,
+		   struct scsi_dh_data *scsi_dh_data)
 {
 	unsigned long flags;
 	struct scsi_device *sdev;
@@ -490,7 +516,7 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	if (!err) {
-		err = scsi_dh_handler_attach(sdev, scsi_dh);
+		err = scsi_dh_handler_attach(sdev, scsi_dh, scsi_dh_data);
 		put_device(&sdev->sdev_gendev);
 	}
 	return err;
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6f4d8e6..2334db1 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -798,7 +798,13 @@ static bool alua_match(struct scsi_device *sdev)
 	return (scsi_device_tpgs(sdev) != 0);
 }
 
-static int alua_bus_attach(struct scsi_device *sdev);
+static size_t alua_dh_data_size(void)
+{
+	return sizeof(struct alua_dh_data);
+}
+
+static int alua_bus_attach(struct scsi_device *sdev,
+			   struct scsi_dh_data *scsi_dh_data);
 static void alua_bus_detach(struct scsi_device *sdev);
 
 static struct scsi_device_handler alua_dh = {
@@ -811,21 +817,23 @@ static struct scsi_device_handler alua_dh = {
 	.activate = alua_activate,
 	.set_params = alua_set_params,
 	.match = alua_match,
+	.get_dh_data_size = alua_dh_data_size,
 };
 
 /*
  * alua_bus_attach - Attach device handler
  * @sdev: device to be attached to
  */
-static int alua_bus_attach(struct scsi_device *sdev)
+static int alua_bus_attach(struct scsi_device *sdev,
+			   struct scsi_dh_data *scsi_dh_data)
 {
-	struct scsi_dh_data *scsi_dh_data;
 	struct alua_dh_data *h;
 	unsigned long flags;
 	int err = SCSI_DH_OK;
 
-	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
-			       + sizeof(*h) , GFP_KERNEL);
+	if (!scsi_dh_data)
+		scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
+				       + sizeof(*h) , GFP_NOIO);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
 			    ALUA_DH_NAME);
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index e1c8be0..fa0553a 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -647,7 +647,13 @@ static bool clariion_match(struct scsi_device *sdev)
 	return false;
 }
 
-static int clariion_bus_attach(struct scsi_device *sdev);
+static size_t clariion_dh_data_size(void)
+{
+	return sizeof(struct clariion_dh_data);
+}
+
+static int clariion_bus_attach(struct scsi_device *sdev,
+			       struct scsi_dh_data *scsi_dh_data);
 static void clariion_bus_detach(struct scsi_device *sdev);
 
 static struct scsi_device_handler clariion_dh = {
@@ -661,17 +667,19 @@ static struct scsi_device_handler clariion_dh = {
 	.prep_fn	= clariion_prep_fn,
 	.set_params	= clariion_set_params,
 	.match		= clariion_match,
+	.get_dh_data_size = clariion_dh_data_size,
 };
 
-static int clariion_bus_attach(struct scsi_device *sdev)
+static int clariion_bus_attach(struct scsi_device *sdev,
+			       struct scsi_dh_data *scsi_dh_data)
 {
-	struct scsi_dh_data *scsi_dh_data;
 	struct clariion_dh_data *h;
 	unsigned long flags;
 	int err;
 
-	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
-			       + sizeof(*h) , GFP_KERNEL);
+	if (!scsi_dh_data)
+		scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
+				       + sizeof(*h) , GFP_NOIO);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
 			    CLARIION_NAME);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 084062b..c0a13e6 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -338,7 +338,13 @@ static bool hp_sw_match(struct scsi_device *sdev)
 	return false;
 }
 
-static int hp_sw_bus_attach(struct scsi_device *sdev);
+static size_t hp_sw_dh_data_size(void)
+{
+	return sizeof(struct hp_sw_dh_data);
+}
+
+static int hp_sw_bus_attach(struct scsi_device *sdev,
+			    struct scsi_dh_data *scsi_dh_data);
 static void hp_sw_bus_detach(struct scsi_device *sdev);
 
 static struct scsi_device_handler hp_sw_dh = {
@@ -350,17 +356,19 @@ static struct scsi_device_handler hp_sw_dh = {
 	.activate	= hp_sw_activate,
 	.prep_fn	= hp_sw_prep_fn,
 	.match		= hp_sw_match,
+	.get_dh_data_size = hp_sw_dh_data_size,
 };
 
-static int hp_sw_bus_attach(struct scsi_device *sdev)
+static int hp_sw_bus_attach(struct scsi_device *sdev,
+			    struct scsi_dh_data *scsi_dh_data)
 {
-	struct scsi_dh_data *scsi_dh_data;
 	struct hp_sw_dh_data *h;
 	unsigned long flags;
 	int ret;
 
-	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
-			       + sizeof(*h) , GFP_KERNEL);
+	if (!scsi_dh_data)
+		scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
+				       + sizeof(*h) , GFP_NOIO);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
 			    HP_SW_NAME);
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 69c915a..77ebc2d 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -824,7 +824,13 @@ static bool rdac_match(struct scsi_device *sdev)
 	return false;
 }
 
-static int rdac_bus_attach(struct scsi_device *sdev);
+static size_t rdac_dh_data_size(void)
+{
+	return sizeof(struct rdac_dh_data);
+}
+
+static int rdac_bus_attach(struct scsi_device *sdev,
+			   struct scsi_dh_data *scsi_dh_data);
 static void rdac_bus_detach(struct scsi_device *sdev);
 
 static struct scsi_device_handler rdac_dh = {
@@ -837,19 +843,21 @@ static struct scsi_device_handler rdac_dh = {
 	.detach = rdac_bus_detach,
 	.activate = rdac_activate,
 	.match = rdac_match,
+	.get_dh_data_size = rdac_dh_data_size,
 };
 
-static int rdac_bus_attach(struct scsi_device *sdev)
+static int rdac_bus_attach(struct scsi_device *sdev,
+			   struct scsi_dh_data *scsi_dh_data)
 {
-	struct scsi_dh_data *scsi_dh_data;
 	struct rdac_dh_data *h;
 	unsigned long flags;
 	int err;
 	char array_name[ARRAY_LABEL_LEN];
 	char array_id[UNIQUE_ID_LEN];
 
-	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
-			       + sizeof(*h) , GFP_KERNEL);
+	if (!scsi_dh_data)
+		scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
+				       + sizeof(*h) , GFP_NOIO);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
 			    RDAC_NAME);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a7f9cba..4f4feb4 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -201,12 +201,13 @@ struct scsi_device_handler {
 	const char *name;
 	const struct scsi_dh_devlist *devlist;
 	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
-	int (*attach)(struct scsi_device *);
+	int (*attach)(struct scsi_device *, struct scsi_dh_data *);
 	void (*detach)(struct scsi_device *);
 	int (*activate)(struct scsi_device *, activate_complete, void *);
 	int (*prep_fn)(struct scsi_device *, struct request *);
 	int (*set_params)(struct scsi_device *, const char *);
 	bool (*match)(struct scsi_device *);
+	size_t (*get_dh_data_size)(void);
 };
 
 struct scsi_dh_data {
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 620c723..26b7d8b 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -58,7 +58,9 @@ enum {
 #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
 extern int scsi_dh_activate(struct request_queue *, activate_complete, void *);
 extern int scsi_dh_handler_exist(const char *);
-extern int scsi_dh_attach(struct request_queue *, const char *);
+extern struct scsi_dh_data *scsi_dh_alloc_data(const char *, gfp_t);
+extern int scsi_dh_attach(struct request_queue *, const char *,
+			  struct scsi_dh_data *);
 extern void scsi_dh_detach(struct request_queue *);
 extern const char *scsi_dh_attached_handler_name(struct request_queue *, gfp_t);
 extern int scsi_dh_set_params(struct request_queue *, const char *);
-- 
1.7.1

