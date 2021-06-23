Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941D5C4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AAED60BD3
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhFWKea (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 06:34:30 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47528 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhFWKe3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 06:34:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15NAW2Wn008698
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:32:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NIauq06p6TDDCH5SW/pRn2o0cA9UbsYooNj2WtXXiaI=;
 b=N6PXJ5B8VRcgf1uj865kgSUnsKfsYPwsISYaLIFssExagZ8SABmwuuD83AnglA4H3rSF
 ONg2Kf3ImkgewcwsjaVff2kwDDrsy41YZX4x8l5te5CFY9xiWodg3aPWfRx38ieX47RO
 n9VDpY12hxP//mLv/1HHlltxq2tTTfRzXb8akrBZ9jM38J/OaFKNtXOs1uksxY0/Pd0c
 nPdjp+Lvy7XEi8+xwN87CI/bU6lifjj3xmfxhwfiy9WQBZU3yfzrUP0mTCRRMyqEf+DZ
 j2zWW0R0BmrPPJHmC4fTuikmCExqP2ZLBnVP9yGIjHZNSKEXW/GDeRcGzBdFmWVvfiEJ ug== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39bptj2jg0-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:32:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Jun
 2021 03:30:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 23 Jun 2021 03:30:37 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9ED3E5B693E;
        Wed, 23 Jun 2021 03:30:37 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 15NAUbIi003801;
        Wed, 23 Jun 2021 03:30:37 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 15NAUbkE003799;
        Wed, 23 Jun 2021 03:30:37 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 10/11] qla2xxx: enable heartbeat validation for edif command
Date:   Wed, 23 Jun 2021 03:26:10 -0700
Message-ID: <20210623102611.3637-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210623102611.3637-1-njavali@marvell.com>
References: <20210623102611.3637-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DpQ0TzAOpcNsqO8aA5nQ1eQOc92-gIfA
X-Proofpoint-GUID: DpQ0TzAOpcNsqO8aA5nQ1eQOc92-gIfA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_03:2021-06-23,2021-06-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Increment the command and the completion counts.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 1 +
 drivers/scsi/qla2xxx/qla_isr.c  | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 8e730cc882e6..ccbe0e1bfcbc 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2926,6 +2926,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
 		req->ring_ptr++;
 	}
 
+	sp->qpair->cmd_cnt++;
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ce4f93fb4d25..e8928fd83049 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3192,10 +3192,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
-	sp->qpair->cmd_completion_cnt++;
-
 	/* Fast path completion. */
 	qla_chk_edif_rx_sa_delete_pending(vha, sp, sts24);
+	sp->qpair->cmd_completion_cnt++;
 
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
 		qla2x00_process_completed_request(vha, req, handle);
-- 
2.19.0.rc0

