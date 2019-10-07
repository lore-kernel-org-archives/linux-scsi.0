Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB4BC4740A
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 05:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AC292133F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 05:19:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Hkr1guOb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfJGFTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 01:19:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42495 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfJGFTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 01:19:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id z12so7449676pgp.9
        for <linux-scsi@vger.kernel.org>; Sun, 06 Oct 2019 22:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qXA+01WHS+GLDf5eh/By648hf9/axC1w1KouXB/AWDY=;
        b=Hkr1guOb0/cR+hbDievtvl33bWb3xtj7gvJy+Ej0KAxfV2rRyzypa53CM9pk7r7jNC
         kyTLXPM+7hmJ+o0R4Tic1Rejg7Y07Jia+yjU0bS+dgF2YNAweYeF/tlldoY7zO82Jxnd
         pFQ+orVxd8kR3s/8ZJibh25RHnkLW7ENE+MBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qXA+01WHS+GLDf5eh/By648hf9/axC1w1KouXB/AWDY=;
        b=qBkTaS8kKGudyTwV2tjIUtUpQxoyyGHXeH/coRn9NhqpYa5PM33T+L/7pT9DsAUi5z
         OS/GXWe2TjRR4G5B1uAWtt6XEvjouxUp8C9ZTdAKFUVbGOt8bBBo3lsztV1Zm3OMiDSr
         sgW3o9xK7B9rT4JdcWQqmwy5gHhG5C+0dahztzH0qY3r7t+xCrx6BakcN9Y75owfdAoN
         /kTGAR4AatoHfSZo4EdeqUSj+GXCMPxYMhV352F1JJHbJQKA5O1LEakKF2NNZij4uwg5
         Usw4D4Sz7YOi09E/tD+PABKko3xc7bxNPtnN0BDDBAeY49qk8wW0gq25HgzdP53d4Mlz
         YRrQ==
X-Gm-Message-State: APjAAAXqnDgA80qSBWsPcYi2kEy5CkCtCQuzUJVItOO48CJ2Z6lwFAUz
        JZYiimVZO+sWFyTJ2FLCjDx2DbAeZ2Z7jLrr6zFETScPuphaIh/ePN9NNpiAss8HNKoGI1l+ov/
        jf5C5RB2lvWSvnmHFObYlx+mcwHr64roRG/LoZUbdM93upmMimcyaBQbZGirLCtDEafr4YknG+l
        yLkydTMIcPWA==
X-Google-Smtp-Source: APXvYqz7QiG5I/VhRRw3w0R2jtOUHQy/uMG0jptd77p/JoCu3H940n/FmH8+g/8hmA+Tl5Nwfp0xcg==
X-Received: by 2002:a63:1720:: with SMTP id x32mr28336323pgl.289.1570425542264;
        Sun, 06 Oct 2019 22:19:02 -0700 (PDT)
Received: from dhcp-10-123-20-55.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f62sm14245046pfg.74.2019.10.06.22.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2019 22:19:01 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        sankar.patra@broadcom.com, sasikumar.pc@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2] megaraid_sas: unique names for MSIx vectors
Date:   Mon,  7 Oct 2019 10:48:28 +0530
Message-Id: <20191007051828.12294-1-chandrakanth.patil@broadcom.com>
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

v2:

     - MEGASAS_MSIX_NAME_LEN macro changed from 16 to 32.
     - Format spectifier for scsi host_no changed from %d to %u.
---
 drivers/scsi/megaraid/megaraid_sas.h      | 3 +++
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index a6e788c..bd81840 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -24,6 +24,8 @@
 #define MEGASAS_VERSION				"07.710.50.00-rc1"
 #define MEGASAS_RELDATE				"June 28, 2019"
 
+#define MEGASAS_MSIX_NAME_LEN			32
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
index 42cf38c..713d04e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5546,9 +5546,11 @@ megasas_setup_irqs_ioapic(struct megasas_instance *instance)
 	pdev = instance->pdev;
 	instance->irq_context[0].instance = instance;
 	instance->irq_context[0].MSIxIndex = 0;
+	snprintf(instance->irq_context->name, MEGASAS_MSIX_NAME_LEN, "%s%u",
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
+		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN, "%s%u-msix%d",
+			"megasas", instance->host->host_no, i);
 		if (request_irq(pci_irq_vector(pdev, i),
-			instance->instancet->service_isr, 0, "megasas",
+			instance->instancet->service_isr, 0, instance->irq_context[i].name,
 			&instance->irq_context[i])) {
 			dev_err(&instance->pdev->dev,
 				"Failed to register IRQ for vector %d.\n", i);
-- 
2.9.5

