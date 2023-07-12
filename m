Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB08FEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbjGLRyL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjGLRxt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:49 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2742103
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:44 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-55b78bf0423so392230a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184423; x=1691776423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUXpsLDX9EJlpe8C0YqEm3lcWH/cmQ9YrJ4oD++IMOU=;
        b=ARAkMrL1JMEXLku2a+3gSkSK/kypBLbAmOMKwTEhQiYsgpPLlutDlN9b4fx/+X+Ww4
         LLiCC40qjzmka1Au80R7CwqZz1wG06XcMrmcNwHE1+M1P2OoDFrAQawaMdbB960W6Mpk
         GntZ632gN3q7nY4plrzUlHcWx0jL2DvgfYMzqwZ3pCIn/7HNza+NaWMlYBDgsYmg8d/X
         mIkn2599vyL9lQacDDf79tij1kuVaPtcb3Z+NigZQOeURx63NlEh0zSOtVYXq7yoC/xT
         5fWf3VECgh4avG/m1k1uurBN1ZPG0bxbI3HAiTtSy93SUva/ZSkNRgbv7MLuBWQiphFp
         E+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184423; x=1691776423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CUXpsLDX9EJlpe8C0YqEm3lcWH/cmQ9YrJ4oD++IMOU=;
        b=PjJ5T2CIKkztuMBiGP+S1jk+DDRE7Lfib3R6kG/QlkH/Cd5OWeqcUGVX1IkgC6jsc0
         FrZOaAxHBXIBrFEYsDL7+i1flroOaiMhjF9ftksqtmENhhltIcdawlKfJWiT6XVwaukO
         LruXxkrIAnI9IdPeChFfkXYV6wzSK8jnMf74OqgNDxLe3/pBROpoLnxzQeCQsc9V2l5X
         nb+Wi7cqM1PsN7sN2U/T5sKkKxUHaQmZ7Mept0Hts2UU2pO6MUeBsWtVb2vvph8114RK
         lOHLn/EZZWRBW4ip4lwbw60ynmajQC8aRAPsmgW6ZAvBb+a0pUD5oVUx8Glyfh6ygIIq
         Tj4w==
X-Gm-Message-State: ABy/qLaJbPDiOAmul6Tbpjfg24OlttkiadTqmr4RopYWIzcPxE7Heuq0
        ipovUIa/eFo5J1lEsF7P8b/2TZiHObQ=
X-Google-Smtp-Source: APBJJlGiciC7ah+jNkY4izzmJGoifZzFtWQpL0X8YaIPc72yt2f2chlT60qDE6IEXX1HVUvpOK9snA==
X-Received: by 2002:a17:903:32c9:b0:1b8:1591:9f81 with SMTP id i9-20020a17090332c900b001b815919f81mr58498plr.4.1689184423442;
        Wed, 12 Jul 2023 10:53:43 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:43 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/12] lpfc: Make fabric zone discovery more robust when handling unsolicited LOGO
Date:   Wed, 12 Jul 2023 11:05:17 -0700
Message-Id: <20230712180522.112722-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch provides better target rport recovery when a target rport is
running in initiator mode to discover the fabric.  Such a target will issue
a LOGO before switching back to strict target mode and changes are made to
recover the login.  Log messages are also updated accordingly.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c        | 20 +++++++----
 drivers/scsi/lpfc/lpfc_els.c       | 14 ++++----
 drivers/scsi/lpfc/lpfc_nportdisc.c | 53 ++++++++++++++++--------------
 3 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 474834f313a7..baae1f8279e0 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1557,7 +1557,8 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				ndlp->nlp_fc4_type |= NLP_FC4_FCP;
 			if (fc4_data_1 &  LPFC_FC4_TYPE_BITMASK)
 				ndlp->nlp_fc4_type |= NLP_FC4_NVME;
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_DISCOVERY | LOG_NODE,
 					 "3064 Setting ndlp x%px, DID x%06x "
 					 "with FC4 x%08x, Data: x%08x x%08x "
 					 "%d\n",
@@ -1568,14 +1569,21 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			if (ndlp->nlp_state == NLP_STE_REG_LOGIN_ISSUE &&
 			    ndlp->nlp_fc4_type) {
 				ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-
-				lpfc_nlp_set_state(vport, ndlp,
-						   NLP_STE_PRLI_ISSUE);
-				lpfc_issue_els_prli(vport, ndlp, 0);
+				/* This is a fabric topology so if discovery
+				 * started with an unsolicited PLOGI, don't
+				 * send a PRLI.  Targets don't issue PLOGI or
+				 * PRLI when acting as a target. Likely this is
+				 * an initiator function.
+				 */
+				if (!(ndlp->nlp_flag & NLP_RCV_PLOGI)) {
+					lpfc_nlp_set_state(vport, ndlp,
+							   NLP_STE_PRLI_ISSUE);
+					lpfc_issue_els_prli(vport, ndlp, 0);
+				}
 			} else if (!ndlp->nlp_fc4_type) {
 				/* If fc4 type is still unknown, then LOGO */
 				lpfc_printf_vlog(vport, KERN_INFO,
-						 LOG_DISCOVERY,
+						 LOG_DISCOVERY | LOG_NODE,
 						 "6443 Sending LOGO ndlp x%px,"
 						 "DID x%06x with fc4_type: "
 						 "x%08x, state: %d\n",
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index aa48153c3735..f37757449f3c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2376,10 +2376,10 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* PRLI failed */
 		lpfc_printf_vlog(vport, mode, loglevel,
 				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
-				 "data: x%x x%x\n",
+				 "data: x%x x%x x%x\n",
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4, ndlp->nlp_state,
-				 ndlp->fc4_prli_sent);
+				 ndlp->fc4_prli_sent, ndlp->nlp_flag);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (!lpfc_error_lost_link(vport, ulp_status, ulp_word4))
@@ -2390,14 +2390,16 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * mismatch typically caused by an RSCN. Skip any
 		 * processing to allow recovery.
 		 */
-		if (ndlp->nlp_state >= NLP_STE_PLOGI_ISSUE &&
-		    ndlp->nlp_state <= NLP_STE_REG_LOGIN_ISSUE) {
+		if ((ndlp->nlp_state >= NLP_STE_PLOGI_ISSUE &&
+		     ndlp->nlp_state <= NLP_STE_REG_LOGIN_ISSUE) ||
+		    (ndlp->nlp_state == NLP_STE_NPR_NODE &&
+		     ndlp->nlp_flag & NLP_DELAY_TMO)) {
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
-					 "2784 PRLI cmpl: state mismatch "
+					 "2784 PRLI cmpl: Allow Node recovery "
 					 "DID x%06x nstate x%x nflag x%x\n",
 					 ndlp->nlp_DID, ndlp->nlp_state,
 					 ndlp->nlp_flag);
-				goto out;
+			goto out;
 		}
 
 		/*
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 6261560eb512..8f6424487397 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -879,23 +879,34 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			spin_unlock_irq(shost->host_lock);
 			lpfc_retry_pport_discovery(phba);
 		}
-	} else if ((!(ndlp->nlp_type & NLP_FABRIC) &&
-		((ndlp->nlp_type & NLP_FCP_TARGET) ||
-		(ndlp->nlp_type & NLP_NVME_TARGET) ||
-		(vport->fc_flag & FC_PT2PT))) ||
-		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
-		/* Only try to re-login if this is NOT a Fabric Node
-		 * AND the remote NPORT is a FCP/NVME Target or we
-		 * are in pt2pt mode. NLP_STE_ADISC_ISSUE is a special
-		 * case for LOGO as a response to ADISC behavior.
-		 */
-		mod_timer(&ndlp->nlp_delayfunc,
-			  jiffies + msecs_to_jiffies(1000 * 1));
-		spin_lock_irq(&ndlp->lock);
-		ndlp->nlp_flag |= NLP_DELAY_TMO;
-		spin_unlock_irq(&ndlp->lock);
-
-		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
+	} else {
+		lpfc_printf_vlog(vport, KERN_INFO,
+				 LOG_NODE | LOG_ELS | LOG_DISCOVERY,
+				 "3203 LOGO recover nport x%06x state x%x "
+				 "ntype x%x fc_flag x%x\n",
+				 ndlp->nlp_DID, ndlp->nlp_state,
+				 ndlp->nlp_type, vport->fc_flag);
+
+		/* Special cases for rports that recover post LOGO. */
+		if ((!(ndlp->nlp_type == NLP_FABRIC) &&
+		     (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET) ||
+		      vport->fc_flag & FC_PT2PT)) ||
+		    (ndlp->nlp_state >= NLP_STE_ADISC_ISSUE ||
+		     ndlp->nlp_state <= NLP_STE_PRLI_ISSUE)) {
+			mod_timer(&ndlp->nlp_delayfunc,
+				  jiffies + msecs_to_jiffies(1000 * 1));
+			spin_lock_irq(&ndlp->lock);
+			ndlp->nlp_flag |= NLP_DELAY_TMO;
+			spin_unlock_irq(&ndlp->lock);
+			ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_NODE | LOG_ELS | LOG_DISCOVERY,
+					 "3204 Start nlpdelay on DID x%06x "
+					 "nflag x%x lastels x%x ref cnt %u",
+					 ndlp->nlp_DID, ndlp->nlp_flag,
+					 ndlp->nlp_last_elscmd,
+					 kref_read(&ndlp->kref));
+		}
 	}
 out:
 	/* Unregister from backend, could have been skipped due to ADISC */
@@ -1854,7 +1865,6 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc_vport *vport,
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 	LPFC_MBOXQ_t	  *mb;
 	LPFC_MBOXQ_t	  *nextmb;
-	struct lpfc_nodelist *ns_ndlp;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
@@ -1882,13 +1892,6 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc_vport *vport,
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	/* software abort if any GID_FT is outstanding */
-	if (vport->cfg_enable_fc4_type != LPFC_ENABLE_FCP) {
-		ns_ndlp = lpfc_findnode_did(vport, NameServer_DID);
-		if (ns_ndlp)
-			lpfc_els_abort(phba, ns_ndlp);
-	}
-
 	lpfc_rcv_logo(vport, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
-- 
2.38.0

