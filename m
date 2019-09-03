Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CD3C3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 21:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4C1122CF7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 21:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c/Jihop+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfICVyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 17:54:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44830 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfICVyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2019 17:54:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id q21so6713466pfn.11
        for <linux-scsi@vger.kernel.org>; Tue, 03 Sep 2019 14:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FwFUaBbytXYWYxey+xP5r7CeZpfOBkFBHTMHIejSy14=;
        b=c/Jihop+1an98mqOzTfXjPwBtd5snNhQJJoUp8Vi1MVCvg7LayCZ8gQXhJOangWFKR
         7BINPFotCnB2WCbIigDNge4QtIjxaKKS213T1sWsZ/yMhPugGuQC3+Ylg+oJZUWxRMBx
         Lk+wJezUoHYlr3mAKyqKJIqQl+ZNeJbJdpVwwb+U5bm8rnXu3/y2w2Itr71F78VSObFg
         lECv3mnxg9wKoK0HNimMEma/bs9pJk+vn4tDfhVRt0CHaPhrgDnlmBPtK4oIA5M9yEiu
         tfjOHwdjHggavNB0+POS+bf4rATihhKP/ScEf2/D6e+mt2QUD7NMQrLL5RU8hk1fQAfS
         83xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FwFUaBbytXYWYxey+xP5r7CeZpfOBkFBHTMHIejSy14=;
        b=Vl8IMFNbRyXF5ZB6NIUVUs2aik8B/IHODW4kHwGcZ+zn8cd5gRhsA081Z2JbOhBZax
         IbF1CTA1DW9NYNCyjztBO275XtfolA2C9zSjKSGAgcivlgDz3nQ3XGrlFfBK//Ab7pZB
         o4Dy3SgdzpLcJNXVV/sXXFOz1m53lx6/RMnzB0rkvzDl2/tus98ac29lGrZr9ZPdpVkv
         zOVRXHQVHB9DGuBOkExEUSfZ7NXyCg+2ckOSe7eCdTAwSKsKUj+AjLGuEvgOBia5wLqs
         ZMgnqEs5XTo5Nkpi3wuVxKH/x+VeN99Bt8+mvhMfVXBB+5a8vUvR0d3IFv5CKiCDxxyB
         wrVA==
X-Gm-Message-State: APjAAAUKpf+e1CD7nTdbydZVN882Qq5US+QDQC6gFHEYeUqHsH9OhanA
        /N2o+Y5iZwbINbu43KX0SDc4nrnr
X-Google-Smtp-Source: APXvYqxrbknR64XAJ7x+lIzduWErqzRrHBAXp1+P/hKwiJoKpphO70TnJFPRXWvPECElKuBbB4EdBw==
X-Received: by 2002:a65:5289:: with SMTP id y9mr32252520pgp.445.1567547692222;
        Tue, 03 Sep 2019 14:54:52 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u9sm490162pjb.4.2019.09.03.14.54.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 03 Sep 2019 14:54:51 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: Fix reset recovery paths that are not recovering
Date:   Tue,  3 Sep 2019 14:54:41 -0700
Message-Id: <20190903215441.10490-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A recent patch unconditionally marks the hba as in error as part
of resetting the adapter. The driver flow that called the adapter
reset was a recovery path, which expects the adapter to not be in
an error state in order to finish the recovery.  Given the new error
state being set, the recovery fails and the adapter is left in limbo.

Revise the adapter reset routine so that it will only mark the
adapter in error if it was unable to reset the adapter.

Fixes: 8c24a4f643ed ("scsi: lpfc: Fix crash due to port reset racing vs adapter error handling")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
Indicated commit that is fixed is only in 5.4/scsi-queue
---
 drivers/scsi/lpfc/lpfc_sli.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bb5705267c39..75bb75800642 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4619,8 +4619,10 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 	hba_aer_enabled = phba->hba_flag & HBA_AER_ENABLED;
 
 	rc = lpfc_sli4_brdreset(phba);
-	if (rc)
-		goto error;
+	if (rc) {
+		phba->link_state = LPFC_HBA_ERROR;
+		goto hba_down_queue;
+	}
 
 	spin_lock_irq(&phba->hbalock);
 	phba->pport->stopped = 0;
@@ -4635,8 +4637,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 	if (hba_aer_enabled)
 		pci_disable_pcie_error_reporting(phba->pcidev);
 
-error:
-	phba->link_state = LPFC_HBA_ERROR;
+hba_down_queue:
 	lpfc_hba_down_post(phba);
 	lpfc_sli4_queue_destroy(phba);
 
-- 
2.13.7

