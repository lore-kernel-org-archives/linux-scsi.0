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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263C7C55178
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC09022249
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dvLEuT1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507559AbgJVAfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:35:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43272 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507553AbgJVAfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:35:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0Tfpp093257;
        Thu, 22 Oct 2020 00:35:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=3r3W7SShPE0OptAVa4seEJQv95dOgtsc9BGBzH004Eg=;
 b=dvLEuT1A3eLm0SvFrSGpiA56YVROLtJIS3gh0fMtT4No5yr3ShJFRuwhvkFVgnRRrsqa
 e7evhAsbGqZ3MYi/ivcddG+RsmE0//Fqae+obF7+Qx87KBlQv5McCteVku7ZWhdFzFxr
 IptLmgM2+IaMHnxyvgyJgFh03RT82EmYmpuFNY/ASzlaNs+qIfQ/QK6az/sZZj/Ul4X3
 VgFM6d5/4pnyQAMpWsYwpwP1hql28k+qN3GkOA/tpSBQQL4Wos1E5Ye8DYxLSGxTWjei
 1DtPTeuG503OcRyj/ZehLwRjdobrm56Ws07IbpuJYKldi1yKNTRjWlhV0j4StUjdYRSb eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 349jrpuft2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 00:35:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0V0N8035630;
        Thu, 22 Oct 2020 00:35:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 348ahy6fnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 00:35:14 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09M0ZDNE025685;
        Thu, 22 Oct 2020 00:35:13 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 17:35:13 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 04/17] vhost: prep vhost_dev_init users to handle failures
Date:   Wed, 21 Oct 2020 19:34:50 -0500
Message-Id: <1603326903-27052-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=2 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is just a prep patch to get vhost_dev_init callers ready to handle
the next patch where the function can fail. In this patch vhost_dev_init
just returns 0, but I think it's easier to check for goto/error handling
errors separated from the next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   | 11 +++++++----
 drivers/vhost/scsi.c  |  7 +++++--
 drivers/vhost/test.c  |  9 +++++++--
 drivers/vhost/vdpa.c  |  7 +++++--
 drivers/vhost/vhost.c | 14 ++++++++------
 drivers/vhost/vhost.h | 10 +++++-----
 drivers/vhost/vsock.c |  9 ++++++---
 7 files changed, 43 insertions(+), 24 deletions(-)

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
index 86617bb..63ba363 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1632,14 +1632,17 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
-		       VHOST_SCSI_WEIGHT, 0, true, NULL);
+	if (vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
+			   VHOST_SCSI_WEIGHT, 0, true, NULL))
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
index a2dbc85..9c8a686 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -810,8 +810,10 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
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
@@ -829,6 +831,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
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
index f40205f..a1a35e1 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -630,9 +630,10 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
 
-	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
-		       UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
-		       VHOST_VSOCK_WEIGHT, true, NULL);
+	if (vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
+			   UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
+			   VHOST_VSOCK_WEIGHT, true, NULL))
+		goto err_dev_init;
 
 	file->private_data = vsock;
 	spin_lock_init(&vsock->send_pkt_list_lock);
@@ -640,6 +641,8 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vhost_work_init(&vsock->send_pkt_work, vhost_transport_send_pkt_work);
 	return 0;
 
+err_dev_init:
+	kfree(vqs);
 out:
 	vhost_vsock_free(vsock);
 	return ret;
-- 
1.8.3.1

