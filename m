Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3DDC55178
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0F3722249
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ljlND7Sx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507566AbgJVAfV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:35:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50980 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507554AbgJVAfU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:35:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0V2De175243;
        Thu, 22 Oct 2020 00:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=qhYe/BL/gqyYuc7vgECQb6usxsig1uae3W+rFQCZVV8=;
 b=ljlND7SxjzjkLerm1O604EU95Lbf68nPvxfz+GVIeis0ABvi311+p8C9LVbhB7YMqKFV
 fN+qnghE/pbVPXh4Neo65G7zitnVmpP52IkZiXMnmKUv92gINY3JwAS17rvM+LxbBtKv
 dwt5VPbrnhB00vmueJ/WNyX2tyQ8zw7ZTbWLvoa9up5VYZB6uTDFdXH7w1NwK4r3GmCb
 CLH7hxCJ873SXPlRwkN2AVHxgEim053dOAAWjn8atuxQcdqkk+yIdgt1OqmDSLhTbUmX
 pM91qrj9OvLly0a73OyVC1ViHfO7kGE0XyC2vewgQNVy9JPvh7KuusvMSBxfq9NnwG8Q 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34ak16kp3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 00:35:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0TfhI186216;
        Thu, 22 Oct 2020 00:35:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 348ah09104-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 00:35:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09M0ZDFd009172;
        Thu, 22 Oct 2020 00:35:14 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 17:35:13 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 05/17] vhost: move vq iovec allocation to dev init time
Date:   Wed, 21 Oct 2020 19:34:51 -0500
Message-Id: <1603326903-27052-6-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=2 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches allow us to create vqs on demand after vhost_dev_init
and vhost_dev_set_owner have been called. For vhost-scsi we don't
know the number of vqs we really want until the vring/vq setup
operations have started up. For other devices we know the number of vqs
at vhost_dev_init time, so for those devs we init the vq and allocate
the needed iovecs. For vhost-scsi we will do it later when userspace has
instructed us to create a vq.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 71 +++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b35229e..a4a4450 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -383,29 +383,27 @@ static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 	vq->heads = NULL;
 }
 
-/* Helper to allocate iovec buffers for all vqs. */
-static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
+static int vhost_vq_alloc_iovecs(struct vhost_dev *dev,
+				 struct vhost_virtqueue *vq)
 {
-	struct vhost_virtqueue *vq;
-	int i;
+	vq->indirect = kmalloc_array(UIO_MAXIOV, sizeof(*vq->indirect),
+				     GFP_KERNEL);
+	if (!vq->indirect)
+		return -ENOMEM;
+
+	if (!dev->iov_limit)
+		return 0;
+
+	vq->log = kmalloc_array(dev->iov_limit, sizeof(*vq->log), GFP_KERNEL);
+	vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
+				  GFP_KERNEL);
+	if (!vq->log || !vq->heads)
+		goto err_nomem;
 
-	for (i = 0; i < dev->nvqs; ++i) {
-		vq = dev->vqs[i];
-		vq->indirect = kmalloc_array(UIO_MAXIOV,
-					     sizeof(*vq->indirect),
-					     GFP_KERNEL);
-		vq->log = kmalloc_array(dev->iov_limit, sizeof(*vq->log),
-					GFP_KERNEL);
-		vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
-					  GFP_KERNEL);
-		if (!vq->indirect || !vq->log || !vq->heads)
-			goto err_nomem;
-	}
 	return 0;
 
 err_nomem:
-	for (; i >= 0; --i)
-		vhost_vq_free_iovecs(dev->vqs[i]);
+	vhost_vq_free_iovecs(vq);
 	return -ENOMEM;
 }
 
@@ -458,6 +456,21 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
 	return sizeof(*vq->desc) * num;
 }
 
+static int vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+{
+	vq->log = NULL;
+	vq->indirect = NULL;
+	vq->heads = NULL;
+	vq->dev = dev;
+	mutex_init(&vq->mutex);
+	vhost_vq_reset(dev, vq);
+
+	if (vq->handle_kick)
+		vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev);
+
+	return vhost_vq_alloc_iovecs(dev, vq);
+}
+
 int vhost_dev_init(struct vhost_dev *dev,
 		   struct vhost_virtqueue **vqs, int nvqs,
 		   int iov_limit, int weight, int byte_weight,
@@ -465,7 +478,6 @@ int vhost_dev_init(struct vhost_dev *dev,
 		   int (*msg_handler)(struct vhost_dev *dev,
 				      struct vhost_iotlb_msg *msg))
 {
-	struct vhost_virtqueue *vq;
 	int i;
 
 	dev->vqs = vqs;
@@ -489,19 +501,16 @@ int vhost_dev_init(struct vhost_dev *dev,
 
 
 	for (i = 0; i < dev->nvqs; ++i) {
-		vq = dev->vqs[i];
-		vq->log = NULL;
-		vq->indirect = NULL;
-		vq->heads = NULL;
-		vq->dev = dev;
-		mutex_init(&vq->mutex);
-		vhost_vq_reset(dev, vq);
-		if (vq->handle_kick)
-			vhost_poll_init(&vq->poll, vq->handle_kick,
-					EPOLLIN, dev);
+		if (vhost_vq_init(dev, dev->vqs[i]))
+			goto err_vq_init;
 	}
 
 	return 0;
+
+err_vq_init:
+	for (--i; i >= 0; --i)
+		vhost_vq_free_iovecs(dev->vqs[i]);
+	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(vhost_dev_init);
 
@@ -606,10 +615,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 			goto err_cgroup;
 	}
 
-	err = vhost_dev_alloc_iovecs(dev);
-	if (err)
-		goto err_cgroup;
-
 	return 0;
 err_cgroup:
 	if (dev->worker) {
-- 
1.8.3.1

