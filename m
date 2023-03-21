Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46481C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 02:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCUCGq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCUCGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 22:06:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6192231E29;
        Mon, 20 Mar 2023 19:06:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4Rbv014753;
        Tue, 21 Mar 2023 02:06:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=kPNNQe0Jkx7j+gAbUS6oUeXbB7bLjs0FNjYR0kSxCp4=;
 b=x4uXVeonER6Cy7wEDDiwO+PUonbFi0mlieYrPjmXXle9k0KQa5jXgl9/nkkh9/1Y09HB
 4iMtJNDG8o6Dc3Gy7EDGmi/B9coOsQ6w2IKaHpK2Fq8fpiRfwcohpvpkELhnRm28Trex
 y9E99Lan1RNs3yauKLNmdAMCUhOdSuZVrIbQrEIsSjYTL1wBj19xvvbU2NcJQAt10nS5
 UfMpwp0LZOE2CGl0TJ//j15MedpKvj2jK1v2nWT0mE4S/ErHnnYVwCZWnYQJ6yQm7zkq
 gn/1G+UnpQlKlq2fgIXU/XMHmes1WcmreCBAUd2wWSVlt0OAr7dbC3kj1T44AxjCYxu1 tQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd4wt4yrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KNPAGZ010423;
        Tue, 21 Mar 2023 02:06:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3peqjn4c4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:35 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32L26T9Y007440;
        Tue, 21 Mar 2023 02:06:34 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-165-250.vpn.oracle.com [10.154.165.250])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3peqjn4c0v-5;
        Tue, 21 Mar 2023 02:06:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 4/7] vhost-scsi: Drop device mutex use in vhost_scsi_do_plug
Date:   Mon, 20 Mar 2023 21:06:21 -0500
Message-Id: <20230321020624.13323-5-michael.christie@oracle.com>
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
X-Proofpoint-GUID: 6sdUmtzut9zu79SSTGG2flVR9jkN3BuT
X-Proofpoint-ORIG-GUID: 6sdUmtzut9zu79SSTGG2flVR9jkN3BuT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't need the device mutex in vhost_scsi_do_plug because:
1. we have the vhost_scsi_mutex so the tpg->vhost_scsi pointer will not
change on us and the vhost_scsi can't be freed from under us if it was
set.
2. vhost_scsi_clear_endpoint will stop the virtqueues and flush them while
holding the vhost_scsi_mutex so we know once vhost_scsi_clear_endpoint
has completed that vhost_scsi_do_plug can't send new events and any
queued ones have completed.

So this patch drops the device mutex use in vhost_scsi_do_plug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 502d6803df0b..c945136ecf18 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2003,8 +2003,6 @@ vhost_scsi_do_plug(struct vhost_scsi_tpg *tpg,
 	if (!vs)
 		return;
 
-	mutex_lock(&vs->dev.mutex);
-
 	if (plug)
 		reason = VIRTIO_SCSI_EVT_RESET_RESCAN;
 	else
@@ -2016,7 +2014,6 @@ vhost_scsi_do_plug(struct vhost_scsi_tpg *tpg,
 		vhost_scsi_send_evt(vs, tpg, lun,
 				   VIRTIO_SCSI_T_TRANSPORT_RESET, reason);
 	mutex_unlock(&vq->mutex);
-	mutex_unlock(&vs->dev.mutex);
 }
 
 static void vhost_scsi_hotplug(struct vhost_scsi_tpg *tpg, struct se_lun *lun)
-- 
2.25.1

