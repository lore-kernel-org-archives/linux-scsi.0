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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD25C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD58F6522C
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbhCAR1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbhCARVm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:21:42 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B397BC06121F
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:35 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id e9so12343846pjj.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SlZza6b4m8F51loT7wIuQstk7AC4p2211wd+uqLV5UM=;
        b=A0QDCAk9EOrLOBdmh25dep9n3bmVL0/qGo44zyXgfM5NvRRqUq5gCwQBrAHg4gWHPq
         Gq9lW9FdMg8msh5VZYCuJ6uvY1p6DA2m+bP+OdFU+QY9moVd2mKUF/+rrOehDdMUMUZ9
         xGO5EpeGOfg0WZWGnTjajB6mpF1AqAlG/YAD57/U14jUrtp+0aSsLZoQL8PK7AA67+OE
         eSI6IXx1KpaNswYHgieFFxqsMX+YUT7juHh843QIyRE80wOlGM9G1EnnzDWUHqkqTTiX
         7RTce0rZWhbHON8dqZGGytqzot1iOVeIu1kjuRi5CdUlbgM3ebGoxx3kfsQLaCZ7EVrT
         o7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SlZza6b4m8F51loT7wIuQstk7AC4p2211wd+uqLV5UM=;
        b=aorrHwQvB8z0qInn6e8uG0swQknVGDsTG4+tTnGs0RsWKJn+AHF2Q0JyCtsf4xqSHk
         rzfiaqwmmJrFbOAtYAAdpID+YRCvStxci9hmmPBVQ9f1rrAgMiiR3E5A6DDwVkRjWBRG
         7wc4K5ZJV2dy5APbImtyHQFhtLL3g45qUCkWCYjZlkkSjecMwPyuUcnP4s66JBOd5nW/
         +xvp+RuV5A3QjUHN1M9StAziBxOaNa0DUQ49A50g5nNGgmdwWBrjA93YDol6xWa17bz7
         swALGNDL3IPjSTunepXfeKYLCS4OOqryQXzNe/1tcLOHcR8QjOEtIQzj550xUxZX8gCG
         PRJw==
X-Gm-Message-State: AOAM533TF8Po2ZcRqCijg7bfkaDupvyv/8wHoBKn+IC5UPjxNKr8Fwah
        4lLJylTWf24tU6Z8xBpKj0Ah+0mPkcw=
X-Google-Smtp-Source: ABdhPJxzZ5klHjCe3Wx4DLspe6je0MeEXkS+GhCdFaRpjXmi4w/Q6ZWrdOMKyKJ2roU019Nbu8QQxg==
X-Received: by 2002:a17:90a:d3c4:: with SMTP id d4mr18287412pjw.31.1614619115180;
        Mon, 01 Mar 2021 09:18:35 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:34 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 12/22] lpfc: Fix dropped FLOGI during pt2pt discovery recovery
Date:   Mon,  1 Mar 2021 09:18:11 -0800
Message-Id: <20210301171821.3427-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
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
index 3bd1482af72f..0e92a0b61e77 100644
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

