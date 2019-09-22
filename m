Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35701C3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04BCA214AF
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4YMndch"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfIVD73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:29 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46965 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfIVD73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:29 -0400
Received: by mail-ot1-f66.google.com with SMTP id f21so9360517otl.13
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VyUAGnIWBo1GovlEDBAz1tIsd1rFbUZofkW0bqw8uOA=;
        b=b4YMndcheffH8S0oAojyMXv8hPdzuOjQRdqTxykcQ7MRPLPqlY2B9wXAzl3F1b1XKX
         VfrHdV5EF0rcHsB6yR/a2teoboy83uih8BODWiCqKdABJ3jsyDbYPD3VI7gT2fWIDrmR
         ecWkGND9NGVUjEmppMjdFb1eqgI5LxS5wG9Kvsw5DJ+Rz4sf4JvRCZH7gpiWIZC9ijYg
         2tenOlbexpSnLiTXAfSGxSYq4V1zmeJJvDHz71OdQwz0qGINOufN9hqchHBqZjwepc/u
         v5zHCkeX0R5qIdTiciqyNojLYDvkTNIcqmtscTpDtIhUW35Agu3EM3q3otD42wmQNLGS
         0Gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VyUAGnIWBo1GovlEDBAz1tIsd1rFbUZofkW0bqw8uOA=;
        b=W7F0BdQ3MebUFcDHEBUug7atHBAxh9WBq/eEZ1/Mp3RUuy1LliIvhLQyybto2BnXBq
         hQNbRAjL7S98FqonCpmhRAM+AHIL/Jg7V4wzOFQmVfaT0LOYwujvhjxsoFomTM8e9EwE
         dqsHYl57sxbV/WaqEiFDoiIg4pUIceJsmqEaZt1bWXEXr8vE4ABI5tJxnNOk1VJqJkz5
         EEQnfctJmQ3VOpobEMzejHqdV5YKT4VeRvp864Xlhfebx1NMXw6EVsTvL7basUb02KCZ
         7nNZ2tCkWUxcBco1sI/fr+d70gBig1DZLf3udE+M8yxlahvGfDXuxDIQ+qTwIlns9Gzf
         HDYA==
X-Gm-Message-State: APjAAAVVqPbgnKzobGKcXFPjTBZMlmW6C7A7/xgtbmGyng3/h14IagvW
        w+img6E0oQNePKpflMLPhDcxaKa7
X-Google-Smtp-Source: APXvYqwqJhCM8L3xin2glgXtuJmHQ39ji0NpQA7wPmZZyEYb8bhfj2DwOEdkzwR/Qz8Lc02nPIussg==
X-Received: by 2002:a9d:5c06:: with SMTP id o6mr1427681otk.266.1569124767715;
        Sat, 21 Sep 2019 20:59:27 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 11/20] lpfc: Fix coverity errors on NULL pointer checks
Date:   Sat, 21 Sep 2019 20:58:57 -0700
Message-Id: <20190922035906.10977-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Coverity flagged several scenarios where checking of null
pointer values wasn't consistent.

Fix the code to that be consistent on checking.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c   |  5 +++++
 drivers/scsi/lpfc/lpfc_nvmet.c | 19 +++++++++++++++----
 drivers/scsi/lpfc/lpfc_scsi.c  |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c   |  9 ++++++---
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d5303994bfd6..55ab37572e92 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4291,6 +4291,11 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	irsp = &rspiocb->iocb;
 
+	if (!vport) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "3177 ELS response failed\n");
+		goto out;
+	}
 	if (cmdiocb->context_un.mbox)
 		mbox = cmdiocb->context_un.mbox;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 121dbdcbb583..c9481a618b85 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1958,12 +1958,10 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	uint32_t *payload;
 	uint32_t size, oxid, sid, rc;
 
-	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
-	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
 
-	if (!phba->targetport) {
+	if (!nvmebuf || !phba->targetport) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6154 LS Drop IO x%x\n", oxid);
+				"6154 LS Drop IO\n");
 		oxid = 0;
 		size = 0;
 		sid = 0;
@@ -1971,6 +1969,9 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		goto dropit;
 	}
 
+	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
+	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
+
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	payload = (uint32_t *)(nvmebuf->dbuf.virt);
 	size = bf_get(lpfc_rcqe_length,  &nvmebuf->cq_event.cqe.rcqe_cmpl);
@@ -2401,6 +2402,11 @@ lpfc_nvmet_unsol_ls_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	d_buf = piocb->context2;
 	nvmebuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 
+	if (!nvmebuf) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"3015 LS Drop IO\n");
+		return;
+	}
 	if (phba->nvmet_support == 0) {
 		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
 		return;
@@ -2429,6 +2435,11 @@ lpfc_nvmet_unsol_fcp_event(struct lpfc_hba *phba,
 			   uint64_t isr_timestamp,
 			   uint8_t cqflag)
 {
+	if (!nvmebuf) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"3167 NVMET FCP Drop IO\n");
+		return;
+	}
 	if (phba->nvmet_support == 0) {
 		lpfc_rq_buf_free(phba, &nvmebuf->hbuf);
 		return;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c2773c07657d..f06f63e58596 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3814,7 +3814,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 	/* Sanity check on return of outstanding command */
 	cmd = lpfc_cmd->pCmd;
-	if (!cmd) {
+	if (!cmd || !phba) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				 "2621 IO completion: Not an active IO\n");
 		spin_unlock(&lpfc_cmd->buf_lock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 313441a3c4cf..939efee6b5dd 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2674,7 +2674,8 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 					"(%d):0323 Unknown Mailbox command "
 					"x%x (x%x/x%x) Cmpl\n",
-					pmb->vport ? pmb->vport->vpi : 0,
+					pmb->vport ? pmb->vport->vpi :
+					LPFC_VPORT_UNKNOWN,
 					pmbox->mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
 									pmb),
@@ -2695,7 +2696,8 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 					"(%d):0305 Mbox cmd cmpl "
 					"error - RETRYing Data: x%x "
 					"(x%x/x%x) x%x x%x x%x\n",
-					pmb->vport ? pmb->vport->vpi : 0,
+					pmb->vport ? pmb->vport->vpi :
+					LPFC_VPORT_UNKNOWN,
 					pmbox->mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
 									pmb),
@@ -2703,7 +2705,8 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 									pmb),
 					pmbox->mbxStatus,
 					pmbox->un.varWords[0],
-					pmb->vport->port_state);
+					pmb->vport ? pmb->vport->port_state :
+					LPFC_VPORT_UNKNOWN);
 				pmbox->mbxStatus = 0;
 				pmbox->mbxOwner = OWN_HOST;
 				rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-- 
2.13.7

