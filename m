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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7FCC32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09B7A20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbdFjPVj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbfHNX5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36209 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbfHNX53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so427859pgm.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eZb9Sh/Id9LGVS6VszTrgSFU/EYwl8ejD+Flvz7I7kE=;
        b=hbdFjPVjpFUCIJHXxigCX07LvJDeCAZKV4HU+q8mfxMfMPbE0pqTcCLlfTDH/Yspzp
         0ISammLJgTLblnoHm1PLENQBSTivgJYo6cTbqyiB1e21uYnFDOU4Dw6OrvMW5hMhvlk5
         6tlPKyp2nbRsOLwL8Utfj1n/Mqwq5JkuO83nZ52O8t8XPm5Zna3/4LDzwHnpjlwSTWYb
         nDdSiR1yFTy8oRl/O6LfGiXKEEqG3OJIwhfcmtjnK48qfJsUk/iT6HsInuYoDASXQ2bg
         8zqRW4lZP3UQ7AKD74pVJoSWcGL+HjcocSYgSVJJsqn0bRnMvDfs6zeEsQnVEBJIbNkz
         l5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eZb9Sh/Id9LGVS6VszTrgSFU/EYwl8ejD+Flvz7I7kE=;
        b=bSQS+x+idPT7sey5qtI/pzxDvStPUl6Yd/edlYqFy5PgGpNeFLsPv973jH8ZA2oY4L
         pTg9yig6xwSovqdfajwmlaTX2p5kDw6kFKbzPaOOqik94sIBSwfZis9OhfbcnzcFstzR
         ndqSCCUWciFcuvr6HEpq63ntGn4U3pDTvTSRgnGGbyWzRbyEbmWNQdKUKbA1ktvfAdAI
         h7hKK/HYS+ztXZ6rf8vLIySp06p3zgF2nuFGYqDF2qjddQSRw30cl6wUJoK1KNZrXBJu
         3eCUCNXEgwIXMllpPsYMRmje59FQ8vM6atXtouf6UhPY/qOsb0/mkjDgUGtss/HPSCwZ
         m1GQ==
X-Gm-Message-State: APjAAAV74n1R9vRLJ5SDrQbzWgTZRiKunln4AQiTNIX85c7j3XIhdIbK
        BHkGlaNWi6kHPRbzcjm/LfmZcY5s
X-Google-Smtp-Source: APXvYqwqQqiVJq0YcYtizl5y1n+yP11c7mwUvPotoBlUESXL4AsRFUOOY7fgDnwurPMntl+tj6FY5w==
X-Received: by 2002:aa7:8a92:: with SMTP id a18mr2636093pfc.216.1565827048515;
        Wed, 14 Aug 2019 16:57:28 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:28 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 08/42] lpfc: Fix discovery when target has no GID_FT information
Date:   Wed, 14 Aug 2019 16:56:38 -0700
Message-Id: <20190814235712.4487-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some remote ports may be slow in registering their GID_FT
protocol information with the fabric. If the remote port is
an initiator, it may send PLOGI to the port before the GID_FT
logic is complete. Meaning, after accepting the PLOGI, when the
driver may see no response to the GID_FT that is issued after
the login to determine the protocols supported so that proper
PRLI's may be transmit. If the driver has no fc4 information,
it currently stops and the remote port is not discovered.

Fix by issuing a LOGO when there is no GID_FT information.
The LOGO completion handling will attempt to re-login if the
nport_id is still present.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c        | 16 +++++++++++++++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  6 +++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 3246942ff2ff..c2ac6cb730e8 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1215,12 +1215,26 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 FC_TYPE_FCP, FC_TYPE_NVME,
 					 ndlp->nlp_state);
 
-			if (ndlp->nlp_state == NLP_STE_REG_LOGIN_ISSUE) {
+			if (ndlp->nlp_state == NLP_STE_REG_LOGIN_ISSUE &&
+			    ndlp->nlp_fc4_type) {
 				ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 
 				lpfc_nlp_set_state(vport, ndlp,
 						   NLP_STE_PRLI_ISSUE);
 				lpfc_issue_els_prli(vport, ndlp, 0);
+			} else if (!ndlp->nlp_fc4_type) {
+				/* If fc4 type is still unknown, then LOGO */
+				lpfc_printf_vlog(vport, KERN_INFO,
+						 LOG_DISCOVERY,
+						 "6443 Sending LOGO ndlp x%px,"
+						 "DID x%06x with fc4_type: "
+						 "x%08x, state: %d\n",
+						 ndlp, did, ndlp->nlp_fc4_type,
+						 ndlp->nlp_state);
+				lpfc_issue_els_logo(vport, ndlp, 0);
+				ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+				lpfc_nlp_set_state(vport, ndlp,
+						   NLP_STE_NPR_NODE);
 			}
 		}
 	} else
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index c58000cd744f..d76d76081d1a 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1822,7 +1822,11 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
-		lpfc_issue_els_prli(vport, ndlp, 0);
+		if (lpfc_issue_els_prli(vport, ndlp, 0)) {
+			lpfc_issue_els_logo(vport, ndlp, 0);
+			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		}
 	} else {
 		if ((vport->fc_flag & FC_PT2PT) && phba->nvmet_support)
 			phba->targetport->port_id = vport->fc_myDID;
-- 
2.13.7

