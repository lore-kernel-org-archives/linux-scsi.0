Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.161
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788339;
	b=tky0R2zJUbkJvQ++wrCtvzsMU3/XJNu+M9xLqvUZ1D77tpCcV1+kgMMWeKQ0+3rDskrA
	 DrQCm1Nm8BcdvCR6OTzi2anle93m0auLp2JccucWHQPf7k0PYFMifVcBd+LijIGA+yoqR
	 7pzrpooN50Z1A85cX3g0C66+NaST/WlS9L3ulUPspVtyBQ5IGFN/mecjRHEYI1ABOqWp5
	 rBhjarjLan/yO3P1DXED6wBd8FrFIhgDMO3lQJ/pyrFBtBiHhDBoIZzXCgirbnC9xjcYV
	 m/jl4Bj25ZT7ZDJLp328vKeFxttUbWy8xX1wq8uInh/0tF2Ep8PCnP7Ww4KzkP3bhAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788339;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=tdfrOz7xzGfEXq8vJYPg+0YWf7A28euKsigs+APSsvI=;
	b=Hi5X/7eYTtcs/wqvaK8x3qwcReEAxB4QsCS1YCNnfmmpx84ArLqhGl6T2xcIAOcviwoU
	 NkSb46eaXw4LcazVJEzADZaY2sLvyybwwLGdtHVMKGuQjWNFnwliiGE5OFp35qUItLZON
	 Qrsqvi9qbyRyrOHf/3L+UKDiCoK59HPZBQFiULuRcpqZA0VpPfnCQSPCEafWt/5dDeCu7
	 m5qRoYIZ0r2uANONI25dgSWZ2Iq+Gps84ieD/MwBHpy8xQkkKbm+HFyJqxqqBS6fk632U
	 qOgnL0bQS6dD8hmGw2Fg9e/2OY8vkqBLvSGnsya7fvVkEtqd5nj+ectcsnkh0peKISA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WQ5ZmKJj;
	arc=none smtp.remote-ip=95.215.58.161
Received: from mta1.migadu.com (out-161.mta1.migadu.com [95.215.58.161])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB359606A31F
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB359606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WQ5ZmKJj
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FD4pERxyaSKZxtj3i6sUoeKk0RZJV3mRCelRawAFGC0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788337; v=1; x=1795393137;
 b=WQ5ZmKJjRD44sDRg52PZ6tHbUsnqIBHD4LHVb2r0uDtWEOImqesdYGjNLdHtKVdr+c8zf66Y
 90Ts5mrwmBb0PXh64EYC/2SLfc0HsycUeREfbPlZR85RkjCCwZVWAbpsJzVjV67RA28j3eB5N1a
 GfDfvRreo3QGxR9SFWZJJ0OA=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 612ab943454751cd;
	Mon, 16 Nov 2026 00:18:57 +0000
X-Mizu-Trace-ID: 612ab943454751cd
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:17:59 -0500
Subject: [PATCH RFC 06/18] scsi: target: uring: Hand commands out through
 TCMUR_IO_FETCH
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
Message-Id: <20261115-feat-target-core-uring-v1-6-28cdc137eac6@linux.dev>
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

Reads and writes of a target_core_uring device wait on the pending list
of their queue.

Nothing takes commands off that list.

Add the TCMUR_IO_FETCH io_uring command. The server issues one per tag;
it completes once the descriptor of the tag holds a command. If a
command is pending, hand it out right away. Otherwise park the fetch
command on the idle list of the queue and complete it from task work
when a command arrives. Complete parked fetch commands with -ECANCELED
when io_uring cancels them, and with -ENODEV when the device goes away.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c     | 216 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/target_core_uring.h |  24 +++-
 2 files changed, 235 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 90e443ecb944c..85c9a1ae84433 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -2,6 +2,10 @@
 /*
  * LIO backstore that hands block commands to a userspace server through
  * io_uring commands.
+ *
+ * Each device has a character device and a set of queues. A queue holds
+ * queue_depth tags; the server owns a tag from the moment the kernel
+ * completes its fetch command until it commits the result.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -10,6 +14,7 @@
 #include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/idr.h>
+#include <linux/io_uring/cmd.h>
 #include <linux/mm.h>
 #include <linux/parser.h>
 #include <linux/scatterlist.h>
@@ -46,16 +51,34 @@ struct tcmur_cmd {
 	struct tcmur_io_desc	desc;
 };
 
+/**
+ * struct tcmur_io - State of one tag
+ * @node:	Entry in tcmur_queue.idle while @ucmd waits for a command
+ * @ucmd:	Fetch command of the server
+ * @cmd:	Command the server is working on
+ * @owned:	The server owns the tag and has to commit it
+ */
+struct tcmur_io {
+	struct list_head	node;
+	struct io_uring_cmd	*ucmd;
+	struct tcmur_cmd	*cmd;
+	bool			owned;
+};
+
 /**
  * struct tcmur_queue - One command queue
- * @lock:	Protect the list
+ * @lock:	Protect the lists and the tags
+ * @idle:	Tags with a fetch command waiting for a command
  * @pending:	Commands waiting for a tag
+ * @ios:	Tags of the queue
  * @descs:	Command descriptors, indexed by tag and mapped by the server
  * @udev:	Device the queue belongs to
  */
 struct tcmur_queue {
 	spinlock_t		lock;
+	struct list_head	idle;
 	struct list_head	pending;
+	struct tcmur_io		*ios;
 	struct tcmur_io_desc	*descs;
 	struct tcmur_dev	*udev;
 } ____cacheline_aligned_in_smp;
@@ -66,6 +89,7 @@ struct tcmur_dev {
 	struct cdev		cdev;
 	int			dev_id;
 	unsigned long		flags;
+	bool			dead;
 
 	u64			dev_size;
 	u32			block_size;
@@ -75,6 +99,18 @@ struct tcmur_dev {
 	struct tcmur_queue	*queues;
 };
 
+/**
+ * struct tcmur_uring_pdu - State of a parked fetch command
+ * @q:		Queue of the tag
+ * @io:		Tag the command fetches for
+ * @res:	Result to complete the command with
+ */
+struct tcmur_uring_pdu {
+	struct tcmur_queue	*q;
+	struct tcmur_io		*io;
+	int			res;
+};
+
 static struct kmem_cache *tcmur_cmd_cache;
 static DEFINE_IDA(tcmur_ida);
 static dev_t tcmur_devt;
@@ -94,13 +130,46 @@ static struct tcmur_queue *tcmur_cmd_queue(struct tcmur_dev *udev,
 	return &udev->queues[(unsigned int)se_cmd->cpuid % udev->nr_queues];
 }
 
+/* Hand @tcmd to the server through the tag @io */
+static void tcmur_io_start(struct tcmur_queue *q, struct tcmur_io *io,
+			   struct tcmur_cmd *tcmd)
+{
+	lockdep_assert_held(&q->lock);
+
+	io->cmd = tcmd;
+	io->owned = true;
+	q->descs[io - q->ios] = tcmd->desc;
+}
+
+static void tcmur_fetch_tw_cb(struct io_tw_req tw_req, io_tw_token_t tw)
+{
+	struct io_uring_cmd *ucmd = io_uring_cmd_from_tw(tw_req);
+	struct tcmur_uring_pdu *pdu = io_uring_cmd_to_pdu(ucmd,
+						struct tcmur_uring_pdu);
+
+	io_uring_cmd_done(ucmd, pdu->res, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
+}
+
 static void tcmur_queue_cmd(struct tcmur_dev *udev, struct tcmur_cmd *tcmd)
 {
 	struct tcmur_queue *q = tcmur_cmd_queue(udev, tcmd->se_cmd);
+	struct io_uring_cmd *ucmd = NULL;
+	struct tcmur_io *io;
 
 	spin_lock(&q->lock);
-	list_add_tail(&tcmd->node, &q->pending);
+	io = list_first_entry_or_null(&q->idle, struct tcmur_io, node);
+	if (io) {
+		list_del(&io->node);
+		ucmd = io->ucmd;
+		io->ucmd = NULL;
+		tcmur_io_start(q, io, tcmd);
+	} else {
+		list_add_tail(&tcmd->node, &q->pending);
+	}
 	spin_unlock(&q->lock);
+
+	if (ucmd)
+		io_uring_cmd_complete_in_task(ucmd, tcmur_fetch_tw_cb);
 }
 
 static sense_reason_t tcmur_submit(struct se_cmd *se_cmd, u32 op, u64 offset,
@@ -140,6 +209,113 @@ static sense_reason_t tcmur_execute_rw(struct se_cmd *se_cmd,
 			    se_cmd->data_length, sgl, sgl_nents);
 }
 
+static void tcmur_cancel_fetch(struct io_uring_cmd *ucmd,
+			       unsigned int issue_flags)
+{
+	struct tcmur_uring_pdu *pdu = io_uring_cmd_to_pdu(ucmd,
+						struct tcmur_uring_pdu);
+	struct tcmur_queue *q = pdu->q;
+	struct tcmur_io *io = pdu->io;
+	bool found = false;
+
+	spin_lock(&q->lock);
+	if (io->ucmd == ucmd) {
+		list_del(&io->node);
+		io->ucmd = NULL;
+		found = true;
+	}
+	spin_unlock(&q->lock);
+
+	if (found)
+		io_uring_cmd_done(ucmd, -ECANCELED, issue_flags);
+}
+
+static int tcmur_fetch(struct tcmur_queue *q, struct tcmur_io *io,
+		       struct io_uring_cmd *ucmd, unsigned int issue_flags)
+{
+	struct tcmur_uring_pdu *pdu = io_uring_cmd_to_pdu(ucmd,
+						struct tcmur_uring_pdu);
+	struct tcmur_cmd *tcmd;
+	int ret = 0;
+
+	spin_lock(&q->lock);
+	if (q->udev->dead) {
+		ret = -ENODEV;
+	} else if (io->ucmd || io->owned) {
+		ret = -EBUSY;
+	} else if (!list_empty(&q->pending)) {
+		tcmd = list_first_entry(&q->pending, struct tcmur_cmd, node);
+		list_del(&tcmd->node);
+		tcmur_io_start(q, io, tcmd);
+	} else {
+		pdu->q = q;
+		pdu->io = io;
+		pdu->res = 0;
+		io->ucmd = ucmd;
+		list_add(&io->node, &q->idle);
+		ret = -EIOCBQUEUED;
+	}
+	spin_unlock(&q->lock);
+
+	if (ret == -EIOCBQUEUED)
+		io_uring_cmd_mark_cancelable(ucmd, issue_flags);
+	return ret;
+}
+
+static int tcmur_ch_uring_cmd_local(struct io_uring_cmd *ucmd,
+				    unsigned int issue_flags)
+{
+	const struct tcmur_io_cmd *ioc = io_uring_sqe_cmd(ucmd->sqe,
+							  struct tcmur_io_cmd);
+	struct tcmur_dev *udev = ucmd->file->private_data;
+	u16 q_id = READ_ONCE(ioc->q_id);
+	u16 tag = READ_ONCE(ioc->tag);
+	struct tcmur_queue *q;
+	struct tcmur_io *io;
+
+	if (q_id >= udev->nr_queues || tag >= udev->queue_depth)
+		return -EINVAL;
+
+	q = &udev->queues[q_id];
+	io = &q->ios[tag];
+
+	switch (ucmd->cmd_op) {
+	case TCMUR_IO_FETCH:
+		return tcmur_fetch(q, io, ucmd, issue_flags);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void tcmur_ch_uring_cmd_tw_cb(struct io_tw_req tw_req, io_tw_token_t tw)
+{
+	unsigned int issue_flags = IO_URING_CMD_TASK_WORK_ISSUE_FLAGS;
+	struct io_uring_cmd *ucmd = io_uring_cmd_from_tw(tw_req);
+	int ret = -ECANCELED;
+
+	if (!tw.cancel)
+		ret = tcmur_ch_uring_cmd_local(ucmd, issue_flags);
+	if (ret != -EIOCBQUEUED)
+		io_uring_cmd_done(ucmd, ret, issue_flags);
+}
+
+static int tcmur_ch_uring_cmd(struct io_uring_cmd *ucmd,
+			      unsigned int issue_flags)
+{
+	if (unlikely(issue_flags & IO_URING_F_CANCEL)) {
+		tcmur_cancel_fetch(ucmd, issue_flags);
+		return 0;
+	}
+
+	/* Run in the submitting task, where fetch commands are completed */
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_uring_cmd_complete_in_task(ucmd, tcmur_ch_uring_cmd_tw_cb);
+		return -EIOCBQUEUED;
+	}
+
+	return tcmur_ch_uring_cmd_local(ucmd, issue_flags);
+}
+
 static size_t tcmur_desc_area_size(struct tcmur_dev *udev)
 {
 	return PAGE_ALIGN(udev->queue_depth * sizeof(struct tcmur_io_desc));
@@ -210,6 +386,7 @@ static const struct file_operations tcmur_ch_fops = {
 	.owner		= THIS_MODULE,
 	.open		= tcmur_ch_open,
 	.release	= tcmur_ch_release,
+	.uring_cmd	= tcmur_ch_uring_cmd,
 	.mmap		= tcmur_ch_mmap,
 	.unlocked_ioctl	= tcmur_ch_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
@@ -222,8 +399,10 @@ static void tcmur_free_queues(struct tcmur_dev *udev)
 	if (!udev->queues)
 		return;
 
-	for (i = 0; i < udev->nr_queues; i++)
+	for (i = 0; i < udev->nr_queues; i++) {
 		vfree(udev->queues[i].descs);
+		kvfree(udev->queues[i].ios);
+	}
 	kvfree(udev->queues);
 	udev->queues = NULL;
 }
@@ -242,10 +421,13 @@ static int tcmur_alloc_queues(struct tcmur_dev *udev)
 		q = &udev->queues[i];
 
 		spin_lock_init(&q->lock);
+		INIT_LIST_HEAD(&q->idle);
 		INIT_LIST_HEAD(&q->pending);
 		q->udev = udev;
+		q->ios = kvcalloc(udev->queue_depth, sizeof(*q->ios),
+				  GFP_KERNEL);
 		q->descs = vmalloc_user(tcmur_desc_area_size(udev));
-		if (!q->descs) {
+		if (!q->ios || !q->descs) {
 			tcmur_free_queues(udev);
 			return -ENOMEM;
 		}
@@ -348,8 +530,34 @@ static int tcmur_configure_device(struct se_device *dev)
 static void tcmur_destroy_device(struct se_device *dev)
 {
 	struct tcmur_dev *udev = TCMUR_DEV(dev);
+	struct tcmur_uring_pdu *pdu;
+	struct io_uring_cmd *ucmd;
+	struct tcmur_queue *q;
+	struct tcmur_io *io;
+	unsigned int i;
 
 	cdev_device_del(&udev->cdev, &udev->cdev_dev);
+
+	/*
+	 * Tell the server that the device is gone. Complete the fetch
+	 * commands from task work, like tcmur_queue_cmd() does.
+	 */
+	for (i = 0; i < udev->nr_queues; i++) {
+		q = &udev->queues[i];
+
+		spin_lock(&q->lock);
+		udev->dead = true;
+		while (!list_empty(&q->idle)) {
+			io = list_first_entry(&q->idle, struct tcmur_io, node);
+			list_del(&io->node);
+			ucmd = io->ucmd;
+			io->ucmd = NULL;
+			pdu = io_uring_cmd_to_pdu(ucmd, struct tcmur_uring_pdu);
+			pdu->res = -ENODEV;
+			io_uring_cmd_complete_in_task(ucmd, tcmur_fetch_tw_cb);
+		}
+		spin_unlock(&q->lock);
+	}
 }
 
 static void tcmur_free_device(struct se_device *dev)
diff --git a/include/uapi/linux/target_core_uring.h b/include/uapi/linux/target_core_uring.h
index d2b8ffe40bf7a..9ce871d2e2087 100644
--- a/include/uapi/linux/target_core_uring.h
+++ b/include/uapi/linux/target_core_uring.h
@@ -7,7 +7,9 @@
 
 /*
  * target_core_uring hands the block commands of a LIO device to a userspace
- * server. The server opens /dev/tcmurN to drive the device.
+ * server. The server opens /dev/tcmurN, maps the command descriptors of
+ * each queue and exchanges commands with the kernel through io_uring
+ * commands (IORING_OP_URING_CMD) issued on that file.
  */
 
 #define TCMUR_MAX_NR_QUEUES	512
@@ -37,6 +39,26 @@ struct tcmur_dev_info {
 
 #define TCMUR_GET_DEV_INFO	_IOR(0xBB, 0x00, struct tcmur_dev_info)
 
+/**
+ * struct tcmur_io_cmd - Payload of the io_uring commands, placed in sqe->cmd
+ * @q_id:	Queue of the tag
+ * @tag:	Tag the command is for
+ * @reserved:	Zero
+ * @reserved1:	Zero
+ */
+struct tcmur_io_cmd {
+	__u16	q_id;
+	__u16	tag;
+	__s32	reserved;
+	__u64	reserved1;
+};
+
+/*
+ * TCMUR_IO_FETCH: wait for a command on (q_id, tag). The CQE result is 0
+ * once the descriptor of the tag holds a command.
+ */
+#define TCMUR_IO_FETCH			_IOWR(0xBB, 0x08, struct tcmur_io_cmd)
+
 enum tcmur_io_op {
 	TCMUR_OP_READ,
 	TCMUR_OP_WRITE,

-- 
2.43.0

