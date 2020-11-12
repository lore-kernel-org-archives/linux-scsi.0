Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7860C2D0E4
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8035421D7F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NP+fCVp4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgKLXTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:19:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgKLXTl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 18:19:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACN9xN4118625;
        Thu, 12 Nov 2020 23:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=b1noA82s4lwdvoXPWkaGQYxPEk5dqmgZwWX7+0ydmPc=;
 b=NP+fCVp4+mvBbK+p5GRrKz1bK2xdV0OhS6f0H32QrQz0crX6rnGooHzHWK6AE9z7ZtzP
 3BRlbOg7usCWSKAlFS271Bwcr7nc0hQb7wCnn/JrPBQIce6xl9dBIbYNfnBZYxWFyiKh
 H67yVU1vmzXtIDg6JovPd27d23QFRobywtgSBbEEii8Fn0HNJDr2yvCyuLOd9fHfArd+
 Rs8xOFCtz2jiCgcAtqV7r1NYyPqkI/ts9us3VFd1AwRxtgS+EMu/i40Un1QpW8OadVYz
 zq+Y+BF4K00TtShV2KuMfa2dtOhwUNOIyVPXuAMxXInOilUDnGgugF+6EDzfFKJUfkJs VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34nkhm83va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:19:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACNBGrk101388;
        Thu, 12 Nov 2020 23:19:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34rt56umm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:19:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACNJQ4A026454;
        Thu, 12 Nov 2020 23:19:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:19:25 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 04/10] vhost: support multiple worker threads
Date:   Thu, 12 Nov 2020 17:19:04 -0600
Message-Id: <1605223150-10888-6-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=2 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=2 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a prep patch to support multiple vhost worker threads per vhost
dev. This patch converts the code that had assumed a single worker
thread by:

1. Moving worker related fields to a new struct vhost_worker.
2. Converting vhost.c code to use the new struct and assume we will
have an array of workers.
3. It also exports 2 helper functions that will be used in the last
patch when vhost-scsi is converted to use this new functionality.

Why do we need multiple worker threads?

The admin can set_num_queues > 1 and the guest OS will run in
multiqueue mode where, depending on the num_queues, you might get
a queue per CPU. The layers below vhost-scsi are also doing
multiqueue. So, while vhost-scsi will create num_queue vqs every
IO on every CPU we are using has to be sent from and complete
on this one thread on one CPU and can't fully utlize the multiple
queues above and below us.

With the null_blk driver we max out at 360K IOPs when doing a random
workload like:

fio --direct=1 --rw=randrw --bs=4k --ioengine=libaio \
--iodepth=VQ_QUEUE_DEPTH --numjobs=NUM_VQS --filename  /dev/sdXYZ

where NUM_VQS gets up to 8 (number of cores per numa node on my system)
and VQ_QUEUE_DEPTH can be anywhere from 32 to 128.

With the patches in this set and the patches to remove the sess_cmd_lock
and execution_lock from lio's IO path in the SCSI tree for 5.11, we are
able to get IOPs from a single LUN up to 700K.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 260 +++++++++++++++++++++++++++++++++++++++-----------
 drivers/vhost/vhost.h |  14 ++-
 2 files changed, 217 insertions(+), 57 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 78d9535..d229515 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -231,16 +231,47 @@ void vhost_poll_stop(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
-void vhost_work_dev_flush(struct vhost_dev *dev)
+static void vhost_work_queue_on(struct vhost_dev *dev, struct vhost_work *work,
+				int worker_id)
+{
+	if (!dev->num_workers)
+		return;
+
+	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
+		/* We can only add the work to the list after we're
+		 * sure it was not in the list.
+		 * test_and_set_bit() implies a memory barrier.
+		 */
+		llist_add(&work->node, &dev->workers[worker_id]->work_list);
+		wake_up_process(dev->workers[worker_id]->task);
+	}
+}
+
+void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
+{
+	vhost_work_queue_on(dev, work, 0);
+}
+EXPORT_SYMBOL_GPL(vhost_work_queue);
+
+static void vhost_work_flush_on(struct vhost_dev *dev, int worker_id)
 {
 	struct vhost_flush_struct flush;
 
-	if (dev->worker) {
-		init_completion(&flush.wait_event);
-		vhost_work_init(&flush.work, vhost_flush_work);
+	init_completion(&flush.wait_event);
+	vhost_work_init(&flush.work, vhost_flush_work);
+
+	vhost_work_queue_on(dev, &flush.work, worker_id);
+	wait_for_completion(&flush.wait_event);
+}
+
+void vhost_work_dev_flush(struct vhost_dev *dev)
+{
+	int i;
 
-		vhost_work_queue(dev, &flush.work);
-		wait_for_completion(&flush.wait_event);
+	for (i = 0; i < dev->num_workers; i++) {
+		if (!dev->workers[i])
+			continue;
+		vhost_work_flush_on(dev, i);
 	}
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
@@ -253,26 +284,18 @@ void vhost_poll_flush(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
+/* A lockless hint for busy polling code to exit the loop */
+bool vhost_has_work(struct vhost_dev *dev)
 {
-	if (!dev->worker)
-		return;
+	int i;
 
-	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
-		/* We can only add the work to the list after we're
-		 * sure it was not in the list.
-		 * test_and_set_bit() implies a memory barrier.
-		 */
-		llist_add(&work->node, &dev->work_list);
-		wake_up_process(dev->worker);
+	for (i = 0; i < dev->num_workers; i++) {
+		if (dev->workers[i] &&
+		    !llist_empty(&dev->workers[i]->work_list))
+			return true;
 	}
-}
-EXPORT_SYMBOL_GPL(vhost_work_queue);
 
-/* A lockless hint for busy polling code to exit the loop */
-bool vhost_has_work(struct vhost_dev *dev)
-{
-	return !llist_empty(&dev->work_list);
+	return false;
 }
 EXPORT_SYMBOL_GPL(vhost_has_work);
 
@@ -343,7 +366,8 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 
 static int vhost_worker(void *data)
 {
-	struct vhost_dev *dev = data;
+	struct vhost_worker *worker = data;
+	struct vhost_dev *dev = worker->dev;
 	struct vhost_work *work, *work_next;
 	struct llist_node *node;
 
@@ -357,8 +381,7 @@ static int vhost_worker(void *data)
 			__set_current_state(TASK_RUNNING);
 			break;
 		}
-
-		node = llist_del_all(&dev->work_list);
+		node = llist_del_all(&worker->work_list);
 		if (!node)
 			schedule();
 
@@ -481,13 +504,13 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->umem = NULL;
 	dev->iotlb = NULL;
 	dev->mm = NULL;
-	dev->worker = NULL;
+	dev->workers = NULL;
+	dev->num_workers = 0;
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
 	dev->use_worker = use_worker;
 	dev->msg_handler = msg_handler;
-	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
 	INIT_LIST_HEAD(&dev->pending_list);
@@ -500,6 +523,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vq->indirect = NULL;
 		vq->heads = NULL;
 		vq->dev = dev;
+		vq->worker_id = 0;
 		mutex_init(&vq->mutex);
 		vhost_vq_reset(dev, vq);
 		if (vq->handle_kick)
@@ -531,14 +555,14 @@ static void vhost_attach_cgroups_work(struct vhost_work *work)
 	s->ret = cgroup_attach_task_all(s->owner, current);
 }
 
-static int vhost_attach_cgroups(struct vhost_dev *dev)
+static int vhost_attach_cgroups_on(struct vhost_dev *dev, int worker_id)
 {
 	struct vhost_attach_cgroups_struct attach;
 
 	attach.owner = current;
 	vhost_work_init(&attach.work, vhost_attach_cgroups_work);
-	vhost_work_queue(dev, &attach.work);
-	vhost_work_dev_flush(dev);
+	vhost_work_queue_on(dev, &attach.work, worker_id);
+	vhost_work_flush_on(dev, worker_id);
 	return attach.ret;
 }
 
@@ -579,10 +603,153 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 	dev->mm = NULL;
 }
 
+static void vhost_worker_free(struct vhost_dev *dev, int worker_id)
+{
+	struct vhost_worker *worker;
+
+	worker = dev->workers[worker_id];
+	WARN_ON(!llist_empty(&worker->work_list));
+	kthread_stop(worker->task);
+	kfree(worker);
+
+	dev->workers[worker_id] = NULL;
+}
+
+void vhost_vq_worker_remove(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+{
+	/*
+	 * vqs may share a worker and so this might have been removed already.
+	 */
+	if (!dev->workers[vq->worker_id])
+		return;
+
+	vhost_worker_free(dev, vq->worker_id);
+	dev->num_workers--;
+
+	vq->worker_id = 0;
+}
+EXPORT_SYMBOL_GPL(vhost_vq_worker_remove);
+
+static void vhost_workers_free(struct vhost_dev *dev)
+{
+	int i;
+
+	if (!dev->workers)
+		return;
+
+	for (i = 0; i < dev->nvqs; i++) {
+		if (!dev->num_workers)
+			break;
+		vhost_vq_worker_remove(dev, dev->vqs[i]);
+	}
+
+	kfree(dev->workers);
+	dev->workers = NULL;
+}
+
+static int vhost_worker_create(struct vhost_dev *dev, int worker_id)
+{
+	struct vhost_worker *worker;
+	struct task_struct *task;
+	int ret;
+
+	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
+	if (!worker)
+		return -ENOMEM;
+
+	init_llist_head(&worker->work_list);
+	worker->dev = dev;
+
+	task = kthread_create(vhost_worker, worker, "vhost-%d", current->pid);
+	if (IS_ERR(task)) {
+		ret = PTR_ERR(task);
+		goto free_worker;
+	}
+
+	dev->workers[worker_id] = worker;
+	worker->task = task;
+	wake_up_process(task); /* avoid contributing to loadavg */
+	return 0;
+
+free_worker:
+	kfree(worker);
+	return ret;
+}
+
+/**
+ * vhost_vq_worker_add - create a new worker and add it to workers[]
+ * @dev: vhost device
+ * @vq: optional virtqueue to bind worker to.
+ *
+ * Caller must have the device mutex and have stopped operations that
+ * can access the workers array.
+ */
+int vhost_vq_worker_add(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+{
+	struct mm_struct *mm;
+	bool owner_match = true;
+	int err, worker_id;
+
+	if (vq && vq->worker_id)
+		return -EINVAL;
+
+	if (vhost_dev_has_owner(dev)) {
+		mm = get_task_mm(current);
+		if (mm != dev->mm)
+			owner_match = false;
+		mmput(mm);
+		if (!owner_match)
+			return -EBUSY;
+	}
+
+	worker_id = dev->num_workers;
+	err = vhost_worker_create(dev, worker_id);
+	if (err)
+		return -ENOMEM;
+	dev->num_workers++;
+
+	err = vhost_attach_cgroups_on(dev, worker_id);
+	if (err)
+		goto free_worker;
+
+	if (vq)
+		vq->worker_id = worker_id;
+	return 0;
+
+free_worker:
+	dev->num_workers--;
+	vhost_worker_free(dev, worker_id);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vhost_vq_worker_add);
+
+static int vhost_workers_create(struct vhost_dev *dev)
+{
+	int err;
+
+	dev->workers = kcalloc(dev->nvqs, sizeof(struct vhost_worker *),
+			       GFP_KERNEL);
+	if (!dev->workers)
+		return -ENOMEM;
+	/*
+	 * All drivers that set use_worker=true use at least one worker that
+	 * may be bound to multiple vqs. Drivers like vhost-scsi may override
+	 * this later.
+	 */
+	err = vhost_vq_worker_add(dev, NULL);
+	if (err)
+		goto free_workers;
+	return 0;
+
+free_workers:
+	kfree(dev->workers);
+	dev->workers = NULL;
+	return err;
+}
+
 /* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
-	struct task_struct *worker;
 	int err;
 
 	/* Is there an owner already? */
@@ -595,31 +762,18 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	dev->kcov_handle = kcov_common_handle();
 	if (dev->use_worker) {
-		worker = kthread_create(vhost_worker, dev,
-					"vhost-%d", current->pid);
-		if (IS_ERR(worker)) {
-			err = PTR_ERR(worker);
-			goto err_worker;
-		}
-
-		dev->worker = worker;
-		wake_up_process(worker); /* avoid contributing to loadavg */
-
-		err = vhost_attach_cgroups(dev);
+		err = vhost_workers_create(dev);
 		if (err)
-			goto err_cgroup;
+			goto err_worker;
 	}
 
 	err = vhost_dev_alloc_iovecs(dev);
 	if (err)
-		goto err_cgroup;
+		goto err_iovecs;
 
 	return 0;
-err_cgroup:
-	if (dev->worker) {
-		kthread_stop(dev->worker);
-		dev->worker = NULL;
-	}
+err_iovecs:
+	vhost_workers_free(dev);
 err_worker:
 	vhost_detach_mm(dev);
 	dev->kcov_handle = 0;
@@ -712,12 +866,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	dev->iotlb = NULL;
 	vhost_clear_msg(dev);
 	wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
-	WARN_ON(!llist_empty(&dev->work_list));
-	if (dev->worker) {
-		kthread_stop(dev->worker);
-		dev->worker = NULL;
-		dev->kcov_handle = 0;
-	}
+	vhost_workers_free(dev);
+	dev->kcov_handle = 0;
 	vhost_detach_mm(dev);
 }
 EXPORT_SYMBOL_GPL(vhost_dev_cleanup);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 575c818..f334e90 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -16,6 +16,7 @@
 #include <linux/irqbypass.h>
 
 struct vhost_work;
+struct vhost_virtqueue;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
 
 #define VHOST_WORK_QUEUED 1
@@ -25,6 +26,12 @@ struct vhost_work {
 	unsigned long		  flags;
 };
 
+struct vhost_worker {
+	struct task_struct *task;
+	struct llist_head work_list;
+	struct vhost_dev *dev;
+};
+
 /* Poll a file (eventfd or socket) */
 /* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
@@ -39,6 +46,8 @@ struct vhost_poll {
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
+int vhost_vq_worker_add(struct vhost_dev *dev, struct vhost_virtqueue *vq);
+void vhost_vq_worker_remove(struct vhost_dev *dev, struct vhost_virtqueue *vq);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev);
@@ -84,6 +93,7 @@ struct vhost_virtqueue {
 
 	struct vhost_poll poll;
 
+	int worker_id;
 	/* The routine to call when the Guest pings us, or timeout. */
 	vhost_work_fn_t handle_kick;
 
@@ -149,8 +159,8 @@ struct vhost_dev {
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-	struct llist_head work_list;
-	struct task_struct *worker;
+	struct vhost_worker **workers;
+	int num_workers;
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
 	spinlock_t iotlb_lock;
-- 
1.8.3.1

