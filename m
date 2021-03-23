Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4A3C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C35AC6199F
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCWEn4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:43:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229560AbhCWEnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:43:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4gASI003655
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:43:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=JGB4RhO0ObTJSw1jaih6KVIo5FHMe+xayMirN9VUh48=;
 b=N+/0grQEYU1ul5yWJanw8r0phhYlZkpeVisdHtoPU+dYizj7h1mmV7ynpHkXtFLDYwly
 w93qTEf/8LCSInOFJNS+y2SsuuAXrFxdyDt1FNK8FJYv1R8HJ4QXQemgX9nhrWokhJOP
 wggM2ECRwWGwBrWlqJ/VQ9P8MkKxYOk8JFZY9BO4HCDUC4XzWGmRpgsMtkFRhE7tNSiM
 Bkg+NVABmpC/UAI1vqGI0MZJii6EtCcvzLFlGfQoPluh/ZfCHb+UJHfaRDp0yEQdpbDl
 Yj3gTKMoijpwXM9kNFspnZlsJnNzAhIPZmyJtWFEtcIHontDDVsUX8nNRiFHBBv+c/jo JA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrfsjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:43:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:43:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:43:46 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4CE403F7041;
        Mon, 22 Mar 2021 21:43:46 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4hkdY026703;
        Mon, 22 Mar 2021 21:43:46 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4hkYJ026702;
        Mon, 22 Mar 2021 21:43:46 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 01/11] qla2xxx: Fix IOPS drop seen in some adapters
Date:   Mon, 22 Mar 2021 21:42:47 -0700
Message-ID: <20210323044257.26664-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Removing the response queue processing in the send path is showing IOPS
drop. Add back the process_response_queue() call in the send path.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
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

