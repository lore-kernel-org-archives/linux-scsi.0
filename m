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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCFEC63798
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 16:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 841D72481C
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 16:27:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rIQaFpSq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgKRQ1y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 11:27:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38500 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbgKRQ1y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 11:27:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AIGJvHt172266;
        Wed, 18 Nov 2020 16:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=dxB3pXbb1d26cvoJl3SazIGF5pnJhbScyWXdEGrdYNU=;
 b=rIQaFpSqf+BSD+S6fmjBTwPO6CUWIJ1WY7ilf8anrdkXGrVMR76hE5rs4O7nH5gqacsH
 W0xD+pdX+/khC4EI+Wa+1krqO1MOrm/RgEzn/0lI0oqzo8xBrqMEvtOI3RDMtUG+D9AL
 xqMQNwBtd/RqeMXgqygVxYalLqFxYf/mS/VEIDGQ5KOkGJhDdKVy7kuxC+nPKuvhd5rs
 9l1Py4AoRX2XQE8apcOUFoly95iJUALAJKjpaFA3MYdx+ljlt260N+wtLNasyYqZrGaW
 k4oTmfHJVqhQW3PyADbWPwYOpBMjOleypqlqw7rd7YoG2KQylqu9l/rRzHSIZLXVmR3N SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34t7vn8vm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 16:27:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AIGLXde089486;
        Wed, 18 Nov 2020 16:27:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ts0sgdn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 16:27:46 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AIGRj6v007171;
        Wed, 18 Nov 2020 16:27:45 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Nov 2020 08:27:43 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/1 V2] vhost scsi: fix lun reset completion handling
Date:   Wed, 18 Nov 2020 10:27:37 -0600
Message-Id: <1605716857-4949-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=2 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

vhost scsi owns the scsi se_cmd but lio frees the se_cmd->se_tmr
before calling release_cmd, so while with normal cmd completion we
can access the se_cmd from the vhost work, we can't do the same with
se_cmd->se_tmr. This has us copy the tmf response in
vhost_scsi_queue_tm_rsp to our internal vhost-scsi tmf struct for
when it gets sent to the guest from our worker thread.

Fixes: Fixes: efd838fec17b ("vhost scsi: Add support for LUN resets.")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
---

V2:
- Added fixes line.

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

