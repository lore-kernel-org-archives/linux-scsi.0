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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C38FC4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A93282087D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hIMHGdof"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgJGUz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:55:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43316 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbgJGUz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:55:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097Knj6O038420;
        Wed, 7 Oct 2020 20:55:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=8f1iB9F7SEnv/Y0diwaXj6AGiOaAb9Dd4CzmiVH4x3c=;
 b=hIMHGdofsO5iSl23VVzTsN4yLZwCjGdB4pQLSR6+dQIr71DbYm4b6pNz1XsCjEAm+yar
 I4hjCK1803WW092B1gVQ1zNoz2jKnKieJlWtFvJxm1ijxqeSF2rz5yquwgW8rESujyEL
 k81P6DTodtRS87+ofbHcoLxr6U4nK2H35iv+wOMZaEjv5GhNHoV+bkGGcjAyf5Jd+Fnf
 GA0RaMaHjTuEoVAtOKtpjH7J+dRUCF4h54NjmVdV2KqlVcROlbdgi7eLYG3Nyn8qNzZb
 KN0MPiJHo9j97E5RLVGqraYJAsu4QfB+a+6EuqUQIacen6jAGlckp+bbtaNMmHX+/xk3 lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxn475d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 20:55:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KpL7c166351;
        Wed, 7 Oct 2020 20:55:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vpyux3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 20:55:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097KtKe1009066;
        Wed, 7 Oct 2020 20:55:20 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 13:55:19 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 06/16] vhost: support delayed vq creation
Date:   Wed,  7 Oct 2020 15:54:51 -0500
Message-Id: <1602104101-5592-7-git-send-email-michael.christie@oracle.com>
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

This allows vq creation to be done when it's first accessed by
userspace. vhost-scsi doesn't know how many queues the user requested
until they are first setup, and we don't want to allocate resources
like the iovecs for 128 vqs when we are only using 1 or 2 most of the
time. In the next pathces, vhost-scsi will also switch to preallocating
cmds per vq instead of per lio session and we don't want to allocate
them for 127 extra vqs if they are not in use.

With this patch when a driver calls vhost_dev_init they pass in the
number of vqs that they know they need and the max they can support.
This patch has all the drivers pass in the same value for both the
initial number of vqs and the max. The next patch will convert scsi.
The other drivers like net/vsock have their vqs hard coded in the
kernel or setup/discovered via other methods like with vdpa.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   |  2 +-
 drivers/vhost/scsi.c  |  4 +--
 drivers/vhost/test.c  |  5 ++--
 drivers/vhost/vdpa.c  |  2 +-
 drivers/vhost/vhost.c | 71 ++++++++++++++++++++++++++++++++++-----------------
 drivers/vhost/vhost.h |  7 +++--
 drivers/vhost/vsock.c | 11 ++++----
 7 files changed, 66 insertions(+), 36 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index fd30b53..fce46f0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1316,7 +1316,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].rx_ring = NULL;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
-	if (vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
+	if (vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX, VHOST_NET_VQ_MAX,
 			   UIO_MAXIOV + VHOST_NET_BATCH,
 			   VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
 			   NULL))
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 63ba363..5d412f1 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1632,8 +1632,8 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	if (vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
-			   VHOST_SCSI_WEIGHT, 0, true, NULL))
+	if (vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, VHOST_SCSI_MAX_VQ,
+			   UIO_MAXIOV, VHOST_SCSI_WEIGHT, 0, true, NULL))
 		goto err_dev_init;
 
 	vhost_scsi_init_inflight(vs, NULL);
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index c255ae5..9d2bfa3 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -119,8 +119,9 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	if (vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
-			   VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL)
+	if (vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, VHOST_TEST_VQ_MAX,
+			   UIO_MAXIOV, VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT,
+			   true, NULL)
 		goto err_dev_init;
 
 	f->private_data = n;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index d413ceb..9507ebb 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -817,7 +817,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 		vqs[i] = &v->vqs[i];
 		vqs[i]->handle_kick = handle_vq_kick;
 	}
-	if (vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
+	if (vhost_dev_init(dev, vqs, nvqs, nvqs, 0, 0, 0, false,
 			   vhost_vdpa_process_iotlb_msg))
 		goto err_dev_init;
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d6af5a4..1507400 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -294,7 +294,7 @@ static void vhost_vq_meta_reset(struct vhost_dev *d)
 {
 	int i;
 
-	for (i = 0; i < d->nvqs; ++i)
+	for (i = 0; i < d->max_nvqs; ++i)
 		__vhost_vq_meta_reset(d->vqs[i]);
 }
 
@@ -332,6 +332,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->busyloop_timeout = 0;
 	vq->umem = NULL;
 	vq->iotlb = NULL;
+	vq->initialized = false;
 	vhost_vring_call_reset(&vq->call_ctx);
 	__vhost_vq_meta_reset(vq);
 }
@@ -412,7 +413,7 @@ static void vhost_dev_free_iovecs(struct vhost_dev *dev)
 {
 	int i;
 
-	for (i = 0; i < dev->nvqs; ++i)
+	for (i = 0; i < dev->max_nvqs; ++i)
 		vhost_vq_free_iovecs(dev->vqs[i]);
 }
 
@@ -457,7 +458,7 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
 	return sizeof(*vq->desc) * num;
 }
 
-static int vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+static void __vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
 	vq->log = NULL;
 	vq->indirect = NULL;
@@ -468,12 +469,29 @@ static int vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 
 	if (vq->handle_kick)
 		vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev);
+}
+
+static int vhost_vq_init(struct vhost_dev *dev, int vq_idx)
+{
+	struct vhost_virtqueue *vq;
+	int ret;
+
+	if (vq_idx >= dev->max_nvqs)
+		return -ENOBUFS;
+
+	vq = dev->vqs[vq_idx];
+	__vhost_vq_init(dev, vq);
+	ret = vhost_vq_alloc_iovecs(dev, vq);
+	if (ret)
+		return ret;
 
-	return vhost_vq_alloc_iovecs(dev, vq);
+	vq->initialized = true;
+	dev->nvqs++;
+	return 0;
 }
 
 int vhost_dev_init(struct vhost_dev *dev,
-		   struct vhost_virtqueue **vqs, int nvqs,
+		   struct vhost_virtqueue **vqs, int nvqs, int max_nvqs,
 		   int iov_limit, int weight, int byte_weight,
 		   bool use_worker,
 		   int (*msg_handler)(struct vhost_dev *dev,
@@ -482,7 +500,8 @@ int vhost_dev_init(struct vhost_dev *dev,
 	int i;
 
 	dev->vqs = vqs;
-	dev->nvqs = nvqs;
+	dev->nvqs = 0;
+	dev->max_nvqs = max_nvqs;
 	mutex_init(&dev->mutex);
 	dev->log_ctx = NULL;
 	dev->umem = NULL;
@@ -500,12 +519,15 @@ int vhost_dev_init(struct vhost_dev *dev,
 	INIT_LIST_HEAD(&dev->pending_list);
 	spin_lock_init(&dev->iotlb_lock);
 
-
-	for (i = 0; i < dev->nvqs; ++i) {
-		if (vhost_vq_init(dev, dev->vqs[i]))
+	for (i = 0; i < nvqs; ++i) {
+		if (vhost_vq_init(dev, i))
 			goto err_vq_init;
 	}
 
+	for (; i < dev->max_nvqs; ++i)
+		/* Just prep/clear the fields and set initialized=false */
+		__vhost_vq_init(dev, dev->vqs[i]);
+
 	return 0;
 
 err_vq_init:
@@ -653,7 +675,7 @@ void vhost_dev_reset_owner(struct vhost_dev *dev, struct vhost_iotlb *umem)
 	/* We don't need VQ locks below since vhost_dev_cleanup makes sure
 	 * VQs aren't running.
 	 */
-	for (i = 0; i < dev->nvqs; ++i)
+	for (i = 0; i < dev->max_nvqs; ++i)
 		dev->vqs[i]->umem = umem;
 }
 EXPORT_SYMBOL_GPL(vhost_dev_reset_owner);
@@ -662,7 +684,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
 {
 	int i;
 
-	for (i = 0; i < dev->nvqs; ++i) {
+	for (i = 0; i < dev->max_nvqs; ++i) {
 		if (dev->vqs[i]->kick && dev->vqs[i]->handle_kick) {
 			vhost_poll_stop(&dev->vqs[i]->poll);
 			vhost_poll_flush(&dev->vqs[i]->poll);
@@ -694,7 +716,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 {
 	int i;
 
-	for (i = 0; i < dev->nvqs; ++i) {
+	for (i = 0; i < dev->max_nvqs; ++i) {
 		if (dev->vqs[i]->error_ctx)
 			eventfd_ctx_put(dev->vqs[i]->error_ctx);
 		if (dev->vqs[i]->kick)
@@ -788,7 +810,7 @@ static bool memory_access_ok(struct vhost_dev *d, struct vhost_iotlb *umem,
 {
 	int i;
 
-	for (i = 0; i < d->nvqs; ++i) {
+	for (i = 0; i < d->max_nvqs; ++i) {
 		bool ok;
 		bool log;
 
@@ -1000,14 +1022,14 @@ static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
 static void vhost_dev_lock_vqs(struct vhost_dev *d)
 {
 	int i = 0;
-	for (i = 0; i < d->nvqs; ++i)
+	for (i = 0; i < d->max_nvqs; ++i)
 		mutex_lock_nested(&d->vqs[i]->mutex, i);
 }
 
 static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 {
 	int i = 0;
-	for (i = 0; i < d->nvqs; ++i)
+	for (i = 0; i < d->max_nvqs; ++i)
 		mutex_unlock(&d->vqs[i]->mutex);
 }
 
@@ -1463,7 +1485,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 	d->umem = newumem;
 
 	/* All memory accesses are done under some VQ mutex. */
-	for (i = 0; i < d->nvqs; ++i) {
+	for (i = 0; i < d->max_nvqs; ++i) {
 		mutex_lock(&d->vqs[i]->mutex);
 		d->vqs[i]->umem = newumem;
 		mutex_unlock(&d->vqs[i]->mutex);
@@ -1591,11 +1613,14 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	r = get_user(idx, idxp);
 	if (r < 0)
 		return r;
-	if (idx >= d->nvqs)
-		return -ENOBUFS;
 
-	idx = array_index_nospec(idx, d->nvqs);
+	idx = array_index_nospec(idx, d->max_nvqs);
 	vq = d->vqs[idx];
+	if (!vq->initialized) {
+		r = vhost_vq_init(d, idx);
+		if (r)
+			return r;
+	}
 
 	if (ioctl == VHOST_SET_VRING_NUM ||
 	    ioctl == VHOST_SET_VRING_ADDR) {
@@ -1727,7 +1752,7 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled)
 	oiotlb = d->iotlb;
 	d->iotlb = niotlb;
 
-	for (i = 0; i < d->nvqs; ++i) {
+	for (i = 0; i < d->max_nvqs; ++i) {
 		struct vhost_virtqueue *vq = d->vqs[i];
 
 		mutex_lock(&vq->mutex);
@@ -1774,7 +1799,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 			r = -EFAULT;
 			break;
 		}
-		for (i = 0; i < d->nvqs; ++i) {
+		for (i = 0; i < d->max_nvqs; ++i) {
 			struct vhost_virtqueue *vq;
 			void __user *base = (void __user *)(unsigned long)p;
 			vq = d->vqs[i];
@@ -1797,7 +1822,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 			break;
 		}
 		swap(ctx, d->log_ctx);
-		for (i = 0; i < d->nvqs; ++i) {
+		for (i = 0; i < d->max_nvqs; ++i) {
 			mutex_lock(&d->vqs[i]->mutex);
 			d->vqs[i]->log_ctx = d->log_ctx;
 			mutex_unlock(&d->vqs[i]->mutex);
@@ -2612,7 +2637,7 @@ void vhost_set_backend_features(struct vhost_dev *dev, u64 features)
 	int i;
 
 	mutex_lock(&dev->mutex);
-	for (i = 0; i < dev->nvqs; ++i) {
+	for (i = 0; i < dev->max_nvqs; ++i) {
 		vq = dev->vqs[i];
 		mutex_lock(&vq->mutex);
 		vq->acked_backend_features = features;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index a053318..2c6473e 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -132,6 +132,8 @@ struct vhost_virtqueue {
 	bool user_be;
 #endif
 	u32 busyloop_timeout;
+
+	bool initialized;
 };
 
 struct vhost_msg_node {
@@ -148,6 +150,7 @@ struct vhost_dev {
 	struct mutex mutex;
 	struct vhost_virtqueue **vqs;
 	int nvqs;
+	int max_nvqs;
 	struct eventfd_ctx *log_ctx;
 	struct llist_head work_list;
 	struct task_struct *worker;
@@ -168,8 +171,8 @@ struct vhost_dev {
 
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 int vhost_dev_init(struct vhost_dev *dev, struct vhost_virtqueue **vqs,
-		   int nvqs, int iov_limit, int weight, int byte_weight,
-		   bool use_worker,
+		   int nvqs, int max_nvqs, int iov_limit, int weight,
+		   int byte_weight, bool use_worker,
 		   int (*msg_handler)(struct vhost_dev *dev,
 				      struct vhost_iotlb_msg *msg));
 long vhost_dev_set_owner(struct vhost_dev *dev);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index a1a35e1..9200868 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -606,7 +606,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 {
 	struct vhost_virtqueue **vqs;
 	struct vhost_vsock *vsock;
-	int ret;
+	int ret, nvqs;
 
 	/* This struct is large and allocation could fail, fall back to vmalloc
 	 * if there is no other way.
@@ -615,7 +615,8 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	if (!vsock)
 		return -ENOMEM;
 
-	vqs = kmalloc_array(ARRAY_SIZE(vsock->vqs), sizeof(*vqs), GFP_KERNEL);
+	nvqs = ARRAY_SIZE(vsock->vqs);
+	vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
 		ret = -ENOMEM;
 		goto out;
@@ -630,9 +631,9 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
 
-	if (vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
-			   UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
-			   VHOST_VSOCK_WEIGHT, true, NULL))
+	if (vhost_dev_init(&vsock->dev, vqs, nvqs, nvqs, UIO_MAXIOV,
+			   VHOST_VSOCK_PKT_WEIGHT, VHOST_VSOCK_WEIGHT, true,
+			   NULL))
 		goto err_dev_init;
 
 	file->private_data = vsock;
-- 
1.8.3.1

