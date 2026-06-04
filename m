Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B7D39936D
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599066; cv=none; b=SRxVlmHmhO++Qm2Yu2DZr1ouiqmVXTrJM8aNj1BXJ2WcaTBS8IufPRr7SI0hNyHwX/be00tp50gLbj7vro0/g7+WdBQkTPpYXDPkSjhC/32MCAg4r3KuMuqOr9FwjRaOkLkMBpgsrco8h4qZ0uTvdd+DEstEwqLkJjgdVMkJJ5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599066; c=relaxed/simple;
	bh=iHjYmlD/Vew8fuV4GWquVJQPOoYhkvd9fAimNDm4ZD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ub2Iu3XZUVB8M09q3xh3Swi0ojsO3ohnyDf3odvdV3z6bfxuja+2nHiu88zEXkuD0PMRTM8YqetKHbRbHhGz7k/vzpM3IwgU7h2R2fAUEKiYFDf51W0425PIR4VF+VrEWE1AROFFABf6ohIwfNFRI9dId0J/B0C/9AxZJzK4/1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G4thfo3z; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G4thfo3z"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-91574384cc2so123856785a.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599064; x=1781203864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oe2MW7CIOB6QT2a+25Ilk6tgK9hPv6iPjAw9Qm5fXBI=;
        b=G4thfo3z8X6zhP2DVUNqxinl+gQFmVxKpxAwnzdBJ2ZEPUkcy3Eo37jSZu9kBGsYXN
         puYXJg8EUxMDcR5dAr9j7x1vTgVhgRg6t1KEbrXfTdPO9PCPXztbs7tW94E3SENx2SOk
         34fRfBPCwG6xxwodjUgCJTkPOzUw5YSnWhjjMTXhYSj3uXFI0YpFFq5n89w3dmUgBXcy
         F/5yhJz/To4a70Bsj97fK6Z6eIcA3/LApo2siup/Oxga/1KnQSEMOX97t8jN9f34vEP7
         0jmVy1Qo0hMmN9RDEtuC2V0+sS64fPqEFM9rWRyppn6070qGVe3BzEP08rtF9b3xA8HW
         WBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599064; x=1781203864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oe2MW7CIOB6QT2a+25Ilk6tgK9hPv6iPjAw9Qm5fXBI=;
        b=DRF5mV+0MzPPPf78NyM1U52LCbUCFVjGni4/tcmMNOTKmXQBt44pJe0JjfXVwsIfvN
         Sgt1Xq/RiEmqjKIi2V1lwzZunVyK92z2bzuTXJhPzBh8mURdkUQ3SSucedBVav74P13z
         az5BvSvBuLdRtPm3Rvu5SjYgNdGbs1I8UaoScSva3xXtjCuPKijsR1lENwWPLnvlzDLd
         d48ZJK9YOJOK/Kzyef7KPoQR1VW3ys7g8oGzZmbH+EyyIBLuFrGYYqaR7fxMQJ/yJ52P
         aM5J8URwP86zMH/fPmZ3LrPu/RHZb8DNwOAvRWgBH9q0WoEYaTPayghXDlqtCI1zR+tz
         44MA==
X-Gm-Message-State: AOJu0YyB21++hcKyYsSDF9IwpKePqlftdkVnjkc03K4VKPPbL9UmiPz1
	vSGDOgWvAc+Iv7QjUph2qTe4cT4MTpNIwnRYHofol/CFl/yHkXFrGNAsDfBIyeHV
X-Gm-Gg: Acq92OHqCWaA96lC5oSZSE6n4J87etkgwFDz/GaO2ItJwztM6rBL7XlU6/1ghnBcOs4
	c3YFiv1depQkkiiwGqQJEXniQpKq+/sIkVW9p9HXYph1fiGsObSfgkFBGqQQinqjuNMGla4o89m
	9V835mrRk1j5FXOTVPdjoCqUAxTv96796MwSeVozv266dqXqhpwK4QWOIZ2bdptokqcx0iMqUvV
	9kG44m8bKlKdPgnb7WBktGSEWT/MPehi31+MMMU904qNBnv5MyD8+daCSPRvBQGBn+kkwXKxt9C
	ShUjZ1diraP1BXkiXRC4x7k+yhfAS4i2+VJH8gy++ZD39jTpgzRLGRfWQKiMt7st3wk07VGcnEJ
	fsyfPI6twW2u/CN8IefTv+UVZnSMAOXqMCf+tu5OvWAfKydsWRAhjkPdSsww1NHTUpxMJXixolS
	R8OuVHQkpJ+v24mvhxQoBytx07AeP54ViqdvZuBIvg8wAT0Jn9IK/aZGrlbQtg3CVGnTCYCIm2I
	eKsitttXBdBvFI495x0rJb8H5mx2bwzXhDTER36g4tZtBloMdgDJg==
X-Received: by 2002:a05:620a:2a05:b0:915:9f87:eaaa with SMTP id af79cd13be357-915a9db7441mr61589785a.42.1780599063378;
        Thu, 04 Jun 2026 11:51:03 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.51.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:51:03 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 12/14] lpfc: Update ELS ACC logging for diagnostic troubleshooting
Date: Thu,  4 Jun 2026 12:29:35 -0700
Message-Id: <20260604192937.65605-13-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260604192937.65605-1-justintee8345@gmail.com>
References: <20260604192937.65605-1-justintee8345@gmail.com>
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

