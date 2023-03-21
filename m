Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121DCC76195
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 02:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjCUCGp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjCUCGk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 22:06:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997A131E23;
        Mon, 20 Mar 2023 19:06:38 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4NRS014691;
        Tue, 21 Mar 2023 02:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=/mEf86uLL/KEFQJyN9JttHSrW4cGrsihIK7v9mbKOsA=;
 b=qc6Ze/en87tIgq7jv7OxS+L/U4JsZahLPGecdJE9SBXFxDle9uKgragvLynDHRSt8j4/
 Htd03G6Y+rIsgMoe+jxPPRlNfjFRgSTdYpME2C8v02u1W46lAwpJ8Kln/71sWvo5Rzz4
 oTpW0KXK7DtH3l/gpCcrSSNpLELxdlKsvvMDJ/iNP31lAwf8wrKLQJdv779fTkGR/CKB
 B8Vrj4x5mTTp+RwPvmos1O5eI9gSbhXzXSpCzB3jJV109YVyPoNzkPGSL+Jz/Va8FISj
 WG218V2iSH+24VMjxxawjbjIW9b4Ca/6S6szeOEEiIAV/tN5QSfSGif0v7Scj4aYrVNY cg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd4wt4yrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KNGH2k010444;
        Tue, 21 Mar 2023 02:06:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3peqjn4c40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:33 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32L26T9W007440;
        Tue, 21 Mar 2023 02:06:33 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-165-250.vpn.oracle.com [10.154.165.250])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3peqjn4c0v-4;
        Tue, 21 Mar 2023 02:06:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 3/7] vhost-scsi: Delay releasing our refcount on the tpg
Date:   Mon, 20 Mar 2023 21:06:20 -0500
Message-Id: <20230321020624.13323-4-michael.christie@oracle.com>
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
X-Proofpoint-GUID: XcYzGs1b0u3yP989LtLsIX9uu8v-blXV
X-Proofpoint-ORIG-GUID: XcYzGs1b0u3yP989LtLsIX9uu8v-blXV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently hold the vhost_scsi_mutex the entire time we are running
vhost_scsi_clear_endpoint. One of the reasons for this is that it prevents
userspace from being able to free the se_tpg from under us after we have
called target_undepend_item. However, it forces management operations for
for other devices to have to wait on a flakey device's:

vhost_scsi_clear_endpoint -> vhost_scsi_flush()

call which can which can take a long time.

This moves the target_undepend_item call and the tpg unsetup code to after
we have stopped new IO from starting up and after we have waited on
running IO. We can then release our refcount on the tpg and session
knowing our device is no longer accessing them. We can then drop the
vhost_scsi_mutex use during thee flush call in later patches in this set,
when we have removed other reasons for holding it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 61 +++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 32d0be968103..502d6803df0b 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1691,11 +1691,10 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 		if (!tpg)
 			continue;
 
-		mutex_lock(&tpg->tv_tpg_mutex);
 		tv_tport = tpg->tport;
 		if (!tv_tport) {
 			ret = -ENODEV;
-			goto err_tpg;
+			goto err_dev;
 		}
 
 		if (strcmp(tv_tport->tport_name, t->vhost_wwpn)) {
@@ -1704,35 +1703,51 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 				tv_tport->tport_name, tpg->tport_tpgt,
 				t->vhost_wwpn, t->vhost_tpgt);
 			ret = -EINVAL;
-			goto err_tpg;
+			goto err_dev;
 		}
+		match = true;
+	}
+	if (!match)
+		goto free_vs_tpg;
+
+	/* Prevent new cmds from starting and accessing the tpgs/sessions */
+	for (i = 0; i < vs->dev.nvqs; i++) {
+		vq = &vs->vqs[i].vq;
+		mutex_lock(&vq->mutex);
+		vhost_vq_set_backend(vq, NULL);
+		mutex_unlock(&vq->mutex);
+	}
+	/* Make sure cmds are not running before tearing them down. */
+	vhost_scsi_flush(vs);
+
+	for (i = 0; i < vs->dev.nvqs; i++) {
+		vq = &vs->vqs[i].vq;
+		vhost_scsi_destroy_vq_cmds(vq);
+	}
+
+	/*
+	 * We can now release our hold on the tpg and sessions and userspace
+	 * can free them after this point.
+	 */
+	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
+		target = i;
+		tpg = vs->vs_tpg[target];
+		if (!tpg)
+			continue;
+
+		mutex_lock(&tpg->tv_tpg_mutex);
+
 		tpg->tv_tpg_vhost_count--;
 		tpg->vhost_scsi = NULL;
 		vs->vs_tpg[target] = NULL;
-		match = true;
+
 		mutex_unlock(&tpg->tv_tpg_mutex);
-		/*
-		 * Release se_tpg->tpg_group.cg_item configfs dependency now
-		 * to allow vhost-scsi WWPN se_tpg->tpg_group shutdown to occur.
-		 */
+
 		se_tpg = &tpg->se_tpg;
 		target_undepend_item(&se_tpg->tpg_group.cg_item);
 	}
-	if (match) {
-		for (i = 0; i < vs->dev.nvqs; i++) {
-			vq = &vs->vqs[i].vq;
-			mutex_lock(&vq->mutex);
-			vhost_vq_set_backend(vq, NULL);
-			mutex_unlock(&vq->mutex);
-		}
-		/* Make sure cmds are not running before tearing them down. */
-		vhost_scsi_flush(vs);
 
-		for (i = 0; i < vs->dev.nvqs; i++) {
-			vq = &vs->vqs[i].vq;
-			vhost_scsi_destroy_vq_cmds(vq);
-		}
-	}
+free_vs_tpg:
 	/*
 	 * Act as synchronize_rcu to make sure access to
 	 * old vs->vs_tpg is finished.
@@ -1745,8 +1760,6 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 	mutex_unlock(&vhost_scsi_mutex);
 	return 0;
 
-err_tpg:
-	mutex_unlock(&tpg->tv_tpg_mutex);
 err_dev:
 	mutex_unlock(&vs->dev.mutex);
 	mutex_unlock(&vhost_scsi_mutex);
-- 
2.25.1

