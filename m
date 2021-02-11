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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D8EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3120464E44
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhBKXqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhBKXqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:16 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EBBC0617A7
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:59 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d13so4210788plg.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p2k0+JecG4JG0EOaso2qaaMTgypBmmiS73QH8hR80ME=;
        b=mu32p3qf7zjmsSU8TgxSClaEVtwAy8L4q+JFg0WP/Jmmq5tW2GzI7shCRf0AmaYQE8
         EMB9E6fQv/XsBqaX97kPHlJcy/TS+5IVyIKKhh5QPyRfy3Pt3nYGbrM9XSz2hjuCIB+W
         ZMTHpdehnfCLfV/PhK4nTfpYS+UCL9NYyXIHhZV5GapQu7ZX/kLwPOp/OEm3UQJUbZDG
         MmPeVFpAqbLWst9niRvbuMcorvEvTqJsY4/VkwOEgCpPc6iYe5kZ411nN5QW6/9Srbcu
         Unu5tEB+P7x1Zir+6JWRLOGjXyLOlkYkZbfygbQl6vP5et6U0JulVW51312wn+aRE9XP
         +7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p2k0+JecG4JG0EOaso2qaaMTgypBmmiS73QH8hR80ME=;
        b=hqw55AiF2djgJ5OCDB9gzAI3iKJZh8fixa23RO94Jv6AI+YDN0AB4QK3F7cc0Po9UU
         jLVtVviI/8G0IqO9hxW5jExjq4F9d0wBadfZ5m39DO/5h7nq81/4k51wfJn+nF4IKzbJ
         xwOk2aXCNcqqdinV8e1go3kyz+9MkHCco7t0u9ZVHbzWOp/9V7yjV9wA0xDNWYxmt/B0
         kvcF+AU/wY7+0Lt9ABSO8n15IT2OPcS0V+ApAtnQmB/58ResU2PBC4BP3oUw7Vtbm0LO
         hA7p1n3dFaxoeeWnWgfuVGUk5WldJjVCfBSgxiM2JCk2E+m3sENekdjMJY6WlNX0pNpY
         KLtA==
X-Gm-Message-State: AOAM533cZlY55/tCS2oWaf7asR6T2Mcf+JnqK/2UbMWeZl166vnXY0yC
        rssGRasPHVepTv1105N4cufpM/x6X4s=
X-Google-Smtp-Source: ABdhPJziIjdnsBuhy9Uzq/j48wTcpN2Th/HciZdk0uwXKLc1nlxWhIQt1yi1R2L6kkPVVZ9HYdS7EQ==
X-Received: by 2002:a17:902:7083:b029:e2:e330:7eaf with SMTP id z3-20020a1709027083b02900e2e3307eafmr507018plk.18.1613087099221;
        Thu, 11 Feb 2021 15:44:59 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:59 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 12/22] lpfc: Fix dropped FLOGI during pt2pt discovery recovery
Date:   Thu, 11 Feb 2021 15:44:33 -0800
Message-Id: <20210211234443.3107-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When connected in pt2pt mode, there is a scenario where the remote port
significantly delays sending a response to our FLOGI, but acts on the
FLOGI it sent us and proceeds to PLOGI/PRLI.  The FLOGI ends up timing
out and kicks off recovery logic. End result is a lot of unnecessary
state changes and lots of discovery messages being logged.

Fix by terminating the FLOGI and noop'ing it's completion if we have
already accepted the remote ports FLOGI and are now processing PLOGI.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h           |  1 +
 drivers/scsi/lpfc/lpfc_crtn.h      |  2 ++
 drivers/scsi/lpfc/lpfc_els.c       | 10 ++++++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c | 10 ++++++++++
 drivers/scsi/lpfc/lpfc_sli.c       |  2 +-
 5 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 6ba5fa08c47a..431c0d5376d9 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -782,6 +782,7 @@ struct lpfc_hba {
 #define HBA_NEEDS_CFG_PORT	0x2000000 /* SLI3 - needs a CONFIG_PORT mbox */
 #define HBA_HBEAT_INP		0x4000000 /* mbox HBEAT is in progress */
 #define HBA_HBEAT_TMO		0x8000000 /* HBEAT initiated after timeout */
+#define HBA_FLOGI_OUTSTANDING	0x10000000 /* FLOGI is outstanding */
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index a0aad4896a45..43820ab8a6e8 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -103,6 +103,8 @@ int lpfc_check_sli_ndlp(struct lpfc_hba *, struct lpfc_sli_ring *,
 struct lpfc_nodelist *lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did);
 struct lpfc_nodelist *lpfc_nlp_get(struct lpfc_nodelist *);
 int  lpfc_nlp_put(struct lpfc_nodelist *);
+void lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+			  struct lpfc_iocbq *rspiocb);
 int  lpfc_nlp_not_used(struct lpfc_nodelist *ndlp);
 struct lpfc_nodelist *lpfc_setup_disc_node(struct lpfc_vport *, uint32_t);
 void lpfc_disc_list_loopmap(struct lpfc_vport *);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a359d0ddd6e8..fc70b4a23c8e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1200,6 +1200,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_issue_clear_la(phba, vport);
 	}
 out:
+	phba->hba_flag &= ~HBA_FLOGI_OUTSTANDING;
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
 }
@@ -1354,7 +1355,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return 1;
 	}
 
-	phba->hba_flag |= HBA_FLOGI_ISSUED;
+	phba->hba_flag |= (HBA_FLOGI_ISSUED | HBA_FLOGI_OUTSTANDING);
 
 	/* Check for a deferred FLOGI ACC condition */
 	if (phba->defer_flogi_acc_flag) {
@@ -1425,9 +1426,14 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 		icmd = &iocb->iocb;
 		if (icmd->ulpCommand == CMD_ELS_REQUEST64_CR) {
 			ndlp = (struct lpfc_nodelist *)(iocb->context1);
-			if (ndlp && (ndlp->nlp_DID == Fabric_DID))
+			if (ndlp && ndlp->nlp_DID == Fabric_DID) {
+				if ((phba->pport->fc_flag & FC_PT2PT) &&
+				    !(phba->pport->fc_flag & FC_PT2PT_PLOGI))
+					iocb->fabric_iocb_cmpl =
+						lpfc_ignore_els_cmpl;
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
 							   NULL);
+			}
 		}
 	}
 	/* Make sure HBA is alive */
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 4918423960d6..57e4aef8a9a3 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -523,6 +523,16 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		/* rcv'ed PLOGI decides what our NPortId will be */
 		vport->fc_myDID = icmd->un.rcvels.parmRo;
 
+		/* If there is an outstanding FLOGI, abort it now.
+		 * The remote NPort is not going to ACC our FLOGI
+		 * if its already issuing a PLOGI for pt2pt mode.
+		 * This indicates our FLOGI was dropped; however, we
+		 * must have ACCed the remote NPorts FLOGI to us
+		 * to make it here.
+		 */
+		if (phba->hba_flag & HBA_FLOGI_OUTSTANDING)
+			lpfc_els_abort_flogi(phba);
+
 		ed_tov = be32_to_cpu(sp->cmn.e_d_tov);
 		if (sp->cmn.edtovResolution) {
 			/* E_D_TOV ticks are in nanoseconds */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 99307bb7b62c..56112c9fb6aa 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11591,7 +11591,7 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * which are aborted. The function frees memory resources used for
  * the aborted ELS commands.
  **/
-static void
+void
 lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		     struct lpfc_iocbq *rspiocb)
 {
-- 
2.26.2

