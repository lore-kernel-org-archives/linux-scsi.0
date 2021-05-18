Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8586BC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6787B611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351251AbhERRqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:54 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:36602 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351298AbhERRqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:49 -0400
Received: by mail-pl1-f182.google.com with SMTP id a11so5524489plh.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HyIWHu6wSvtZ6CNbSNm7IaQcJgVpK0q0FwNFOsD8dZI=;
        b=hgFiqFsAEUAy2qxlCc6PreIuNblKEDMESpn8MQfwKVQRGPXQ/lsjNiUrFrBpx7hb/n
         D3Hfzh1bpx26E8QPgX4B4+591/SnURp6FcQxnnwOuALAzbo3hMYr/03F4ka81qdGQGxP
         pK+7SYt9YRn/oc1NVG6HT7yc/QF0PqC2yuTW45muhMxnHGymMFIeeTlcEfOyD4flCZjC
         U55EzbWf5Yq2P/HVVLWBtjA5XSQOAMXA6XOOaliAc2YIqJFcpvDrLh1oc+MX/E8+rfpk
         m02UiLbhYcyncnICiTYfge3IxhFwYj+ZORNWyqaYnYT7T0uL/kx9KVI55FMoUyC4MgsF
         C9gQ==
X-Gm-Message-State: AOAM533p15uARY/4U4ygblF+8F5CvjcOZThX1E0Ikx3g9LoHBDec1wRr
        aX84MGdiKa4L46FbYEKzYF4=
X-Google-Smtp-Source: ABdhPJxEVvWTirsbzYHZNkOJy6NOUFUb1nCiPCEXpXbnfr6rVOYerQTPV5xhRjFhP6/o+f/SQR/fuw==
X-Received: by 2002:a17:902:f543:b029:f3:bfca:21b4 with SMTP id h3-20020a170902f543b02900f3bfca21b4mr2308716plf.6.1621359930378;
        Tue, 18 May 2021 10:45:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 26/50] lpfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:26 -0700
Message-Id: <20210518174450.20664-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
index eefbb9b22798..fd4e77fe25f1 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -648,7 +648,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 
 	cpu = raw_smp_processor_id();
 	if (cmnd && phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ) {
-		tag = blk_mq_unique_tag(cmnd->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 		idx = blk_mq_unique_tag_to_hwq(tag);
 	} else {
 		idx = phba->sli4_hba.cpu_map[cpu].hdwq;
@@ -1010,7 +1010,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		return 0;
 
 	sgpe = scsi_prot_sglist(sc);
-	lba = t10_pi_ref_tag(sc->request);
+	lba = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (lba == LPFC_INVALID_REFTAG)
 		return 0;
 
@@ -1593,7 +1593,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1756,7 +1756,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1987,7 +1987,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2188,7 +2188,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2782,7 +2782,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-		start_ref_tag = t10_pi_ref_tag(cmd->request);
+		start_ref_tag = t10_pi_ref_tag(scsi_cmd_to_rq(cmd));
 		if (start_ref_tag == LPFC_INVALID_REFTAG)
 			goto out;
 		start_app_tag = src->app_tag;
@@ -2876,7 +2876,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
@@ -2888,7 +2888,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9066 BLKGRD: reftag %x ref_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
@@ -2900,7 +2900,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9041 BLKGRD: reftag %x app_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
 				app_tag, start_app_tag);
 	}
 }
@@ -2964,7 +2964,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -2981,7 +2981,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -2998,7 +2998,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3042,7 +3042,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -3079,8 +3079,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
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
@@ -3091,8 +3091,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
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
@@ -3109,8 +3109,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9055 BLKGRD: Guard Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3126,8 +3126,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9056 BLKGRD: Ref Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3143,8 +3143,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9061 BLKGRD: App Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3187,8 +3187,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9057 BLKGRD: Unknown error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				t10_pi_ref_tag(scsi_cmd_to_rq(cmd)),
+				blk_rq_sectors(scsi_cmd_to_rq(cmd)), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -5269,8 +5269,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
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
@@ -5281,8 +5281,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
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
@@ -5334,8 +5334,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				   bf_get(wqe_tmo,
 				   &lpfc_cmd->cur_iocbq.wqe.generic.wqe_com) :
 				   lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
-				   (uint32_t)
-				   (cmnd->request->timeout / 1000));
+				   (uint32_t)(scsi_cmd_to_rq(cmnd)->timeout / 1000));
 
 		goto out_host_busy_free_buf;
 	}
