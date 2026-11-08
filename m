Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170885;
	b=xi/piI0QmoEjPbTZqgEMJHN2xcydYBenaKfdR/8YIwMzbkD7yP1D6P2DQgkAWr69/bzY
	 Z8HlPADALYJUZVw8v+qdM3BZ5iB54u1Ik80+UGtG2ALYN846uJ56vKODod6z45MPfjVx0
	 m3TjB8Bjlwks5GH33AwokC+Na8/NHEbUyba9RYwuaBkVDBPw1pyXqpCTsKZv4knRJyquT
	 qmWUnXWe/Tilhyy7WjMmfKRovm27RSGZ1z1Ckvsxh1QKYgCWFfEVqiuNe2v+TcuNp598Z
	 NWb1WkWGfE2y76iWtea9XYyJg+yYo0eHYw8X5sL6BTMqT6KYTvHc0ENsFfysQ0DWdBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170885;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7IWC9iRb2iMutylTV3wTN9F4lqxXhmqki0q58tou2N0=;
	b=AY/Yn6wKioIg4joZXqqvyK5a+phIMt6Wz60rrcG0zscQEmkHdZ3nIRGOJpvTuQpsV5lE
	 4B5doRhAZAEC+lI8tV5o9twkLFcPpOeat7WljEO59IU8JjLZwYDl31gmF3XSfe7N9GbHY
	 XJ+DoStchRfq7JR/ZkDAeRvazMa8qtAzhSyJoQe+KdUy8vjGwGnbj5lGLfSn2831/uiLZ
	 qXmY8qzvvK/MiL/+XryjGIpJS+fkQq+usO6aZprGjv2e7iQxWortGzE1h4yyoci6WqTTB
	 PrHLKun6LkhA0yZd5bhlOx391ToON6nlcZUckXORRej+nP57/fjUbjAaipdTbL/Y/YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=O9Jp88ls;
	arc=none smtp.remote-ip=95.215.58.50
Received: from mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E93E606D806
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E93E606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=O9Jp88ls
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KQ58HxN+QINzjNeXUVexzQ283FkiHEbWebIwDbAZvzE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170882; v=1; x=1794775682;
 b=O9Jp88ls7YrQTUME0USZf7kwxEtBofr8hvDF9WCQFhEANYa8380ZX1l4/z/i9I3wSqimF7F1
 NKWAFrRyHPOZ+kmRHzUp5UEOYcuwQ9h6h9jmFM8V5F8fQhd+3YdCuUwFiPNYQ27+e8zFqZq+4Cs
 TL0/ULmTY2DXr5hf8CH8oXZg=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 16be4bca72700676;
	Sun, 08 Nov 2026 20:48:02 +0000
X-Mizu-Trace-ID: 16be4bca72700676
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
Subject: [PATCH v9 07/29] libmultipath: Add delayed removal support
Date: Sun,  8 Nov 2026 20:47:11 +0000
Message-ID: <20261108204733.557995-8-john.garry@linux.dev>
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

Add support for delayed removal, same as exists for NVMe.

The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

Helpers mpath_delayed_removal_secs_show() and
mpath_delayed_removal_secs_store() may be used in the driver sysfs code.

The driver is responsible for supplying the removal work callback for
the delayed work.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h | 18 ++++++++
 lib/multipath.c           | 91 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 033ee8d54bbe..66b6ad9c2219 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -34,6 +34,7 @@ struct mpath_device {
 
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *);
+	void (*remove_head)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	struct bio *(*clone_bio)(struct bio *);
@@ -41,6 +42,7 @@ struct mpath_head_template {
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
+#define MPATH_HEAD_QUEUE_IF_NO_PATH		1
 
 struct mpath_head {
 	struct srcu_struct	srcu;
@@ -58,6 +60,10 @@ struct mpath_head {
 	atomic_long_t		requeue_no_usable_path_cnt;
 	atomic_long_t		fail_no_avail_path_cnt;
 
+	struct delayed_work	remove_work;
+	unsigned int		delayed_removal_secs;
+	struct module		*drv_module;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -111,6 +117,11 @@ void mpath_remove_disk(struct mpath_head *mpath_head);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
+bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+			char *buf);
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count);
 
 static inline bool is_mpath_disk(struct gendisk *disk)
 {
@@ -126,6 +137,13 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline bool mpath_head_queue_if_no_path(struct mpath_head *mpath_head)
+{
+	if (test_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags))
+		return true;
+	return false;
+}
+
 static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
 {
 	kblockd_schedule_work(&mpath_head->requeue_work);
diff --git a/lib/multipath.c b/lib/multipath.c
index fd7821824447..cdf8fbc5105b 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -67,6 +67,9 @@ int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
 	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
 	mutex_unlock(&mpath_head->lock);
 
+	if (cancel_delayed_work(&mpath_head->remove_work))
+		module_put(mpath_head->drv_module);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mpath_add_device);
@@ -340,7 +343,16 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
 			return true;
 	}
 
-	return false;
+	/*
+	 * If "mpath_head->delayed_removal_secs" is set (i.e., non-zero), do
+	 * not immediately fail I/O. Instead, requeue the I/O for the configured
+	 * duration, anticipating that if there's a transient link failure then
+	 * it may recover within this time window. This parameter is exported to
+	 * userspace via sysfs, and its default value is zero. It is internally
+	 * mapped to MPATH_HEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
+	 * non-zero, this flag is set to true. When zero, the flag is cleared.
+	 */
+	return mpath_head_queue_if_no_path(mpath_head);
 }
 
 static void mpath_bdev_submit_bio(struct bio *bio)
@@ -482,6 +494,39 @@ static void mpath_requeue_work(struct work_struct *work)
 	}
 }
 
+bool mpath_can_remove_head(struct mpath_head *mpath_head)
+{
+	unsigned long delay;
+	bool remove = false;
+
+	mutex_lock(&mpath_head->lock);
+	/*
+	 * Ensure that no one could remove this module while the head
+	 * remove work is pending.
+	 */
+	if (mpath_head_queue_if_no_path(mpath_head) &&
+	    !check_mul_overflow(mpath_head->delayed_removal_secs, HZ, &delay) &&
+	    try_module_get(mpath_head->drv_module)) {
+		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);
+	} else {
+		remove = true;
+	}
+
+	mutex_unlock(&mpath_head->lock);
+	return remove;
+}
+EXPORT_SYMBOL_GPL(mpath_can_remove_head);
+
+static void mpath_remove_head_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head = container_of(to_delayed_work(work),
+			struct mpath_head, remove_work);
+	struct module *drv_module = mpath_head->drv_module;
+
+	mpath_head->mpdt->remove_head(mpath_head);
+	module_put(drv_module);
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
@@ -529,6 +574,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	mpath_head->disk->private_data = mpath_head;
 	mpath_head->disk->fops = &mpath_ops;
 
+	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
+	mpath_head->delayed_removal_secs = 0;
+
 	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
 
 	return 0;
@@ -572,6 +620,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+					char *buf)
+{
+	int ret;
+
+	mutex_lock(&mpath_head->lock);
+	ret = sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
+	mutex_unlock(&mpath_head->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
+
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count)
+{
+	unsigned int sec;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 0, &sec);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&mpath_head->lock);
+	mpath_head->delayed_removal_secs = sec;
+	if (sec)
+		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	else
+		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	mutex_unlock(&mpath_head->lock);
+
+	/*
+	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
+	 * by its reader.
+	 */
+	mpath_synchronize(mpath_head);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
+
 void mpath_add_sysfs_link(struct mpath_head *mpath_head)
 {
 	struct device *target;
-- 
2.43.0

