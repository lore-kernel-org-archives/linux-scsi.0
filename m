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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24257C41604
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDA4F2083B
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tl5yKk7X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgJGUze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:55:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35250 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbgJGUzb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:55:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KoCJr113276;
        Wed, 7 Oct 2020 20:55:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=TxaIUJd6h4H8huBw9neYsTBcQJ2+geI1a5MAf+wgTwk=;
 b=Tl5yKk7XcjoaHsGh03RwJyJvP2NwwuHToewkEDB73uUOwXDyzJOekSpE9agfU3DGpDDh
 UhcZsvb63xe/de1Xqh+2d29XWdmRndV03lcOorKl5JZ4ox8lWO2/205pk8BXKEAk5Onc
 VrfiKduzWQFPgTm2ei63/I61tdQu5CsdVWPOgfc6XrdFb2Q4L6RGz1QPa6AjyyILogf4
 gg+0D+YKzH+lJTeZA7lEJAPFssR8oCzHVhbl2z9/OO7tcxLIA+K/Wj8hM1k8drCTC0qf
 MVmP/e6d30Rj43L086WhOxOzXT+J9qBRUa2KrGlxlxRVnLaMnCVCdzmBgjvCiGVm/Sr0 7w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34scr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 20:55:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KpLpV166381;
        Wed, 7 Oct 2020 20:55:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33y2vpyv4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 20:55:27 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097KtPNV032127;
        Wed, 7 Oct 2020 20:55:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 13:55:25 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 16/16] vhost scsi: multiple worker support
Date:   Wed,  7 Oct 2020 15:55:01 -0500
Message-Id: <1602104101-5592-17-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Create a vhost_worker per IO vq. When using a more than 2 vqs and/or
multiple LUNs per vhost-scsi dev, we hit a bottleneck with the single
worker. The problem is that we want to start and complete all vqs and
all LUNs from the same thread. Combine with the previous patches that
allow us to add more than 2 vqs, we see a IOPs workloads (like 50/50
randrw 4K IOs) go from 150K to 400K where the native device is 500K.
For the lio rd_mcp backend, we see IOPs go for from 400K to 600K.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4309f97..e5f73c1 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1624,6 +1624,22 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
 		       sizeof(vs->vs_vhost_wwpn));
 
+		/*
+		 * For compat, have the evt and ctl vqs share worker0 with
+		 * the first IO vq like is setup as default already. Any
+		 * addition vqs will get their own worker.
+		 *
+		 * Note: if we fail later, then the vhost_dev_cleanup call on
+		 * release() will clean up all the workers.
+		 */
+		ret = vhost_workers_create(&vs->dev,
+					   vs->dev.nvqs - VHOST_SCSI_VQ_IO);
+		if (ret) {
+			pr_err("Could not create vhost-scsi workers. Error %d.",
+			       ret);
+			goto undepend;
+		}
+
 		for (i = VHOST_SCSI_VQ_IO; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
 			if (!vq->initialized)
@@ -1631,6 +1647,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 
 			if (vhost_scsi_setup_vq_cmds(vq, vq->num))
 				goto destroy_vq_cmds;
+			vhost_vq_set_worker(vq, i - VHOST_SCSI_VQ_IO);
 		}
 
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
-- 
1.8.3.1

