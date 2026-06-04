Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D413347C7
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599058; cv=none; b=teCv9TH4jFU12VDHB+ONzvLAT0J4wJbCAzxFcjmYcZ8y2jIXSWa1avNEgKZ/5h1JBHxFi0UQSIlSkVfExlvMsDN8uy5RLnS2mp+6axGqF3DvA2n9EEu0cWPJtTljNNIpnYLNi6baVeV1ofd7U0u6mnvksgy/tOQHfZra23+fYEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599058; c=relaxed/simple;
	bh=uoCZN77bmG9bHlwdCN7vV3waeqoq7I1W8yMbd9r7rBY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bt2aiHeF0SgjKvWP8WhNMHw8MSD9t286rvUdglX5mOd8q8wgV+JMDrZFRCqncrR7JaCCQ76PNQulrcpdaNiT5UcnHRWSiJCk9drntnY31ugwMzJjNkHMlU9lqWJQaYLcpK0qgQR6+k/gr53cS6UmlXrckJRbIr626LCUkKGPNT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mz98VrZW; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mz98VrZW"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-91588056619so73143785a.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599054; x=1781203854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAK1PejVMJR2yKwVdMLx0VAgStQ60AVahgVuO0wrW8Q=;
        b=Mz98VrZWyIuVxYRhXdTyTzdTzl5lKnITanxF7cw/aCcoOxnB8VJ7aGGkM2TYqOmJjv
         a4MX9kKNJrFF9MQrckgs3QqLT5P7zuJsxdqMpTVgp1G4lRFu199XHtyNSN4PxwEmtZR4
         LLAAEkyonyMrT2eYjZHEb3BT5f7lSxGODnJRhuozWXfrKzOwZz53mxRRk7SqmGHpawKk
         ABtT0AnzFIJqJ4+ryd9aMtedihgA5AYd/olxIrfV5yCFNPq4ArhWdRqX2NNYBSAXnKgK
         UJcFMGMT5x1DaoovY5TKWVPVSLPDAXtClurOjXBdwonPHwzFBpG+AluMk3nBqgj4stUM
         CUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599054; x=1781203854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XAK1PejVMJR2yKwVdMLx0VAgStQ60AVahgVuO0wrW8Q=;
        b=fSATlqtY3nEtnqRqXdKbNMpsaaINrkfqHhJoacIgmKDMUmaAJQbNwiOPGFEPcVbLR+
         hZKbmx8bt4avXi4wh3BXwTGy0gfoX5OEohsphHMf/0RQ1/LrHxIq0THZy49m7Ca0W6ta
         LKk91/+VRhI7MZEOBfwrMnJjIfS86Soo/6kGZ7W1UN1Z8wM+dRpDM8EbpRKTfwYUDkrh
         dvooBzwXKi7Dmk8TlNs3UeUzuyB02J7xPCpNsNPJppLzZZOz43ROYQ1/lYiniKYZ83Mj
         AnJT7FIiP6pVAt3VfzMg3AXyf4pYr48rJUGMACilzVQpe20RFHIYyw3/V21wEK94C1l4
         e9bg==
X-Gm-Message-State: AOJu0YwHqURTA+QIMSjZtUeJ2Jka9NTMzOjrXDTG7VMWkDcCzdq4i6FA
	8VUQ7hpDU5i5lQ+L49wzBB7i9TfQOaXg1Ykfxc3dDThSXqtNTEa6D3fRW/cGaXk5
X-Gm-Gg: Acq92OEU/qijzKf2wxBuEKhTussWQONqfqR/EyqkWy6qKdOxjarZDzwzCFLs/d3YHIB
	CV7XSOYmO8SRU24AH7w50gw0iRG5FVWS/0Ia6WfIrHwI6db888QlkHen/FuxfWdNmJav/4NvBSG
	GYilsiWW1q15NhxmcNxfeVbSdgTI+Wu7aUWzLKcv5KVX3no0JBr/UlgSHIah5bwPawz0FdywRK9
	rm2eV7P9gF5o7tqT2dvkkLiXkSM+tgLyJy/Q97rdozTsciZVR2jCDHUabrsgNB9gHyQNBdxmEKj
	cl+cqSUZpVsJfHCj3/bBOgNq/wshejEiIlDdq43NrjXmUeIlJ/ARwFNLTOJzK88R6bmlMHsvESK
	nwL8sDDZQQjwYRHQEmITGqIOZajv3j4muDVwokyPBIdGFJpl5KgjE2e/lOSEpgGP+9mjwkmvJGN
	Bs/4UuT44XWJq/qnaoLo+5W722OrL6OW06Od7AQAx10C1aClzc40EyWhjyR+4CUFel2gUxGJzjf
	6UevIR96pumJXWjlEZebQSe7jG1D7oU1hmgFojRUlVFGwjNuVEZ/qMCFAqoDoXd
X-Received: by 2002:a05:620a:390e:b0:914:e3dd:17fd with SMTP id af79cd13be357-915a9c25a45mr76110685a.6.1780599054500;
        Thu, 04 Jun 2026 11:50:54 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.50.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:50:54 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/14] lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery sequence
Date: Thu,  4 Jun 2026 12:29:29 -0700
Message-Id: <20260604192937.65605-7-justintee8345@gmail.com>
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

