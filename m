Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3BEC2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4ED821835
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:33:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QA+0ggFp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgACLdb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:33:31 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44124 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbgACLdb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:33:31 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so23316338pgl.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LgyCBCwMEjWZSAmvrSz4sCeou4b/HqUhMDjoDHzocgs=;
        b=QA+0ggFpyxtqYlMVrZh+7ZFqJhaQ7puwykO/D2OkIQGJ7cfjPL4+30wkMJ6Iuxv5ke
         vGyWvSX1+E+v9IqehucJPF0TkrGi9z8wtuhgmv4k0R05mAi/A6qpl1CUo8skmjoYwz8T
         CeGOqWyKJx5wxYAqEBqyHSeGev6XxhP5ZN32w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LgyCBCwMEjWZSAmvrSz4sCeou4b/HqUhMDjoDHzocgs=;
        b=bM5O2QXtPqUmyFFrwYeHhi+HN5xcxkdz/iK/omEkAXXR9nZhvAPuO2qPI6qL76Mujg
         iIznXXSavsayGJjLjsXo03LZekCCjTbxGdNlB/w1xa4JPpOEFt9KK3rcMUmwR9iakEpw
         vbXubyDSOKNWfHKJjfl5lxfEWFto3VPZ9YrfwZ+e7lRR4n3CxrTk9VwKqA48nkObB008
         eDXpCXld4/tYYFcKfRutlwkONixIN3YfDfFP0KAzvi6nujM4+v3ODJcXmjSUS79ljol0
         SscrS9iweoFMt3aWbgEdtPKHii04bEea1O18585UniBF1k5glK3WRyfaAUdkyxjIoMwo
         SeOg==
X-Gm-Message-State: APjAAAWq/o9Sc1UUNB/uVYqRJPm5PTS4dlQvMgEb/pm7sjG3aKf4/CeA
        hENwrKfis2Y+G/RjnVzThnic1vN6+GY9HB7Jm6U4S9kQBtzdvfWCFZT0/Qvr9GJAiux4Jc22M1v
        gJJim5t378EuBMagW/KGJslKjUL5+WUAoxwXkXjUs9qxstUnlq1sj0K7jA+fzcqRZz6OU5kuj9j
        hDLTYnLg==
X-Google-Smtp-Source: APXvYqzaB7RaqVLJV/B/JQxe+q6N/qVPsmzpgTL1oeJnO6wmXusX033s9ecqtnZw7+OYnxN23ubu8w==
X-Received: by 2002:aa7:820d:: with SMTP id k13mr97083259pfi.10.1578051210442;
        Fri, 03 Jan 2020 03:33:30 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.33.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:33:29 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 01/11] megaraid_sas: Add transition_to_ready retry logic in resume path
Date:   Fri,  3 Jan 2020 17:02:25 +0530
Message-Id: <1578051155-14716-2-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 34 +++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a4bc814..b5f0221 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7593,6 +7593,7 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	int irq_flags = PCI_IRQ_LEGACY;
+	u32 status_reg;
 
 	instance = pci_get_drvdata(pdev);
 
@@ -7620,9 +7621,38 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	/*
 	 * We expect the FW state to be READY
 	 */
-	if (megasas_transition_to_ready(instance, 0))
-		goto fail_ready_state;
 
+	if (megasas_transition_to_ready(instance, 0)) {
+		dev_info(&instance->pdev->dev,
+			 "Failed to transition controller to ready from %s!\n",
+			 __func__);
+		if (instance->adapter_type != MFI_SERIES) {
+			status_reg =
+			instance->instancet->read_fw_status_reg(instance);
+			if (status_reg & MFI_RESET_ADAPTER) {
+				if (megasas_adp_reset_wait_for_ready
+					(instance, true, 0) == FAILED)
+					goto fail_ready_state;
+				} else {
+					goto fail_ready_state;
+				}
+		} else {
+			atomic_set(&instance->fw_reset_no_pci_access, 1);
+			instance->instancet->adp_reset
+				(instance, instance->reg_set);
+			atomic_set(&instance->fw_reset_no_pci_access, 0);
+
+			/*waitting for about 30 second before retry*/
+			ssleep(30);
+
+			if (megasas_transition_to_ready(instance, 0))
+				goto fail_ready_state;
+		}
+
+		dev_info(&instance->pdev->dev,
+			 "FW restarted successfully from %s!\n",
+			 __func__);
+	}
 	if (megasas_set_dma_mask(instance))
 		goto fail_set_dma_mask;
 
-- 
1.8.3.1

