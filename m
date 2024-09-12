Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACA318891D
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 23:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726182609; cv=none; b=e/POuSUtoLtWMmRPL8pL48dkK00hvA9GzANN3T0Zr8AKf81BdksuGIc7ZqilYe14ZvNBMAjig2I+zeXr5eErpzDmiFhlhPq2bmdqwTG9boWc8H8q+Hv7f9oHVpKuinE34mNiIyqEo+uIC/5wuxRSVaPB+TWmzVtR/knPu3smM1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726182609; c=relaxed/simple;
	bh=wMpDmxBHytG7Jf1csBBM0ji4ieB0FL303AnK2i9amQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S6W+LLuX9p6lovO9qhWEr66Mxz6U4aQsKfZB5hUjsjcx/Ws56NZJ5kAwAUYfXFTdK6Wkl0ORZmXW34KdQWUeEIFiDphDvwJ/W0voUZ3LNsVZlNdsHbwwJkC+lI0IsxkW7E3TcRElEWvQVajiYiTmNOBlkmLU9REZD19CHek3AdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k0ZhgEGG; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k0ZhgEGG"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6c54a5fbceeso2407916d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 16:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726182607; x=1726787407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYyNrz+TlE5htw9JW3j3Ef1zlHJX86IWpVATX9R7INE=;
        b=k0ZhgEGGd6dUqYdUCPIwDIELtp/x4pIEpj/FXsvvBz+6D00cMOvu8Jd3yMR5mxC2ul
         J6ZU6HfAzRWYEW62WFzIMGvRkr9tKDHMzKVex+E5Fg4Sluxetp7r5qo/OXUWY1/w5fH2
         wVoik9mo+CXsKy+6zGnBALSXb7IMgnRR2E2YG+hW0JzbynWhg0S2Ajf8oQKk8uRYZmvz
         48wpTfbIS0prm5mnRy/qWOcnp0oKx57I9ueMmm8miWnAxg993b6e7dnzg7yoU60UpOWk
         nnHt1eGVaEC33FGi/juRpFv41A/BjmXd6gzCW4pjh3PoonoxUMcl8aQQkxHtqnwtyVl8
         69jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726182607; x=1726787407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYyNrz+TlE5htw9JW3j3Ef1zlHJX86IWpVATX9R7INE=;
        b=KJSU0kBoJvkt+VyeysdOwWUPpcBjvd00E4tMal4E9/BGFXK89CaI3w+naWsWdVRGif
         CZ4eYiNVL5j1mNy3AIpvKhK92SJQ+TKNw0vPDcHMnN6eICOPZ8fKxkqN4KycNTTYTwz/
         EapXVBVfvY6IBUiLRQY05I0Wid6JMbY7kP3MiY4GYiyiKd5VPF4UQXnJFRNkCP2qrAYi
         2o8DYMSnrE916gZEY2QqAffHypxrBoaeMUw8gGgDTbdEdjHqeLv3uoxdOBgTRV8dnIts
         JK64c8xF9S/OLlQUcJowg2dCKU+gqg8ypEVZM03xFuJhilmmx6rneizZS7azr6Yvr/AH
         KqbQ==
X-Gm-Message-State: AOJu0YxMX/3Ylaw+GIedetCfFPrXzfGfzz/NlMLdg+ptq0xhSGzewwst
	7YIfw4011ArE89WOorZCHYxeqR/pvhZbJKgNxF7Tp2sc5POLHhLpQY5Lmw==
X-Google-Smtp-Source: AGHT+IGOsnW8AIDMV05qjSFQPOnnLxV1EPBKmnkbmVo88+GFPLgDlm6J5EOtdLWhtVomnKV93bwMSg==
X-Received: by 2002:a05:6214:3d8c:b0:6c5:2a13:b8e1 with SMTP id 6a1803df08f44-6c57e132c4emr18052306d6.43.1726182606796;
        Thu, 12 Sep 2024 16:10:06 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534339a88sm59363136d6.50.2024.09.12.16.10.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2024 16:10:06 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/8] lpfc: Revise TRACE_EVENT log flag severities from KERN_ERR to KERN_WARNING
Date: Thu, 12 Sep 2024 16:24:45 -0700
Message-Id: <20240912232447.45607-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Revise certain log messages marked as KERN_ERR LOG_TRACE_EVENT to
KERN_WARNING and use the lpfc_vlog_msg macro to still log the event.  The
benefit is that events of interest are still logged and the entire trace
buffer is not dumped with extraneous logging information when using default
lpfc_log_verbose driver parameter settings.

Also, delete the keyword "fail" from such log messages as they aren't
really causes for concern.  The log messages are more for warnings to a SAN
admin about SAN activity.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c  |  10 +--
 drivers/scsi/lpfc/lpfc_els.c | 125 +++++++++++++++++------------------
 2 files changed, 64 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 1e5db489a00c..134bc96dd134 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1572,8 +1572,8 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 		}
 	} else
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "3065 GFT_ID failed x%08x\n", ulp_status);
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_DISCOVERY,
+			      "3065 GFT_ID status x%08x\n", ulp_status);
 
 out:
 	lpfc_ct_free_iocb(phba, cmdiocb);
@@ -2258,7 +2258,7 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "0229 FDMI cmd %04x failed, latt = %d "
+				 "0229 FDMI cmd %04x latt = %d "
 				 "ulp_status: x%x, rid x%x\n",
 				 be16_to_cpu(fdmi_cmd), latt, ulp_status,
 				 ulp_word4);
@@ -2275,9 +2275,9 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Check for a CT LS_RJT response */
 	cmd =  be16_to_cpu(fdmi_cmd);
 	if (be16_to_cpu(fdmi_rsp) == SLI_CT_RESPONSE_FS_RJT) {
-		/* FDMI rsp failed */
+		/* Log FDMI reject */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_ELS,
-				 "0220 FDMI cmd failed FS_RJT Data: x%x", cmd);
+				 "0220 FDMI cmd FS_RJT Data: x%x", cmd);
 
 		/* Should we fallback to FDMI-2 / FDMI-1 ? */
 		switch (cmd) {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 7219b1ada1ea..d737b897ddd8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -979,7 +979,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				phba->fcoe_cvl_eventtag_attn =
 					phba->fcoe_cvl_eventtag;
 			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP | LOG_ELS,
-					"2611 FLOGI failed on FCF (x%x), "
+					"2611 FLOGI FCF (x%x), "
 					"status:x%x/x%x, tmo:x%x, perform "
 					"roundrobin FCF failover\n",
 					phba->fcf.current_rec.fcf_indx,
@@ -997,11 +997,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
 		      ((ulp_word4 & IOERR_PARAM_MASK) ==
 					IOERR_LOOP_OPEN_FAILURE)))
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "2858 FLOGI failure Status:x%x/x%x TMO"
-					 ":x%x Data x%lx x%x\n",
-					 ulp_status, ulp_word4, tmo,
-					 phba->hba_flag, phba->fcf.fcf_flag);
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "2858 FLOGI Status:x%x/x%x TMO"
+				      ":x%x Data x%lx x%x\n",
+				      ulp_status, ulp_word4, tmo,
+				      phba->hba_flag, phba->fcf.fcf_flag);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
@@ -1023,7 +1023,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			lpfc_nlp_put(ndlp);
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
-				 "0150 FLOGI failure Status:x%x/x%x "
+				 "0150 FLOGI Status:x%x/x%x "
 				 "xri x%x TMO:x%x refcnt %d\n",
 				 ulp_status, ulp_word4, cmdiocb->sli4_xritag,
 				 tmo, kref_read(&ndlp->kref));
@@ -1032,11 +1032,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
 		      ((ulp_word4 & IOERR_PARAM_MASK) ==
 					IOERR_LOOP_OPEN_FAILURE))) {
-			/* FLOGI failure */
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "0100 FLOGI failure Status:x%x/x%x "
-					 "TMO:x%x\n",
-					 ulp_status, ulp_word4, tmo);
+			/* Warn FLOGI status */
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "0100 FLOGI Status:x%x/x%x "
+				      "TMO:x%x\n",
+				      ulp_status, ulp_word4, tmo);
 			goto flogifail;
 		}
 
@@ -1964,16 +1964,16 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (ulp_status) {
 		/* Check for retry */
-		/* RRQ failed Don't print the vport to vport rjts */
+		/* Warn RRQ status Don't print the vport to vport rjts */
 		if (ulp_status != IOSTAT_LS_RJT ||
 		    (((ulp_word4) >> 16 != LSRJT_INVALID_CMD) &&
 		     ((ulp_word4) >> 16 != LSRJT_UNABLE_TPC)) ||
 		    (phba)->pport->cfg_log_verbose & LOG_ELS)
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "2881 RRQ failure DID:%06X Status:"
-					 "x%x/x%x\n",
-					 ndlp->nlp_DID, ulp_status,
-					 ulp_word4);
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "2881 RRQ DID:%06X Status:"
+				      "x%x/x%x\n",
+				      ndlp->nlp_DID, ulp_status,
+				      ulp_word4);
 	}
 
 	lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
@@ -2077,16 +2077,16 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			goto out;
 		}
-		/* PLOGI failed Don't print the vport to vport rjts */
+		/* Warn PLOGI status Don't print the vport to vport rjts */
 		if (ulp_status != IOSTAT_LS_RJT ||
 		    (((ulp_word4) >> 16 != LSRJT_INVALID_CMD) &&
 		     ((ulp_word4) >> 16 != LSRJT_UNABLE_TPC)) ||
 		    (phba)->pport->cfg_log_verbose & LOG_ELS)
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "2753 PLOGI failure DID:%06X "
-					 "Status:x%x/x%x\n",
-					 ndlp->nlp_DID, ulp_status,
-					 ulp_word4);
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "2753 PLOGI DID:%06X "
+				      "Status:x%x/x%x\n",
+				      ndlp->nlp_DID, ulp_status,
+				      ulp_word4);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (!lpfc_error_lost_link(vport, ulp_status, ulp_word4))
@@ -2323,7 +2323,6 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_nodelist *ndlp;
 	char *mode;
-	u32 loglevel;
 	u32 ulp_status;
 	u32 ulp_word4;
 	bool release_node = false;
@@ -2372,17 +2371,14 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * could be expected.
 		 */
 		if (test_bit(FC_FABRIC, &vport->fc_flag) ||
-		    vport->cfg_enable_fc4_type != LPFC_ENABLE_BOTH) {
-			mode = KERN_ERR;
-			loglevel =  LOG_TRACE_EVENT;
-		} else {
+		    vport->cfg_enable_fc4_type != LPFC_ENABLE_BOTH)
+			mode = KERN_WARNING;
+		else
 			mode = KERN_INFO;
-			loglevel =  LOG_ELS;
-		}
 
-		/* PRLI failed */
-		lpfc_printf_vlog(vport, mode, loglevel,
-				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
+		/* Warn PRLI status */
+		lpfc_printf_vlog(vport, mode, LOG_ELS,
+				 "2754 PRLI DID:%06X Status:x%x/x%x, "
 				 "data: x%x x%x x%x\n",
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4, ndlp->nlp_state,
@@ -2854,11 +2850,11 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			goto out;
 		}
-		/* ADISC failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2755 ADISC failure DID:%06X Status:x%x/x%x\n",
-				 ndlp->nlp_DID, ulp_status,
-				 ulp_word4);
+		/* Warn ADISC status */
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "2755 ADISC DID:%06X Status:x%x/x%x\n",
+			      ndlp->nlp_DID, ulp_status,
+			      ulp_word4);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_ADISC);
 
@@ -3045,12 +3041,12 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * discovery.  The PLOGI will retry.
 	 */
 	if (ulp_status) {
-		/* LOGO failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2756 LOGO failure, No Retry DID:%06X "
-				 "Status:x%x/x%x\n",
-				 ndlp->nlp_DID, ulp_status,
-				 ulp_word4);
+		/* Warn LOGO status */
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "2756 LOGO, No Retry DID:%06X "
+			      "Status:x%x/x%x\n",
+			      ndlp->nlp_DID, ulp_status,
+			      ulp_word4);
 
 		if (lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 			skip_recovery = 1;
@@ -4837,11 +4833,10 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 			  (cmd == ELS_CMD_FDISC) &&
 			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_OUT_OF_RESOURCE)){
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
-						 "0125 FDISC Failed (x%x). "
-						 "Fabric out of resources\n",
-						 stat.un.lsRjtError);
+				lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+					      "0125 FDISC (x%x). "
+					      "Fabric out of resources\n",
+					      stat.un.lsRjtError);
 				lpfc_vport_set_state(vport,
 						     FC_VPORT_NO_FABRIC_RSCS);
 			}
@@ -4877,11 +4872,10 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 						LSEXP_NOTHING_MORE) {
 				vport->fc_sparam.cmn.bbRcvSizeMsb &= 0xf;
 				retry = 1;
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
-						 "0820 FLOGI Failed (x%x). "
-						 "BBCredit Not Supported\n",
-						 stat.un.lsRjtError);
+				lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+					      "0820 FLOGI (x%x). "
+					      "BBCredit Not Supported\n",
+					      stat.un.lsRjtError);
 			}
 			break;
 
@@ -4891,11 +4885,10 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			  ((stat.un.b.lsRjtRsnCodeExp == LSEXP_INVALID_PNAME) ||
 			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_INVALID_NPORT_ID))
 			  ) {
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
-						 "0122 FDISC Failed (x%x). "
-						 "Fabric Detected Bad WWN\n",
-						 stat.un.lsRjtError);
+				lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+					      "0122 FDISC (x%x). "
+					      "Fabric Detected Bad WWN\n",
+					      stat.un.lsRjtError);
 				lpfc_vport_set_state(vport,
 						     FC_VPORT_FABRIC_REJ_WWN);
 			}
@@ -5355,8 +5348,8 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
 	if (!vport) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"3177 ELS response failed\n");
+		lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
+				"3177 null vport in ELS rsp\n");
 		goto out;
 	}
 	if (cmdiocb->context_un.mbox)
@@ -11328,10 +11321,10 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
 			goto out;
-		/* FDISC failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "0126 FDISC failed. (x%x/x%x)\n",
-				 ulp_status, ulp_word4);
+		/* Warn FDISC status */
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "0126 FDISC cmpl status: x%x/x%x)\n",
+			      ulp_status, ulp_word4);
 		goto fdisc_failed;
 	}
 
-- 
2.38.0

