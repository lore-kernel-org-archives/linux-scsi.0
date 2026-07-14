Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D943D1A9F8D
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989471; cv=none; b=RZxJ6rquLf1aCHrEQUXLL+y63pYNqzMgxULeNX2L+O71HrDvEg/UUm6KTCjmgtD1Ptsue8cNIm8z9wFLsjc9bqHYCzXKS9Dbqpzjpx7d4qn/hISvxXiCgCMLYmd8uEvuKenh/SGZ10ARmCJsZ6kYo7aPUkxSfjlseVzX7UUiEQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989471; c=relaxed/simple;
	bh=ah2gX6X+g3L3E+1u/OOWhAJIoZFTtjXQnIxsmIdijto=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NgvlX1jyc4/nyPjxGDxOlWq/PbVoPEePRfJp7ApxBKqk99outhzQM5XFUIfjHjkvE+UZGQYbzoO78eZL0Ky7jG7wAXgyHiqlngjco8tqfc/GlZnrI459wFRI3NOgYUrcoTVkjSk1W2yRBx9eyxK9+tAg55xB9uQ2mR+KusBBWf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G6D3y/Sp; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G6D3y/Sp"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-920f33347f5so244819485a.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989469; x=1784594269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xgEPdTysYZhVJboHEs1xEstuqWgmCOz3iGH+1BqB/CA=;
        b=G6D3y/SpRGCDa3xFt+4SKzEun89BIA9rK9LUvOzfTuvK/ukX5VrOWGiBvb5FED2gWb
         7HtzZiRcLqHN3EeGfyfm4JxSapdBMwOk7oaXJmkXnlBX5i2mB93IuxRDa7DW164wWYmo
         /wJtxP8nURbTd4HhgIc2gJ2DqGMMCpSVMbLl97ZlHtfGx9V69yn4DI/8Bm9ZOhpeL8Qc
         pg+wZS3zHgoHIKHM+DLUiPomlukd0k05R1AXvFzyh6JvhA4x1Ws/xo+CXqaLs9AiJVI2
         PWj822d5rOcr5/vn+ol+WvY/I1TjYP4RP9b+BF7V8ApASAnH88Os46bBYsJSpGhc/ZhP
         6a8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989469; x=1784594269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xgEPdTysYZhVJboHEs1xEstuqWgmCOz3iGH+1BqB/CA=;
        b=PYjF3tpYSs8IXU6+8PgplFUgsrxKuwniew4KXNXa3rbgCABtapjGeMhLab06ANsyvc
         JJapLIMLMYpgX683+iv2Oksk45QoOc+/DO2toP/HFlKqtF8Yvbfu6Wj7RAWXAk/+oVrb
         KRKBHimyPABIuGDYijjtIf/Jf3pSg7xIt6FsFZBneJ0y/uewdYWa0c0lazy5ZzrmMTEj
         3izVOf5dBlXxex7aAYh6ZakYlXaJcsNpe5eLnNw02aF/kpweRfdbKhTcxBIzcrFbRtbB
         kN4I5WBu5WMmDtGHRLd+rzOtLW5EUKIB8MhWQQFnY/gYO51kYXzChaa9JtJ933ZPbmGn
         uYRQ==
X-Gm-Message-State: AOJu0YygiKXicIchZE7n/UX9U+8q9O15d4bYmns6ApAqn4gJjeW5gzTM
	k+QTDAZ3tS9TgtWYui9V5nZQA/Sn7SEK6TTuP3XnoC5XLE4s5CAUW/3us1gSvD4ymJo=
X-Gm-Gg: AfdE7cm1NWUs8zvzWDDWWrgK8bpQ9nQaupR1eLhsKtIPSa2dHGcJ/vSDutcGc/bBgdG
	lcRrD9z6F12l7XX9ZpSxx9y/jhBBK8uE8zAiUwVjB5Bthgp9rR4Nfbr/MD0ztt9vNaVWiLO0IGX
	G+1GLvmpJQzyG5ttfObwRQSy2AfqqPu4dsjDEiL/+GMazpp4vYkJFBeqAY7v+wyKe7D7sihvRQm
	Vg4yAe810S3gIl231Wg5uHSHJXYWRNmMz0/IuTR+8qAKwhW/mYrzznq7hlAZcjhfCYqlkTB5pHj
	/4+QS4aZuSiqiDNc6fN8/xXi+nu617I0h2KFOWyP5sZcsZoTWUDkIDFbcjj/ZRI++D6pwDlxpih
	Sa8wHpu/iqlMCzVvQvmLyhh7nSMoUXaaaiufEPuEvc1coeQnabICJcgWj9SOqH1zjRhHS19sssr
	e3TBU+KKK2Lo4gH5DyC/lS4Au+tTirh1ODYjaqTjEHj8vazMVf/6qxOGeY1cN6qbqb1iptbH+Hy
	KoujfJoHtodgSUSdb+PAfnAKMLNhz1l
X-Received: by 2002:a05:620a:2718:b0:92e:e125:55bb with SMTP id af79cd13be357-92ef2b12a34mr1099537485a.4.1783989468795;
        Mon, 13 Jul 2026 17:37:48 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:48 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 06/14] lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery sequence
Date: Mon, 13 Jul 2026 18:18:04 -0700
Message-Id: <20260714011812.106753-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260714011812.106753-1-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In large SAN configurations when a target port fails over, RSCNs may be
spammed triggering a repeat of restarting discovery events for an ndlp
object.

In the case when discovery reaches PRLI state, but the PRLI operation is
interrupted, this leaves the nlp_fc4_type and nlp_type flags cleared.  And,
on the next cycle through lpfc_nlp_reg_node, the NLP_XPT_REGD flag is set
but registraton with the fc transport is bypassed because
lpfc_valid_xpt_node returns false.

This sets up a condition whereby the next call to lpfc_nlp_unreg_node
results in a premature release of the ndlp, and a callback from the
transport results in a use-after-free condition.

To address this issue, refactor lpfc_fc4_xpt_flags such that both SCSI and
NVME have separate flags indicating registration with their respective
transport.  The flags also indicate a request to unregister had been made.
In dev-loss or transport callback processing, the SCSI_XPT_UNREG_WAIT and
NVME_XPT_UNREG_WAIT flags indicate whether the ndlp reference has already
been released.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h    |  2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 97 ++++++++++++++++----------------
 2 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index a377e97cbe65..afc5e84bf0fa 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -83,7 +83,7 @@ struct lpfc_enc_info {
 };
 
 enum lpfc_fc4_xpt_flags {
-	NLP_XPT_REGD		= 0x1,
+	SCSI_XPT_UNREG_WAIT	= 0x1,
 	SCSI_XPT_REGD		= 0x2,
 	NVME_XPT_REGD		= 0x4,
 	NVME_XPT_UNREG_WAIT	= 0x8,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c9b02d2c6305..6337dae4f1cd 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -200,26 +200,18 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		/* The scsi_transport is done with the rport so lpfc cannot
 		 * call to unregister.
 		 */
-		if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
+		if ((ndlp->fc4_xpt_flags & SCSI_XPT_REGD) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_UNREG_WAIT)) {
+			/* Reference held since no unreg call made */
 			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
 
-			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
-			 * unregister calls were made to the scsi and nvme
-			 * transports and refcnt was already decremented. Clear
-			 * the NLP_XPT_REGD flag only if the NVME nrport is
-			 * confirmed unregistered.
-			 */
-			if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
-				if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
-					ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
-				spin_unlock_irqrestore(&ndlp->lock, iflags);
-
-				/* Release scsi transport reference */
-				lpfc_nlp_put(ndlp);
-			} else {
-				spin_unlock_irqrestore(&ndlp->lock, iflags);
-			}
+			/* Release scsi transport reference */
+			lpfc_nlp_put(ndlp);
 		} else {
+			/* Clear scsi xpt flags */
+			ndlp->fc4_xpt_flags &= ~(SCSI_XPT_REGD |
+						 SCSI_XPT_UNREG_WAIT);
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
 		}
 
@@ -270,7 +262,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	 * The backend does not expect any more calls associated with this
 	 * rport. Remove the association between rport and ndlp.
 	 */
-	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+	ndlp->fc4_xpt_flags &= ~(SCSI_XPT_REGD | SCSI_XPT_UNREG_WAIT);
 	((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
 	ndlp->rport = NULL;
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
@@ -606,7 +598,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 		return fcf_inuse;
 	}
 
-	if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 
 	return fcf_inuse;
@@ -4346,7 +4338,8 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		 */
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
 			clear_bit(NLP_NPR_2B_DISC, &ndlp->nlp_flag);
-			lpfc_nlp_put(ndlp);
+			if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+				lpfc_nlp_put(ndlp);
 		}
 
 		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
@@ -4527,6 +4520,7 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	}
 
 	spin_lock_irqsave(&ndlp->lock, flags);
+	ndlp->fc4_xpt_flags &= ~SCSI_XPT_UNREG_WAIT;
 	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD;
 	spin_unlock_irqrestore(&ndlp->lock, flags);
 
@@ -4562,6 +4556,7 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 {
 	struct fc_rport *rport = ndlp->rport;
 	struct lpfc_vport *vport = ndlp->vport;
+	unsigned long flags;
 
 	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
 		return;
@@ -4577,6 +4572,11 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 			 kref_read(&ndlp->kref));
 
 	fc_remote_port_delete(rport);
+
+	/* Flag unreg pending and reference released */
+	spin_lock_irqsave(&ndlp->lock, flags);
+	ndlp->fc4_xpt_flags |= SCSI_XPT_UNREG_WAIT;
+	spin_unlock_irqrestore(&ndlp->lock, flags);
 	lpfc_nlp_put(ndlp);
 }
 
@@ -4623,7 +4623,9 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	lpfc_check_nlp_post_devloss(vport, ndlp);
 
 	spin_lock_irqsave(&ndlp->lock, iflags);
-	if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
+	if ((ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+	    !(ndlp->fc4_xpt_flags & (SCSI_XPT_UNREG_WAIT |
+				     NVME_XPT_UNREG_WAIT))) {
 		/* Already registered with backend, trigger rescan */
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
 
@@ -4633,16 +4635,11 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		}
 		return;
 	}
-
-	ndlp->fc4_xpt_flags |= NLP_XPT_REGD;
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
 	if (lpfc_valid_xpt_node(ndlp)) {
 		vport->phba->nport_event_cnt++;
-		/*
-		 * Tell the fc transport about the port, if we haven't
-		 * already. If we have, and it's a scsi entity, be
-		 */
+		/* Tell the fc transport about the port */
 		lpfc_register_remote_port(vport, ndlp);
 	}
 
@@ -4650,24 +4647,24 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (!(ndlp->nlp_fc4_type & NLP_FC4_NVME))
 		return;
 
+	if (vport->phba->sli_rev < LPFC_SLI_REV4)
+		return;
+
 	/* Notify the NVME transport of this new rport. */
-	if (vport->phba->sli_rev >= LPFC_SLI_REV4 &&
-			ndlp->nlp_fc4_type & NLP_FC4_NVME) {
-		if (vport->phba->nvmet_support == 0) {
-			/* Register this rport with the transport.
-			 * Only NVME Target Rports are registered with
-			 * the transport.
-			 */
-			if (ndlp->nlp_type & NLP_NVME_TARGET) {
-				vport->phba->nport_event_cnt++;
-				lpfc_nvme_register_port(vport, ndlp);
-			}
-		} else {
-			/* Just take an NDLP ref count since the
-			 * target does not register rports.
-			 */
-			lpfc_nlp_get(ndlp);
+	if (vport->phba->nvmet_support == 0) {
+		/* Register this rport with the transport.
+		 * Only NVME Target Rports are registered with
+		 * the transport.
+		 */
+		if (ndlp->nlp_type & NLP_NVME_TARGET) {
+			vport->phba->nport_event_cnt++;
+			lpfc_nvme_register_port(vport, ndlp);
 		}
+	} else {
+		/* Just take an NDLP ref count since the
+		 * target does not register rports.
+		 */
+		lpfc_nlp_get(ndlp);
 	}
 }
 
@@ -4678,7 +4675,7 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	unsigned long iflags;
 
 	spin_lock_irqsave(&ndlp->lock, iflags);
-	if (!(ndlp->fc4_xpt_flags & NLP_XPT_REGD)) {
+	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
 		lpfc_printf_vlog(vport, KERN_INFO,
 				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
@@ -4688,12 +4685,11 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				  ndlp->nlp_flag, ndlp->fc4_xpt_flags);
 		return;
 	}
-
-	ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
 	if (ndlp->rport &&
-	    ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
+	    ((ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | SCSI_XPT_UNREG_WAIT)) ==
+	     SCSI_XPT_REGD)) {
 		vport->phba->nport_event_cnt++;
 		lpfc_unregister_remote_port(ndlp);
 	} else if (!ndlp->rport) {
@@ -4706,7 +4702,12 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				 kref_read(&ndlp->kref));
 	}
 
-	if (ndlp->fc4_xpt_flags & NVME_XPT_REGD) {
+	/* If no remote NVME node is indicated, just exit */
+	if (!(ndlp->nlp_fc4_type & NLP_FC4_NVME))
+		return;
+
+	if ((ndlp->fc4_xpt_flags & (NVME_XPT_REGD | NVME_XPT_UNREG_WAIT)) ==
+	    NVME_XPT_REGD) {
 		vport->phba->nport_event_cnt++;
 		if (vport->phba->nvmet_support == 0) {
 			lpfc_nvme_unregister_port(vport, ndlp);
-- 
2.38.0

