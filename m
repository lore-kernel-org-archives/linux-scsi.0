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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81CEC32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C8EC20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jnw1O9Yx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbfHNX5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42023 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbfHNX5o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:44 -0400
Received: by mail-pg1-f195.google.com with SMTP id p3so412376pgb.9
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pKKwpmu7+LJP10oCTEtrsz/Dck9zTl6D1XRMxRIgWIE=;
        b=Jnw1O9YxFoBz9PWFL8DFrfwL4Z8gJPewAypOii85+e78gaay1S8QWL2+oM3vbdhGVw
         YUpHu7TVtoIItdDe2u8bj21j2HXo0QvdhQeWFqgZHiLWZzdkEhnfLTvLg/ycFK2CgOFJ
         DECEQGKhhaFnCwqmXBQ791iMZRvse2wyj6xAtIOK1uWSVx8PW9lbuVoiPCSxOuuXy1ZF
         A0zv53ZlkXFVkGvX0fJs3bdfAPYkf/5Mj8REc6EirR9hhJwNz29oK0zi4lk6W7bWWlbq
         XjDibsR4aqXuKg/Wz5gxbyDjiZUm7Hkkdyf3X5le5ZgLrgzuTAabfO4efs90ppQfWJCM
         qzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pKKwpmu7+LJP10oCTEtrsz/Dck9zTl6D1XRMxRIgWIE=;
        b=NXN56Sr88YM775DmojPvu6ZxLuxZNYrc/KMDptp6NqH7rgobJqxj6NQHSpoVv/LG2G
         t27aQBZ86PcNBlLVcsVFZf7MGUI9S4M60N5dUPjCxU9fI/hxnrb0Bln630ZOTC8FDHJ3
         n79F0ZsF6KvTUVX5quQLHzXYcIkIkCzdvZEQ6XgKxHu4AJXioRoM/9GuCHYh7EMtxE/b
         b+kjb5EZwYSyP84/e5nmJeumow+wNFM0gnz75fZRN5YCUH6jeViwEDFzaKC5EmQ2c5i9
         Gx0LYAky88zN7EZiCssld83pXIBWCryJKH1QcWSA7QQIPUG0XA3eFmCZUg/ypzScPAMy
         rVLg==
X-Gm-Message-State: APjAAAWa3KiPQiDR6xbOHeSxRor4PeouEIbpHJzPOK76aWkfP7XaueYH
        wXqe8y6ynPV8EjG8+FqdJJX5WqGk
X-Google-Smtp-Source: APXvYqyeWp8ylIr3RsKeIgcLwoPqenPlvJKtvQVf5YWeEhjm4TYSSa7IGCSRncd1nWTlnfUE99dk/g==
X-Received: by 2002:a17:90a:1d8:: with SMTP id 24mr449192pjd.70.1565827064068;
        Wed, 14 Aug 2019 16:57:44 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:43 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 28/42] lpfc: Fix sli4 adapter initialization with MSI
Date:   Wed, 14 Aug 2019 16:56:58 -0700
Message-Id: <20190814235712.4487-29-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When forcing the use of MSI (vs MSI-X) the driver is crashing in
pci_irq_get_affinity.

The driver was not using the new pci_alloc_irq_vectors interface
in the MSI path.

Fix by using pci_alloc_irq_vectors() with PCI_RQ_MSI in the MSI path.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1e43890f9ae1..7227bd46244d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11140,10 +11140,10 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI interrupt mode to device with
- * SLI-4 interface spec. The kernel function pci_enable_msi() is called
- * to enable the MSI vector. The device driver is responsible for calling
- * the request_irq() to register MSI vector with a interrupt the handler,
- * which is done in this function.
+ * SLI-4 interface spec. The kernel function pci_alloc_irq_vectors() is
+ * called to enable the MSI vector. The device driver is responsible for
+ * calling the request_irq() to register MSI vector with a interrupt the
+ * handler, which is done in this function.
  *
  * Return codes
  * 	0 - successful
@@ -11154,20 +11154,21 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 {
 	int rc, index;
 
-	rc = pci_enable_msi(phba->pcidev);
-	if (!rc)
+	rc = pci_alloc_irq_vectors(phba->pcidev, 1, 1,
+				   PCI_IRQ_MSI | PCI_IRQ_AFFINITY);
+	if (rc > 0)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0487 PCI enable MSI mode success.\n");
 	else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0488 PCI enable MSI mode failed (%d)\n", rc);
-		return rc;
+		return rc ? rc : -1;
 	}
 
 	rc = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
 			 0, LPFC_DRIVER_NAME, phba);
 	if (rc) {
-		pci_disable_msi(phba->pcidev);
+		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0490 MSI request_irq failed (%d)\n", rc);
 		return rc;
-- 
2.13.7

