Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F8AC433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7807A61920
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbhC2IzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 04:55:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13846 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236329AbhC2IxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 04:53:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T8oKNi025294;
        Mon, 29 Mar 2021 01:53:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=XzqEGYCn2wjMKFnlhDrzTtBbGc8yto/T9mdFIhHNxx8=;
 b=dq0BrYblSOjP9vfvcl0ml2/qFj9JU5lVKQu6umvJwtKqydAG0qoBqVsrTxefY8kyOe2A
 zhbh+pvNRIwFLYAiK1US6rid64canMrOu0qVR3ijegkomwV8ggNw/UaeaXPCmaGs917D
 2jTn33ObEyHIygBmNBc6K8oRPNLWnYF828gZfQlTXjsSC+CwjpBQN3XacZz1bqqjmirb
 U+wDO2mFGHd0oNzFLYAHdTOFb5mohlYzNILAlx/GztsQPNzpgjimad7k5jA2hQYk5VC2
 pFD3rAPW128hDQnqtq8XFZRmD0VUTi1i3Vc3dmL19u5AAXvXoKpCwjXdeAJXLKf+ppmn Ew== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37j47p4asw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 01:53:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 01:53:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Mar 2021 01:53:18 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 368113F7044;
        Mon, 29 Mar 2021 01:53:18 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12T8rIRn004414;
        Mon, 29 Mar 2021 01:53:18 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12T8rIgO004413;
        Mon, 29 Mar 2021 01:53:18 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: [PATCH v2 01/12] qla2xxx: Fix IOPS drop seen in some adapters
Date:   Mon, 29 Mar 2021 01:52:18 -0700
Message-ID: <20210329085229.4367-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210329085229.4367-1-njavali@marvell.com>
References: <20210329085229.4367-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 9oxmaQ9HwBuA7FqXtEHGnN-mIpmtkCad
X-Proofpoint-ORIG-GUID: 9oxmaQ9HwBuA7FqXtEHGnN-mIpmtkCad
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_04:2021-03-26,2021-03-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Removing the response queue processing in the send path is showing IOPS
drop. Add back the process_response_queue() call in the send path.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8b41cbaf8535..f26a7a14fce9 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1600,12 +1600,14 @@ qla24xx_start_scsi(srb_t *sp)
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
 	struct req_que *req = NULL;
+	struct rsp_que *rsp;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 
 	/* Setup device pointers. */
 	req = vha->req;
+	rsp = req->rsp;
 
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
@@ -1707,6 +1709,11 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (vha->flags.process_response_queue &&
+	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha, rsp);
+
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
 
@@ -1897,6 +1904,11 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (vha->flags.process_response_queue &&
+	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha, rsp);
+
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_SUCCESS;
@@ -1931,6 +1943,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
 	struct req_que *req = NULL;
+	struct rsp_que *rsp;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
@@ -1941,6 +1954,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 
 	/* Setup qpair pointers */
 	req = qpair->req;
+	rsp = qpair->rsp;
 
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
@@ -2041,6 +2055,11 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (vha->flags.process_response_queue &&
+	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha, rsp);
+
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 	return QLA_SUCCESS;
 
-- 
2.19.0.rc0

