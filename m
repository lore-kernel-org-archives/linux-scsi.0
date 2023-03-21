Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2298C77B62
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 02:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCUCGh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCUCGf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 22:06:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF5C305E8;
        Mon, 20 Mar 2023 19:06:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4RGV014750;
        Tue, 21 Mar 2023 02:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=mPrQHdQOaZkxh1Qbo5znE9BUO57yBo10h6YULnR6O6U=;
 b=zwAtqapJBwB7C6k+3d0iHV2zXLFR5pgt+1R5FGGQGIIGpq68fz5FvZEsOeTCM7RYVdHu
 2ivinXjo7PiG1FyN1iqzqp2NHi1sWhvmsdPOv0CUf+eBJ5Dv/PhrilO4uwA4WnO1JWWw
 LLttVyrnu7nucludSh9S2o/ZR3+OFQVS72cqw0KwuOHdlVAsCDD2vgEbZt9TyNrUeDa/
 3HZgT4cNuirlazu5MOpZm5Wp3SCpWE3rOqBFV3E/ic/jlJmZytvPn0ElnTXvNWPBJxv6
 s6VQUX/tQDbe1J/zeiwrCvDOxZjZQKYtsoJ5FMSO+CK665UnN+frUgkejcvfX8hEdVwT 8Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd4wt4yrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KNRDJI010339;
        Tue, 21 Mar 2023 02:06:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3peqjn4c2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:29 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32L26T9S007440;
        Tue, 21 Mar 2023 02:06:29 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-165-250.vpn.oracle.com [10.154.165.250])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3peqjn4c0v-2;
        Tue, 21 Mar 2023 02:06:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/7] vhost-scsi: Fix vhost_scsi struct use after free
Date:   Mon, 20 Mar 2023 21:06:18 -0500
Message-Id: <20230321020624.13323-2-michael.christie@oracle.com>
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
X-Proofpoint-GUID: v6_BLPy3Y6golBYeEqYuoEtDWuHmh-zT
X-Proofpoint-ORIG-GUID: v6_BLPy3Y6golBYeEqYuoEtDWuHmh-zT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If vhost_scsi_setup_vq_cmds fails we leave the tpg->vhost_scsi pointer
set. If the device is freed and then the user unmaps the LUN, the call to
vhost_scsi_port_unlink -> vhost_scsi_hotunplug will see the that
tpg->vhost_scsi is still set and try to use it.

This has us clear the vhost_scsi pointer in the failure path. It also
has us take tv_tpg_mutex in this failure path, because tv_tpg_vhost_count
is accessed under this mutex in vhost_scsi_drop_nexus and in the future
we will want to serialize access to tpg->vhost_scsi with that mutex
instead of the vhost_scsi_mutex.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index b244e7c0f514..5875241e1654 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1658,7 +1658,10 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
 		tpg = vs_tpg[i];
 		if (tpg) {
+			mutex_lock(&tpg->tv_tpg_mutex);
+			tpg->vhost_scsi = NULL;
 			tpg->tv_tpg_vhost_count--;
+			mutex_unlock(&tpg->tv_tpg_mutex);
 			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
 		}
 	}
-- 
2.25.1

