Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFE5C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 625BC6113B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbhHETTt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:49 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:51775 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242907AbhHETTs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:48 -0400
Received: by mail-pj1-f53.google.com with SMTP id mt6so11328555pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tA3LmES8v6WLt2B62YZmGK6WdK6cIyjSz0t5AEaW98I=;
        b=W1WuWDc0ZpfmKDwNe8z4ASUYv4ypQhja7iaomjWGS+9dRcHfAf2qZLdjXvxSjTV9yk
         SUbWcemCT12dTs9DaIcZi6L7t/wQDYTF60OR+y2A9nQGbrJ8NZ2zw0Uz76LGuXRyTX50
         IkaRItLvCzlhrueDtN+4ac8A78n8W/0xQCRgriyOHZLb4fwJ0VsA+GVxdS4106xbHDeB
         2ML75ZlAlU2XEYNCmUhK45bTKSYQU6nFdEAdGj1fa6rBtwvoLI/zYXzDJ2L7hK1ZnIAG
         agxTxHPrnnlxbmW5zpPnolEX5ifIONR+k4dB2t3dNgfPJH2l6XFqytsflELBrXI4QVAa
         np7w==
X-Gm-Message-State: AOAM533kBrEojGDTjn0utGzmHk+JB4mjWNBUhxl14nzogTvtQm09hfrD
        U8w4KlfY1kVEXZCGR46D+Ss=
X-Google-Smtp-Source: ABdhPJy7UyVJZmD+ZXba7+EVDQCHg5GS6mDBQLhQdU3jBsyDK0xNDUipA3cpMUPZIHdmbXJtPb4YIg==
X-Received: by 2002:aa7:969a:0:b029:3bd:40c4:971f with SMTP id f26-20020aa7969a0000b02903bd40c4971fmr917640pfk.39.1628191173307;
        Thu, 05 Aug 2021 12:19:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 27/52] lpfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:03 -0700
Message-Id: <20210805191828.3559897-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 71 ++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ee4ff4855866..f905a53d050f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -683,7 +683,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 
 	cpu = raw_smp_processor_id();
 	if (cmnd && phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ) {
-		tag = blk_mq_unique_tag(cmnd->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 		idx = blk_mq_unique_tag_to_hwq(tag);
 	} else {
 		idx = phba->sli4_hba.cpu_map[cpu].hdwq;
@@ -1046,7 +1046,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		return 0;
 
 	sgpe = scsi_prot_sglist(sc);
-	lba = t10_pi_ref_tag(sc->request);
+	lba = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (lba == LPFC_INVALID_REFTAG)
 		return 0;
 
@@ -1629,7 +1629,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1792,7 +1792,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2023,7 +2023,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2224,7 +2224,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2818,7 +2818,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-		start_ref_tag = t10_pi_ref_tag(cmd->request);
+		start_ref_tag = t10_pi_ref_tag(scsi_cmd_to_rq(cmd));
 		if (start_ref_tag == LPFC_INVALID_REFTAG)
 			goto out;
 		start_app_tag = src->app_tag;
@@ -2910,7 +2910,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
@@ -2920,7 +2920,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9066 BLKGRD: reftag %x ref_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
@@ -2930,7 +2930,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9041 BLKGRD: reftag %x app_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
 				app_tag, start_app_tag);
 	}
 }
@@ -2992,7 +2992,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3007,7 +3007,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3022,7 +3022,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3066,7 +3066,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -3103,8 +3103,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9072 BLKGRD: Invalid BG Profile in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3115,8 +3115,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9073 BLKGRD: Invalid BG PDIF Block in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3131,8 +3131,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9055 BLKGRD: Guard Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3146,8 +3146,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9056 BLKGRD: Ref Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3161,8 +3161,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9061 BLKGRD: App Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3205,8 +3205,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9057 BLKGRD: Unknown error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -5419,13 +5419,9 @@ static int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
  */
 static char *lpfc_is_command_vm_io(struct scsi_cmnd *cmd)
 {
-	char *uuid = NULL;
+	struct bio *bio = scsi_cmd_to_rq(cmd)->bio;
 
-	if (cmd->request) {
-		if (cmd->request->bio)
-			uuid = blkcg_get_fc_appid(cmd->request->bio);
-	}
-	return uuid;
+	return bio ? blkcg_get_fc_appid(bio) : NULL;
 }
 
 /**
@@ -5553,8 +5549,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "reftag x%x cnt %u pt %x\n",
 					 dif_op_str[scsi_get_prot_op(cmnd)],
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(cmnd->request),
-					 blk_rq_sectors(cmnd->request),
+					 t10_pi_ref_tag(scsi_cmd_to_rq(cmnd)),
+					 blk_rq_sectors(scsi_cmd_to_rq(cmnd)),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
@@ -5565,8 +5561,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
 					 "x%x reftag x%x cnt %u pt %x\n",
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(cmnd->request),
-					 blk_rq_sectors(cmnd->request),
+					 t10_pi_ref_tag(scsi_cmd_to_rq(cmnd)),
+					 blk_rq_sectors(scsi_cmd_to_rq(cmnd)),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
@@ -5637,8 +5633,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				   bf_get(wqe_tmo,
 				   &lpfc_cmd->cur_iocbq.wqe.generic.wqe_com) :
 				   lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
-				   (uint32_t)
-				   (cmnd->request->timeout / 1000));
+				   (uint32_t)(scsi_cmd_to_rq(cmnd)->timeout / 1000));
 
 		goto out_host_busy_free_buf;
 	}
