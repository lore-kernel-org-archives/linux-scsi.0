Received: from mail-dl2-f36.google.com (mail-dl2-f36.google.com [74.125.229.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCC44E9C16
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618104; cv=none; b=dkgdGEYIKok0MhwAlL10bhxTzJN0ax/xKV2urOJDCKQeQnF0Vk4LGOXiVskV98QroFCSHOJHntBpLPlkvjVR0OGgQfU8Jaxv3leRsZleBkzcX/MZJlruuNWDfww/w9ZPyykTQ1/9zTsB+dRuVmxS1z+w8aqIqSAAJANjaEjt2rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618104; c=relaxed/simple;
	bh=yo9h9d7eYcWwxEPyjPjNZ6XfQFvw1edQdwX6q2EoHlg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hlnLKUFX2yVdJODmgsmR3Bw42J4RWJp3QK/8X/ERTClki1q3k/K85yX8Wg2FwEK75ptGpZpGLJaSANRj//4nwgWlK6M3ffF8MKarNxSp4O3P43d4U6NLnN+riFermtj/4cxiRigrbVz12E4H8f0JRUX9tDrJ1Y/CWpNbIyQjlFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i8Dsi2ds; arc=none smtp.client-ip=74.125.229.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i8Dsi2ds"
Received: by mail-dl2-f36.google.com with SMTP id a92af1059eb24-14373bcc010so2829509c88.1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618101; x=1791222901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LVK138RppNiT8tW29zWZxDpjRmApdveBKq+9o67goAk=;
        b=i8Dsi2dsHTJ6uXFmELElOAyuWBTrpGlC1Wlm1BQGYqZWxHsqHpx7lzTP6djWHm3MGx
         uX6b6xlKzd/apn7deTEaypaSJS+S03bTguJIHP9bUQZ5IG89AjzX2vU4ggmtWXKFil1O
         w+M76IXInNJq+c+C5rg4FStX3jk3NDVtVJdPWpVu4Dde1DnhF4KhIOZJ1Wb9mm/OvaIg
         XRaxmL4bWlSSTjqche00ffRH+kLLhKH6bXR/2aCLO/iA1a6mGUwUXwvcwqPB96FF641q
         cpS1Kl/ABgg574ZUKZoueGGWtCuQnAdfouWAEHqzB0H0MmYa65sI3n6iWtxYZj0Gn9zG
         WzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618101; x=1791222901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LVK138RppNiT8tW29zWZxDpjRmApdveBKq+9o67goAk=;
        b=te3aEvJNQ7084lNwM0McTzv13wqAx+upEizGkb98KH2ArhmJkzv4EQPGefDunyrZA2
         aZ3IsluTezIiodOpdAPx0MM32DOu3AwPgFx8TLkBKAvsv82/RVwuoVqMyAkHKKdZ6I/4
         +G/KOMXjIEWFx8YTjjNblQ4qkQkMAEWFTMfK2Lt9ehmO+LHP4kLYE8rrHayUkL0wN1N9
         e+DZR18yFV6FxagdY3MIvBdG82WenpLcQAfq6hpVHbkpEgUfD282fqpJAb4jgOsrzhEt
         GNoab0KMddw8Vso3RuX7510eKGjkvjPWbUn/ZcGNFph+9Tx3wofcGuLWZR22FN2cnRsz
         P5Ag==
X-Gm-Message-State: AFuF++lfY007BD6SvfK/zAB4I4w9BgreJ0d8iDbu36HbeLBV0RSUO4A9
	5p+M1DTAhfDftbOZfh1tYNhhkoDlbC1Ls5fmV8WKGbCqE9dulc4ySNG3LIY4C4z3
X-Gm-Gg: AYBFou22GfrTzd1SerzPFHBtiLr50qJv7XRAEoA0irFRWmZ/Jo2WDrttUOmUNaKf09j
	LT0Zw2GPBfcFLjF3m8K4Y0Gw42eycHfECSoUWjiD1NeXI0QyDT3Rs5yB+wynxyfJ8IxBIij5WY6
	oabslZLdnfml/BOngX7UG8J0mMaOBzMvbL83VziwB/zUzYO/IhbhH1kr3V/aU41AdMrw7lXKl4G
	Jw6FrXaXjGef179uAvU5OEpvY0iNNDh0z4foOim3eGEZ1nbwC2aN/dTbDL9c4wAAMkjp9BYqE6f
	EkCl47ymPI1S8mr7BE+x8c/vqnIGs/Uo+RdlsEuFAqhGAofi6/zd5zxgW1RpF5D+CcIcFLV26wy
	F2fCwCZhFtPZKd82Jsvrj5NGctk40d8jsCZHCLNIaEQn7g2FmT950lCJfcKCyIc1PyoYCR6tp7f
	fZNPIi4ASvH6jXbYXxG0SA58k+vLKHrFfAxQSqjxLHwFA73SbIAL3aVzX+J18Whs4I1FzqPzT43
	YCqRQfnyhFFXm1yFbMuGrx37tuTePpiJ/wmpW4AIU5yNK5l+T+eP2Geey2wDO0cuFlAAQ==
X-Received: by 2002:a05:701b:21db:b0:14a:8df8:56b1 with SMTP id a92af1059eb24-14a8df85cc5mr1984866c88.22.1790618101017;
        Mon, 28 Sep 2026 10:55:01 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.55.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:55:00 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 06/10] lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery sequence
Date: Mon, 28 Sep 2026 11:17:53 -0700
Message-Id: <20260928181757.21959-7-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In large SAN configurations when a target port fails over, RSCNs may
be spammed triggering a repeat of restarting discovery events for an
ndlp object.

In the case when discovery reaches PRLI state, but the PRLI operation
is interrupted, this leaves the nlp_fc4_type and nlp_type flags
cleared. On the next cycle through lpfc_nlp_reg_node, the NLP_XPT_REGD
flag is set but registraton with the fc transport is bypassed because
lpfc_valid_xpt_node returns false.

This sets up a condition whereby the next call to lpfc_nlp_unreg_node
results in a premature release of the ndlp, and a callback from the
transport results in a use-after-free condition.

To address this issue, refactor lpfc_fc4_xpt_flags such that both
SCSI and NVME have separate flags indicating registration with their
respective transport.  The flags also indicate a request to unregister
had been made. In dev-loss or transport callback processing, the
SCSI_XPT_UNREG_WAIT and NVME_XPT_UNREG_WAIT flags indicate whether
the ndlp reference has already been released.

Introduce explicit, symmetric reference-count tracking for NVMET
target nodes via the new NVMET_XPT_TGT flag and close a race in
lpfc_unregister_remote_port() by marking UNREG_WAIT before
triggering fc_remote_port_delete() rather than after.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h    |   5 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 163 ++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_nvme.c    |   9 ++
 3 files changed, 107 insertions(+), 70 deletions(-)

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
index 4c673dffa671..83e29eed14fa 100644
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
@@ -4488,26 +4481,36 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct lpfc_hba  *phba = vport->phba;
 	unsigned long flags;
 
-	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
+	/* Don't add the remote port if unloading. */
+	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		return;
 
+	spin_lock_irqsave(&ndlp->lock, flags);
+	if ((ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | SCSI_XPT_UNREG_WAIT)) ==
+	    SCSI_XPT_REGD) {
+		/* Prevent racing registrations */
+		spin_unlock_irqrestore(&ndlp->lock, flags);
+		return;
+	}
+	ndlp->fc4_xpt_flags &= ~SCSI_XPT_UNREG_WAIT;
+	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD;
+	spin_unlock_irqrestore(&ndlp->lock, flags);
+
 	/* Remote port has reappeared. Re-register w/ FC transport */
 	rport_ids.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
 	rport_ids.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
 	rport_ids.port_id = ndlp->nlp_DID;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
-
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
 			      "rport add:       did:x%x flg:x%lx type x%x",
 			      ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
-	/* Don't add the remote port if unloading. */
-	if (test_bit(FC_UNLOADING, &vport->load_flag))
-		return;
-
 	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
 	if (!rport) {
+		spin_lock_irqsave(&ndlp->lock, flags);
+		ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+		spin_unlock_irqrestore(&ndlp->lock, flags);
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
 			   "Warning: fc_remote_port_add failed\n");
 		return;
@@ -4519,6 +4522,9 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	rdata = rport->dd_data;
 	rdata->pnode = lpfc_nlp_get(ndlp);
 	if (!rdata->pnode) {
+		spin_lock_irqsave(&ndlp->lock, flags);
+		ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+		spin_unlock_irqrestore(&ndlp->lock, flags);
 		dev_warn(&phba->pcidev->dev,
 			 "Warning - node ref failed. Unreg rport\n");
 		fc_remote_port_delete(rport);
@@ -4526,10 +4532,6 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		return;
 	}
 
-	spin_lock_irqsave(&ndlp->lock, flags);
-	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD;
-	spin_unlock_irqrestore(&ndlp->lock, flags);
-
 	if (ndlp->nlp_type & NLP_FCP_TARGET)
 		rport_ids.roles |= FC_PORT_ROLE_FCP_TARGET;
 	if (ndlp->nlp_type & NLP_FCP_INITIATOR)
@@ -4562,6 +4564,7 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 {
 	struct fc_rport *rport = ndlp->rport;
 	struct lpfc_vport *vport = ndlp->vport;
+	unsigned long flags;
 
 	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
 		return;
@@ -4576,7 +4579,21 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
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
 
@@ -4623,7 +4640,10 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	lpfc_check_nlp_post_devloss(vport, ndlp);
 
 	spin_lock_irqsave(&ndlp->lock, iflags);
-	if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
+	if (((ndlp->fc4_xpt_flags & SCSI_XPT_REGD) &&
+	     !(ndlp->fc4_xpt_flags & SCSI_XPT_UNREG_WAIT)) ||
+	    ((ndlp->fc4_xpt_flags & NVME_XPT_REGD) &&
+	     !(ndlp->fc4_xpt_flags & NVME_XPT_UNREG_WAIT))) {
 		/* Already registered with backend, trigger rescan */
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
 
@@ -4633,41 +4653,46 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		}
 		return;
 	}
-
-	ndlp->fc4_xpt_flags |= NLP_XPT_REGD;
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
-	if (lpfc_valid_xpt_node(ndlp)) {
-		vport->phba->nport_event_cnt++;
-		/*
-		 * Tell the fc transport about the port, if we haven't
-		 * already. If we have, and it's a scsi entity, be
-		 */
-		lpfc_register_remote_port(vport, ndlp);
+	if (vport->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		if (lpfc_valid_xpt_node(ndlp)) {
+			vport->phba->nport_event_cnt++;
+			/* Tell the fc transport about the port */
+			lpfc_register_remote_port(vport, ndlp);
+		}
 	}
 
 	/* We are done if we do not have any NVME remote node */
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
 
@@ -4678,7 +4703,15 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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
@@ -4688,12 +4721,11 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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
@@ -4706,16 +4738,11 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 71714ea390d9..1b854306d577 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2601,6 +2601,15 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * The transport will update it.
 		 */
 		spin_lock_irq(&ndlp->lock);
+		/* Prevent racing unregister requests. */
+		if (ndlp->fc4_xpt_flags & NVME_XPT_UNREG_WAIT) {
+			spin_unlock_irq(&ndlp->lock);
+			lpfc_vlog_msg(vport, KERN_NOTICE, LOG_NVME_DISC,
+				      "6034 NVME unregister in progress, "
+				      "remote port x%px, refcnt %d\n",
+				      remoteport, kref_read(&ndlp->kref));
+			return;
+		}
 		ndlp->fc4_xpt_flags |= NVME_XPT_UNREG_WAIT;
 		spin_unlock_irq(&ndlp->lock);
 
-- 
2.38.0

