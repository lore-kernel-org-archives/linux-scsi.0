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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6282BC5519F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 007F321D7F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lwslecXo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgKLXTo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:19:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33636 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgKLXTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 18:19:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACNAs3h119284;
        Thu, 12 Nov 2020 23:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=aPfcN7KuEaC6QPosjKJKTrzN39N6uYT6NYusx0B9wME=;
 b=lwslecXonjC/dE8BDvWM8JVSJUPGabyjLP0AAIBWG0NGdmw4Oq7SbBVlCAyH1FdQpnzg
 8eqE5azlhsOxBJzO6isQuIfnj2Qpx1ZLDV5C58xqK4/tlEt9FBPvKRjCD0QpyoRNYI7B
 5HVtKdWWvrh+tmM/DvYCEUbUBG+01jVtpHKNiIoToEJ9M/PZMZCcl/3vwIQ5IBYVHOVv
 WfqppRjcAl2hg1c2EXKJFWnlZ/J3aggsFdZbqiaV7e30iPmG4EPvgJmB/Sp0TfKv4q1D
 /VGdNQFRuQonXMK2I6x4yuM687B20O1Y2qShKKsYI/UOggCWym+g4lGFYbXVWOaWcmQs Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhm83vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:19:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACNBKnT177101;
        Thu, 12 Nov 2020 23:19:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55s26fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:19:30 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ACNJTso020407;
        Thu, 12 Nov 2020 23:19:29 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:19:29 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 08/10] vhost: move msg_handler to new ops struct
Date:   Thu, 12 Nov 2020 17:19:08 -0600
Message-Id: <1605223150-10888-10-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch adds a callout so drivers can perform some action when we
get a VHOST_SET_VRING_ENABLE, so this patch moves the msg_handler callout
to a new vhost_dev_ops struct just to keep all the callouts better
organized.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vdpa.c  |  7 +++++--
 drivers/vhost/vhost.c | 10 ++++------
 drivers/vhost/vhost.h | 11 ++++++-----
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2754f30..f271f42 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -802,6 +802,10 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 	}
 }
 
+static struct vhost_dev_ops vdpa_dev_ops = {
+	.msg_handler	= vhost_vdpa_process_iotlb_msg,
+};
+
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v;
@@ -829,8 +833,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 		vqs[i] = &v->vqs[i];
 		vqs[i]->handle_kick = handle_vq_kick;
 	}
-	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
-		       vhost_vdpa_process_iotlb_msg);
+	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false, &vdpa_dev_ops);
 
 	dev->iotlb = vhost_iotlb_alloc(0, 0);
 	if (!dev->iotlb) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 6a6abfc..2f98b81 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -504,9 +504,7 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
 void vhost_dev_init(struct vhost_dev *dev,
 		    struct vhost_virtqueue **vqs, int nvqs,
 		    int iov_limit, int weight, int byte_weight,
-		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
-				       struct vhost_iotlb_msg *msg))
+		    bool use_worker, struct vhost_dev_ops *ops)
 {
 	struct vhost_virtqueue *vq;
 	int i;
@@ -524,7 +522,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
 	dev->use_worker = use_worker;
-	dev->msg_handler = msg_handler;
+	dev->ops = ops;
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
 	INIT_LIST_HEAD(&dev->pending_list);
@@ -1328,8 +1326,8 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
-	if (dev->msg_handler)
-		ret = dev->msg_handler(dev, &msg);
+	if (dev->ops && dev->ops->msg_handler)
+		ret = dev->ops->msg_handler(dev, &msg);
 	else
 		ret = vhost_process_iotlb_msg(dev, &msg);
 	if (ret) {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 0837133..a293f48 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -156,6 +156,10 @@ struct vhost_msg_node {
   struct list_head node;
 };
 
+struct vhost_dev_ops {
+	int (*msg_handler)(struct vhost_dev *dev, struct vhost_iotlb_msg *msg);
+};
+
 struct vhost_dev {
 	struct mm_struct *mm;
 	struct mutex mutex;
@@ -175,16 +179,13 @@ struct vhost_dev {
 	int byte_weight;
 	u64 kcov_handle;
 	bool use_worker;
-	int (*msg_handler)(struct vhost_dev *dev,
-			   struct vhost_iotlb_msg *msg);
+	struct vhost_dev_ops *ops;
 };
 
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
 		    int nvqs, int iov_limit, int weight, int byte_weight,
-		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
-				       struct vhost_iotlb_msg *msg));
+		    bool use_worker, struct vhost_dev_ops *ops);
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
-- 
1.8.3.1

