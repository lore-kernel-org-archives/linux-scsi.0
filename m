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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E467C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD78E20872
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qUshph/T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgJGUzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:55:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48200 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgJGUzY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:55:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KoCLM028894;
        Wed, 7 Oct 2020 20:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Wi7RtYH0fZg2S+uVbL6yjJO6oNhjvPLtXETQITgty8o=;
 b=qUshph/T6NsCSv0NOMt76/iWVx3vmU/Uvi2AuPlglowG9Q4rv7xib8EjDjVapLJ3iI6E
 pgrilmZGDX/7EJlMyziUn4fKl/8eWo7XUX67h/54Lc9gQhq863GRSZpdeEQe+0PGhuey
 0cwSe6p1jtSoe74C1p9Y3jEgFUN/baWVomIKkssxaRn00K6rqi48MGrX3XwDKwImaZax
 PiyL9+BY84Vj4bO04k0Ws8Z6yVTzL4bNCv+Lh2pVA3mmthq33iuCLzMPk+oWjbPp/ix3
 TzYtpFZr6rgcGmsxXiCxEh1XhO5V/Ngd6FA3vuTpJ9oq4fUvBGdEhZgcYwGvaeabErf5 Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33xetb4eet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 20:55:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KpD0S029005;
        Wed, 7 Oct 2020 20:55:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33yyjhpudb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 20:55:19 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097KtILK005628;
        Wed, 7 Oct 2020 20:55:18 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 13:55:18 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 03/16] vhost net: use goto error handling in open
Date:   Wed,  7 Oct 2020 15:54:48 -0500
Message-Id: <1602104101-5592-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
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

