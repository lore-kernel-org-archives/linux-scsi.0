Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AF6C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED63264E4B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhBKXq1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhBKXqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:15 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3C5C061794
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:58 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e12so4199895pls.4
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=COdVxe1AeMbdTSnEuZdxsRHZ7H+JQxgPDN83XBgpqFk=;
        b=FmaGV8wCMmB5IEK7btIm9q5K9sdqWRSAmkez1XU+6/7wzYD3HZ5gEVpTE1XwCulSIo
         IiucvUzgrnZHNrVq+XTU29AFnD5KixovykBIhvcJyzXSj8cgYx9SieaxDgtGdv4OW74u
         SuxKBNcUGrrWwERdbJL2oe1mqN8DqYjEqB2ddt/zaEdSeqLwaTVT7xqSCQrUNoTIYPvX
         3OgAFqaQJLG14XhJQfVEt9kMq4+V9Uy4m8PBjxOsZFhhcZa99FAXlN1pUQt2uj+zGm8T
         VNEIHarzBcksEFiHOJmAea8J+qlh0KdOwskibpbPZN1O7nOBCzD20RilfB/m9liSbQOB
         N/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=COdVxe1AeMbdTSnEuZdxsRHZ7H+JQxgPDN83XBgpqFk=;
        b=JrQO6RPAIMJ4YgfM9h44wQ9Xu+mLIL4LKrKrIXd6nOfpHOv9iZHneABw4p8A+4oo+E
         U6/IyukQpxoUonac2+Ioc2zWOn2J+EEw7N54vc9Pb78UzW+C4Gjqctj4l+tM/g/s9E+f
         zEzms6iDPHcntpSBDToyH62jEMwvk10Tn2FqrNgOKSyqaH42fPHf4rwjKK4NSvCxiwbU
         zHGA3rvjYV6ignRq1ExpaKiDLYfJAzuvh/dZnPS6HbtVv0hrP1bjbvwYf3V8g2dF7GuF
         5t0os7GqQZ/Fr0Y3xtN1jsf1/p1tOdor/7cwgRaa4najeZTWNhwbjPJUpPzbKfgaglKR
         Nt5w==
X-Gm-Message-State: AOAM533qTE9K/GBOM1I/lQ/gUOZELnsEoGMZdTxXdDPN0agN5QAGFmg1
        LKkM1yEIGhs57gSCTBA05NEFu7a1BDI=
X-Google-Smtp-Source: ABdhPJy42t1kMCtZEmRRVDvhQwngy+Z4PqxFI3nCkvZbphjvEufymkkVKbMD4fVh/H6siFZE8WPfag==
X-Received: by 2002:a17:902:9044:b029:df:fa69:1ed1 with SMTP id w4-20020a1709029044b02900dffa691ed1mr415539plz.11.1613087098046;
        Thu, 11 Feb 2021 15:44:58 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:57 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/22] lpfc: Fix use after free in lpfc_els_free_iocb
Date:   Thu, 11 Feb 2021 15:44:31 -0800
Message-Id: <20210211234443.3107-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
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
index aabb3f115da2..ee362e6c0d62 100644
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

