Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788310;
	b=dwA1AFK1T7lOYCC2uOOaqAsmpD9fYoflYy4f7FE3fx0lePfHaOpI+ii6j0ncTVaEniDB
	 mGUQnp2APzXKpMLkqcEtom6/tWfb3vew4W9SQSJX0EkTR179FOgzmIAWneYmxjOv79qTE
	 2A6HcfD4QioQz++WCHq2nD7nX++UKNgdstl1G0g5Ej0KxS3OMwFO1TUq31JJD6CUQP1Wj
	 L55h/ERgGnfbmQInXiQkEdoC10QPqPuyNJKU5m6kX/7yJIRsmlRXzGwKKcmBpQ1tjpB9/
	 bO2HI1Qesuonw4hAkNqiqQ5JlpVeg+iIdMclCkeWx8yHAThUbc3VsLEqiEY3w6yWIGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788310;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=mMdb4tR91nmD6w506kiG4wAfNL4qMROGO5XCFHkTs2Y=;
	b=FkCL2n7pmMXMfi1sY1Nira95UxUv5t1EAaaVZ07P8obzbtLzdGiELNkKtffULpZKo3Yx
	 C1KXU0mnlU62iz8y+tkcbThJdmxJcPVwZr6oMAJug9McSUzsGzCwTHeqWgNBTeiri2r+0
	 f1yglg94hl0G9dpYLoBIgjGhEbBPRtKWwENkkvAIOqmih7aGfr8DEkGLS8kpIw1+l+443
	 k0rG4S/xnW3PY7pfaYISzgquPhCtMdg0/BKOLDlw0Bnc0Ly6jD44GgP1v2kYC5mtgymBu
	 eSGE1BJN1sXQWeTn/1VWwY2md8yJ8USvqCpo6eoX8PVeWDkJ7Tck/AZMQMjfZqp2IAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YRCB1i1b;
	arc=none smtp.remote-ip=95.215.58.144
Received: from mta1.migadu.com (out-144.mta1.migadu.com [95.215.58.144])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BBD606A331
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95BBD606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YRCB1i1b
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lHzioVgVpmzpNGL2O+NZClhTWJ3YSVbogsBizqbwGcA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788307; v=1; x=1795393107;
 b=YRCB1i1bD8ufcayP6KqNrPS8Wxciy7YfJwkHeY57O5yd4b0r2AcX78wJxlWU3rID1LJwzZhe
 8lU3GYcJzYRxIRZvbyz7XfNO2JZA2IutIVinNyEMQOpI0wwuuGEiDnPj7uKHpZdAQ3RNQF92SeW
 G6s0slZxlZOBPE9MoiIdDwGA=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ff2ac73be5b4796c;
	Mon, 16 Nov 2026 00:18:27 +0000
X-Mizu-Trace-ID: ff2ac73be5b4796c
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:17:55 -0500
Subject: [PATCH RFC 02/18] scsi: target: uring: Allocate per-queue command
 descriptors
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
Message-Id: <20261115-feat-target-core-uring-v1-2-28cdc137eac6@linux.dev>
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

A target_core_uring device only has a size and a block size so far.

The server needs to learn what each command asks for, and commands
submitted on different CPUs should not share state.

Add the nr_queues and queue_depth parameters and allocate that many
queues when the device is configured. Give each queue an array of
struct tcmur_io_desc, one per tag, that describes a command as an
operation, an offset and a length. Define the descriptor in a new uAPI
header and allocate the array with vmalloc_user() so that it can be
mapped later.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 MAINTAINERS                            |  1 +
 drivers/target/target_core_uring.c     | 90 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/target_core_uring.h | 43 ++++++++++++++++
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e31de6e2ebfb..07148430d9ea6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25330,6 +25330,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
 F:	Documentation/target/
 F:	drivers/target/
 F:	include/target/
+F:	include/uapi/linux/target_core_uring.h
 
 SCTP PROTOCOL
 M:	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 13981e608a85c..135435748d367 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -7,20 +7,40 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/mm.h>
 #include <linux/parser.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
+#include <uapi/linux/target_core_uring.h>
 
 #define TCMUR_VERSION		"1.0"
 #define TCMUR_MAX_IO_SIZE	(4U << 20)
+#define TCMUR_DEF_QUEUE_DEPTH	128
 #define TCMUR_DEF_BLOCK_SIZE	512
 
+struct tcmur_dev;
+
+/**
+ * struct tcmur_queue - One command queue
+ * @descs:	Command descriptors, indexed by tag
+ * @udev:	Device the queue belongs to
+ */
+struct tcmur_queue {
+	struct tcmur_io_desc	*descs;
+	struct tcmur_dev	*udev;
+} ____cacheline_aligned_in_smp;
+
 struct tcmur_dev {
 	struct se_device	se_dev;
 
 	u64			dev_size;
 	u32			block_size;
+	u16			nr_queues;
+	u16			queue_depth;
+
+	struct tcmur_queue	*queues;
 };
 
 static struct tcmur_dev *TCMUR_DEV(struct se_device *dev)
@@ -36,6 +56,47 @@ static sense_reason_t tcmur_execute_rw(struct se_cmd *se_cmd,
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
+static size_t tcmur_desc_area_size(struct tcmur_dev *udev)
+{
+	return PAGE_ALIGN(udev->queue_depth * sizeof(struct tcmur_io_desc));
+}
+
+static void tcmur_free_queues(struct tcmur_dev *udev)
+{
+	unsigned int i;
+
+	if (!udev->queues)
+		return;
+
+	for (i = 0; i < udev->nr_queues; i++)
+		vfree(udev->queues[i].descs);
+	kvfree(udev->queues);
+	udev->queues = NULL;
+}
+
+static int tcmur_alloc_queues(struct tcmur_dev *udev)
+{
+	struct tcmur_queue *q;
+	unsigned int i;
+
+	udev->queues = kvcalloc(udev->nr_queues, sizeof(*udev->queues),
+				GFP_KERNEL);
+	if (!udev->queues)
+		return -ENOMEM;
+
+	for (i = 0; i < udev->nr_queues; i++) {
+		q = &udev->queues[i];
+
+		q->udev = udev;
+		q->descs = vmalloc_user(tcmur_desc_area_size(udev));
+		if (!q->descs) {
+			tcmur_free_queues(udev);
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
 static void tcmur_dev_call_rcu(struct rcu_head *p)
 {
 	struct se_device *dev = container_of(p, struct se_device, rcu_head);
@@ -61,6 +122,8 @@ static struct se_device *tcmur_alloc_device(struct se_hba *hba,
 	if (!udev)
 		return NULL;
 
+	udev->nr_queues = 1;
+	udev->queue_depth = TCMUR_DEF_QUEUE_DEPTH;
 	udev->block_size = TCMUR_DEF_BLOCK_SIZE;
 
 	return &udev->se_dev;
@@ -69,14 +132,20 @@ static struct se_device *tcmur_alloc_device(struct se_hba *hba,
 static int tcmur_configure_device(struct se_device *dev)
 {
 	struct tcmur_dev *udev = TCMUR_DEV(dev);
+	int ret;
 
 	if (!udev->dev_size || (udev->dev_size & (udev->block_size - 1))) {
 		pr_err("dev_size must be a multiple of the block size\n");
 		return -EINVAL;
 	}
 
+	ret = tcmur_alloc_queues(udev);
+	if (ret)
+		return ret;
+
 	dev->dev_attrib.hw_block_size = udev->block_size;
 	dev->dev_attrib.hw_max_sectors = TCMUR_MAX_IO_SIZE / udev->block_size;
+	dev->dev_attrib.hw_queue_depth = udev->nr_queues * udev->queue_depth;
 	dev->dev_attrib.is_nonrot = 1;
 
 	return 0;
@@ -84,6 +153,9 @@ static int tcmur_configure_device(struct se_device *dev)
 
 static void tcmur_destroy_device(struct se_device *dev)
 {
+	struct tcmur_dev *udev = TCMUR_DEV(dev);
+
+	tcmur_free_queues(udev);
 }
 
 static void tcmur_free_device(struct se_device *dev)
@@ -92,12 +164,14 @@ static void tcmur_free_device(struct se_device *dev)
 }
 
 enum {
-	Opt_dev_size, Opt_block_size, Opt_err,
+	Opt_dev_size, Opt_block_size, Opt_nr_queues, Opt_queue_depth, Opt_err,
 };
 
 static const match_table_t tcmur_tokens = {
 	{ Opt_dev_size,		"dev_size=%s" },
 	{ Opt_block_size,	"block_size=%u" },
+	{ Opt_nr_queues,	"nr_queues=%u" },
+	{ Opt_queue_depth,	"queue_depth=%u" },
 	{ Opt_err,		NULL }
 };
 
@@ -141,6 +215,18 @@ static ssize_t tcmur_set_configfs_dev_params(struct se_device *dev,
 			else
 				udev->block_size = val;
 			break;
+		case Opt_nr_queues:
+			if (!val || val > TCMUR_MAX_NR_QUEUES)
+				ret = -EINVAL;
+			else
+				udev->nr_queues = val;
+			break;
+		case Opt_queue_depth:
+			if (!val || val > TCMUR_MAX_QUEUE_DEPTH)
+				ret = -EINVAL;
+			else
+				udev->queue_depth = val;
+			break;
 		}
 	}
 
@@ -155,6 +241,8 @@ static ssize_t tcmur_show_configfs_dev_params(struct se_device *dev, char *b)
 
 	bl += sprintf(b + bl, "Size: %llu Block size: %u", udev->dev_size,
 		      udev->block_size);
+	bl += sprintf(b + bl, " Queues: %u Queue depth: %u", udev->nr_queues,
+		      udev->queue_depth);
 	bl += sprintf(b + bl, "\n");
 	return bl;
 }
diff --git a/include/uapi/linux/target_core_uring.h b/include/uapi/linux/target_core_uring.h
new file mode 100644
index 0000000000000..64fa1dfcd011f
--- /dev/null
+++ b/include/uapi/linux/target_core_uring.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_TARGET_CORE_URING_H
+#define _UAPI_LINUX_TARGET_CORE_URING_H
+
+#include <linux/types.h>
+
+/*
+ * target_core_uring hands the block commands of a LIO device to a userspace
+ * server.
+ */
+
+#define TCMUR_MAX_NR_QUEUES	512
+#define TCMUR_MAX_QUEUE_DEPTH	4096
+
+enum tcmur_io_op {
+	TCMUR_OP_READ,
+	TCMUR_OP_WRITE,
+};
+
+/* Put the write on stable storage before completing it */
+#define TCMUR_IO_F_FUA		(1U << 0)
+
+/**
+ * struct tcmur_io_desc - Describe one command
+ * @op:		Operation, one of enum tcmur_io_op
+ * @flags:	TCMUR_IO_F_*
+ * @offset:	Start of the range in bytes
+ * @len:	Length of the range in bytes
+ * @data_len:	Bytes of data to transfer
+ * @reserved:	Zero
+ *
+ * The descriptors of a queue form an array indexed by tag.
+ */
+struct tcmur_io_desc {
+	__u32	op;
+	__u32	flags;
+	__u64	offset;
+	__u64	len;
+	__u32	data_len;
+	__u32	reserved;
+};
+
+#endif /* _UAPI_LINUX_TARGET_CORE_URING_H */

-- 
2.43.0

