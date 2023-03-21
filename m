Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621D4C6FD1C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 02:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjCUCGy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCUCGs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 22:06:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99BD305E8;
        Mon, 20 Mar 2023 19:06:45 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4pHX026340;
        Tue, 21 Mar 2023 02:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=H9r2il6PViKSpQVaulibxENpxkzMyrAhWfxHwqY8eGY=;
 b=es1YJ3vsQyoGuNvLze/XpPDfgf1/9n0YiY8ET6tPdm0G6Xe+tW1owSTHQykgY5664oIU
 7B89dEivBZd0KEkx3vQb71ZoBCEMfGoMq05v6Ba0oq+8f+zobcMdCMorTNYMOGNvVD+O
 cGCw50BnEn0a8Vx1FowwibdiUGkWCL3C86bwj7dGTX+8eeSmx7t0O7r2w26K+m/qZJDC
 vWhPq3Q1EGeVBrTLbSr7f7XZ5mGndwybn6d510PPetcWQjpVD/7cw6p3kGc0Ug7xWwFh
 vSTJpfLwOF93bDI/h69Q59mbwWZL6jWCTUcjOxXfYDCRgSpzOSxhBBba+gFHBUdNcG8R 9Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd47tn0sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KNExeQ010388;
        Tue, 21 Mar 2023 02:06:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3peqjn4c5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:40 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32L26T9e007440;
        Tue, 21 Mar 2023 02:06:39 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-165-250.vpn.oracle.com [10.154.165.250])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3peqjn4c0v-8;
        Tue, 21 Mar 2023 02:06:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 7/7] vhost-scsi: Reduce vhost_scsi_mutex use
Date:   Mon, 20 Mar 2023 21:06:24 -0500
Message-Id: <20230321020624.13323-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321020624.13323-1-michael.christie@oracle.com>
References: <20230321020624.13323-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_18,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210017
X-Proofpoint-GUID: QtG3BjkRHARJkLjfhDuFDNXl5a2DGMFy
X-Proofpoint-ORIG-GUID: QtG3BjkRHARJkLjfhDuFDNXl5a2DGMFy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We on longer need to hold the vhost_scsi_mutex the entire time we
set/clear the endpoint. The tv_tpg_mutex handles tpg accesses not related
to the tpg list, the port link/unlink functions use the tv_tpg_mutex while
accessing the tpg->vhost_scsi pointer, vhost_scsi_do_plug will no longer
queue events after the virtqueue's backend has been cleared and flushed,
and we don't drop our refcount to the tpg until after we have stopped
cmds and wait for outstanding cmds to complete.

This moves the vhost_scsi_mutex use to it's documented use of being used
to access the tpg list. We then don't need to hold it while a flush is
being performed causing other device's vhost_scsi_set_endpoint
and vhost_scsi_make_tpg/vhost_scsi_drop_tpg calls to have to wait on a
flakey device.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d4372a4aff49..3b0b556c57ef 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -229,7 +229,10 @@ struct vhost_scsi_ctx {
 	struct iov_iter out_iter;
 };
 
-/* Global spinlock to protect vhost_scsi TPG list for vhost IOCTL access */
+/*
+ * Global mutex to protect vhost_scsi TPG list for vhost IOCTLs and LIO
+ * configfs management operations.
+ */
 static DEFINE_MUTEX(vhost_scsi_mutex);
 static LIST_HEAD(vhost_scsi_list);
 
@@ -1526,7 +1529,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
  * vhost_scsi_tpg with an active struct vhost_scsi_nexus
  *
  *  The lock nesting rule is:
- *    vhost_scsi_mutex -> vs->dev.mutex -> tpg->tv_tpg_mutex -> vq->mutex
+ *    vs->dev.mutex -> vhost_scsi_mutex -> tpg->tv_tpg_mutex -> vq->mutex
  */
 static int
 vhost_scsi_set_endpoint(struct vhost_scsi *vs,
@@ -1540,7 +1543,6 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	int index, ret, i, len;
 	bool match = false;
 
-	mutex_lock(&vhost_scsi_mutex);
 	mutex_lock(&vs->dev.mutex);
 
 	/* Verify that ring has been setup correctly. */
@@ -1561,6 +1563,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	if (vs->vs_tpg)
 		memcpy(vs_tpg, vs->vs_tpg, len);
 
+	mutex_lock(&vhost_scsi_mutex);
 	list_for_each_entry(tpg, &vhost_scsi_list, tv_tpg_list) {
 		mutex_lock(&tpg->tv_tpg_mutex);
 		if (!tpg->tpg_nexus) {
@@ -1576,6 +1579,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		if (!strcmp(tv_tport->tport_name, t->vhost_wwpn)) {
 			if (vs->vs_tpg && vs->vs_tpg[tpg->tport_tpgt]) {
 				mutex_unlock(&tpg->tv_tpg_mutex);
+				mutex_unlock(&vhost_scsi_mutex);
 				ret = -EEXIST;
 				goto undepend;
 			}
@@ -1590,6 +1594,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			if (ret) {
 				pr_warn("target_depend_item() failed: %d\n", ret);
 				mutex_unlock(&tpg->tv_tpg_mutex);
+				mutex_unlock(&vhost_scsi_mutex);
 				goto undepend;
 			}
 			tpg->tv_tpg_vhost_count++;
@@ -1599,6 +1604,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		}
 		mutex_unlock(&tpg->tv_tpg_mutex);
 	}
+	mutex_unlock(&vhost_scsi_mutex);
 
 	if (match) {
 		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
@@ -1654,7 +1660,6 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	kfree(vs_tpg);
 out:
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&vhost_scsi_mutex);
 	return ret;
 }
 
@@ -1670,7 +1675,6 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 	int index, ret, i;
 	u8 target;
 
-	mutex_lock(&vhost_scsi_mutex);
 	mutex_lock(&vs->dev.mutex);
 	/* Verify that ring has been setup correctly. */
 	for (index = 0; index < vs->dev.nvqs; ++index) {
@@ -1757,12 +1761,10 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 	vs->vs_tpg = NULL;
 	WARN_ON(vs->vs_events_nr);
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&vhost_scsi_mutex);
 	return 0;
 
 err_dev:
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&vhost_scsi_mutex);
 	return ret;
 }
 
-- 
2.25.1

