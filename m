Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD781C3A5A6
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 848A120820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EINpZfwm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfIVD7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:31 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40017 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfIVD7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:31 -0400
Received: by mail-oi1-f194.google.com with SMTP id k9so4987161oib.7
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PODCCYMxxLrgSWb8BaXykQR8NPa5pu1msdUczHRp/pA=;
        b=EINpZfwmxGw7rQ3kvfQplOUZjZ6XkOY8iD2ikSg3KXMUMdLnTvtfMDLn/XrxdCDBZN
         /ipBfwCfwtdbuXSbG1+Z3syzorNnAJ8s47Y9zmSGjLbxngFFTbXJDAYKVnd+rYgbPl/a
         1pxWmWt6FjVAUqArf2IsjaHlimiHToWldDsabJgyvGZ/PTlJIMSb8rHN1kFCTZLdlYDA
         nLy83JlosCp/0T48jWK3MlwZ2SE0LyFDgKkjK8aaNvnJ0RJntZ3t97G8qadAjUQQGJly
         nuWAjqw+HvR/4hYIYO86R7spfpObBfq+5aVVt7+RomygeH65/ldYOHySRlZ3WQV3jSvn
         SWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PODCCYMxxLrgSWb8BaXykQR8NPa5pu1msdUczHRp/pA=;
        b=iqTVtHXx+VB75xDpwPd+D5kWTp7CKqEEDlHYnlXtIgv8ePQsxSiXNOE/h0Enc8uLcR
         8NSHCiI/jBO7czGDNjrQyk4hvTwQvHYEcqoS3QCB5TXdYXmb9sGsyi5QDRB1mtQJ4HVf
         ULfXwVSi2AFfWBXOsw4hGq11ECI8h6L3y+NrsRQNPwnjiXhuzZ0AUTN1nGo8VF8YBxwt
         xTUeJyiNCy3CVzPHFHaJF7J/Im+9QFq/bfLdh5umMCRJu+FWjK3AzZzsF1YZPe7U1aBV
         SUbjfVTKNk2SxXm4QIWC5ZC67ZPuDT9oPmTmTRVxx6npn8K6nnzGZaOi7K9TOM8nzuvf
         bVLA==
X-Gm-Message-State: APjAAAUsZp3lKb2zQR1fYkCDQ+x5Os6N4hZOgS4CvhlDdfY85I3n3heN
        GnXBor7OVDqMVKujzYceBQnK3i56
X-Google-Smtp-Source: APXvYqxKt9QDEKKDDOc0PT0NuNFyK5DWWq6xzMlLcc4gu4w8flaELOOs/jqva6d1lMDleE/CXd44BA==
X-Received: by 2002:aca:cfc9:: with SMTP id f192mr9403754oig.26.1569124770880;
        Sat, 21 Sep 2019 20:59:30 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:30 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 14/20] lpfc: Fix spinlock_irq issues in lpfc_els_flush_cmd()
Date:   Sat, 21 Sep 2019 20:59:00 -0700
Message-Id: <20190922035906.10977-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While reviewing the CT behavior, issues with spinlock_irq were
seen. The driver should be using spinlock_irqsave/irqrestore in
the els flush routine.

Changed to spinlock_irqsave/irqrestore.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index bd8109b2a083..da90c7bf2287 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7991,20 +7991,22 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	IOCB_t *cmd = NULL;
+	unsigned long iflags = 0;
 
 	lpfc_fabric_abort_vport(vport);
+
 	/*
 	 * For SLI3, only the hbalock is required.  But SLI4 needs to coordinate
 	 * with the ring insert operation.  Because lpfc_sli_issue_abort_iotag
 	 * ultimately grabs the ring_lock, the driver must splice the list into
 	 * a working list and release the locks before calling the abort.
 	 */
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	pring = lpfc_phba_elsring(phba);
 
 	/* Bail out if we've no ELS wq, like in PCI error recovery case. */
 	if (unlikely(!pring)) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		return;
 	}
 
@@ -8045,21 +8047,21 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_unlock(&pring->ring_lock);
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	/* Abort each txcmpl iocb on aborted list and remove the dlist links. */
 	list_for_each_entry_safe(piocb, tmp_iocb, &abort_list, dlist) {
-		spin_lock_irq(&phba->hbalock);
+		spin_lock_irqsave(&phba->hbalock, iflags);
 		list_del_init(&piocb->dlist);
 		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 	if (!list_empty(&abort_list))
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "3387 abort list for txq not empty\n");
 	INIT_LIST_HEAD(&abort_list);
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
@@ -8099,7 +8101,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_unlock(&pring->ring_lock);
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &abort_list,
-- 
2.13.7

