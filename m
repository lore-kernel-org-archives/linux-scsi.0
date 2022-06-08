Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743F8C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbiFHL7N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbiFHL7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:59:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462B524D697
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:59:10 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2581X4Nf020925
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:59:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Bsbo1D5sMvFbU9uRpE+tZ97rl11UlbRkgkU8Ydyi6Mc=;
 b=Z84U1C76OQkmpWAvXn7LSlMLRm0yifIRRRqGlKwIb05hlLCwXmz+p811934bqk6InmS6
 /dzC5HeEJOn10NLFoWybqICAE/OJiWvxhPpdsB2hjUdHW0nOehAfEGX2vGc/KJ53SNiX
 YFBmEyLpxICjH0NqKPX2x90iSAdqqjDrwElXGetZlnTGAUbNRsvz/EI9Lpw+NsHpEA4l
 XCh++/RdKwuPclskgCuMagdZWQzD27fAr12dCd7SWdW/oZUbIuBs0zGC5pWPe3EwTpug
 Om62Sz8fwuDoHbJYJZa6a0iAUbBDsK71w10zSOLcL0a4VUf6cM2a++4xHJt5Hsp/vciW 7A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gjb7pbsag-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:59:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Jun
 2022 04:58:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A75153F7086;
        Wed,  8 Jun 2022 04:58:55 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 01/10] qla2xxx: edif: Fix IO timeout due to over subscription
Date:   Wed, 8 Jun 2022 04:58:40 -0700
Message-ID: <20220608115849.16693-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: xu6dnd1fqlHgS_bUDz6Dq92-PnE1CUJF
X-Proofpoint-ORIG-GUID: xu6dnd1fqlHgS_bUDz6Dq92-PnE1CUJF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Current edif code does not keep track of FW IOCB resources.
This led to IOCB queue full on error recovery (IO timeout).
This patch make use of the existing code that track IOCB
resources to prevent over subscription of IOCB resources.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 18eb8d63e37c..6a16e16e39f5 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2951,6 +2951,12 @@ qla28xx_start_scsi_edif(srb_t *sp)
 
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.iocb_cnt = req_cnt;
+	if (qla_get_iocbs(sp->qpair, &sp->iores))
+		goto queuing_error;
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    rd_reg_dword(req->req_q_out);
@@ -3142,6 +3148,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
 		mempool_free(sp->u.scmd.ct6_ctx, ha->ctx_mempool);
 		sp->u.scmd.ct6_ctx = NULL;
 	}
+	qla_put_iocbs(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(lock, flags);
 
 	return QLA_FUNCTION_FAILED;
-- 
2.19.0.rc0

