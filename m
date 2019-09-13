Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723FCC49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 06:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B48B2089F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 06:55:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EBlyIil9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfIMGzr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 02:55:47 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46040 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfIMGzr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 02:55:47 -0400
Received: by mail-pl1-f193.google.com with SMTP id x3so12821359plr.12
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2019 23:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xd51Y45uaCLoIVenNopa1Znhc8IGjKAK6/rDkOtlI+4=;
        b=EBlyIil9FYP40VoxON0glZmZv8lszdjUfT0f4DveKRh7sGA77e4elBDWS4N8N1Tn70
         NJe6SC8f70Pxt8y35x07OCzPqdEBYbnOuRLpEFjPl1GuAv2Nx8uhtd859+7NRfksUIDh
         GDCUnMaAsqIMLOWAiCSrXsC1FYGxUBIlJt8VE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xd51Y45uaCLoIVenNopa1Znhc8IGjKAK6/rDkOtlI+4=;
        b=NykmyY8NlJll9oVdlZvjcmhjq+M3xyNEVFraXXhG0hyYRXjYYuxqaT0LIdWGntuuLL
         zQ2yWpQ9bDOt1EMgFn6evtuX6WQ7HzHLdeuw4L3YV+HsRjAZKX7DDAgULBcKMSizQ8cC
         RBpa0ZbR3A/qTQnlk+SnQtcvK+33NJSUy3yo+JwgyBgci0dlprP1Sw0vfCtXMEJT3Z/S
         ykGok64Uf1IoQhEfjn9MKQGyohnbs+KeZTE46TA/ck6qT7o1xYFU24In7aJVHPQI9xCF
         4LmEF2wHYMC5D7blaM8IVfcTV8F89pAaftpGXVm50n/59nbTGoIZSSNN1y8/qkO8Db/T
         ysRQ==
X-Gm-Message-State: APjAAAVpSFsKQZ5NCXb+tdrNGtOA68y83zQdx0Hals/ufBFxeBedcBFy
        Oh2u7w0IjqpvX9ef8UO03LQMMyhNc5p2QAbeoSeXyhReSEZFnRcf/L9WXAQ3172d5pAVcTdrN1U
        gg4PGkKbb7stt9p4s8udLvIWEGqUxUeBJzo+oX1mZc7ume89shcu2utdaDoKIjho5NGiAqXf1X1
        GunwaH79v7nQ==
X-Google-Smtp-Source: APXvYqxIl/sAmWkd+Nnq9D93vbSzaQ9SZR3yKqdjV+8gzKc9Wl1Oa+1UaxPsSzmlDyDwq+wM4EgWRw==
X-Received: by 2002:a17:902:a98a:: with SMTP id bh10mr49586158plb.213.1568357746431;
        Thu, 12 Sep 2019 23:55:46 -0700 (PDT)
Received: from dhcp-10-123-20-55.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id s73sm1221583pjb.15.2019.09.12.23.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 23:55:45 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH] megaraid_sas: unique names for MSIx vectors
Date:   Fri, 13 Sep 2019 12:25:15 +0530
Message-Id: <20190913065515.22493-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, MSIx vectors name appears in /proc/interrupts is "megasas"
which is same for all the vectors. This patch provides the unique
name to all megaraid_sas controllers and its associated MSIx interrupts.

Suggested-by: Konstantin Shalygin <k0ste@k0ste.ru>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 3 +++
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index a6e788c..d194548 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -24,6 +24,8 @@
 #define MEGASAS_VERSION				"07.710.50.00-rc1"
 #define MEGASAS_RELDATE				"June 28, 2019"
 
+#define MEGASAS_MSIX_NAME_LEN			16
+
 /*
  * Device IDs
  */
@@ -2203,6 +2205,7 @@ struct megasas_aen_event {
 };
 
 struct megasas_irq_context {
+	char name[MEGASAS_MSIX_NAME_LEN];
 	struct megasas_instance *instance;
 	u32 MSIxIndex;
 	u32 os_irq;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 42cf38c..ebb3fc2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5546,9 +5546,11 @@ megasas_setup_irqs_ioapic(struct megasas_instance *instance)
 	pdev = instance->pdev;
 	instance->irq_context[0].instance = instance;
 	instance->irq_context[0].MSIxIndex = 0;
+	snprintf(instance->irq_context->name, MEGASAS_MSIX_NAME_LEN, "%s%d",
+		"megasas", instance->host->host_no);
 	if (request_irq(pci_irq_vector(pdev, 0),
 			instance->instancet->service_isr, IRQF_SHARED,
-			"megasas", &instance->irq_context[0])) {
+			instance->irq_context->name, &instance->irq_context[0])) {
 		dev_err(&instance->pdev->dev,
 				"Failed to register IRQ from %s %d\n",
 				__func__, __LINE__);
@@ -5580,8 +5582,10 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 	for (i = 0; i < instance->msix_vectors; i++) {
 		instance->irq_context[i].instance = instance;
 		instance->irq_context[i].MSIxIndex = i;
+		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN, "%s%d-msix%d",
+			"megasas", instance->host->host_no, i);
 		if (request_irq(pci_irq_vector(pdev, i),
-			instance->instancet->service_isr, 0, "megasas",
+			instance->instancet->service_isr, 0, instance->irq_context[i].name,
 			&instance->irq_context[i])) {
 			dev_err(&instance->pdev->dev,
 				"Failed to register IRQ for vector %d.\n", i);
-- 
2.9.5

