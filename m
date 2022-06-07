Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65B4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbiFGEq7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbiFGEqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D333AD31A0
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:44 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXafr025411
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=kh4du7gVLr3Fz6ydJ847kIBv+HBsk0wX6lVh+AkOMlI=;
 b=KByAIZc41r7yx4Yu1imqNgkeD9nIHNQacSieNt5K9rnQVC3j+IEb6DKsA9u6rh+0oPsH
 eqId4y58gxBLHHBPi7ko4DVXvn4bxw4Epf5oLlhUNSXULFgPPDW3ubVarlOuAe1dyS6B
 yDJju42gzGxTdJDj67uRNQnfvIqDUOBBmi7tpsZ7akB3MyUydeMZfcl+3U2Rihk7dsVE
 f9fgTmpHrtFc7HN4Cg5LNm5Um2iFYVuKYHfdlyKds5wl4xiKHepz5n6FNtQ5dy92JNSX
 qccQR6RZtgLUspGJIime+e9UQUrMxDSekuQaDR/FcRBUcj+mkYZ59Z4UbatdGD6pYHPq qA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8e-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jun
 2022 21:46:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6D79E3F7069;
        Mon,  6 Jun 2022 21:46:41 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/11] qla2xxx: edif: add retry for els pass through
Date:   Mon, 6 Jun 2022 21:46:23 -0700
Message-ID: <20220607044627.19563-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: csNSxZqbFRe8AhcASQo3zwYl0mMZ5Pm_
X-Proofpoint-GUID: csNSxZqbFRe8AhcASQo3zwYl0mMZ5Pm_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Relating to EDIF, when sending IKE message, updating
key or deleting key, driver can encounter IOCB queue full. Add
additional retries to reduce higher level recovery.

Fixes: dd30706e73b70 ("scsi: qla2xxx: edif: Add key update")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 52 +++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_os.c   |  2 +-
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index c9f6ec49b0b4..142feda0381f 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1467,6 +1467,8 @@ qla24xx_check_sadb_avail_slot(struct bsg_job *bsg_job, fc_port_t *fcport,
 
 #define QLA_SA_UPDATE_FLAGS_RX_KEY      0x0
 #define QLA_SA_UPDATE_FLAGS_TX_KEY      0x2
+#define EDIF_MSLEEP_INTERVAL 100
+#define EDIF_RETRY_COUNT  50
 
 int
 qla24xx_sadb_update(struct bsg_job *bsg_job)
@@ -1479,7 +1481,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	struct edif_list_entry *edif_entry = NULL;
 	int			found = 0;
 	int			rval = 0;
-	int result = 0;
+	int result = 0, cnt;
 	struct qla_sa_update_frame sa_frame;
 	struct srb_iocb *iocb_cmd;
 	port_id_t portid;
@@ -1720,11 +1722,23 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	sp->done = qla2x00_bsg_job_done;
 	iocb_cmd = &sp->u.iocb_cmd;
 	iocb_cmd->u.sa_update.sa_frame  = sa_frame;
-
+	cnt = 0;
+retry:
 	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS) {
+	switch (rval) {
+	case QLA_SUCCESS:
+		break;
+	case EAGAIN:
+		msleep(EDIF_MSLEEP_INTERVAL);
+		cnt++;
+		if (cnt < EDIF_RETRY_COUNT)
+			goto retry;
+
+		fallthrough;
+	default:
 		ql_log(ql_dbg_edif, vha, 0x70e3,
-		    "qla2x00_start_sp failed=%d.\n", rval);
+		       "%s qla2x00_start_sp failed=%d.\n",
+		       __func__, rval);
 
 		qla2x00_rel_sp(sp);
 		rval = -EIO;
@@ -2398,7 +2412,6 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	rval = qla2x00_start_sp(sp);
 
 	if (rval != QLA_SUCCESS) {
-		rval = QLA_FUNCTION_FAILED;
 		goto done_free_sp;
 	}
 
@@ -3530,7 +3543,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	fc_port_t *fcport = NULL;
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
-	int rval =  (DID_ERROR << 16);
+	int rval =  (DID_ERROR << 16), cnt;
 	port_id_t d_id;
 	struct qla_bsg_auth_els_request *p =
 	    (struct qla_bsg_auth_els_request *)bsg_job->request;
@@ -3625,17 +3638,26 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	sp->free = qla2x00_bsg_sp_free;
 	sp->done = qla2x00_bsg_job_done;
 
+	cnt = 0;
+retry:
 	rval = qla2x00_start_sp(sp);
-
-	ql_dbg(ql_dbg_edif, vha, 0x700a,
-	    "%s %s %8phN xchg %x ctlflag %x hdl %x reqlen %xh bsg ptr %p\n",
-	    __func__, sc_to_str(p->e.sub_cmd), fcport->port_name,
-	    p->e.extra_rx_xchg_address, p->e.extra_control_flags,
-	    sp->handle, sp->remap.req.len, bsg_job);
-
-	if (rval != QLA_SUCCESS) {
+	switch (rval) {
+	case QLA_SUCCESS:
+		ql_dbg(ql_dbg_edif, vha, 0x700a,
+		       "%s %s %8phN xchg %x ctlflag %x hdl %x reqlen %xh bsg ptr %p\n",
+		       __func__, sc_to_str(p->e.sub_cmd), fcport->port_name,
+		       p->e.extra_rx_xchg_address, p->e.extra_control_flags,
+		       sp->handle, sp->remap.req.len, bsg_job);
+		break;
+	case EAGAIN:
+		msleep(EDIF_MSLEEP_INTERVAL);
+		cnt++;
+		if (cnt < EDIF_RETRY_COUNT)
+			goto retry;
+		fallthrough;
+	default:
 		ql_log(ql_log_warn, vha, 0x700e,
-		    "qla2x00_start_sp failed = %d\n", rval);
+		    "%s qla2x00_start_sp failed = %d\n", __func__, rval);
 		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
 		rval = -EIO;
 		goto done_free_remap_rsp;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 73073fb08369..4f3125b826c4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5472,7 +5472,7 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 			    e->u.fcport.fcport, false);
 			break;
 		case QLA_EVT_SA_REPLACE:
-			qla24xx_issue_sa_replace_iocb(vha, e);
+			rc = qla24xx_issue_sa_replace_iocb(vha, e);
 			break;
 		}
 
-- 
2.19.0.rc0

