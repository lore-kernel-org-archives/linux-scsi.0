Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E55C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 12:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237197AbiERMfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 08:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbiERMee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 08:34:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918D419CB43;
        Wed, 18 May 2022 05:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E7FF615FE;
        Wed, 18 May 2022 12:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C26C34115;
        Wed, 18 May 2022 12:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652877003;
        bh=1W2LW1qZ7oq6x4+GTpFCSF5m4dT2h7TD7pOzJu6tlbQ=;
        h=From:To:Cc:Subject:Date:From;
        b=tvvUc004o1M0N15KzfsDYmjrS8rcIPOksrQMDp9pY4jfm5kvAhKceamFI8xHhV1ij
         JuGCG1Bk5et0IJEQg8ZNtqUpyHjrXc42UEx/se47t932gRHzIdPesJGzrK3PqaGMwL
         /OLLwtqRuF90paIS0+HG7Zlw9Gt7SINKPWueSM7prhCln5zDEpHScEH1o5H9dD2WbY
         dr9wBF/SERuvVdHgoVD0Tnix8gUrUdQFSipoGB20N9nDPN0n5Q2MKz1iosPc3beH1j
         toKbOORR5Tt78MuDY3wdALKrzHo3y/39RhoJAc6XAieMPfeIiL9OnNUpcIzliGmL+y
         BnqX4GH6KthQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gleb Chesnokov <Chesnokov.G@raidix.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/5] scsi: qla2xxx: Fix missed DMA unmap for aborted commands
Date:   Wed, 18 May 2022 08:29:56 -0400
Message-Id: <20220518123000.343787-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gleb Chesnokov <Chesnokov.G@raidix.com>

[ Upstream commit 26f9ce53817a8fd84b69a73473a7de852a24c897 ]

Aborting commands that have already been sent to the firmware can
cause BUG in qlt_free_cmd(): BUG_ON(cmd->sg_mapped)

For instance:

 - Command passes rdx_to_xfer state, maps sgl, sends to the firmware

 - Reset occurs, qla2xxx performs ISP error recovery, aborts the command

 - Target stack calls qlt_abort_cmd() and then qlt_free_cmd()

 - BUG_ON(cmd->sg_mapped) in qlt_free_cmd() occurs because sgl was not
   unmapped

Thus, unmap sgl in qlt_abort_cmd() for commands with the aborted flag set.

Link: https://lore.kernel.org/r/AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 97a0c2384aee..4b431ca55c96 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3639,6 +3639,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
+		if (cmd->sg_mapped)
+			qlt_unmap_sg(vha, cmd);
+
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/*
 		 * It's normal to see 2 calls in this path:
-- 
2.35.1

