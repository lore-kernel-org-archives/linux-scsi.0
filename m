Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B73EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA0161158
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352348AbhIHQsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:48:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23270 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240734AbhIHQsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 12:48:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1889r43u000993;
        Wed, 8 Sep 2021 09:47:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=f8nU5MVrANQW+jvSrrMZ9InIVA2MYfOchW7Xp/W03jI=;
 b=eSVfacrznNrNlFWW5wgNpH9VLQfxWO4GmHjtny/hY/bYlhD9BQoruxdVjrPSzKyBRfXG
 PauLN2BxKlncIwraCE3hbo8NXCW+DU3Q0/X6S02gOc6UggcJc3s+2FNH/wXZgAk/YYwr
 JXfi0SBz4Ujl7bbuKXG0+CjIASSCZpKr3mcZcHhcoAbheuTYouNlXVsV90XAhHcUUrZf
 XDSGRVFDnXod0yyZJc6Lj9U38N5wt1uErxBMy8mEUKXnEt/97ojU6REPihAIkdqabY/R
 X3eMnVT2BRnaERCCofFq2q+Vlja/6O3SuLpL8qvVPGkhC3RfiWAZHKInhC9bBlHXtrKh uA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3axtxc1kh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:47:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Sep
 2021 09:47:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Sep 2021 09:47:38 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9D6F33F70A7;
        Wed,  8 Sep 2021 09:47:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 188Glc9G019311;
        Wed, 8 Sep 2021 09:47:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 188Glc3s019310;
        Wed, 8 Sep 2021 09:47:38 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <djeffery@redhat.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 07/10] qla2xxx: Call process_response_queue() in Tx path
Date:   Wed, 8 Sep 2021 09:46:19 -0700
Message-ID: <20210908164622.19240-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210908164622.19240-1-njavali@marvell.com>
References: <20210908164622.19240-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: TvfCWTPIgLqEfk4_uTxS2euF51plDXZ9
X-Proofpoint-GUID: TvfCWTPIgLqEfk4_uTxS2euF51plDXZ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_06,2021-09-07_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shreyas Deodhar <sdeodhar@marvell.com>

Process responses in Tx path if any available for better performance.

Fixes: e84067d743010 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and
		      transport registration”)
Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar<sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 877b2b625020..0ae1e081cb03 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -399,6 +399,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	uint16_t	avail_dsds;
 	struct dsd64	*cur_dsd;
 	struct req_que *req = NULL;
+	struct rsp_que *rsp = NULL;
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_qpair *qpair = sp->qpair;
@@ -410,6 +411,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 
 	/* Setup qpair pointers */
 	req = qpair->req;
+	rsp = qpair->rsp;
 	tot_dsds = fd->sg_cnt;
 
 	/* Acquire qpair specific lock */
@@ -571,6 +573,10 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
+	if (vha->flags.process_response_queue &&
+	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha, rsp);
+
 queuing_error:
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
-- 
2.19.0.rc0

