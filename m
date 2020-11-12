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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B62CC56202
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F07E122227
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CAGe0CZk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgKLXTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:19:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57208 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKLXTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 18:19:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACNAUNv087344;
        Thu, 12 Nov 2020 23:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=inE/sT98h+DxX+TMTZz44K2yKdu909cu59+L/DBU4f4=;
 b=CAGe0CZkbvzldQmV2dPMlPBVG+mkEbn7zICigJEPkRLannPnWRSwYpx5aoJfSnYhpMn/
 DOlSjrO9ArwFFXFQUT4zAthdcEpm0vmraXvcFaZGkwOpZU9J1d2Vi9UwrXGL9mMzgk2Z
 g48WZ/BAeTyYc8mPcplm1VC5++YQzoWxJ9kbg43cfwrjtDmmMrAi6sxu9cgO7v+M4y7b
 nlh5rbws2RyWxtKWxiu2iExtylXkSnYFx4qvh4ge7C8b/LHsO+Sk1JyX6B9D3jvtdjTb
 fKqr44eAcKXFCAKgJjI1TPvpkYbDdX+GkUU5ERrmYT3seXPnPKjGGcHnFCT8qZtJctO8 1A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34nh3b8btu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:19:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACNB0Rb027426;
        Thu, 12 Nov 2020 23:19:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34p5g3tsfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:19:31 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ACNJU2Y020415;
        Thu, 12 Nov 2020 23:19:30 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:19:30 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 09/10] vhost: add VHOST_SET_VRING_ENABLE support
Date:   Thu, 12 Nov 2020 17:19:09 -0600
Message-Id: <1605223150-10888-11-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a new ioctl VHOST_SET_VRING_ENABLE that the vhost drivers can
implement a callout for and execute an operation when the vq is
enabled/disabled.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c      | 25 +++++++++++++++++++++++++
 drivers/vhost/vhost.h      |  1 +
 include/uapi/linux/vhost.h |  1 +
 3 files changed, 27 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2f98b81..e953031 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1736,6 +1736,28 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
 
 	return r;
 }
+
+static long vhost_vring_set_enable(struct vhost_dev *d,
+				   struct vhost_virtqueue *vq,
+				   void __user *argp)
+{
+	struct vhost_vring_state s;
+	int ret = 0;
+
+	if (vq->private_data)
+		return -EBUSY;
+
+	if (copy_from_user(&s, argp, sizeof s))
+		return -EFAULT;
+
+	if (s.num != 1 && s.num != 0)
+		return -EINVAL;
+
+	if (d->ops && d->ops->enable_vring)
+		ret = d->ops->enable_vring(vq, s.num);
+	return ret;
+}
+
 long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 {
 	struct file *eventfp, *filep = NULL;
@@ -1765,6 +1787,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	mutex_lock(&vq->mutex);
 
 	switch (ioctl) {
+	case VHOST_SET_VRING_ENABLE:
+		r = vhost_vring_set_enable(d, vq, argp);
+		break;
 	case VHOST_SET_VRING_BASE:
 		/* Moving base with an active backend?
 		 * You don't want to do that. */
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index a293f48..1279c09 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -158,6 +158,7 @@ struct vhost_msg_node {
 
 struct vhost_dev_ops {
 	int (*msg_handler)(struct vhost_dev *dev, struct vhost_iotlb_msg *msg);
+	int (*enable_vring)(struct vhost_virtqueue *vq, bool enable);
 };
 
 struct vhost_dev {
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860..3ffd133 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -70,6 +70,7 @@
 #define VHOST_VRING_BIG_ENDIAN 1
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+#define VHOST_SET_VRING_ENABLE _IOW(VHOST_VIRTIO, 0x15, struct vhost_vring_state)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
-- 
1.8.3.1

