Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553C3C3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 208AB20820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLZaElLO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfIVD7V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:21 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39148 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfIVD7V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:21 -0400
Received: by mail-ot1-f66.google.com with SMTP id s22so9403769otr.6
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qGZM39KeQFMuPoTx2Bev/RkYQzHWgTjJYXRJdcjOY/M=;
        b=NLZaElLOe6hkBAQHQQL8ry3Wm/eEZHVp84sChKyDJRKgXz31g3E+oeRehWhPwJHxYO
         20UMnfUenxlwwOkwGj1LvG3hQO9u4d3AGVHdDMvmXKn+ClHKeDzPrwu3ZbGAQU53TBTN
         GLtTKjloet5wnB1bE4onbZyK5bEEdSoSAloz09ykek1CfY0sQRMp034J1+M+h3fquPcP
         m993JAqaDrY6zAKABbhgNLngPbWwlvfVvsRpyt9W7lvofzO/x0/d6XBJ1usaNVi7+KEt
         jN3LPFoUaHfbiPhC+bDisGetM1k6wyJT5QUnSia8AhsY4knp7njCtkRE0oDWnKEzpHax
         jTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qGZM39KeQFMuPoTx2Bev/RkYQzHWgTjJYXRJdcjOY/M=;
        b=Fg5I+JnOpHSYcep0r7DbxVe2taHFJ9ZKj+KJKVkznqhkt0cm2JyN6tCReuNXZYDSwb
         TybqT7QK3gnZ+VUzSdtSQVADxf5ryUbYcRF0lfcgSqDCOOTMpDqDz+6Jjcb9UMqX7Izt
         GQl+YIudNCQCZ6kGN42VjI6fpHP2pQ23WSb+2J/bJD0Ksn5OZZBApnwB/SIRSzkRPxx4
         qgbF1sI2DRRYk3kFxhLXjvEj9q1tue9CfS3qbqOIiIEnnbCRl2Ffo91zLKfnQz9A6zre
         u3QI6m36XEVd8A5IJpi/Zq0qyAhr7VKbrHPIfT013dgdY+cmOtlcDCsvgiReyq6ZlgeN
         xPTw==
X-Gm-Message-State: APjAAAVTB/8kGNvKCo0AjHzf+M/X7XQQKRwU7AbiRE6fbGAAOg1kcqi8
        MwIZz4wUN2TQ0nS5DKl3rFLXd0NK
X-Google-Smtp-Source: APXvYqwQ0TrRzEPk7qn4ZOPP0+xEYOcHdZ3cL4fxLN4mXk44Mvl/s9rIQJp65YuVLI9BQGCOZHspRw==
X-Received: by 2002:a9d:4919:: with SMTP id e25mr18330663otf.267.1569124759911;
        Sat, 21 Sep 2019 20:59:19 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:19 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/20] lpfc: Fix rpi release when deleting vport
Date:   Sat, 21 Sep 2019 20:58:51 -0700
Message-Id: <20190922035906.10977-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A prior use-after-free mailbox fix solved it's problem by
null'ing a ndlp pointer.  However, further testing has shown
that this change causes a later state change to occasionally
be skipped, which results in a reference count never being
decremented thus the rpi is never released, which causes a
vport delete to never succeed.

Revise the fix in the prior patch to no longer null the
ndlp. Instead the RELEASE_RPI flag is set which will
drive the release of the rpi.

Given the new code was added at a deep indentation level,
refactor the code block using a new routine that avoids
the indentation issues.

Fixes: 	9b1640686470 ("scsi: lpfc: Fix use-after-free mailbox cmd completion")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 88 +++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli.c     |  2 +
 2 files changed, 61 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 749286acdc17..9df6f0cabab0 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4841,6 +4841,44 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /*
+ * Sets the mailbox completion handler to be used for the
+ * unreg_rpi command. The handler varies based on the state of
+ * the port and what will be happening to the rpi next.
+ */
+static void
+lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
+	struct lpfc_nodelist *ndlp, LPFC_MBOXQ_t *mbox)
+{
+	unsigned long iflags;
+
+	if (ndlp->nlp_flag & NLP_ISSUE_LOGO) {
+		mbox->ctx_ndlp = ndlp;
+		mbox->mbox_cmpl = lpfc_nlp_logo_unreg;
+
+	} else if (phba->sli_rev == LPFC_SLI_REV4 &&
+		   (!(vport->load_flag & FC_UNLOADING)) &&
+		    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
+				      LPFC_SLI_INTF_IF_TYPE_2) &&
+		    (kref_read(&ndlp->kref) > 0)) {
+		mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
+		mbox->mbox_cmpl = lpfc_sli4_unreg_rpi_cmpl_clr;
+	} else {
+		if (vport->load_flag & FC_UNLOADING) {
+			if (phba->sli_rev == LPFC_SLI_REV4) {
+				spin_lock_irqsave(&vport->phba->ndlp_lock,
+						  iflags);
+				ndlp->nlp_flag |= NLP_RELEASE_RPI;
+				spin_unlock_irqrestore(&vport->phba->ndlp_lock,
+						       iflags);
+			}
+			lpfc_nlp_get(ndlp);
+		}
+		mbox->ctx_ndlp = ndlp;
+		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	}
+}
+
+/*
  * Free rpi associated with LPFC_NODELIST entry.
  * This routine is called from lpfc_freenode(), when we are removing
  * a LPFC_NODELIST entry. It is also called if the driver initiates a
@@ -4890,33 +4928,12 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 			lpfc_unreg_login(phba, vport->vpi, rpi, mbox);
 			mbox->vport = vport;
-			if (ndlp->nlp_flag & NLP_ISSUE_LOGO) {
-				mbox->ctx_ndlp = ndlp;
-				mbox->mbox_cmpl = lpfc_nlp_logo_unreg;
-			} else {
-				if (phba->sli_rev == LPFC_SLI_REV4 &&
-				    (!(vport->load_flag & FC_UNLOADING)) &&
-				    (bf_get(lpfc_sli_intf_if_type,
-				     &phba->sli4_hba.sli_intf) >=
-				      LPFC_SLI_INTF_IF_TYPE_2) &&
-				    (kref_read(&ndlp->kref) > 0)) {
-					mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
-					mbox->mbox_cmpl =
-						lpfc_sli4_unreg_rpi_cmpl_clr;
-					/*
-					 * accept PLOGIs after unreg_rpi_cmpl
-					 */
-					acc_plogi = 0;
-				} else if (vport->load_flag & FC_UNLOADING) {
-					mbox->ctx_ndlp = NULL;
-					mbox->mbox_cmpl =
-						lpfc_sli_def_mbox_cmpl;
-				} else {
-					mbox->ctx_ndlp = ndlp;
-					mbox->mbox_cmpl =
-						lpfc_sli_def_mbox_cmpl;
-				}
-			}
+			lpfc_set_unreg_login_mbx_cmpl(phba, vport, ndlp, mbox);
+			if (mbox->mbox_cmpl == lpfc_sli4_unreg_rpi_cmpl_clr)
+				/*
+				 * accept PLOGIs after unreg_rpi_cmpl
+				 */
+				acc_plogi = 0;
 			if (((ndlp->nlp_DID & Fabric_DID_MASK) !=
 			    Fabric_DID_MASK) &&
 			    (!(vport->fc_flag & FC_OFFLINE_MODE)))
@@ -5057,6 +5074,7 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct lpfc_hba  *phba = vport->phba;
 	LPFC_MBOXQ_t *mb, *nextmb;
 	struct lpfc_dmabuf *mp;
+	unsigned long iflags;
 
 	/* Cleanup node for NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
@@ -5138,8 +5156,20 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	lpfc_cleanup_vports_rrqs(vport, ndlp);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		ndlp->nlp_flag |= NLP_RELEASE_RPI;
-	lpfc_unreg_rpi(vport, ndlp);
-
+	if (!lpfc_unreg_rpi(vport, ndlp)) {
+		/* Clean up unregistered and non freed rpis */
+		if ((ndlp->nlp_flag & NLP_RELEASE_RPI) &&
+		    !(ndlp->nlp_rpi == LPFC_RPI_ALLOC_ERROR)) {
+			lpfc_sli4_free_rpi(vport->phba,
+					   ndlp->nlp_rpi);
+			spin_lock_irqsave(&vport->phba->ndlp_lock,
+					  iflags);
+			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+			spin_unlock_irqrestore(&vport->phba->ndlp_lock,
+					       iflags);
+		}
+	}
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 827406f58b1e..f764012ba0a6 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2526,6 +2526,8 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			} else {
 				__lpfc_sli_rpi_release(vport, ndlp);
 			}
+			if (vport->load_flag & FC_UNLOADING)
+				lpfc_nlp_put(ndlp);
 			pmb->ctx_ndlp = NULL;
 		}
 	}
-- 
2.13.7

