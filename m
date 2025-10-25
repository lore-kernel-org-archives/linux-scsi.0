Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446A03081D4;
	Sat, 25 Oct 2025 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409580; cv=none; b=tS81dk4pFCv5SDa0+TN6P2UKqi900eGKVILh2400VVnZsY6WTzOQNYSYMAdG/ZVDHFxq/kV3rFfLgBg5DQDCn+3TmX/uP1tVm3N1DvsKAcDEE3OXJXi6YlZBlgBVhREQvxoh8TYpfYz9CjdovA3AYrFbjbnd/yfw0dJVPK40pXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409580; c=relaxed/simple;
	bh=JNQ39YWeAi4K7+X6qQwqEvnb4FQtk+/2HcK70qeEeds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaIoWAsZV5Cgyil+dvr+J0j4ZWy3hnV+0b1CJW3V4l8Al74fuNfQtnK4npYtN3l62rml/mdwkrVy2vcR/AV8XcfhxLfWORRZDyU4oeEDe3j+RrFHWobI8Scj+/IeMoHCu77PCgXiI3q5Nu9c3df1zKf/8JIBT7kyvptYAqLuPgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sWRs00aI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sWRs00aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509A8C4CEF5;
	Sat, 25 Oct 2025 16:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409580;
	bh=JNQ39YWeAi4K7+X6qQwqEvnb4FQtk+/2HcK70qeEeds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWRs00aIBHypzmsQ8o4s87O8mFzjmBo64Kud3ISOh5PoqM9T1QR1AJtO9xUWB34QA
	 zQZJ4yOurMk0q3S0EnKDfJJA79xrjOBhlx3aoFrB5YzJqGIVQzIoMPinel313JAmD4
	 hbj0k99SJS7g4Z7pFGFWfQpwKzXp52Lw0hrEoOuc7IYWsgUhmT/SpiKIk+i0AZpbxn
	 1A6TUj9WqAcRY42ism12BMzRvRl22woHgI6d5kMQ4p+Kq4i5tIxiYTF3BMYxZZLSIg
	 7PXt6vJ5Jh2myQxk9OV2ViHXjmJWDKydSQQ4SrjXV4gPyT0SPi6qD6iEjzhd5oS5Cm
	 S3APqObEtr83w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.ely@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] scsi: lpfc: Ensure PLOGI_ACC is sent prior to PRLI in Point to Point topology
Date: Sat, 25 Oct 2025 12:00:06 -0400
Message-ID: <20251025160905.3857885-375-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 2bf81856a403c92a4ce375288f33fba82ca2ccc6 ]

There is a timing race condition when a PRLI may be sent on the wire
before PLOGI_ACC in Point to Point topology.  Fix by deferring REG_RPI
mbox completion handling to after PLOGI_ACC's CQE completion.  Because
the discovery state machine only sends PRLI after REG_RPI mbox
completion, PRLI is now guaranteed to be sent after PLOGI_ACC.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-8-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `drivers/scsi/lpfc/lpfc_nportdisc.c:329-353` now keeps the original
  `REG_RPI` mailbox queued with the PLOGI ACC when `FC_PT2PT` is set, so
  the driver no longer tells the discovery state machine that login
  succeeded until the ACC CQE really arrives; this closes the race where
  the state machine could transmit PRLI while the remote port was still
  waiting for our PLOGI_ACC.
- The matching completion path in
  `drivers/scsi/lpfc/lpfc_els.c:5341-5409` runs
  `lpfc_mbx_cmpl_reg_login()` only after the ACC response finishes on a
  point-to-point link, guaranteeing the required on-wire ordering
  (PLOGI_ACC before PRLI) and keeping the `NLP_ACC_REGLOGIN` bookkeeping
  consistent.
- The change is tightly scoped to lpfc point-to-point discovery, adds no
  new features, and leaves fabric/NVMe paths untouched; failure paths
  still fall back to the existing cleanup, so regression risk is low.
- Without this fix, direct-attach systems can intermittently fail to
  establish sessions because the target sees PRLI before we have
  acknowledged its login, which is a user-visible bug.
- Backporters should be aware that older stable trees still use
  `login_mbox->context3` and bitmask-clear macros for `nlp_flag`; the
  logic ports cleanly but needs those mechanical adjustments.

 drivers/scsi/lpfc/lpfc_els.c       | 10 +++++++---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 23 ++++++++++++++++++-----
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3f703932b2f07..8762fb84f14f1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5339,12 +5339,12 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		ulp_status, ulp_word4, did);
 	/* ELS response tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0110 ELS response tag x%x completes "
+			 "0110 ELS response tag x%x completes fc_flag x%lx"
 			 "Data: x%x x%x x%x x%x x%lx x%x x%x x%x %p %p\n",
-			 iotag, ulp_status, ulp_word4, tmo,
+			 iotag, vport->fc_flag, ulp_status, ulp_word4, tmo,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi, kref_read(&ndlp->kref), mbox, ndlp);
-	if (mbox) {
+	if (mbox && !test_bit(FC_PT2PT, &vport->fc_flag)) {
 		if (ulp_status == 0 &&
 		    test_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag)) {
 			if (!lpfc_unreg_rpi(vport, ndlp) &&
@@ -5403,6 +5403,10 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 out_free_mbox:
 		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	} else if (mbox && test_bit(FC_PT2PT, &vport->fc_flag) &&
+		   test_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag)) {
+		lpfc_mbx_cmpl_reg_login(phba, mbox);
+		clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
 	}
 out:
 	if (ndlp && shost) {
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index a596b80d03d4d..3799bdf2f1b88 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -326,8 +326,14 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 		/* Now that REG_RPI completed successfully,
 		 * we can now proceed with sending the PLOGI ACC.
 		 */
-		rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
-				      save_iocb, ndlp, NULL);
+		if (test_bit(FC_PT2PT, &ndlp->vport->fc_flag)) {
+			rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
+					      save_iocb, ndlp, login_mbox);
+		} else {
+			rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
+					      save_iocb, ndlp, NULL);
+		}
+
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"4576 PLOGI ACC fails pt2pt discovery: "
@@ -335,9 +341,16 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 		}
 	}
 
-	/* Now process the REG_RPI cmpl */
-	lpfc_mbx_cmpl_reg_login(phba, login_mbox);
-	clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
+	/* If this is a fabric topology, complete the reg_rpi and prli now.
+	 * For Pt2Pt, the reg_rpi and PRLI are deferred until after the LS_ACC
+	 * completes.  This ensures, in Pt2Pt, that the PLOGI LS_ACC is sent
+	 * before the PRLI.
+	 */
+	if (!test_bit(FC_PT2PT, &ndlp->vport->fc_flag)) {
+		/* Now process the REG_RPI cmpl */
+		lpfc_mbx_cmpl_reg_login(phba, login_mbox);
+		clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
+	}
 	kfree(save_iocb);
 }
 
-- 
2.51.0

