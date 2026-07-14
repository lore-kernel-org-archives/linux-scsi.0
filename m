Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A413D757EA
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989475; cv=none; b=B4MzgGXL3WUEY8bqiEB1vpZJ0JK1nVh8wgANMLwD8JRnP1gEO5f2xPZ1OAg3isUmp7sBz6pGiyvXnQPEiExZXUEtnIArT/+0hiC0fHyLOOCdx04ZyH7UoKRdIpriqHfGuelh3HWDoStF3KzeN4DFUaSTB4qrYlNQ5ffh00o9E5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989475; c=relaxed/simple;
	bh=iVwlZjaP51yEBy1sqGFaRwCjzTeXD0crTc6cg/bbQm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FSmzsfZFJttf4mwriQO02kg0UVnMsS+0Zk6VYpEwmgPN8tkFdJElwRXvUnoKTGPIze4j1ZMdrtYyZbNYh+7PC/BI6BVzjqbckg2h3H5J/8rpT4qFjiY7nigdkhW/Ys/tISTTjUetgxMZN+9idLcCjGZIoaBX6yVddv5w/LfN820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZsCuojbe; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZsCuojbe"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e622cc874so227913085a.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989472; x=1784594272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=skzatxhWpr2Kr45UUyZ20zV0qn+NJalaJc7pw0azF1I=;
        b=ZsCuojbeVZwOKoW6pbw5dlWIxo2ZHAT2m8xrTgeDGAiMfBK891RygLtHHQsHUShQz8
         GRjf0lylCJ0+Mo1GDVPz/7ceF6+Hzj6Mbx29Cg+gGwz5KtrFDZg2jy+3LqGBwO7/wIWQ
         6LT1ug8J6nLntFguFdbM9bWj0UQBzUzdmwixJZg2Za0EMWbdvoTRXFZLDhBAxBl4DzjI
         HIpPeBWf/ZaEtiKrxnI/9QzVOjQ98c/ERNSrAvvR8crlpEUy8NYjSTEzV3W3tDbfwx3/
         PDz2pw+76H5R1ni5mdNQDwC7vxkBMCD/7oXyGqnYd7djMEgHMCYoCEWS0zNQXl9zHAaK
         JNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989472; x=1784594272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=skzatxhWpr2Kr45UUyZ20zV0qn+NJalaJc7pw0azF1I=;
        b=Odbz3mcQUF2SBBY6ByCvP0r9Y1J0slMmAvPFDiUGzjXxkxvyLvvedVP1LvhSiuv9oh
         ytBmNomX5Pgo9DPEeNyAIg6TgkVacwuYW4Py8bQ2etPTr009nacj4T+FlA3gWRZKHr9v
         9M4DT0G4A1VU6Gw0Y7B9l7k2hTiMeUTb36/oysSs1wVZtZQcYEHtfPdqsr0SESYTsFPi
         3HFkQkscyz3H+VJFYQL1NfTo+5dODxi6d724j8ZYV/JiATwBkjUTqSNJJm9GIW0ZmbBD
         BVCN7KPoYontiabZ74mCS2KeVaE+1rifzM6Fg1M2Qvwz2VuyWlkib8czmd+tL/pPoiyK
         xMog==
X-Gm-Message-State: AOJu0Yz3vIxqe0dlX6VdUqwSI0nZLS8oXeOTD8cA9IXLRdpgY7sgPsZe
	v6HhQPweWR/E57xZqFL2SWbxoC6WpwRlSSdExj/+lt6e6DcxE+YtAv8/xkOXKMkIyzs=
X-Gm-Gg: AfdE7cnXn930oh7xNJJZqnHyEC6/cFE2r7StbFzQ+m6jzLjQmDnGM4d71Bjckd4dlZy
	jwWRJgRCg3NQTEPzzQbob1dqxwDskETC5EV+25vdfJvO+Xe+9f2R/IYq+1tgilKBZXjQ/wpnY5X
	ASkrEQienMXWm9xK7vVqHBS9a+M3gZf3Ei8wEAoeRhlIb7ChF94u8xgKOL8AvpDy1WM4VnCPb1S
	Q92XEsET8LCcQqpFFfHA+MTbf66by+M1SIoxqojQYOka/PSrznmftDdYc3RMvY96AA3KMWNgr4M
	csViEpq9fBKCJB6LT9/vAIwd1rSSn3tb9p8/LDRFuYPF/SzLUgMGW6VzjmaSEhZa6Hm96jeRNUy
	Ki9mNmZm4G4CGoUW9mXks79FgDDDnltmG4fw4RhoLm0KKu3XeIi8p8dNzB2nLw2xTv1aLU4yQLP
	hwYvyQEMT9Kzia2SIPub0vmRrT6oA9qWE8bJ7c5Tu6M+R+oy8MEU05BRNCSG7tsVJsd/st1PMOP
	FKYvY5vC4CFICznURPDmy0h4EkaJbv1
X-Received: by 2002:a05:620a:870d:10b0:92a:e2a7:d55b with SMTP id af79cd13be357-93083d41d04mr102784585a.47.1783989471528;
        Mon, 13 Jul 2026 17:37:51 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:51 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 08/14] lpfc: Improve PLOGI retry handling for large SAN configurations
Date: Mon, 13 Jul 2026 18:18:06 -0700
Message-Id: <20260714011812.106753-9-justintee8345@gmail.com>
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
index 6720fd5ec523..16b10377a095 100644
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
index 10db07771ccf..54bc5d8984fc 100644
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

