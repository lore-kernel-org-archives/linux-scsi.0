Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED7AC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 09:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D00DA21D7A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 09:59:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="g2YP1S8s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgIHJ7E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 05:59:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52324 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728828AbgIHJ7E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 05:59:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0889p6Rl002554;
        Tue, 8 Sep 2020 02:58:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=g7EJ0ES+qzVmtE56onOJLs0Go+C/M6IL3HMq7BqnnlM=;
 b=g2YP1S8sw7deX+woONcvAumfj2REZP7FKZr+LJqbJn6UQs0B4xdnAKRTYDthroSHFyAt
 ZuqVOw515FRlOpVSnW8FA24fmUAz5JBKU11kncB+4UqUTaHul1+5vqgGfbyRXUh7hOIm
 lc1Eir8Es+rixRhV7gVduF6HaDZ8Sa1R7XWFwthCJqW4nJE0wnqiJHemBfZb2+Oj1h/k
 OzmWE1SJXYCeYej/BWFqvM3TyHndeiAtKZfiNAjarmAUYQmQYdKjpbzhmAFc27aw8Lr3
 2uvsj+vRyzwz06f7xiBiXPRsMnE/c9IMHEPfGEnkYJDyyjfhEEJqLNfh2WQAJJvxL/bk kQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pu0tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 02:58:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep
 2020 02:58:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Sep 2020 02:58:58 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 666EF3F703F;
        Tue,  8 Sep 2020 02:58:58 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0889wwip026888;
        Tue, 8 Sep 2020 02:58:58 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0889wweR026887;
        Tue, 8 Sep 2020 02:58:58 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 4/8] qedi: Protect active command list to avoid list corruption
Date:   Tue, 8 Sep 2020 02:56:53 -0700
Message-ID: <20200908095657.26821-5-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200908095657.26821-1-mrangankar@marvell.com>
References: <20200908095657.26821-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_05:2020-09-08,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

Protect active command list for non i/o commands like,
login response, logout response, text response and recovery
cleanup of active list to avoid list corruption.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 8 ++++++++
 drivers/scsi/qedi/qedi_iscsi.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 34c477bda8a4..f158fde0a43c 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -59,6 +59,7 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
 
+	spin_lock(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
@@ -69,6 +70,7 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 			  cmd->task_id, qedi_conn->iscsi_conn_id,
 			  &cmd->io_cmd);
 	}
+	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
@@ -122,6 +124,7 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
 
+	spin_lock(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
@@ -132,6 +135,7 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 			  cmd->task_id, qedi_conn->iscsi_conn_id,
 			  &cmd->io_cmd);
 	}
+	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
@@ -222,11 +226,13 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 
 	tmf_hdr = (struct iscsi_tm *)qedi_cmd->task->hdr;
 
+	spin_lock(&qedi_conn->list_lock);
 	if (likely(qedi_cmd->io_cmd_in_list)) {
 		qedi_cmd->io_cmd_in_list = false;
 		list_del_init(&qedi_cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
+	spin_unlock(&qedi_conn->list_lock);
 
 	if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
 	      ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
@@ -288,11 +294,13 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 		  ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
 	qedi_conn->gen_pdu.resp_wr_ptr = qedi_conn->gen_pdu.resp_buf + pld_len;
 
+	spin_lock(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
+	spin_unlock(&qedi_conn->list_lock);
 
 	memset(task_ctx, '\0', sizeof(*task_ctx));
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index f815845fc568..ae86a40ca040 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -975,11 +975,13 @@ static void qedi_cleanup_active_cmd_list(struct qedi_conn *qedi_conn)
 {
 	struct qedi_cmd *cmd, *cmd_tmp;
 
+	spin_lock(&qedi_conn->list_lock);
 	list_for_each_entry_safe(cmd, cmd_tmp, &qedi_conn->active_cmd_list,
 				 io_cmd) {
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
+	spin_unlock(&qedi_conn->list_lock);
 }
 
 static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
-- 
2.25.0

