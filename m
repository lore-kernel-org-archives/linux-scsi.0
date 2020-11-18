Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA43C6369E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 06:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C56D724695
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 06:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KdgufsGS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgKRG0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 01:26:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37292 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgKRG0e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 01:26:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AI6OGMD074669;
        Wed, 18 Nov 2020 06:26:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=Tbb6SYe55brUhsH/FvL/9Dk91K3PBn20zWIWA6xuSrw=;
 b=KdgufsGS3Amd1MjhbcmYN6hwlHF9/7ABb6eWRvbTw2LzJcsCc/AsvpRFZeQDy3CvTh1R
 h9dMdcpmEBaqLUX5Qt6NpXmJqR0m3pK23k6d6E4Tpcna6CWDCZKrWRzvTef0Ayk+amBj
 zBt97HTtcTqt335e/tkHLH8zHiV7W1VNobOr7149Svuu6SCTDOPJVjprXJJGojf6Fy9W
 uboYp9tSegQfvjkp0qI6AfoS0+QkY9j0eFN8ABkAb+QcPmXBRe6g0U0EfV8md3Wpgrqi
 bzcMAtmRozzL6eFoCD8Wi9GKOKTu5PisHTZGrPnBXQsi7tiD4g9L19tBjWtmbfDPruXO 5A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34t76kxbys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 06:26:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AI69g8i190744;
        Wed, 18 Nov 2020 06:24:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34uspuc09b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 06:24:29 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AI6ORAP026737;
        Wed, 18 Nov 2020 06:24:27 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Nov 2020 22:24:27 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/1] vhost scsi: fix lun reset completion handling
Date:   Wed, 18 Nov 2020 00:24:20 -0600
Message-Id: <1605680660-3671-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=2 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180044
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

vhost scsi owns the scsi se_cmd but lio frees the se_cmd->se_tmr
before calling release_cmd, so while with normal cmd completion we
can access the se_cmd from the vhost work, we can't do the same with
se_cmd->se_tmr. This has us copy the tmf response in
vhost_scsi_queue_tm_rsp to our internal vhost-scsi tmf struct for
when it gets sent to the guest from our worker thread.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f22fce5..6ff8a5096 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -220,6 +220,7 @@ struct vhost_scsi_tmf {
 	struct list_head queue_entry;
 
 	struct se_cmd se_cmd;
+	u8 scsi_resp;
 	struct vhost_scsi_inflight *inflight;
 	struct iovec resp_iov;
 	int in_iovs;
@@ -426,6 +427,7 @@ static void vhost_scsi_queue_tm_rsp(struct se_cmd *se_cmd)
 	struct vhost_scsi_tmf *tmf = container_of(se_cmd, struct vhost_scsi_tmf,
 						  se_cmd);
 
+	tmf->scsi_resp = se_cmd->se_tmr_req->response;
 	transport_generic_free_cmd(&tmf->se_cmd, 0);
 }
 
@@ -1183,7 +1185,7 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 						  vwork);
 	int resp_code;
 
-	if (tmf->se_cmd.se_tmr_req->response == TMR_FUNCTION_COMPLETE)
+	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE)
 		resp_code = VIRTIO_SCSI_S_FUNCTION_SUCCEEDED;
 	else
 		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
-- 
1.8.3.1

