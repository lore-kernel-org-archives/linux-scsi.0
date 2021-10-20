Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BA1C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 14:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A6BC6135E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 14:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhJTOTt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 10:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhJTOTs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 10:19:48 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EA8C06161C;
        Wed, 20 Oct 2021 07:17:33 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w17so4398987plg.9;
        Wed, 20 Oct 2021 07:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=7f2ijMKOoH8cL3tH1omUbgK+gxfuqZ2CPeATZrytvh8=;
        b=VmZQ+Zo0ykqcmrnMFHV3bHFF+8Mjw5voQGDOq9G2Ox4mlScVz/Fu/OgGsCtSQZo8Zj
         FZ46ZOfst7Vk0+v2foeyVgig7C2rVfT9eX0K92VJ08z7B0oWOhXGjEp6lxXbyNFGYr/E
         te9JETjlG557H7w+Q1LmU8mcIV9LWWDGx/7B98wZLxXtIy2IKbq+edHi+THofA6yLh2e
         CUmmeOQ1ZLufyb86F4F5JNMWyrzI/Yt3ms6K//MpDY5whGRIYoZGHcuUctw9oALAWV+T
         a8R/mx/aeflVIqdh0M2ftDZvUBdcLLNSpvSiYIl0OGXwTONKKlhnLJddVO2ieENfxmx/
         mmxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7f2ijMKOoH8cL3tH1omUbgK+gxfuqZ2CPeATZrytvh8=;
        b=SH6fuhNByRoYnyNA2HCJ5v6dlolQegdkKdUz8Zp/7A1Pn1YU/wa1UNV/JxLCJh/Mjw
         jOSBNwnLTKFAEPkLVuOAVuAq27QISZsRX21guYhPOxrs4QW7PQ0JL4FX5xDbYbXy8K45
         RNU3d7BWb9F0GeeW/CDiSGCewmIPnVZSyp7oh710IkwFocwAEkGICOcY5MRJH5H2fpT/
         dGRlxCZyvfApUS/AGWMrOx7C8qlxF5+OuLnoWyswzBBNT91seA+zJTbdg6/VP6UPhxeK
         bWLuO0hXXa4T4M56OeJ4kOrBTlxUdWOH7RL4zcYNrVOjCwf5rfCRpGeExIj9z/GWZBI2
         jJsQ==
X-Gm-Message-State: AOAM532I1r4Zln/vV6kg0SsudxUVlXPntTTdaHTdGhIsK5/OJ/r8jkz/
        uxBX2zQbC9lX/4LXvfUGhw==
X-Google-Smtp-Source: ABdhPJy6pLxwnh13ARTWMNzYC8YNeciAOG85kAi4U++07V7N1FJC3l9ThByWTtaA7zxN/ga8BIb54g==
X-Received: by 2002:a17:90b:a18:: with SMTP id gg24mr7687677pjb.18.1634739453390;
        Wed, 20 Oct 2021 07:17:33 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id p31sm2771081pfw.201.2021.10.20.07.17.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Oct 2021 07:17:32 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] scsi: megarad: Fix the return value of the probe function
Date:   Wed, 20 Oct 2021 14:17:22 +0000
Message-Id: <1634739442-26844-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4298bf4a482..b94f9557b2fa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7468,7 +7468,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	case PCI_DEVICE_ID_LSI_AERO_10E4:
 	case PCI_DEVICE_ID_LSI_AERO_10E7:
 		dev_err(&pdev->dev, "Adapter is in non secure mode\n");
-		return 1;
+		return -ENODEV;
 	case PCI_DEVICE_ID_LSI_AERO_10E1:
 	case PCI_DEVICE_ID_LSI_AERO_10E5:
 		dev_info(&pdev->dev, "Adapter is in configurable secure mode\n");
-- 
2.17.6

