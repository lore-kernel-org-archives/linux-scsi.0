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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75F0C4727E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56A7B20872
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lEgeUPQK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgJGUzd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:55:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgJGUzb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:55:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KnUFr038310;
        Wed, 7 Oct 2020 20:55:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=nMSyPzjtY25TB3KiQcKSoQOhg9Eo04FswU4uDxvkkc0=;
 b=lEgeUPQKGy0cbXFcG3j+dI0sxbw5tMb65C2ZXgRv8cFvMmbbVDuAZ0P4Yr+k/BNGGtsp
 lcVcBTVnqXETrM3q2zoORGoRQIgk/PS3wFHIPblNlfterwRQlBBZWj/7efx2tAhcYVfV
 rQt2W5HvIAIU1S9hjwlPnQxjh0Acl3yLxB1moq5c4PgVddNnTtZwlG6rOgHZfyk0wxE4
 h6Y4to0lby4jmHwM4MLr8plc9B9BU9QOabolz26YyErh2VcHXK58ARkOK9ff8SOqBysp
 GGOfT7VZ1GGdFzNndnaPe2CbIPB1pPlovFqwlDCCNO27ujT4nfJsXYzDPpsuEKwCpbQE ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxn475t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 20:55:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KpLYp166298;
        Wed, 7 Oct 2020 20:55:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33y2vpyv3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 20:55:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097KtOin021079;
        Wed, 7 Oct 2020 20:55:24 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 13:55:24 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 14/16] vhost: poll support support multiple workers
Date:   Wed,  7 Oct 2020 15:54:59 -0500
Message-Id: <1602104101-5592-15-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=2 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=2 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The final patches are going to have vhost scsi create a vhost worker
per IO vq. This patch converts the poll code to poll and queue work on
the worker that is tied to the vq (in this patch we maintain the old
behavior where all vqs use a single worker).

For drivers that do not convert over to the multiple worker support
or for the case where the user just does not want to allocate the
resources then we maintain support for the single worker case.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   |  6 ++++--
 drivers/vhost/vhost.c | 25 ++++++++++++++++++++++---
 drivers/vhost/vhost.h |  9 +++++++--
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index fce46f0..a316ed0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1322,8 +1322,10 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 			   NULL))
 		goto err_dev_init;
 
-	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
-	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev,
+			vqs[VHOST_NET_VQ_TX]);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev,
+			vqs[VHOST_NET_VQ_RX]);
 
 	f->private_data = n;
 	n->page_frag.page = NULL;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e46b39e..f0038d6 100644
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
@@ -283,6 +285,12 @@ void vhost_poll_flush(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
+{
+	vhost_work_queue_on(vq->dev, work, vq->worker_id);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
+
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_has_work(struct vhost_dev *dev)
 {
@@ -302,7 +310,7 @@ bool vhost_has_work(struct vhost_dev *dev)
 
 void vhost_poll_queue(struct vhost_poll *poll)
 {
-	vhost_work_queue(poll->dev, &poll->work);
+	vhost_vq_work_queue(poll->vq, &poll->work);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_queue);
 
@@ -488,11 +496,12 @@ static void __vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	vq->indirect = NULL;
 	vq->heads = NULL;
 	vq->dev = dev;
+	vq->worker_id = 0;
 	mutex_init(&vq->mutex);
 	vhost_vq_reset(dev, vq);
 
 	if (vq->handle_kick)
-		vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev);
+		vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev, vq);
 }
 
 static int vhost_vq_init(struct vhost_dev *dev, int vq_idx)
@@ -643,6 +652,16 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 	dev->mm = NULL;
 }
 
+int vhost_vq_set_worker(struct vhost_virtqueue *vq, int worker_id)
+{
+	if (vhost_vq_get_backend(vq))
+		return -EBUSY;
+
+	vq->worker_id = worker_id;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vhost_vq_set_worker);
+
 static void vhost_workers_free(struct vhost_dev *dev)
 {
 	struct vhost_worker *worker;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 2bbe85f..6e9643d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -16,6 +16,7 @@
 #include <linux/irqbypass.h>
 
 struct vhost_work;
+struct vhost_virtqueue *vq;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
 
 #define VHOST_WORK_QUEUED 1
@@ -32,7 +33,6 @@ struct vhost_worker {
 };
 
 /* Poll a file (eventfd or socket) */
-/* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
 	poll_table		table;
 	wait_queue_head_t	*wqh;
@@ -40,15 +40,19 @@ struct vhost_poll {
 	struct vhost_work	work;
 	__poll_t		mask;
 	struct vhost_dev	*dev;
+	struct vhost_virtqueue	*vq;
 };
 
+int vhost_vq_set_worker(struct vhost_virtqueue *vq, int worker_id);
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
 int vhost_workers_create(struct vhost_dev *dev, int new_num_workers);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev);
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq);
 int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
@@ -92,6 +96,7 @@ struct vhost_virtqueue {
 
 	struct vhost_poll poll;
 
+	int worker_id;
 	/* The routine to call when the Guest pings us, or timeout. */
 	vhost_work_fn_t handle_kick;
 
-- 
1.8.3.1

