Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBADC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5DE561151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhEXDLU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:20 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:33502 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbhEXDLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:20 -0400
Received: by mail-pj1-f41.google.com with SMTP id v13-20020a17090abb8db029015f9f7d7290so714840pjr.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uhDDuUzMJIn5hTXZdi1/PYXN+04vMwyqdf7/y9GwrZ8=;
        b=qYIw5ZrzxWQm0Dz6xBodHvu9zlieFlMnJc4TGoSHWiwxRwdYe8yAhpHCMOMUc4P13P
         8Klihs/p/ug055YZtCT+H2MhodCagJW08fKM/Uq62XIcs/LaCyatRw4ick9g57LNuNVe
         YM/B/kmpcYz14ChSxjPUjPt836Toe6qRhPNZ/ikE5Jian/ksH6dm/XztDufDf1QjZvix
         fg/t8eai+O5skmGaueeuSGaoGofbn2jk3aNRrsUvkyBWNYEV4iTmGSrZG8E+EJDAVnVV
         01Hgouet50HLfGAJtk/9tJT9oPu84wJCEmBd6tYSQIUI79NPAZ40AcPoFfuopTHUcC5r
         iqrg==
X-Gm-Message-State: AOAM531ZdrU5G1apYSGM0aTa9p0xeaAKS7cTSOH9cvMxnPqUefYR59Qj
        5l1npWFsbP1WK772Y4uQZTc=
X-Google-Smtp-Source: ABdhPJxkK4ckkGZ2k/8TBZdm+eFIxLjz4rcA3NHM/95Adui+9w1pZhb2ZpT5+m8EYrPVKWvlAQBnzw==
X-Received: by 2002:a17:902:f552:b029:f5:4679:6194 with SMTP id h18-20020a170902f552b02900f546796194mr23553477plf.54.1621825791481;
        Sun, 23 May 2021 20:09:51 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 27/51] lpfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:32 -0700
Message-Id: <20210524030856.2824-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 63 +++++++++++++++++------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b8bb012abb33..795b0305fbdc 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -674,7 +674,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 
 	cpu = raw_smp_processor_id();
 	if (cmnd && phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ) {
-		tag = blk_mq_unique_tag(cmnd->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 		idx = blk_mq_unique_tag_to_hwq(tag);
 	} else {
 		idx = phba->sli4_hba.cpu_map[cpu].hdwq;
@@ -1037,7 +1037,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		return 0;
 
 	sgpe = scsi_prot_sglist(sc);
-	lba = t10_pi_ref_tag(sc->request);
+	lba = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (lba == LPFC_INVALID_REFTAG)
 		return 0;
 
@@ -1620,7 +1620,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1783,7 +1783,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2014,7 +2014,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2215,7 +2215,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2809,7 +2809,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-		start_ref_tag = t10_pi_ref_tag(cmd->request);
+		start_ref_tag = t10_pi_ref_tag(scsi_cmd_to_rq(cmd));
 		if (start_ref_tag == LPFC_INVALID_REFTAG)
 			goto out;
 		start_app_tag = src->app_tag;
@@ -2903,7 +2903,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
@@ -2915,7 +2915,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9066 BLKGRD: reftag %x ref_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
@@ -2927,7 +2927,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9041 BLKGRD: reftag %x app_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
 				app_tag, start_app_tag);
 	}
 }
@@ -2991,7 +2991,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3008,7 +3008,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3025,7 +3025,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3069,7 +3069,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -3106,8 +3106,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
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
@@ -3118,8 +3118,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
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
@@ -3136,8 +3136,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9055 BLKGRD: Guard Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3153,8 +3153,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9056 BLKGRD: Ref Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3170,8 +3170,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9061 BLKGRD: App Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3214,8 +3214,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9057 BLKGRD: Unknown error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -5302,8 +5302,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
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
@@ -5314,8 +5314,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
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
@@ -5367,8 +5367,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				   bf_get(wqe_tmo,
 				   &lpfc_cmd->cur_iocbq.wqe.generic.wqe_com) :
 				   lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
-				   (uint32_t)
-				   (cmnd->request->timeout / 1000));
+				   (uint32_t)(scsi_cmd_to_rq(cmnd)->timeout / 1000));
 
 		goto out_host_busy_free_buf;
 	}
