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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B38C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72D42086C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDkx/LIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbfHNX53 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33226 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbfHNX52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id n190so438218pgn.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4O39nKqG7WHn7Z7690H8RiSBamI2Mn1Dwsup9KpDSUY=;
        b=EDkx/LIPg+5BF1I+jdTUzne7Nox4zyZqnL2VVKk70P9PLOr5dVDB4+fh5x9Ipmelg/
         PFao6TzrihGOyt85rZs0BFC63j4El8IQZuPHtOB6K0Ewh0aqdxSrNqb/e0VKXWb0vYMj
         dSDzqm5j7Uw6H/y2sqdajtKiDwTQ+U4HxHKQYapj4t2kvW/wvee3RV2PtmMNrTD9Ut4H
         2dT96JHXBX+kpM3RNeBq0bFBVplynUDEjCZmgccCZtQSM7j6hPjBeAY73BDQxSYJd0Gc
         EwQG4x64M0x9/aOJxYpiF3L4QZAl3ow8CSlkJDoTnSOLnXTn+pNuG0q8K+AfRdQSXvi8
         dbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4O39nKqG7WHn7Z7690H8RiSBamI2Mn1Dwsup9KpDSUY=;
        b=MtG2qc2eo0KdQqq+JlPO/BdMZWOy8GlnYWXscAOof0YmxkdzOv3fcPoQK0AGhCtU6V
         +F4PhOQG7zfR6ya388hHCFRg0olRxe7VqVIHnBFXnObmaxHAtY+CZNShVLezMHIqD2q9
         L+3hfgnurQRLoa/EAcjs2O5/qpWRXY6WHgN7CFqbOdThWKqnhgnSFsLnTy3N55Z/5vZa
         wmK1hvGJH11TVqCGuvhGyhi3gKUnSoC/bNW+rF+aPH20D0UOigzaFFsDeiHmyqex7nqb
         +j11K8kL5SI7TjJAttv54McRY2SuPlgnXg9fww0TlLOnIy5RCDOMr/bhfDT512sARPVQ
         hPEQ==
X-Gm-Message-State: APjAAAXbiAJLrG0PGWyyH8aCyYlvSDgXxaWAhbI5dpY3KdJePGizXiTb
        S6FhyNVrX4EF5UGTFB+el5x4Dl4j
X-Google-Smtp-Source: APXvYqwqmlzebb5Kjn10KURAYKAcQR3370UOORXm85dCLflb/p2F8jIJn9BsQ9hhCaHtZO7XU6Zk/Q==
X-Received: by 2002:a62:63c7:: with SMTP id x190mr2461469pfb.181.1565827047764;
        Wed, 14 Aug 2019 16:57:27 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/42] lpfc: Fix port relogin failure due to GID_FT interaction
Date:   Wed, 14 Aug 2019 16:56:37 -0700
Message-Id: <20190814235712.4487-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In cases of remote-port-side cable pull/replug, there happens to
be a target that upon replug will send the port a PLOGI, a PRLI,
and a LOGO.  When this sequence is received by the driver, the
PLOGI accepted and a GFT_ID is issued to find the protocol support
for the remote port. While the GFT_ID is outstanding, a LOGO is
received. The driver logs the remote port out and unregisters the
RPI and schedules a new PLOGI transmission. However, the GFT_ID
was not terminated. When it completed, the driver attempted to
transition the remote port to PRLI transmission, which cancels
the PLOGI scheduling. The PRLI transmit attempt is rejected by the
adapter as the remote port is not logged in. No retry is attempted
as it's expected the logout is noted and the supposedly scheduled
PLOGI should address the state. As there is no PLOGI, the remote
port does not get re-discovered.

Fix by aborting the outstanding GFT_ID if the related remote port is
logged out.

Ensure a PRLI transmit attempt only occurs if the remote port is
logging in. This avoids the incorrect attempt while logged out.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c        | 15 ++++++++++-----
 drivers/scsi/lpfc/lpfc_nportdisc.c |  8 ++++++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index ec72c39997d2..3246942ff2ff 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1210,13 +1210,18 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				ndlp->nlp_fc4_type |= NLP_FC4_NVME;
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "3064 Setting ndlp %p, DID x%06x with "
-					 "FC4 x%08x, Data: x%08x x%08x\n",
+					 "FC4 x%08x, Data: x%08x x%08x %d\n",
 					 ndlp, did, ndlp->nlp_fc4_type,
-					 FC_TYPE_FCP, FC_TYPE_NVME);
-			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+					 FC_TYPE_FCP, FC_TYPE_NVME,
+					 ndlp->nlp_state);
 
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
-			lpfc_issue_els_prli(vport, ndlp, 0);
+			if (ndlp->nlp_state == NLP_STE_REG_LOGIN_ISSUE) {
+				ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+
+				lpfc_nlp_set_state(vport, ndlp,
+						   NLP_STE_PRLI_ISSUE);
+				lpfc_issue_els_prli(vport, ndlp, 0);
+			}
 		}
 	} else
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 59252bfca14e..c58000cd744f 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1661,6 +1661,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc_vport *vport,
 	LPFC_MBOXQ_t	  *mb;
 	LPFC_MBOXQ_t	  *nextmb;
 	struct lpfc_dmabuf *mp;
+	struct lpfc_nodelist *ns_ndlp;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
@@ -1693,6 +1694,13 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc_vport *vport,
 	}
 	spin_unlock_irq(&phba->hbalock);
 
+	/* software abort if any GID_FT is outstanding */
+	if (vport->cfg_enable_fc4_type != LPFC_ENABLE_FCP) {
+		ns_ndlp = lpfc_findnode_did(vport, NameServer_DID);
+		if (ns_ndlp && NLP_CHK_NODE_ACT(ns_ndlp))
+			lpfc_els_abort(phba, ns_ndlp);
+	}
+
 	lpfc_rcv_logo(vport, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
-- 
2.13.7

