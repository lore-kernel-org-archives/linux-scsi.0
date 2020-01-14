Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B8DC33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E0924676
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Wo5pdU02"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgANLWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:22:15 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50843 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANLWP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:22:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id a5so13317712wmb.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K3KQItSsU/uSAtTpUNi8r57iE2Zbw+z7P6QwToqrP+w=;
        b=Wo5pdU028gEHOaE8+VQ1CF5gmatxAGsoh5m+/75Mtk5a5qzgO0XFvewbfQj71mifRH
         ifN6ef0P7H12/Zl66onGcVjKRkY8M61/Y1cIwg1EFnWnxDUqpUN3Ajp2Q0SA1hPc/PC5
         rt4glY/YanQhr5yXkIGa/HMzrh1E+gBOEJu2w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K3KQItSsU/uSAtTpUNi8r57iE2Zbw+z7P6QwToqrP+w=;
        b=RnL7JykQ/4WIRuGVa896dVtdfRqOMQwGWd3los9ymsLBJojqNDJwGfzZUIIBaR4rEW
         GB7YFMv+4CD5/3W4SodLouE1diB5apVQO0bxe5f8EFX25ONuN3QogwV3D1QLoZyJ4flF
         nRTU3DZkLUgwmGvqhaByFg7cVgVYxe2oBcqs7okewPQy95WIfGr61DcXvEWkBuqZfvA9
         U9fCqZ3EEGnGOBe+kvvJKVrfm76oB8TS9Ql4bE5i5pB6o43K/qzQr8KK154CIPZNBvpL
         m8Jz3rkVw4UEdqozgauT6bDGcVrESC3NUBb+olDZqcGia/itrBJeygwUjwDR8FONWV7P
         1TJg==
X-Gm-Message-State: APjAAAVdLwItWEF8vTID4NS0zpf91H8WUELMksBF5B7WCVgWFlF5a/T7
        YYb0j95XJh6/JmoJFiObdFhnJ9KpCFjSKVBRVcFkaONXbqWcIZYhIb/ZPQBAMVJST4wnC9a3pFh
        BhrieAtpn1UPRuvp0PJqm7X6aQKe/cyYer7LVChu3fTL7b0oA0xlXk3l5CfD3q5LPRBLDzgXtpc
        0N9RqW9Q==
X-Google-Smtp-Source: APXvYqxLjte4LQ26UOSZLAXZs/VUErt+b3BqNkkhiBmTS4LaDqyCnGVx+7I8Ek5Ev77kvg6OOl8Hmw==
X-Received: by 2002:a1c:4b0a:: with SMTP id y10mr27490348wma.78.1579000933343;
        Tue, 14 Jan 2020 03:22:13 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.22.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:22:12 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 01/11] megaraid_sas: Reset adapter if FW is not in READY state after device resume
Date:   Tue, 14 Jan 2020 16:51:12 +0530
Message-Id: <1579000882-20246-2-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After device resume we expect the firmware to be in READY state.
Transition to READY might fail due to unhandled exceptions,such
as an internal error or a hardware failure.Retry initiating chip
reset and wait for the controller to come to ready state.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a4bc814..96b893f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7593,6 +7593,7 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	int irq_flags = PCI_IRQ_LEGACY;
+	u32 status_reg;
 
 	instance = pci_get_drvdata(pdev);
 
@@ -7620,9 +7621,35 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
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
+			if (!(status_reg & MFI_RESET_ADAPTER) ||
+				((megasas_adp_reset_wait_for_ready
+				(instance, true, 0)) == FAILED))
+				goto fail_ready_state;
+		} else {
+			atomic_set(&instance->fw_reset_no_pci_access, 1);
+			instance->instancet->adp_reset
+				(instance, instance->reg_set);
+			atomic_set(&instance->fw_reset_no_pci_access, 0);
+
+			/* waiting for about 30 seconds before retry */
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

