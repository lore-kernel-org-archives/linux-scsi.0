Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F08EE49AF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 12:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbjHVM1j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 08:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbjHVLhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 07:37:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2D3E5E;
        Tue, 22 Aug 2023 04:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 538376535C;
        Tue, 22 Aug 2023 11:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3082C433CA;
        Tue, 22 Aug 2023 11:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692704193;
        bh=WTD3lJunNv5sofpRbLtPclgLM1LNn+JnUh5Z8n1If3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uidtmBTy5SonAbrOCBTPXzb9gDBrMcknynBSteTENhEbjCSMI5uoUy0tQlXN/80wh
         gam7x99gnBnJufB2sXAD6ZFEYzeh/3MaQEQ9ibmlN1jR6KykKr+TspkuI2cAtbmeLq
         kdTkoQiRr06KwC1W6KZTidFGBkmjkP+XTugshH1bB1fkB6Rk6bbsOOxEwQcUvd3s0v
         QzUPI41GngZKfe4nrOMan1tnjSIOqMDDEoZCQEeuO1uEAb/9z6/A/0n3JAY/zNFS8K
         vspr9GUNyHSpUMAW6oEkdlUUvFyzj11LlQdQa6k8yAbQ1nkO3+NVPQwipw10iga9Dj
         GCaU3mnwfXUjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 03/10] scsi: lpfc: Remove reftag check in DIF paths
Date:   Tue, 22 Aug 2023 07:36:21 -0400
Message-Id: <20230822113628.3551393-3-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230822113628.3551393-1-sashal@kernel.org>
References: <20230822113628.3551393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.46
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 8eebf0e84f0614cebc7347f7bbccba4056d77d42 ]

When preparing protection DIF I/O for DMA, the driver obtains reference
tags from scsi_prot_ref_tag().  Previously, there was a wrong assumption
that an all 0xffffffff value meant error and thus the driver failed the
I/O.  This patch removes the evaluation code and accepts whatever the upper
layer returns.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20230803211932.155745-1-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 7a1563564df7f..7aac9fc719675 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -109,8 +109,6 @@ lpfc_sli4_set_rsp_sgl_last(struct lpfc_hba *phba,
 	}
 }
 
-#define LPFC_INVALID_REFTAG ((u32)-1)
-
 /**
  * lpfc_rampdown_queue_depth - Post RAMP_DOWN_QUEUE event to worker thread
  * @phba: The Hba for which this call is being executed.
@@ -978,8 +976,6 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	sgpe = scsi_prot_sglist(sc);
 	lba = scsi_prot_ref_tag(sc);
-	if (lba == LPFC_INVALID_REFTAG)
-		return 0;
 
 	/* First check if we need to match the LBA */
 	if (phba->lpfc_injerr_lba != LPFC_INJERR_LBA_OFF) {
@@ -1560,8 +1556,6 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command for pde*/
 	reftag = scsi_prot_ref_tag(sc);
-	if (reftag == LPFC_INVALID_REFTAG)
-		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -1723,8 +1717,6 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	/* extract some info from the scsi command */
 	blksize = scsi_prot_interval(sc);
 	reftag = scsi_prot_ref_tag(sc);
-	if (reftag == LPFC_INVALID_REFTAG)
-		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -1954,8 +1946,6 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command for pde*/
 	reftag = scsi_prot_ref_tag(sc);
-	if (reftag == LPFC_INVALID_REFTAG)
-		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -2155,8 +2145,6 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	/* extract some info from the scsi command */
 	blksize = scsi_prot_interval(sc);
 	reftag = scsi_prot_ref_tag(sc);
-	if (reftag == LPFC_INVALID_REFTAG)
-		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -2748,8 +2736,6 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
 		start_ref_tag = scsi_prot_ref_tag(cmd);
-		if (start_ref_tag == LPFC_INVALID_REFTAG)
-			goto out;
 		start_app_tag = src->app_tag;
 		len = sgpe->length;
 		while (src && protsegcnt) {
@@ -3495,11 +3481,11 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 			     scsi_cmnd->sc_data_direction);
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-			"9084 Cannot setup S/G List for HBA"
-			"IO segs %d/%d SGL %d SCSI %d: %d %d\n",
+			"9084 Cannot setup S/G List for HBA "
+			"IO segs %d/%d SGL %d SCSI %d: %d %d %d\n",
 			lpfc_cmd->seg_cnt, lpfc_cmd->prot_seg_cnt,
 			phba->cfg_total_seg_cnt, phba->cfg_sg_seg_cnt,
-			prot_group_type, num_sge);
+			prot_group_type, num_sge, ret);
 
 	lpfc_cmd->seg_cnt = 0;
 	lpfc_cmd->prot_seg_cnt = 0;
-- 
2.40.1

