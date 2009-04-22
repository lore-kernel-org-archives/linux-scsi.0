From: michaelc@cs.wisc.edu
Subject: [PATCH] RFC: have dm-mpath use already attached scsi_dh
Date: Tue, 21 Apr 2009 23:33:26 -0500
Message-ID: <1240374806-6043-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

If you have a mixed environment of clarriions, where some
support ALAU and some support PNR, what do you put in
your multipath.conf? With this patch you do not have to worry about
it. If those modules are loaded before dm-mpath, then they
will have attached to the correct devices based on inquiry, alua commands
and parsing of data buffers (for example in scsi_dh_emc's alua check).
There is no need for the user to set that info in the multipath.conf.
And in general since all scsi_dh_modules will attach to the devices
they work for, we do not need to have users specific this.

I kept the code to try and use what the user passed in for compat
reasons (in case scsi_dh_* was not loaded), but if the scsi
layer has already attached we use that.

I have not tested the patch. It is only compile tested.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/dm-mpath.c                 |   22 +++++++++++++++++++---
 drivers/scsi/device_handler/scsi_dh.c |   22 ++++++++++++++++++++++
 include/scsi/scsi_dh.h                |    6 ++++++
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 095f77b..bae7b77 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -571,6 +571,8 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 			       struct dm_target *ti)
 {
 	int r;
+	char *hw_handler_name;
+	struct request_queue *q;
 	struct pgpath *p;
 	struct multipath *m = ti->private;
 
@@ -591,9 +593,23 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 		goto bad;
 	}
 
-	if (m->hw_handler_name) {
-		r = scsi_dh_attach(bdev_get_queue(p->path.dev->bdev),
-				   m->hw_handler_name);
+
+	q = bdev_get_queue(p->path.dev->bdev);
+	hw_handler_name = scsi_dh_get_attached_name(q);
+	if (hw_handler_name) {
+		if (!m->hw_handler_name)
+			m->hw_handler_name = hw_handler_name;
+		else if (strcmp(hw_handler_name, m->hw_handler_name)) {
+			/*
+			 * if there is a mismatch, then assume
+			 * the scsi layer knew best.
+			 */
+			kfree(m->hw_handler_name);
+			m->hw_handler_name = hw_handler_name;
+		} else
+			kfree(hw_handler_name);
+	} else if (m->hw_handler_name) {
+		r = scsi_dh_attach(q, m->hw_handler_name);
 		if (r < 0) {
 			dm_put_device(ti, p->path.dev);
 			goto bad;
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index a518f2e..257327f 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -481,6 +481,28 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 }
 EXPORT_SYMBOL_GPL(scsi_dh_attach);
 
+/**
+ * scsi_dh_get_attached_name
+ * @q: request queue to test
+ *
+ * Return name of scsi_dh module if attached. Caller must
+ * free returned string.
+ */
+char *scsi_dh_get_attached_name(struct request_queue *q)
+{
+	struct scsi_device *sdev;
+	unsigned long flags;
+	char *attached = NULL;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	if (sdev && sdev->scsi_dh_data)
+		attached = kstrdup(sdev->scsi_dh_data->scsi_dh->name,
+				   GFP_ATOMIC);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+	return attached;
+}
+
 /*
  * scsi_dh_handler_detach - Detach device handler
  * @sdev - sdev the handler should be detached from
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 33efce2..9373702 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -60,6 +60,7 @@ extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern void scsi_dh_detach(struct request_queue *);
+extern char *scsi_dh_get_attached_name(struct request_queue *);
 #else
 static inline int scsi_dh_activate(struct request_queue *req)
 {
@@ -77,4 +78,9 @@ static inline void scsi_dh_detach(struct request_queue *q)
 {
 	return;
 }
+
+extern char *scsi_dh_get_attached_name(struct request_queue *q)
+{
+	return NULL;
+}
 #endif
-- 
1.6.0.6
