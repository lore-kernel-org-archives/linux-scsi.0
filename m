Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FD03749E8
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682261; cv=none; b=KmW6HCMz/pii+reuFYYvV4QGhgla5Fv+GXiwZeme4zDxUZP0c5W+T6X2HLujcKuuvxQK4vxh6tzD7bBA7nW3ULvhPs83PnrdfGQO6D7GDYyYWrKxdN5CrYEugded0ouGvO3ynz8/P/sA3yhi4+XgjVySMrr9SFoHRFtpmrV+P+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682261; c=relaxed/simple;
	bh=er+i+bcUgXpA4B5pLjnulSJU8FZ2N5ENrMVZLO5GAwk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iVG3CU6RGZO3qXdd9CM2s5N7KNlPAoGwN3dGI6MMhHFfWwNCnBaWwl22VKDpve1QF6vmS4ljuTC65sF/w/ZCmThAdtxxWhB+oPRCI81fcTAQQTV4Xfug/7yIpcrz5Llc84XhN06yd/ADr8DCBDG47SIN1hPC8mBHZvbS2Cl6TEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RM26NV5K; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RM26NV5K"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747f0b25dso1085905ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682257; x=1790287057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mn52uYZrf0+gQFWYQ5xAjqLszn260wVjZkNXeoQi56U=;
        b=RM26NV5K7ltq5oMVIAu8tDUpBsMH84D+rMx2tHMn261hECnCd8re4IpPA4Q0QfPMIL
         ZGebAfms2sjd802Fg6kxlOiMPXBWkOYeJCE6tCkzxI3ZGbrBnhitKHrfwuv3V0QIaulX
         njroe5SGBpcKxNLsKFI7Mr7hfNo+n6JN5JneLJgSy3LkpgC43Fg+YK3BYEaYOb3lh15F
         SUlu3VkpHO1d47xsTPdX1ipR/2ectOt6PtJisOtTOSm3z77r11Ssuc2SYfXO6IAiWkaD
         jZdibzBhbR4yKXrEyBKCteDNUJIn3LTVq1jm4bme6+oRLWI0UM4kXegwgXhqE+7aPsGy
         altg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682257; x=1790287057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mn52uYZrf0+gQFWYQ5xAjqLszn260wVjZkNXeoQi56U=;
        b=rghRU+8eCgaTaIz2Gt39i3GkRoiZIiLtsoFRlTBtsi//r+nbBURmeAfY8/wG/vxskw
         TK5qFy6iJ9bzSxai6UDJT9upCw7qNacYDXxuI+Mw39m3VNjWAUPejlPL2ibAOg7lYh+M
         17QfCeEVszcrLgC4zqAVsppsfrkmkTrts5bWCqYrK33l6z0hsux//dfY64BNP1Z+lmDh
         oDsqK7VN44APw8YorWReALxZqSTZGUb1Tk++xFVrEBENLRyJNPUgeDAFJcrtbNCrdNPe
         sz6UR+IOjV0YmZZNlTL+Dk8dsJZKDtKMdG6MJJ5vveKuFvXQEEbjVYDqzAbmzsLbuvo4
         6RDA==
X-Gm-Message-State: AFuF++nrJVDN5auRxHCYFiyZdRiLG2Khe01r0wyQxTeilxCYfYjZlLVQ
	weq3tARUsyMdatyiP0lXAvTUZC4mm+WLhI6J5IRrz3S25Fpzt4BFkGrTmuxCtbVv
X-Gm-Gg: AYBFou33fyJRdZ7zWGv2ekpbqiJFKJSeXH3hUg5KxVcuqIOWlrGZciYdxmGStZz2UF9
	Espx/jah8t1ucAr9nCln10AX9WQfMNR+RxcHh5WvYVBUxHSpg/nEacHVxhL+DLPZLEL2axa6iT0
	J4/oSBIGAPlQQfgHMQw2Fgth7ROm1bt2lkXr8EqHaqt3wGgHKm4fTRMDz6FhmCVcB0IgaxVP24I
	YNnUI+a87O0EVSfLe4IUYnlOiM59qB2PPW3puzIKimY0YLKpdDiwnQtBxYxLdcZCiP3Qv9MJbD3
	QLwsUtZdAdlP8iidXZq9bwmMKmTTXlJrid9sOu58RqCFDQKSTIAUDyBvUXpiUpptMH8Vc6VO9Y6
	CuaxbPidu89QwCCfVbwj/4uVHjlm81/ylHv6AtxLR8n/pehiwFqRUFdFOYIHZvytyogxK40fAwE
	qU7v0kI7tahk7+7HF3NAPV/m160a3eXxrzNaBfsU6+Ov5Kj4AleZ1wpRsaX4lFCyFCupewUdEdL
	MvfOIkYw74ai74OPHe6Kl8So2knhRQSO3VFnG3wo8q7V8pQx8ALa8fhHkXVaIpZaA8HuA==
X-Received: by 2002:a17:902:da89:b0:2ca:d91d:d3a7 with SMTP id d9443c01a7336-2ddb1adf98cmr11151215ad.10.1789682257441;
        Thu, 17 Sep 2026 14:57:37 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:36 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 06/14] lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery sequence
Date: Thu, 17 Sep 2026 15:20:07 -0700
Message-Id: <20260917222015.61053-7-nkirkland2304@gmail.com>
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

Introduce explicit, symmetric reference-count tracking for NVMET target
nodes via the new NVMET_XPT_TGT flag and close a race in
lpfc_unregister_remote_port() by marking UNREG_WAIT before triggering
fc_remote_port_delete() rather than after.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h    |   5 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 127 ++++++++++++++++++-------------
 2 files changed, 75 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index a377e97cbe65..0ca0a785514c 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -83,11 +83,12 @@ struct lpfc_enc_info {
 };
 
 enum lpfc_fc4_xpt_flags {
-	NLP_XPT_REGD		= 0x1,
+	SCSI_XPT_UNREG_WAIT	= 0x1,
 	SCSI_XPT_REGD		= 0x2,
 	NVME_XPT_REGD		= 0x4,
 	NVME_XPT_UNREG_WAIT	= 0x8,
-	NLP_XPT_HAS_HH		= 0x10
+	NLP_XPT_HAS_HH		= 0x10,
+	NVMET_XPT_TGT		= 0x20
 };
 
 enum lpfc_nlp_save_flags { /* mask bits */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4c673dffa671..b4a5c7d5c2a0 100644
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
@@ -4576,7 +4571,21 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 			 ndlp->nlp_DID, rport, ndlp->fc4_xpt_flags,
 			 kref_read(&ndlp->kref));
 
+	/* There are certain cases where the following call could result in an
+	 * almost immediate dev-loss callback. Set unreg pending flag before
+	 * making the call.
+	 */
+	spin_lock_irqsave(&ndlp->lock, flags);
+	if (ndlp->fc4_xpt_flags & SCSI_XPT_UNREG_WAIT) {
+		spin_unlock_irqrestore(&ndlp->lock, flags);
+		return;
+	}
+	ndlp->fc4_xpt_flags |= SCSI_XPT_UNREG_WAIT;
+	spin_unlock_irqrestore(&ndlp->lock, flags);
+
 	fc_remote_port_delete(rport);
+
+	/* Release reference */
 	lpfc_nlp_put(ndlp);
 }
 
@@ -4623,7 +4632,10 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	lpfc_check_nlp_post_devloss(vport, ndlp);
 
 	spin_lock_irqsave(&ndlp->lock, iflags);
-	if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
+	if (((ndlp->fc4_xpt_flags & SCSI_XPT_REGD) &&
+	     !(ndlp->fc4_xpt_flags & SCSI_XPT_UNREG_WAIT)) ||
+	    ((ndlp->fc4_xpt_flags & NVME_XPT_REGD) &&
+	     !(ndlp->fc4_xpt_flags & NVME_XPT_UNREG_WAIT))) {
 		/* Already registered with backend, trigger rescan */
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
 
@@ -4633,16 +4645,11 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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
 
@@ -4650,24 +4657,32 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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
+		}
+	} else {
+		/* Just take an NDLP ref count since the
+		 * target does not register rports.
+		 */
+		spin_lock_irqsave(&ndlp->lock, iflags);
+		if (ndlp->fc4_xpt_flags & NVMET_XPT_TGT) {
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			return;
 		}
+		ndlp->fc4_xpt_flags |= NVMET_XPT_TGT;
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+
+		lpfc_nlp_get(ndlp);
 	}
 }
 
@@ -4678,7 +4693,15 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	unsigned long iflags;
 
 	spin_lock_irqsave(&ndlp->lock, iflags);
-	if (!(ndlp->fc4_xpt_flags & NLP_XPT_REGD)) {
+	if (vport->phba->nvmet_support != 0) {
+		if (ndlp->fc4_xpt_flags & NVMET_XPT_TGT) {
+			ndlp->fc4_xpt_flags &= ~NVMET_XPT_TGT;
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			lpfc_nlp_put(ndlp);
+			return;
+		}
+	}
+	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
 		lpfc_printf_vlog(vport, KERN_INFO,
 				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
@@ -4688,12 +4711,11 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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
@@ -4706,16 +4728,11 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				 kref_read(&ndlp->kref));
 	}
 
-	if (ndlp->fc4_xpt_flags & NVME_XPT_REGD) {
+	if ((ndlp->fc4_xpt_flags & (NVME_XPT_REGD | NVME_XPT_UNREG_WAIT)) ==
+	    NVME_XPT_REGD) {
 		vport->phba->nport_event_cnt++;
-		if (vport->phba->nvmet_support == 0) {
-			lpfc_nvme_unregister_port(vport, ndlp);
-		} else {
-			/* NVMET has no upcall. */
-			lpfc_nlp_put(ndlp);
-		}
+		lpfc_nvme_unregister_port(vport, ndlp);
 	}
-
 }
 
 /*
-- 
2.38.0

