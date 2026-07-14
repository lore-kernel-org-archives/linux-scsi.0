Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD51757EA
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989479; cv=none; b=hHAu7cd/g0h82int6LSPxpGK6kE2Q/E8NkcpPVzQasT5ZgoIdkH5McK34yBEQIdC13XCpxtBPXJrKdSEnHdebqtkq/UY8lut+pDL6rd7BhLTdcW3vBkb4ti9m3W8VvHbPEjh6IJ1CrLLRP4KhwvzJlhchZh+z0xUFWjKqmUJ1XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989479; c=relaxed/simple;
	bh=pITOK6U4OdCAtlJF1TzT3nklxd2Xlu/c07Wagkw4+zE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEvucvWPaByNEw/gBL45mUZ6/dR2U0nX09MLuApHXoYb64eatxAWOD3W8YEzou8T9F51OI/6AbG9Ie7Y2ReTknt8lzJp3NoBhANm6/Uy9faHbtq1IX4iX/ANPnALmDVRMXKH/s2HQmfWqO7XPosRLCX7yknfun4KftIMpNTtHiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b8/xpWhH; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8/xpWhH"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-9034b6b7674so24064626d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989476; x=1784594276; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z0yMLYkR3uY3uCAlA/oTkXHtvXoA82YznZIkmxKgCRg=;
        b=b8/xpWhHE4fYVQgGpjv9tbKQ+isT8j6JQ02M1BM4L6A9HFI9dUh8GE0wuvR3drKKNh
         33Piv2d7yXJaEodtLMYl0RBwjrgfifBjsC0PP8JAYKUwJwrj3lme4oDvowBlBS8bES2B
         9mTyqJZ7yRNLWA+PZn6gf1U2d9ZUDrnk9tT8z7nn4I9T62uHSyckLnYGhIfq2zDjWmBb
         YjBPG7J9wSe9tdKJgLcTE5KVQ/acooS6h3qPC5V+8j2m9roS04DvBDDoCIw8WZKKe+vn
         uYiRoY68uY6w8r0cM0G6BMnOOw/q4iD07QfXAeS4xa3C8dcFStVoyGveYvbSSxlKdOVK
         RoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989476; x=1784594276;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z0yMLYkR3uY3uCAlA/oTkXHtvXoA82YznZIkmxKgCRg=;
        b=JI/OQdZzvKK9VvvBI3BNtom2CbCB3FHscTp1hU6Ol/3Y/OXP5/5Tl0ofkL3GWJ6IxO
         S/PDxCdTeKxo/iHWUsncxEfc+MIzE7Ia5dF7omUJd1prErRnNcCWfPzuAqzeY1brnjs4
         k4SpatjPUmZKUWmeH1XI0Ip2awP7TIdHmLHXaRywjb3PoeS4Zy9i/z7Y2g9Y22OaZXET
         QnglF3YUlKun8gwa9AEAV+yBErsgnH2/faEiST7PqHnhyy7l1m3G11uyy+YpYKdW3LyS
         l+G9/s+mO8U451o1NzmRlLJVFnxuveLFXuhrgPjxmehF9oREID4UmynBPBbtdIRGWH+4
         w2iw==
X-Gm-Message-State: AOJu0YwxOCK5eO5U/w3UnfbsC7EFZ/dyg13MWL3ysk9r7O1v5vWuo1L8
	PlTFTCp3ngfPukzt43qV2wAqa8z/PB8EUzsUiW6EyWX2dnDY6++XsljvFhP3TqrBPf8=
X-Gm-Gg: AfdE7ckA0BNkvoh6m+lhFgsCZtXBTR10OWL/fmFTryk0zVX5jyDGSiXM/pNzcob/1DU
	aJEDSLd+m/8QYIJODpvB7gsab08l0cpIl9jEC61K0UmkCRK2FGhSV0TNdadTYnEAaS1jlBCitS1
	x0Zks11b7TO8svryCfELdXfX7JmVTOFNfMTavMYl84in+Zh9iHx8UJRtF+maKSJKFK8FAyT3oNT
	bQ+ZxV8XTezdy1i/3W1zqNFSO90FUTArmvplyGoClB+BGj8MUebOhU0L/Esgk1ZWPXy5FWEH2UD
	j/IzlSJUZ53YbLafhit3RYizfmhWI7JK26xxx5kva4LOrPpeSuBl/PVZxfwF1/WklejgpL0DeOV
	EflNov9H2cxcB+eeEZMuLkDmP+EqybioPzlEOvsUuFYcrQpXlV3M56PS75rSjqLpU027lk9sDYU
	Yr7sWg8nL99wyZ3AZL95VJgslILbH1pNx4n+aohjPVvhb+dbert2szX56jDrIfZfD0wwnIM5vav
	MSzliPCQkDKGjuYvDZ5OaDOHO4mpgsF
X-Received: by 2002:a05:620a:81d:b0:92e:ee51:e9cf with SMTP id af79cd13be357-93083d41dbbmr113259585a.61.1783989476089;
        Mon, 13 Jul 2026 17:37:56 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:55 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 11/14] lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL unavailable
Date: Mon, 13 Jul 2026 18:18:09 -0700
Message-Id: <20260714011812.106753-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260714011812.106753-1-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When ELS/CT commands can't be sent due to ELS WQ full, queue the iocbq on
the phba->txq tail for retrying submission later in lpfc_drain_txq.

lpfc_drain_txq is flagged to be called by the worker thread when an ELS CQE
completes lpfc_sli4_sp_handle_els_wcqe through the HBA_SP_QUEUE_EVT flag.

lpfc_drain_txq is also updated to queue an iocbq back on to the head of
phba->txq when lpfc_drain_txq itself still observes ELS WQ full or SGL
unavailable events.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h      |   7 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  17 ++++-
 drivers/scsi/lpfc/lpfc_els.c       |  58 ++++++++++++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c |   9 ++-
 drivers/scsi/lpfc/lpfc_sli.c       | 104 +++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_sli.h       |   4 +-
 6 files changed, 176 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 2ca5f0229ca1..47a593fe5e69 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -536,8 +536,11 @@ int lpfc_bsg_timeout(struct bsg_job *);
 int lpfc_bsg_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			     struct lpfc_iocbq *);
 int lpfc_bsg_ct_unsol_abort(struct lpfc_hba *, struct hbq_dmabuf *);
-void __lpfc_sli_ringtx_put(struct lpfc_hba *, struct lpfc_sli_ring *,
-	struct lpfc_iocbq *);
+void lpfc_sli4_queue_io_for_retry(struct lpfc_hba *phba,
+				  struct lpfc_iocbq *iocb,
+				  bool head);
+void __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *ring,
+			   struct lpfc_iocbq *iocb, bool head);
 struct lpfc_iocbq *lpfc_sli_ringtx_get(struct lpfc_hba *,
 	struct lpfc_sli_ring *);
 int __lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index e14170550e69..16f9cd507834 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -639,11 +639,24 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 		goto out;
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, geniocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (rc) {
+		lpfc_vlog_msg(vport, KERN_NOTICE,
+			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+			      "0156 %ps WQE Put returned %d\n",
+			      cmpl, rc);
+
+		/* Under heavy vpi counts, the driver's host_index can catch up
+		 * to the hba_index causing a put error. Catch this case and
+		 * put the IO on phba->txq.
+		 */
+		if (rc == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			lpfc_sli4_queue_io_for_retry(phba, geniocb, false);
+			return 0;
+		}
+
 		lpfc_nlp_put(ndlp);
 		goto out;
 	}
-
 	return 0;
 out:
 	lpfc_sli_release_iocbq(phba, geniocb);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 11c36968a2be..73552ce4bc64 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2440,6 +2440,20 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (ret) {
+		lpfc_vlog_msg(vport, KERN_NOTICE,
+			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+			      "0157 PLOGI WQE Put returned %d\n",
+			      ret);
+
+		/* Under heavy vpi counts, the driver's host_index can catch up
+		 * to the hba_index causing a put error. Catch this case and
+		 * put the IO on phba->txq.
+		 */
+		if (ret == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
+			return 0;
+		}
+
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -2766,7 +2780,21 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (rc) {
+		lpfc_vlog_msg(vport, KERN_NOTICE,
+			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+			      "0155 PRLI WQE Put returned %d\n",
+			      rc);
+
+		/* Under heavy vpi counts, the driver's host_index can catch up
+		 * to the hba_index causing a put error. Catch this case and
+		 * put the IO on phba->txq.
+		 */
+		if (rc == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
+			return 0;
+		}
+
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -5982,7 +6010,21 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (rc) {
+		lpfc_vlog_msg(vport, KERN_NOTICE,
+			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+			      "0154 LS_ACC WQE Put returned %d\n",
+			      rc);
+
+		/* Under heavy vpi counts, the driver's host_index can catch up
+		 * to the hba_index causing a put error. Catch this case and
+		 * put the IO on phba->txq.
+		 */
+		if (rc == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
+			return 0;
+		}
+
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -10583,6 +10625,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	uint8_t rjt_exp, rjt_err = 0, init_link = 0;
 	struct lpfc_wcqe_complete *wcqe_cmpl = NULL;
 	LPFC_MBOXQ_t *mbox;
+	u16 rcv_oxid;
 
 	if (!vport || !elsiocb->cmd_dmabuf)
 		goto dropit;
@@ -10652,11 +10695,18 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	if ((cmd & ELS_CMD_MASK) == ELS_CMD_RSCN) {
 		cmd &= ELS_CMD_MASK;
 	}
+
+	/* Fetch the incoming ox_id for SLI4 only - SLI3 can't do this. */
+	rcv_oxid = 0xffff;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		rcv_oxid = get_job_rcvoxid(phba, elsiocb);
+
 	/* ELS command <elsCmd> received from NPORT <did> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0112 ELS command x%x received from NPORT x%x "
-			 "refcnt %d Data: x%x x%lx x%x x%x\n",
-			 cmd, did, kref_read(&ndlp->kref), vport->port_state,
+			 "refcnt %d rcvoxid x%x Data: x%x x%lx x%x x%x\n",
+			 cmd, did, kref_read(&ndlp->kref),
+			 rcv_oxid, vport->port_state,
 			 vport->fc_flag, vport->fc_myDID, vport->fc_prevDID);
 
 	/* reject till our FLOGI completes or PLOGI assigned DID via PT2PT */
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index e7ade735a97c..c0b2a678d492 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1993,6 +1993,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
 	MAILBOX_t *mb = &pmb->u.mb;
 	uint32_t did  = mb->un.varWords[1];
+	int rc;
 
 	if (mb->mbxStatus) {
 		/* RegLogin failed */
@@ -2071,7 +2072,13 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
-		if (lpfc_issue_els_prli(vport, ndlp, 0)) {
+		rc = lpfc_issue_els_prli(vport, ndlp, 0);
+		if (rc) {
+			lpfc_vlog_msg(vport, KERN_NOTICE,
+				      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+				      "3015 PRLI Issue returning %d to DID "
+				      "x%06x, Send LOGO\n",
+				      rc, ndlp->nlp_DID);
 			lpfc_issue_els_logo(vport, ndlp, 0);
 			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 424ad15416ef..8bbe269e8a3d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -243,6 +243,38 @@ lpfc_sli4_pcimem_bcopy(void *srcp, void *destp, uint32_t cnt)
 #define lpfc_sli4_pcimem_bcopy(a, b, c) lpfc_sli_pcimem_bcopy(a, b, c)
 #endif
 
+/**
+ * lpfc_sli4_queue_io_for_retry - Put an ELS/CT IO request on the txq.
+ * @phba: pointer to the hba instance.
+ * @iocb: the IO request to put on the txq.
+ * @head: A boolean to request a put to the head (true) or tail (false) of the
+ *        txq.
+ *
+ * This routine is for SLI4 interfaces only.
+ * When ELS/CT commands can't be sent because of ELS WQ full put status,
+ * queue the iocbq on the phba->txq, at the head or tail as requested by
+ * the caller, for a retry later in lpfc_drain_txq. The lpfc_drain_txq
+ * routine is called per ELS CQE completion.
+ */
+void lpfc_sli4_queue_io_for_retry(struct lpfc_hba *phba,
+				  struct lpfc_iocbq *iocb,
+				  bool head)
+{
+	unsigned long iflags;
+	struct lpfc_sli_ring *pring;
+
+	/* Mark the IO as in RETRY to stop a full reprep of the SGL/XRI. */
+	iocb->cmd_flag |= LPFC_IO_IN_RETRY;
+	pring = phba->sli4_hba.els_wq->pring;
+
+	/* Insert to the head or tail of the txq ring as indicated
+	 * by the caller's head argument.
+	 */
+	spin_lock_irqsave(&pring->ring_lock, iflags);
+	__lpfc_sli_ringtx_put(phba, pring, iocb, head);
+	spin_unlock_irqrestore(&pring->ring_lock, iflags);
+}
+
 /**
  * lpfc_sli4_wq_put - Put a Work Queue Entry on an Work Queue
  * @q: The Work Queue to operate on.
@@ -275,6 +307,10 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe128 *wqe)
 	/* If the host has not yet processed the next entry then we are done */
 	idx = ((q->host_index + 1) % q->entry_count);
 	if (idx == q->hba_index) {
+		lpfc_printf_log(q->phba, KERN_WARNING, LOG_SLI,
+				"9998 No available WQ Slots on "
+				"q_id x%x, host x%x, hba x%x\n",
+				q->queue_id, idx, q->hba_index);
 		q->WQ_overflow++;
 		return -EBUSY;
 	}
@@ -10419,6 +10455,7 @@ lpfc_mbox_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to address of newly added command iocb.
+ * @head: put at head (true) or tail (false)
  *
  * This function is called with hbalock held for SLI3 ports or
  * the ring lock held for SLI4 ports to add a command
@@ -10427,14 +10464,20 @@ lpfc_mbox_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
  **/
 void
 __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
-		    struct lpfc_iocbq *piocb)
+		      struct lpfc_iocbq *piocb, bool head)
 {
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		lockdep_assert_held(&pring->ring_lock);
 	else
 		lockdep_assert_held(&phba->hbalock);
-	/* Insert the caller's iocb in the txq tail for later processing. */
-	list_add_tail(&piocb->list, &pring->txq);
+
+	/* Insert the caller's iocb in the txq head or tail for later
+	 * processing.
+	 */
+	if (head)
+		list_add(&piocb->list, &pring->txq);
+	else
+		list_add_tail(&piocb->list, &pring->txq);
 }
 
 /**
@@ -10587,7 +10630,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
  out_busy:
 
 	if (!(flag & SLI_IOCB_RET_IOCB)) {
-		__lpfc_sli_ringtx_put(phba, pring, piocb);
+		__lpfc_sli_ringtx_put(phba, pring, piocb, false);
 		return IOCB_SUCCESS;
 	}
 
@@ -10725,6 +10768,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	struct lpfc_queue *wq;
 	struct lpfc_sli_ring *pring;
 	u32 ulp_command = get_job_cmnd(phba, piocb);
+	int rc = IOCB_SUCCESS;
 
 	/* Get the WQ */
 	if ((piocb->cmd_flag & LPFC_IO_FCP) ||
@@ -10740,9 +10784,11 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	/*
 	 * The WQE can be either 64 or 128 bytes,
 	 */
-
 	lockdep_assert_held(&pring->ring_lock);
 	wqe = &piocb->wqe;
+	if (piocb->cmd_flag & LPFC_IO_IN_RETRY)
+		goto retry_io;
+
 	if (piocb->sli4_xritag == NO_XRI) {
 		if (ulp_command == CMD_ABORT_XRI_CX)
 			sglq = NULL;
@@ -10752,7 +10798,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 				if (!(flag & SLI_IOCB_RET_IOCB)) {
 					__lpfc_sli_ringtx_put(phba,
 							pring,
-							piocb);
+							piocb, false);
 					return IOCB_SUCCESS;
 				} else {
 					return IOCB_BUSY;
@@ -10793,12 +10839,18 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 			return IOCB_ERROR;
 	}
 
-	if (lpfc_sli4_wq_put(wq, wqe))
-		return IOCB_ERROR;
+ retry_io:
+	piocb->cmd_flag &= ~LPFC_IO_IN_RETRY;
 
-	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
+	/* Push the wqe to the wq.  If the push fails with -EBUSY it means
+	 * the WQ is full.  Pass this status back to enable a retry.
+	 */
+	rc = lpfc_sli4_wq_put(wq, wqe);
+	if (rc == -EBUSY)
+		return IOCB_FAILED_PUT;
 
-	return 0;
+	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
+	return rc;
 }
 
 /*
@@ -21277,7 +21329,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 
 		ret = __lpfc_sli_issue_iocb(phba, pring->ringno, piocbq, 0);
 
-		if (ret && ret != IOCB_BUSY) {
+		if (ret && ret != IOCB_BUSY && ret != IOCB_FAILED_PUT) {
 			fail_msg = " - Cannot send IO ";
 			piocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 		}
@@ -21293,9 +21345,35 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 			list_add_tail(&piocbq->list, &completions);
 			fail_msg = NULL;
 		}
-		spin_unlock_irqrestore(&pring->ring_lock, iflags);
-		if (txq_cnt == 0 || ret == IOCB_BUSY)
+
+		if (txq_cnt == 0 || ret == IOCB_BUSY ||
+		    ret == IOCB_FAILED_PUT) {
+			/* If ELS WQ was full (IOCB_FAILED_PUT), then an SGL has
+			 * been assigned.  If SGL pool was empty (IOCB_BUSY),
+			 * then all we need is to put back on phba->txq to try
+			 * again later.
+			 */
+			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+					"2820 IOCB iotag x%x xri x%x ret %d "
+					"cmd_flg x%x txq_cnt x%x\n",
+					piocbq->iotag, piocbq->sli4_xritag, ret,
+					piocbq->cmd_flag, txq_cnt);
+			switch (ret) {
+			case IOCB_FAILED_PUT:
+				piocbq->cmd_flag |= LPFC_IO_IN_RETRY;
+				__lpfc_sli_ringtx_put(phba, pring, piocbq,
+						      true);
+				break;
+			case IOCB_BUSY:
+				__lpfc_sli_ringtx_put(phba, pring, piocbq,
+						      true);
+				break;
+			}
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
 			break;
+		}
+
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
 	/* Cancel all the IOCBs that cannot be issued */
 	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index cf7c42ec0306..86a7363a771a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -123,6 +123,7 @@ struct lpfc_iocbq {
 #define LPFC_IO_NVMET		0x800000 /* NVMET command */
 #define LPFC_IO_VMID            0x1000000 /* VMID tagged IO */
 #define LPFC_IO_CMF		0x4000000 /* CMF command */
+#define LPFC_IO_IN_RETRY	0x8000000 /* Caller is retrying IO. */
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
 	struct lpfc_vport *vport;/* virtual port pointer */
@@ -160,6 +161,7 @@ struct lpfc_iocbq {
 #define IOCB_ABORTED        4
 #define IOCB_ABORTING	    5
 #define IOCB_NORESOURCE	    6
+#define IOCB_FAILED_PUT     7
 
 #define SLI_WQE_RET_WQE    1    /* Return WQE if cmd ring full */
 
-- 
2.38.0

