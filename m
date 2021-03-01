Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7021C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F53765248
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbhCARZt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237680AbhCARVU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:21:20 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7101DC06121D
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:34 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z7so10316182plk.7
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scfs9/rsoYxf1j6+bqX9MDWyWTTtwOf4Li9pZ5m7024=;
        b=aH0UO8dpXASFrqpzumuvTxzUyp9nzpnjeOg4FZZU9XW6Kt+iiw5X/SFLEDhun66Xy3
         HOlduSH7LBVfMbgjbd4KM1uP+tB72BvfDPZwEJpQSw+0U7SDjrsekx1NwY2N5b6VY7Xp
         0SiH4q2S/NYJXRToo5jglvCPza4GzK2NhuQrqkLNhnX6cbUm+OvBON+jfE7ED5GCXYbs
         1tsLkBrSIvzl9+CQx/+CCIOQFqrPIbLAKJxkDot/jwWkUBFxQc7zcrqUAE/182Dj6Gl/
         ni9t6E5f+woKh/4T+VDYSorX9EiA1hhLcxOiMC2N2Gk5YoMQf0O/nJ/Hevf+u8Tj8oD4
         kKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scfs9/rsoYxf1j6+bqX9MDWyWTTtwOf4Li9pZ5m7024=;
        b=WlztzoyIHvul70PRDY9Uf18Al9/UuYU2+QOCRBe3vM4WP4XsZvlIqpSpLmiQSPG++w
         uXwj8r5iOYKvmQzzAoEkyczn+caAk/s/IfOUqRXeGfr3/1gNCf4KEDJMTRlFjhPPuq/d
         76Qt6MmzYYvISq5qMOK2E4CUIoIFgHAYbrmYdkCC9Kn1b+xV3PrJY1CYwaCAnvYNF2Yu
         RTd5WmVD71DOUGA8/C+yNxdL4YAWDcPZ7+Bk7VTFZJMxxMS3W5APegFbu/ZNxLEyO5Q/
         PJZ9rHW4cmySbBNtXl4gjnsw8csCpQy/Q/Y5957+HW+p/hiROgdkZT2ppH3X+AovdCSf
         0Emw==
X-Gm-Message-State: AOAM530Ez4/hEyIUW4rLNSlbGv/hLNsnYNkvEDqliUQKoGmJzt2SPtpb
        M2nO/fiZh2r8KPCAh7hbiRnccp9SYsI=
X-Google-Smtp-Source: ABdhPJy764tsatdfIIz8KJ9vgbamx2q6OQID7d6/qY69kWtcrUGNxHCCMHw6r8CWKZuQjXHURkf8TA==
X-Received: by 2002:a17:902:9a49:b029:df:fab8:384 with SMTP id x9-20020a1709029a49b02900dffab80384mr16757673plv.37.1614619113660;
        Mon, 01 Mar 2021 09:18:33 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:33 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 10/22] lpfc: Fix use after free in lpfc_els_free_iocb
Date:   Mon,  1 Mar 2021 09:18:09 -0800
Message-Id: <20210301171821.3427-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are several code paths where the following sequence occurs:
- An ndlp pointer is assigned to an iocb via a nlp_get()
- An attempt is made to issue the iocb, but it fails
- The failure case does a put on the ndlp then calls lpfc_els_free_iocb()

The put may free the ndlp structure, but the els_free_iocb may reference
the now-stale ndlp pointer and cause a crash.

Fix by ensuring that the lpfc_els_free_iocb() occurs before the
lpfc_nlp_put().

While fixing, refactored the code to better ensure this calling sequence.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 348 ++++++++++++++++++-----------------
 1 file changed, 177 insertions(+), 171 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index de67ba76374a..08de3496d065 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1342,12 +1342,17 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		phba->sli3_options, 0, 0);
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto out;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	rc = lpfc_issue_fabric_iocb(phba, elsiocb);
-	if (rc == IOCB_ERROR)
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
 	phba->hba_flag |= HBA_FLOGI_ISSUED;
 
@@ -1377,11 +1382,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		vport->fc_myDID = did;
 	}
 
-	if (!rc)
-		return 0;
- out:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
+	return 0;
 }
 
 /**
@@ -2152,19 +2153,19 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 			      "Issue PLOGI:     did:x%x refcnt %d",
 			      did, kref_read(&ndlp->kref), 0);
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto io_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (ret) {
+		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		goto io_err;
+		return 1;
 	}
-	return 0;
 
- io_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
+	return 0;
 }
 
 /**
@@ -2458,12 +2459,17 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			      "Issue PRLI:  did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto io_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		goto err;
+	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto node_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		goto err;
+	}
 
 
 	/* The driver supports 2 FC4 types.  Make sure
@@ -2475,13 +2481,10 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	else
 		return 0;
 
- node_err:
-	lpfc_nlp_put(ndlp);
- io_err:
+err:
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_PRLI_SND;
 	spin_unlock_irq(&ndlp->lock);
-	lpfc_els_free_iocb(phba, elsiocb);
 	return 1;
 }
 
@@ -2765,24 +2768,27 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_flag |= NLP_ADISC_SND;
 	spin_unlock_irq(&ndlp->lock);
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		goto err;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue ADISC:   did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		goto err;
+	}
+
 	return 0;
 
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
+err:
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_ADISC_SND;
 	spin_unlock_irq(&ndlp->lock);
-	lpfc_els_free_iocb(phba, elsiocb);
 	return 1;
 }
 
@@ -2983,15 +2989,20 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_flag &= ~NLP_ISSUE_LOGO;
 	spin_unlock_irq(&ndlp->lock);
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		goto err;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue LOGO:      did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		goto err;
+	}
 
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_prev_state = ndlp->nlp_state;
@@ -2999,13 +3010,10 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_LOGO_ISSUE);
 	return 0;
 
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
+err:
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
 	spin_unlock_irq(&ndlp->lock);
-	lpfc_els_free_iocb(phba, elsiocb);
 	return 1;
 }
 
@@ -3221,25 +3229,24 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 	phba->fc_stat.elsXmitSCR++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue SCR:     did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
 	/* Keep the ndlp just in case RDF is being sent */
 	return 0;
-
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
 }
 
 /**
@@ -3321,16 +3328,21 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 	phba->fc_stat.elsXmitRSCN++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue RSCN:       did:x%x",
 			      ndlp->nlp_DID, 0, 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
 	/* This will cause the callback-function lpfc_cmpl_els_cmd to
 	 * trigger the release of node.
@@ -3338,11 +3350,6 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 	if (!(vport->fc_flag & FC_PT2PT))
 		lpfc_nlp_put(ndlp);
 	return 0;
-io_err:
-	lpfc_nlp_put(ndlp);
-node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
 }
 
 /**
@@ -3437,8 +3444,8 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 		 * lpfc_els_free_iocb routine to trigger the release of
 		 * the node.
 		 */
-		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
 		return 1;
 	}
 	/* This will cause the callback-function lpfc_cmpl_els_cmd to
@@ -3518,23 +3525,22 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return -EIO;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue RDF:     did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return -EIO;
+	}
 	return 0;
-
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return -EIO;
 }
 
 /**
@@ -4821,12 +4827,17 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
 	/* Xmit ELS ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -4837,12 +4848,6 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi, vport->fc_flag);
 	return 0;
-
-io_err:
-	lpfc_nlp_put(ndlp);
-node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
 }
 
 /**
@@ -4914,20 +4919,19 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 	phba->fc_stat.elsXmitLSRJT++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
 	return 0;
-
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
 }
 
 /**
@@ -4997,12 +5001,17 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
 	/* Xmit ELS ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -5013,12 +5022,6 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi, vport->fc_flag);
 	return 0;
-
-io_err:
-	lpfc_nlp_put(ndlp);
-node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
 }
 
 /**
@@ -5172,19 +5175,19 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 =  lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
-	return 0;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
+	return 0;
 }
 
 /**
@@ -5279,20 +5282,19 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
 	return 0;
-
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
 }
 
 /**
@@ -5394,19 +5396,19 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 =  lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
-	return 0;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
+	return 0;
 }
 
 /**
@@ -6050,8 +6052,8 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
-		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
 	}
 
 	goto free_rdp_context;
@@ -6082,8 +6084,8 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
-		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
 	}
 
 free_rdp_context:
@@ -6295,16 +6297,16 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	phba->fc_stat.elsXmitACC++;
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
-
-	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (!rc)
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
 		goto out;
+	}
 
-	lpfc_nlp_put(ndlp);
- node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+	}
  out:
 	kfree(lcb_context);
 	return;
@@ -6340,8 +6342,8 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
-		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
 	}
 free_lcb_context:
 	kfree(lcb_context);
@@ -7407,18 +7409,17 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return;
+	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+	}
 	return;
-
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
 }
 
 /**
@@ -7567,8 +7568,8 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
-		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
 	}
 	return 0;
 
@@ -7645,8 +7646,8 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	return 0;
 
  io_err:
-	lpfc_nlp_put(ndlp);
 	lpfc_els_free_iocb(phba, elsiocb);
+	lpfc_nlp_put(ndlp);
 	return 1;
 }
 
@@ -7743,19 +7744,19 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
-	return 0;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
 
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
-	lpfc_els_free_iocb(phba, elsiocb);
-	return 1;
+	return 0;
 }
 
 /**
@@ -9661,11 +9662,14 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		did, 0, 0);
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
 		goto err_out;
+	}
 
 	rc = lpfc_issue_fabric_iocb(phba, elsiocb);
 	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		goto err_out;
 	}
@@ -9674,7 +9678,6 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	return 0;
 
  err_out:
-	lpfc_els_free_iocb(phba, elsiocb);
 	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			 "0256 Issue FDISC: Cannot send IOCB\n");
@@ -9782,20 +9785,23 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	spin_unlock_irq(&ndlp->lock);
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1)
-		goto node_err;
+	if (!elsiocb->context1) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		goto err;
+	}
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
-		goto io_err;
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		lpfc_nlp_put(ndlp);
+		goto err;
+	}
 	return 0;
 
- io_err:
-	lpfc_nlp_put(ndlp);
- node_err:
+err:
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
 	spin_unlock_irq(&ndlp->lock);
-	lpfc_els_free_iocb(phba, elsiocb);
 	return 1;
 }
 
-- 
2.26.2

