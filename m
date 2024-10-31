Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1051CCB30
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412943; cv=none; b=qtMxum1eQw38YPdzB/L7oOsv2ij9yIfONk42rS+hogJcQ0FIU2fqDec8XRgMe2X9sqcZe4c7m3MfYw3QitydhOFwddjwmBr2fVaqv7s5d0ME4gwfpqAs9lzTSwswf2e4UYb7YZmblhbJ30a0N1dMyAQ3YyG3RinUHrTQIz+f1Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412943; c=relaxed/simple;
	bh=t3ryj4gi87N/iyZvHo73ItJRIsQq7UQ2F0RU3vHnkuU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kvdXjrHZCeeCVflURgjDKw9Z5BKNYE7Sg8+yV5oVkPPZiAI7B+SbL5mFHMxEN/YvN1iaH359S/yCR0o7iwcIJpULPjppESA9/0mz+I6dmF1BumeQ9jOVm/ZVcHiw4ZefLlrhEmJZB8X0jlVE032sJJ9ODR9CSf7eOvGP3kpnYIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mdwaFmBZ; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdwaFmBZ"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7ede82dbb63so958896a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412936; x=1731017736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=emYPRwMMg54wVmcucg16hyNsUZsdXG2wp8EJhj3XyR4=;
        b=mdwaFmBZTLbHFS8LYfUmUefI3Vr/+VCXGUsxUKC17fexRE5fZhfQGcmlnXMvIhQWTI
         MpVYtuha3taCGC7/+1Ea/CU/jYLXeYPQFU1nbzN5ZvVyJkkjs/ERYka5pmwZ99emC+hU
         WNTiLH9j0egyo/+oF7sQPLSi3NdIvXjbmB5pezTgSiSSbrr1bpf8wS1AbDbIbmMLt/Ix
         95MTONYU7MeMm/G69xLnciFnPVLIh+bGhi6AVfxeSJ1lPOpEw+tiKJIupHHmywoWy4M4
         N7FOrFqtc6FzrzdiOWG9we4C7a1FVLYWsf2+clbN2m/0zcGwV7KMFbKxeOaaMKM0dOsW
         opuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412936; x=1731017736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=emYPRwMMg54wVmcucg16hyNsUZsdXG2wp8EJhj3XyR4=;
        b=TxLN/rimDxp9zsrsJ+m/pw5I25+p6Oo718Q34WSVZuG03V/n9guaAGF/UFQLOv8BzY
         Hj6zfDzh3TBZI2Ilj+R3+7HS5alPDUHqWQyXs/YL0EvO2QwmvUPgVaGrXl/szqREPfvq
         d7Lv2h1iMn64tFCAG0uZkKBtiA9YvcpVFKSzVI798jRU8rc2CBMUeeVv9wv1d2lMFzHc
         aVi8RXqlnwVLmCgaMVH/rD1aieemK/u0yTLxTrrEzQ06AYMrTXSAWg12msg9IYRbnB9K
         2KBN4eIlqEnpkuL1LFLflDpLiWcZCAyThEIVj8ITgwyECCUBS70LiksIDiXCMe5OriK5
         zV2A==
X-Gm-Message-State: AOJu0YyWb/DqJ43j/m08NaxAaxxk+Mtzs/oy3lQS2+AHil8zaBa2MmBK
	UR1M4qYBy2rFHs7pp/yzC+PCDWajLqKSxDzZjNfXrjRb1fQjDn1GvDuHHQ==
X-Google-Smtp-Source: AGHT+IEFauMfrEL3hV4NJ6JuDN2uOGnYBNS2Eglf1ibTjKYxGmM2d6mTL+Xn8lYB0ypXtr64r3qGpw==
X-Received: by 2002:a17:90b:394b:b0:2e2:ba35:3574 with SMTP id 98e67ed59e1d1-2e94c2adb7dmr2088643a91.11.1730412935801;
        Thu, 31 Oct 2024 15:15:35 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:35 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/11] lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure
Date: Thu, 31 Oct 2024 15:32:16 -0700
Message-Id: <20241031223219.152342-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An RPI is tightly bound to an ndlp structure and is freed only upon release
of an ndlp object.  As such, there should be no logic that frees an RPI
outside of the lpfc_nlp_release routine.  In order to reinforce the
original design usage of RPIs, this patch removes the NLP_RELEASE_RPI flag
and related logic.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h    |  2 +-
 drivers/scsi/lpfc/lpfc_disc.h    |  1 -
 drivers/scsi/lpfc/lpfc_els.c     | 32 +++-----------------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 52 +++++++-------------------------
 drivers/scsi/lpfc/lpfc_init.c    | 36 +++++++---------------
 drivers/scsi/lpfc/lpfc_sli.c     | 48 +++++++++++------------------
 6 files changed, 44 insertions(+), 127 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index b1e26a5abe58..f8a77ffdb0a8 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -571,7 +571,7 @@ int lpfc_issue_reg_vfi(struct lpfc_vport *);
 int lpfc_issue_unreg_vfi(struct lpfc_vport *);
 int lpfc_selective_reset(struct lpfc_hba *);
 int lpfc_sli4_read_config(struct lpfc_hba *);
-void lpfc_sli4_node_prep(struct lpfc_hba *);
+void lpfc_sli4_node_rpi_restore(struct lpfc_hba *phba);
 int lpfc_sli4_els_sgl_update(struct lpfc_hba *phba);
 int lpfc_sli4_nvmet_sgl_update(struct lpfc_hba *phba);
 int lpfc_io_buf_flush(struct lpfc_hba *phba, struct list_head *sglist);
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index f5ae8cc15820..5d6eabaeb094 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -185,7 +185,6 @@ struct lpfc_node_rrq {
 /* Defines for nlp_flag (uint32) */
 #define NLP_IGNR_REG_CMPL  0x00000001 /* Rcvd rscn before we cmpl reg login */
 #define NLP_REG_LOGIN_SEND 0x00000002   /* sent reglogin to adapter */
-#define NLP_RELEASE_RPI    0x00000004   /* Release RPI to free pool */
 #define NLP_SUPPRESS_RSP   0x00000010	/* Remote NPort supports suppress rsp */
 #define NLP_PLOGI_SND      0x00000020	/* sent PLOGI request for this entry */
 #define NLP_PRLI_SND       0x00000040	/* sent PRLI request for this entry */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3d965c0fd0c6..2c64f8d0a7bd 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3063,8 +3063,6 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 */
 	if (ndlp->nlp_flag & NLP_TARGET_REMOVE) {
 		spin_lock_irq(&ndlp->lock);
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			ndlp->nlp_flag |= NLP_RELEASE_RPI;
 		ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 		spin_unlock_irq(&ndlp->lock);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
@@ -5456,24 +5454,14 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 
 	/* An SLI4 NPIV instance wants to drop the node at this point under
-	 * these conditions and release the RPI.
+	 * these conditions because it doesn't need the login.
 	 */
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
 	    vport && vport->port_type == LPFC_NPIV_PORT &&
 	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
-		if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
-			if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE &&
-			    ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) {
-				lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
-				spin_lock_irq(&ndlp->lock);
-				ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-				ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
-				spin_unlock_irq(&ndlp->lock);
-			}
-			lpfc_drop_node(vport, ndlp);
-		} else if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE &&
-			   ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE &&
-			   ndlp->nlp_state != NLP_STE_PRLI_ISSUE) {
+		if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE &&
+		    ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE &&
+		    ndlp->nlp_state != NLP_STE_PRLI_ISSUE) {
 			/* Drop ndlp if there is no planned or outstanding
 			 * issued PRLI.
 			 *
@@ -5852,18 +5840,6 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 		return 1;
 	}
 
-	/* The NPIV instance is rejecting this unsolicited ELS. Make sure the
-	 * node's assigned RPI gets released provided this node is not already
-	 * registered with the transport.
-	 */
-	if (phba->sli_rev == LPFC_SLI_REV4 &&
-	    vport->port_type == LPFC_NPIV_PORT &&
-	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
-		spin_lock_irq(&ndlp->lock);
-		ndlp->nlp_flag |= NLP_RELEASE_RPI;
-		spin_unlock_irq(&ndlp->lock);
-	}
-
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 3c8cb6ecc0ac..af1fdecf5341 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5212,14 +5212,6 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 		lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
 	} else {
-		/* NLP_RELEASE_RPI is only set for SLI4 ports. */
-		if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
-			lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
-			spin_lock_irq(&ndlp->lock);
-			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
-			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-			spin_unlock_irq(&ndlp->lock);
-		}
 		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag &= ~NLP_UNREG_INP;
 		spin_unlock_irq(&ndlp->lock);
@@ -5242,8 +5234,6 @@ static void
 lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
 	struct lpfc_nodelist *ndlp, LPFC_MBOXQ_t *mbox)
 {
-	unsigned long iflags;
-
 	/* Driver always gets a reference on the mailbox job
 	 * in support of async jobs.
 	 */
@@ -5261,13 +5251,6 @@ lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
 		    (kref_read(&ndlp->kref) > 0)) {
 		mbox->mbox_cmpl = lpfc_sli4_unreg_rpi_cmpl_clr;
 	} else {
-		if (test_bit(FC_UNLOADING, &vport->load_flag)) {
-			if (phba->sli_rev == LPFC_SLI_REV4) {
-				spin_lock_irqsave(&ndlp->lock, iflags);
-				ndlp->nlp_flag |= NLP_RELEASE_RPI;
-				spin_unlock_irqrestore(&ndlp->lock, iflags);
-			}
-		}
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	}
 }
@@ -5330,14 +5313,11 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				return 1;
 			}
 
+			/* Accept PLOGIs after unreg_rpi_cmpl. */
 			if (mbox->mbox_cmpl == lpfc_sli4_unreg_rpi_cmpl_clr)
-				/*
-				 * accept PLOGIs after unreg_rpi_cmpl
-				 */
 				acc_plogi = 0;
-			if (((ndlp->nlp_DID & Fabric_DID_MASK) !=
-			    Fabric_DID_MASK) &&
-			    (!test_bit(FC_OFFLINE_MODE, &vport->fc_flag)))
+
+			if (!test_bit(FC_OFFLINE_MODE, &vport->fc_flag))
 				ndlp->nlp_flag |= NLP_UNREG_INP;
 
 			lpfc_printf_vlog(vport, KERN_INFO,
@@ -5561,10 +5541,6 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	list_del_init(&ndlp->dev_loss_evt.evt_listp);
 	list_del_init(&ndlp->recovery_evt.evt_listp);
 	lpfc_cleanup_vports_rrqs(vport, ndlp);
-
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		ndlp->nlp_flag |= NLP_RELEASE_RPI;
-
 	return 0;
 }
 
@@ -6573,8 +6549,9 @@ lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did)
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		ndlp->nlp_rpi = rpi;
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_DISCOVERY,
-				 "0007 Init New ndlp x%px, rpi:x%x DID:%x "
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
+				 "0007 Init New ndlp x%px, rpi:x%x DID:x%x "
 				 "flg:x%x refcnt:%d\n",
 				 ndlp, ndlp->nlp_rpi, ndlp->nlp_DID,
 				 ndlp->nlp_flag, kref_read(&ndlp->kref));
@@ -6619,19 +6596,12 @@ lpfc_nlp_release(struct kref *kref)
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	lpfc_cleanup_node(vport, ndlp);
 
-	/* Not all ELS transactions have registered the RPI with the port.
-	 * In these cases the rpi usage is temporary and the node is
-	 * released when the WQE is completed.  Catch this case to free the
-	 * RPI to the pool.  Because this node is in the release path, a lock
-	 * is unnecessary.  All references are gone and the node has been
-	 * dequeued.
+	/* All nodes are initialized with an RPI that needs to be released
+	 * now. All references are gone and the node has been dequeued.
 	 */
-	if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
-		if (ndlp->nlp_rpi != LPFC_RPI_ALLOC_ERROR &&
-		    !(ndlp->nlp_flag & (NLP_RPI_REGISTERED | NLP_UNREG_INP))) {
-			lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
-			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-		}
+	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
+		lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
+		ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
 	}
 
 	/* The node is not freed back to memory, it is released to a pool so
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c16a321404c5..006e22506ae8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3380,7 +3380,7 @@ lpfc_block_mgmt_io(struct lpfc_hba *phba, int mbx_action)
 }
 
 /**
- * lpfc_sli4_node_prep - Assign RPIs for active nodes.
+ * lpfc_sli4_node_rpi_restore - Recover assigned RPIs for active nodes.
  * @phba: pointer to lpfc hba data structure.
  *
  * Allocate RPIs for all active remote nodes. This is needed whenever
@@ -3388,7 +3388,7 @@ lpfc_block_mgmt_io(struct lpfc_hba *phba, int mbx_action)
  * is to fixup the temporary rpi assignments.
  **/
 void
-lpfc_sli4_node_prep(struct lpfc_hba *phba)
+lpfc_sli4_node_rpi_restore(struct lpfc_hba *phba)
 {
 	struct lpfc_nodelist  *ndlp, *next_ndlp;
 	struct lpfc_vport **vports;
@@ -3398,10 +3398,10 @@ lpfc_sli4_node_prep(struct lpfc_hba *phba)
 		return;
 
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports == NULL)
+	if (!vports)
 		return;
 
-	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+	for (i = 0; i <= phba->max_vports && vports[i]; i++) {
 		if (test_bit(FC_UNLOADING, &vports[i]->load_flag))
 			continue;
 
@@ -3410,7 +3410,13 @@ lpfc_sli4_node_prep(struct lpfc_hba *phba)
 					 nlp_listp) {
 			rpi = lpfc_sli4_alloc_rpi(phba);
 			if (rpi == LPFC_RPI_ALLOC_ERROR) {
-				/* TODO print log? */
+				lpfc_printf_vlog(ndlp->vport, KERN_INFO,
+						 LOG_NODE | LOG_DISCOVERY,
+						 "0099 RPI alloc error for "
+						 "ndlp x%px DID:x%06x "
+						 "flg:x%x\n",
+						 ndlp, ndlp->nlp_DID,
+						 ndlp->nlp_flag);
 				continue;
 			}
 			ndlp->nlp_rpi = rpi;
@@ -3830,26 +3836,6 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 					ndlp->nlp_flag &= ~(NLP_UNREG_INP |
 							    NLP_RPI_REGISTERED);
 					spin_unlock_irq(&ndlp->lock);
-					if (phba->sli_rev == LPFC_SLI_REV4)
-						lpfc_sli_rpi_release(vports[i],
-								     ndlp);
-				} else {
-					lpfc_unreg_rpi(vports[i], ndlp);
-				}
-				/*
-				 * Whenever an SLI4 port goes offline, free the
-				 * RPI. Get a new RPI when the adapter port
-				 * comes back online.
-				 */
-				if (phba->sli_rev == LPFC_SLI_REV4) {
-					lpfc_printf_vlog(vports[i], KERN_INFO,
-						 LOG_NODE | LOG_DISCOVERY,
-						 "0011 Free RPI x%x on "
-						 "ndlp: x%px did x%x\n",
-						 ndlp->nlp_rpi, ndlp,
-						 ndlp->nlp_DID);
-					lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
-					ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
 				}
 
 				if (ndlp->nlp_type & NLP_FABRIC) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5ad5ff10256b..c1ce05646e72 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2844,27 +2844,6 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	return;
 }
 
-static void
-__lpfc_sli_rpi_release(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
-{
-	unsigned long iflags;
-
-	if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
-		lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
-		spin_lock_irqsave(&ndlp->lock, iflags);
-		ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
-		ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-		spin_unlock_irqrestore(&ndlp->lock, iflags);
-	}
-	ndlp->nlp_flag &= ~NLP_UNREG_INP;
-}
-
-void
-lpfc_sli_rpi_release(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
-{
-	__lpfc_sli_rpi_release(vport, ndlp);
-}
-
 /**
  * lpfc_sli_def_mbox_cmpl - Default mailbox completion handler
  * @phba: Pointer to HBA context object.
@@ -2944,8 +2923,6 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				ndlp->nlp_flag &= ~NLP_UNREG_INP;
 				ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 				lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
-			} else {
-				__lpfc_sli_rpi_release(vport, ndlp);
 			}
 
 			/* The unreg_login mailbox is complete and had a
@@ -2993,6 +2970,7 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport  *vport = pmb->vport;
 	struct lpfc_nodelist *ndlp;
+	u32 unreg_inp;
 
 	ndlp = pmb->ctx_ndlp;
 	if (pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) {
@@ -3011,14 +2989,22 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 					 ndlp->nlp_DID, ndlp->nlp_defer_did,
 					 ndlp->nlp_flag,
 					 ndlp);
-				ndlp->nlp_flag &= ~NLP_LOGO_ACC;
+
+				/* Cleanup the nlp_flag now that the UNREG RPI
+				 * has completed.
+				 */
+				spin_lock_irq(&ndlp->lock);
+				unreg_inp = ndlp->nlp_flag & NLP_UNREG_INP;
+				ndlp->nlp_flag &=
+					~(NLP_UNREG_INP | NLP_LOGO_ACC);
+				spin_unlock_irq(&ndlp->lock);
 
 				/* Check to see if there are any deferred
 				 * events to process
 				 */
-				if ((ndlp->nlp_flag & NLP_UNREG_INP) &&
-				    (ndlp->nlp_defer_did !=
-				    NLP_EVT_NOTHING_PENDING)) {
+				if (unreg_inp &&
+				    ndlp->nlp_defer_did !=
+				    NLP_EVT_NOTHING_PENDING) {
 					lpfc_printf_vlog(
 						vport, KERN_INFO,
 						LOG_MBOX | LOG_SLI | LOG_NODE,
@@ -3027,14 +3013,12 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 						"NPort x%x Data: x%x x%px\n",
 						ndlp->nlp_rpi, ndlp->nlp_DID,
 						ndlp->nlp_defer_did, ndlp);
-					ndlp->nlp_flag &= ~NLP_UNREG_INP;
 					ndlp->nlp_defer_did =
 						NLP_EVT_NOTHING_PENDING;
 					lpfc_issue_els_plogi(
 						vport, ndlp->nlp_DID, 0);
-				} else {
-					__lpfc_sli_rpi_release(vport, ndlp);
 				}
+
 				lpfc_nlp_put(ndlp);
 			}
 		}
@@ -8752,6 +8736,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				lpfc_sli_config_mbox_opcode_get(
 					phba, mboxq),
 				rc, dd);
+
 	/*
 	 * Allocate all resources (xri,rpi,vpi,vfi) now.  Subsequent
 	 * calls depends on these resources to complete port setup.
@@ -8764,6 +8749,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		goto out_free_mbox;
 	}
 
+	lpfc_sli4_node_rpi_restore(phba);
+
 	lpfc_set_host_data(phba, mboxq);
 
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
@@ -8951,7 +8938,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		rc = -ENODEV;
 		goto out_free_iocblist;
 	}
-	lpfc_sli4_node_prep(phba);
 
 	if (!test_bit(HBA_FCOE_MODE, &phba->hba_flag)) {
 		if ((phba->nvmet_support == 0) || (phba->cfg_nvmet_mrq == 1)) {
-- 
2.38.0

