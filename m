Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BBFC433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 19:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CABF461A39
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 19:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCYTwF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 15:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhCYTvu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 15:51:50 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57135C06174A
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2021 12:51:50 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id l3so3139448pfc.7
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2021 12:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lJ91goXBMm6In1xfpxuCXNm6Jv5FD9hQ8dj2hk0NDNo=;
        b=OsjM0ixxvLUdzhxEsl/PUgE32o9JgW9Bg2+cUYVvy5JaCHFDPbb/fK7TSzoaL9OkMc
         +cCyuaG9Dx9Tkt4BHW6y1Js/3XRqpdkLNb9mmYv0FTqCk39ftQRr2DqzF8R5/I1FvHAr
         hsamD0TnF6nQGT+7I+BhuMt1wzUMdvo5gpBOp6xK6B2fXQpzSea0tf8xUexiLIAGX1XE
         uSXpM/quhBz1jSyG2e9k3ZW76MXn9j5A6bJbYidE/dU/kDi3MljjzB5H/pqxgiOYk/bn
         0Jfk1ABn3NL5ao5Gp0gLzxYeuPPi+X1HvcPpmSaJa4/8DAvZmg0ADClsc+V3bbTfz71G
         tWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lJ91goXBMm6In1xfpxuCXNm6Jv5FD9hQ8dj2hk0NDNo=;
        b=FpALG0MXGAXCcUQmUohoExJMozpWBzZgxbi4C2N28CXoeGqvt39UmsqyCvLwAi05CC
         3xbSFzSh0Xtbd22MD5x760mdx81mwwZgN+vtthAWUaz7eJdU4eONFn163n5EF+u6OeuF
         d/uPyxBYZzqd4WqCvNJc2D5Cd1cd8V7iR1Ed7q4M+N0IrVrvRSF1j3baRqgcDoejeCc+
         TppMHr7ngh+bVqf6zXPMl94CY6elPRplOiEyD/Q/JeIQf7M2KgbO+36OGUNfqP9EHT5T
         N5kRX1W6c26GKk48NbLWMB0eMMBKqv0eMVE/5bpghOr+5hM5WshOjIbXuL11j204kKLc
         f22A==
X-Gm-Message-State: AOAM533hJqOjZJkmdQc9z4jPuvtgTcUEG+9/R+FCH9Ysed9IztuS0Y0L
        vWtzdkLKTxuLu7bu3RFAHKtTxNjj6KPA7Q==
X-Google-Smtp-Source: ABdhPJy9LW5w2lcOOHP4zMMDm7dbEbG+dpRLy+86oo/q7uvVdm/VmAYb+RFy8DkFic2hg5tl8RHUHQ==
X-Received: by 2002:a17:902:a9c2:b029:e7:147f:76a1 with SMTP id b2-20020a170902a9c2b02900e7147f76a1mr6592191plr.5.1616701909478;
        Thu, 25 Mar 2021 12:51:49 -0700 (PDT)
Received: from ubuntu.fastly.com (c-69-181-198-179.hsd1.ca.comcast.net. [69.181.198.179])
        by smtp.gmail.com with ESMTPSA id f20sm6645511pfa.10.2021.03.25.12.51.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Mar 2021 12:51:48 -0700 (PDT)
From:   Joe Damato <ice799@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, Joe Damato <ice799@gmail.com>
Subject: [PATCH] scsi: mpt3sas: disable ASPM for mpt3sas / SAS3.0
Date:   Thu, 25 Mar 2021 12:51:29 -0700
Message-Id: <1616701889-77537-1-git-send-email-ice799@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Noticed commit ffdadd68af5a ("scsi: mpt3sas: disable ASPM for MPI2
controllers") disables ASPM for SAS-2.0 HBAs, but this change was not
replicated for SAS-3.0 HBAs. This change replicates this behavior.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6aa6de7..bc038e4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11842,6 +11842,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		break;
 	case MPI25_VERSION:
 	case MPI26_VERSION:
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
+			PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
 		/* Use mpt3sas driver host template for SAS 3.0 HBA's */
 		shost = scsi_host_alloc(&mpt3sas_driver_template,
 		  sizeof(struct MPT3SAS_ADAPTER));
-- 
2.7.4

