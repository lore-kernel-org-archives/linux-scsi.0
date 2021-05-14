Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D79FC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 418D16143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbhENVgH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:07 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:46863 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbhENVgF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:05 -0400
Received: by mail-pg1-f179.google.com with SMTP id m124so232327pgm.13
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1bE/JDdSNRM+UpTgVHuQJDAeQB5au8eWRTRk/CqlttE=;
        b=pPO/ajcCJsuZ+WAY6JyxAWU9++4Bmw235Bb+Gl4bb9xHXgfgFm6LMMiHg/+spaB+aR
         e5vzSD36THdDLqNw5II+iFDm+H/GlXuDDR130EFShdNT/CRu5PIIO5jrIfUyc7ll/Vft
         sBx3dBPdK1wJhzBfeJ4oFt3sf4yFjdikNt2VP/U8qlEkGB4PNk55Jqwiev22V6Afnk2I
         aW51PSwWLTK/BjHUpksymXXBwiCw9PKjTTWGvmTET2g389NBuuNcGdnb4a/9F4MquTcY
         KR3sqox8H7XeWLSWVoCV7+aegSIFG9ECnTwCdhsetBeU/kKiAfEMIHzWVAI1UElIp0Nt
         OT5w==
X-Gm-Message-State: AOAM530ZBGxxsujl9Kkpqc1VFJS0GMFKSAYgyiIZiqe8tsdRkxlumcHN
        9XcMcRPQ1KHYKe0MYEPFmEw=
X-Google-Smtp-Source: ABdhPJzAfOpmb2BTq/Cnk9oe9xp1/kCGUHB8feJusMvWbztDgwDi5iC0e2JGCXJzo59qp7bQG42Ytg==
X-Received: by 2002:a62:3003:0:b029:28e:74d9:1e16 with SMTP id w3-20020a6230030000b029028e74d91e16mr49309369pfw.21.1621028092117;
        Fri, 14 May 2021 14:34:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 26/50] lpfc: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:41 -0700
Message-Id: <20210514213356.5264-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 63 +++++++++++++++++------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index eefbb9b22798..b9716237bdbe 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -648,7 +648,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 
 	cpu = raw_smp_processor_id();
 	if (cmnd && phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ) {
-		tag = blk_mq_unique_tag(cmnd->request);
+		tag = blk_mq_unique_tag(blk_req(cmnd));
 		idx = blk_mq_unique_tag_to_hwq(tag);
 	} else {
 		idx = phba->sli4_hba.cpu_map[cpu].hdwq;
@@ -1010,7 +1010,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		return 0;
 
 	sgpe = scsi_prot_sglist(sc);
-	lba = t10_pi_ref_tag(sc->request);
+	lba = t10_pi_ref_tag(blk_req(sc));
 	if (lba == LPFC_INVALID_REFTAG)
 		return 0;
 
@@ -1593,7 +1593,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(blk_req(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1756,7 +1756,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(blk_req(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1987,7 +1987,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(blk_req(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2188,7 +2188,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(blk_req(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2782,7 +2782,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-		start_ref_tag = t10_pi_ref_tag(cmd->request);
+		start_ref_tag = t10_pi_ref_tag(blk_req(cmd));
 		if (start_ref_tag == LPFC_INVALID_REFTAG)
 			goto out;
 		start_app_tag = src->app_tag;
@@ -2876,7 +2876,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(blk_req(cmd)),
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
@@ -2888,7 +2888,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9066 BLKGRD: reftag %x ref_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(blk_req(cmd)),
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
@@ -2900,7 +2900,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9041 BLKGRD: reftag %x app_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(blk_req(cmd)),
 				app_tag, start_app_tag);
 	}
 }
@@ -2964,7 +2964,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -2981,7 +2981,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -2998,7 +2998,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3042,7 +3042,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -3079,8 +3079,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9072 BLKGRD: Invalid BG Profile in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(blk_req(cmd)),
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3091,8 +3091,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9073 BLKGRD: Invalid BG PDIF Block in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(blk_req(cmd)),
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3109,8 +3109,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9055 BLKGRD: Guard Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(blk_req(cmd)),
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3126,8 +3126,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9056 BLKGRD: Ref Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(blk_req(cmd)),
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3143,8 +3143,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9061 BLKGRD: App Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(blk_req(cmd)),
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3187,8 +3187,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9057 BLKGRD: Unknown error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(blk_req(cmd)),
+				blk_rq_sectors(blk_req(cmd)), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -5269,8 +5269,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "reftag x%x cnt %u pt %x\n",
 					 dif_op_str[scsi_get_prot_op(cmnd)],
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(cmnd->request),
-					 blk_rq_sectors(cmnd->request),
+					 t10_pi_ref_tag(blk_req(cmnd)),
+					 blk_rq_sectors(blk_req(cmnd)),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
@@ -5281,8 +5281,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
 					 "x%x reftag x%x cnt %u pt %x\n",
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(cmnd->request),
-					 blk_rq_sectors(cmnd->request),
+					 t10_pi_ref_tag(blk_req(cmnd)),
+					 blk_rq_sectors(blk_req(cmnd)),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
@@ -5334,8 +5334,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				   bf_get(wqe_tmo,
 				   &lpfc_cmd->cur_iocbq.wqe.generic.wqe_com) :
 				   lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
-				   (uint32_t)
-				   (cmnd->request->timeout / 1000));
+				   (uint32_t)(blk_req(cmnd)->timeout / 1000));
 
 		goto out_host_busy_free_buf;
 	}
