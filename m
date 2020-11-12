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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDBEC388F7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9128D216C4
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="v37VAkh/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKLXVe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:21:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgKLXVd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 18:21:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACNAKhV118902;
        Thu, 12 Nov 2020 23:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=C2UFcoAa+tlDqsgrPEG6ID0wm4r8+kdJITF1WyQq7G0=;
 b=v37VAkh/VTd2W1ogOaF2hfgMc+PfM7YQuZQD+LLf3dRQgOPB+1O88dsvdKdf04LrMzpm
 dJLQ+jnaOwcW0NdbjyHdsZVATR5wTngJeJHyyP2sF0Z65xsZp18B0vrldkrDbfd697PH
 tQ9RjtIhgDMvsB5bsczojSweyqaZH1Xfg/u+HWL3Kh64y3IYMkx31pck6hZN/emvG2V1
 3i7AjTJ0GtjTdTeG88A/wqrmWMjYZIQYu8QlkJPSY8U3u4icZNrZMkEimh1k9DVvUt7u
 qbCxq7GHrLGV01MNbLi30e+JS63g3wgJLkl/hv/Y2Yvqyp+uk4oos+nvJ0K4d43ooYGz aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34nkhm8418-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:21:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACNAx72027354;
        Thu, 12 Nov 2020 23:19:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34p5g3ts9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:19:23 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACNJLDO026812;
        Thu, 12 Nov 2020 23:19:21 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:19:20 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/1] qemu vhost scsi: add VHOST_SET_VRING_ENABLE support
Date:   Thu, 12 Nov 2020 17:19:00 -0600
Message-Id: <1605223150-10888-2-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
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

This patch made over the master branch allows the vhost-scsi
driver to call into the kernel and tell it to enable/disable
a virtqueue.

The kernel patches included with this set, will create
a worker per IO vq when multiple IO queues have been setup.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 hw/scsi/vhost-scsi.c        |  6 ++++++
 hw/virtio/vhost-backend.c   | 30 ++++++++++++++++++++++++++++++
 linux-headers/linux/vhost.h |  1 +
 3 files changed, 37 insertions(+)

diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index 4d70fa0..bbb2ba3 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -93,6 +93,12 @@ static int vhost_scsi_start(VHostSCSI *s)
         return ret;
     }
 
+    ret = vsc->dev.vhost_ops->vhost_set_vring_enable(&vsc->dev, 1);
+    if (ret) {
+        error_report("Error enabling vhost-scsi vqs %d", ret);
+        vhost_scsi_common_stop(vsc);
+    }
+
     ret = vhost_scsi_set_endpoint(s);
     if (ret < 0) {
         error_report("Error setting vhost-scsi endpoint");
diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
index 88c8ecc..e190c8e 100644
--- a/hw/virtio/vhost-backend.c
+++ b/hw/virtio/vhost-backend.c
@@ -102,6 +102,35 @@ static int vhost_kernel_set_mem_table(struct vhost_dev *dev,
     return vhost_kernel_call(dev, VHOST_SET_MEM_TABLE, mem);
 }
 
+static int vhost_kernel_set_vring_enable(struct vhost_dev *dev, int enable)
+{
+    struct vhost_vring_state s;
+    int i, ret;
+
+    s.num = 1;
+    for (i = 0; i < dev->nvqs; ++i) {
+        s.index = i;
+
+        ret = vhost_kernel_call(dev, VHOST_SET_VRING_ENABLE, &s);
+        /* Ignore kernels that do not support the cmd */
+        if (ret == -EPERM)
+            return 0;
+        if (ret)
+            goto disable_vrings;
+    }
+
+    return 0;
+
+disable_vrings:
+    s.num = 0;
+    for (i--; i < dev->nvqs; ++i) {
+        s.index = i;
+        vhost_kernel_call(dev, VHOST_SET_VRING_ENABLE, &s);
+    }
+
+    return ret;
+}
+
 static int vhost_kernel_set_vring_addr(struct vhost_dev *dev,
                                        struct vhost_vring_addr *addr)
 {
@@ -302,6 +331,7 @@ static const VhostOps kernel_ops = {
         .vhost_scsi_get_abi_version = vhost_kernel_scsi_get_abi_version,
         .vhost_set_log_base = vhost_kernel_set_log_base,
         .vhost_set_mem_table = vhost_kernel_set_mem_table,
+        .vhost_set_vring_enable = vhost_kernel_set_vring_enable,
         .vhost_set_vring_addr = vhost_kernel_set_vring_addr,
         .vhost_set_vring_endian = vhost_kernel_set_vring_endian,
         .vhost_set_vring_num = vhost_kernel_set_vring_num,
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index 7523218..98dd919 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -70,6 +70,7 @@
 #define VHOST_VRING_BIG_ENDIAN 1
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+#define VHOST_SET_VRING_ENABLE _IOW(VHOST_VIRTIO, 0x15, struct vhost_vring_state)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
-- 
1.8.3.1

