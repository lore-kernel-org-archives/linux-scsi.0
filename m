Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBFAC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5059260F5E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237903AbhHQFO3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12860 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237592AbhHQFOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2lb7D006738
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=HDMjiF/yHznlpOMEdnOMG0i+Kz/vCnMzdyjfNhqMZqI=;
 b=DRQ9jAcXaL+pVvz++Ksfm//dqW3bQ58kDNK/DRBwMurnGdA/CIGAqbJ8/mBmlXAudbG5
 9RVwU37KuVPb+b92SZMV1y5pZT7XK8IaSoL99SYwSgbZeKGGEu/vcS83zev4G/XvGj91
 1NEe0dUg46xMX9mHUQ9nMVYTsY1M2dayoFUjZw6NN5DdefF8F5sGqUikhwoquqZoYcvC
 /GnS6Ff5Qq0UblD8pvtvbW/kU1t8DAKgYYetq6zBKL+vVXhdIWgYMCn81MR2WHsGdggh
 UUZBN9K1T5YIaRZaimYhew/FLsJQydqh62YMLvKNMG8MKn1/5hSJEJPXz2Bf7DeZsEeC ew== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0rdcv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:51 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 624333F70AE;
        Mon, 16 Aug 2021 22:13:51 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5Dpbo002540;
        Mon, 16 Aug 2021 22:13:51 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5DpVo002539;
        Mon, 16 Aug 2021 22:13:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/12] qla2xxx: fix NVME | FCP personality change
Date:   Mon, 16 Aug 2021 22:13:10 -0700
Message-ID: <20210817051315.2477-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 0cJx4Kci2hOg27gW947wBxJbb-_uON_Q
X-Proofpoint-ORIG-GUID: 0cJx4Kci2hOg27gW947wBxJbb-_uON_Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Currently driver saves the personality type (FCP|NVME) at the
start of first discovery of the remote device. If the remote device
personality do change over time, then qla driver needs to present
that to user to decide.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 1 +
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 11401cfc35a1..df6e3ef52e2c 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3502,6 +3502,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 				continue;
 			fcport->scan_state = QLA_FCPORT_FOUND;
 			fcport->last_rscn_gen = fcport->rscn_gen;
+			fcport->fc4_type = rp->fc4type;
 			found = true;
 			/*
 			 * If device was not a fabric device before.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7e6fb4ad4255..a70c68bb1d2d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1610,11 +1610,12 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u16 sec;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d8,
-	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d\n",
+	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d fc4type %x\n",
 	    __func__, fcport->port_name, fcport->disc_state,
 	    fcport->fw_login_state, fcport->login_pause, fcport->flags,
 	    fcport->conflict, fcport->last_rscn_gen, fcport->rscn_gen,
-	    fcport->login_gen, fcport->loop_id, fcport->scan_state);
+	    fcport->login_gen, fcport->loop_id, fcport->scan_state,
+	    fcport->fc4_type);
 
 	if (fcport->scan_state != QLA_FCPORT_FOUND)
 		return 0;
-- 
2.23.1

