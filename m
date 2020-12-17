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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8571CC2BBCA
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50DBE23437
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgLQGp2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:45:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49292 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgLQGp2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:45:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6UI0F164616;
        Thu, 17 Dec 2020 06:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=QtztLmncsKwWwSwW80/MG0QyYLS2ur2O0J5kNsNCA/Y=;
 b=BZM5AzM3H/Q4vSKJ2b6r8Au20qkKiN2YPAWAVxwrt+WYogSQoCTLeMBDyioRsYe7o66u
 y+l0ak3GAK1c04aC6I/PzQdEnsdBAfA4uta8sd7ixcC5GEZXRrOBcknsBcxeTYmU62n1
 9/fGYG9rgxzPargYEYOpcD/uXv7Ibd8CU9WCpHng7k+W4W/NNAsElAskkJdpFHrf519V
 ALPZX39roW1WqJny7YQQdZtczB9B4JXzMMUaCA5oj7Xvym32C7l/L13jqVIOGVIZr+AK
 NUeGJ1QC6YUuwUooWIgQXh+tt/AIvtOer7qSeq+P5hbJNIWcsuCHaQmzhsIqYFZaXOXA gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntmbujk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:44:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VFD1178222;
        Thu, 17 Dec 2020 06:42:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35e6jts20q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BH6gaQa019179;
        Thu, 17 Dec 2020 06:42:36 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:35 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 18/22] qedi: prep driver for switch to blk tags
Date:   Thu, 17 Dec 2020 00:42:08 -0600
Message-Id: <1608187332-4434-19-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently implement our own tagging which just adds another
layer of locks. For scsi cmds we can just use the block layer
tags. This patch preps qedi for this change by:

1. Having it use the correct itt to task look up function.
See below for info and question.

2. Using iscsi_complete_scsi_task when it has access to the task
instead of playing tricks with the itt which may not work with
multiple queues.

Question for Manish:

We are supposed to use iscsi_itt_to_ctask for scsi tasks and
iscsi_itt_to_task for iscsi "mgmt" tasks. The latter are nops,
login, logout, etc.

I could not tell if the !found cases in
qedi_process_cmd_cleanup_resp were for scsi cmds or mgmt ones.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 57 ++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2..d93a6b2 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -627,20 +627,15 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 
 	qedi_iscsi_unmap_sg_list(cmd);
 
-	hdr = (struct iscsi_scsi_rsp *)task->hdr;
-	hdr->opcode = cqe_data_in->opcode;
-	hdr->max_cmdsn = cpu_to_be32(cqe_data_in->max_cmd_sn);
-	hdr->exp_cmdsn = cpu_to_be32(cqe_data_in->exp_cmd_sn);
-	hdr->itt = build_itt(cqe->cqe_solicited.itid, conn->session->age);
-	hdr->response = cqe_data_in->reserved1;
-	hdr->cmd_status = cqe_data_in->status_rsvd;
-	hdr->flags = cqe_data_in->flags;
-	hdr->residual_count = cpu_to_be32(cqe_data_in->residual_count);
-
-	if (hdr->cmd_status == SAM_STAT_CHECK_CONDITION) {
+	sc_cmd->result = (DID_OK << 16) | cqe_data_in->status_rsvd;
+	if (cqe_data_in->reserved1 != ISCSI_STATUS_CMD_COMPLETED)
+		sc_cmd->result = DID_ERROR << 16;
+
+	if (cqe_data_in->status_rsvd == SAM_STAT_CHECK_CONDITION) {
 		datalen = cqe_data_in->reserved2 &
 			  ISCSI_COMMON_HDR_DATA_SEG_LEN_MASK;
-		memcpy((char *)conn->data, (char *)cmd->sense_buffer, datalen);
+		memcpy(sc_cmd->sense_buffer, cmd->sense_buffer,
+		       min(datalen, SCSI_SENSE_BUFFERSIZE));
 	}
 
 	/* If f/w reports data underrun err then set residual to IO transfer
@@ -653,9 +648,23 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 			  hdr->itt, cqe_data_in->flags, cmd->task_id,
 			  qedi_conn->iscsi_conn_id, hdr->residual_count,
 			  scsi_bufflen(sc_cmd));
-		hdr->residual_count = cpu_to_be32(scsi_bufflen(sc_cmd));
-		hdr->flags |= ISCSI_FLAG_CMD_UNDERFLOW;
-		hdr->flags &= (~ISCSI_FLAG_CMD_OVERFLOW);
+
+		cqe_data_in->residual_count = scsi_bufflen(sc_cmd);
+		cqe_data_in->flags |= ISCSI_FLAG_CMD_UNDERFLOW;
+		cqe_data_in->flags &= (~ISCSI_FLAG_CMD_OVERFLOW);
+	}
+
+	if (cqe_data_in->flags & (ISCSI_FLAG_CMD_UNDERFLOW |
+				  ISCSI_FLAG_CMD_OVERFLOW)) {
+		int res_count = cqe_data_in->residual_count;
+
+		if (res_count > 0 &&
+		    (cqe_data_in->flags & ISCSI_FLAG_CMD_OVERFLOW ||
+		    res_count <= scsi_bufflen(sc_cmd)))
+			scsi_set_resid(sc_cmd, res_count);
+		else
+			sc_cmd->result = (DID_BAD_TARGET << 16) |
+						cqe_data_in->status_rsvd;
 	}
 
 	spin_lock(&qedi_conn->list_lock);
@@ -674,8 +683,8 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		qedi_trace_io(qedi, task, cmd->task_id, QEDI_IO_TRACE_RSP);
 
 	qedi_clear_task_idx(qedi, cmd->task_id);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
-			     conn->data, datalen);
+	iscsi_complete_scsi_task(task, cqe_data_in->exp_cmd_sn,
+				 cqe_data_in->max_cmd_sn);
 error:
 	spin_unlock_bh(&session->back_lock);
 }
@@ -796,11 +805,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
 		    ISCSI_TM_FUNC_ABORT_TASK) {
 			spin_lock_bh(&conn->session->back_lock);
-
-			protoitt = build_itt(get_itt(tmf_hdr->rtt),
-					     conn->session->age);
-			task = iscsi_itt_to_task(conn, protoitt);
-
+			task = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
 			spin_unlock_bh(&conn->session->back_lock);
 
 			if (!task) {
@@ -1387,8 +1392,8 @@ static void qedi_tmf_work(struct work_struct *work)
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 
-	ctask = iscsi_itt_to_task(conn, tmf_hdr->rtt);
-	if (!ctask || !ctask->sc) {
+	ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
+	if (!ctask) {
 		QEDI_ERR(&qedi->dbg_ctx, "Task already completed\n");
 		goto abort_ret;
 	}
@@ -1520,8 +1525,8 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 
 	if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
 	     ISCSI_TM_FUNC_ABORT_TASK) {
-		ctask = iscsi_itt_to_task(conn, tmf_hdr->rtt);
-		if (!ctask || !ctask->sc) {
+		ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
+		if (!ctask) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Could not get reference task\n");
 			return 0;
-- 
1.8.3.1

