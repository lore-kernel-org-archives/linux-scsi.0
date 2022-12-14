Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CBAC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 04:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiLNEub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237256AbiLNEu0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 23:50:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FFA1B6
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:26 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE3gCYx020056
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NSB6M5rI/2seYxPOPAcwTkkfhyLtGkCX9E94P7rZQgQ=;
 b=WnC+fgnxw3VeBAfhphod0baHjV8uCW8LqRf7/bUwdw4qp8eCgJbYSNhF3rkperB2Bl3j
 sr7fsym5ZkVQyzaBmnsUCBZ3bumsXgLnWYnW3j0w28uIndfj7hjRyK+C2l9ZcUPt7oBN
 Q2ZuzJQOhgICnng7CyAn7kIv54n3yoK5MUDCEP6FSjXPVy+QVb6sRwJicUM1m8CBxS80
 UZo22Ie9/kb4lSAH7Sc7Py2Ctsr6NrK1niihx/j6dziwsRHTFN7xdAUhx5n0gI9qAb/J
 /o6Iql33ImXT0LGFzHdGLPJ30UTlT1tgX7aFufDzwymD7JhMl6i4/SP1nvhWoVOwGSVv lA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mf6tj078a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 13 Dec
 2022 20:50:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 13 Dec 2022 20:50:24 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F2CEB3F707D;
        Tue, 13 Dec 2022 20:50:23 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 01/10] qla2xxx: Check if port is online before sending ELS
Date:   Tue, 13 Dec 2022 20:50:05 -0800
Message-ID: <20221214045014.19362-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221214045014.19362-1-njavali@marvell.com>
References: <20221214045014.19362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: u2VhtxdTalU7WlgrBeo7Uz9s36nESpug
X-Proofpoint-GUID: u2VhtxdTalU7WlgrBeo7Uz9s36nESpug
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_02,2022-12-13_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shreyas Deodhar <sdeodhar@marvell.com>

CT Ping and ELS cmds fail for NVMe targets.
Check if port is online before sending ELS instead of
sending login.

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index cd75b179410d..dba7bba788d7 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -278,8 +278,8 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	const char *type;
 	int req_sg_cnt, rsp_sg_cnt;
 	int rval =  (DID_ERROR << 16);
-	uint16_t nextlid = 0;
 	uint32_t els_cmd = 0;
+	int qla_port_allocated = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = fc_bsg_to_rport(bsg_job);
@@ -329,9 +329,9 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 		/* make sure the rport is logged in,
 		 * if not perform fabric login
 		 */
-		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
+		if (atomic_read(&fcport->state) != FCS_ONLINE) {
 			ql_dbg(ql_dbg_user, vha, 0x7003,
-			    "Failed to login port %06X for ELS passthru.\n",
+			    "Port %06X is not online for ELS passthru.\n",
 			    fcport->d_id.b24);
 			rval = -EIO;
 			goto done;
@@ -348,6 +348,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 			goto done;
 		}
 
+		qla_port_allocated = 1;
 		/* Initialize all required  fields of fcport */
 		fcport->vha = vha;
 		fcport->d_id.b.al_pa =
@@ -432,7 +433,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_request->msgcode != FC_BSG_RPT_ELS)
+	if (qla_port_allocated)
 		qla2x00_free_fcport(fcport);
 done:
 	return rval;
-- 
2.19.0.rc0

