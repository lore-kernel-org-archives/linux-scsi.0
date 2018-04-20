From: Anatoliy Glagolev <glagolig@gmail.com>
Subject: Re: [PATCH] bsg referencing bus driver module
Date: Fri, 20 Apr 2018 16:44:05 -0600
Message-ID: <20180420224404.GC32372@xldev-tmpl.dev.purestorage.com>
References: <CANFzKepsGq0EHX4GPtC0RZOWqVf2fTJ6uA2WH-SZNsBuwMJ5KA@mail.gmail.com>
 <CANFzKer6QDaJALX3LKPF2DV6LgczTh-efQe9+zeK8BuxTWFt1A@mail.gmail.com>
 <CANFzKepRSA+VoVAvOfW6U_qHFVDZex+=hQ=QhU+7Z=unvwejJQ@mail.gmail.com>
 <1524218126.3321.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524218126.3321.6.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, martin.petersen@oracle.com, jthumshirn@suse.de, hare@suse.com, bblock@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

 
> This patch isn't applyable because your mailer has changed all the tabs
> to spaces.
> 
> I also think there's no need to do it this way.  I think what we need
> is for fc_bsg_remove() to wait until the bsg queue is drained.  It does
> look like the author thought this happened otherwise the code wouldn't
> have the note.  If we fix it that way we can do the same thing in all
> the other transport classes that use bsg (which all have a similar
> issue).
> 
> James
> 

Thanks, James. Sorry about the tabs; re-sending.

On fc_bsg_remove()...: are you suggesting to implement the whole fix
in scsi_transport_fc.c? That would be nice, but I do not see how that
is possible. Even with the queue drained bsg still holds a reference
to the Scsi_Host via bsg_class_device; bsg_class_device itself is
referenced on bsg_open and kept around while a user-mode process keeps
a handle to bsg.
Even if we somehow implement the waiting the call may be stuck
forever if the user-mode process keeps the handle.
I think handling it via a rererence to the module is more consistent
with the way things are done in Linux. You suggested the approach
youself back in "Waiting for scsi_host_template release" discussion.


>From df939b80d02bf37b21efaaef8ede86cfd39b0cb8 Mon Sep 17 00:00:00 2001
From: Anatoliy Glagolev <glagolig@gmail.com>
Date: Thu, 19 Apr 2018 15:06:06 -0600
Subject: [PATCH] bsg referencing parent module

Fixing a bug when bsg layer holds the last reference to device
when the device's module has been unloaded. Upon dropping the
reference the device's release function may touch memory of
the unloaded module.
---
 block/bsg-lib.c                  | 24 ++++++++++++++++++++++--
 block/bsg.c                      | 29 ++++++++++++++++++++++++++---
 drivers/scsi/scsi_transport_fc.c |  8 ++++++--
 include/linux/bsg-lib.h          |  4 ++++
 include/linux/bsg.h              |  5 +++++
 5 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index fc2e5ff..90c28fd 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -309,6 +309,25 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 		bsg_job_fn *job_fn, int dd_job_size,
 		void (*release)(struct device *))
 {
+	return bsg_setup_queue_ex(dev, name, job_fn, dd_job_size, release,
+		NULL);
+}
+EXPORT_SYMBOL_GPL(bsg_setup_queue);
+
+/**
+ * bsg_setup_queue - Create and add the bsg hooks so we can receive requests
+ * @dev: device to attach bsg device to
+ * @name: device to give bsg device
+ * @job_fn: bsg job handler
+ * @dd_job_size: size of LLD data needed for each job
+ * @release: @dev release function
+ * @dev_module: @dev's module
+ */
+struct request_queue *bsg_setup_queue_ex(struct device *dev, const char *name,
+		bsg_job_fn *job_fn, int dd_job_size,
+		void (*release)(struct device *),
+		struct module *dev_module)
+{
 	struct request_queue *q;
 	int ret;
 
@@ -331,7 +350,8 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 	blk_queue_softirq_done(q, bsg_softirq_done);
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
-	ret = bsg_register_queue(q, dev, name, &bsg_transport_ops, release);
+	ret = bsg_register_queue_ex(q, dev, name, &bsg_transport_ops, release,
+		dev_module);
 	if (ret) {
 		printk(KERN_ERR "%s: bsg interface failed to "
 		       "initialize - register queue\n", dev->kobj.name);
@@ -343,4 +363,4 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 	blk_cleanup_queue(q);
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(bsg_setup_queue);
+EXPORT_SYMBOL_GPL(bsg_setup_queue_ex);
diff --git a/block/bsg.c b/block/bsg.c
index defa06c..6920c5b 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -750,7 +750,8 @@ static struct bsg_device *__bsg_get_device(int minor, struct request_queue *q)
 	return bd;
 }
 
-static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
+static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file,
+	struct bsg_class_device **pbcd)
 {
 	struct bsg_device *bd;
 	struct bsg_class_device *bcd;
@@ -766,6 +767,7 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 
 	if (!bcd)
 		return ERR_PTR(-ENODEV);
+	*pbcd = bcd;
 
 	bd = __bsg_get_device(iminor(inode), bcd->queue);
 	if (bd)
@@ -781,22 +783,34 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 static int bsg_open(struct inode *inode, struct file *file)
 {
 	struct bsg_device *bd;
+	struct bsg_class_device *bcd;
 
-	bd = bsg_get_device(inode, file);
+	bd = bsg_get_device(inode, file, &bcd);
 
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
 	file->private_data = bd;
+	if (bcd->parent_module) {
+		if (!try_module_get(bcd->parent_module)) {
+			bsg_put_device(bd);
+			return -ENODEV;
+		}
+	}
 	return 0;
 }
 
 static int bsg_release(struct inode *inode, struct file *file)
 {
+	int ret;
 	struct bsg_device *bd = file->private_data;
+	struct module *parent_module = bd->queue->bsg_dev.parent_module;
 
 	file->private_data = NULL;
-	return bsg_put_device(bd);
+	ret = bsg_put_device(bd);
+	if (parent_module)
+		module_put(parent_module);
+	return ret;
 }
 
 static __poll_t bsg_poll(struct file *file, poll_table *wait)
@@ -922,6 +936,14 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 		const char *name, const struct bsg_ops *ops,
 		void (*release)(struct device *))
 {
+	return bsg_register_queue_ex(q, parent, name, ops, release, NULL);
+}
+
+int bsg_register_queue_ex(struct request_queue *q, struct device *parent,
+		const char *name, const struct bsg_ops *ops,
+		void (*release)(struct device *),
+		struct module *parent_module)
+{
 	struct bsg_class_device *bcd;
 	dev_t dev;
 	int ret;
@@ -958,6 +980,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	bcd->parent = get_device(parent);
 	bcd->release = release;
 	bcd->ops = ops;
+	bcd->parent_module = parent_module;
 	kref_init(&bcd->ref);
 	dev = MKDEV(bsg_major, bcd->minor);
 	class_dev = device_create(bsg_class, parent, dev, NULL, "%s", devname);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index be3be0f..f21f7d2 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3772,17 +3772,21 @@ static int fc_bsg_dispatch(struct bsg_job *job)
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct request_queue *q;
 	char bsg_name[20];
+	struct module *shost_module = NULL;
 
 	fc_host->rqst_q = NULL;
 
 	if (!i->f->bsg_request)
 		return -ENOTSUPP;
 
+	if (shost->hostt)
+		shost_module = shost->hostt->module;
+
 	snprintf(bsg_name, sizeof(bsg_name),
 		 "fc_host%d", shost->host_no);
 
-	q = bsg_setup_queue(dev, bsg_name, fc_bsg_dispatch, i->f->dd_bsg_size,
-			NULL);
+	q = bsg_setup_queue_ex(dev, bsg_name, fc_bsg_dispatch,
+		i->f->dd_bsg_size, NULL, shost_module);
 	if (IS_ERR(q)) {
 		dev_err(dev,
 			"fc_host%d: bsg interface failed to initialize - setup queue\n",
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 28a7ccc..232c855 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -74,6 +74,10 @@ void bsg_job_done(struct bsg_job *job, int result,
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 		bsg_job_fn *job_fn, int dd_job_size,
 		void (*release)(struct device *));
+struct request_queue *bsg_setup_queue_ex(struct device *dev, const char *name,
+		bsg_job_fn *job_fn, int dd_job_size,
+		void (*release)(struct device *),
+		struct module *dev_module);
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);
 
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 0c7dd9c..0e7c26c 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -23,11 +23,16 @@ struct bsg_class_device {
 	struct kref ref;
 	const struct bsg_ops *ops;
 	void (*release)(struct device *);
+	struct module *parent_module;
 };
 
 int bsg_register_queue(struct request_queue *q, struct device *parent,
 		const char *name, const struct bsg_ops *ops,
 		void (*release)(struct device *));
+int bsg_register_queue_ex(struct request_queue *q, struct device *parent,
+		const char *name, const struct bsg_ops *ops,
+		void (*release)(struct device *),
+		struct module *parent_module);
 int bsg_scsi_register_queue(struct request_queue *q, struct device *parent);
 void bsg_unregister_queue(struct request_queue *q);
 #else
-- 
1.9.1
