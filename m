Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620A322173D
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681509; cv=none; b=jn8PQw17WB2nUWbHArKtIY7ZNOofY5xbNWu85EzO1nUt+maYiNzIsy3fSnFEgAuKpCnRIPb0Pcrfm9yMKe2sM1RxhUaiLDhtAqU9w9GfWQ3j/DIYUtqBs9D2F4SWIRquRjRYh62/pnErKyD8lTiwxll/mDOPK0JXVEWryDDtTkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681509; c=relaxed/simple;
	bh=uoCZN77bmG9bHlwdCN7vV3waeqoq7I1W8yMbd9r7rBY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rWyNPeG3H5p0tVJO7qVQXoN1ddtkCHtKa1CIOtNFW7WOxxeY2u9Un6miGvz8tfL+O+uv29tfALkyLs+zvc5fADiPD3X+yPkUA/qWIRgvbyGhAMWVmmiPSlI4Lv2xd7CbAgA0IN35L21iXC/uVOp9ZLargFN6SsTIDQ1HgmO61SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+3vmC7i; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+3vmC7i"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5176465a4a4so29530681cf.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681503; x=1781286303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAK1PejVMJR2yKwVdMLx0VAgStQ60AVahgVuO0wrW8Q=;
        b=Y+3vmC7iEXmTfzqx7IuNGQu0cEVWC87p994Ru8tXsICZQRSCu1lH2lqneNnI73J4WP
         54/kho0Uxt9uUdz+loDPu9PKVXbpvPxeT+b2n7QwPNhn41XpDjBT/qsVfUXqfzTvurSt
         0pQSts411dzgtSPhk+fcalxEa5T/jD5F/mFuEmwDliYYo8TRTF4Vug510JzpdijSZSOO
         4Cj/WUTy4KyRWwAgJnLM9Y+3KMSWN0tLwxGPx6iMUnI3VjFRK6B0pK8DHiG2HYjYcvlo
         AM2Wz/2YhduhzVLfIjt4+v4buZB6NaZplEDkiKGOONMCw+IvXhgfn6ilSgVaUMv7qUa1
         3Mfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681503; x=1781286303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XAK1PejVMJR2yKwVdMLx0VAgStQ60AVahgVuO0wrW8Q=;
        b=fALqh4Gqnr9k17YoLfChILATzouSfRrN9vPwr4E//bPLj5kFBVF2JQmKRPGkj6OyjE
         01nSBwPZCa62F8amf3mRFvJwwPtihR0l6ETRnYJgREHURcHa3xp5ZlA2Q8CpMX3HErOO
         dQssd2wxy4C7rw5pM0Z70eIQJyqFXVgsurh6j74wcKdH5NoeUUo8SwSquTDwgJeD+BEY
         3TJ1VOYBNgcsMJaqOy2PweZYT8JQcZ81dLSqK1nDF5fw3vO+WM3+pK2tINm68HqLV4iT
         8e8wOKQghftmOFR3qm4Vgd2a1/KXpF+wUKFneGuAwFv5Ba135wTJRxA7lLdY5/JCMry5
         WpBw==
X-Gm-Message-State: AOJu0YzzSMhDHrjSdE4e7T6KCtrr2ER3gRkSmAFVfufdi8ywCKb1fgx1
	BqiWicg0sY1qKVmtvLluLw6rkhNxEFLR9S8Hc4gvjht2y93oxh3Lz233YD9QKB5N
X-Gm-Gg: Acq92OGOjTJUlPuHtJpR+AC98Wlyyb5nllQhxOlx+U6yB/rPfuOQdth/x8E18Lm94G8
	7vUUGrFVFhvP8NxZ7IDFVgao+ZZRHNoNsJVhdEoVLrw/+JiDJvl5c7v0xFRZSVkSbJmCsDIwNST
	3ibRCdGQDzaEwyKMwhcYf1q3w5hcBrwvuzP1ydn/v2QQFPbBJk74SXW4edvUXa1OFSqMoQcGb60
	w17T3uwUs7Z4kcqhFFKXZiAxBZkAMat/Z6f+HiAYCiZarWCABnnnk3Oi3mVoofzNPdRUVcM6Hff
	1qr+TJNzKGKh6meg1ON5kBy8OyaERO/oveH1LE9uIb/7YlWsQLZ15Kc5Wy/XH3XTyW09MOikPBV
	zPsXpdchIZaW1ff4EKiFpYmWwcVWeB39YnG0fhGG6Iuk0Qqug264IDhjuralcjHadL5n83AXG4N
	3cBUVAGY0IhKZVSBkp1TGMmqmSFqNy3bru91KXGkGaNsal42dyJKQ34B0VN4+U651yRZp0rWK5X
	hOpGz30MaDDWlU2eR7kr23kFVFkBINjdKuz3wmB+QYEXLlcSqo6ckgrO/bFyxkB
X-Received: by 2002:a05:622a:2613:b0:517:79f0:ae4d with SMTP id d75a77b69052e-517a12d2d6amr21682181cf.19.1780681503006;
        Fri, 05 Jun 2026 10:45:03 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.45.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:45:02 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 06/14] lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery sequence
Date: Fri,  5 Jun 2026 11:23:28 -0700
Message-Id: <20260605182336.134919-7-justintee8345@gmail.com>
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
index f3a85f6c796e..e65214e5044d 100644
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

