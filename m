Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2CD2084E4;
	Wed, 25 Sep 2024 12:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266077; cv=none; b=MArekCgHnC9SHsESdWq/yWL5wR61QBYOm3oMOEuO72EkX2gMGqUyWypqc3hFTmZT6wZTcJ5rSAut03tmzV6Js+qHUXkKMYIRaZpfxt7ZCcUo/r5y83gmAZFF4hDDddAaxfyLUlD6RriPABNGcQtEFoctqxypTR/w1ML1m//kjgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266077; c=relaxed/simple;
	bh=YZdxG0WcsnreBdC8s9HOENw1zLsxN7HujNZ03t5E/ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKYV1BmxwAUucu/AcUu+QIRms8vpO9uqR+LI2tvtxtw3ZvtFmP7lcYGLIq8MCZ6RQoEDbQpovPg+3AHCZW/VGBdeilZSW4aXE3M9V/Gw1Iv3G41ZePQ0KGhhF6wqYfWfpt/wnPLfNmXAqpBDaaL0/x7hTqcDXctGEvJe1EYMBW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXzSWBXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXzSWBXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA83C4CECE;
	Wed, 25 Sep 2024 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727266077;
	bh=YZdxG0WcsnreBdC8s9HOENw1zLsxN7HujNZ03t5E/ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXzSWBXzVO87lokMubzP1vC/adVrka+qNhd+ekAIma5yLYiQDerWPHEY5CJFolGtJ
	 x4gSwZZdiYZF75+66FB8qpz5u50MR0SKh6kpRQRF098ElevZSGVm17pvZAlIdJQ5oL
	 VzLEFoJu0Gd/UCFXLiEJopj60BCuTKHJwImiOKaoha7MmuzB9S81rfbb+t9p+jz4NR
	 Yz32LH0/k+yppci31M5VtaD/IkLhVRJezFle73iAIBTPjJkAxC0GzvNmfXKFD9Po4N
	 NLrstvDXIuM2ZqrsZvcKAIL34Q7GhToXojW6unAJi+6ULTQCRqviWd5C4UvRNd/X1Y
	 rLF3/fhu+UZbQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 164/197] scsi: lpfc: Update PRLO handling in direct attached topology
Date: Wed, 25 Sep 2024 07:53:03 -0400
Message-ID: <20240925115823.1303019-164-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925115823.1303019-1-sashal@kernel.org>
References: <20240925115823.1303019-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.11
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 1f0f7679ad8942f810b0f19ee9cf098c3502d66a ]

A kref imbalance occurs when handling an unsolicited PRLO in direct
attached topology.

Rework PRLO rcv handling when in MAPPED state.  Save the state that we were
handling a PRLO by setting nlp_last_elscmd to ELS_CMD_PRLO.  Then in the
lpfc_cmpl_els_logo_acc() completion routine, manually restart discovery.
By issuing the PLOGI, which nlp_gets, before nlp_put at the end of the
lpfc_cmpl_els_logo_acc() routine, we are saving us from a final nlp_put.
And, we are still allowing the unreg_rpi to happen.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240726231512.92867-7-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c       | 27 ++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_nportdisc.c | 22 ++++++++++++++++++++--
 2 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9084976aa77e1..9c8a6d2a29049 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5244,9 +5244,10 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -5258,18 +5259,22 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
index f6a53446e57f9..4574716c8764f 100644
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
2.43.0

