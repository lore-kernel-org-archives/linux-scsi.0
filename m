From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Bsg referencing parent device
Date: Fri, 18 May 2018 02:30:46 -0700
Message-ID: <20180518093046.GA9959@infradead.org>
References: <20180517010214.GA18978@xldev-tmpl.dev.purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180517010214.GA18978@xldev-tmpl.dev.purestorage.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anatoliy Glagolev <glagolig@gmail.com>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com
List-Id: linux-scsi@vger.kernel.org

The idea looks pretty reasonable, but once that is done we can get rid of
the ->release callback entirely and just handle it in the callers.
Something like the untested patch below:

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index fc2e5ff2c4b9..9419def8c017 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -303,11 +303,9 @@ static void bsg_exit_rq(struct request_queue *q, struct request *req)
  * @name: device to give bsg device
  * @job_fn: bsg job handler
  * @dd_job_size: size of LLD data needed for each job
- * @release: @dev release function
  */
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
-		bsg_job_fn *job_fn, int dd_job_size,
-		void (*release)(struct device *))
+		bsg_job_fn *job_fn, int dd_job_size)
 {
 	struct request_queue *q;
 	int ret;
@@ -331,7 +329,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 	blk_queue_softirq_done(q, bsg_softirq_done);
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
-	ret = bsg_register_queue(q, dev, name, &bsg_transport_ops, release);
+	ret = bsg_register_queue(q, dev, name, &bsg_transport_ops);
 	if (ret) {
 		printk(KERN_ERR "%s: bsg interface failed to "
 		       "initialize - register queue\n", dev->kobj.name);
diff --git a/block/bsg.c b/block/bsg.c
index defa06c11858..fe1e5632e5d1 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -650,18 +650,6 @@ static struct bsg_device *bsg_alloc_device(void)
 	return bd;
 }
 
-static void bsg_kref_release_function(struct kref *kref)
-{
-	struct bsg_class_device *bcd =
-		container_of(kref, struct bsg_class_device, ref);
-	struct device *parent = bcd->parent;
-
-	if (bcd->release)
-		bcd->release(bcd->parent);
-
-	put_device(parent);
-}
-
 static int bsg_put_device(struct bsg_device *bd)
 {
 	int ret = 0, do_free;
@@ -694,7 +682,6 @@ static int bsg_put_device(struct bsg_device *bd)
 
 	kfree(bd);
 out:
-	kref_put(&q->bsg_dev.ref, bsg_kref_release_function);
 	if (do_free)
 		blk_put_queue(q);
 	return ret;
@@ -760,8 +747,6 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 	 */
 	mutex_lock(&bsg_mutex);
 	bcd = idr_find(&bsg_minor_idr, iminor(inode));
-	if (bcd)
-		kref_get(&bcd->ref);
 	mutex_unlock(&bsg_mutex);
 
 	if (!bcd)
@@ -772,8 +757,6 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 		return bd;
 
 	bd = bsg_add_device(inode, bcd->queue, file);
-	if (IS_ERR(bd))
-		kref_put(&bcd->ref, bsg_kref_release_function);
 
 	return bd;
 }
@@ -913,25 +896,17 @@ void bsg_unregister_queue(struct request_queue *q)
 		sysfs_remove_link(&q->kobj, "bsg");
 	device_unregister(bcd->class_dev);
 	bcd->class_dev = NULL;
-	kref_put(&bcd->ref, bsg_kref_release_function);
 	mutex_unlock(&bsg_mutex);
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
 int bsg_register_queue(struct request_queue *q, struct device *parent,
-		const char *name, const struct bsg_ops *ops,
-		void (*release)(struct device *))
+		const char *name, const struct bsg_ops *ops)
 {
 	struct bsg_class_device *bcd;
 	dev_t dev;
 	int ret;
 	struct device *class_dev = NULL;
-	const char *devname;
-
-	if (name)
-		devname = name;
-	else
-		devname = dev_name(parent);
 
 	/*
 	 * we need a proper transport to send commands, not a stacked device
@@ -955,15 +930,12 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 
 	bcd->minor = ret;
 	bcd->queue = q;
-	bcd->parent = get_device(parent);
-	bcd->release = release;
 	bcd->ops = ops;
-	kref_init(&bcd->ref);
 	dev = MKDEV(bsg_major, bcd->minor);
-	class_dev = device_create(bsg_class, parent, dev, NULL, "%s", devname);
+	class_dev = device_create(bsg_class, parent, dev, NULL, "%s", name);
 	if (IS_ERR(class_dev)) {
 		ret = PTR_ERR(class_dev);
-		goto put_dev;
+		goto idr_remove;
 	}
 	bcd->class_dev = class_dev;
 
@@ -978,8 +950,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 
 unregister_class_dev:
 	device_unregister(class_dev);
-put_dev:
-	put_device(parent);
+idr_remove:
 	idr_remove(&bsg_minor_idr, bcd->minor);
 unlock:
 	mutex_unlock(&bsg_mutex);
@@ -993,7 +964,7 @@ int bsg_scsi_register_queue(struct request_queue *q, struct device *parent)
 		return -EINVAL;
 	}
 
-	return bsg_register_queue(q, parent, NULL, &bsg_scsi_ops, NULL);
+	return bsg_register_queue(q, parent, dev_name(parent), &bsg_scsi_ops);
 }
 EXPORT_SYMBOL_GPL(bsg_scsi_register_queue);
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index be3be0f9cb2d..d97f689b9278 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3781,8 +3781,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	snprintf(bsg_name, sizeof(bsg_name),
 		 "fc_host%d", shost->host_no);
 
-	q = bsg_setup_queue(dev, bsg_name, fc_bsg_dispatch, i->f->dd_bsg_size,
-			NULL);
+	q = bsg_setup_queue(dev, bsg_name, fc_bsg_dispatch, i->f->dd_bsg_size);
 	if (IS_ERR(q)) {
 		dev_err(dev,
 			"fc_host%d: bsg interface failed to initialize - setup queue\n",
@@ -3827,8 +3826,8 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 	if (!i->f->bsg_request)
 		return -ENOTSUPP;
 
-	q = bsg_setup_queue(dev, NULL, fc_bsg_dispatch, i->f->dd_bsg_size,
-			NULL);
+	q = bsg_setup_queue(dev, dev_name(dev), fc_bsg_dispatch,
+			i->f->dd_bsg_size);
 	if (IS_ERR(q)) {
 		dev_err(dev, "failed to setup bsg queue\n");
 		return PTR_ERR(q);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 65f6c94f2e9b..6fd2fe210fc3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1542,7 +1542,7 @@ iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
 		return -ENOTSUPP;
 
 	snprintf(bsg_name, sizeof(bsg_name), "iscsi_host%d", shost->host_no);
-	q = bsg_setup_queue(dev, bsg_name, iscsi_bsg_host_dispatch, 0, NULL);
+	q = bsg_setup_queue(dev, bsg_name, iscsi_bsg_host_dispatch, 0);
 	if (IS_ERR(q)) {
 		shost_printk(KERN_ERR, shost, "bsg interface failed to "
 			     "initialize - no request queue\n");
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 08acbabfae07..e2953b416746 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -187,16 +187,6 @@ static int sas_smp_dispatch(struct bsg_job *job)
 	return 0;
 }
 
-static void sas_host_release(struct device *dev)
-{
-	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	struct request_queue *q = sas_host->q;
-
-	if (q)
-		blk_cleanup_queue(q);
-}
-
 static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 {
 	struct request_queue *q;
@@ -208,7 +198,7 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 
 	if (rphy) {
 		q = bsg_setup_queue(&rphy->dev, dev_name(&rphy->dev),
-				sas_smp_dispatch, 0, NULL);
+				sas_smp_dispatch, 0);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
 		rphy->q = q;
@@ -217,7 +207,7 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 
 		snprintf(name, sizeof(name), "sas_host%d", shost->host_no);
 		q = bsg_setup_queue(&shost->shost_gendev, name,
-				sas_smp_dispatch, 0, sas_host_release);
+				sas_smp_dispatch, 0);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
 		to_sas_host_attrs(shost)->q = q;
@@ -260,8 +250,11 @@ static int sas_host_remove(struct transport_container *tc, struct device *dev,
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct request_queue *q = to_sas_host_attrs(shost)->q;
 
-	if (q)
+	if (q) {
 		bsg_unregister_queue(q);
+		blk_cleanup_queue(q);
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 28a7ccc55c89..6aeaf6472665 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -72,8 +72,7 @@ struct bsg_job {
 void bsg_job_done(struct bsg_job *job, int result,
 		  unsigned int reply_payload_rcv_len);
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
-		bsg_job_fn *job_fn, int dd_job_size,
-		void (*release)(struct device *));
+		bsg_job_fn *job_fn, int dd_job_size);
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);
 
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 0c7dd9ceb139..dac37b6e00ec 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -17,17 +17,13 @@ struct bsg_ops {
 
 struct bsg_class_device {
 	struct device *class_dev;
-	struct device *parent;
 	int minor;
 	struct request_queue *queue;
-	struct kref ref;
 	const struct bsg_ops *ops;
-	void (*release)(struct device *);
 };
 
 int bsg_register_queue(struct request_queue *q, struct device *parent,
-		const char *name, const struct bsg_ops *ops,
-		void (*release)(struct device *));
+		const char *name, const struct bsg_ops *ops);
 int bsg_scsi_register_queue(struct request_queue *q, struct device *parent);
 void bsg_unregister_queue(struct request_queue *q);
 #else
