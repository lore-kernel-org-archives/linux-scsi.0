Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB42E1527BB
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 23:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722034810; cv=none; b=nPnlvOjGB4bM3VZLx7D6BJyadtgfa3j+4EQnbk0Uf4ZyhX9eqGSZqLvKnHrEUzzmFZl8HR2I1gyh74Q5E+yMI+GnK/vWgBbKEH8W3Vr1vOL6/CRWHFEjocc4r6V5oEChih5XxL1J1aBe5MH3QhawT5qF05kyN5XGmlg0cKPnBfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722034810; c=relaxed/simple;
	bh=YfC8+wMtK3tDA8+FCyrmBh5/pAjFiuwzJdBXNu5YcrU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KTA/8JppL8gUHNLMjRkYpHX1AD+MWxpmn0O0TLGoSpKdM6HZ7Uy8HMBQ4cUw+VFI7EY1Y28YCo6fmFFTumDRxfX+S76+UZDJ9MH0WkbBmtSCR8Ii8SS4NT0bC4b89dMptu+jUnKAb7MhzF7bdEm4TcgC6z1mJ4r4La4X1u0WrpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tt+1Gola; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tt+1Gola"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3db10d8830aso169970b6e.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 16:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722034808; x=1722639608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MddidqU/RGIlO0vgZMgZIJgKpfz/9aGGUJheDEJs4CY=;
        b=Tt+1GolaTHFh/FV0Q1EdSORZyFW5p+9jgi7uZG0SnL3cOITmJXQUDY+DFya0ClVEdF
         8wK6h23DuScq8WrGYLdnVpvrMcOF/p2Hr437biXOfHnq5/hbH0jGDp3zuu4B6fB0b51n
         Pm48Z9DlsPciZKN2Y9w6vyH6Um9tmr0uUgR1OLk3xYVMOTbXnK1gzqmrBKA8hWct1q6O
         PDYAPX5l2q9YYGuzF+U3QEyBJa0Xi/pDdxfMJj/nrVbvElrk/zV0KMRmR2aFZct6DvDy
         eFlDJa0IKqa5AOUp+mM1WX0byQEUCoCxMKTUQz04ei3t5xTnqarsdbjwbDW4UTJA41K7
         MOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722034808; x=1722639608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MddidqU/RGIlO0vgZMgZIJgKpfz/9aGGUJheDEJs4CY=;
        b=a23Nt+4HsrTyGjh8k7BApdGdse4edpgSO9ee9GzSCqI6drGNoWg0k0IH/dD2BtwyGs
         7ha9ZFdEH5nm3AvN5BdD/Mkenl1+AAD0v18OS5BNhv4SPTvrWzA16ZF+l3EDLpkULPC1
         E6PwIxltehKh8gWuwfpjoRJoZL1sTawrG8lit3iD/qy6fPUR0ksqHU5G4pQTVSixXC2L
         +N5VzN4ajd9Dzcc2bHUni22USO0jM0Gr1oa8lnUdgWnaqPPKMGCtzzHO/k2OV3Bw6sZZ
         ffqv0e6M4yr4lEH/i+4vXrcOON1ilb2gW/kN5W20kan9RHwRVNzDw/FLaLMCSiOPk8ld
         kHSA==
X-Gm-Message-State: AOJu0YyKwnAhBc98vahKjFelJREq9PBf/TzRhI9hIQARrrsY+EyD9aSz
	3R7SoNY6YVx57k6K+lH+/6ebuN2f8UuGALzWHxC1HqmYyUNnBpJIzbMJug==
X-Google-Smtp-Source: AGHT+IEElMmc+GWvOT/Tsw9MFFeh3lY1tuJpTH3JuFvn1fQJl33HhCOZcVBzXbn0GCDIN/SUrCdy/Q==
X-Received: by 2002:a05:687c:2c19:b0:259:f03c:4e90 with SMTP id 586e51a60fabf-264a35d1c79mr4671087fac.4.1722034807606;
        Fri, 26 Jul 2024 16:00:07 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8834b1sm3308540b3a.178.2024.07.26.16.00.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2024 16:00:07 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/8] lpfc: Update PRLO handling in direct attached topology
Date: Fri, 26 Jul 2024 16:15:10 -0700
Message-Id: <20240726231512.92867-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240726231512.92867-1-justintee8345@gmail.com>
References: <20240726231512.92867-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A kref imbalance occurs when handling an unsolicited PRLO in direct
attached topology.

Rework PRLO rcv handling when in MAPPED state.  Save the state that we were
handling a PRLO by setting nlp_last_elscmd to ELS_CMD_PRLO.  Then in the
lpfc_cmpl_els_logo_acc completion routine, manually restart discovery.  By
issuing the PLOGI, which nlp_gets, before nlp_put at the end of the
lpfc_cmpl_els_logo_acc routine, we are saving us from a final nlp_put.
And, we are still allowing the unreg_rpi to happen.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 27 ++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_nportdisc.c | 22 ++++++++++++++++++++--
 2 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b5a8d050419a..de0ec945d2f1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5246,9 +5246,10 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* ACC to LOGO completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0109 ACC to LOGO completes to NPort x%x refcnt %d "
-			 "Data: x%x x%x x%x\n",
-			 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp->nlp_flag,
-			 ndlp->nlp_state, ndlp->nlp_rpi);
+			 "last els x%x Data: x%x x%x x%x\n",
+			 ndlp->nlp_DID, kref_read(&ndlp->kref),
+			 ndlp->nlp_last_elscmd, ndlp->nlp_flag, ndlp->nlp_state,
+			 ndlp->nlp_rpi);
 
 	/* This clause allows the LOGO ACC to complete and free resources
 	 * for the Fabric Domain Controller.  It does deliberately skip
@@ -5260,18 +5261,22 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 
 	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
-		/* If PLOGI is being retried, PLOGI completion will cleanup the
-		 * node. The NLP_NPR_2B_DISC flag needs to be retained to make
-		 * progress on nodes discovered from last RSCN.
-		 */
-		if ((ndlp->nlp_flag & NLP_DELAY_TMO) &&
-		    (ndlp->nlp_last_elscmd == ELS_CMD_PLOGI))
-			goto out;
-
 		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
 			lpfc_unreg_rpi(vport, ndlp);
 
+		/* If came from PRLO, then PRLO_ACC is done.
+		 * Start rediscovery now.
+		 */
+		if (ndlp->nlp_last_elscmd == ELS_CMD_PRLO) {
+			spin_lock_irq(&ndlp->lock);
+			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
+			spin_unlock_irq(&ndlp->lock);
+			ndlp->nlp_prev_state = ndlp->nlp_state;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
+			lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
+		}
 	}
+
  out:
 	/*
 	 * The driver received a LOGO from the rport and has ACK'd it.
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index f6a53446e57f..4574716c8764 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2652,8 +2652,26 @@ lpfc_rcv_prlo_mapped_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	/* flush the target */
 	lpfc_sli_abort_iocb(vport, ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 
-	/* Treat like rcv logo */
-	lpfc_rcv_logo(vport, ndlp, cmdiocb, ELS_CMD_PRLO);
+	/* Send PRLO_ACC */
+	spin_lock_irq(&ndlp->lock);
+	ndlp->nlp_flag |= NLP_LOGO_ACC;
+	spin_unlock_irq(&ndlp->lock);
+	lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
+
+	/* Save ELS_CMD_PRLO as the last elscmd and then set to NPR.
+	 * lpfc_cmpl_els_logo_acc is expected to restart discovery.
+	 */
+	ndlp->nlp_last_elscmd = ELS_CMD_PRLO;
+	ndlp->nlp_prev_state = ndlp->nlp_state;
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_ELS | LOG_DISCOVERY,
+			 "3422 DID x%06x nflag x%x lastels x%x ref cnt %u\n",
+			 ndlp->nlp_DID, ndlp->nlp_flag,
+			 ndlp->nlp_last_elscmd,
+			 kref_read(&ndlp->kref));
+
+	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+
 	return ndlp->nlp_state;
 }
 
-- 
2.38.0

