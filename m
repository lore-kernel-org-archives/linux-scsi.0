Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B96C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB56B20809
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bHa20HIk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgG3IEZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgG3IEY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 04:04:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3702C0619D2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:23 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w2so16079539pgg.10
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1iVr+h4AIu5NlHCv7r2GRJVy1ku5y/jnGZ7EiMbfWE4=;
        b=bHa20HIkre/3sTEOqo6JjVErINioH6XDLuwu/vhigcX7wXwrJ9HsaswnzOy68d5pvL
         niQuYVD4qLcyNWwGkFPzYd7INkDRQO9uswq0L3Lrht27hxIgvYAc+dize/0uDnZ3JE5q
         9kxkj6F0VzO5j4D6kG43nEuQr6QXcuaDo/zWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1iVr+h4AIu5NlHCv7r2GRJVy1ku5y/jnGZ7EiMbfWE4=;
        b=HaWRb/vglIhGV0fmroY3qpgSSh1qW/yQ89bA79yeZicRPp1gkp8pYkjAKeUaBv2HHm
         Iwh56bjFQlFfdIuwD9xBIoL2J4H4K0Gmr+FR3J5Aw2pqGYHejSXFNWzNCUn4xX2p5yOP
         Zd5AwgMum+dOYy7Bf1QW9s+3Fvzknkm51LNCW7bBxdg08Zy6CfCxPjbXU1hmmPEhI/6a
         bXA+CaE+paYPt0gyPMGaxR1tfyWP8n+f223B3USEgPVDxv+SSK261svflNFlPAlqBPIX
         gswEkdQtb7qn9h1+wyuPqzQaXTVSvMgrcqRixI6sFHKFXh0XGAvX8qevQX/8a/qpMbHF
         BUfQ==
X-Gm-Message-State: AOAM5322q7tC/tUsJ75f2cSVEdfzhcvIUK4kS1BU0Ujtm79APiTHGsCT
        yaykQItxJ1Yy5or+ED711uo+dg==
X-Google-Smtp-Source: ABdhPJxdlgH8/gUOaYsIyB2NoZer3yPo0PDDMvrdswRGmnVUvbLZl0N8MmO8mLyb5tqx6FPNTYfq1Q==
X-Received: by 2002:a65:620e:: with SMTP id d14mr32843436pgv.360.1596096263235;
        Thu, 30 Jul 2020 01:04:23 -0700 (PDT)
Received: from localhost.localdomain ([192.19.212.250])
        by smtp.gmail.com with ESMTPSA id d13sm5051412pfq.118.2020.07.30.01.04.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 01:04:22 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 2/7] mpt3sas: Dump system registers for debugging.
Date:   Thu, 30 Jul 2020 13:33:44 +0530
Message-Id: <1596096229-3341-3-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When controller fails to transition to READY state during driver
probe, dump the system interface register set. This will give
snapshot of the firmware status for debugging driver load issues.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 96b78fd..b9d8f08 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5617,6 +5617,23 @@ _base_wait_on_iocstate(struct MPT3SAS_ADAPTER *ioc, u32 ioc_state, int timeout)
 	return current_state;
 }
 
+/**
+ * _base_dump_reg_set -	This function will print hexdump of register set.
+ * @ioc: per adapter object
+ *
+ * Returns nothing.
+ */
+static inline void
+_base_dump_reg_set(struct MPT3SAS_ADAPTER *ioc)
+{
+	unsigned int i, sz = 256;
+	u32 __iomem *reg = (u32 __iomem *)ioc->chip;
+
+	ioc_info(ioc, "System Register set:\n");
+	for (i = 0; i < (sz / sizeof(u32)); i++)
+		pr_info("%08x: %08x\n", (i * 4), readl(&reg[i]));
+}
+
 /**
  * _base_wait_for_doorbell_int - waiting for controller interrupt(generated by
  * a write to the doorbell)
@@ -6795,6 +6812,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 		if (count++ > 20) {
 			ioc_info(ioc,
 			    "Stop writing magic sequence after 20 retries\n");
+			_base_dump_reg_set(ioc);
 			goto out;
 		}
 
@@ -6823,6 +6841,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 		if (host_diagnostic == 0xFFFFFFFF) {
 			ioc_info(ioc,
 			    "Invalid host diagnostic register value\n");
+			_base_dump_reg_set(ioc);
 			goto out;
 		}
 		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
@@ -6857,6 +6876,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc_state) {
 		ioc_err(ioc, "%s: failed going to ready state (ioc_state=0x%x)\n",
 			__func__, ioc_state);
+		_base_dump_reg_set(ioc);
 		goto out;
 	}
 
-- 
2.26.2

