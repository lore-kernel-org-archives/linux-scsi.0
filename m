Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7860EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiKPBLH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiKPBLE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:11:04 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BB231FB9
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:11:03 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id g10so10752226qkl.6
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1jMpunGh8qvSmxj3MMVrBO6QBce8gOCg1IYF8CofhI=;
        b=irN8HBcxtvB1JX6yPvaOhfW+ShtTtHJqE4BZUbaLDf/6u6wtiJDxfuMth2KVez5O3x
         xh2Hfi0L/8ZWDBXRYWikXWTMUqzwLIi1ogzqz1VZaZQE1vor9bdEU9QQ9GgHv6sYad+H
         vRlU6NA6OKzsnWW8Zm2gLiQfFyjDSHwK4F/Cm8IMJLJmpA4Tyze49VNWTEIRI/jUoQ6H
         0fpodPoRkq9dCdY8AIHCD4TxPxyb4z+dFCW86Nc7QxCVqfUATEmYqWzirrH0mcNZF2dg
         8eYvVmlBrfc+9yzX4AVlUCvIZ+8ijLYOpR2ee3MB5anTtMm4HS/3MqgKhrELygDvGIvF
         q9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/1jMpunGh8qvSmxj3MMVrBO6QBce8gOCg1IYF8CofhI=;
        b=S0V0DTynq3kpNsxAO4uwJpJHIvkndoYFO3jT+/CXP/USFQPdo6rdnSqX+xSoNOnbmz
         PJpbdHd4zxkl7zvqHMFmyaS3grpbm8APksR3kM6JrR3fKO8wtsBHPLa4+zk7ouig51Y7
         u0lFryLVxcL8plOqZVio8ww4zEXbzXbQQAtMXP8NkiGn267GnUaq2XiGrqv/hvsApK4A
         /QeBJ443qI+qMnSE5tXSWLY0Za85sbLucjENHAiKwod9GzKoqyuOVG1G62bTxuS9JDZj
         Yo5aX+1BTzbjO7naXuXOCv4Eb+ZK93oViI3ke2onB9oVIKZZAwCUde50IvKMqZDdck3H
         ziPw==
X-Gm-Message-State: ANoB5plZ/XauSYg9KfCVpN5G1q5L+w0gs122BI5++X1YLID7c4LheJEr
        Fv4Xjpusj/UmVEB7inULUHymOzSAO1M=
X-Google-Smtp-Source: AA0mqf6qzmxaXU361n9IfQ0vfLhgvrEXsKMcDXiEF4vb/VWlXG96ct3pjfzFOgoBilTwXwYSrVv7Mg==
X-Received: by 2002:a05:620a:470a:b0:6ec:51cd:c376 with SMTP id bs10-20020a05620a470a00b006ec51cdc376mr17437409qkb.300.1668561062108;
        Tue, 15 Nov 2022 17:11:02 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8128c000000b00399b73d06f0sm7901966qti.38.2022.11.15.17.11.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 17:11:01 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Dietmar Hahn <dietmar.hahn@fujitsu.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 4/6] lpfc: Fix crash involving race between FLOGI timeout and devloss handler
Date:   Tue, 15 Nov 2022 17:19:19 -0800
Message-Id: <20221116011921.105995-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221116011921.105995-1-justintee8345@gmail.com>
References: <20221116011921.105995-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a FLOGI completes with a sequence timeout error, a freed kref ptr
dereference crash can occur due to a timing race involving ndlp referencing
in lpfc_dev_loss_tmo_callbk.

Fix by ensuring the driver accounts for an outstanding FLOGI when dev_loss
is active.  Also, don't remove the HBA_FLOGI_OUTSTANDING flag when the
FLOGI is retried to allow the driver to handle the reference counts
correctly in lpfc_dev_loss_tmo_handler.

Reported-by: Dietmar Hahn <dietmar.hahn@fujitsu.com>
Tested-by: Dietmar Hahn <dietmar.hahn@fujitsu.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 36 +++++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_hbadisc.c | 36 +++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2b03210264bb..1b541d2cf827 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -952,6 +952,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	uint16_t fcf_index;
 	int rc;
 	u32 ulp_status, ulp_word4, tmo;
+	bool flogi_in_retry = false;
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
@@ -1022,8 +1023,23 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 phba->hba_flag, phba->fcf.fcf_flag);
 
 		/* Check for retry */
-		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
+		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
+			/* Address a timing race with dev_loss.  If dev_loss
+			 * is active on this FPort node, put the initial ref
+			 * count back to stop premature node release actions.
+			 */
+			lpfc_check_nlp_post_devloss(vport, ndlp);
+			flogi_in_retry = true;
 			goto out;
+		}
+
+		/* The FLOGI will not be retried.  If the FPort node is not
+		 * registered with the SCSI transport, remove the initial
+		 * reference to trigger node release.
+		 */
+		if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+			lpfc_nlp_put(ndlp);
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_TRACE_EVENT,
 				 "0150 FLOGI failure Status:x%x/x%x "
@@ -1086,7 +1102,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	spin_unlock_irq(shost->host_lock);
 
 	/*
-	 * The FLogI succeeded.  Sync the data for the CPU before
+	 * The FLOGI succeeded.  Sync the data for the CPU before
 	 * accessing it.
 	 */
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
@@ -1108,6 +1124,12 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
 						  LPFC_VMID_TYPE_PRIO);
 
+	/*
+	 * Address a timing race with dev_loss.  If dev_loss is active on
+	 * this FPort node, put the initial ref count back to stop premature
+	 * node release actions.
+	 */
+	lpfc_check_nlp_post_devloss(vport, ndlp);
 	if (vport->port_state == LPFC_FLOGI) {
 		/*
 		 * If Common Service Parameters indicate Nport
@@ -1198,7 +1220,9 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_issue_clear_la(phba, vport);
 	}
 out:
-	phba->hba_flag &= ~HBA_FLOGI_OUTSTANDING;
+	if (!flogi_in_retry)
+		phba->hba_flag &= ~HBA_FLOGI_OUTSTANDING;
+
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
 }
@@ -1365,15 +1389,17 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return 1;
 	}
 
+	/* Avoid race with FLOGI completion and hba_flags. */
+	phba->hba_flag |= (HBA_FLOGI_ISSUED | HBA_FLOGI_OUTSTANDING);
+
 	rc = lpfc_issue_fabric_iocb(phba, elsiocb);
 	if (rc == IOCB_ERROR) {
+		phba->hba_flag &= ~(HBA_FLOGI_ISSUED | HBA_FLOGI_OUTSTANDING);
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
 	}
 
-	phba->hba_flag |= (HBA_FLOGI_ISSUED | HBA_FLOGI_OUTSTANDING);
-
 	/* Clear external loopback plug detected flag */
 	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index d38ebd7281b9..80375d73b732 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -426,10 +426,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 	name = (uint8_t *)&ndlp->nlp_portname;
 	phba = vport->phba;
 
-	spin_lock_irqsave(&ndlp->lock, iflags);
-	ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
-	spin_unlock_irqrestore(&ndlp->lock, iflags);
-
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		fcf_inuse = lpfc_fcf_inuse(phba);
 
@@ -451,22 +447,36 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 				 *name, *(name+1), *(name+2), *(name+3),
 				 *(name+4), *(name+5), *(name+6), *(name+7),
 				 ndlp->nlp_DID);
+
+		spin_lock_irqsave(&ndlp->lock, iflags);
+		ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
 		return fcf_inuse;
 	}
 
 	/* Fabric nodes are done. */
 	if (ndlp->nlp_type & NLP_FABRIC) {
 		spin_lock_irqsave(&ndlp->lock, iflags);
-		/* In massive vport configuration settings, it's possible
-		 * dev_loss_tmo fired during node recovery.  So, check if
-		 * fabric nodes are in discovery states outstanding.
+
+		/* In massive vport configuration settings or when the FLOGI
+		 * completes with a sequence timeout, it's possible
+		 * dev_loss_tmo fired during node recovery.  The driver has to
+		 * account for this race to allow for recovery and keep
+		 * the reference counting correct.
 		 */
 		switch (ndlp->nlp_DID) {
 		case Fabric_DID:
 			fc_vport = vport->fc_vport;
-			if (fc_vport &&
-			    fc_vport->vport_state == FC_VPORT_INITIALIZING)
-				recovering = true;
+			if (fc_vport) {
+				/* NPIV path. */
+				if (fc_vport->vport_state ==
+				    FC_VPORT_INITIALIZING)
+					recovering = true;
+			} else {
+				/* Physical port path. */
+				if (phba->hba_flag & HBA_FLOGI_OUTSTANDING)
+					recovering = true;
+			}
 			break;
 		case Fabric_Cntl_DID:
 			if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
@@ -514,6 +524,9 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 			return fcf_inuse;
 		}
 
+		spin_lock_irqsave(&ndlp->lock, iflags);
+		ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
 		lpfc_nlp_put(ndlp);
 		return fcf_inuse;
 	}
@@ -552,6 +565,9 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 		return fcf_inuse;
 	}
 
+	spin_lock_irqsave(&ndlp->lock, iflags);
+	ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
+	spin_unlock_irqrestore(&ndlp->lock, iflags);
 	if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 
-- 
2.38.0

