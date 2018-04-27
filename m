From: Anatoliy Glagolev <glagolig@gmail.com>
Subject: Re: [PATCH] bsg referencing bus driver module
Date: Thu, 26 Apr 2018 18:01:00 -0600
Message-ID: <20180427000059.GA7044@xldev-tmpl.dev.purestorage.com>
References: <CANFzKepsGq0EHX4GPtC0RZOWqVf2fTJ6uA2WH-SZNsBuwMJ5KA@mail.gmail.com>
 <CANFzKer6QDaJALX3LKPF2DV6LgczTh-efQe9+zeK8BuxTWFt1A@mail.gmail.com>
 <CANFzKepRSA+VoVAvOfW6U_qHFVDZex+=hQ=QhU+7Z=unvwejJQ@mail.gmail.com>
 <1524218126.3321.6.camel@HansenPartnership.com>
 <20180420224404.GC32372@xldev-tmpl.dev.purestorage.com>
 <1524383279.3389.7.camel@HansenPartnership.com>
 <20180423183845.GA21609@xldev-tmpl.dev.purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180423183845.GA21609@xldev-tmpl.dev.purestorage.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, martin.petersen@oracle.com, jthumshirn@suse.de, hare@suse.com, bblock@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Any thoughts on this? Can we really drop a reference from a child device
(bsg_class_device) to a parent device (Scsi_Host) while the child device
is still around at fc_bsg_remove time?

If not, please consider a fix with module references. I realized that
the previous version of the fix had a problem since bsg_open may run
more often than bsg_release. Sending a newer version... The new fix
piggybacks on the bsg layer logic allocating/freeing bsg_device structs.
When all those structs are gone there are no references to Scsi_Host from
the user-mode side. The only remaining references are from a SCSI bus
driver (like qla2xxx) itself; it is safe to drop the module reference
at that time.


>From c744d4fd93578545ad12faa35a3354364793b124 Mon Sep 17 00:00:00 2001
From: Anatoliy Glagolev <glagolig@gmail.com>
Date: Wed, 25 Apr 2018 19:16:10 -0600
Subject: [PATCH] bsg referencing parent module
Signed-off-by: Anatoliy Glagolev <glagolig@gmail.com>

Fixing a bug when bsg layer holds the last reference to device
when the device's module has been unloaded. Upon dropping the
reference the device's release function may touch memory of
the unloaded module.
---
 block/bsg-lib.c                  | 24 ++++++++++++++++++++++--
 block/bsg.c                      | 22 +++++++++++++++++++++-
 drivers/scsi/scsi_transport_fc.c |  8 ++++++--
 include/linux/bsg-lib.h          |  4 ++++
 include/linux/bsg.h              |  5 +++++
 5 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index fc2e5ff..bb11786 100644
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
+ * bsg_setup_queue_ex - Create and add the bsg hooks so we can receive requests
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
index defa06c..950cd31 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -666,6 +666,7 @@ static int bsg_put_device(struct bsg_device *bd)
 {
 	int ret = 0, do_free;
 	struct request_queue *q = bd->queue;
+	struct module *parent_module = q->bsg_dev.parent_module;
 
 	mutex_lock(&bsg_mutex);
 
@@ -695,8 +696,11 @@ static int bsg_put_device(struct bsg_device *bd)
 	kfree(bd);
 out:
 	kref_put(&q->bsg_dev.ref, bsg_kref_release_function);
-	if (do_free)
+	if (do_free) {
 		blk_put_queue(q);
+		if (parent_module)
+			module_put(parent_module);
+	}
 	return ret;
 }
 
@@ -706,12 +710,19 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 {
 	struct bsg_device *bd;
 	unsigned char buf[32];
+	struct module *parent_module = rq->bsg_dev.parent_module;
 
 	if (!blk_get_queue(rq))
 		return ERR_PTR(-ENXIO);
 
+	if (parent_module) {
+		if (!try_module_get(parent_module))
+			return ERR_PTR(-ENODEV);
+	}
 	bd = bsg_alloc_device();
 	if (!bd) {
+		if (parent_module)
+			module_put(parent_module);
 		blk_put_queue(rq);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -922,6 +933,14 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
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
@@ -958,6 +977,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
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
