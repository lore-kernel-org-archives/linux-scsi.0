Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3BCC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A7B120866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o1q1HQlS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfHNX5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43345 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfHNX5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id v12so322863pfn.10
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zpH5HJWJokV7j4PYSP1cYI0UhR+zvLsIAFM9PzXCjTs=;
        b=o1q1HQlSsdcF+8cO7HY+M1y0dZ6uS1mapbsPqOUj7Kmjr0TnesZstmdCoZxuH3NuVi
         FGYqgGbwvv9HyLFlsdgPTAM2kRJomKm48uROwteyCRNytkpAaAZHHPwUAu+4SLT36s/o
         gMT5SARcjhCEB4Zh//mhFevZHLWq9GaacHuhEbdr/Ce5bsD6+PSZJDWeY6y75G34K2/F
         zLjl0eWaakUHmyGkaNopUa+KZnZyTpRx3Ce8ycNGRzBmoumh+nc077UqljRCKl1WjeBT
         ZWY4husGUsltpnWWn/ZUejXblNHucrTbC3ZGDond5bN1xRUVGuW+3s77qYG74xfIF3lV
         0BFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zpH5HJWJokV7j4PYSP1cYI0UhR+zvLsIAFM9PzXCjTs=;
        b=PCpMS61E2JpvWbgYsHKZSY05pt46x48D4vFEgQVLkG18baO7uXQDQANJYKkqcNtJ/g
         BhyOxJ1UF7uv1aNXnoclJ43msjWyf+gFkVF52kLZ6zdgFWZcRMxY/Pmk9QbcackCtZat
         u12umqh6OCDqxHzkwkV/fRry1nxj0fuVBd7apbkK9Zcx79BBIpkeKjnXDo6mpNQh5TZM
         QQVCoEGgkXoUp41d3qmVazyKSCYH6wxxs6CjQzZVkd770RrJr0KYCq3jlzJWsEE6Ao9+
         LYc2WUbRa5T58M1Wk0VFzxnf/nnn56kxYO8p/39LpvBA2wFZcmLw9apAV8P4GezAQCdL
         +0vQ==
X-Gm-Message-State: APjAAAX0kyhDX7TI3F9m66+GAPRQsXEV/2PXvmPuKFlexwBQilhutpW4
        GmrdSUXhYSTq1sEYTDBDuvHGbuKI
X-Google-Smtp-Source: APXvYqwC6ml/Aic/4fPrqEiN+vnXjXd9yWO9TEI+Du1wb8ZyRMxyTS5L7zO3vSKKnuCdazqQ7h8hAg==
X-Received: by 2002:a62:1808:: with SMTP id 8mr2576766pfy.177.1565827043944;
        Wed, 14 Aug 2019 16:57:23 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 02/42] lpfc: Fix PLOGI failure with high remoteport count
Date:   Wed, 14 Aug 2019 16:56:32 -0700
Message-Id: <20190814235712.4487-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When connected to a high number of remote ports, the driver is
encountering PLOGI errors.  The errors are due to adapter detected
failures indicating illegal field values.

Turns out the driver was prematurely clearing an RPI bitmask before
waiting for an UNREG_RPI mailbox completion. This allowed the RPI to
be reused before it was actually available.

Fix by clearing RPI bitmask only after UNREG_RPI mailbox completion.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h    |  1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c |  8 ++++++--
 drivers/scsi/lpfc/lpfc_sli.c     | 12 ++++++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 1c89c9f314fa..49bb0b180b19 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -157,6 +157,7 @@ struct lpfc_node_rrq {
 /* Defines for nlp_flag (uint32) */
 #define NLP_IGNR_REG_CMPL  0x00000001 /* Rcvd rscn before we cmpl reg login */
 #define NLP_REG_LOGIN_SEND 0x00000002   /* sent reglogin to adapter */
+#define NLP_RELEASE_RPI    0x00000004   /* Release RPI to free pool */
 #define NLP_SUPPRESS_RSP   0x00000010	/* Remote NPort supports suppress rsp */
 #define NLP_PLOGI_SND      0x00000020	/* sent PLOGI request for this entry */
 #define NLP_PRLI_SND       0x00000040	/* sent PRLI request for this entry */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 28ecaa7fc715..6360683417b8 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4805,6 +4805,10 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 		lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
 	} else {
+		if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
+			lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
+			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+		}
 		ndlp->nlp_flag &= ~NLP_UNREG_INP;
 	}
 }
@@ -5104,6 +5108,8 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	list_del_init(&ndlp->els_retry_evt.evt_listp);
 	list_del_init(&ndlp->dev_loss_evt.evt_listp);
 	lpfc_cleanup_vports_rrqs(vport, ndlp);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		ndlp->nlp_flag |= NLP_RELEASE_RPI;
 	lpfc_unreg_rpi(vport, ndlp);
 
 	return 0;
@@ -6200,8 +6206,6 @@ lpfc_nlp_release(struct kref *kref)
 	spin_lock_irqsave(&phba->ndlp_lock, flags);
 	NLP_CLR_NODE_ACT(ndlp);
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
 
 	/* free ndlp memory for final ndlp release */
 	if (NLP_CHK_FREE_REQ(ndlp)) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f9e6a135d656..504f56a99b20 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2507,6 +2507,11 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 				lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
 			} else {
+				if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
+					lpfc_sli4_free_rpi(vport->phba,
+							   ndlp->nlp_rpi);
+					ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+				}
 				ndlp->nlp_flag &= ~NLP_UNREG_INP;
 			}
 			pmb->ctx_ndlp = NULL;
@@ -2582,6 +2587,13 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 					lpfc_issue_els_plogi(
 						vport, ndlp->nlp_DID, 0);
 				} else {
+					if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
+						lpfc_sli4_free_rpi(
+							vport->phba,
+							ndlp->nlp_rpi);
+						ndlp->nlp_flag &=
+							~NLP_RELEASE_RPI;
+					}
 					ndlp->nlp_flag &= ~NLP_UNREG_INP;
 				}
 			}
-- 
2.13.7

