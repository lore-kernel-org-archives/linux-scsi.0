Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A82C001DB
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Aug 2023 21:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjHCVGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Aug 2023 17:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbjHCVGt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2023 17:06:49 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F813C25
        for <linux-scsi@vger.kernel.org>; Thu,  3 Aug 2023 14:06:46 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-267f32e89a5so227116a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 03 Aug 2023 14:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691096805; x=1691701605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TX4/rAGJDkwQ68cNVQuvHv6nWu5bnNPOPX/LfHsa00E=;
        b=fRuwtZSEOJc9AIRYTFwcTgNlH6fObIKiPzYMud4TZLOMndDElGgYApYe+psXq0d23G
         dbuENWtK8bUJwyoEu1SdIj3Ay04HgU6jhYKXxIIffWSFhgJj5I8A326NQUspsrjesURD
         WMTIDeGA7RD00qjRoFd5VTxvp6B5NuOE8MQTff4N2GLVVdXYD1eJUnRi4exa0p/EP8yY
         AJSTJUmv9T2T5QKfZFWjF2Q1fOwUDrLJxqojDNzjhxLtGRDZu5FDpMKEf4A01WVxe/Wg
         pbumVPc0OyTPzX975jLQBuaJ8ntAH69HpvYE4//Gl/X6QaDug8Lti6tJ97LXCEuKL2A6
         ohPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691096805; x=1691701605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TX4/rAGJDkwQ68cNVQuvHv6nWu5bnNPOPX/LfHsa00E=;
        b=KningBJbQUqvnqo/MetY4M3/qHtLbfPAQVg2ILAeZt+aBcqcrb7fDiEsqS8wnWKt1s
         BAwV8bXc3YIU08YlGAOlXhp+Vr+vILt13QvosVuS3lltdJNocgE2MMu+ryZcs1D7KaaO
         C40NPwNePhRInLv63HbY/jd1S/oMw/doDEOgwmJfdasK+83/odgC1DMDjsiuBFbLAEik
         jA0vNfuLWsvOj5KcKA7sVF4lN2um51C3J55NzqvCzXyAJ3EywFcrkKS6YROUo4Vf0v5e
         dp0sAZey8oZDmXvBN6T7vON9OppjyafH9ALjgueZxs3wM6mtXuPX5vrKja8idR6mch3F
         yueA==
X-Gm-Message-State: ABy/qLY6IMSO/xRZKwJWYHwUamdTJg7MtqHLb+MUgxy6GZbJnaDZsjbU
        OtGACwRVFF4IUc9NvZWQl7KGvTlquZM=
X-Google-Smtp-Source: APBJJlF2CUkWxRWfJs8/0lmKXxo9AX3p/upbxpfB94NuLrPa7JlX0Y+XaLlv0UIp1naPGW7SMSgjEw==
X-Received: by 2002:a17:90a:53a3:b0:268:437:7bd9 with SMTP id y32-20020a17090a53a300b0026804377bd9mr15405127pjh.3.1691096805211;
        Thu, 03 Aug 2023 14:06:45 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h22-20020a17090adb9600b002684129f4b7sm2925574pjv.18.2023.08.03.14.06.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Aug 2023 14:06:44 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/1] lpfc: Remove reftag check in DIF paths
Date:   Thu,  3 Aug 2023 14:19:32 -0700
Message-Id: <20230803211932.155745-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When preparing protection DIF I/O for DMA, the driver obtains reference
tags from scsi_prot_ref_tag.  Previously, there was a wrong assumption that
an all 0xffffffff value meant error and thus the driver failed the I/O.
This patch removes the evaluation code and accepts whatever the upper layer
returns.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a62e091894f6..d26941b131fd 100644
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
@@ -1953,8 +1945,6 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command for pde*/
 	reftag = scsi_prot_ref_tag(sc);
-	if (reftag == LPFC_INVALID_REFTAG)
-		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -2154,8 +2144,6 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	/* extract some info from the scsi command */
 	blksize = scsi_prot_interval(sc);
 	reftag = scsi_prot_ref_tag(sc);
-	if (reftag == LPFC_INVALID_REFTAG)
-		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -2746,8 +2734,6 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
 		start_ref_tag = scsi_prot_ref_tag(cmd);
-		if (start_ref_tag == LPFC_INVALID_REFTAG)
-			goto out;
 		start_app_tag = src->app_tag;
 		len = sgpe->length;
 		while (src && protsegcnt) {
@@ -3493,11 +3479,11 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
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
2.38.0

