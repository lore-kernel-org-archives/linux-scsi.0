Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E0FC77B6C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 02:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCUCGr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCUCGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 22:06:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD162ED5B;
        Mon, 20 Mar 2023 19:06:41 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4Nwp017041;
        Tue, 21 Mar 2023 02:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=g/fWfgh2zgVn1G6uuOchSviM3Kl8lun20//Qo3MS6UI=;
 b=e5lDDR141feVlzQjLQ+orIVMQM5nAcXNQw+9NcsvrmWvAWN4ExsTvMnpfRlBIH7edEtY
 yuvB/QU68YScZkS3mBQP92V9F1pYVk/2dZKZ+TrFP4kDJwZ1nzeDu8x5LXZdtDqxf6r3
 AoVhluaO15HVbWZPMy6SnKVwE7v3osmzxKIRl9AaV2g0ZRQS3f0yZnk/ERhPeIKVy60Z
 KdxE/VMnLz33O/TmvWt/SqcsKUxPstfDvwXSS9YiNdzhYuwuHzg5TnMTs3ISVyKfEXvE
 qSJKc0XpmU31dHQ1PfutFJrj71pn5KNTMG3XeqMObo6x9Vn1IhKUIvvqc33wM4maePpx jA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd5bcd14f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KNYkhf010738;
        Tue, 21 Mar 2023 02:06:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3peqjn4c4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:36 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32L26T9a007440;
        Tue, 21 Mar 2023 02:06:36 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-165-250.vpn.oracle.com [10.154.165.250])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3peqjn4c0v-6;
        Tue, 21 Mar 2023 02:06:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 5/7] vhost-scsi: Check for a cleared backend before queueing an event
Date:   Mon, 20 Mar 2023 21:06:22 -0500
Message-Id: <20230321020624.13323-6-michael.christie@oracle.com>
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
X-Proofpoint-ORIG-GUID: C9zns4ZwLWXe2SaW7yy-EhTv7Nry9sEO
X-Proofpoint-GUID: C9zns4ZwLWXe2SaW7yy-EhTv7Nry9sEO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currenly hold the vhost_scsi_mutex while clearing the endpoint and
while performing vhost_scsi_do_plug, so tpg->vhost_scsi can't be freed
from uder us, and to make sure anything queued is handled by the
full call in vhost_scsi_clear_endpoint.

This patch removes the need for the vhost_scsi_mutex for the latter
case. In the next patches, we won't hold the vhost_scsi_mutex while
flushing so this patch adds a check for the clearing of the virtqueue
from vhost_scsi_clear_endpoint. We then know that once
vhost_scsi_clear_endpoint has cleared the backend that no new events
will be queued, and the flush after the vhost_vq_set_backend(vq, NULL)
call will see everything that's been queued to that point. So the flush
will then handle all events without the need for the vhost_scsi_mutex.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c945136ecf18..ba8097fcea43 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2010,9 +2010,17 @@ vhost_scsi_do_plug(struct vhost_scsi_tpg *tpg,
 
 	vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	mutex_lock(&vq->mutex);
+	/*
+	 * We can't queue events if the backend has been cleared, because
+	 * we could end up queueing an event after the flush.
+	 */
+	if (!vhost_vq_get_backend(vq))
+		goto unlock;
+
 	if (vhost_has_feature(vq, VIRTIO_SCSI_F_HOTPLUG))
 		vhost_scsi_send_evt(vs, tpg, lun,
 				   VIRTIO_SCSI_T_TRANSPORT_RESET, reason);
+unlock:
 	mutex_unlock(&vq->mutex);
 }
 
-- 
2.25.1

