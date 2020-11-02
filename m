Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB91EC4742C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E0822268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gEvgla2U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbgKBQzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgKBQzD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:55:03 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5102C0617A6;
        Mon,  2 Nov 2020 08:55:03 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 62so4005693pgg.12;
        Mon, 02 Nov 2020 08:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ui/Tg6A0BnaN3BBtG1fWoCuT6IRPSKhNvvy+KUOGlY=;
        b=gEvgla2U5+zkdxzjNq4Y+OqR7bhdhQ0U0ekzs2BUF7LP6e6f6brIFD04ZOYiDVPHxd
         B9oVKKMNwBQWGe66H/1aQESSOVXsP63gLokNheNZit56xFJNuEMiCdzQnrKBqRmPJJWT
         lDquROHkFpB84dZuD0RVTYUpGgLlebkH52pLhkaJJ2Sldm9cSK/RwmtiR05ZhyIlBEeb
         uuUV0QHyV2oMWiQgqSWjPhbJkWsPRJ7dqtZSAzYTrv6st0o9gasryxNlww5hQkhTMyqo
         zocJxNcaS/PPboDIGkm18Ko5e4bHENEqABMuZj6W15JKx131fJFy2FB8t+KrLXK0mQ64
         YaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ui/Tg6A0BnaN3BBtG1fWoCuT6IRPSKhNvvy+KUOGlY=;
        b=IwECKlz9QYjqSXjlJ+xcI6DI2hl4fCmlfXqO7V5+ujSNfuSK65X39pn9qLfLr/7mT7
         SdANwnvZ0fGooastfyMo+FMRaAJ1l7+Ert3n+wk/shCBaCDFEewLj32JqvWHWQ5dOtfI
         v1noCisM6WBONKGfSJ697zrQO1oKw+nvJnXMmi/ypcPFfEO6gwfMiATK9Z0WBa5bpdnW
         Ux32VKIiG2+Tgbt+lr1dEyHPsk/ZtvBta2oMulXdDf7NRxeOHTdIGjsZLU3FG0k9u6Kd
         EyMzbHv+mC232alI4XI0EFH24R3ytsbEA1+pJ9DBzKBDyw53vpCsNJCjLdWwHuisPYY5
         XZlg==
X-Gm-Message-State: AOAM5324iOEnFLVTvoVWp+PqQ5ZJFuZo2Qn2M4IRhbNptdBjNe8NN/og
        n1S/yYhN3NCKr35G3Tob04Q=
X-Google-Smtp-Source: ABdhPJyj629fp48GcZrJ+3yMSSNljQLe94icEhcMlzF6ecfvj/MGCVMilJk+PvxHmE3Q2s0IobZPjA==
X-Received: by 2002:a17:90b:994:: with SMTP id bl20mr18627123pjb.34.1604336103472;
        Mon, 02 Nov 2020 08:55:03 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:55:03 -0800 (PST)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Balsundar P <balsundar.p@microchip.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v4 25/29] scsi: mvumi: Drop PCI Wakeup calls from .resume
Date:   Mon,  2 Nov 2020 22:17:26 +0530
Message-Id: <20201102164730.324035-26-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in mvumi_resume(), and
there is no corresponding pci_enable_wake(...., true) in mvumi_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
mvumi_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/mvumi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 0354898d7cac..7cd9c70e32dd 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2595,7 +2595,6 @@ static int __maybe_unused mvumi_resume(struct pci_dev *pdev)
 	mhba = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	ret = pci_enable_device(pdev);
-- 
2.28.0

