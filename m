Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750CEC4727F
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 318722083B
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:57:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eiDBb5rD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgJGU5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:57:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36572 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgJGU5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:57:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KoGb3113298;
        Wed, 7 Oct 2020 20:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=kEsw8MaL3Rqz6MCZK7TzqKzYFxtra7l/p0GyZvcJHqk=;
 b=eiDBb5rDn8G10xYB++6+IRtC90KDHKs0Gi52ZEO43BPfkmVXy8UOYOqib06imEo8kPiT
 IiVqYi1eduIP8liSZY3MZey7WgKFycYs4CAkVLf7ky0kw8zaJyDqEp483XY9HW6MlE/+
 9555/SwKq2F5mRrOYMIhNyufLLomQ+pNPac4WDQT39f9E2NVviC5OKh5WGk6BzXCfWyv
 k9jA8g8T4YHhWoStsqhZ/0UTl2aSAuQlmRmjPXDALsChDZBQTSF7rBcyYnaRKIyvi9az
 WZroGbkj3mftb8ojyZ0oX/I0iU3whX880UotCEQTfZPHagSDk2aOwBUHYiL7EF7mlof7 oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34scyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 20:57:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097Kor1g125510;
        Wed, 7 Oct 2020 20:55:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3410k03uu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 20:55:24 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097KtNmt005660;
        Wed, 7 Oct 2020 20:55:23 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 13:55:23 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 12/16] vhost: support multiple worker threads
Date:   Wed,  7 Oct 2020 15:54:57 -0500
Message-Id: <1602104101-5592-13-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=2 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=2 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a prep patch to support multiple vhost worker threads per vhost
dev. This patch converts the code that had assumed a single worker
thread by:

1. Moving worker related fields to a new struct vhost_worker.
2. Converting vhost.c code to use the new struct and assume we will
have an array of workers.
3. It also exports a helper function that will be used in the last
patch when vhost-scsi is converted to use this new functionality.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 232 +++++++++++++++++++++++++++++++++++++++-----------
 drivers/vhost/vhost.h |  12 ++-
 2 files changed, 190 insertions(+), 54 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 1507400..e46b39e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -231,18 +231,48 @@ void vhost_poll_stop(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
-void vhost_work_dev_flush(struct vhost_dev *dev)
+static void vhost_work_queue_on(struct vhost_dev *dev, struct vhost_work *work,
+				int worker_id)
+{
+	if (!dev->workers)
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
+	if (dev->workers) {
 		init_completion(&flush.wait_event);
 		vhost_work_init(&flush.work, vhost_flush_work);
 
-		vhost_work_queue(dev, &flush.work);
+		vhost_work_queue_on(dev, &flush.work, worker_id);
 		wait_for_completion(&flush.wait_event);
 	}
 }
+
+void vhost_work_dev_flush(struct vhost_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->num_workers; i++)
+		vhost_work_flush_on(dev, i);
+}
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
 /* Flush any work that has been scheduled. When calling this, don't hold any
@@ -253,26 +283,20 @@ void vhost_poll_flush(struct vhost_poll *poll)
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
+	if (!dev->workers)
+		return false;
+
+	for (i = 0; i < dev->num_workers; i++) {
+		if (!llist_empty(&dev->workers[i]->work_list))
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
 
@@ -339,7 +363,8 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 
 static int vhost_worker(void *data)
 {
-	struct vhost_dev *dev = data;
+	struct vhost_worker *worker = data;
+	struct vhost_dev *dev = worker->dev;
 	struct vhost_work *work, *work_next;
 	struct llist_node *node;
 
@@ -353,8 +378,7 @@ static int vhost_worker(void *data)
 			__set_current_state(TASK_RUNNING);
 			break;
 		}
-
-		node = llist_del_all(&dev->work_list);
+		node = llist_del_all(&worker->work_list);
 		if (!node)
 			schedule();
 
@@ -507,13 +531,13 @@ int vhost_dev_init(struct vhost_dev *dev,
 	dev->umem = NULL;
 	dev->iotlb = NULL;
 	dev->mm = NULL;
-	dev->worker = NULL;
+	dev->workers = NULL;
+	dev->num_workers = 0;
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
-	dev->byte_weight = byte_weight;
 	dev->use_worker = use_worker;
+	dev->byte_weight = byte_weight;
 	dev->msg_handler = msg_handler;
-	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
 	INIT_LIST_HEAD(&dev->pending_list);
@@ -559,16 +583,28 @@ static void vhost_attach_cgroups_work(struct vhost_work *work)
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
+static int vhost_attach_cgroups(struct vhost_dev *dev, int first_worker)
+{
+	int i, ret = 0;
+
+	for (i = first_worker; i < dev->num_workers; i++) {
+		ret = vhost_attach_cgroups_on(dev, i);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
 
 /* Caller should have device mutex */
 bool vhost_dev_has_owner(struct vhost_dev *dev)
@@ -607,10 +643,117 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 	dev->mm = NULL;
 }
 
+static void vhost_workers_free(struct vhost_dev *dev)
+{
+	struct vhost_worker *worker;
+	int i;
+
+	if (!dev->workers)
+		return;
+
+	for (i = 0; i < dev->num_workers; i++) {
+		worker = dev->workers[i];
+
+		WARN_ON(!llist_empty(&worker->work_list));
+		kthread_stop(worker->task);
+		kfree(worker);
+	}
+
+	kfree(dev->workers);
+	dev->workers = NULL;
+	dev->num_workers = 0;
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
+ * vhost_workers_create - create vhost workers and attach to cgroup
+ * @dev: vhost device
+ * @new_num_workers: the total number of workers we want after this returns
+ *
+ * Caller must have the device mutex and have stopped operations that
+ * can access the workers array.
+ */
+int vhost_workers_create(struct vhost_dev *dev, int new_num_workers)
+{
+	struct vhost_worker **new_workers;
+	struct mm_struct *mm;
+	bool owner_match = true;
+	int i, err, start;
+
+	if (new_num_workers == dev->num_workers)
+		return 0;
+
+	if (new_num_workers < dev->num_workers)
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
+	new_workers = krealloc(dev->workers, new_num_workers * sizeof(*new_workers),
+			       GFP_KERNEL);
+	if (!new_workers) {
+		err = -ENOMEM;
+		goto free_workers;
+	}
+	dev->workers = new_workers;
+
+	start = dev->num_workers;
+	for (i = start; i < new_num_workers; i++) {
+		err = vhost_worker_create(dev, i);
+		if (err)
+			goto free_workers;
+		dev->num_workers++;
+	}
+
+	err = vhost_attach_cgroups(dev, start);
+	if (err)
+		goto free_workers;
+
+	return 0;
+
+free_workers:
+	vhost_workers_free(dev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vhost_workers_create);
+
 /* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
-	struct task_struct *worker;
 	int err;
 
 	/* Is there an owner already? */
@@ -623,27 +766,16 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
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
+		/*
+		 * All drivers that set use_worker=true, use at least one
+		 * worker. Drivers like vhost-scsi may override this later.
+		 */
+		err = vhost_workers_create(dev, 1);
 		if (err)
-			goto err_cgroup;
+			goto err_worker;
 	}
 
 	return 0;
-err_cgroup:
-	if (dev->worker) {
-		kthread_stop(dev->worker);
-		dev->worker = NULL;
-	}
 err_worker:
 	vhost_detach_mm(dev);
 	dev->kcov_handle = 0;
@@ -736,12 +868,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
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
index 2c6473e..a91be8a 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -25,6 +25,12 @@ struct vhost_work {
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
@@ -39,6 +45,7 @@ struct vhost_poll {
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
+int vhost_workers_create(struct vhost_dev *dev, int new_num_workers);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev);
@@ -152,8 +159,8 @@ struct vhost_dev {
 	int nvqs;
 	int max_nvqs;
 	struct eventfd_ctx *log_ctx;
-	struct llist_head work_list;
-	struct task_struct *worker;
+	struct vhost_worker **workers;
+	int num_workers;
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
 	spinlock_t iotlb_lock;
@@ -175,6 +182,7 @@ int vhost_dev_init(struct vhost_dev *dev, struct vhost_virtqueue **vqs,
 		   int byte_weight, bool use_worker,
 		   int (*msg_handler)(struct vhost_dev *dev,
 				      struct vhost_iotlb_msg *msg));
+int vhost_vq_set_worker(struct vhost_virtqueue *vq, int worker_id);
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
-- 
1.8.3.1

