Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C42C2BBCD
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1CBE22597
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgLDH5g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 02:57:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbgLDH5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 02:57:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47oflt001894;
        Fri, 4 Dec 2020 07:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=rp7bFSDDHd55DqhuS2l/JjJUVhoj1ajEtKyRlYXpi/M=;
 b=fbM1fgOvtQ7zJskwGYfvgYswjrtVX2/5JQtt29e8MZFChgqUOJNoB5WHLcnTUCGUk8xu
 L8B6aoX18WJl4xB2bRs5KC5wlmCE5kWmZCt19mNj/891g4ofngZrk0Xi7X367dFgeSCG
 NEfCO0K+CjY3+HwdR+UGD6sr/Ur8Dm0C7xqqjbBRaw7HFdJNa2DfseeY0HjQbdZCru4Z
 KvnNjscKA2nIYMINWXGXmuiS4cCtZ3tYUYZ7aV+3ZmxdX0RMH6fcIi1CEMUN8I+HUVKe
 XAxjWZBGZB1aUSSkEcnSGJyOtuHOtMgXwpdK/spzDalpyPeLi92uOGYh2fG6M+mkq+AJ Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyr1wu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 07:56:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47oF7S079580;
        Fri, 4 Dec 2020 07:56:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3540f2yyyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 07:56:47 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B47ujcw007277;
        Fri, 4 Dec 2020 07:56:45 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 23:56:45 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     sgarzare@redhat.com, stefanha@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 5/8] vhost: allow userspace to bind vqs to CPUs
Date:   Fri,  4 Dec 2020 01:56:30 -0600
Message-Id: <1607068593-16932-6-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040045
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch allows user space to bind vqs to specific CPUs. Since
cgroups will not be supported this just uses the normal kernel
workqueues. I know you guys were thinking about userspace
initiating the threading and doing something like nbd's DO_IO
ioctl, or something like shared thread pools, etc. But workqueues
have had the benefits:

1. You can share the same thread with different devs and/or vqs
and there's almost no extra code in vhost.c.

2. If a work item blocks for too long, the workqueue code can
create new threads on demand for us. This ends up being helpful
for the scsi case, where we can block waiting for IO completions
when the queues get too full.

3. We get the workqueue's dynamic thread creation and destruction.
We don't have to add our own reaping code when the system becomes
less busy.

Some TODOs:

1. What about the default worker? I left this setup for now.
For vhost-scsi, we can have multple queues, and then also multple
LUNs under the same vhost-scsi device. So we might want some
lower perf LUNs to use the default worker and use the existing
cgroup settings.

2. I added the get_workqueue callout so drivers could pass in
their own workqueue incase some wanted to do a per device one.
We could also just one vhost workqueue. vhost-scsi can do a lot
of work that might block in its work struct so I didn't want
it to interfer with the other devs.

Some results:

With this patch and the patches for 5.11's target/lio layer that
fix up/remove the locking in the main IO path, I can get 920K IOPs
with the lio ram disk and 800K with the nullblk driver and iblock
backend. This is with 8 vqs, virtqueue_size/cmd_per_lun=1024 (in
some guests I had to set both really high to get the guest's
scsi_host can_queue high enough to allow IO from all vqs), and
a fio command like:

fio --filename=/dev/sda --direct=1 --rw=randrw --bs=4k --ioengine=libaio
--iodepth=128  --numjobs=8 --time_based --group_reporting --name=iops
--runtime=60 --eta-newline=1

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c        |   6 ++-
 drivers/vhost/vhost.c      | 130 +++++++++++++++++++++++++++++++++++++--------
 drivers/vhost/vhost.h      |  15 +++++-
 include/uapi/linux/vhost.h |   5 ++
 4 files changed, 129 insertions(+), 27 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d..6a27fe6 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1330,8 +1330,10 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
 		       NULL);
 
-	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
-	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev,
+			vqs[VHOST_NET_VQ_TX]);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev,
+			vqs[VHOST_NET_VQ_RX]);
 
 	f->private_data = n;
 	n->page_frag.page = NULL;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ee2551c..f425d0f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -187,13 +187,15 @@ void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn)
 
 /* Init poll structure */
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev)
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq)
 {
 	init_waitqueue_func_entry(&poll->wait, vhost_poll_wakeup);
 	init_poll_funcptr(&poll->table, vhost_poll_func);
 	poll->mask = mask;
 	poll->dev = dev;
 	poll->wqh = NULL;
+	poll->vq = vq;
 
 	vhost_work_init(&poll->work, fn);
 }
@@ -242,6 +244,9 @@ void vhost_work_dev_flush(struct vhost_dev *dev)
 		vhost_work_queue(dev, &flush.work);
 		wait_for_completion(&flush.wait_event);
 	}
+
+	if (dev->wq)
+		flush_workqueue(dev->wq);
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
@@ -253,7 +258,46 @@ void vhost_poll_flush(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
+static bool vhost_run_work_list(struct vhost_dev *dev,
+				struct llist_head *work_list)
+{
+	struct vhost_work *work, *work_next;
+	struct llist_node *node;
+
+	node = llist_del_all(work_list);
+	if (!node)
+		return false;
+
+	node = llist_reverse_order(node);
+	/* make sure flag is seen after deletion */
+	smp_wmb();
+	llist_for_each_entry_safe(work, work_next, node, node) {
+		clear_bit(VHOST_WORK_QUEUED, &work->flags);
+		__set_current_state(TASK_RUNNING);
+		kcov_remote_start_common(dev->kcov_handle);
+		work->fn(work);
+		kcov_remote_stop();
+		if (need_resched())
+			schedule();
+	}
+
+	return true;
+}
+
+static void vhost_vq_work(struct work_struct *work)
+{
+	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
+						  work);
+	struct vhost_dev *dev = vq->dev;
+
+	kthread_use_mm(dev->mm);
+	vhost_run_work_list(dev, &vq->work_list);
+	kthread_unuse_mm(dev->mm);
+}
+
+static void __vhost_work_queue(struct vhost_dev *dev,
+			       struct vhost_virtqueue *vq,
+			       struct vhost_work *work)
 {
 	if (!dev->worker)
 		return;
@@ -263,12 +307,28 @@ void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 		 * sure it was not in the list.
 		 * test_and_set_bit() implies a memory barrier.
 		 */
-		llist_add(&work->node, &dev->work_list);
-		wake_up_process(dev->worker);
+		if (!vq || vq->cpu == -1) {
+			llist_add(&work->node, &dev->work_list);
+			wake_up_process(dev->worker);
+		} else {
+			llist_add(&work->node, &vq->work_list);
+			queue_work_on(vq->cpu, dev->wq, &vq->work);
+		}
 	}
 }
+
+void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
+{
+	__vhost_work_queue(dev, NULL, work);
+}
 EXPORT_SYMBOL_GPL(vhost_work_queue);
 
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
+{
+	__vhost_work_queue(vq->dev, vq, work);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
+
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_has_work(struct vhost_dev *dev)
 {
@@ -278,7 +338,7 @@ bool vhost_has_work(struct vhost_dev *dev)
 
 void vhost_poll_queue(struct vhost_poll *poll)
 {
-	vhost_work_queue(poll->dev, &poll->work);
+	vhost_vq_work_queue(poll->vq, &poll->work);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_queue);
 
@@ -344,8 +404,6 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 static int vhost_worker(void *data)
 {
 	struct vhost_dev *dev = data;
-	struct vhost_work *work, *work_next;
-	struct llist_node *node;
 
 	kthread_use_mm(dev->mm);
 
@@ -358,22 +416,8 @@ static int vhost_worker(void *data)
 			break;
 		}
 
-		node = llist_del_all(&dev->work_list);
-		if (!node)
+		if (!vhost_run_work_list(dev, &dev->work_list))
 			schedule();
-
-		node = llist_reverse_order(node);
-		/* make sure flag is seen after deletion */
-		smp_wmb();
-		llist_for_each_entry_safe(work, work_next, node, node) {
-			clear_bit(VHOST_WORK_QUEUED, &work->flags);
-			__set_current_state(TASK_RUNNING);
-			kcov_remote_start_common(dev->kcov_handle);
-			work->fn(work);
-			kcov_remote_stop();
-			if (need_resched())
-				schedule();
-		}
 	}
 	kthread_unuse_mm(dev->mm);
 	return 0;
@@ -480,6 +524,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->iotlb = NULL;
 	dev->mm = NULL;
 	dev->worker = NULL;
+	dev->wq = NULL;
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
@@ -497,12 +542,15 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vq->log = NULL;
 		vq->indirect = NULL;
 		vq->heads = NULL;
+		vq->cpu = -1;
 		vq->dev = dev;
+		init_llist_head(&vq->work_list);
+		INIT_WORK(&vq->work, vhost_vq_work);
 		mutex_init(&vq->mutex);
 		vhost_vq_reset(dev, vq);
 		if (vq->handle_kick)
 			vhost_poll_init(&vq->poll, vq->handle_kick,
-					EPOLLIN, dev);
+					EPOLLIN, dev, vq);
 	}
 }
 EXPORT_SYMBOL_GPL(vhost_dev_init);
@@ -1572,6 +1620,39 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
 
 	return r;
 }
+
+static long vhost_vring_set_cpu(struct vhost_dev *d, struct vhost_virtqueue *vq,
+				void __user *argp)
+{
+	struct vhost_vring_state s;
+	int ret = 0;
+
+	if (vq->private_data)
+		return -EBUSY;
+
+	if (copy_from_user(&s, argp, sizeof s))
+		return -EFAULT;
+
+	if (s.num == -1) {
+		vq->cpu = s.num;
+		return 0;
+	}
+
+	if (s.num >= nr_cpu_ids)
+		return -EINVAL;
+
+	if (!d->ops || !d->ops->get_workqueue)
+		return -EINVAL;
+
+	if (!d->wq)
+		d->wq = d->ops->get_workqueue();
+	if (!d->wq)
+		return -EINVAL;
+
+	vq->cpu = s.num;
+	return ret;
+}
+
 long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 {
 	struct file *eventfp, *filep = NULL;
@@ -1601,6 +1682,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	mutex_lock(&vq->mutex);
 
 	switch (ioctl) {
+	case VHOST_SET_VRING_CPU:
+		r = vhost_vring_set_cpu(d, vq, argp);
+		break;
 	case VHOST_SET_VRING_BASE:
 		/* Moving base with an active backend?
 		 * You don't want to do that. */
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 64fa638..28ff4a2 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -26,7 +26,6 @@ struct vhost_work {
 };
 
 /* Poll a file (eventfd or socket) */
-/* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
 	poll_table		table;
 	wait_queue_head_t	*wqh;
@@ -34,14 +33,17 @@ struct vhost_poll {
 	struct vhost_work	work;
 	__poll_t		mask;
 	struct vhost_dev	*dev;
+	struct vhost_virtqueue	*vq;
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev);
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq);
 int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
@@ -82,6 +84,9 @@ struct vhost_virtqueue {
 	struct eventfd_ctx *error_ctx;
 	struct eventfd_ctx *log_ctx;
 
+	unsigned int cpu;
+	struct work_struct work;
+	struct llist_head work_list;
 	struct vhost_poll poll;
 
 	/* The routine to call when the Guest pings us, or timeout. */
@@ -145,6 +150,11 @@ struct vhost_msg_node {
 
 struct vhost_dev_ops {
 	int (*msg_handler)(struct vhost_dev *dev, struct vhost_iotlb_msg *msg);
+	/*
+	 * If the driver supports the VHOST_SET_VRING_CPU ioctl this must
+	 * return the workqueue to use.
+	 */ 
+	struct workqueue_struct *(*get_workqueue)(void);
 };
 
 struct vhost_dev {
@@ -166,6 +176,7 @@ struct vhost_dev {
 	int byte_weight;
 	u64 kcov_handle;
 	bool use_worker;
+	struct workqueue_struct *wq;
 	struct vhost_dev_ops *ops;
 };
 
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860..78b31d8 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -70,6 +70,11 @@
 #define VHOST_VRING_BIG_ENDIAN 1
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+/* Bind a vring to a CPU. vhost_vring_state.num is -1 then the default worker
+ * and it's cgroup will be used. If vhost_vring_state.num != -1, the vring will
+ * be bound to the CPU in vhost_vring_state.num.
+ */
+#define VHOST_SET_VRING_CPU _IOW(VHOST_VIRTIO, 0x15, struct vhost_vring_state)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
-- 
1.8.3.1

