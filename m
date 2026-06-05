Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8DC3955DC
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681519; cv=none; b=WrRfkbzM+ooBW5QX5jJ8V4v4OBcNJ3P0fUREgSATKcL4grUrjTe6xjiPsgivtji2pFpUmg7HL9r4rVSxDtl3w0g52ozGfMEmr04Q7msv147kALNTpbngzUWCOSp2b9s7mjq4ZUwpm7TvvNaBvAm/Qjq28uTKmqUV+kwdhiaiWT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681519; c=relaxed/simple;
	bh=iHjYmlD/Vew8fuV4GWquVJQPOoYhkvd9fAimNDm4ZD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QU/qfHl6XheEzOS0btbCcY3l97vnlVlH/tUka5t4clfvyaVVQksFmqGtKMZ8jCvTJ3TfSShy3jHdydzDY8xjnHLZE8rlwnbSvncEOCDhbvrvcHVA8Ak1Bd2wgKujERS2nOk4AkldM0RZSArWoON35y9xOO23zpdV7NAf4o4iASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VrBK7DkR; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrBK7DkR"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51790c0a692so18779651cf.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681512; x=1781286312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oe2MW7CIOB6QT2a+25Ilk6tgK9hPv6iPjAw9Qm5fXBI=;
        b=VrBK7DkRC57do0QwPgFOCs9ldF+vuMIfQak4xoTxN4XLMHrnlknLKJJ/NjsmS0rE2S
         HdgrWSmPUvPqKVFlfRHjY4e0/vLzR+ZvExon/vDrQ4Zo0S+RY+SpBmJl5eSikji7l1WR
         ERzeXj22SHVN6dFwDLXojc5mhkh25hx1WDiyHvkPlUlg2T43Bs1nAklRk+1itjC2/Dqc
         QG1iCW70zRbnsG3x0BqKkOWSeA3slcIp5dHB5R9zVyhzodYqyR0gZJPYbWECbMezQiaj
         0asgpBVIAcc3kVSvsnS28ajm81OcB9dYpgpKR3X+k/n1gQH+0eLXmdYEJOeBb5uen+BJ
         fJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681512; x=1781286312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oe2MW7CIOB6QT2a+25Ilk6tgK9hPv6iPjAw9Qm5fXBI=;
        b=JbxAgiBx+lwMojmJ9y0c18aJH/NQL41iGL5PCZelhqJPsZGdtV+QwqzYpNE3tuMmAd
         cUdh99RVlM3ys1N99o1dR5b0LnCy30keytALbyqNoCHVMYmtv8YDyqI1heA0I5y5xB++
         3ycW3loGYxpA8N4elIfLe9YebEgYXp7B3JcbDHjeNnBLkTPvu+W+j7hfLZh2wP/7bogE
         ofaHZyuzoEWeeO/zmt/qBffXT7bPZOm7JrUuVEE6dK5hvNHbPLyYMZbj0IASLQQWeTzs
         sMTUdcdTAfKlYibrYJv0oYNzRRbtX5efEqZXtLc5IWEc/WrBAaxo+zB6rafCeb32OyoJ
         W7qg==
X-Gm-Message-State: AOJu0YyZMnjB03RbjorAs12aj6INz/Rit9HzmnJBTjH01qEX7QIykpdJ
	FP2H56il8hTafwveHBAjfxP4ooDGj7rAanESx/XOnV9SXJAAb1sg4uTGRzD1yIVV
X-Gm-Gg: Acq92OFOsNyyjN05lm4pRYK3Um8AW0tXW3b8mPV/+6LGszWqc+P3CbNaFu44A5ICrXK
	foA5DUYpXgQEoYptTWjcpXq4CrjG1RcI8G0vN3m+JYmvBwsRFksbhGx73933jCYEuqA1MI/m2NP
	EZjlTJPWjOuIxrwb7dW5iNNS1YJwX+oDxIasYlwYyt0zOh/0m+ATLn7Qcp2GaJHJ4ND0J1YZ7zA
	/jMn/SqlqiGLOeXa4T3uBgQHpgaV3XPgc6NUELjzwTYOO4CQbctfuogrFrMQua6RtmNuoNZwRM6
	a4nCfKorYIn/N4BX6V0917N3DBUba8MWh+/G6+ZS+4R7dAIs1Uq5FWi6CdwLor86O2LwvyyycW1
	vh6VgxYc3Q3WIs44B+1Mb959KRHq/hJvmzduWR/nB6NHdmuIwUv9OG6Wu3EIN/Ecg1QS5gvBEJ4
	jJPjGieor4axS83Gp4FPbXA5FKJME93Xo7dLLJPYla9dBTE9wEuF6bX4tK3n6XKUrKdr/e0c5Cr
	4rHohTeZMisVKdyrCk/RbFYt0czl87STkm8kMKMgoHtavnyqWR+/A==
X-Received: by 2002:a05:622a:1811:b0:50d:62d1:c3fa with SMTP id d75a77b69052e-517959d5f02mr70734121cf.2.1780681511835;
        Fri, 05 Jun 2026 10:45:11 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.45.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:45:11 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 12/14] lpfc: Update ELS ACC logging for diagnostic troubleshooting
Date: Fri,  5 Jun 2026 11:23:34 -0700
Message-Id: <20260605182336.134919-13-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, there are ELS ACC routines that lack debug log messages to
indicate when ACC frame transmission run into issues.  The generic
lpfc_els_rsp_acc and more specific ACC routines are updated to log when
there is an issue with transmitting the frame.  The routines are also
updated to return different return codes when encountering various
transmission issues and their function comment header is updated.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 187 ++++++++++++++++++++++++++---------
 1 file changed, 141 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 38a23646538e..27ccd3ad4b7a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4037,13 +4037,8 @@ lpfc_els_rcv_rdf(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	int rc;
 
 	rc = lpfc_els_rsp_acc(vport, ELS_CMD_RDF, cmdiocb, ndlp, NULL);
-	/* Send LS_ACC */
-	if (rc) {
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
-				 "1623 Failed to RDF_ACC from x%x for x%x Data: %d\n",
-				 ndlp->nlp_DID, vport->fc_myDID, rc);
+	if (rc)
 		return -EIO;
-	}
 
 	rc = lpfc_issue_els_rdf(vport, 0);
 	/* Issue new RDF for reregistering */
@@ -5777,7 +5772,10 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  *
  * Return code
  *   0 - Successfully issued acc response
- *   1 - Failed to issue acc response
+ *   -ENOMEM - IOCB not prepped successfully
+ *   -EIO - The IOCB failed to issue successfully
+ *   -ENODEV - No associated node for IOCB
+ *   -EACCES - ACC unhandled for this command
  **/
 int
 lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
@@ -5796,6 +5794,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	int rc;
 	ELS_PKT *els_pkt_ptr;
 	struct fc_els_rdf_resp *rdf_resp;
+	int err;
+	uint32_t old_opcode = 0;
 
 	switch (flag) {
 	case ELS_CMD_ACC:
@@ -5804,7 +5804,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 					     ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
 		if (!elsiocb) {
 			clear_bit(NLP_LOGO_ACC, &ndlp->nlp_flag);
-			return 1;
+			err = -ENOMEM;
+			goto err_out;
 		}
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
@@ -5839,8 +5840,10 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		cmdsize = (sizeof(struct serv_parm) + sizeof(uint32_t));
 		elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry,
 					     ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
-		if (!elsiocb)
-			return 1;
+		if (!elsiocb) {
+			err = -ENOMEM;
+			goto err_out;
+		}
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			wqe = &elsiocb->wqe;
@@ -5917,8 +5920,10 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		cmdsize = sizeof(uint32_t) + sizeof(PRLO);
 		elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry,
 					     ndlp, ndlp->nlp_DID, ELS_CMD_PRLO);
-		if (!elsiocb)
-			return 1;
+		if (!elsiocb) {
+			err = -ENOMEM;
+			goto err_out;
+		}
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			wqe = &elsiocb->wqe;
@@ -5955,8 +5960,10 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		cmdsize = sizeof(*rdf_resp);
 		elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry,
 					     ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
-		if (!elsiocb)
-			return 1;
+		if (!elsiocb) {
+			err = -ENOMEM;
+			goto err_out;
+		}
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			wqe = &elsiocb->wqe;
@@ -5991,7 +5998,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		rdf_resp->lsri.rqst_w0.cmd = ELS_RDF;
 		break;
 	default:
-		return 1;
+		err = -EACCES;
+		goto err_out;
 	}
 	if (test_bit(NLP_LOGO_ACC, &ndlp->nlp_flag)) {
 		if (!test_bit(NLP_RPI_REGISTERED, &ndlp->nlp_flag) &&
@@ -6006,7 +6014,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
@@ -6027,7 +6036,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		return 1;
+		err = -EIO;
+		goto err_out;
 	}
 
 	/* Xmit ELS ACC response tag <ulpIoTag> */
@@ -6039,6 +6049,17 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi, vport->fc_flag, kref_read(&ndlp->kref));
 	return 0;
+
+err_out:
+	if (oldiocb->cmd_dmabuf && oldiocb->cmd_dmabuf->virt)
+		old_opcode = *(uint32_t *)oldiocb->cmd_dmabuf->virt;
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "1027 Xmit ELS ACC Unsuccessful: "
+			 "cmd: x%x, error_code: %d "
+			 "S_ID: x%x\n", old_opcode, err,
+			 vport->fc_myDID);
+	return err;
 }
 
 /**
@@ -6253,7 +6274,9 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  *
  * Return code
  *   0 - Successfully issued acc adisc response
- *   1 - Failed to issue adisc acc response
+ *   -ENOMEM - IOCB not prepped successfully
+ *   -EIO - The IOCB failed to issue successfully
+ *   -ENODEV - No associated node for IOCB
  **/
 int
 lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
@@ -6268,12 +6291,15 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	uint16_t cmdsize;
 	int rc;
 	u32 ulp_context;
+	int err;
 
 	cmdsize = sizeof(uint32_t) + sizeof(ADISC);
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_ACC);
-	if (!elsiocb)
-		return 1;
+	if (!elsiocb) {
+		err = -ENOMEM;
+		goto err_out;
+	}
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		wqe = &elsiocb->wqe;
@@ -6320,17 +6346,26 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		return 1;
+		err = -EIO;
+		goto err_out;
 	}
 
 	return 0;
+
+err_out:
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "1025 Xmit ADISC ACC Unsuccessful: "
+			 "error_code: %d S_ID: x%x\n",
+			 err, vport->fc_myDID);
+	return err;
 }
 
 /**
@@ -6350,7 +6385,10 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
  *
  * Return code
  *   0 - Successfully issued acc prli response
- *   1 - Failed to issue acc prli response
+ *   -ENOMEM - IOCB not prepped successfully
+ *   -EIO - The IOCB failed to issue successfully
+ *   -ENODEV - No associated node for IOCB
+ *   -EACCES - Acc not needed for this command
  **/
 int
 lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
@@ -6370,6 +6408,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	struct lpfc_dmabuf *req_buf;
 	int rc;
 	u32 elsrspcmd, ulp_context;
+	int err;
 
 	/* Need the incoming PRLI payload to determine if the ACC is for an
 	 * FC4 or NVME PRLI type.  The PRLI type is at word 1.
@@ -6391,13 +6430,16 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		cmdsize = sizeof(uint32_t) + sizeof(struct lpfc_nvme_prli);
 		elsrspcmd = (ELS_CMD_ACC | (ELS_CMD_NVMEPRLI & ~ELS_RSP_MASK));
 	} else {
-		return 1;
+		err = -EACCES;
+		goto err_out;
 	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 				     ndlp->nlp_DID, elsrspcmd);
-	if (!elsiocb)
-		return 1;
+	if (!elsiocb) {
+		err = -ENOMEM;
+		goto err_out;
+	}
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		wqe = &elsiocb->wqe;
@@ -6512,17 +6554,28 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	elsiocb->ndlp =  lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		return 1;
+		err = -EIO;
+		goto err_out;
 	}
 
 	return 0;
+
+err_out:
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "1026 Xmit PRLI ACC Unsuccessful: "
+			 "cmd: x%x, error_code: %d "
+			 "S_ID: x%x\n",
+			 *(uint32_t *)oldiocb->cmd_dmabuf->virt, err,
+			 vport->fc_myDID);
+	return err;
 }
 
 /**
@@ -6543,7 +6596,9 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
  *
  * Return code
  *   0 - Successfully issued acc rnid response
- *   1 - Failed to issue acc rnid response
+ *   -ENOMEM - IOCB not prepped successfully
+ *   -EIO - The IOCB failed to issue successfully
+ *   -ENODEV - No associated node for IOCB
  **/
 static int
 lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
@@ -6558,6 +6613,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 	uint16_t cmdsize;
 	int rc;
 	u32 ulp_context;
+	int err;
 
 	cmdsize = sizeof(uint32_t) + sizeof(uint32_t)
 					+ (2 * sizeof(struct lpfc_name));
@@ -6566,8 +6622,10 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_ACC);
-	if (!elsiocb)
-		return 1;
+	if (!elsiocb) {
+		err = -ENOMEM;
+		goto err_out;
+	}
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		wqe = &elsiocb->wqe;
@@ -6626,17 +6684,26 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		return 1;
+		err = -EIO;
+		goto err_out;
 	}
 
 	return 0;
+
+err_out:
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "1028 Xmit RNID ACC Unsuccessful: "
+			 "error_code: %d S_ID: x%x\n",
+			 err, vport->fc_myDID);
+	return err;
 }
 
 /**
@@ -6696,7 +6763,9 @@ lpfc_els_clear_rrq(struct lpfc_vport *vport,
  *
  * Return code
  *   0 - Successfully issued acc echo response
- *   1 - Failed to issue acc echo response
+ *   -ENOMEM - IOCB not prepped successfully
+ *   -EIO - The IOCB failed to issue successfully
+ *   -ENODEV - No associated node for IOCB
  **/
 static int
 lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
@@ -6710,6 +6779,7 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 	uint16_t cmdsize;
 	int rc;
 	u32 ulp_context;
+	int err;
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		cmdsize = oldiocb->wcqe_cmpl.total_data_placed;
@@ -6723,8 +6793,10 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 		cmdsize = LPFC_BPL_SIZE;
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_ACC);
-	if (!elsiocb)
-		return 1;
+	if (!elsiocb) {
+		err = -ENOMEM;
+		goto err_out;
+	}
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		wqe = &elsiocb->wqe;
@@ -6760,17 +6832,26 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 	elsiocb->ndlp =  lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		return 1;
+		err = -EIO;
+		goto err_out;
 	}
 
 	return 0;
+
+err_out:
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "1029 Xmit ECHO ACC Unsuccessful: "
+			 "error_code: %d S_ID: x%x\n",
+			 err, vport->fc_myDID);
+	return err;
 }
 
 /**
@@ -8473,14 +8554,14 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	vport->fc_rscn_id_list[vport->fc_rscn_id_cnt++] = pcmd;
 	/* Indicate we are done walking fc_rscn_id_list on this vport */
 	vport->fc_rscn_flush = 0;
+	/* Send back ACC */
+	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 	/*
 	 * If we zero, cmdiocb->cmd_dmabuf, the calling routine will
 	 * not try to free it.
 	 */
 	cmdiocb->cmd_dmabuf = NULL;
 	lpfc_set_disctmo(vport);
-	/* Send back ACC */
-	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 	/* send RECOVERY event for ALL nodes that match RSCN payload */
 	lpfc_rscn_recovery_check(vport);
 	return lpfc_els_handle_rscn(vport);
@@ -9280,7 +9361,9 @@ lpfc_send_rrq(struct lpfc_hba *phba, struct lpfc_node_rrq *rrq)
  *
  * Return code
  *   0 - Successfully issued ACC RPL ELS command
- *   1 - Failed to issue ACC RPL ELS command
+ *   -ENOMEM - IOCB not prepped successfully
+ *   -EIO - The IOCB failed to issue successfully
+ *   -ENODEV - No associated node for IOCB
  **/
 static int
 lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
@@ -9294,12 +9377,15 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	u32 ulp_context;
+	int err;
 
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_ACC);
 
-	if (!elsiocb)
-		return 1;
+	if (!elsiocb) {
+		err = -ENOMEM;
+		goto err_out;
+	}
 
 	ulp_context = get_job_ulpcontext(phba, elsiocb);
 	if (phba->sli_rev == LPFC_SLI_REV4) {
@@ -9342,17 +9428,26 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		return 1;
+		err = -EIO;
+		goto err_out;
 	}
 
 	return 0;
+
+err_out:
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "1030 Xmit ELS RPL ACC Unsuccessful: "
+			 "error_code: %d S_ID: x%x\n",
+			 err, vport->fc_myDID);
+	return err;
 }
 
 /**
@@ -9587,7 +9682,7 @@ lpfc_els_rcv_fan(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  * @ndlp: pointer to a node-list data structure.
  *
  * Return code
- *   0 - Successfully processed echo iocb (currently always return 0)
+ *   0 - Successfully processed edc iocb (currently always return 0)
  **/
 static int
 lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
-- 
2.38.0

