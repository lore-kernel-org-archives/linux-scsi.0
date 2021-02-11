Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 281A2C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0CB264E42
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhBKXrd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhBKXqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:39 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE1EC061224
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:19 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id nm1so4366372pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=odLf/WAD6xKWM86AG3jHvrBwC5m7u2gSqIwh0Ct7qRM=;
        b=Btcet1/sbVwRJigO6zS6PGiOLsEoETT2xnPwKE8p3ruS48AoENAIGkgYa95BhGF6gV
         p404gOb4qxNsLj3epVjBhgneRTUpaLdtnFAZ5jfI2B8AJLWuYsztDVdPaow14uIXyvXJ
         Gqdrj7Ho0bpweKb5iwSmGi3vXGvkxJRv57xhkN6dUNxuCfVj8ZSQu9GED9Tg//2lKVpR
         eABb39o3DcLrPi3tTuv53UmdIWlDadNADy8NarUL+HdNG6NdCxGPeJl7YOXdYZlpbrhM
         hOqvVORXPWIgIjGAbvYDMRlqVWiXYToKh2uwKBPA45DMztDc1RuUpzShKShJk/7httR+
         Fq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=odLf/WAD6xKWM86AG3jHvrBwC5m7u2gSqIwh0Ct7qRM=;
        b=WfZWM/UmCw1fuaY7umvbfZ93t8d07xwtSeSvLsW0Z64SBNNJVFRTrYNJ9sGZLiJ0gP
         HRyyZFNrclHr7YQJMtZFXwjvfTQ3RwBxW1HJyrrLDOkBS6ySap3miQ68IHAnXyU4EUKl
         Jdeoym4DkCcTWY6oKpKnWsdFTdcectL0Sb44MCA4ySqA3v66hmQLEuCDrZ8r+/MBx+eq
         RoZ3COuOLLhBzVgTfPvxwCJTpYjRTpxUQ0EGRkSevVlYrevSHwscXeCd4rmrIypO8Fpn
         I0+59LPLJqYj+NTgR/84yc1Yl0TWPW/fFghZjALU6cu1WPPo0AwA8bQBdp/HawLtK7Va
         iLdA==
X-Gm-Message-State: AOAM530Xw5jSxVxyTDvlmLlqf5LqRlq8OyQ1oUsM2CpFavfVfIw5+oxF
        cHwGMhukXBCIGdj8mNXlwadeqxk5/p8=
X-Google-Smtp-Source: ABdhPJwuIHeptVBsRnLpzhYLuHtC/eSnrlh7xxrfbPuRa2bWguTKNTW4lo01ZE/TscN+Y3PdM5Y93Q==
X-Received: by 2002:a17:902:c404:b029:e2:cb8e:6b78 with SMTP id k4-20020a170902c404b02900e2cb8e6b78mr411484plk.3.1613087092697;
        Thu, 11 Feb 2021 15:44:52 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:52 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/22] lpfc: Fix reftag generation sizing errors
Date:   Thu, 11 Feb 2021 15:44:24 -0800
Message-Id: <20210211234443.3107-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An LBA is 8 bytes. The driver generates a reftag from the LBA but the
reftag is 4 bytes. Thus scsi_get_lba() could return a value that exceeds
our reftag size.

Fix by creating a common routine used for creating reftags that ensures
a 4byte value. Also correct a few code lines that access lba directly and
ensure 64bit data types are used.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 109 ++++++++++++++++++++++------------
 1 file changed, 71 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a4d697373c71..1a9343e5b8f2 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -132,6 +132,27 @@ lpfc_sli4_set_rsp_sgl_last(struct lpfc_hba *phba,
 	}
 }
 
+#define LPFC_INVALID_REFTAG ((u32)-1)
+
+/*
+ * lpfc_scsi_get_reftag - Get truncated LBA for a SCSI command
+ * @sc: The SCSI Layer structure for the IO in question.
+ *
+ * The LBA of a SCSI command can be up to 8 bytes in length, for DIF
+ * reftag applications and some log messages, we need to use a
+ * truncated LBA (4 bytes)
+ */
+static u32
+lpfc_scsi_get_reftag(struct scsi_cmnd *sc)
+{
+	sector_t lba;
+
+	lba = scsi_get_lba(sc);
+
+	/* Now truncate the LBA to 4 bytes, reftag size */
+	return (u32)(lba & 0xffffffff);
+}
+
 /**
  * lpfc_update_stats - Update statistical data for the command completion
  * @vport: The virtual port on which this call is executing.
@@ -1000,7 +1021,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint32_t op = scsi_get_prot_op(sc);
 	uint32_t blksize;
 	uint32_t numblks;
-	sector_t lba;
+	u32 lba;
 	int rc = 0;
 	int blockoff = 0;
 
@@ -1008,7 +1029,9 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		return 0;
 
 	sgpe = scsi_prot_sglist(sc);
-	lba = scsi_get_lba(sc);
+	lba = lpfc_scsi_get_reftag(sc);
+	if (lba == LPFC_INVALID_REFTAG)
+		return 0;
 
 	/* First check if we need to match the LBA */
 	if (phba->lpfc_injerr_lba != LPFC_INJERR_LBA_OFF) {
@@ -1016,11 +1039,11 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		numblks = (scsi_bufflen(sc) + blksize - 1) / blksize;
 
 		/* Make sure we have the right LBA if one is specified */
-		if ((phba->lpfc_injerr_lba < lba) ||
-			(phba->lpfc_injerr_lba >= (lba + numblks)))
+		if (phba->lpfc_injerr_lba < (u64)lba ||
+		    (phba->lpfc_injerr_lba >= (u64)(lba + numblks)))
 			return 0;
 		if (sgpe) {
-			blockoff = phba->lpfc_injerr_lba - lba;
+			blockoff = phba->lpfc_injerr_lba - (u64)lba;
 			numblks = sg_dma_len(sgpe) /
 				sizeof(struct scsi_dif_tuple);
 			if (numblks < blockoff)
@@ -1589,7 +1612,9 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
+	reftag = lpfc_scsi_get_reftag(sc);
+	if (reftag == LPFC_INVALID_REFTAG)
+		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -1750,7 +1775,9 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
+	reftag = lpfc_scsi_get_reftag(sc);
+	if (reftag == LPFC_INVALID_REFTAG)
+		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -1979,7 +2006,9 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
+	reftag = lpfc_scsi_get_reftag(sc);
+	if (reftag == LPFC_INVALID_REFTAG)
+		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -2178,7 +2207,9 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
+	reftag = lpfc_scsi_get_reftag(sc);
+	if (reftag == LPFC_INVALID_REFTAG)
+		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -2770,7 +2801,9 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-		start_ref_tag = (uint32_t)scsi_get_lba(cmd); /* Truncate LBA */
+		start_ref_tag = lpfc_scsi_get_reftag(cmd);
+		if (start_ref_tag == LPFC_INVALID_REFTAG)
+			goto out;
 		start_app_tag = src->app_tag;
 		len = sgpe->length;
 		while (src && protsegcnt) {
@@ -2861,8 +2894,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			      SAM_STAT_CHECK_CONDITION;
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9069 BLKGRD: LBA %lx grd_tag error %x != %x\n",
-				(unsigned long)scsi_get_lba(cmd),
+				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
+				lpfc_scsi_get_reftag(cmd),
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
@@ -2873,8 +2906,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9066 BLKGRD: LBA %lx ref_tag error %x != %x\n",
-				(unsigned long)scsi_get_lba(cmd),
+				"9066 BLKGRD: reftag %x ref_tag err %x != %x\n",
+				lpfc_scsi_get_reftag(cmd),
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
@@ -2885,8 +2918,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9041 BLKGRD: LBA %lx app_tag error %x != %x\n",
-				(unsigned long)scsi_get_lba(cmd),
+				"9041 BLKGRD: reftag %x app_tag err %x != %x\n",
+				lpfc_scsi_get_reftag(cmd),
 				app_tag, start_app_tag);
 	}
 }
@@ -3062,10 +3095,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_invalid_prof(bgstat)) {
 		cmd->result = DID_ERROR << 16;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9072 BLKGRD: Invalid BG Profile in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9072 BLKGRD: Invalid BG Profile in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				lpfc_scsi_get_reftag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 		ret = (-1);
 		goto out;
@@ -3074,10 +3107,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_uninit_dif_block(bgstat)) {
 		cmd->result = DID_ERROR << 16;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9073 BLKGRD: Invalid BG PDIF Block in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9073 BLKGRD: Invalid BG PDIF Block in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				lpfc_scsi_get_reftag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 		ret = (-1);
 		goto out;
@@ -3092,10 +3125,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 			      SAM_STAT_CHECK_CONDITION;
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9055 BLKGRD: Guard Tag error in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9055 BLKGRD: Guard Tag error in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				lpfc_scsi_get_reftag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3109,10 +3142,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9056 BLKGRD: Ref Tag error in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9056 BLKGRD: Ref Tag error in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				lpfc_scsi_get_reftag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3126,10 +3159,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9061 BLKGRD: App Tag error in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9061 BLKGRD: App Tag error in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				lpfc_scsi_get_reftag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3170,10 +3203,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (!ret) {
 		/* No error was reported - problem in FW? */
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9057 BLKGRD: Unknown error in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9057 BLKGRD: Unknown error in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				lpfc_scsi_get_reftag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
@@ -5252,10 +5285,10 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 			lpfc_printf_vlog(vport,
 					 KERN_INFO, LOG_SCSI_CMD,
 					 "9033 BLKGRD: rcvd %s cmd:x%x "
-					 "sector x%llx cnt %u pt %x\n",
+					 "reftag x%x cnt %u pt %x\n",
 					 dif_op_str[scsi_get_prot_op(cmnd)],
 					 cmnd->cmnd[0],
-					 (unsigned long long)scsi_get_lba(cmnd),
+					 lpfc_scsi_get_reftag(cmnd),
 					 blk_rq_sectors(cmnd->request),
 					 (cmnd->cmnd[1]>>5));
 		}
@@ -5265,9 +5298,9 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 			lpfc_printf_vlog(vport,
 					 KERN_INFO, LOG_SCSI_CMD,
 					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
-					 "x%x sector x%llx cnt %u pt %x\n",
+					 "x%x reftag x%x cnt %u pt %x\n",
 					 cmnd->cmnd[0],
-					 (unsigned long long)scsi_get_lba(cmnd),
+					 lpfc_scsi_get_reftag(cmnd),
 					 blk_rq_sectors(cmnd->request),
 					 (cmnd->cmnd[1]>>5));
 		}
-- 
2.26.2

