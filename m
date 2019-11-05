Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BA4CA9ED5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CDC320717
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1lfkC53"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbfKEA53 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:57:29 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36281 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbfKEA53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:57:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id c22so18124342wmd.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AeuDvHRqTnp0nwkn+XnvcF6m1iUWiRQfOTVqAPtJjkM=;
        b=W1lfkC53QL0dh29Pis+tpWKnNzMTWAywpsWJIAlCclc0H4xPDp+2Ul1g/7b/lKoEGg
         Etmv0U/cjRd8nWgxHNDZ7GpA7UeV70iIllqP7M6pX0862HQNZRrsohEH4dNZjE3ve2p+
         NB6lBm9Zb82fFaNsW8OT13aL1ynzRRC9YZsq9aQcNH0VHwlvLaNNiVaWb5mqIB/zxMCI
         FSaxKBCjNUPfqJVjke9Owxc/YC3v/Dm/2yBmKo4jJqK2NXsuYdXTQRIux6GUf1br5oQ5
         vr0ZNUnhr3V+jZG1ByhHd04hYceGCGdVrCsvoJVEmjf4TBxSKk3aTQvGYhP/SL4/wYa2
         yGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AeuDvHRqTnp0nwkn+XnvcF6m1iUWiRQfOTVqAPtJjkM=;
        b=hPv5LebLKN4JxLme8O4sk85A8zY9qHypd307DJp7LTx1viXIkqiOanEbM3UIiqE1Uf
         i/GI+TZ5yDhl0KzwHTmLKq5I1jBkrxyzlgAIxWklwjPdpCRKNd15dE9duhF63UIvzAHz
         PBIYQYrmBG78177mn5C/39qg5NEmxfZaRQpSs1Zo7cWzMsvsvcp6i6lG7+p05HOgiBQD
         4teFb69fDDyvodsnE6UvxdCAaz32cPtiKZ7bgBV65yhWVTpCmKqS8Z7XAqetH67a7wqc
         LISe3F5oYiT+uyqP1ZpEpa9QCqwdXDD1z0uuch4wknqf7SLebK/OoPXCeBt6U2U5rT+R
         ZJYQ==
X-Gm-Message-State: APjAAAVJhQgFpaURkSBbLwZhfvUDaA+won9ep0MLCSgryl/LnHbHiDvA
        7e6oGoB75W9ux0Fv7lOjc+yJHHw4lhc=
X-Google-Smtp-Source: APXvYqznxM8DMotoQtHGQvlDm1Rv+gxHKlDchGt1PkLzM4ksLarTSQLP3lU7iaL62X4YWN85Xs9AHg==
X-Received: by 2002:a1c:a556:: with SMTP id o83mr1495130wme.165.1572915447453;
        Mon, 04 Nov 2019 16:57:27 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g5sm16920991wma.43.2019.11.04.16.57.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 16:57:27 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/11] lpfc: Fix unexpected error messages during RSCN handling
Date:   Mon,  4 Nov 2019 16:57:01 -0800
Message-Id: <20191105005708.7399-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191105005708.7399-1-jsmart2021@gmail.com>
References: <20191105005708.7399-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During heavy RCN activity and log_verbose = 0 we see these messages:
2754 PRLI failure DID:521245 Status:x9/xb2c00, data: x0
0231 RSCN timeout Data: x0 x3
0230 Unexpected timeout, hba link state x5

This is due to delayed RSCN activity.

Correct by avoiding the timeout thus the messages by resetarting
the discovery timeout whenever an rscn is received.

Filter PRLI responses such that severity depends on whether expected for
the configuration or not. For example, PRLI errors on a fabric will be
informational (they are expected), but Point-to-Point errors are not
necessarily expected so they are raised to an error level.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9a1b7f331718..9a570c15b2a1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2236,6 +2236,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
+	char *mode;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2273,8 +2274,17 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		}
 
+		/* If we don't send GFT_ID to Fabric, a PRLI error
+		 * could be expected.
+		 */
+		if ((vport->fc_flag & FC_FABRIC) ||
+		    (vport->cfg_enable_fc4_type != LPFC_ENABLE_BOTH))
+			mode = KERN_ERR;
+		else
+			mode = KERN_INFO;
+
 		/* PRLI failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+		lpfc_printf_vlog(vport, mode, LOG_ELS,
 				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
 				 "data: x%x\n",
 				 ndlp->nlp_DID, irsp->ulpStatus,
@@ -6465,7 +6475,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t payload_len, length, nportid, *cmd;
 	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
-	int i;
+	int i, tmo;
 
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	lp = (uint32_t *) pcmd->virt;
@@ -6571,6 +6581,13 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_RSCN_DEFERRED;
+
+		/* Restart disctmo if its already running */
+		if (vport->fc_flag & FC_DISC_TMO) {
+			tmo = ((phba->fc_ratov * 3) + 3);
+			mod_timer(&vport->fc_disctmo,
+				  jiffies + msecs_to_jiffies(1000 * tmo));
+		}
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !(vport->fc_flag & FC_RSCN_DISCOVERY)) {
 			vport->fc_flag |= FC_RSCN_MODE;
-- 
2.13.7

