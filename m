Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.83
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170891;
	b=RGk6jzt1oKFbaJt7Wv0/YFjSVELHDxWuBvYVze54DG2cW5zct1yovCLmyrian7xaIdPk
	 yXrRON3ly0fAj35wchRYfwtzheWGgiL7SQWEpBip5ZPYxXR5azk8B9J89IjTz1k+LyUL1
	 JQbyxKEQc/83LBsAIR3sC6icix0jULDFSS+u2kBdq95ivgYe07pT+/mtTQxUk4r2mkZgz
	 fUdVNaq6c9pZv1154P4CzyW7zOJglZO13/v7XXVudKiaA2sBxIU57wnOxECHnOdEppopo
	 kT8NjZ5pZtdaLYU8JD+J8B7m2Sc3vwGOWJcryjTNkH30M5Q5LXLN+MMiony3N5YOJkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170891;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LP7nZQDMQxMQ54H9tPz0vTAyhNzBESJOkdjBl4aXMkk=;
	b=tj+z2P0XGDy4WooXPz9akpudSELPQwJgdNwHGxbp9UPNxpBJ1+PIxBJW/Yjc5lZ5YMiE
	 p5xqqagKNeyZnZa73KNK29YQGsJuDlp1W8UZyAPmr32Z0Ft5EmnFvV4NhbWRY3ioko5Fa
	 Le7zGpWAdJR1IhdgcbONlc0gpEfE0CEGr5nSprisqi83iGWs0v6mYcGdPBNsErnP8JuQw
	 3mwmOfCPCLNY9QLzF/84AmbMUEa+J8ga+QlJiRDxLk9WEPR7+CA8plZNlrp0cRK1ZmP01
	 ZK8drGq7TNOa8Mvv8pvPTqHdMUB+L3HQfb6du/GWKxHaKB3FNgf/43r9gE0mej2giOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZjZvbPFO;
	arc=none smtp.remote-ip=95.215.58.83
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EEC606D814
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84EEC606D814
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZjZvbPFO
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=95mBYkAZssh9t2dGRQfr8vRhaWGCQB2zkQxAtctCKv8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170888; v=1; x=1794775688;
 b=ZjZvbPFO9jokBMPWT+iZ987ok0L4iywvpXxRSgf3awH1a6v8xHlvQVFZBgWzD1kjHvCqKWXr
 vdXwsoXmq3DoDRbmarJf6QF+gDTYEUgwoOSO4eTogHgS3S+m/eWov7Hiwk634a+/iaiRkQrtxLO
 a7XLjmCXcwvhp4ZcUWDuCiAs=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 1b0e7d72f3e73a26;
	Sun, 08 Nov 2026 20:48:08 +0000
X-Mizu-Trace-ID: 1b0e7d72f3e73a26
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
Subject: [PATCH v9 13/29] scsi-multipath: introduce scsi_device head structure
Date: Sun,  8 Nov 2026 20:47:17 +0000
Message-ID: <20261108204733.557995-14-john.garry@linux.dev>
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

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

There is no reference in scsi_mpath_head to any disk, as this would be
managed by the scsi_disk driver.

A list of scsi_mpath_head structures is managed to lookup for matching
multipathed scsi_device's. Matching is done through the scsi_device
unique id.

A new class for multipathed devices is added, scsi_mpath_device_class.

The purpose of this class is for managing the scsi_mpath_head.dev member.

The naming for the scsi_device structure is in form H:C:I:L,
where H is host, C is channel, I is ID, and L is lun.

However, for a multipathed scsi_device, all the naming members may be
different between member scsi_device's. As such, just use a simple
single-number naming index for each scsi_mpath_head.

The sysfs device folder will have links to the scsi_device's so, it will
be possible to lookup the member scsi_device's.

An example sysfs entry is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
drwxr-xr-x    2 root     root             0 Apr 13 15:48 power
lrwxrwxrwx    1 root     root             0 Apr 13 15:48 subsystem -> ../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Apr 13 15:48 uevent
-r--r--r--    1 root     root          4096 Apr 13 15:48 vpd_id

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 205 +++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c     |   3 +
 include/scsi/scsi_multipath.h |  36 ++++++
 3 files changed, 242 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 97f7513b4712..625a72cb73c3 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -29,6 +29,10 @@ static const char *scsi_multipath_modes[] = {
 
 static int scsi_multipath = SCSI_MULTIPATH_OFF;
 
+static LIST_HEAD(scsi_mpath_heads_list);
+static DEFINE_MUTEX(scsi_mpath_heads_lock);
+static DEFINE_IDA(scsi_multipath_dev_ida);
+
 static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
 {
 	int mode;
@@ -74,6 +78,55 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_head_release(struct device *dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+	ida_destroy(&scsi_mpath_head->ida);
+	mpath_head_uninit(mpath_head);
+	kfree(scsi_mpath_head);
+}
+
+static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return sysfs_emit(buf, "%s\n", scsi_mpath_head->vpd_id);
+}
+static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
+
+static struct attribute *scsi_mpath_device_attrs[] = {
+	&dev_attr_vpd_id.attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_device_attrs_group = {
+	.attrs = scsi_mpath_device_attrs,
+};
+
+static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	return true;
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+
+static const struct attribute_group *scsi_mpath_device_groups[] = {
+	&scsi_mpath_device_attrs_group,
+	NULL
+};
+
+static const struct class scsi_mpath_device_class = {
+	.name = "scsi_mpath_device",
+	.dev_groups = scsi_mpath_device_groups,
+	.dev_release = scsi_mpath_head_release,
+};
+
 static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -93,6 +146,74 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static struct mpath_head_template smpdt = {
+};
+
+static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
+	if (!scsi_mpath_head)
+		return NULL;
+
+	ida_init(&scsi_mpath_head->ida);
+
+	if (mpath_head_init(&scsi_mpath_head->mpath_head))
+		goto out_free;
+	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+
+	strscpy(scsi_mpath_head->vpd_id, vpd_id,
+		SCSI_MPATH_DEVICE_ID_LEN);
+
+	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
+	if (scsi_mpath_head->index < 0)
+		goto out_uninit_head;
+	kref_init(&scsi_mpath_head->ref);
+
+	device_initialize(&scsi_mpath_head->dev);
+	scsi_mpath_head->dev.class = &scsi_mpath_device_class;
+	ret = dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
+				scsi_mpath_head->index);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	ret = device_add(&scsi_mpath_head->dev);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	return scsi_mpath_head;
+
+out_uninit_head:
+	mpath_head_uninit(&scsi_mpath_head->mpath_head);
+out_free:
+	kfree(scsi_mpath_head);
+	return NULL;
+}
+
+static struct scsi_mpath_head *scsi_mpath_find_head(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+
+	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
+		if (strncmp(scsi_mpath_head->vpd_id,
+			scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
+			if (scsi_mpath_try_get_head(scsi_mpath_head))
+				continue;
+			return scsi_mpath_head;
+		}
+	}
+
+	return NULL;
+}
+
 static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 {
 	kfree(sdev->scsi_mpath_dev);
@@ -101,6 +222,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
+	struct scsi_mpath_head *scsi_mpath_head;
 	int ret;
 
 	if (scsi_multipath == SCSI_MULTIPATH_OFF)
@@ -120,13 +242,51 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 	if (ret < 0)
 		goto out_uninit;
 
-	return 0;
+	mutex_lock(&scsi_mpath_heads_lock);
+	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
+	if (scsi_mpath_head)
+		goto found;
+	scsi_mpath_head =
+		scsi_mpath_alloc_head(sdev->scsi_mpath_dev->device_id_str);
+	if (!scsi_mpath_head) {
+		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, device multipathing disabled\n");
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_uninit;
+	}
 
+	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
+found:
+	mutex_unlock(&scsi_mpath_heads_lock);
+	ret = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
+	if (ret < 0)
+		goto out_put_head;
+	sdev->scsi_mpath_dev->index = ret;
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
+	sdev->scsi_mpath_dev->mpath_device.mpath_head =
+				&scsi_mpath_head->mpath_head;
+	return 0;
+out_put_head:
+	scsi_mpath_put_head(scsi_mpath_head);
 out_uninit:
 	scsi_multipath_sdev_uninit(sdev);
 	return 0;
 }
 
+static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	scsi_mpath_put_head(scsi_mpath_dev->scsi_mpath_head);
+	scsi_mpath_dev->scsi_mpath_head = NULL;
+}
+
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+
+	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
+
+	scsi_mpath_remove_head(scsi_mpath_dev);
+}
+
 void scsi_mpath_dev_release(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -137,13 +297,54 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
 	scsi_multipath_sdev_uninit(sdev);
 }
 
-int __init scsi_multipath_init(void)
+void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
 {
+	kref_get(&scsi_mpath_head->ref);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
+
+int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	if (!kref_get_unless_zero(&scsi_mpath_head->ref))
+		return -ENXIO;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_mpath_try_get_head);
+
+static void scsi_mpath_free_head(struct kref *ref)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(ref, struct scsi_mpath_head, ref);
+
+	/*
+	 * If we race with scsi_mpath_find_head(), then that function may
+	 * find this scsi_mpath_head in the heads list; however we would fail
+	 * to take a reference to this scsi_mpath_head and continue the search.
+	 * As such, it is safe to call device_unregister (and free
+	 * scsi_mpath_head) after we delete this head from the list.
+	 */
+	mutex_lock(&scsi_mpath_heads_lock);
+	list_del_init(&scsi_mpath_head->entry);
+	mutex_unlock(&scsi_mpath_heads_lock);
+
+	device_unregister(&scsi_mpath_head->dev);
+}
+
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	kref_put(&scsi_mpath_head->ref, scsi_mpath_free_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
+
+int __init scsi_multipath_init(void)
+{
+	return class_register(&scsi_mpath_device_class);
+}
 
 void __exit scsi_multipath_exit(void)
 {
+	ida_destroy(&scsi_multipath_dev_ida);
+	class_unregister(&scsi_mpath_device_class);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6a68da42df91..5b5de5806385 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1526,6 +1526,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 */
 	scsi_target_reap(scsi_target(sdev));
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
+
 	put_device(dev);
 }
 
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d3d410dafd17..50d422798d83 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -19,12 +19,25 @@
 #ifdef CONFIG_SCSI_MULTIPATH
 #define SCSI_MPATH_DEVICE_ID_LEN 256
 
+struct scsi_mpath_head {
+	struct mpath_head	mpath_head;
+	char			vpd_id[SCSI_MPATH_DEVICE_ID_LEN];
+	struct list_head	entry;
+	struct ida		ida;
+	struct kref		ref;
+	struct device		dev;
+	int			index;
+};
+
 struct scsi_mpath_device {
 	struct mpath_device	mpath_device;
 	struct scsi_device 	*sdev;
+	int			index;
+	struct scsi_mpath_head	*scsi_mpath_head;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
+
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
@@ -32,8 +45,14 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
+int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
 
+struct scsi_mpath_head {
+};
 struct scsi_mpath_device {
 };
 
@@ -51,5 +70,22 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
+static inline
+void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+}
+static inline
+int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	return 0;
+}
+static inline
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.0

