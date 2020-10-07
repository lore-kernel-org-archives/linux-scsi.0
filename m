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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568EDC4727E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0067B20872
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jruyjena"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgJGUzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:55:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48204 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728227AbgJGUzY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:55:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KoWp5029087;
        Wed, 7 Oct 2020 20:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=poLcKZ6/BP8EW9T+WZC/daa9IF1Bf81Hb8L+IgoSLWU=;
 b=JruyjenaJlTeyTb4ihfxSFY2odN26N8JVQPf0gac9YjTJdtP/6/d/bTnMwIafL/DrFP4
 vDPA+VXS9cPMtK0KD0aZWMPnRbEBx3FhCT3wpSrOyEO/ki9YGZ2UbJkqQuxCaEB9ky6g
 NXVL1vygMLW8E4mxtqc5lWeOJyOY3NzjA0VJZRjiv0iyQdrmYqFD5vRJuiEqOYl75Qqr
 +FvGlFOIpiDJXJTzMcodwh3OTslIAsKhEVQ8VuW+k/odSGm6S31u6XgJiewD1HRR67aW
 cZsYPw/Eelbs0+u0P9gavYPWBp0fjmHUGLmE5PKjJ9E9P43CZ0MJ0srhWwhoLmb1p06v Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetb4eeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 20:55:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KpKud166290;
        Wed, 7 Oct 2020 20:55:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vpyuwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 20:55:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097KtJUJ009063;
        Wed, 7 Oct 2020 20:55:19 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 13:55:19 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 05/16] vhost: move vq iovec allocation to dev init time
Date:   Wed,  7 Oct 2020 15:54:50 -0500
Message-Id: <1602104101-5592-6-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=2 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=2 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches allow us to create vqs on demand after vhost_dev_init
and vhost_dev_set_owner have been called. For vhost-scsi we don't
know the number of vqs we really want until the vring/vq setup
operations have started up. For other devices we know the number of vqs
at vhost_dev_init time, so for those devs we init the vq and allocate
the needed iovecs. For vhost-scsi we will do it later when userspace has
instructed us to setup a specific vq.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 71 +++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b05e690..d6af5a4 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -384,29 +384,27 @@ static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
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
 
@@ -459,6 +457,21 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
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
@@ -466,7 +479,6 @@ int vhost_dev_init(struct vhost_dev *dev,
 		   int (*msg_handler)(struct vhost_dev *dev,
 				      struct vhost_iotlb_msg *msg))
 {
-	struct vhost_virtqueue *vq;
 	int i;
 
 	dev->vqs = vqs;
@@ -490,19 +502,16 @@ int vhost_dev_init(struct vhost_dev *dev,
 
 
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
 
@@ -607,10 +616,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
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

