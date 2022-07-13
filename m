Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5D8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiGMFVM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiGMFVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:21:00 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E17D4459
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:59 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2Lj1W025309
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=leTHu1//1ZZMs5Do+5Cr+P7YZT1ZrG3rKH/niQkQWPY=;
 b=UFBmTKlGZ0b/H9L2BnTXbtR8euHvCT3eEi5bMHU3Wenlh+eSYdxtz4SYL7+Lw3AtBGFM
 /BFTtwybUfnnM4NZBIoVcMzOeu0I8iQmDu3ztx7toGYjG8dBdbeA8WQELzCTLvHfSrkn
 lUALyEgKo6DPSo0s+nIQw48Oel6VIBCNtnYsNMGAMDX16VQm7zM8ZYzYkRMIjh0hsUc7
 GKniI/t/FJKv3eUFLirJtjU5vIxikUKtCDweU/fCGoiTWcwdPf3nxVt7SsbMLSGP9yXZ
 O+DiIS2FdLesQEnbQUwMg/aImvIGR8CHkWbsWCTxHGCVplGSqb+pXBPE+ZYKEPF0cRto 9g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0h-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jul
 2022 22:20:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 54E4E3F70BE;
        Tue, 12 Jul 2022 22:20:55 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/10] qla2xxx: Fix imbalance vha->vref_count
Date:   Tue, 12 Jul 2022 22:20:41 -0700
Message-ID: <20220713052045.10683-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: V-fcwRpEKtla8mugqfFHVlDIxUMVJDGj
X-Proofpoint-GUID: V-fcwRpEKtla8mugqfFHVlDIxUMVJDGj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

vref_count took an extra decrement in the task management path.
Add an extra ref count to compensate the imbalance.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 15fb5ed565c0..83fae4c341ee 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -168,6 +168,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	struct srb_iocb *abt_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
+	uint8_t bail;
 
 	/* ref: INIT for ABTS command */
 	sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
@@ -175,6 +176,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	if (!sp)
 		return QLA_MEMORY_ALLOC_FAILED;
 
+	QLA_VHA_MARK_BUSY(vha, bail);
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
@@ -2018,12 +2020,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	struct srb_iocb *tm_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
+	uint8_t bail;
 
 	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
+	QLA_VHA_MARK_BUSY(vha, bail);
 	sp->type = SRB_TM_CMD;
 	sp->name = "tmf";
 	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),
-- 
2.19.0.rc0

