Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46849C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A1CE61002
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbhHIXFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:13 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:44545 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbhHIXFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:07 -0400
Received: by mail-pj1-f44.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so2395256pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tA3LmES8v6WLt2B62YZmGK6WdK6cIyjSz0t5AEaW98I=;
        b=d0yePkpo+BQKMRhohKA/x+3rWq3gp89ijoROZzpvhBg4ZayONoTwDf0E77i46pkH5T
         vTS35+tedsQCc3zLyZGO9iL+61tMlDSVYeUXP8xoTILgiUIQAC06LRNbEdBV1TJjNCSC
         l29aeSHkfD3MM+/SgJfd/4Nh3TwIpAaBksxt3mTVBapxebgQvP/FyjtMl7l5o1VvL4gS
         WNswmkMQ68abYpwPW1mTqEK9YN43FTi4c+HkkyrzMPMK8WcDzxdpYGYnN2zDwFWJUSWp
         w5qgnjPgoepCkdYNttUuhOnzEv11+CYzsBY37peG9epaTWe5+DuOhCZLmGjZsiqY2kJG
         MzbQ==
X-Gm-Message-State: AOAM531++h6D5RdaF7CPMmJluUV3qs3E5PKYCeLj4EbFjbcYPRY5tIZp
        BE6d5+mtc6EBxU7fQDQ4gRo=
X-Google-Smtp-Source: ABdhPJxa0OBJsPgthPKql2uCRAjRQpnMqtAigc2o/5wmI28pKBxVMA9iOvz3qS9oFryoFZl3eYoZwA==
X-Received: by 2002:a17:903:32d1:b029:12c:d4c6:6d2c with SMTP id i17-20020a17090332d1b029012cd4c66d2cmr8315405plr.28.1628550286440;
        Mon, 09 Aug 2021 16:04:46 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 27/52] lpfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:30 -0700
Message-Id: <20210809230355.8186-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
