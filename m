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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC629C55179
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A8C22275
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R8FHgGQ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507551AbgJVAfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:35:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43246 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507542AbgJVAfR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:35:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0TELr092876;
        Thu, 22 Oct 2020 00:35:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Wi7RtYH0fZg2S+uVbL6yjJO6oNhjvPLtXETQITgty8o=;
 b=R8FHgGQ+Hfos/cxfESk1lde6ibZyy3lWPk2h1yPVWd49YRps3NKsFzZD/LsXVOdYMtyI
 b73SCekBV/8PriAZPhN+spZmC1OfDsMp5mkWVDqfLyKeTeBcA1DxrBgORd8UfnC+nd8K
 xTH+BmbBlJXJUISMbAlbYQ5IxalyG7F7Gij91i08XHEYyaGh02PvpwR2UPI4/eGzj5SI
 f1iA9vA1jx4nBOUXWvauk9qRpX8RQ315OVyM+P4bENaUlFtMOdTq5W7FF+dqqLiewNxe
 CiUpRgA9pRbDLB5DSXGnNsBCDIlBo7ssQTzlxaB8vYuOMxgZNP9pLrysUIU8gl07Szos cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 349jrpuft0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 00:35:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0U6gt177063;
        Thu, 22 Oct 2020 00:35:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 348a6q15rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 00:35:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09M0ZCPa029942;
        Thu, 22 Oct 2020 00:35:12 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 17:35:12 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 03/17] vhost net: use goto error handling in open
Date:   Wed, 21 Oct 2020 19:34:49 -0500
Message-Id: <1603326903-27052-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the next patches vhost_dev_init will be able to fail. This patch has
vhost_net_open use goto error handling like is done in the other vhost
code to make handling vhost_dev_init failures easier to handle and
extend in the future.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
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

