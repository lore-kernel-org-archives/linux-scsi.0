Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3DB4A4986
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682269; cv=none; b=AV9ZWpRWJ6/d1fnK3FsKX+z1aWSbu5zLZot2/VR3dqWytHFVC2RYJuD3yhdjd3/bvw7+H9YRjUUtYqjSkLY6ioryetWvHngeLsjHuSzByh0KajaX7X4XMhccpQ7nBsFFR37Ntw/kAQwhqkWNzRvjUwv5/jOBYsyP8tD02lZyoFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682269; c=relaxed/simple;
	bh=nDdglWLi2r1R6Q4PJaMMQpmMS7nHf8EVyJq8NT+6kQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O4KbMjp0njQpLo7sVEIHWt7zZgM5C5o9MW88dxlbawOGmn+9DbyQE8zhGK75RFOO2L2TE10leBACrCjajoWTUhrOFp+spX2llAi7O0azFeKAA5elnUbp+1Ey5NtZuHYQS+8P60ilAQmt3el9YsAmEdwddNTx1y4abg6owXU1FKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CBnLpUJm; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CBnLpUJm"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso1011606a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682266; x=1790287066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mlFvM4moR7qOovqoBufsUQd10RbNWMLGNcISgaxpHzY=;
        b=CBnLpUJmM8YZtT290i8lajVLGVq8u6+Yg+Jdw5bHyR/iegmdwXw2F2jER1VAFY9LJi
         OHb53iwPgOmK6Z+s1fueFp4GdFu3C/k3uKSYgl9ncQGuvTlNYH3p3PLlYvxPJoUBKdE7
         9jqLMMmIbw3327jWlKfJvCwALQoYXvdL8Z7S6a/N2wGtirNQw7rrpHmIs3sCXT4sW2j9
         esX8UdypO10qJWJV3s7lFWwb+D9eKV2N87NF4u5hIMc6opC4LOL8QPAfdqXcyyeOMo4/
         jpbo2fXtsIwJIT5Y1GCkFZDQ0ZBN1RLuUiInoPvyU6RYF7dHPRR3H1WTOVaTtbGp1cl1
         9b+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682266; x=1790287066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mlFvM4moR7qOovqoBufsUQd10RbNWMLGNcISgaxpHzY=;
        b=j0+yOxZxUHyBY/2xoOWMseb+k7H+tE5JLTMqE5gieyFgAucgJTrImfYMjAzPZJ7Y21
         I/tiaMfuBFMM5mbDhMGVo9YNElU/CQzr9MZnqGI78avKqe0zIDAXv0kDLX33lxCsRlwS
         jGzV7vp/rVsyFzBSrjWvlhBuGV18T9nOlKn1/2uFV8PqSG3ZyNiKowjjrqDcy/VQ6lTx
         tbEwAM7mN/JJVUZ/zAdZVeMJrMatAyrvRs2lcjZsKNRDxNPfAbFxJEyLrPgoFdtUkOmd
         qGaW1Y6tzLhPCK2mAnU3KSs5HsCjJFn/hgsQXpeeYxINcfuqzYd+bqULligL+OVWWJ+Y
         RxDQ==
X-Gm-Message-State: AFuF++lMSTLHeEwV9L8BpZYUASaNkxo5oFdY7W3zdyPYJAUbb0sPdnSr
	1Z86o/SXtpBzEc+Ox9XqqB+de9Gh3n62Xh7o35jAlreBvSx0RT7Ibr8l5S2mD9Ef
X-Gm-Gg: AYBFou1jUFp43zP2eaP3BFQNKQC9uIG3yBQPGSuiHjj7szwzTb1pFdjLw0gLZJY3u2V
	nIjLon75UAEsMgaw67RRZLVFiANf7vTRHRytyjqSMd5t2HwE6lD6JMtRHlmFddJYoJhpnWQ+WNi
	cKA8h3JJQQNoncMRWBayU2vFS7bTwPJ0F/R9GZrKruTJepu7B2lD6POymIQ0JTq5QuOwkmDyWWF
	5aqy+F1BcdydXytjTmHQSlTcHZGVlpQroP/fKQgx+0tHTvtg5/wFfb//EqgHIRXN41kyDlXOi1f
	keKUvMW20ZN4tOhoKWWUN8QQL+MJmitbgOrkbhImH+0NH7YC/929msLQKRMB2Tu3MPX95PT00pD
	aEPwsHwa19dokgI3c5Za8hB2bOjmWidL8d6W7/FKchZbERBxz53YiTZqfC7JKUK7Zqyjyt70xiX
	a4pchfQaOz/J7tmuv0bhqH8vDYQYJADC31BMi0Acfv2bsSWWzwR936HqPcp/eRk4yYdNXahY94D
	LDKuAG9kvmT0KuvSmLdqEstJK2l7kb063oCAGzaLNTi024RxdUi5K9AoXedzJN9rhdTaQ==
X-Received: by 2002:a17:90b:57e6:b0:39e:58d8:f899 with SMTP id 98e67ed59e1d1-39e58d8fa69mr184a91.35.1789682264703;
        Thu, 17 Sep 2026 14:57:44 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:44 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 12/14] lpfc: Update ELS ACC logging for diagnostic troubleshooting
Date: Thu, 17 Sep 2026 15:20:13 -0700
Message-Id: <20260917222015.61053-13-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
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

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 187 ++++++++++++++++++++++++++---------
 1 file changed, 141 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index bf71b5a3e55e..cb06dbc9edfa 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4053,13 +4053,8 @@ lpfc_els_rcv_rdf(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
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
@@ -5793,7 +5788,10 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -5812,6 +5810,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	int rc;
 	ELS_PKT *els_pkt_ptr;
 	struct fc_els_rdf_resp *rdf_resp;
+	int err;
+	uint32_t old_opcode = 0;
 
 	switch (flag) {
 	case ELS_CMD_ACC:
@@ -5820,7 +5820,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 					     ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
 		if (!elsiocb) {
 			clear_bit(NLP_LOGO_ACC, &ndlp->nlp_flag);
-			return 1;
+			err = -ENOMEM;
+			goto err_out;
 		}
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
@@ -5855,8 +5856,10 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
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
@@ -5933,8 +5936,10 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
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
@@ -5971,8 +5976,10 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
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
@@ -6007,7 +6014,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		rdf_resp->lsri.rqst_w0.cmd = ELS_RDF;
 		break;
 	default:
-		return 1;
+		err = -EACCES;
+		goto err_out;
 	}
 	if (test_bit(NLP_LOGO_ACC, &ndlp->nlp_flag)) {
 		if (!test_bit(NLP_RPI_REGISTERED, &ndlp->nlp_flag) &&
@@ -6022,7 +6030,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
@@ -6043,7 +6052,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		return 1;
+		err = -EIO;
+		goto err_out;
 	}
 
 	/* Xmit ELS ACC response tag <ulpIoTag> */
@@ -6055,6 +6065,17 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
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
@@ -6269,7 +6290,9 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
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
@@ -6284,12 +6307,15 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
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
@@ -6336,17 +6362,26 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (lpfc_iocb_failed(rc)) {
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
@@ -6366,7 +6401,10 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
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
@@ -6386,6 +6424,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	struct lpfc_dmabuf *req_buf;
 	int rc;
 	u32 elsrspcmd, ulp_context;
+	int err;
 
 	/* Need the incoming PRLI payload to determine if the ACC is for an
 	 * FC4 or NVME PRLI type.  The PRLI type is at word 1.
@@ -6407,13 +6446,16 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
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
@@ -6528,17 +6570,28 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	elsiocb->ndlp =  lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (lpfc_iocb_failed(rc)) {
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
@@ -6559,7 +6612,9 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
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
@@ -6574,6 +6629,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 	uint16_t cmdsize;
 	int rc;
 	u32 ulp_context;
+	int err;
 
 	cmdsize = sizeof(uint32_t) + sizeof(uint32_t)
 					+ (2 * sizeof(struct lpfc_name));
@@ -6582,8 +6638,10 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 
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
@@ -6642,17 +6700,26 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (lpfc_iocb_failed(rc)) {
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
@@ -6712,7 +6779,9 @@ lpfc_els_clear_rrq(struct lpfc_vport *vport,
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
@@ -6726,6 +6795,7 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 	uint16_t cmdsize;
 	int rc;
 	u32 ulp_context;
+	int err;
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		cmdsize = oldiocb->wcqe_cmpl.total_data_placed;
@@ -6739,8 +6809,10 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
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
@@ -6776,17 +6848,26 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 	elsiocb->ndlp =  lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (lpfc_iocb_failed(rc)) {
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
@@ -8489,14 +8570,14 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
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
@@ -9296,7 +9377,9 @@ lpfc_send_rrq(struct lpfc_hba *phba, struct lpfc_node_rrq *rrq)
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
@@ -9310,12 +9393,15 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
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
@@ -9358,17 +9444,26 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (lpfc_iocb_failed(rc)) {
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
@@ -9603,7 +9698,7 @@ lpfc_els_rcv_fan(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
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

