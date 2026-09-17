Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FE13C1D5B
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682265; cv=none; b=jD1y+RfsCpRAN9TPxIOqBphw1IZjPCeyIUmKIeQXXkBA4kKmrt2ZYSfhM72yPpoVax2MY+l5IthDsrTmYy1MoY8zLVxcZRmfiYqHYokmy3eEsRhPiiCVfa0WxxpD2CkZNPpSj8nZfAouOE//dmZN7WFx/8OpFn4YnWpY3Bxjr/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682265; c=relaxed/simple;
	bh=qbm51fCz7nNvhs59hU8Wm3bZ9MT3kbEXWv3h/P3A8HE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UWP12kTJzXVOWZgHI3gIZ2Ek+RoiN8m+nxOL9MYpvL1q6/WnLAc+muSwl0fj+6FoHLmfsc/md+qgLT04ejtC5yW3FlemVyC5rtVlcr3yRm4Nh5eYBffpAp0N5w7qfRGuXrtihCx+rhmtHUsZ6HpJl0zv0beJy2BSrsAn1wJxDpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UStgycIc; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UStgycIc"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8674704dab1so207364b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682260; x=1790287060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4wzXDfgFXpUh+TXQXjNDO5+cdQ54snHlkLnR5l//jiw=;
        b=UStgycIcHyDPZn0tzeEpkU4kvr41IH22jqFMi0ISko38MjQalpYlLsCRe6D5jgwISo
         m7eiKSAWHY/hkgOYSoAnRbS4bFn4KIF3xFU64eYTSU13TTAoijBhM41HtC5JHVOQaD+i
         dh9aAtJmSCFqMM5jsqpHaBw55qzD6mWaDNWqbsNt2zz8oDNv0T/hsH9SnhWCRior0Yyb
         oyew1Msr/irZJxtR9J33ORG3sraEAPAJQEYGycWeJVHFJaWeSzqcVkyXsj0a+Pwmzntj
         rH66gelUiXxSCoWya67evBccmd4Fe9DH07IkhuHwaQSLzVpNE7TP+kj1rPwcIieAlKJP
         IxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682260; x=1790287060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4wzXDfgFXpUh+TXQXjNDO5+cdQ54snHlkLnR5l//jiw=;
        b=gEZGiYkYD7fQGQDaAW75I3CGjcwfa8OQFv1uQ5ZsOMXVKPK51LxcHWxVTwTtFr0YEi
         xwDtaB7LfNaA09CPoUW5gAyEZwc9EU7tSy4DKs4IQJGg90zhR2hTRtGkEE4qdkp1pGGo
         pEIiNYrln1YqwlJ//qWZiHXt2b698SpjCVGBFtj2Buacg4Cy2AOdA4bsoRHrg6QaKkIX
         5cF8iAGhpk137PNy7ASKp6LOeF3u4N8TugYvkvgYPCBdyFGrNeXxKu8J9SxtMLa8b4ps
         1Ou6FlCryvOW6P3tGqwWwIg0GZqjlazMkJHmhWSZtmJUjV5betCvG0tEMiTZPdFniub5
         YKyA==
X-Gm-Message-State: AFuF++kQL4EuuTRX/AGjzAP15HZoxl82D7huCTc/o9C5ua+pGzUzydi3
	7bGX4F84ldP0xcGC/8MV2oMx5POnVSoWEVYXSk5pWGoQH2AYGKBZXHd0ywuY3A==
X-Gm-Gg: AYBFou16+OUDKU7x5rujpciYJgnlxE/BaeJ+hRSP5RoYWfs5lbwVpI1th5rRL/3iFiA
	CBSs3NgHaM4DdvlcFP1RZ8hAz14r0pp+vTIo1fr3rCPAw1j+PVPJmqA+L/mf6lu7kKRL54Z/B7v
	vaJdifQnEOhGc3ZUn0gNFs2Nx+hgztBcLhOs3d7dnsRW4WzPL4ixESEecBOYFbxThpUYkLVTPUr
	cHYQB0z2FBJcQbrl7UeDk06E42vJVPWzabCwzh+YdHdSipZb7bMSUKKG3xavokNYjkKowUn0tA/
	P8/xpSLfd9h3fUEf4zK5STTM5TQF+LVG8Ljp0sHeK/x3X5j1dBIiaWX22qywmHiESUcRQdnxmcP
	C0BbIC543ycr+sZ1VcdNPaEsoR4x0r/ct4mTv0Vmz+F/9Aby7zLEWCpLt89bimDRIOJVlLUVByH
	oV8+4SpGV7V/6r95m9H7hj+MEk06022w6Vpb7gBiGJs3eq4lls84MB2qpXosb9k/F6CXOaTdSXk
	AM3GAc6IcvQ3D8X1glRhjCGLFYh+XZsfJW33WKYiyaTzbgigC0IQCUTl0A=
X-Received: by 2002:a05:6a20:1609:b0:3d3:ae50:97ce with SMTP id adf61e73a8af0-3dd8c58f633mr642721637.27.1789682260341;
        Thu, 17 Sep 2026 14:57:40 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:39 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 08/14] lpfc: Improve PLOGI retry handling for large SAN configurations
Date: Thu, 17 Sep 2026 15:20:09 -0700
Message-Id: <20260917222015.61053-9-nkirkland2304@gmail.com>
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

In large SAN configurations with link perturbations, rediscovery of target
ports is problematic due to PLOGI retry race conditions.

This patch improves target rediscovery by ensuring PLOGI retries are
serialized in unregistration and retry handler paths.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 92 ++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c | 72 ++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c       | 41 +++++++++++--
 3 files changed, 191 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index cd431c7bd9f0..3e26654a8286 100644
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
@@ -2410,11 +2438,26 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (ret) {
+		lpfc_vlog_msg(vport, KERN_NOTICE,
+			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+			      "0157 PLOGI WQE Put returned %d\n",
+			      ret);
+
+		/* Under heavy vpi counts, the driver's host_index can catch up
+		 * to the hba_index causing a put error. Catch this case and
+		 * put the IO on phba->txq.
+		 */
+		if (ret == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
+			return 0;
+		}
+
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
 	}
 
+	set_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);
 	return 0;
 }
 
@@ -2735,7 +2778,21 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (rc) {
+		lpfc_vlog_msg(vport, KERN_NOTICE,
+			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+			      "0155 PRLI WQE Put returned %d\n",
+			      rc);
+
+		/* Under heavy vpi counts, the driver's host_index can catch up
+		 * to the hba_index causing a put error. Catch this case and
+		 * put the IO on phba->txq.
+		 */
+		if (rc == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
+			return 0;
+		}
+
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -4614,6 +4671,31 @@ lpfc_els_retry_delay_handler(struct lpfc_nodelist *ndlp)
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
index f917a5bcfd02..b0af279480fb 100644
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
@@ -1651,9 +1709,14 @@ lpfc_rcv_plogi_adisc_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 		return ndlp->nlp_state;
 	}
-	ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
-	lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
+
+	/* lpfc_issue_els_plogi rejects a request if the ndlp state
+	 * has advanced beyond PLOGI_ISSUE.  Since the ADISC was aborted
+	 * and the lpfc_rcv_plogi failed, ensure the PLOGI is sent.
+	 */
+	ndlp->nlp_prev_state = ndlp->nlp_state;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
+	lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
 
 	return ndlp->nlp_state;
 }
@@ -2675,7 +2738,10 @@ lpfc_rcv_plogi_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		clear_bit(NLP_NPR_ADISC, &ndlp->nlp_flag);
 		clear_bit(NLP_NPR_2B_DISC, &ndlp->nlp_flag);
 	} else if (!test_bit(NLP_NPR_2B_DISC, &ndlp->nlp_flag)) {
-		/* send PLOGI immediately, move to PLOGI issue state */
+		/* Provided a delay timer isn't running, send a PLOGI.
+		 * Otherwise the nlp_delay_func will expire and send
+		 * a PLOGI to the remote node.
+		 */
 		if (!test_bit(NLP_DELAY_TMO, &ndlp->nlp_flag)) {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b370a64e6b67..dab5411f876d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2915,7 +2915,19 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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
@@ -2966,6 +2978,7 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_vport  *vport = pmb->vport;
 	struct lpfc_nodelist *ndlp;
 	bool unreg_inp;
+	int rc = 0;
 
 	ndlp = pmb->ctx_ndlp;
 	if (pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) {
@@ -3003,15 +3016,31 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 						LOG_MBOX | LOG_SLI | LOG_NODE,
 						"4111 UNREG cmpl deferred "
 						"clr x%x on "
-						"NPort x%x Data: x%x x%px\n",
+						"NPort x%x Data: x%x x%x x%px\n",
 						ndlp->nlp_rpi, ndlp->nlp_DID,
-						ndlp->nlp_defer_did, ndlp);
+						ndlp->nlp_defer_did,
+						ndlp->nlp_last_elscmd,
+						ndlp);
 					ndlp->nlp_defer_did =
 						NLP_EVT_NOTHING_PENDING;
-					lpfc_issue_els_plogi(
-						vport, ndlp->nlp_DID, 0);
-				}
 
+					if (!test_bit(NLP_DELAY_TMO,
+						      &ndlp->nlp_flag) &&
+					    ndlp->nlp_last_elscmd ==
+					    ELS_CMD_PLOGI) {
+						rc = lpfc_issue_els_plogi(vport,
+							      ndlp->nlp_DID, 0);
+						if (rc)
+							goto out;
+
+						ndlp->nlp_prev_state =
+								ndlp->nlp_state;
+						lpfc_nlp_set_state(vport,
+							   ndlp,
+							   NLP_STE_PLOGI_ISSUE);
+					}
+				}
+out:
 				lpfc_nlp_put(ndlp);
 			}
 		}
-- 
2.38.0

