Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8719C6FA82
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 11:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiI1LBg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 07:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiI1LAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 07:00:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CA8A060C
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 04:00:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 8-20020a17090a0b8800b00205d8564b11so1353796pjr.5
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 04:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=hOXy/3B0e3cTGMIExCyp30h8nQPc8EN7HUScg4kF8wU=;
        b=hLncl5wigkp6LZxL1UHj5XXUDDZ7qtJq55Ge5vMbfW4Al2AGA2iQkMOvrdtdOf1VL2
         Rk/K/quMGIKxGPbpPAVJMtta7+wR+aeQCVaEZustg4IyVmieXUttW5qjciBXU//DM50q
         hGgVzPCREUx3DwaSPr8HwW088CPspOQqoZjpUpmyQMHz4xc+k6wRn2UheZ9k13pqJ4of
         S61hxLYNDw+33s1SeoYz6kEwxf25V4l4XlDghrJbkBTjFerJpQLwGBR528la4jpRrmBd
         c0uwJBogoeYHET4ns90XPd1dUcF8W6nI1xhKtZCRBBVuv2WRMWTiyUyYiZy/6E2YUYVj
         qoCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hOXy/3B0e3cTGMIExCyp30h8nQPc8EN7HUScg4kF8wU=;
        b=WqJWcaly+7cmEMED9zjzBxOm6WOyEe1twPdJ+WYX7ZsYwtQbd8VO7KnW9N+nGSP912
         xVb6A50bjj/9mxmwRpKSMXDpB3f5AKI5RYCcy8eq9nQL6e9w9D0Nur/hBp4FDRDJBlsG
         yMhQj15VpyIg4IwLlsLczhbdn6Iuw6bbQCeUKyACNw7b+nsRwEMdFRj/MR+xM5PATNA4
         +h12Ry/y5Mofuam80NMFhG0JyGNjAbg3YfZdDDjIUE4rSegNbqhtXBxrU15AHN0hLf9m
         kmPmZM27XCPG8C5qKnmMNIiMWQIJZgEMa9eHa/d+8JGacQWr3yk+fc3y9/VN/1OgxwVw
         8WIA==
X-Gm-Message-State: ACrzQf2l9XcbC8bFVigECF1Zc6z91vO0U4kE2Q+DmEAueq/Hd09yYqrW
        1FG6Zaz0dRfWQftIj4gnJ3LWzg==
X-Google-Smtp-Source: AMsMyM4zzBvJpGNUwArQu+atMDproDm1I0tlw6EBKQ2GB2pfCmWCLWQxTIq8rmIlylXF+q8NzyS4Lg==
X-Received: by 2002:a17:90b:374f:b0:205:e255:e8de with SMTP id ne15-20020a17090b374f00b00205e255e8demr6980382pjb.8.1664362821737;
        Wed, 28 Sep 2022 04:00:21 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b00177efb56475sm1539524plg.85.2022.09.28.04.00.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Sep 2022 04:00:21 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     sathyanarayanan.kuppuswamy@linux.intel.com, bhelgaas@google.com,
        ruscur@russell.cc, oohall@gmail.com, fancer.lancer@gmail.com,
        jdmason@kudzu.us, dave.jiang@intel.com, allenbh@gmail.com,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     chenzhuo.1@bytedance.com, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: [PATCH v3 3/9] NTB: Remove pci_aer_clear_nonfatal_status() call
Date:   Wed, 28 Sep 2022 18:59:40 +0800
Message-Id: <20220928105946.12469-4-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220928105946.12469-1-chenzhuo.1@bytedance.com>
References: <20220928105946.12469-1-chenzhuo.1@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need to clear error status during init code, so remove it.

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
---
 drivers/ntb/hw/idt/ntb_hw_idt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/ntb/hw/idt/ntb_hw_idt.c b/drivers/ntb/hw/idt/ntb_hw_idt.c
index 0ed6f809ff2e..fed03217289d 100644
--- a/drivers/ntb/hw/idt/ntb_hw_idt.c
+++ b/drivers/ntb/hw/idt/ntb_hw_idt.c
@@ -2657,8 +2657,6 @@ static int idt_init_pci(struct idt_ntb_dev *ndev)
 	ret = pci_enable_pcie_error_reporting(pdev);
 	if (ret != 0)
 		dev_warn(&pdev->dev, "PCIe AER capability disabled\n");
-	else /* Cleanup nonfatal error status before getting to init */
-		pci_aer_clear_nonfatal_status(pdev);
 
 	/* First enable the PCI device */
 	ret = pcim_enable_device(pdev);
-- 
2.30.1 (Apple Git-130)

