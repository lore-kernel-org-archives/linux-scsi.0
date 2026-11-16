Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788318;
	b=c/4WZYxxdT9iKjZg5nK+hKlZlXE744vyb+64kQhIDETl6pALvXaj3nZNsSaoK1hl/cpB
	 NgYTpHtd8W4vTdvFG/+Xoxay7JmFG/kQVTjavPleZfdqM0DXQdB9PzosoFYcwfszuVCFE
	 EqRIFTJOjrPoLrTpIdHNxcwNRGI4CsPnXPZsP0OL1r9yFmsSgbXlisZz3B01f28oFA2zL
	 R7uXhFTJ3lmTqA7tKhHm3MOall9eySo3CVmqmwYG4Pj95mQclYZzFvW/cizScLvPy5R4N
	 jtTHC8NgJzajDrLVq6uTuWVaH969GVkVt/5Ex9o6pvhQpmuvbSEqJkIa2TjnI7afsFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788318;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=NPwgDGffjgxzqF0wjVDUtuwfQMsoOYNvmv0aBlc7Yzk=;
	b=kWRB1TI4tBYBww0XG8smn3hu5NToOapkEgPe74Elk8nOITCLeDAklED1OyQuwdA9cftb
	 LfaTtZC/yGoxf/5TbktuRp2RtMlsMkepazYuAeiQXVA4Tdtg6La2BLjUZ20+REA475GEl
	 jkvZi60Hg8R51mjxC1rWmcZPafvSek1uvBFe0xM5YRcVoDKbUxvXC0quOAIF9WzIKXoK2
	 YTIzB4Ws31bMLp7Ap4ZOmM/yAocEZJ+o5LHvvvNWUCluxtxrqMoQCf9LfLZEf4qKc/0PG
	 FHkSBqF2bcHyNTSzdTkRPG2cWYEZWLWCC+lhXyL5bERUzQLkQRWKiukXzklbWNJ3TJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lNVSxHTo;
	arc=none smtp.remote-ip=95.215.58.148
Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6446606A330
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:18:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6446606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lNVSxHTo
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=N+ug4Qa9hbc13T5tV7E/M5+vFQ8g/1H/okjBVM6cPgY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788314; v=1; x=1795393114;
 b=lNVSxHTo9BV5PjqEnWyyfwS0tql0rgd2Kt704zpcJB55rKvqAu6UsuTCKXlGZhsue2B+J1ic
 Tu4lEZsPTQdeV1AKHWUi+PwaIiXZsiEtpU1z/KNDQI/CujbRQHPPtnhKJLLmhwPkY3Rxrfd8jRk
 CEYP7FmAfiO4tswWvSI6Nsog=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dd9babe0e9c447ee;
	Mon, 16 Nov 2026 00:18:34 +0000
X-Mizu-Trace-ID: dd9babe0e9c447ee
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:17:56 -0500
Subject: [PATCH RFC 03/18] scsi: target: uring: Create a character device
 per backstore device
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-feat-target-core-uring-v1-3-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
In-Reply-To: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
To: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, 
 Bodo Stroesser <bostroesser@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

A target_core_uring device has queues and command descriptors, but
userspace has no handle on it.

The server needs a file to issue io_uring commands on, and the state of
the device has to stay around for as long as that file is open, which
can be longer than the configfs item lives.

Create /dev/tcmurN when a device is configured and show its name in the
info file. Allow one opener at a time, with CAP_SYS_ADMIN. Tie the
lifetime of the device to the embedded struct device, so that the queues
are freed when the last reference to the character device goes. Report
the geometry of the device through the TCMUR_GET_DEV_INFO ioctl.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c     | 138 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/target_core_uring.h |  27 ++++++-
 2 files changed, 160 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 135435748d367..d1ca4f16e7d0b 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -7,6 +7,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/idr.h>
 #include <linux/mm.h>
 #include <linux/parser.h>
 #include <linux/slab.h>
@@ -16,10 +19,14 @@
 #include <uapi/linux/target_core_uring.h>
 
 #define TCMUR_VERSION		"1.0"
+#define TCMUR_MINORS		(1U << MINORBITS)
 #define TCMUR_MAX_IO_SIZE	(4U << 20)
 #define TCMUR_DEF_QUEUE_DEPTH	128
 #define TCMUR_DEF_BLOCK_SIZE	512
 
+/* Set while the file is open, to allow one server at a time */
+#define TCMUR_DEV_OPEN		0
+
 struct tcmur_dev;
 
 /**
@@ -34,6 +41,10 @@ struct tcmur_queue {
 
 struct tcmur_dev {
 	struct se_device	se_dev;
+	struct device		cdev_dev;
+	struct cdev		cdev;
+	int			dev_id;
+	unsigned long		flags;
 
 	u64			dev_size;
 	u32			block_size;
@@ -43,6 +54,13 @@ struct tcmur_dev {
 	struct tcmur_queue	*queues;
 };
 
+static DEFINE_IDA(tcmur_ida);
+static dev_t tcmur_devt;
+
+static const struct class tcmur_class = {
+	.name = "tcm-uring",
+};
+
 static struct tcmur_dev *TCMUR_DEV(struct se_device *dev)
 {
 	return container_of(dev, struct tcmur_dev, se_dev);
@@ -61,6 +79,56 @@ static size_t tcmur_desc_area_size(struct tcmur_dev *udev)
 	return PAGE_ALIGN(udev->queue_depth * sizeof(struct tcmur_io_desc));
 }
 
+static long tcmur_ch_ioctl(struct file *filp, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct tcmur_dev *udev = filp->private_data;
+	struct tcmur_dev_info info = {
+		.dev_size	= udev->dev_size,
+		.block_size	= udev->block_size,
+		.max_io_size	= TCMUR_MAX_IO_SIZE,
+		.nr_queues	= udev->nr_queues,
+		.queue_depth	= udev->queue_depth,
+	};
+
+	if (cmd != TCMUR_GET_DEV_INFO)
+		return -ENOTTY;
+
+	if (copy_to_user((void __user *)arg, &info, sizeof(info)))
+		return -EFAULT;
+	return 0;
+}
+
+static int tcmur_ch_open(struct inode *inode, struct file *filp)
+{
+	struct tcmur_dev *udev = container_of(inode->i_cdev, struct tcmur_dev,
+					      cdev);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (test_and_set_bit(TCMUR_DEV_OPEN, &udev->flags))
+		return -EBUSY;
+
+	filp->private_data = udev;
+	return 0;
+}
+
+static int tcmur_ch_release(struct inode *inode, struct file *filp)
+{
+	struct tcmur_dev *udev = filp->private_data;
+
+	clear_bit(TCMUR_DEV_OPEN, &udev->flags);
+	return 0;
+}
+
+static const struct file_operations tcmur_ch_fops = {
+	.owner		= THIS_MODULE,
+	.open		= tcmur_ch_open,
+	.release	= tcmur_ch_release,
+	.unlocked_ioctl	= tcmur_ch_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+};
+
 static void tcmur_free_queues(struct tcmur_dev *udev)
 {
 	unsigned int i;
@@ -104,6 +172,16 @@ static void tcmur_dev_call_rcu(struct rcu_head *p)
 	kfree(TCMUR_DEV(dev));
 }
 
+static void tcmur_cdev_release(struct device *dev)
+{
+	struct tcmur_dev *udev = container_of(dev, struct tcmur_dev, cdev_dev);
+
+	tcmur_free_queues(udev);
+	if (udev->dev_id >= 0)
+		ida_free(&tcmur_ida, udev->dev_id);
+	call_rcu(&udev->se_dev.rcu_head, tcmur_dev_call_rcu);
+}
+
 static int tcmur_attach_hba(struct se_hba *hba, u32 host_id)
 {
 	return 0;
@@ -122,10 +200,15 @@ static struct se_device *tcmur_alloc_device(struct se_hba *hba,
 	if (!udev)
 		return NULL;
 
+	udev->dev_id = -1;
 	udev->nr_queues = 1;
 	udev->queue_depth = TCMUR_DEF_QUEUE_DEPTH;
 	udev->block_size = TCMUR_DEF_BLOCK_SIZE;
 
+	device_initialize(&udev->cdev_dev);
+	udev->cdev_dev.class = &tcmur_class;
+	udev->cdev_dev.release = tcmur_cdev_release;
+
 	return &udev->se_dev;
 }
 
@@ -143,24 +226,47 @@ static int tcmur_configure_device(struct se_device *dev)
 	if (ret)
 		return ret;
 
+	ret = ida_alloc_max(&tcmur_ida, TCMUR_MINORS - 1, GFP_KERNEL);
+	if (ret < 0)
+		goto free_queues;
+	udev->dev_id = ret;
+
 	dev->dev_attrib.hw_block_size = udev->block_size;
 	dev->dev_attrib.hw_max_sectors = TCMUR_MAX_IO_SIZE / udev->block_size;
 	dev->dev_attrib.hw_queue_depth = udev->nr_queues * udev->queue_depth;
 	dev->dev_attrib.is_nonrot = 1;
 
+	udev->cdev_dev.devt = MKDEV(MAJOR(tcmur_devt), udev->dev_id);
+	ret = dev_set_name(&udev->cdev_dev, "tcmur%d", udev->dev_id);
+	if (ret)
+		goto free_id;
+
+	cdev_init(&udev->cdev, &tcmur_ch_fops);
+	udev->cdev.owner = THIS_MODULE;
+	ret = cdev_device_add(&udev->cdev, &udev->cdev_dev);
+	if (ret)
+		goto free_id;
+
 	return 0;
+
+free_id:
+	ida_free(&tcmur_ida, udev->dev_id);
+	udev->dev_id = -1;
+free_queues:
+	tcmur_free_queues(udev);
+	return ret;
 }
 
 static void tcmur_destroy_device(struct se_device *dev)
 {
 	struct tcmur_dev *udev = TCMUR_DEV(dev);
 
-	tcmur_free_queues(udev);
+	cdev_device_del(&udev->cdev, &udev->cdev_dev);
 }
 
 static void tcmur_free_device(struct se_device *dev)
 {
-	call_rcu(&dev->rcu_head, tcmur_dev_call_rcu);
+	put_device(&TCMUR_DEV(dev)->cdev_dev);
 }
 
 enum {
@@ -239,6 +345,8 @@ static ssize_t tcmur_show_configfs_dev_params(struct se_device *dev, char *b)
 	struct tcmur_dev *udev = TCMUR_DEV(dev);
 	ssize_t bl = 0;
 
+	if (udev->dev_id >= 0)
+		bl += sprintf(b + bl, "Device: /dev/tcmur%d ", udev->dev_id);
 	bl += sprintf(b + bl, "Size: %llu Block size: %u", udev->dev_size,
 		      udev->block_size);
 	bl += sprintf(b + bl, " Queues: %u Queue depth: %u", udev->nr_queues,
@@ -284,13 +392,35 @@ static const struct target_backend_ops tcmur_ops = {
 
 static int __init tcmur_module_init(void)
 {
-	return transport_backend_register(&tcmur_ops);
+	int ret;
+
+	ret = alloc_chrdev_region(&tcmur_devt, 0, TCMUR_MINORS, "tcm-uring");
+	if (ret)
+		return ret;
+
+	ret = class_register(&tcmur_class);
+	if (ret)
+		goto unregister_chrdev;
+
+	ret = transport_backend_register(&tcmur_ops);
+	if (ret)
+		goto unregister_class;
+
+	return 0;
+
+unregister_class:
+	class_unregister(&tcmur_class);
+unregister_chrdev:
+	unregister_chrdev_region(tcmur_devt, TCMUR_MINORS);
+	return ret;
 }
 
 static void __exit tcmur_module_exit(void)
 {
 	target_backend_unregister(&tcmur_ops);
-	/* Wait for the devices that tcmur_free_device() frees with RCU */
+	class_unregister(&tcmur_class);
+	unregister_chrdev_region(tcmur_devt, TCMUR_MINORS);
+	/* Wait for the devices that tcmur_cdev_release() frees with RCU */
 	rcu_barrier();
 }
 
diff --git a/include/uapi/linux/target_core_uring.h b/include/uapi/linux/target_core_uring.h
index 64fa1dfcd011f..c23e01e7638a2 100644
--- a/include/uapi/linux/target_core_uring.h
+++ b/include/uapi/linux/target_core_uring.h
@@ -3,15 +3,40 @@
 #define _UAPI_LINUX_TARGET_CORE_URING_H
 
 #include <linux/types.h>
+#include <linux/ioctl.h>
 
 /*
  * target_core_uring hands the block commands of a LIO device to a userspace
- * server.
+ * server. The server opens /dev/tcmurN to drive the device.
  */
 
 #define TCMUR_MAX_NR_QUEUES	512
 #define TCMUR_MAX_QUEUE_DEPTH	4096
 
+/**
+ * struct tcmur_dev_info - Geometry of a device
+ * @dev_size:		Size of the device in bytes
+ * @block_size:		Logical block size in bytes
+ * @max_io_size:	Largest amount of data in one command, in bytes
+ * @nr_queues:		Number of queues
+ * @queue_depth:	Number of tags per queue
+ * @reserved0:		Zero
+ * @features:		Zero for now
+ * @reserved1:		Zero
+ */
+struct tcmur_dev_info {
+	__u64	dev_size;
+	__u32	block_size;
+	__u32	max_io_size;
+	__u16	nr_queues;
+	__u16	queue_depth;
+	__u32	reserved0;
+	__u64	features;
+	__u64	reserved1[4];
+};
+
+#define TCMUR_GET_DEV_INFO	_IOR(0xBB, 0x00, struct tcmur_dev_info)
+
 enum tcmur_io_op {
 	TCMUR_OP_READ,
 	TCMUR_OP_WRITE,

-- 
2.43.0

