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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0C1C0018C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1BD422583
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgLDH5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 02:57:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbgLDH5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 02:57:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47ncq2001125;
        Fri, 4 Dec 2020 07:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=cZyFI5n2A7L4LJEbKIRH1MmYalBJ/jDJniUTE4TPNew=;
 b=Ppv4m4l7cgFbVdP7wkoduSe53bWB30h3dJcYkb4ktZAQ7Io0rKDk28YhqwKyihjMiD3R
 gcl+lesvbuxQOHHpDZFcfokbTLFPqrjGbny8uupno4fsbPCwwMs56zkPjBkDkVk2mMvj
 CzOwM9CQrSJQLjRotwMfCTm9JnSpOoeliYXoL65yFeyMkRdHT9aScfA/3oQGyiM74PON
 YV+lZr4WqsWNm17tSYfI7rl2UACF1WddB1/ye1RGeg2qv88J1yP6D1YERVRItJwQRDa8
 AmJTCU5IgPcF8PJpx8rLewW57SrG2GQmBvM6PUjQHASe/2XRjTKV8TgDi8lk0AyiNWby OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyr1wtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 07:56:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47oXHD066700;
        Fri, 4 Dec 2020 07:56:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404ryfsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 07:56:45 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B47ujlS015544;
        Fri, 4 Dec 2020 07:56:45 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 23:56:45 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     sgarzare@redhat.com, stefanha@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 4/8] vhost: move msg_handler to new ops struct
Date:   Fri,  4 Dec 2020 01:56:29 -0600
Message-Id: <1607068593-16932-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040045
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch adds a callout so drivers can perform some action when we
bind a vq to a cpu, so this patch moves the msg_handler callout to a new
vhost_dev_ops struct just to keep all the callouts better organized.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vdpa.c  |  7 +++++--
 drivers/vhost/vhost.c | 10 ++++------
 drivers/vhost/vhost.h | 11 ++++++-----
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ef688c8..1c8c2bf 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -844,6 +844,10 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 	}
 }
 
+static struct vhost_dev_ops vdpa_dev_ops = {
+	.msg_handler	= vhost_vdpa_process_iotlb_msg,
+};
+
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v;
@@ -871,8 +875,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 		vqs[i] = &v->vqs[i];
 		vqs[i]->handle_kick = handle_vq_kick;
 	}
-	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
-		       vhost_vdpa_process_iotlb_msg);
+	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false, &vdpa_dev_ops);
 
 	dev->iotlb = vhost_iotlb_alloc(0, 0);
 	if (!dev->iotlb) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 78d9535..ee2551c 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -467,9 +467,7 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
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
@@ -486,7 +484,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
 	dev->use_worker = use_worker;
-	dev->msg_handler = msg_handler;
+	dev->ops = ops;
 	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
@@ -1164,8 +1162,8 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
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
index 575c818..64fa638 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -143,6 +143,10 @@ struct vhost_msg_node {
   struct list_head node;
 };
 
+struct vhost_dev_ops {
+	int (*msg_handler)(struct vhost_dev *dev, struct vhost_iotlb_msg *msg);
+};
+
 struct vhost_dev {
 	struct mm_struct *mm;
 	struct mutex mutex;
@@ -162,16 +166,13 @@ struct vhost_dev {
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

