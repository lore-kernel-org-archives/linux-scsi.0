Return-Path: <SRS0=dBT0=W2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03773C41514
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7B6223439
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="r90NmUCq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfH3WYQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Aug 2019 18:24:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38870 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728199AbfH3WYP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Aug 2019 18:24:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UMJjEM006175;
        Fri, 30 Aug 2019 15:24:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=fUI+br7gWO0Thwzb5cqo/zNUahFTGkBbTySOSPGo8Ew=;
 b=r90NmUCqBrfq8rnb04R0oIxSnDJZY9g1MQSgAOEowmT7HhUKepRum1+NUtO2KKUa/y2R
 qF/qn43TrajzATAc1IwJ+UOOiS8dLw4PChX4xQdy23XALX+URvYB89IiiPTxMWnqtxQk
 Rhn8IH+AzfIuL9qrNNqemNUK+ULcneR27tWz13efD9cjZG0grgoYRY9ghRf8jeheFsZw
 dRBurWmGQusINiKH1H6FZaegqKm+Y7oa3lW2dbTYUBNq9EMcFchvkzlur6GfiMQUwQV6
 HcmBX+4i1QEDA1YoyS5MioKtigAki+Fwi9sO+TRcR6sI8zNZ75F9yHBe7mnAQWl+HVTo 9g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2upmepn44a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:24:14 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 15:24:12 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 15:24:12 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 348063F703F;
        Fri, 30 Aug 2019 15:24:12 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7UMOBKK023735;
        Fri, 30 Aug 2019 15:24:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7UMOBeP023734;
        Fri, 30 Aug 2019 15:24:11 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 3/6] qla2xxx: Fix driver reload for ISP82xx
Date:   Fri, 30 Aug 2019 15:23:59 -0700
Message-ID: <20190830222402.23688-4-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190830222402.23688-1-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_09:2019-08-29,2019-08-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

HINT_MBX_INT_PENDING is not guaranteed to be cleared by
firmware. Remove check that prevent driver load with ISP82XX.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 16 ++--------------
 drivers/scsi/qla2xxx/qla_nx.c  |  3 ++-
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a82b6db2fa9d..4c858e2d0ea8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -253,21 +253,9 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	if ((!abort_active && io_lock_on) || IS_NOPOLLING_TYPE(ha)) {
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
-		if (IS_P3P_TYPE(ha)) {
-			if (RD_REG_DWORD(&reg->isp82.hint) &
-				HINT_MBX_INT_PENDING) {
-				ha->flags.mbox_busy = 0;
-				spin_unlock_irqrestore(&ha->hardware_lock,
-					flags);
-
-				atomic_dec(&ha->num_pend_mbx_stage2);
-				ql_dbg(ql_dbg_mbx, vha, 0x1010,
-				    "Pending mailbox timeout, exiting.\n");
-				rval = QLA_FUNCTION_TIMEOUT;
-				goto premature_exit;
-			}
+		if (IS_P3P_TYPE(ha))
 			WRT_REG_DWORD(&reg->isp82.hint, HINT_MBX_INT_PENDING);
-		} else if (IS_FWI2_CAPABLE(ha))
+		else if (IS_FWI2_CAPABLE(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index a79f8da38abe..2b2028f2383e 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2287,7 +2287,8 @@ qla82xx_disable_intrs(struct qla_hw_data *ha)
 {
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
-	qla82xx_mbx_intr_disable(vha);
+	if (ha->interrupts_on)
+		qla82xx_mbx_intr_disable(vha);
 
 	spin_lock_irq(&ha->hardware_lock);
 	if (IS_QLA8044(ha))
-- 
2.12.0

