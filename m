Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C74306D5F
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467345; cv=none; b=gQcua/6cLY/nuPwA84ganGWziQTkhck7NrBimBcHcZtXHp+roGhhEO+k0mSVZgFcXZPWqtgqDcoU3WG6Qge5eHFrERNO9ngGmbuW2lt3Keo08uWw7EEnphPFTm4na7aGd0BAYtaIAphPq4Kg+z6BZUwg0AbP28g2kHYiVu14cw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467345; c=relaxed/simple;
	bh=zajGqLUA3vr+Vz0TRc0PY+zKAOHUEgkfPBIF87z7Q4o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gXmU+IyvcgdIa2j09IBhbO6HBbEfC4z4EkvgFac81F3YO8GbJS+qNynakFdo1NRk7ynq4t8bnnOolL7SsAdR39H35bA1LQlE/lkH12PM/48I6o9AFtxFoxYnbvOjZ5RSMuVvJWdXwf1L9J3iVphOllYoR7spxOmxGUm/688ZGfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mtbCSHjf; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mtbCSHjf"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7a9c64dfa8aso101901b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467343; x=1763072143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaV5T+CkHKumub+1IyVNraAlr4M5fw3/XvkVE6EY/28=;
        b=mtbCSHjfcLbqmF4diwf9CfIEZt4EHTGOvwupDco5cUbZ3QwYcM5C7YKFuPYxiFZPz5
         ioSStpoDM/1NNKcXKy/SXGabgcrTwdaIqU4hiyMH1UG6morJTmv40+zbbFRjG2KQM1Kd
         FhIMXwYlhaidazQPSfthypnA1y+vN6TPArlw48XcaN2MFIUJFIWJEE2IWm4vq1bAknea
         Jvr4kxt4jR0L+/7WKdlanQWE7p4bEP8aYYDsEAENeLLCA3JITkt/opLzJVbLVNbkODDs
         VOT1vHsFTvaCMrbuLXKbIcSg8yy71tcgT0KuTCjkTub7md9ET3el5cmu/Fe/1C+SAEyD
         fNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467343; x=1763072143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iaV5T+CkHKumub+1IyVNraAlr4M5fw3/XvkVE6EY/28=;
        b=nAuYt5iQDMkiBYVVP+6ZXP+zAebJtyzBL38EiMQo9Ouaoz04htOG6+eNesf+FJoOLH
         9AO7V+PVQI5XzvISGqtRU3kYGs/jMjwF2NXaEZUcTy0CgsI0mzJ+8hvhJWEaE+9c94tm
         E4BKRaxUFUiwdJRi5Woh+zbX5954veocrs8cgyP1srGLd4vm7qR8RqbUvCoPjFtI7uIb
         H6u5Fg7TzjzKmhTyUtBVC30exjdLQoBsQHLc8sOZchIy5kINpLJ60N7pARHdxWLMb8Av
         qUWCM7wPP3Wh4hbPa0xTfk5xzxLMStbI4XKcj5B4v3tIkYMAKu3v10QhRSyAnF9ue9cH
         SeIg==
X-Gm-Message-State: AOJu0YzkICN82IWn1DrEJ1kJMCJbfSv4uM9Y5gP4dN9hjNJu0Oxw9zKY
	N6eK/W0JFJ5dCzEbEbPZ25pCt1aMi3gjMGL7FXjql3/bayJkL7DrSM4kZxHTxXzT
X-Gm-Gg: ASbGncuZVlypBKqhcHrVK/1oAX18sZREcYDAOML8Y8K2izGBznAdpoV3zsMPi/aq7OT
	TsAYJvN8llVK+jZqBJYjR9ek0FeGAveD/pnoj9NIxokHaWMAqKKNRT1TAzMt3qG3xjW4mqszYCk
	Z3LEFfFExsjAzMw/KA7qScXsb4peDz3xdNbL61iCmMbXTq0j1L6X+7rj6TvWQrsXCm1mPGCjZLD
	lisEnCfSLp7Pg0dWsJTj031BlxH/NoKgTQnDcAUlpNRSkkyBXeLJa+uBrB+7gVPsgidrkhiEaxx
	36j7Ph86xEVd1lgX/GDwCsg7d3qtJxHoXoYI9kyXBwJKqqmp9FJW2H9N6u8+nKLYi3zWjx5sCl/
	JmFTs+uYrvKLFi537ADuRvNVyD806bGysS2dYd52HBDWwZ5rofv86LY2mBFPFMRwrOFO6sqK0lx
	KMhlARONKh+Qap2z6o9EsvfT/RY4hj0ponH61DUxzl32+HfJBtSe2wjJU1Ln5gDI2reoxZhQU=
X-Google-Smtp-Source: AGHT+IF2dBduhDMcTQ4BiQq/EJ5TZWxQc2hOsCcxp0dOt8jT1+qvngyFFAtDgKQUqx5CkfkHDCIxGA==
X-Received: by 2002:a05:6a21:3394:b0:32d:b925:4a8 with SMTP id adf61e73a8af0-35227f62fa9mr1644191637.3.1762467342891;
        Thu, 06 Nov 2025 14:15:42 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:42 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 02/10] lpfc: Revise discovery related function headers and comments
Date: Thu,  6 Nov 2025 14:46:31 -0800
Message-Id: <20251106224639.139176-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correcting discovery related function headers, return status information,
and comment descriptions.  There are no functional changes.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 ++++++++---------
 drivers/scsi/lpfc/lpfc_sli.c |  9 +++++----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f7c6758557c8..5456d2ab2d36 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3024,6 +3024,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			      ndlp->nlp_DID, ulp_status,
 			      ulp_word4);
 
+		/* Call NLP_EVT_DEVICE_RM if link is down or LOGO is aborted */
 		if (lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 			skip_recovery = 1;
 	}
@@ -3306,7 +3307,8 @@ lpfc_reg_fab_ctrl_node(struct lpfc_vport *vport, struct lpfc_nodelist *fc_ndlp)
  *
  * This routine is a generic completion callback function for Discovery ELS cmd.
  * Currently used by the ELS command issuing routines for the ELS State Change
- * Request (SCR), lpfc_issue_els_scr() and the ELS RDF, lpfc_issue_els_rdf().
+ * Request (SCR), lpfc_issue_els_scr(), Exchange Diagnostic Capabilities (EDC),
+ * lpfc_issue_els_edc()  and the ELS RDF, lpfc_issue_els_rdf().
  * These commands will be retried once only for ELS timeout errors.
  **/
 static void
@@ -3705,10 +3707,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 		lpfc_nlp_put(ndlp);
 		return 1;
 	}
-	/* This will cause the callback-function lpfc_cmpl_els_cmd to
-	 * trigger the release of the node.
-	 */
-	/* Don't release reference count as RDF is likely outstanding */
+
 	return 0;
 }
 
@@ -4299,7 +4298,7 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		/* The additional lpfc_nlp_put will cause the following
-		 * lpfc_els_free_iocb routine to trigger the rlease of
+		 * lpfc_els_free_iocb routine to trigger the release of
 		 * the node.
 		 */
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -5127,7 +5126,7 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 {
 	struct lpfc_dmabuf *buf_ptr, *buf_ptr1;
 
-	/* The I/O iocb is complete.  Clear the node and first dmbuf */
+	/* The I/O iocb is complete.  Clear the node and first dmabuf */
 	elsiocb->ndlp = NULL;
 
 	/* cmd_dmabuf = cmd,  cmd_dmabuf->next = rsp, bpl_dmabuf = bpl */
@@ -8734,7 +8733,7 @@ lpfc_els_rcv_rls(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
  *
- * This routine processes Read Timout Value (RTV) IOCB received as an
+ * This routine processes Read Timeout Value (RTV) IOCB received as an
  * ELS unsolicited event. It first checks the remote port state. If the
  * remote port is not in NLP_STE_UNMAPPED_NODE state or NLP_STE_MAPPED_NODE
  * state, it invokes the lpfc_els_rsl_reject() routine to send the reject
@@ -10843,7 +10842,7 @@ lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	lpfc_els_unsol_buffer(phba, pring, vport, elsiocb);
 	/*
 	 * The different unsolicited event handlers would tell us
-	 * if they are done with "mp" by setting cmd_dmabuf to NULL.
+	 * if they are done with "mp" by setting cmd_dmabuf/bpl_dmabuf to NULL.
 	 */
 	if (elsiocb->cmd_dmabuf) {
 		lpfc_in_buf_free(phba, elsiocb->cmd_dmabuf);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7ea7c4245c69..41eb558dd139 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -19858,13 +19858,15 @@ lpfc_sli4_remove_rpis(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_resume_rpi - Remove the rpi bitmask region
+ * lpfc_sli4_resume_rpi - Resume traffic relative to an RPI
  * @ndlp: pointer to lpfc nodelist data structure.
  * @cmpl: completion call-back.
  * @iocbq: data to load as mbox ctx_u information
  *
- * This routine is invoked to remove the memory region that
- * provided rpi via a bitmask.
+ * Return codes
+ *	0 - successful
+ *	-ENOMEM - No available memory
+ *	-EIO - The mailbox failed to complete successfully.
  **/
 int
 lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
@@ -19894,7 +19896,6 @@ lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
 		return -EIO;
 	}
 
-	/* Post all rpi memory regions to the port. */
 	lpfc_resume_rpi(mboxq, ndlp);
 	if (cmpl) {
 		mboxq->mbox_cmpl = cmpl;
-- 
2.38.0

