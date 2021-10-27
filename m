Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FA9C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F7B61052
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241491AbhJ0KCs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 06:02:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19236 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241514AbhJ0KCK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 06:02:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R6I99J032380
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Jr+fogWXa/2YKJqBG36LMZU7x0+3zTsFNZArZs4PWCs=;
 b=aCcDBADv1fHGub3DR90rUptdmUQN7JALQQKmjmvTQupgtu/nySnSA6wY+1JYGzMImU3k
 mwjxX0o0/7BalKvd47JHGSja/LSUnIy+9RZnHUFbCzgSxbbNx2QXmROjpNe/Bx9cvDFM
 qtLrIv+2xNFpFZM4Ix1fRxzPd7jP6jZz6AS11FOSpnjx2aQH2qIMMCSDaMywDq6he/Qy
 0Wh3YIyh2jD9V7JZL1lfjmFTHP7YhJBhKm6ZwcbfLSvTx0tWibKTQFDJlQamv1xL/rlm
 AV+24CIj/+iTGyI08TmUNxSKQcg57AGOafCxoLUgfpZhHRH7aNwF+8ggJRsNchVFDa+s TA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1ca8tjs-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:45 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 02:59:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 02:59:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5C9FA3F706D;
        Wed, 27 Oct 2021 02:59:41 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19R9xfCb016445;
        Wed, 27 Oct 2021 02:59:41 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19R9xfjN016444;
        Wed, 27 Oct 2021 02:59:41 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 12/13] qla2xxx: edif: fix edif bsg
Date:   Wed, 27 Oct 2021 02:58:50 -0700
Message-ID: <20211027095851.16362-13-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211027095851.16362-1-njavali@marvell.com>
References: <20211027095851.16362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: n6uAlaBpnlsRZV_l57uDyPQ-Tr-E7eFE
X-Proofpoint-ORIG-GUID: n6uAlaBpnlsRZV_l57uDyPQ-Tr-E7eFE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Various EDIF bsg's did not properly fill out the reply_payload_rcv_len
field. This cause app to parse empty data in the return payload.

Fixes: 7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 49 ++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 74a1656e696d..84cc6103ae9b 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -541,14 +541,14 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	appreply.edif_enode_active = vha->pur_cinfo.enode_flags;
 	appreply.edif_edb_active = vha->e_dbell.db_flags;
 
-	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
-	    sizeof(struct app_start_reply);
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 
 	SET_DID_STATUS(bsg_reply->result, DID_OK);
 
-	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, &appreply,
-	    sizeof(struct app_start_reply));
+	bsg_reply->reply_payload_rcv_len = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+							       bsg_job->reply_payload.sg_cnt,
+							       &appreply,
+							       sizeof(struct app_start_reply));
 
 	ql_dbg(ql_dbg_edif, vha, 0x911d,
 	    "%s app start completed with 0x%x\n",
@@ -745,9 +745,10 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 errstate_exit:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, &appplogireply,
-	    sizeof(struct app_plogi_reply));
+	bsg_reply->reply_payload_rcv_len = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+							       bsg_job->reply_payload.sg_cnt,
+							       &appplogireply,
+							       sizeof(struct app_plogi_reply));
 
 	return rval;
 }
@@ -830,7 +831,7 @@ static int
 qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 {
 	int32_t			rval = 0;
-	int32_t			num_cnt;
+	int32_t			pcnt = 0;
 	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
 	struct app_pinfo_req	app_req;
 	struct app_pinfo_reply	*app_reply;
@@ -842,16 +843,14 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	    bsg_job->request_payload.sg_cnt, &app_req,
 	    sizeof(struct app_pinfo_req));
 
-	num_cnt = app_req.num_ports;	/* num of ports alloc'd by app */
-
 	app_reply = kzalloc((sizeof(struct app_pinfo_reply) +
-	    sizeof(struct app_pinfo) * num_cnt), GFP_KERNEL);
+	    sizeof(struct app_pinfo) * app_req.num_ports), GFP_KERNEL);
+
 	if (!app_reply) {
 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
 		rval = -1;
 	} else {
 		struct fc_port	*fcport = NULL, *tf;
-		uint32_t	pcnt = 0;
 
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			if (!(fcport->flags & FCF_FCSP_DEVICE))
@@ -920,9 +919,11 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		SET_DID_STATUS(bsg_reply->result, DID_OK);
 	}
 
-	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, app_reply,
-	    sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) * num_cnt);
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	bsg_reply->reply_payload_rcv_len = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+							       bsg_job->reply_payload.sg_cnt,
+							       app_reply,
+							       sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) * pcnt);
 
 	kfree(app_reply);
 
@@ -939,10 +940,11 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 {
 	int32_t			rval = 0;
 	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
-	uint32_t ret_size, size;
+	uint32_t size;
 
 	struct app_sinfo_req	app_req;
 	struct app_stats_reply	*app_reply;
+	uint32_t pcnt = 0;
 
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, &app_req,
@@ -958,18 +960,12 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	size = sizeof(struct app_stats_reply) +
 	    (sizeof(struct app_sinfo) * app_req.num_ports);
 
-	if (size > bsg_job->reply_payload.payload_len)
-		ret_size = bsg_job->reply_payload.payload_len;
-	else
-		ret_size = size;
-
 	app_reply = kzalloc(size, GFP_KERNEL);
 	if (!app_reply) {
 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
 		rval = -1;
 	} else {
 		struct fc_port	*fcport = NULL, *tf;
-		uint32_t	pcnt = 0;
 
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			if (fcport->edif.enable) {
@@ -993,9 +989,11 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		SET_DID_STATUS(bsg_reply->result, DID_OK);
 	}
 
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len =
 	    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-	       bsg_job->reply_payload.sg_cnt, app_reply, ret_size);
+	       bsg_job->reply_payload.sg_cnt, app_reply,
+	       sizeof(struct app_stats_reply) + (sizeof(struct app_sinfo) * pcnt));
 
 	kfree(app_reply);
 
@@ -1069,8 +1067,7 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 		    __func__,
 		    bsg_request->rqst_data.h_vendor.vendor_cmd[1]);
 		rval = EXT_STATUS_INVALID_PARAM;
-		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		done = false;
 		break;
 	}
 
-- 
2.19.0.rc0

