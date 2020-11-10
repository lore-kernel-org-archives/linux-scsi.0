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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3D7C388F7
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 05:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D94620795
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 05:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DeC9TjQR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbgKJFfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 00:35:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53166 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731671AbgKJFfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 00:35:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA5Y1jA175615;
        Tue, 10 Nov 2020 05:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=RhlM2CTqcflV5vp3F7q5MDizBtwnh8ThdrPV8oRgjIw=;
 b=DeC9TjQR/dZGY9JoUBXV8/kIdDR0+8M3oiKCt6wULALI4gCFQrVyx9Eag8no4kX42vYv
 aXxnch7rfhKQz3L1+fQRIVw4uTz6k6hyAjX69HJLo3YCH/cAmtNtb5GPEOKqUjh5PWNd
 3PJ++tlQGkAzzIvr75RUgVJ8rbF68RO9YWkdDH5Q/DIsQFdyE0ujIoFaA1d8A7ZunFYl
 AnBtFEe5LHbJfA4grtnrdKACV9zR/Vd1GcpO1l03JQcVx9chfVKZjUDOGqapRtRguNwj
 nqymYmLgiIYqA1VSpV0xADqjDiiSLoxIbLa5/yHUDkF18MLIJEuWbrLGieqL7u+n46YJ Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34nh3asuey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 05:35:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA5EoMs125362;
        Tue, 10 Nov 2020 05:33:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34p5fyqrjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 05:33:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AA5XVE3020910;
        Tue, 10 Nov 2020 05:33:31 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 21:33:31 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH 1/5] vhost: add helper to check if a vq has been setup
Date:   Mon,  9 Nov 2020 23:33:19 -0600
Message-Id: <1604986403-4931-2-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
References: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100038
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper check if a vq has been setup. The next patches
will use this when we move the vhost scsi cmd preallocation from per
session to per vq. In the per vq case, we only want to allocate cmds
for vqs that have actually been setup and not for all the possible
vqs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 6 ++++++
 drivers/vhost/vhost.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5c835a2..a262e12 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -304,6 +304,12 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
 	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer));
 }
 
+bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
+{
+	return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_is_setup);
+
 static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index e016cd3..b063324 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -190,6 +190,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
 int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-- 
1.8.3.1

