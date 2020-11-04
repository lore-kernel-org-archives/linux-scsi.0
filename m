Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F12CC4741F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF3620825
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pCO2Os8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732042AbgKDW1A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 17:27:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49218 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgKDW07 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 17:26:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MNtnF041315;
        Wed, 4 Nov 2020 22:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=d1s3X6z8/9q2XDDHZLhoLMpMS0nwE1v8g4RF91IxOvA=;
 b=pCO2Os8eoC5/2C9eTkhGuBCFs5DL1dKFepMSp2VOZsukSBBCd7OfqoWoSlpsKHqttdW3
 0gx7RmaEDWKWFpZ3WN/n9fRVDG+tbjiht3Kbya/RSSuZ7WyjzMWIFNVrnOeBUiD++4LA
 fJqG3ujPgrruLdm45yEMQgxTomLRDJndT7EKDRqLlcQ3aAKBfTHfmph5oTLFKku7ulpd
 1gEIj04/CwVUuAgITw0RViKNcwYy/xtw+QGwWaJrgUyvu24uCOwlGVXyMsDkihiE+IM1
 34ICYBgkCptmG7pATYwe2I5V9sbStYUkYmv+NzrNDL43gdZwonFcOShqc8KU/U8BZgWX zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34hhb296sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 22:26:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MJnP7082901;
        Wed, 4 Nov 2020 22:26:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34hvryj72d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 22:26:54 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A4MQrmK011479;
        Wed, 4 Nov 2020 22:26:53 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 14:26:53 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 03/11] vhost net: use goto error handling in open
Date:   Wed,  4 Nov 2020 16:26:36 -0600
Message-Id: <1604528804-2878-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040159
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the next patches vhost_dev_init will be able to fail. This patch has
vhost_net_open use goto error handling like is done in the other vhost
code to make handling vhost_dev_init failures easier to handle and
extend in the future.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d..831d824 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1286,27 +1286,18 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	if (!n)
 		return -ENOMEM;
 	vqs = kmalloc_array(VHOST_NET_VQ_MAX, sizeof(*vqs), GFP_KERNEL);
-	if (!vqs) {
-		kvfree(n);
-		return -ENOMEM;
-	}
+	if (!vqs)
+		goto err_vqs;
 
 	queue = kmalloc_array(VHOST_NET_BATCH, sizeof(void *),
 			      GFP_KERNEL);
-	if (!queue) {
-		kfree(vqs);
-		kvfree(n);
-		return -ENOMEM;
-	}
+	if (!queue)
+		goto err_queue;
 	n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;
 
 	xdp = kmalloc_array(VHOST_NET_BATCH, sizeof(*xdp), GFP_KERNEL);
-	if (!xdp) {
-		kfree(vqs);
-		kvfree(n);
-		kfree(queue);
-		return -ENOMEM;
-	}
+	if (!xdp)
+		goto err_xdp;
 	n->vqs[VHOST_NET_VQ_TX].xdp = xdp;
 
 	dev = &n->dev;
@@ -1338,6 +1329,14 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	n->refcnt_bias = 0;
 
 	return 0;
+
+err_xdp:
+	kfree(queue);
+err_queue:
+	kfree(vqs);
+err_vqs:
+	kvfree(n);
+	return -ENOMEM;
 }
 
 static struct socket *vhost_net_stop_vq(struct vhost_net *n,
-- 
1.8.3.1

