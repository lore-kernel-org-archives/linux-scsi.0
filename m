Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76857C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 09:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCVJNY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 05:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjCVJNX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 05:13:23 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098E7E390
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 02:13:23 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c18so18660674ple.11
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 02:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20210112.gappssmtp.com; s=20210112; t=1679476402;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5NbocV/CGU6vo/Jq423AoG+k28z3QYnZrMdtS3Ex8/4=;
        b=OkZiwJlN7EdOw0wCwLta+QvSYI38sAmKzXJ5O1VagUK/K3AfSI3/Ml3FapA8AyvHBS
         u3ObomU7CcTou5TYITedY0chuRE47MgzVLpCqDbgz+9Xf0rDBOsm6PrS1CjGgiFt3yE9
         5qxX4lSeLQg+rPONlEK/mLTWN5aAXfNKDb1W1pvO7EhbQ7VRcdC3kjsIIUPoUmTIcAuU
         soQF/YHFZKbY5j7gIyXVtdwBkxEjPZv+wZxNgJV60aEegHfd5LeNd4kYBOUrPo3EpOnu
         AfASMlr2EOYcEdh3LmpjxtIi27flJRX5oIkmCMAWVp3ImnmWWPP2gqU0+ETCJhXLMnpl
         +T6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679476402;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5NbocV/CGU6vo/Jq423AoG+k28z3QYnZrMdtS3Ex8/4=;
        b=oEa6VZShWdygCVhOX3o/GTeN1ffTiPCXeypuDYsCTGODynfG1tYAbGoGLQ9MSXTyxX
         awiserLyF9SmjdUorFdTDPthnR6iCWsxtUUJcjz/qPQQJxv+AawDpaGHdibgYYGPRgRH
         dg/bGGsmrjEFtCdeWY9+nIDxqNNPh/VGl3JznoVLhb+/4QQ5CeNxb0oVAImqjCyEwLqF
         2E7/NYiDH/vDW/wCt94T/V/Zb+sRahGFkm7czSMkbIQ1ZWR85fPxtOe5CVycESleKEzV
         vg8qpROnrztbDOvSHObzcKBTS6QQs7tQUN1SQyjcXzhI8ye3e2uJQhZYUI/gBMuO/50S
         6ERw==
X-Gm-Message-State: AO0yUKXyEQ6pigcdccBqvTiH+2PToyrTINExgxMNcfYEbArL1N8KQ+JP
        +MNb/pDNM12f0W3AnFg8/9TJ7Q==
X-Google-Smtp-Source: AK7set909pBC/j4lWAqNDjTzNbAkvQ3Nf/ka8NPlkkT02+PZ5xKi2gOu85q8p6SGKuddKairK/wipA==
X-Received: by 2002:a17:90b:3149:b0:23f:dd27:169b with SMTP id ip9-20020a17090b314900b0023fdd27169bmr2881569pjb.2.1679476402512;
        Wed, 22 Mar 2023 02:13:22 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id z3-20020a17090ad78300b0020b21019086sm983192pju.3.2023.03.22.02.13.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Mar 2023 02:13:22 -0700 (PDT)
Message-ID: <81c1f98819dfdfa18ae4d3b854b7733af9d34ea5.camel@areca.com.tw>
Subject: [PATCH 2/5] scsi: arcmsr: fixed ADAPTER_TYPE_B 64bits dma
 compatibility issue
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Thu, 23 Mar 2023 01:13:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch fixed ADAPTER_TYPE_B 64bits dma compatibility issue
on some mother board.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index e8c12dd..d387a38 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -996,6 +996,8 @@ static int arcmsr_set_dma_mask(struct AdapterControlBlock *acb)
 		if (((acb->adapter_type == ACB_ADAPTER_TYPE_A) && !dma_mask_64) ||
 		    dma_set_mask(&pcidev->dev, DMA_BIT_MASK(64)))
 			goto	dma32;
+		if (acb->adapter_type <= ACB_ADAPTER_TYPE_B)
+			return 0;
 		if (dma_set_coherent_mask(&pcidev->dev, DMA_BIT_MASK(64)) ||
 		    dma_set_mask_and_coherent(&pcidev->dev, DMA_BIT_MASK(64))) {
 			printk("arcmsr: set DMA 64 mask failed\n");

