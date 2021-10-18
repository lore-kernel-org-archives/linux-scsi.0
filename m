Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB09C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DA8560174
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhJRM3O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:29:14 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:40186 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229843AbhJRM3N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 08:29:13 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7F48141206;
        Mon, 18 Oct 2021 12:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1634560020; x=
        1636374421; bh=SPDSUZyQ+LkQQv0yTHGMYMcsB0vdKmmmorWkm9qTSjI=; b=c
        Bs0N10m/jNemmZOFMaunnythey9+QJNYvipj58VYaLYIBZhqzFY4MN5m1V4ArNh3
        bn9o5BgZgFM5on/dAc6QpNLnTz0/zqHuiv1Ik+V8EUC+pMdzqaz883GWtzuGAwXT
        MhWYqdCfsQoZswzxaVQh0MjP4aPUv9cG84Pw9hIb0Q=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0PAGD45EFvas; Mon, 18 Oct 2021 15:27:00 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C6588400F6;
        Mon, 18 Oct 2021 15:26:59 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.10.157) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Oct 2021 15:26:58 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH RESEND] scsi: qla2xxx: fix unmap already freed sgl
Date:   Mon, 18 Oct 2021 15:26:50 +0300
Message-ID: <20211018122650.11846-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.10.157]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sgl is freed in the target stack in target_release_cmd_kref before
calling qlt_free_cmd, but there is an unmap of sgl in qlt_free_cmd that
causes such a panic if sgl is not yet DMA unmapped:

NIP dma_direct_unmap_sg+0xdc/0x180
LR  dma_direct_unmap_sg+0xc8/0x180
Call Trace:
 ql_dbg_prefix+0x68/0xc0 [qla2xxx] (unreliable)
 dma_unmap_sg_attrs+0x54/0xf0
 qlt_unmap_sg.part.19+0x54/0x1c0 [qla2xxx]
 qlt_free_cmd+0x124/0x1d0 [qla2xxx]
 tcm_qla2xxx_release_cmd+0x4c/0xa0 [tcm_qla2xxx]
 target_put_sess_cmd+0x198/0x370 [target_core_mod]
 transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
 tcm_qla2xxx_complete_free+0x6c/0x90 [tcm_qla2xxx]

SGL may be left unmapped in error cases of response sending.
For instance, qlt_rdy_to_xfer maps sgl and exits when sesssion is being
deleted keeping sgl mapped.

This patch removes use-after-free of sgl, and ensures that sgl is
unmapped for the cmd that was not send to FW.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
This patchset is intended for scsi-fix.
---
 drivers/scsi/qla2xxx/qla_target.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b3478ed9b12e..7d8242c120fc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3319,8 +3319,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			"RESET-RSP online/active/old-count/new-count = %d/%d/%d/%d.\n",
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return 0;
+		goto out_unmap_unlock;
 	}
 
 	/* Does F/W have an IOCBs for this request */
@@ -3445,10 +3444,6 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	prm.sg = NULL;
 	prm.req_cnt = 1;
 
-	/* Calculate number of entries and segments required */
-	if (qlt_pci_map_calc_cnt(&prm) != 0)
-		return -EAGAIN;
-
 	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		/*
@@ -3466,6 +3461,10 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 		return 0;
 	}
 
+	/* Calculate number of entries and segments required */
+	if (qlt_pci_map_calc_cnt(&prm) != 0)
+		return -EAGAIN;
+
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	/* Does F/W have an IOCBs for this request */
 	res = qlt_check_reserve_free_req(qpair, prm.req_cnt);
@@ -3870,9 +3869,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 
 	BUG_ON(cmd->cmd_in_wq);
 
-	if (cmd->sg_mapped)
-		qlt_unmap_sg(cmd->vha, cmd);
-
 	if (!cmd->q_full)
 		qlt_decr_num_pend_cmds(cmd->vha);
 
-- 
2.25.1

