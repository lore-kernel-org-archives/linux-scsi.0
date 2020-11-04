Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35526C5517A
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC582080D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:27:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pL8puCEo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732152AbgKDW1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 17:27:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49226 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731576AbgKDW1A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 17:27:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MNrfT041312;
        Wed, 4 Nov 2020 22:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=iT9Wny9BKHFCjaQ8FyRpW2JzimPHdFrTRUVwVXTqEk8=;
 b=pL8puCEobR7i0qngjVcOU1YcbWQyX/WANxkJ7lzWHQ2NByMdjkbXfvyaXAV26LyC/bh/
 Vpw6EfzSnI9+MaHpnU6osi8qRVuyn0eja3ZI3mdsQF3fzejXXH/BN5wOq0v7LezeRf5D
 hbmuFOyVIznr2GbdFx5BaFquWuD4dcPp6wohyBA5/CD0gXSKUseYmTHMB6puI7jXH/b7
 OCqqw72y3uo4NCbhuW/6Hc5G3MarKj3Y3w1F5kkGFhHyzu/z0UEBVAQREj2bxZ3BaM+y
 g3qYGYR1OmVRXSrsJsX30XCnbqVGgk36TATh+na8vYfCpx/gHg1Vxqhd34liOASkuJyG Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34hhb296ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 22:26:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MKkkf192225;
        Wed, 4 Nov 2020 22:26:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34hw0g9gu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 22:26:55 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A4MQsvB008222;
        Wed, 4 Nov 2020 22:26:54 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 14:26:53 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 04/11] vhost: prep vhost_dev_init users to handle failures
Date:   Wed,  4 Nov 2020 16:26:37 -0600
Message-Id: <1604528804-2878-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=2
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040159
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is just a prep patch to get vhost_dev_init callers ready to handle
the next patch where the function can fail. In this patch vhost_dev_init
just returns 0, but I think it's easier to check for goto/error handling
errors separated from the next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com> 
---
 drivers/vhost/net.c   | 11 +++++++----
 drivers/vhost/scsi.c  |  8 ++++++--
 drivers/vhost/test.c  |  9 +++++++--
 drivers/vhost/vdpa.c  |  7 +++++--
 drivers/vhost/vhost.c | 14 ++++++++------
 drivers/vhost/vhost.h | 10 +++++-----
 drivers/vhost/vsock.c | 10 +++++++---
 7 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 831d824..fd30b53 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1316,10 +1316,11 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].rx_ring = NULL;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
-	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
-		       UIO_MAXIOV + VHOST_NET_BATCH,
-		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
-		       NULL);
+	if (vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
+			   UIO_MAXIOV + VHOST_NET_BATCH,
+			   VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
+			   NULL))
+		goto err_dev_init;
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
@@ -1330,6 +1331,8 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 
 	return 0;
 
+err_dev_init:
+	kfree(xdp);
 err_xdp:
 	kfree(queue);
 err_queue:
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 86617bb..ed8baf9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1632,14 +1632,18 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
-		       VHOST_SCSI_WEIGHT, 0, true, NULL);
+	r = vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
+			   VHOST_SCSI_WEIGHT, 0, true, NULL);
+	if (r)
+		goto err_dev_init;
 
 	vhost_scsi_init_inflight(vs, NULL);
 
 	f->private_data = vs;
 	return 0;
 
+err_dev_init:
+	kfree(vqs);
 err_vqs:
 	kvfree(vs);
 err_vs:
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index a09dedc..c255ae5 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -119,12 +119,17 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
-		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL);
+	if (vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
+			   VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL)
+		goto err_dev_init;
 
 	f->private_data = n;
 
 	return 0;
+
+err_dev_init:
+	kfree(vqs);
+	return -ENOMEM;
 }
 
 static void *vhost_test_stop_vq(struct vhost_test *n,
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2754f30..c1615a7 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -829,8 +829,10 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 		vqs[i] = &v->vqs[i];
 		vqs[i]->handle_kick = handle_vq_kick;
 	}
-	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
-		       vhost_vdpa_process_iotlb_msg);
+	r = vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
+			   vhost_vdpa_process_iotlb_msg);
+	if (r)
+		goto err_dev_init;
 
 	dev->iotlb = vhost_iotlb_alloc(0, 0);
 	if (!dev->iotlb) {
@@ -850,6 +852,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 err_init_iotlb:
 	vhost_dev_cleanup(&v->vdev);
+err_dev_init:
 	kfree(vqs);
 err:
 	atomic_dec(&v->opened);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 6818f71..b35229e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -458,12 +458,12 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
 	return sizeof(*vq->desc) * num;
 }
 
-void vhost_dev_init(struct vhost_dev *dev,
-		    struct vhost_virtqueue **vqs, int nvqs,
-		    int iov_limit, int weight, int byte_weight,
-		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
-				       struct vhost_iotlb_msg *msg))
+int vhost_dev_init(struct vhost_dev *dev,
+		   struct vhost_virtqueue **vqs, int nvqs,
+		   int iov_limit, int weight, int byte_weight,
+		   bool use_worker,
+		   int (*msg_handler)(struct vhost_dev *dev,
+				      struct vhost_iotlb_msg *msg))
 {
 	struct vhost_virtqueue *vq;
 	int i;
@@ -500,6 +500,8 @@ void vhost_dev_init(struct vhost_dev *dev,
 			vhost_poll_init(&vq->poll, vq->handle_kick,
 					EPOLLIN, dev);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vhost_dev_init);
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 1365f33..9ad34b1 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -167,11 +167,11 @@ struct vhost_dev {
 };
 
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
-void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
-		    int nvqs, int iov_limit, int weight, int byte_weight,
-		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
-				       struct vhost_iotlb_msg *msg));
+int vhost_dev_init(struct vhost_dev *dev, struct vhost_virtqueue **vqs,
+		   int nvqs, int iov_limit, int weight, int byte_weight,
+		   bool use_worker,
+		   int (*msg_handler)(struct vhost_dev *dev,
+				      struct vhost_iotlb_msg *msg));
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f40205f..cae0083 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -630,9 +630,11 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
 
-	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
-		       UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
-		       VHOST_VSOCK_WEIGHT, true, NULL);
+	ret = vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
+			     UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
+			     VHOST_VSOCK_WEIGHT, true, NULL);
+	if (ret)
+		goto err_dev_init;
 
 	file->private_data = vsock;
 	spin_lock_init(&vsock->send_pkt_list_lock);
@@ -640,6 +642,8 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vhost_work_init(&vsock->send_pkt_work, vhost_transport_send_pkt_work);
 	return 0;
 
+err_dev_init:
+	kfree(vqs);
 out:
 	vhost_vsock_free(vsock);
 	return ret;
-- 
1.8.3.1

