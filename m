Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69385C2BB40
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E47223884
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgLQGp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:45:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56498 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQGp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:45:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6UdZd147582;
        Thu, 17 Dec 2020 06:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=6W3HPoFRnzxQ3dArlUgHO1O0wQLmdtaBn9QzyT8xH4o=;
 b=Fwy2Btxe9uw7Q+rM8Mx3z4/Jj0v3fHuyXTUk6q8Z4LfsEmP7Cq5GAXYVv1aSLVHm6Oyi
 YfiPr6TJRwmi5gdl1FBkBADqAO4nhkyAqjCWlP8LerqhLhMRqa+aYFHaQ4O4gWxYUx8O
 8gQpbPFCAHAUNDKUxlanLoJAtGY7U18gALHicpMi+FXLOimsNtBhWIetojepG195rjKk
 W/yH9nRyNJ7f3+Hkqcbl+xc3BMpuwspVAmRscuxrtspo4pQGX+W8LXbtDVgN6VYM83ST
 mjMVh09JadeJc5m2chuEzDEh9IAYyg54IbKSPSJeoWe19I9bGuqIfsvprBW2xnHEfqZJ Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcbm1vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:44:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VF5Z178238;
        Thu, 17 Dec 2020 06:42:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35e6jts206-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BH6gZxw019176;
        Thu, 17 Dec 2020 06:42:35 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:35 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 17/22] bnx2i: prep driver for switch to blk tags
Date:   Thu, 17 Dec 2020 00:42:07 -0600
Message-Id: <1608187332-4434-18-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently implement our own tagging which just adds another
layer of locks. For scsi cmds we can just use the block layer
tags. This patch preps bnx2i for this change by having it use
the correct itt to task look up function and then cap the can_queue
to the max iscsi ITT it can support.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c   | 14 +++++++-------
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  6 ++++++
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index bad396e..7e53684 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -404,8 +404,8 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 	switch (tmfabort_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
 	case ISCSI_TM_FUNC_ABORT_TASK:
 	case ISCSI_TM_FUNC_TASK_REASSIGN:
-		ctask = iscsi_itt_to_task(conn, tmfabort_hdr->rtt);
-		if (!ctask || !ctask->sc)
+		ctask = iscsi_itt_to_ctask(conn, tmfabort_hdr->rtt);
+		if (!ctask)
 			/*
 			 * the iscsi layer must have completed the cmd while
 			 * was starting up.
@@ -1347,8 +1347,8 @@ int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
 
 	resp_cqe = (struct bnx2i_cmd_response *)cqe;
 	spin_lock_bh(&session->back_lock);
-	task = iscsi_itt_to_task(conn,
-				 resp_cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
+	task = iscsi_itt_to_ctask(conn,
+				  resp_cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
 	if (!task)
 		goto fail;
 
@@ -1908,9 +1908,9 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 	int rc = 0;
 
 	spin_lock(&session->back_lock);
-	task = iscsi_itt_to_task(bnx2i_conn->cls_conn->dd_data,
-				 cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
-	if (!task || !task->sc) {
+	task = iscsi_itt_to_ctask(bnx2i_conn->cls_conn->dd_data,
+				  cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
+	if (!task) {
 		spin_unlock(&session->back_lock);
 		return -EINVAL;
 	}
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index eaccc04..b71f0db 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -763,6 +763,12 @@ static void bnx2i_setup_host_queue_size(struct bnx2i_hba *hba,
 		shost->can_queue = ISCSI_MAX_CMDS_PER_HBA_57710;
 	else
 		shost->can_queue = ISCSI_MAX_CMDS_PER_HBA_5708;
+	/*
+	 * We use the request's tag as the itt so cap the can_queue as
+	 * the max SCSI cmd ITT.
+	 */
+	if (shost->can_queue > ISCSI_CMD_REQUEST_INDEX - ISCSI_MGMT_CMDS_MAX)
+		shost->can_queue = ISCSI_CMD_REQUEST_INDEX - ISCSI_MGMT_CMDS_MAX;
 }
 
 
-- 
1.8.3.1

