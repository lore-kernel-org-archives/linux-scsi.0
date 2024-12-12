Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25AE1AC891
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045293; cv=none; b=nPno6XCXdzqtMkSy0VEfZuC0dijQOdRMzk6eU/6sE914wPwD6PbIpO7Y/QN7/xIs74S0OBq/GLtHrDZTY7X63h2xCezU+QA/JzwKONWhOpl3iGbu2lSDW0iyzHsjnZa/PDM+dbmT7dwzT9A7Q9ALKu/Lb7olsUy6Ap36Ah6wqMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045293; c=relaxed/simple;
	bh=BF6nf5zW7KCJonZol6dE/ViDX1iL/lVzmh+4/bKftm8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KYLLmvIra/WcJm7ISCguV9YrDinjfbeeZhyTmTN/Q5tUcA9kOw7I06c/FjeVs1HdAXGfgdvnDMK+jEH/GIqqqRZfG9SIcO0wFCqWdWGNrbOHEk2uQOlzc3YkKTQNxhqTvIE9yf+1C9zlpHQkoIOau9RVIs1UBYOjCOdmEiC6MV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G2e2ByVi; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2e2ByVi"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21670dce0a7so13500495ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045291; x=1734650091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MietTjhNhKwekWfshXG/f57JMT3PZ5boeTAKTJM8wI0=;
        b=G2e2ByVivdc4/e+/eBaxkuot7K4L60yGrj3Lu+kl8kFKLcEMEo1Iv4KEu2RUMn2wUr
         x3jwEAMcJZTor2Z0cP6YNHLnUSBxB0eC79ffZfz3e+G4Y93ew9MejQk8dLpdsoByVogR
         uVQgTCQNLG7uIEaizV6THbmee2i7tv3P+bxPfVudNsYEhATQ89oKvZbWFgEKsmXPLJFZ
         sTjFg7EjudqWFeBFVkRE2lWAGGOIXO2aVSiYZr9WlsgHFga8jmS+D2j2OsVbEXe4AOwU
         SVCBQQUzhPRyhJ+4Shd0yA//1/k9HwR9cX3reJJiSH5vxmOTspBUwACTdtxhUh5wzHHn
         s5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045291; x=1734650091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MietTjhNhKwekWfshXG/f57JMT3PZ5boeTAKTJM8wI0=;
        b=W2fUGjPVifhzyHx4VWPClSwOxeLkwbD5pInmdhLY3g9JxGhS3fKd6ix8Gh0SRp/2ok
         akS3kXlX3BBoklNLxNTlcWVegEm1JimErdgrLw5b7bZbYWLn/P4AlFIq3WuR+S//qQdW
         y6MwH4/EEh/Q/rM/r/09tISb9Q/sS6AfP852Zv09AjZ99LEUiHlqjrgwyUWo3LHcqSU1
         QZa/0RFBGN2ZKn4qnzIMgx7tiEAxof1M7Mgb18kf4sIDYn7nhVK7Mam1A+bSSJl6eDyp
         cVDi5x4U/kl9CqnC4lXBeyea5/+h2GG/jyCzot1U3vSBZTu0WLJQELoGKBY8ZInZW5r5
         6pBQ==
X-Gm-Message-State: AOJu0YwEvFv3GMF64AAs2GL2GYEHdUtT+3Qq7BObYoN05VpfHgT1QJCK
	3OX4gGPQsMQmgsGuPxLqLRDUfKtD01qDSVx8W9d3in5l9DxcBuqxjuCjJA==
X-Gm-Gg: ASbGncvrU0IIkX8fuQIjiB/AndbLcm/KS6Lj8bPftVq/dYJaqKyNj5ffofMydiqFfsK
	8GiSm4HxxzPlyJ5YncRJQ7RYN4s/NK9g23FlnaBj5IZ9Plq5CuQGbMVYfseroSOlX10w0OubnYo
	N7L1mTLE8rtOGns95XmRVzsSx2MhWk71YzxpkIA2BWKO9F60kO7IapHbGEqWn65DDmJfWyTUL1X
	ERwbSxx0csJ3Y+lKe1YfT6OK/uqvJwoHWNyOlrP5ug+ZaVCBEX1Ki0XOPwiU9/kkPYygwnQzKeA
	JDGJm6dL3USaAI+3MK5A2uBrHm5X2TYA2f5JbFr0zQ==
X-Google-Smtp-Source: AGHT+IF16iebkckM2ZNk9hPisTSiN3Ev1JgnKhVqkl9kKrKYozVwlPvzakEgnbd1ZLKSB1L0AMGSUQ==
X-Received: by 2002:a17:902:cec5:b0:216:3083:d03d with SMTP id d9443c01a7336-21892a337f3mr7895455ad.44.1734045290825;
        Thu, 12 Dec 2024 15:14:50 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:50 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/10] lpfc: Change lpfc_nodelist save_flags member into a bitmask
Date: Thu, 12 Dec 2024 15:33:05 -0800
Message-Id: <20241212233309.71356-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In attempt to reduce the amount of unnecessary ndlp->lock acquisitions
in the lpfc driver, change save_flags into an unsigned long bitmask and
use clear_bit/test_bit bitwise atomic APIs instead of reliance on
ndlp->lock for synchronization.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c      |  6 ++----
 drivers/scsi/lpfc/lpfc_disc.h    | 10 +++++-----
 drivers/scsi/lpfc/lpfc_els.c     | 12 +++---------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 13 ++-----------
 drivers/scsi/lpfc/lpfc_init.c    |  4 ++--
 drivers/scsi/lpfc/lpfc_scsi.c    | 19 ++++++++-----------
 drivers/scsi/lpfc/lpfc_vport.c   | 22 +++++++++++-----------
 7 files changed, 33 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 30891ad17e2a..12c67cdd7c19 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1646,14 +1646,12 @@ lpfc_cmpl_ct(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* If the caller wanted a synchronous DA_ID completion, signal the
 	 * wait obj and clear flag to reset the vport.
 	 */
-	if (ndlp->save_flags & NLP_WAIT_FOR_DA_ID) {
+	if (test_bit(NLP_WAIT_FOR_DA_ID, &ndlp->save_flags)) {
 		if (ndlp->da_id_waitq)
 			wake_up(ndlp->da_id_waitq);
 	}
 
-	spin_lock_irq(&ndlp->lock);
-	ndlp->save_flags &= ~NLP_WAIT_FOR_DA_ID;
-	spin_unlock_irq(&ndlp->lock);
+	clear_bit(NLP_WAIT_FOR_DA_ID, &ndlp->save_flags);
 
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 81cfa35dab98..3d47dc7458d1 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -85,13 +85,13 @@ enum lpfc_fc4_xpt_flags {
 	NLP_XPT_HAS_HH		= 0x10
 };
 
-enum lpfc_nlp_save_flags {
+enum lpfc_nlp_save_flags { /* mask bits */
 	/* devloss occurred during recovery */
-	NLP_IN_RECOV_POST_DEV_LOSS	= 0x1,
+	NLP_IN_RECOV_POST_DEV_LOSS,
 	/* wait for outstanding LOGO to cmpl */
-	NLP_WAIT_FOR_LOGO		= 0x2,
+	NLP_WAIT_FOR_LOGO,
 	/* wait for outstanding DA_ID to finish */
-	NLP_WAIT_FOR_DA_ID              = 0x4
+	NLP_WAIT_FOR_DA_ID
 };
 
 struct lpfc_nodelist {
@@ -154,7 +154,7 @@ struct lpfc_nodelist {
 	uint32_t fc4_prli_sent;
 
 	/* flags to keep ndlp alive until special conditions are met */
-	enum lpfc_nlp_save_flags save_flags;
+	unsigned long save_flags;
 
 	enum lpfc_fc4_xpt_flags fc4_xpt_flags;
 
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 32e5e99ebbd4..1d7db49a8fe4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2988,12 +2988,8 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 
 	clear_bit(NLP_LOGO_SND, &ndlp->nlp_flag);
-	spin_lock_irq(&ndlp->lock);
-	if (ndlp->save_flags & NLP_WAIT_FOR_LOGO) {
+	if (test_and_clear_bit(NLP_WAIT_FOR_LOGO, &ndlp->save_flags))
 		wake_up_waiter = 1;
-		ndlp->save_flags &= ~NLP_WAIT_FOR_LOGO;
-	}
-	spin_unlock_irq(&ndlp->lock);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"LOGO cmpl:       status:x%x/x%x did:x%x",
@@ -11509,15 +11505,13 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_can_disctmo(vport);
 	}
 
-	if (ndlp->save_flags & NLP_WAIT_FOR_LOGO) {
+	if (test_bit(NLP_WAIT_FOR_LOGO, &ndlp->save_flags)) {
 		/* Wake up lpfc_vport_delete if waiting...*/
 		if (ndlp->logo_waitq)
 			wake_up(ndlp->logo_waitq);
 		clear_bit(NLP_ISSUE_LOGO, &ndlp->nlp_flag);
 		clear_bit(NLP_LOGO_SND, &ndlp->nlp_flag);
-		spin_lock_irq(&ndlp->lock);
-		ndlp->save_flags &= ~NLP_WAIT_FOR_LOGO;
-		spin_unlock_irq(&ndlp->lock);
+		clear_bit(NLP_WAIT_FOR_LOGO, &ndlp->save_flags);
 	}
 
 	/* Safe to release resources now. */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4036a9838bb5..36e66df36a18 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -414,12 +414,7 @@ void
 lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 			    struct lpfc_nodelist *ndlp)
 {
-	unsigned long iflags;
-
-	spin_lock_irqsave(&ndlp->lock, iflags);
-	if (ndlp->save_flags & NLP_IN_RECOV_POST_DEV_LOSS) {
-		ndlp->save_flags &= ~NLP_IN_RECOV_POST_DEV_LOSS;
-		spin_unlock_irqrestore(&ndlp->lock, iflags);
+	if (test_and_clear_bit(NLP_IN_RECOV_POST_DEV_LOSS, &ndlp->save_flags)) {
 		lpfc_nlp_get(ndlp);
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_NODE,
 				 "8438 Devloss timeout reversed on DID x%x "
@@ -427,9 +422,7 @@ lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 				 "port_state = x%x\n",
 				 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp,
 				 ndlp->nlp_flag, vport->port_state);
-		return;
 	}
-	spin_unlock_irqrestore(&ndlp->lock, iflags);
 }
 
 /**
@@ -546,9 +539,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 					 ndlp->nlp_DID, kref_read(&ndlp->kref),
 					 ndlp, ndlp->nlp_flag,
 					 vport->port_state);
-			spin_lock_irqsave(&ndlp->lock, iflags);
-			ndlp->save_flags |= NLP_IN_RECOV_POST_DEV_LOSS;
-			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			set_bit(NLP_IN_RECOV_POST_DEV_LOSS, &ndlp->save_flags);
 			return fcf_inuse;
 		} else if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 			/* Fabric node fully recovered before this dev_loss_tmo
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7f57397d91a9..44ddecb3909d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3847,8 +3847,8 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 					 * Otherwise, let dev_loss take care of
 					 * the node.
 					 */
-					if (!(ndlp->save_flags &
-					      NLP_IN_RECOV_POST_DEV_LOSS) &&
+					if (!test_bit(NLP_IN_RECOV_POST_DEV_LOSS,
+						      &ndlp->save_flags) &&
 					    !(ndlp->fc4_xpt_flags &
 					      (NVME_XPT_REGD | SCSI_XPT_REGD)))
 						lpfc_disc_state_machine
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c57f11f6fc84..5ba3d4f32e1d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6120,31 +6120,28 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 
 		/* Issue LOGO, if no LOGO is outstanding */
 		spin_lock_irqsave(&pnode->lock, flags);
-		if (!(pnode->save_flags & NLP_WAIT_FOR_LOGO) &&
+		if (!test_bit(NLP_WAIT_FOR_LOGO, &pnode->save_flags) &&
 		    !pnode->logo_waitq) {
 			pnode->logo_waitq = &waitq;
 			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
-			set_bit(NLP_ISSUE_LOGO, &pnode->nlp_flag);
-			pnode->save_flags |= NLP_WAIT_FOR_LOGO;
 			spin_unlock_irqrestore(&pnode->lock, flags);
+			set_bit(NLP_ISSUE_LOGO, &pnode->nlp_flag);
+			set_bit(NLP_WAIT_FOR_LOGO, &pnode->save_flags);
 			lpfc_unreg_rpi(vport, pnode);
 			wait_event_timeout(waitq,
-					   (!(pnode->save_flags &
-					      NLP_WAIT_FOR_LOGO)),
+					   !test_bit(NLP_WAIT_FOR_LOGO,
+						     &pnode->save_flags),
 					   msecs_to_jiffies(dev_loss_tmo *
 							    1000));
 
-			if (pnode->save_flags & NLP_WAIT_FOR_LOGO) {
+			if (test_and_clear_bit(NLP_WAIT_FOR_LOGO,
+					       &pnode->save_flags))
 				lpfc_printf_vlog(vport, KERN_ERR, logit,
 						 "0725 SCSI layer TGTRST "
 						 "failed & LOGO TMO (%d, %llu) "
 						 "return x%x\n",
 						 tgt_id, lun_id, status);
-				spin_lock_irqsave(&pnode->lock, flags);
-				pnode->save_flags &= ~NLP_WAIT_FOR_LOGO;
-			} else {
-				spin_lock_irqsave(&pnode->lock, flags);
-			}
+			spin_lock_irqsave(&pnode->lock, flags);
 			pnode->logo_waitq = NULL;
 			spin_unlock_irqrestore(&pnode->lock, flags);
 			status = SUCCESS;
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 9e0e35763377..3d70cc517573 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -492,21 +492,22 @@ lpfc_send_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
 	spin_lock_irq(&ndlp->lock);
-	if (!(ndlp->save_flags & NLP_WAIT_FOR_LOGO) &&
+	if (!test_bit(NLP_WAIT_FOR_LOGO, &ndlp->save_flags) &&
 	    !ndlp->logo_waitq) {
 		ndlp->logo_waitq = &waitq;
 		ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 		set_bit(NLP_ISSUE_LOGO, &ndlp->nlp_flag);
-		ndlp->save_flags |= NLP_WAIT_FOR_LOGO;
+		set_bit(NLP_WAIT_FOR_LOGO, &ndlp->save_flags);
 	}
 	spin_unlock_irq(&ndlp->lock);
 	rc = lpfc_issue_els_npiv_logo(vport, ndlp);
 	if (!rc) {
 		wait_event_timeout(waitq,
-				   (!(ndlp->save_flags & NLP_WAIT_FOR_LOGO)),
+				   !test_bit(NLP_WAIT_FOR_LOGO,
+					     &ndlp->save_flags),
 				   msecs_to_jiffies(phba->fc_ratov * 2000));
 
-		if (!(ndlp->save_flags & NLP_WAIT_FOR_LOGO))
+		if (!test_bit(NLP_WAIT_FOR_LOGO, &ndlp->save_flags))
 			goto logo_cmpl;
 		/* LOGO wait failed.  Correct status. */
 		rc = -EINTR;
@@ -516,9 +517,7 @@ lpfc_send_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	/* Error - clean up node flags. */
 	clear_bit(NLP_ISSUE_LOGO, &ndlp->nlp_flag);
-	spin_lock_irq(&ndlp->lock);
-	ndlp->save_flags &= ~NLP_WAIT_FOR_LOGO;
-	spin_unlock_irq(&ndlp->lock);
+	clear_bit(NLP_WAIT_FOR_LOGO, &ndlp->save_flags);
 
  logo_cmpl:
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_VPORT,
@@ -696,19 +695,20 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 
 			spin_lock_irq(&ndlp->lock);
 			ndlp->da_id_waitq = &waitq;
-			ndlp->save_flags |= NLP_WAIT_FOR_DA_ID;
 			spin_unlock_irq(&ndlp->lock);
+			set_bit(NLP_WAIT_FOR_DA_ID, &ndlp->save_flags);
 
 			rc = lpfc_ns_cmd(vport, SLI_CTNS_DA_ID, 0, 0);
 			if (!rc) {
 				wait_event_timeout(waitq,
-				   !(ndlp->save_flags & NLP_WAIT_FOR_DA_ID),
+				   !test_bit(NLP_WAIT_FOR_DA_ID,
+					     &ndlp->save_flags),
 				   msecs_to_jiffies(phba->fc_ratov * 2000));
 			}
 
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_VPORT | LOG_ELS,
 					 "1829 DA_ID issue status %d. "
-					 "SFlag x%x NState x%x, NFlag x%lx "
+					 "SFlag x%lx NState x%x, NFlag x%lx "
 					 "Rpi x%x\n",
 					 rc, ndlp->save_flags, ndlp->nlp_state,
 					 ndlp->nlp_flag, ndlp->nlp_rpi);
@@ -718,8 +718,8 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 			 */
 			spin_lock_irq(&ndlp->lock);
 			ndlp->da_id_waitq = NULL;
-			ndlp->save_flags &= ~NLP_WAIT_FOR_DA_ID;
 			spin_unlock_irq(&ndlp->lock);
+			clear_bit(NLP_WAIT_FOR_DA_ID, &ndlp->save_flags);
 		}
 
 issue_logo:
-- 
2.38.0

