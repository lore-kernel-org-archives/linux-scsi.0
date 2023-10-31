Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037C1C4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbjJaS70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbjJaS7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:59:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19D3E8
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:19 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cc4d306fe9so5150075ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778759; x=1699383559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QBK5fLy0U3b6zmeHz4k+VvgXfMeYUN84qpqw5Ya2Ow=;
        b=QezSF7nfutNTxZCH/3VQP2fRX2IUKrubiLiIzjx+IBjKGZhKJwqQODrwQIN4F+0+KO
         CTO4hDaUvjLMSGMqNfcAVYcSfNxj+FzPDV5AJ/waCXuWrLKuBMFEKVHsqYe7E8whf7/c
         /t7Msjd6gMuMkl6OvgHBu2oV7yATo5qeAZSKMMub01rBqyJS/4MuhCytXx3KiqtRVX0D
         fzFoyW7amU4qY+Vfslpdo8bKeHKp6qKJjT8iXASvo6HGbpXuDV7KU7tni9FLty8fuujJ
         gksyPjKoTCPxczH87ZAFk/n+JE8relvI+gluu19kOXEB1riJn+PldtnKV3KGpFPC8sY+
         nrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778759; x=1699383559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6QBK5fLy0U3b6zmeHz4k+VvgXfMeYUN84qpqw5Ya2Ow=;
        b=RsUFeQstflwyBgQPtUkokrNKCbIsEpjPTC8ZJv9mLbX/d6gKj7jOjjIs4p5Z4SeD9p
         T0TZ3LsyIzuPFQ54R9z4Xu6qjeuHw0s87DzznR1yjgr0qNgMwcEZX3tiRpuGRuY8bfdy
         rBV+QqlKIQ5XU12JaxI5HiFWl76JOFC+MUklKXoj2S+Q2k4X6UEkTJqRQ2Fr2DHc9UaY
         zXUu2pu1w1o5oicgyG/5Q3B1MU5qMyZH1LDz6XZJ6i54XjJNvktxoXAhYPWnHdtx0EBm
         j9Z4O0hNf2Lx/PI5SJICkDx0pPTYNJmE+IbGjNGiNnBZAsgIDtZLZVuegLv5cwd+fAX7
         4znw==
X-Gm-Message-State: AOJu0YzUDP5Y/jasHxK/iZrRGQ6d58psj1yRWQ9VjJAekkV7BspytlY6
        OWB26bxMx/HgDTBvpuHwRa5y/Vu/s6k=
X-Google-Smtp-Source: AGHT+IF9RSB0xlB1wLQdWgZInb0xoV0ZJ0VPlMXX1+awIRpSS+daZfnDL0lJimQ3KsvppwdYszuVVQ==
X-Received: by 2002:a17:902:c70b:b0:1c3:a4f2:7c99 with SMTP id p11-20020a170902c70b00b001c3a4f27c99mr13121945plp.4.1698778759244;
        Tue, 31 Oct 2023 11:59:19 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.59.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:59:18 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 7/9] lpfc: Enhance driver logging for selected discovery events
Date:   Tue, 31 Oct 2023 12:12:22 -0700
Message-Id: <20231031191224.150862-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Typically, debugging discovery issues requires the ndlp reference count,
nlp flags, transport flags, and the io tag for root cause analysis.

Modify important discovery log messages to include one or more of these
attributes to aid in debugging and support.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 49 +++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli.c | 11 +++++---
 2 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0829fe6ddff8..f04326db8c19 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2062,8 +2062,9 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* PLOGI completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0102 PLOGI completes to NPort x%06x "
-			 "Data: x%x x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, ndlp->nlp_fc4_type,
+			 "IoTag x%x Data: x%x x%x x%x x%x x%x\n",
+			 ndlp->nlp_DID, iotag,
+			 ndlp->nlp_fc4_type,
 			 ulp_status, ulp_word4,
 			 disc, vport->num_disc_nodes);
 
@@ -2362,9 +2363,10 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* PRLI completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0103 PRLI completes to NPort x%06x "
-			 "Data: x%x x%x x%x x%x\n",
+			 "Data: x%x x%x x%x x%x x%x\n",
 			 ndlp->nlp_DID, ulp_status, ulp_word4,
-			 vport->num_disc_nodes, ndlp->fc4_prli_sent);
+			 vport->num_disc_nodes, ndlp->fc4_prli_sent,
+			 ndlp->fc4_xpt_flags);
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport))
@@ -2805,7 +2807,7 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	int  disc;
-	u32 ulp_status, ulp_word4, tmo;
+	u32 ulp_status, ulp_word4, tmo, iotag;
 	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
@@ -2818,9 +2820,11 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		tmo = get_wqe_tmo(cmdiocb);
+		iotag = get_wqe_reqtag(cmdiocb);
 	} else {
 		irsp = &rspiocb->iocb;
 		tmo = irsp->ulpTimeout;
+		iotag = irsp->ulpIoTag;
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
@@ -2838,9 +2842,11 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* ADISC completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0104 ADISC completes to NPort x%x "
-			 "Data: x%x x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, ulp_status, ulp_word4,
+			 "IoTag x%x Data: x%x x%x x%x x%x x%x\n",
+			 ndlp->nlp_DID, iotag,
+			 ulp_status, ulp_word4,
 			 tmo, disc, vport->num_disc_nodes);
+
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
 		spin_lock_irq(&ndlp->lock);
@@ -3001,7 +3007,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int wake_up_waiter = 0;
 	u32 ulp_status;
 	u32 ulp_word4;
-	u32 tmo;
+	u32 tmo, iotag;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->rsp_iocb = rspiocb;
@@ -3011,9 +3017,11 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		tmo = get_wqe_tmo(cmdiocb);
+		iotag = get_wqe_reqtag(cmdiocb);
 	} else {
 		irsp = &rspiocb->iocb;
 		tmo = irsp->ulpTimeout;
+		iotag = irsp->ulpIoTag;
 	}
 
 	spin_lock_irq(&ndlp->lock);
@@ -3032,9 +3040,11 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* LOGO completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0105 LOGO completes to NPort x%x "
-			 "refcnt %d nflags x%x Data: x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp->nlp_flag,
-			 ulp_status, ulp_word4,
+			 "IoTag x%x refcnt %d nflags x%x xflags x%x "
+			 "Data: x%x x%x x%x x%x\n",
+			 ndlp->nlp_DID, iotag,
+			 kref_read(&ndlp->kref), ndlp->nlp_flag,
+			 ndlp->fc4_xpt_flags, ulp_status, ulp_word4,
 			 tmo, vport->num_disc_nodes);
 
 	if (lpfc_els_chk_latt(vport)) {
@@ -5075,16 +5085,19 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (logerr) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			 "0137 No retry ELS command x%x to remote "
-			 "NPORT x%x: Out of Resources: Error:x%x/%x\n",
-			 cmd, did, ulp_status,
-			 ulp_word4);
+			 "NPORT x%x: Out of Resources: Error:x%x/%x "
+			 "IoTag x%x\n",
+			 cmd, did, ulp_status, ulp_word4,
+			 cmdiocb->iotag);
 	}
 	else {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0108 No retry ELS command x%x to remote "
-			 "NPORT x%x Retried:%d Error:x%x/%x\n",
-			 cmd, did, cmdiocb->retry, ulp_status,
-			 ulp_word4);
+				 "0108 No retry ELS command x%x to remote "
+				 "NPORT x%x Retried:%d Error:x%x/%x "
+				 "IoTag x%x nflags x%x\n",
+				 cmd, did, cmdiocb->retry, ulp_status,
+				 ulp_word4, cmdiocb->iotag,
+				 (ndlp ? ndlp->nlp_flag : 0));
 	}
 	return 0;
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bfbc23248692..46e6f807d1ca 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2995,8 +2995,9 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		     LPFC_SLI_INTF_IF_TYPE_2)) {
 			if (ndlp) {
 				lpfc_printf_vlog(
-					 vport, KERN_INFO, LOG_MBOX | LOG_SLI,
-					 "0010 UNREG_LOGIN vpi:%x "
+					 vport, KERN_INFO,
+					 LOG_MBOX | LOG_SLI | LOG_NODE,
+					 "0010 UNREG_LOGIN vpi:x%x "
 					 "rpi:%x DID:%x defer x%x flg x%x "
 					 "x%px\n",
 					 vport->vpi, ndlp->nlp_rpi,
@@ -3012,7 +3013,8 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				    (ndlp->nlp_defer_did !=
 				    NLP_EVT_NOTHING_PENDING)) {
 					lpfc_printf_vlog(
-						vport, KERN_INFO, LOG_DISCOVERY,
+						vport, KERN_INFO,
+						LOG_MBOX | LOG_SLI | LOG_NODE,
 						"4111 UNREG cmpl deferred "
 						"clr x%x on "
 						"NPort x%x Data: x%x x%px\n",
@@ -10144,11 +10146,12 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
 			"(%d):0354 Mbox cmd issue - Enqueue Data: "
-			"x%x (x%x/x%x) x%x x%x x%x\n",
+			"x%x (x%x/x%x) x%x x%x x%x x%x\n",
 			mboxq->vport ? mboxq->vport->vpi : 0xffffff,
 			bf_get(lpfc_mqe_command, &mboxq->u.mqe),
 			lpfc_sli_config_mbox_subsys_get(phba, mboxq),
 			lpfc_sli_config_mbox_opcode_get(phba, mboxq),
+			mboxq->u.mb.un.varUnregLogin.rpi,
 			phba->pport->port_state,
 			psli->sli_flag, MBX_NOWAIT);
 	/* Wake up worker thread to transport mailbox command from head */
-- 
2.38.0

