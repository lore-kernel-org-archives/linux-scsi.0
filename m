Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D0EC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2FC360EB6
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhGVVhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 17:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbhGVVg7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 17:36:59 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806EBC061575
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:33 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso4649298pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zsyIjXE4sd+BqrKXvg7gRp6u/RTo7xDW0Yih7Gobli8=;
        b=Z1Ahi8Tp8Q35Hqc/esMzy5PDrKobmlxhzqEOFuUTrXXcUSx5BsBBHQu2kqBm3GspJA
         TlWXtLC0IxIaz2g/c6Slh2vG92hksxwj0JAOJabykt+U2ctEn82IBmsMnuJYl7h9WflG
         r7H7FIMPTL4L2XkipW9UjGbpAZ+9ddW5rIM7aWD4JgofyHLbn1fEbModik6LSb5XcAUe
         dLYIjIlleMyV6RvpEOgFSmYlCaudz9VlnMNk1SfhdBKdb2hjIKhByjRtPIQVhxQLxvTg
         Z0iEMN0fSNB+j3g46IocNx3biZ4zJDprlns3KdT4hwSTrVNP7I23IX59hrDO2IVoLQUF
         UjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsyIjXE4sd+BqrKXvg7gRp6u/RTo7xDW0Yih7Gobli8=;
        b=NCKPwhMS9PMJDpNX/1rvDV+EZB42eordWIrccT6zLUqLKzTmeufkop7pK/bNoSzvvV
         rPPcqDeNxEywXHV7Qlmp6FdIQmG6rdhPQAqwrDL/pTwAvdIopaJXI5pEtNgIoRPXLsA6
         hlnI/qpGExc2phKWPwo4ydWyQExQEBAnrX/zxBxzSrNKyMb9zO6BanF16gw0/FeFgFrP
         hD6aD1pbug7446o/+Dp5K5JMWSq/YXwSbk4euiB8k70eHHgWQ9FhdfdsNnt1UM1rHbd8
         uFl0GdDKYtaP13Vc5QJs8ClrWvbADpWQQG6cz6GZAbNNy2Wh7KPI0S2EyH9PNTSAygk8
         U/fQ==
X-Gm-Message-State: AOAM532lWxj+akZl+kYcnzwetfjBNgsRwpIcsAOlmtYuX8E7eTqSO3pE
        4eJYKhrSbFtUxFenTCzok5YcCqKBXIU=
X-Google-Smtp-Source: ABdhPJwecOr903aUvQgqpsKASuJ7JS3LihBRTI6LEgyKOMuLAh8Bseb0hf+Dk41/rj+ORnwkpfhYlA==
X-Received: by 2002:a17:90a:ce04:: with SMTP id f4mr1763544pju.1.1626992252988;
        Thu, 22 Jul 2021 15:17:32 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a18sm31374460pfi.6.2021.07.22.15.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:17:32 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 1/6] lpfc: Add pci id support for LPe37000/LPe38000 series adapters
Date:   Thu, 22 Jul 2021 15:17:16 -0700
Message-Id: <20210722221721.74388-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210722221721.74388-1-jsmart2021@gmail.com>
References: <20210722221721.74388-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update supported pci_device_id table to include the values for the
G7+ Asic Device ID utilized by LPe37xxx and LPe38xxx series
of adapters.  The default reporting string will be "LPe38000".

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw.h   | 1 +
 drivers/scsi/lpfc/lpfc_ids.h  | 2 ++
 drivers/scsi/lpfc/lpfc_init.c | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 4a5a85ed42ec..476d17708157 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1694,6 +1694,7 @@ struct lpfc_fdmi_reg_portattr {
 #define PCI_DEVICE_ID_LANCER_FCOE_VF 0xe268
 #define PCI_DEVICE_ID_LANCER_G6_FC  0xe300
 #define PCI_DEVICE_ID_LANCER_G7_FC  0xf400
+#define PCI_DEVICE_ID_LANCER_G7P_FC 0xf500
 #define PCI_DEVICE_ID_SAT_SMB       0xf011
 #define PCI_DEVICE_ID_SAT_MID       0xf015
 #define PCI_DEVICE_ID_RFLY          0xf095
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index d48414e295a0..72ad9ecb87ab 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -118,6 +118,8 @@ const struct pci_device_id lpfc_id_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G7_FC,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G7P_FC,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 65a7c564f1d6..f08129c67a2e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2599,6 +2599,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 	case PCI_DEVICE_ID_LANCER_G7_FC:
 		m = (typeof(m)){"LPe36000", "PCIe", "Fibre Channel Adapter"};
 		break;
+	case PCI_DEVICE_ID_LANCER_G7P_FC:
+		m = (typeof(m)){"LPe38000", "PCIe", "Fibre Channel Adapter"};
+		break;
 	case PCI_DEVICE_ID_SKYHAWK:
 	case PCI_DEVICE_ID_SKYHAWK_VF:
 		oneConnect = 1;
-- 
2.26.2

