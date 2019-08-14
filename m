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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8611C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 776FA20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GepCp80k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbfHNX5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35490 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbfHNX5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id n4so432290pgv.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+ChsBAleKS4P8EvrNkCSHk5kbMVNuySpby8MvL1vfVA=;
        b=GepCp80kbVVL5XiSK7Gdfeg/MOpS/eAgyCBw/NECHQJDcWpOwcSSzhZWxAOYUo8kvn
         qiGhj41t/WdOSimUxHLYSj8wls5/9z9VhmJ7fYNKUlj48BTU22ckWN0BNiMY2N1Cfnu5
         AFoKL6AzCCkgu9SRHqL6JLJTsm3ilGLV1IusG5W2RNSDLvkGwyzoQenHIOO5Ab5Afgzd
         /Vu6rWBW0I7sJthWtjVnyrafBXJ06Gr0yNfXExOdqMuY/mIGjpjny4SeBwYuEaoLb5b5
         npA3lyep6jyscb6FSlml+ToCYCwN7Tvnqmnvt6MNsJCjigHibC5E3qjS6zwWG81F4lxs
         /LtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+ChsBAleKS4P8EvrNkCSHk5kbMVNuySpby8MvL1vfVA=;
        b=M2l6rdjKkm9PhO3ATK4y8dI2Pth1fyg77R67OliT+Eu0QqXyfPg9vY702kLWFbkXx5
         9zLQajM1qvL/M1x7gMyWnXqSgpoPfkpz0hyQv4Xp1xRXiyB8m5we5vQiVtvnF28Hf/xd
         rgV060XUR0aXtgO0xFXgYJNxck7Z570RidNJRbJe2X/SOor6rpNMDQjna58oQEwnuAX6
         7KlA9jWc9L0+TXsvpRMgmiyqEUCm9RXZVfodeTnMpz6QM1zFnGL87igKIhCvfGaoR3qe
         qE7WiitjVwsmLxYxZmWU9X406k7e2hOG7zWNRExhMmXOg27JRQ+CViBgDqgNInE0ZBjU
         IvYg==
X-Gm-Message-State: APjAAAXkJcF1tWH0rthw51RQKenBZgHW8S0kIJclnbXcXNvLOLP9BNvM
        jHD+sajo/RLKklgkRtXfDuLqqzEg
X-Google-Smtp-Source: APXvYqzJX0YERVWQYJ71NCYsdbiDMfiQfsEtMEc00uKiYNSTgi+y6QPq6Cc1G0kVqHuFtnsjkc1FrQ==
X-Received: by 2002:a17:90a:bc06:: with SMTP id w6mr445550pjr.130.1565827052956;
        Wed, 14 Aug 2019 16:57:32 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:32 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 14/42] lpfc: Fix FLOGI handling across multiple link up/down conditions
Date:   Wed, 14 Aug 2019 16:56:44 -0700
Message-Id: <20190814235712.4487-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's possible for the driver to initiate an FLOGI and before it
completes, another link down/up transition occurs requiring a new
FLOGI. Currently, nothing is done to abort/noop the older FLOGI
request to the adapter, so if this transition occurs and the FLOGI
completion is received after the link down/up transition, the
driver may erroneously act on the older FLOGI. In most cases,
the adapter properly terminates/fails the FLOGI, but there is a
timing condition where the FLOGI may complete on the wire prior
to the transition, but the response may not be seen/processed by
the driver before the driver sees the link transition.

Fix by having the link down handler in the driver run through
any outstanding ELS's and change the completion handler of the
ELS so that it will be no-op'd and released.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 75 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f12780f4cfbb..8103635adc38 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1207,6 +1207,39 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
+ * lpfc_cmpl_els_link_down - Completion callback function for ELS command
+ *                           aborted during a link down
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @rspiocb: pointer to lpfc response iocb data structure.
+ *
+ */
+static void
+lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+			struct lpfc_iocbq *rspiocb)
+{
+	IOCB_t *irsp;
+	uint32_t *pcmd;
+	uint32_t cmd;
+
+	pcmd = (uint32_t *)(((struct lpfc_dmabuf *)cmdiocb->context2)->virt);
+	cmd = *pcmd;
+	irsp = &rspiocb->iocb;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+			"6445 ELS completes after LINK_DOWN: "
+			" Status %x/%x cmd x%x flg x%x\n",
+			irsp->ulpStatus, irsp->un.ulpWord[4], cmd,
+			cmdiocb->iocb_flag);
+
+	if (cmdiocb->iocb_flag & LPFC_IO_FABRIC) {
+		cmdiocb->iocb_flag &= ~LPFC_IO_FABRIC;
+		atomic_dec(&phba->fabric_iocb_count);
+	}
+	lpfc_els_free_iocb(phba, cmdiocb);
+}
+
+/**
  * lpfc_issue_els_flogi - Issue an flogi iocb command for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -7960,18 +7993,40 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
+	/* First we need to issue aborts to outstanding cmds on txcmpl */
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
 		if (piocb->iocb_flag & LPFC_IO_LIBDFC)
 			continue;
 
 		if (piocb->vport != vport)
 			continue;
-		list_add_tail(&piocb->dlist, &abort_list);
+
+		/* On the ELS ring we can have ELS_REQUESTs or
+		 * GEN_REQUESTs waiting for a response.
+		 */
+		cmd = &piocb->iocb;
+		if (cmd->ulpCommand == CMD_ELS_REQUEST64_CR) {
+			list_add_tail(&piocb->dlist, &abort_list);
+
+			/* If the link is down when flushing ELS commands
+			 * the firmware will not complete them till after
+			 * the link comes back up. This may confuse
+			 * discovery for the new link up, so we need to
+			 * change the compl routine to just clean up the iocb
+			 * and avoid any retry logic.
+			 */
+			if (phba->link_state == LPFC_LINK_DOWN)
+				piocb->iocb_cmpl = lpfc_cmpl_els_link_down;
+		}
+		if (cmd->ulpCommand == CMD_GEN_REQUEST64_CR)
+			list_add_tail(&piocb->dlist, &abort_list);
 	}
+
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_unlock(&pring->ring_lock);
 	spin_unlock_irq(&phba->hbalock);
-	/* Abort each iocb on the aborted list and remove the dlist links. */
+
+	/* Abort each txcmpl iocb on aborted list and remove the dlist links. */
 	list_for_each_entry_safe(piocb, tmp_iocb, &abort_list, dlist) {
 		spin_lock_irq(&phba->hbalock);
 		list_del_init(&piocb->dlist);
@@ -7987,6 +8042,9 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
+	/* No need to abort the txq list,
+	 * just queue them up for lpfc_sli_cancel_iocbs
+	 */
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txq, list) {
 		cmd = &piocb->iocb;
 
@@ -8007,11 +8065,22 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		list_del_init(&piocb->list);
 		list_add_tail(&piocb->list, &abort_list);
 	}
+
+	/* The same holds true for any FLOGI/FDISC on the fabric_iocb_list */
+	if (vport == phba->pport) {
+		list_for_each_entry_safe(piocb, tmp_iocb,
+					 &phba->fabric_iocb_list, list) {
+			cmd = &piocb->iocb;
+			list_del_init(&piocb->list);
+			list_add_tail(&piocb->list, &abort_list);
+		}
+	}
+
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_unlock(&pring->ring_lock);
 	spin_unlock_irq(&phba->hbalock);
 
-	/* Cancell all the IOCBs from the completions list */
+	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &abort_list,
 			      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
 
-- 
2.13.7

