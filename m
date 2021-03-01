Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DB3C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4AA96506F
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbhCARWN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbhCARTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:19:12 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3BDC0617A9
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:28 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b15so11723927pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zGPUEDFuSpGsb8uvCJtAALcL984FJpX7fUTl8zWEduo=;
        b=JBOQZ2WVkGWH7ONZERKv381NdoUdiYMCtZ/VdpPpP643MiMhT5npW9QE49oQI8OASd
         N5VyTHEy6aC3Y3rQUXA3q1sEKeVPxlLZDN/cQvCTqyt7rv5Sc49DQY7Or08fB9wR7SmO
         F8hOLeER38V4qy0BkFD2JnH8Lm7xJoHkemDlCpAssrsq9QzcM/61Wz1nThHLK5XDkGgk
         9se9Hj3ionhlEsK3gg6ZNnKbf3JthW+wRjf7TB1SyD53MOY77J2lZNrdIOM8YUeClLYR
         T8uwVuq51pSpKPzyRfq7gtoty36MTPBiqz3SbWkp1wO9r4dPx9206oeBLn4lDf9mprxR
         LlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zGPUEDFuSpGsb8uvCJtAALcL984FJpX7fUTl8zWEduo=;
        b=US5A62KhzyAZHp2oIlYNN6biSfsKU1mWK3t85OfO6fYeqrfwM62dlmN7ptI/+h7pRg
         wygQDOVyisSBbNZ/qFxaEUdZJK0Iu6qY8B9ysi//ioTh8V5LVQRlJ/9051PtkKLjl/xO
         4ZceOU1lpeoU42dHeSSoi459mJUBEsD3CKE3XaKQu9nHAHeT9ynlKBPMHcTGB5XjRed6
         0JZs9NArLRDB4/GsAq61pZqf9Q8SU2S/SwmqVSmuSZAH+F8xYM3wplX2f3RGpDrISSb/
         3zi1tuHpIA+Op49Ug8G8SfCcfv3YMDucW0F9BS7biGmZXwq2ir+CLGYapLAQ7N2zyxKm
         TsWg==
X-Gm-Message-State: AOAM531I+N2a9Ghfr+5RYyese4eqINUWXrQiw3+X9s4VlnrkRZfRWlWU
        +xwFiA0aSQsTqExz/o1KFs8mgYfDTxo=
X-Google-Smtp-Source: ABdhPJw9NUkPBxzLRpmKt2Fw4+2YufWPQqgvY4V3REk+QIiTAH2bhJLH+rRlYNucJT4vF1ttf60c4g==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr18664527pjb.35.1614619107897;
        Mon, 01 Mar 2021 09:18:27 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:27 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 03/22] lpfc: Fix reftag generation sizing errors
Date:   Mon,  1 Mar 2021 09:18:02 -0800
Message-Id: <20210301171821.3427-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An LBA is 8 bytes. The driver generates a reftag from the LBA but the
reftag is 4 bytes. Thus scsi_get_lba() could return a value that exceeds
our reftag size.

Fix by converting all the code to calling the common routine
t10_pi_ref_tag() which returns a u32, thus ensuring a consistent 4byte
value.  Also correct a few code lines that access lba directly and
ensure 64bit data types are used.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v2:
  replace lpfc_scsi_get_reftag() with the system routine t10_pi_ref_tag()
---
 drivers/scsi/lpfc/lpfc_scsi.c | 90 ++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a4d697373c71..3e1bc55993fd 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -132,6 +132,8 @@ lpfc_sli4_set_rsp_sgl_last(struct lpfc_hba *phba,
 	}
 }
 
+#define LPFC_INVALID_REFTAG ((u32)-1)
+
 /**
  * lpfc_update_stats - Update statistical data for the command completion
  * @vport: The virtual port on which this call is executing.
@@ -1000,7 +1002,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint32_t op = scsi_get_prot_op(sc);
 	uint32_t blksize;
 	uint32_t numblks;
-	sector_t lba;
+	u32 lba;
 	int rc = 0;
 	int blockoff = 0;
 
@@ -1008,7 +1010,9 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		return 0;
 
 	sgpe = scsi_prot_sglist(sc);
-	lba = scsi_get_lba(sc);
+	lba = t10_pi_ref_tag(sc->request);
+	if (lba == LPFC_INVALID_REFTAG)
+		return 0;
 
 	/* First check if we need to match the LBA */
 	if (phba->lpfc_injerr_lba != LPFC_INJERR_LBA_OFF) {
@@ -1016,11 +1020,11 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
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
@@ -1589,7 +1593,9 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
+	reftag = t10_pi_ref_tag(sc->request);
+	if (reftag == LPFC_INVALID_REFTAG)
+		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -1750,7 +1756,9 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
+	reftag = t10_pi_ref_tag(sc->request);
+	if (reftag == LPFC_INVALID_REFTAG)
+		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -1979,7 +1987,9 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
+	reftag = t10_pi_ref_tag(sc->request);
+	if (reftag == LPFC_INVALID_REFTAG)
+		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -2178,7 +2188,9 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 	/* extract some info from the scsi command */
 	blksize = lpfc_cmd_blksize(sc);
-	reftag = (uint32_t)scsi_get_lba(sc); /* Truncate LBA */
+	reftag = t10_pi_ref_tag(sc->request);
+	if (reftag == LPFC_INVALID_REFTAG)
+		goto out;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	rc = lpfc_bg_err_inject(phba, sc, &reftag, NULL, 1);
@@ -2770,7 +2782,9 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-		start_ref_tag = (uint32_t)scsi_get_lba(cmd); /* Truncate LBA */
+		start_ref_tag = t10_pi_ref_tag(cmd->request);
+		if (start_ref_tag == LPFC_INVALID_REFTAG)
+			goto out;
 		start_app_tag = src->app_tag;
 		len = sgpe->length;
 		while (src && protsegcnt) {
@@ -2861,8 +2875,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			      SAM_STAT_CHECK_CONDITION;
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9069 BLKGRD: LBA %lx grd_tag error %x != %x\n",
-				(unsigned long)scsi_get_lba(cmd),
+				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
+				t10_pi_ref_tag(cmd->request),
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
@@ -2873,8 +2887,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9066 BLKGRD: LBA %lx ref_tag error %x != %x\n",
-				(unsigned long)scsi_get_lba(cmd),
+				"9066 BLKGRD: reftag %x ref_tag err %x != %x\n",
+				t10_pi_ref_tag(cmd->request),
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
@@ -2885,8 +2899,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9041 BLKGRD: LBA %lx app_tag error %x != %x\n",
-				(unsigned long)scsi_get_lba(cmd),
+				"9041 BLKGRD: reftag %x app_tag err %x != %x\n",
+				t10_pi_ref_tag(cmd->request),
 				app_tag, start_app_tag);
 	}
 }
@@ -3062,10 +3076,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_invalid_prof(bgstat)) {
 		cmd->result = DID_ERROR << 16;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9072 BLKGRD: Invalid BG Profile in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9072 BLKGRD: Invalid BG Profile in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				t10_pi_ref_tag(cmd->request),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 		ret = (-1);
 		goto out;
@@ -3074,10 +3088,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (lpfc_bgs_get_uninit_dif_block(bgstat)) {
 		cmd->result = DID_ERROR << 16;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9073 BLKGRD: Invalid BG PDIF Block in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9073 BLKGRD: Invalid BG PDIF Block in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				t10_pi_ref_tag(cmd->request),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 		ret = (-1);
 		goto out;
@@ -3092,10 +3106,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 			      SAM_STAT_CHECK_CONDITION;
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9055 BLKGRD: Guard Tag error in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9055 BLKGRD: Guard Tag error in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				t10_pi_ref_tag(cmd->request),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3109,10 +3123,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9056 BLKGRD: Ref Tag error in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9056 BLKGRD: Ref Tag error in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				t10_pi_ref_tag(cmd->request),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3126,10 +3140,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9061 BLKGRD: App Tag error in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9061 BLKGRD: App Tag error in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				t10_pi_ref_tag(cmd->request),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3170,10 +3184,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	if (!ret) {
 		/* No error was reported - problem in FW? */
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-				"9057 BLKGRD: Unknown error in cmd"
-				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"9057 BLKGRD: Unknown error in cmd "
+				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				(unsigned long long)scsi_get_lba(cmd),
+				t10_pi_ref_tag(cmd->request),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
@@ -5252,10 +5266,10 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 			lpfc_printf_vlog(vport,
 					 KERN_INFO, LOG_SCSI_CMD,
 					 "9033 BLKGRD: rcvd %s cmd:x%x "
-					 "sector x%llx cnt %u pt %x\n",
+					 "reftag x%x cnt %u pt %x\n",
 					 dif_op_str[scsi_get_prot_op(cmnd)],
 					 cmnd->cmnd[0],
-					 (unsigned long long)scsi_get_lba(cmnd),
+					 t10_pi_ref_tag(cmnd->request),
 					 blk_rq_sectors(cmnd->request),
 					 (cmnd->cmnd[1]>>5));
 		}
@@ -5265,9 +5279,9 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 			lpfc_printf_vlog(vport,
 					 KERN_INFO, LOG_SCSI_CMD,
 					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
-					 "x%x sector x%llx cnt %u pt %x\n",
+					 "x%x reftag x%x cnt %u pt %x\n",
 					 cmnd->cmnd[0],
-					 (unsigned long long)scsi_get_lba(cmnd),
+					 t10_pi_ref_tag(cmnd->request),
 					 blk_rq_sectors(cmnd->request),
 					 (cmnd->cmnd[1]>>5));
 		}
-- 
2.26.2

