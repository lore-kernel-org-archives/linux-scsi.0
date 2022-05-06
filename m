Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD401C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388841AbiEFD7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388856AbiEFD7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:12 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1712655C
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c11so6225785plg.13
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IKC5VYOSrma1br6bpss3+JGoTu8uDh+cfluIvfZaNnA=;
        b=D6SvQiMJX5c5qbuc5TuFhoMVYkE/FxcIAAagoX5eH+0aP1Q5nzMIiwDhw2DC+QNVwr
         ZZ/GL82nIQ5aisfnGrgH82iZQiH8k43GEBlXG42po/bLsLGefNnQlnZ3ICvj5xfFOiAW
         ew75qSfMPh9CDR/xoNKhLp/0tkYePef74b6WZkUYMwho57/2vVwllIZNCQur8zAQumhT
         awvwCqv6RCCIB2VPbVB6BlE3Eg88gsr/NjzC3b8hneh56zAeGQ4d74GudByUeYtpnUYG
         G12rJBeI9A9XLSMsrgMX0029/jZ7oZYTCRo83kW9yrF4wGvOG9HN9Zfg4vw3jO7mGUAO
         /URg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IKC5VYOSrma1br6bpss3+JGoTu8uDh+cfluIvfZaNnA=;
        b=mCK/IYpydAxg/z0sk9p61fNzvrwsvmoVD2JZmaw8R6iRuG1aJUXAmsD8P5QAY7lZQL
         U331Qh7QR5NkR2ISrfaqaBZJ+Z7lsTdVE4+NWOzbTz6twQm8PGl0dBGQR+46CNTH2ZFg
         N2oPoeJ8yVD0aVc0safjce75WstDIVL7HZMuFMf80qEWhTdvxq7o75KZl0g/zK/SFyhx
         SPoJXVXBM2s0e9ZNcUSytFTB/E3MpVaPo9e+M9zc8IhJGO/oDODy25t+wtjTEgzpwsP7
         6oWrC15YcvH8TjX+oIJJwYPosPMcyzZ5jmj4K3neFS4KO/ARNA5k7CERZGEZQC6tnZg8
         37zw==
X-Gm-Message-State: AOAM532umOKc1MX6/9mC22iBWczXobNFO7n6PX65Hbngu+yyGjwr0sP1
        Ra0YUIa/TE1JKlyebZTduBrkQq6Q93M=
X-Google-Smtp-Source: ABdhPJye546LaYccBI0wD2etMkUWVZMA9XfyGfmUGnlZgp0axvUZ0bRjC+34Rqj2zUWPW+YUx8qU9A==
X-Received: by 2002:a17:90b:224f:b0:1dc:76e9:e963 with SMTP id hk15-20020a17090b224f00b001dc76e9e963mr1916664pjb.16.1651809329221;
        Thu, 05 May 2022 20:55:29 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:28 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 02/12] lpfc: Fill in missing ndlp kref puts in error paths
Date:   Thu,  5 May 2022 20:55:09 -0700
Message-Id: <20220506035519.50908-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Code review, following every lpfc_nlp_get call vs calls during error
handling, discovered cases of missing put calls.

Correct by adding ndlp kref puts in the respective error paths.

Also added comments to several of the error paths to record
relationships to reference counts.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 11 +++++------
 drivers/scsi/lpfc/lpfc_nportdisc.c | 15 +++++++++++++--
 drivers/scsi/lpfc/lpfc_nvme.c      |  5 +++++
 drivers/scsi/lpfc/lpfc_sli.c       |  6 +++++-
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 527f2c148e04..ace812ce857d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8725,19 +8725,18 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rrq;
 
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
-	if (!elsiocb->ndlp) {
-		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
-	}
+	if (!elsiocb->ndlp)
+		goto io_err;
 
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (ret == IOCB_ERROR)
+	if (ret == IOCB_ERROR) {
+		lpfc_nlp_put(ndlp);
 		goto io_err;
+	}
 	return 0;
 
  io_err:
 	lpfc_els_free_iocb(phba, elsiocb);
-	lpfc_nlp_put(ndlp);
 	return 1;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 5e4822bf54f4..639f86635127 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -513,6 +513,10 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			lpfc_config_link(phba, link_mbox);
 			link_mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 			link_mbox->vport = vport;
+
+			/* The default completion handling for CONFIG_LINK
+			 * does not require the ndlp so no reference is needed.
+			 */
 			link_mbox->ctx_ndlp = ndlp;
 
 			rc = lpfc_sli_issue_mbox(phba, link_mbox, MBX_NOWAIT);
@@ -633,6 +637,9 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	 */
 	login_mbox->mbox_cmpl = lpfc_defer_plogi_acc;
 	login_mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
+	if (!login_mbox->ctx_ndlp)
+		goto out;
+
 	login_mbox->context3 = save_iocb; /* For PLOGI ACC */
 
 	spin_lock_irq(&ndlp->lock);
@@ -641,8 +648,10 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	/* Start the ball rolling by issuing REG_LOGIN here */
 	rc = lpfc_sli_issue_mbox(phba, login_mbox, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED)
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_nlp_put(ndlp);
 		goto out;
+	}
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_REG_LOGIN_ISSUE);
 
 	return 1;
@@ -1099,8 +1108,10 @@ lpfc_release_rpi(struct lpfc_hba *phba, struct lpfc_vport *vport,
 				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag);
 
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED)
+		if (rc == MBX_NOT_FINISHED) {
+			lpfc_nlp_put(ndlp);
 			mempool_free(pmb, phba->mbox_mem_pool);
+		}
 	}
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 376f6c0265c0..3aebd01e07fd 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2357,6 +2357,11 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		rpinfo.dev_loss_tmo = vport->cfg_devloss_tmo;
 
 	spin_lock_irq(&ndlp->lock);
+
+	/* If an oldrport exists, so does the ndlp reference.  If not
+	 * a new reference is needed because either the node has never
+	 * been registered or it's been unregistered and getting deleted.
+	 */
 	oldrport = lpfc_ndlp_get_nrport(ndlp);
 	if (oldrport) {
 		prev_ndlp = oldrport->ndlp;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d2900ac8de9d..fe4eb36426df 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20684,8 +20684,12 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
 			act_mbx_ndlp = (struct lpfc_nodelist *)mb->ctx_ndlp;
-			/* Put reference count for delayed processing */
+
+			/* This reference is local to this routine.  The
+			 * reference is removed at routine exit.
+			 */
 			act_mbx_ndlp = lpfc_nlp_get(act_mbx_ndlp);
+
 			/* Unregister the RPI when mailbox complete */
 			mb->mbox_flag |= LPFC_MBX_IMED_UNREG;
 		}
-- 
2.26.2

