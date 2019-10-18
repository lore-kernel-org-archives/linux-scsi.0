Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6DDCA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22BDD2089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IsJkzG0Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440302AbfJRVSv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:18:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43699 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390763AbfJRVSv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:18:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id i32so4009068pgl.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qr9x4B4M5vOln2YofHmfuK0eyIF+f9D+/3jFtJyFoDs=;
        b=IsJkzG0YGoFDNynrUG/nAqX76jPblQs52xFykQJOWVfIUURP4ErlyY6cq22wyH6kD5
         Rb799HbwdezrwCajSBSG4WFuvF/vpVqOwBA8lccHkySasuJA0IyvKzRhojpmoqO67Ipp
         0H+zxB2HJt/SZC3AJJQK894wO+sixMG7of02RH3cfl1pD+Mo/fVzvq5qcm66LzKU2OLp
         +SqKCyvkVgyMpkKyQm/AQ7MorY9rGgQ+Mtge9mU8lkBAZe5Zbo9JgKpjcLGFvBEr5OtQ
         QeeteSWizg03+xvs+P/bU86vATMGBBQyvi/2NZX5GCc7O4rzEIOslvY9o7i34jiGgg2+
         DvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qr9x4B4M5vOln2YofHmfuK0eyIF+f9D+/3jFtJyFoDs=;
        b=etUltuuW1trIEhBjNSzeKDF26mhxIB6kP7cwm7LbpzTPhokeqHNb4S3v57yW4DA21d
         /tG3Dusw7keEhIjDNXV9P4TYqXEz8qtsF2UGibZuTU4BdIeBWSCNKOAjthdaJs9jE9gE
         4kMRHkoPeHA4JTLOCqSQLRfLLsl5qorg0PBToyhxucym3U4BLOVArA5A41Op26GTcA0B
         v3IzQ4sZaHTY+PyzTlyHULwonyQx/tOpzb7Ta9zLrM0OFdItne6Lg//CX0f2ln11qH/Q
         Ppyi+Ygd2WpSsEGVG+IHY1spozpTMLVzhF0X1/upw5ccf5KBk+TMEn985SeNfYjoojhb
         ulwA==
X-Gm-Message-State: APjAAAV2VFSHQZrbHyAPl3P/U8nZ5xO+O3gHi+MdkskdNRREfH291bGq
        rz0l6ALNn65ibFyPLZglNxV30UnS
X-Google-Smtp-Source: APXvYqx0mDLxbZwJ4Z5PtR9TXfioN4ZENjR1vzFa2mJ43O9Vr2CxQ1esxYfJkZo+39itHmZu+L/hkQ==
X-Received: by 2002:aa7:9a0c:: with SMTP id w12mr8957404pfj.81.1571433530922;
        Fri, 18 Oct 2019 14:18:50 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.18.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:18:50 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/16] lpfc: fix lpfc_nvmet_mrq to be bound by hdw queue count
Date:   Fri, 18 Oct 2019 14:18:17 -0700
Message-Id: <20191018211832.7917-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, lpfc_nvmet_mrq is always scaled back to the
min(lpfc_nvmet_mrq, lpfc_irq_chann). There's no reason to reduce
it to the number of interrupt vectors.  Rather, it should be scaled
down based on the number of hardware queues for the system (if lower
than max of 16).

Change scaling to use hardware queue count rather than
interrupt vector count.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 6 +++---
 drivers/scsi/lpfc/lpfc_init.c | 6 ++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e4c89e56c632..266a71b01c47 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -7264,11 +7264,11 @@ lpfc_nvme_mod_param_dep(struct lpfc_hba *phba)
 		}
 
 		if (!phba->cfg_nvmet_mrq)
-			phba->cfg_nvmet_mrq = phba->cfg_irq_chann;
+			phba->cfg_nvmet_mrq = phba->cfg_hdw_queue;
 
 		/* Adjust lpfc_nvmet_mrq to avoid running out of WQE slots */
-		if (phba->cfg_nvmet_mrq > phba->cfg_irq_chann) {
-			phba->cfg_nvmet_mrq = phba->cfg_irq_chann;
+		if (phba->cfg_nvmet_mrq > phba->cfg_hdw_queue) {
+			phba->cfg_nvmet_mrq = phba->cfg_hdw_queue;
 			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
 					"6018 Adjust lpfc_nvmet_mrq to %d\n",
 					phba->cfg_nvmet_mrq);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a0aa7a555811..d2cb3b0d1849 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8630,8 +8630,8 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 	 */
 
 	if (phba->nvmet_support) {
-		if (phba->cfg_irq_chann < phba->cfg_nvmet_mrq)
-			phba->cfg_nvmet_mrq = phba->cfg_irq_chann;
+		if (phba->cfg_hdw_queue < phba->cfg_nvmet_mrq)
+			phba->cfg_nvmet_mrq = phba->cfg_hdw_queue;
 		if (phba->cfg_nvmet_mrq > LPFC_NVMET_MRQ_MAX)
 			phba->cfg_nvmet_mrq = LPFC_NVMET_MRQ_MAX;
 	}
@@ -11033,8 +11033,6 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 				phba->cfg_irq_chann, vectors);
 		if (phba->cfg_irq_chann > vectors)
 			phba->cfg_irq_chann = vectors;
-		if (phba->nvmet_support && (phba->cfg_nvmet_mrq > vectors))
-			phba->cfg_nvmet_mrq = vectors;
 	}
 
 	return rc;
-- 
2.13.7

