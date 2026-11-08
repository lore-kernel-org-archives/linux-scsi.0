Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.27
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170881;
	b=0SQstpJwPo55nisbUaYeAakIO3Dd/M9QjxLml1c0fbehc/PlFaHyBZZBlLKDuEYNCjjx
	 dp8sGm6h7bKrbbw5Icxp6X7zjYaTMfsPKOmz5vQz1N7pP98V4MkZYCjFpklCha3gtUCeA
	 vfbsOciO6OLomtkZ2mb7GodRD3DP2z33fPOG11/EIQIhA1k9Coo/uWKnMskQt9C1rSFH3
	 3NH3om+X8lTxdXLGm/TrMtrSJpIA+ocvmt8C3WwFM0NzDAXzsGm9O0/6djkCAcO+GATBk
	 JXTT2HwWUnYdaQl5HBFbG0w7nz9PsseBZgkXUUpWaRRM7nPDkejUQovnY7Be15OgqwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170881;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ikmfrunlJJ/YKeUvGeyPy6Hr5fLbyjiGxROd9YPAoJ4=;
	b=iSSQtMxg8S5gllubrF5RgEZktBRCJIolwUQWpPOuAissXtb+qRMe28Llr8IhWjZP0//l
	 GdSIB07J6q/9xl/gRrwLt4cwfYOBVPOE1TCmEsLoNUH0sNoQHgfi1EfuJZYCkK0nx2kO3
	 ag6Z547HWA99DSWerAMBs9tw/fHRmx0O4KJonSTL4c0cPZurUTWF2eRCFm4W2osS13Wm4
	 OJPBMWq9e9aK+FrargtcPMTQwbLuVt/kFzq0Smj/89BzQ7yTrPu0hM7LJKSAEUwu+lEgN
	 cCZtUos7kiUAb1Ga55+/MAYWBYyGUjiWjwPHbXpnjiRn7ocofTAB+PCwb4DY1ZPkwMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vMzRtOUg;
	arc=none smtp.remote-ip=95.215.58.27
Received: from mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346FE606A31C
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:47:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 346FE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vMzRtOUg
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=RcUeH7gkhrSc5PnVsT18R86a50wGu0BU/15a/DDdUMk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170878; v=1; x=1794775678;
 b=vMzRtOUgZFag1qjNoQ/W4Dozw9mdeZIO3GU6PidayqzLUuxTB2c3T7vyitO2ivBwa8/r0OWg
 Tv1lE6KRYD0ftkhX0beGWRoYZ87OD+KJ+gxEdN8oPdFcc0uclPrFLl4QgWKJeC8nR2PhDFcaK0T
 cEFz4G3TyE2ht4hNN5J2w1Y0=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 302a52f6cfd93f21;
	Sun, 08 Nov 2026 20:47:58 +0000
X-Mizu-Trace-ID: 302a52f6cfd93f21
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 03/29] libmultipath: Add basic gendisk support
Date: Sun,  8 Nov 2026 20:47:07 +0000
Message-ID: <20261108204733.557995-4-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support to allocate and free a multipath gendisk.

NVMe has almost like-for-like equivalents here:
- mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
- multipath_partition_scan_work() -> nvme_partition_scan_work()
- mpath_remove_disk() -> nvme_remove_head()
- mpath_device_set_live() -> nvme_mpath_set_live()

struct mpath_head_template is introduced as a method for drivers to
provide custom multipath functionality.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  38 ++++++++++++++
 lib/multipath.c           | 103 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 407d985cd31f..ca6e02505be4 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,11 +5,19 @@
 #include <linux/blkdev.h>
 #include <linux/srcu.h>
 
+extern const struct block_device_operations mpath_ops;
+
 struct mpath_device {
+	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
 };
 
+struct mpath_head_template {
+};
+
+#define MPATH_HEAD_DISK_LIVE 			0
+
 struct mpath_head {
 	struct srcu_struct	srcu;
 	struct list_head	dev_list;	/* list of all mpath_devs */
@@ -17,12 +25,42 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	unsigned long		flags;
+	struct gendisk		*disk;
+	struct work_struct	partition_scan_work;
+	struct device		*parent;
+	const struct attribute_group 		**disk_groups;
+	const struct mpath_head_template	*mpdt;
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
+{
+	return mpath_bd_device_to_head(disk_to_dev(disk));
+}
+
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
 void mpath_head_uninit(struct mpath_head *mpath_head);
 
+void mpath_put_disk(struct mpath_head *mpath_head);
+void mpath_remove_disk(struct mpath_head *mpath_head);
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node);
+void mpath_device_set_live(struct mpath_device *mpath_device);
+
+static inline bool is_mpath_disk(struct gendisk *disk)
+{
+	#if IS_ENABLED(CONFIG_LIBMULTIPATH)
+	return disk->fops == &mpath_ops;
+	#else
+	return false;
+	#endif
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 31ef98980ba4..93c0ca8b390b 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -37,6 +37,106 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_head_uninit);
 
+static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	return mpath_get_head(mpath_head);
+}
+
+static void mpath_bdev_release(struct gendisk *disk)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	mpath_put_head(mpath_head);
+}
+
+const struct block_device_operations mpath_ops = {
+	.owner          = THIS_MODULE,
+	.open		= mpath_bdev_open,
+	.release	= mpath_bdev_release,
+};
+EXPORT_SYMBOL_GPL(mpath_ops);
+
+static void multipath_partition_scan_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+		container_of(work, struct mpath_head, partition_scan_work);
+
+	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
+					     &mpath_head->disk->state)))
+		return;
+
+	mutex_lock(&mpath_head->disk->open_mutex);
+	bdev_disk_changed(mpath_head->disk, false);
+	mutex_unlock(&mpath_head->disk->open_mutex);
+}
+
+void mpath_remove_disk(struct mpath_head *mpath_head)
+{
+	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		struct gendisk *disk = mpath_head->disk;
+
+		del_gendisk(disk);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_remove_disk);
+
+void mpath_put_disk(struct mpath_head *mpath_head)
+{
+	if (!mpath_head->disk)
+		return;
+
+	/* make sure all pending bios are cleaned up */
+	flush_work(&mpath_head->partition_scan_work);
+	put_disk(mpath_head->disk);
+	mpath_head->disk = NULL;
+}
+EXPORT_SYMBOL_GPL(mpath_put_disk);
+
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node)
+{
+	struct gendisk *disk;
+
+	if (mpath_head->disk)
+		return -EINVAL;
+
+	disk = blk_alloc_disk(lim, numa_node);
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
+
+	mpath_head->disk = disk;
+	mpath_head->disk->private_data = mpath_head;
+	mpath_head->disk->fops = &mpath_ops;
+
+	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_alloc_head_disk);
+
+void mpath_device_set_live(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int ret;
+
+	if (!mpath_head->disk)
+		return;
+
+	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		dev_set_drvdata(disk_to_dev(mpath_head->disk), mpath_head);
+		ret = device_add_disk(mpath_head->parent, mpath_head->disk,
+				mpath_head->disk_groups);
+		if (ret) {
+			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
+			return;
+		}
+		queue_work(mpath_wq, &mpath_head->partition_scan_work);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_device_set_live);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
@@ -44,6 +144,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 	mutex_init(&mpath_head->lock);
 	refcount_set(&mpath_head->refcount, 1);
 
+	INIT_WORK(&mpath_head->partition_scan_work,
+		multipath_partition_scan_work);
+
 	return init_srcu_struct(&mpath_head->srcu);
 }
 EXPORT_SYMBOL_GPL(mpath_head_init);
-- 
2.43.0

