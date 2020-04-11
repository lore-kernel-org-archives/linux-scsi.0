Return-Path: <SRS0=XSNP=53=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5120C2BA19
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF4C120CC7
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647375;
	bh=Nor3LFQx5gasX/TffxXutfOivoR3WUsiFJPiv1MKceg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WN+d2kA3JGRWHdehb6g76LrR34jbtLqvfTsVYX0Zp32L0du/nkurDzyRvD3127jIA
	 rXYCXcmcxTJ521pcKt6czXveKSqAf9ndoqevtLKnInk+1LwKP5Bx8NsFEmls+JY2cd
	 3u2zB61dJlkNyip+8gwmdRAQi8N4MQP+vJaY5peg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgDKXWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730368AbgDKXNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D2B20708;
        Sat, 11 Apr 2020 23:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646794;
        bh=Nor3LFQx5gasX/TffxXutfOivoR3WUsiFJPiv1MKceg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxKlm8zRYOcG8MJaHfEWDNPVmuVtuds7byNvMxGib2HRQSEATTfCZDHNI+TFju0m8
         n/0UIyUwhrLZnB+Wr1dfwqJPtbfXY6bmj6iq7YxP3O0De2LxQhqulZZxlZxjHuVgrd
         3vvyrNY8GQ/4JCYXnC4r9+MCrVgoXWoIBcVtynco=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 58/66] scsi: qla2xxx: Fix control flags for login/logout IOCB
Date:   Sat, 11 Apr 2020 19:11:55 -0400
Message-Id: <20200411231203.25933-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit 419ae5fe73e50084fa794934fb62fab34f564b7c ]

This patch fixes control flag options for login/logout IOCB.

Link: https://lore.kernel.org/r/20200212214436.25532-23-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7e47321e003c8..f07aa045f3f93 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2224,6 +2224,8 @@ qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
+	logio->control_flags = cpu_to_le16(LCF_COMMAND_PLOGI);
+
 	if (lio->u.logio.flags & SRB_LOGIN_PRLI_ONLY) {
 		logio->control_flags = cpu_to_le16(LCF_COMMAND_PRLI);
 	} else {
@@ -2663,7 +2665,6 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	sp->fcport = fcport;
 
 	elsio->timeout = qla2x00_els_dcmd2_iocb_timeout;
-	init_completion(&elsio->u.els_plogi.comp);
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
@@ -2673,7 +2674,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	elsio->u.els_plogi.tx_size = elsio->u.els_plogi.rx_size = DMA_POOL_SIZE;
 
 	ptr = elsio->u.els_plogi.els_plogi_pyld =
-	    dma_alloc_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+	    dma_alloc_coherent(&ha->pdev->dev, elsio->u.els_plogi.tx_size,
 		&elsio->u.els_plogi.els_plogi_pyld_dma, GFP_KERNEL);
 	ptr_dma = elsio->u.els_plogi.els_plogi_pyld_dma;
 
@@ -2683,7 +2684,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	}
 
 	resp_ptr = elsio->u.els_plogi.els_resp_pyld =
-	    dma_alloc_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+	    dma_alloc_coherent(&ha->pdev->dev, elsio->u.els_plogi.rx_size,
 		&elsio->u.els_plogi.els_resp_pyld_dma, GFP_KERNEL);
 
 	if (!elsio->u.els_plogi.els_resp_pyld) {
@@ -2707,6 +2708,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
 	    sizeof(*elsio->u.els_plogi.els_plogi_pyld));
 
+	init_completion(&elsio->u.els_plogi.comp);
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
-- 
2.20.1

