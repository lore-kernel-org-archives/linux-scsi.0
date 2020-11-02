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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4165BC00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC4822268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NpW31TLe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgKBQyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbgKBQyo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:54:44 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5047C0617A6;
        Mon,  2 Nov 2020 08:54:44 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id o3so11269885pgr.11;
        Mon, 02 Nov 2020 08:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ccyY/JHq4D3PLCl7N5Le5xwodBVxQCbk5cLiaDjEFw=;
        b=NpW31TLetItFsb140xAKZVbCVOKP2GAN9IMwURcruykGX00RcSle7+2EuM5I36CM8o
         fe4KsRaDfKtHUaTt5xVXCH2kez+BLnx9rJKFhORdMLQa+sk8W1vYH6YiTDcef8q2V1nl
         TUb30IC4T2Nfc+uLV0DYvKeXIHBywuPzlJoPTU+U8+zHYiyGEDA04TIpppSOGFkxexbh
         pGh73vWQpUaRpZ0IY9BxvFO5oZ4uB7CxqpYtva2SHbT1HQ+v+o8j8g0UTb+rkEAPvUH+
         uaO2mHw4WvhZwEH8bDpx50oDS1g4G4FzH6lSucG9qGv8O1Aqk+f4J93leDCgYGD3nIcm
         IuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ccyY/JHq4D3PLCl7N5Le5xwodBVxQCbk5cLiaDjEFw=;
        b=qM0ug096weLn6w5GT3rTvFwJ3HGTIKjq/2t7ltyS3m1RNVdcme0O96uuz5XPCKyysZ
         zp9kVQwtXbkhEZ7ApyYN1A4W16ADy3nZFMaTDKHNqppl4V2T+b6apzCOj5GIpaUWOTTe
         Qs5wbLEES0ccaZTk295LmlWufN/yaNJ8gXx7nRKz3hhIUNhBaAvIZSA96PWKe0JX5NI/
         sxmoe04PP7YfAWp30M/sAGK/mhYMR4CV9/HpmqTOtpjUF4Lr/2MZlq2BOpFh/MVJwmAZ
         xAhMmrWj1mpNoB4U+bQeGF3e26z8vS7qJclQXte/koXilrOOWWij4bug77f8cdjGyddX
         whzg==
X-Gm-Message-State: AOAM531HyrtWxvHIH231+q6dIjpvY54kUHvhaK3SUKz4JcOaZs1C4ClR
        D21DoAIhczSTmZKVBugKLuc=
X-Google-Smtp-Source: ABdhPJx/1LewIo20VjBh1CMTVa+zuJIuzuWLg4W/csDX8oOWuCb+rFAFC6LAzjvhej07R0r8NoDkqA==
X-Received: by 2002:a17:90a:1188:: with SMTP id e8mr18750804pja.61.1604336084398;
        Mon, 02 Nov 2020 08:54:44 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:54:43 -0800 (PST)
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
Subject: [PATCH v4 23/29] scsi: 3w-sas: Drop PCI Wakeup calls from .resume
Date:   Mon,  2 Nov 2020 22:17:24 +0530
Message-Id: <20201102164730.324035-24-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in twl_resume(), and
there is no corresponding pci_enable_wake(...., true) in twl_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
twl_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/3w-sas.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index dda6fa857709..0b4888199699 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1795,7 +1795,6 @@ static int twl_resume(struct pci_dev *pdev)
 
 	printk(KERN_WARNING "3w-sas: Resuming host %d.\n", tw_dev->host->host_no);
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	retval = pci_enable_device(pdev);
-- 
2.28.0

