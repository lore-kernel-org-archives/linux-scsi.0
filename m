Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F65229B38
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681519; cv=none; b=VZ/tWPgHiXv35SreYbyXB9ea35KqHCDDGP98LjkhF6DHYFniVfakWes0UIX6dc9XWVVaRj2KHcVt0zSTACods9OR55hTZCj6n+x+92080nTEz63uqyF6iSxzzOB8pC+3wSCi9QfN9+z6yEm4xZM/lBzEinBXKXyv++pxJMxVLFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681519; c=relaxed/simple;
	bh=irg10sguo4P4opu9kJcLyizUCQpfPHL3o+kaCIFIOT8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=csAla6QswtjMMSr5MJwf083o2fncSiheZYjdwLLekFOmDrsf8eZ267T0IFhkaNCdMDwmhjtJFGBLz93nSp1ST/GCanAffOhcPt3kZw+IfHNkYpAPqelzqJqliAWSPxkwzKdy6c6wArSEakh8cdrq82kXOCTeCHRRbOrNhASq03w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kttGnqkv; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kttGnqkv"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5176d4c14f5so18176031cf.0
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681506; x=1781286306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXy7x2vQ5tNMNKJfcBjpaaGItqniXr9jZaa22LwaNSE=;
        b=kttGnqkvBzHatORP1F7J7stjeaTePBzFRj3VQFjzaM6Ztlyk7sQYnh6F6HFeoMbEiJ
         0YstGIO5k9CnN7ww/mHcAaTTTmuJyOQY13bCdYUHcXLlPOPx1wP62WbMA+kmagkK97zp
         iQvb/427PZG/VjF5bPZymWLZwQpHZnEdlE3Cf/qD3vfk9JEsVQm/THBLJwjgnpWJ710S
         HwayBtzKd/ZlTemw6FyOdFMVK3Y9h//acEuIzSqSdfaWQZLRBlnU3lJW/IVYxc4wArIA
         S+s/hbLNF1fQWsvJbfRwNssVhaGABscsL2JiAOI4m8jXAI0yavQK81UmBBbRVtoBzdDu
         mfuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681506; x=1781286306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YXy7x2vQ5tNMNKJfcBjpaaGItqniXr9jZaa22LwaNSE=;
        b=ONr4VjXanKalspZiEz067YX1I+n8YNt4sjlkRr3MlwmWcuEnwIDLH9uO47KJNCafir
         vP+/3ik1B/o7v6etDlLHByW0L7UB27tbL0u5Ham6A7Y3AYY3QBSadLVvXVVgUL85U+q3
         fuHu7+Fcd8kGU3cNRSS9TboTle+DuL0FR/6C1vugrPK0Dgh0bzf73WMY+sfwLLXC/WSa
         Vvn659fiZ7Z20bh0/kzorIvxz8FoWd9z4FdeknLv1P9l6v4IM4qmQ8tgAbyCrwqQudWU
         L2Unl2DHKM/P3Fsy1nVdP6kvzncm82vwv0YubHOr4jN/VLhYuq1/vo2eCIU9cNaDcF/h
         mbTw==
X-Gm-Message-State: AOJu0YyQwSyeVwnJzGmKgfs0o9YLHujLiw9Kk2oSUJe5gWSZG/FtZhEB
	7NJjXnRo8PsorkM4kMcNqEsOnficvfNDBYnTvJqNr2KO/CxTPeGY2FkNXD9Xyizn
X-Gm-Gg: Acq92OG+T3J1DhVwTkAb/U4OtQsrw7VAT4LsQDxiqmOilztPS+jGGOvKQIbyFOQbB+A
	ATsTL7HQC7348+/gD5aqihVr8Y6pHHlN0mheICyqmI9fDgcGqwoZKzbGOgDxVfVyRBK6js01FrQ
	Ta/aD22P5iUIjuWPS+k9Rr4XhJUBDPzi2UJh22kevZ3PkY6WGk2Fjg55lav/DbdTytSnkEGgD6W
	0d2pSwme9/TRXi5Yew0LEoyMl9aBXIu/d2aetcFvIubUDoMI5pZ8wkIACm7IN7jHnBUsTc6eLD0
	quYMr+TzaW7sf44RRvYjPxWmGxR2QZkViAPxCwDkwqVuh2VAaNNEAjIuwJARQeiZVnOST1xawPW
	8ppq2SmRWmLrZqbUz719AAh9ZNJISAn5KM+Wk5BCZEx4cSwdB+GCGqGJGGNzekVOxogaFtNoqcM
	yYZ7eo+kXh+KmynGRxCa+yuWowDvcJjC9k7ZGlXdGRP43fdfrfDep6T3+m4zaG8xtSVYvBM5TvT
	JgtXjhWwkMJmHvxxpQZ1Auiwk5H1j5ag0SLWWmSHr93sa3aAfXohQ==
X-Received: by 2002:a05:622a:6115:b0:50e:ca38:e219 with SMTP id d75a77b69052e-51795c0b2cbmr61072211cf.45.1780681505866;
        Fri, 05 Jun 2026 10:45:05 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.45.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:45:05 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 08/14] lpfc: Improve PLOGI retry handling for large SAN configurations
Date: Fri,  5 Jun 2026 11:23:30 -0700
Message-Id: <20260605182336.134919-9-justintee8345@gmail.com>
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

In large SAN configurations with link perturbations, rediscovery of target
ports is problematic due to PLOGI retry race conditions.

This patch improves target rediscovery by ensuring PLOGI retries are
serialized in unregistration and retry handler paths.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 62 +++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c | 58 ++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c       | 87 +++++++++++++++++-------------
 3 files changed, 167 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c67f8581f584..056d63a3d166 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2159,6 +2159,8 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out_freeiocb;
 	}
 
+	clear_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);
+
 	/* Since ndlp can be freed in the disc state machine, note if this node
 	 * is being used during discovery.
 	 */
@@ -2329,17 +2331,43 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	     test_bit(NLP_UNREG_INP, &ndlp->nlp_flag)) &&
 	    ((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
 	    !test_bit(FC_OFFLINE_MODE, &vport->fc_flag)) {
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
 				 "4110 Issue PLOGI x%x deferred "
 				 "on NPort x%x rpi x%x flg x%lx Data:"
 				 " x%px\n",
 				 ndlp->nlp_defer_did, ndlp->nlp_DID,
 				 ndlp->nlp_rpi, ndlp->nlp_flag, ndlp);
 
-		/* We can only defer 1st PLOGI */
-		if (ndlp->nlp_defer_did == NLP_EVT_NOTHING_PENDING)
+		/* Don't defer a PLOGI that is already in that condition.
+		 * Also set the nlp_last_elscmd to PLOGI to get the retry.
+		 */
+		if (ndlp->nlp_defer_did == NLP_EVT_NOTHING_PENDING) {
 			ndlp->nlp_defer_did = did;
-		return 0;
+			ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
+		}
+		return 1;
+	}
+
+	if (test_bit(NLP_PLOGI_SND, &ndlp->nlp_flag)) {
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
+				 "4113 Reject PLOGI issue, PLOGI in-flight "
+				 "x%px, DID x%x nflag x%lx\n",
+				 ndlp, ndlp->nlp_DID, ndlp->nlp_flag);
+		return 1;
+	}
+
+	if (ndlp->nlp_state > NLP_STE_PLOGI_ISSUE &&
+	    ndlp->nlp_state <= NLP_STE_MAPPED_NODE) {
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
+				 "4114 Reject PLOGI issue, Node in "
+				 "unexpected state x%px, DID x%x nflag x%lx "
+				 "in State x%x\n",
+				 ndlp, ndlp->nlp_DID,
+				 ndlp->nlp_flag, ndlp->nlp_state);
+		return 1;
 	}
 
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
@@ -2415,6 +2443,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 		return 1;
 	}
 
+	set_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);
 	return 0;
 }
 
@@ -4614,6 +4643,31 @@ lpfc_els_retry_delay_handler(struct lpfc_nodelist *ndlp)
 		lpfc_issue_els_flogi(vport, ndlp, retry);
 		break;
 	case ELS_CMD_PLOGI:
+		/* The driver delayed a PLOGI via the nlp_delayfunc, but
+		 * it's possible the PLOGI is already on a deferred retry.
+		 * Catch this case and skip this delayed PLOGI. This prevents
+		 * multiple PLOGIs in flight. The defer code flow cleans
+		 * up.
+		 */
+		if ((test_bit(NLP_IGNR_REG_CMPL, &ndlp->nlp_flag) ||
+		     test_bit(NLP_UNREG_INP, &ndlp->nlp_flag)) &&
+		    ndlp->nlp_defer_did != NLP_EVT_NOTHING_PENDING &&
+		    ((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
+		    !test_bit(FC_OFFLINE_MODE, &vport->fc_flag)) {
+			/* When UNREG_RPI completes we need to have the
+			 * nlp_last_elscmd set.
+			 */
+			ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
+					 "4112 Skip delayed PLOGI x%x deferred "
+					 "on NPort x%x rpi x%x flg x%lx Data:"
+					 " x%px\n",
+					 ndlp->nlp_defer_did, ndlp->nlp_DID,
+					 ndlp->nlp_rpi, ndlp->nlp_flag, ndlp);
+			break;
+		}
+
 		if (!lpfc_issue_els_plogi(vport, ndlp->nlp_DID, retry)) {
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index f917a5bcfd02..0270ab7e602f 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -920,6 +920,64 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				 ndlp->nlp_DID, ndlp->nlp_state,
 				 ndlp->nlp_type, vport->fc_flag);
 
+		/* The driver wants to schedule a delayed PLOGI to recover
+		 * the remote Nport.  However, there are two cases that
+		 * stop this so that multiple PLOGI are not inflight to
+		 * the same NPortID
+		 *
+		 * Do not schedule a delayed PLOGI if the deferred PLOGI
+		 * code already set up a PLOGI retry after an UNREG_RPI
+		 * mailbox completes.
+		 */
+		if (test_bit(NLP_UNREG_INP, &ndlp->nlp_flag) &&
+		    ndlp->nlp_defer_did == ndlp->nlp_DID &&
+		    ndlp->nlp_last_elscmd == ELS_CMD_PLOGI) {
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_NODE | LOG_ELS | LOG_DISCOVERY,
+					 "3206 No PLOGI delay, defer PLOGI "
+					 "waiting on DID x%06x UNREG_RPI "
+					 "nflag x%lx state x%x lastels x%x "
+					 "defer_did x%x\n",
+					 ndlp->nlp_DID, ndlp->nlp_flag,
+					 ndlp->nlp_state, ndlp->nlp_last_elscmd,
+					 ndlp->nlp_defer_did);
+			goto out;
+		}
+
+		/* A delayed PLOGI retry is not required if the ndlp's delay
+		 * timer is running and the last command was PLOGI.
+		 */
+		if (test_bit(NLP_DELAY_TMO, &ndlp->nlp_flag) &&
+		    ndlp->nlp_last_elscmd == ELS_CMD_PLOGI) {
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_NODE | LOG_ELS | LOG_DISCOVERY,
+					 "3207 No PLOGI delay, PLOGI_DELAY_TMO "
+					 "active on DID x%06x "
+					 "nflag x%lx state x%x lastels x%x "
+					 "defer_did x%x\n",
+					 ndlp->nlp_DID, ndlp->nlp_flag,
+					 ndlp->nlp_state, ndlp->nlp_last_elscmd,
+					 ndlp->nlp_defer_did);
+			goto out;
+		}
+
+		/* Do not schedule a PLOGI retry if the ndlp state is NPR
+		 * and vport has received an RSCN
+		 */
+		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
+		    test_bit(FC_RSCN_MODE, &vport->fc_flag)) {
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_NODE | LOG_ELS | LOG_DISCOVERY,
+					 "3939 No PLOGI delay, RSCN in "
+					 "progress for NPR DID x%06x "
+					 "nflag x%lx state x%x last_els x%x "
+					 "defer_did x%06x\n",
+					 ndlp->nlp_DID, ndlp->nlp_flag,
+					 ndlp->nlp_state, ndlp->nlp_last_elscmd,
+					 ndlp->nlp_defer_did);
+			goto out;
+		}
+
 		/* Special cases for rports that recover post LOGO. */
 		if ((!(ndlp->nlp_type == NLP_FABRIC) &&
 		     (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET) ||
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 20ee8171e31f..efde944a2693 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2914,7 +2914,19 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			    ndlp->nlp_defer_did != NLP_EVT_NOTHING_PENDING) {
 				clear_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
 				ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
-				lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
+
+				if (!test_bit(NLP_DELAY_TMO, &ndlp->nlp_flag) &&
+				    ndlp->nlp_last_elscmd == ELS_CMD_PLOGI) {
+					rc = lpfc_issue_els_plogi(vport,
+								  ndlp->nlp_DID,
+								  0);
+					if (!rc) {
+						ndlp->nlp_prev_state =
+							ndlp->nlp_state;
+						lpfc_nlp_set_state(vport, ndlp,
+							   NLP_STE_PLOGI_ISSUE);
+					}
+				}
 			} else {
 				clear_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
 			}
@@ -2967,52 +2979,55 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	bool unreg_inp;
 
 	ndlp = pmb->ctx_ndlp;
-	if (pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) {
+	if (pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN && ndlp) {
 		if (phba->sli_rev == LPFC_SLI_REV4 &&
 		    (bf_get(lpfc_sli_intf_if_type,
 		     &phba->sli4_hba.sli_intf) >=
 		     LPFC_SLI_INTF_IF_TYPE_2)) {
-			if (ndlp) {
-				lpfc_printf_vlog(
-					 vport, KERN_INFO,
+			lpfc_printf_vlog(vport, KERN_INFO,
 					 LOG_MBOX | LOG_SLI | LOG_NODE,
-					 "0010 UNREG_LOGIN vpi:x%x "
-					 "rpi:%x DID:%x defer x%x flg x%lx "
-					 "x%px\n",
+					 "0010 UNREG_LOGIN vpi:x%x rpi:%x "
+					 "DID:%x defer x%x flg x%lx x%px\n",
 					 vport->vpi, ndlp->nlp_rpi,
 					 ndlp->nlp_DID, ndlp->nlp_defer_did,
-					 ndlp->nlp_flag,
-					 ndlp);
+					 ndlp->nlp_flag, ndlp);
 
-				/* Cleanup the nlp_flag now that the UNREG RPI
-				 * has completed.
-				 */
-				unreg_inp = test_and_clear_bit(NLP_UNREG_INP,
-							       &ndlp->nlp_flag);
-				clear_bit(NLP_LOGO_ACC, &ndlp->nlp_flag);
+			/* Cleanup the nlp_flag now that the UNREG RPI
+			 * has completed.
+			 */
+			unreg_inp = test_and_clear_bit(NLP_UNREG_INP,
+						       &ndlp->nlp_flag);
+			clear_bit(NLP_LOGO_ACC, &ndlp->nlp_flag);
 
-				/* Check to see if there are any deferred
-				 * events to process
-				 */
-				if (unreg_inp &&
-				    ndlp->nlp_defer_did !=
-				    NLP_EVT_NOTHING_PENDING) {
-					lpfc_printf_vlog(
-						vport, KERN_INFO,
-						LOG_MBOX | LOG_SLI | LOG_NODE,
-						"4111 UNREG cmpl deferred "
-						"clr x%x on "
-						"NPort x%x Data: x%x x%px\n",
-						ndlp->nlp_rpi, ndlp->nlp_DID,
-						ndlp->nlp_defer_did, ndlp);
-					ndlp->nlp_defer_did =
-						NLP_EVT_NOTHING_PENDING;
-					lpfc_issue_els_plogi(
-						vport, ndlp->nlp_DID, 0);
-				}
+			/* Check to see if there are any deferred
+			 * events to process
+			 */
+			if (unreg_inp &&
+			    ndlp->nlp_defer_did != NLP_EVT_NOTHING_PENDING) {
+				lpfc_printf_vlog(vport, KERN_INFO,
+						 LOG_MBOX | LOG_SLI | LOG_NODE,
+						 "4111 UNREG cmpl deferred "
+						 "clr x%x on  NPort x%x "
+						 "Data: x%x x%x x%px\n",
+						 ndlp->nlp_rpi, ndlp->nlp_DID,
+						 ndlp->nlp_defer_did,
+						 ndlp->nlp_last_elscmd, ndlp);
+				ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 
-				lpfc_nlp_put(ndlp);
+				if (!test_bit(NLP_DELAY_TMO, &ndlp->nlp_flag) &&
+				    ndlp->nlp_last_elscmd == ELS_CMD_PLOGI) {
+					if (lpfc_issue_els_plogi(vport,
+								 ndlp->nlp_DID,
+								 0))
+						goto out;
+
+					ndlp->nlp_prev_state = ndlp->nlp_state;
+					lpfc_nlp_set_state(vport, ndlp,
+							   NLP_STE_PLOGI_ISSUE);
+				}
 			}
+out:
+			lpfc_nlp_put(ndlp);
 		}
 	}
 
-- 
2.38.0

