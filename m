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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A501AC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B0E72225F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T4aNxNFp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894385AbgJVAfa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:35:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37520 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894371AbgJVAfZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:35:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0Swe7049885;
        Thu, 22 Oct 2020 00:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=91O5yBfXorSpihUlbuDMGyWknKSGOWoecP6GtssP67Q=;
 b=T4aNxNFpmA4du2K8bEJlufJmhT51Vs8LTH6c7aip1TqMYnWTC1vMPQNhk3zECMIqWGku
 6vlBVl9oXAvTRUh0I6Jj3IZvPsak/GfZwAf/MJ7wgCEeOa7YylrPNlAhNUQorBNW99+O
 ZtiS4baUAgKq5m2n/WgBBPv68h5M/9jjXSXbbvVHemNTQeF6bNKQS3LKpjTb2QByIFZg
 MDZ7fZ4dyjaT4mL+dj0zgVeX1hYV0rnWABBUQBBsorRTQ4x3A84cfKFuKbPIoAoCEw60
 qQISYa0IssMqcdLKc2CBO7T5e/xpaSp9yyBzukmOvOeJRKKuzNnss8vwqyxa2CODyJc9 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 347p4b3f7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 00:35:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0U6gc177069;
        Thu, 22 Oct 2020 00:35:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 348a6q15u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 00:35:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09M0ZK6b011429;
        Thu, 22 Oct 2020 00:35:20 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 17:35:20 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 16/17] vhost scsi: multiple worker support
Date:   Wed, 21 Oct 2020 19:35:02 -0500
Message-Id: <1603326903-27052-17-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Create a vhost_worker per IO vq. When using more than 2 vqs and/or
multiple LUNs per vhost-scsi dev, we hit a bottleneck with the single
worker where we want to start and complete all vqs and all LUNs from the
same thread.

Combined with the previous patches that allow us to increase the
queue depths and virtqueue count, for a single LUN/device with 8
virtqueues at queue depth of 128 cmds per queue, IOPs heavy workloads
(like 50/50 randrw 4K IOs with numjobs=virtqueues and iodepth=queue
depth) go from 180K to 400K where the native device can get 500K IOPs.

When using the null_blk driver, with a single LUN/device and the
same number of virtqueues/queuedepth and fio workload we see IOPs go
from 360K to 640K.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5d6dc15..4e91a90 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1624,6 +1624,22 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
 		       sizeof(vs->vs_vhost_wwpn));
 
+		/*
+		 * For compat, have the evt and ctl vqs share worker0 with
+		 * the first IO vq like is setup as default already. Any
+		 * additional vqs will get their own worker.
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

