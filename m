Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3609C4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9901020B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADnt676A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgJAMbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731987AbgJAMbl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:31:41 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9C2C0613D0;
        Thu,  1 Oct 2020 05:31:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m34so3914455pgl.9;
        Thu, 01 Oct 2020 05:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ccyY/JHq4D3PLCl7N5Le5xwodBVxQCbk5cLiaDjEFw=;
        b=ADnt676AAP5flINm0S2qqqHIISzdszBdV/K0pjxZBtIPrRD/ewjglITrUMhytntX8O
         smIsN3OgyJl0MQ1/tPj9e05fRv0HczWSF/ZXnEY15KL7AWwXO02zvKX0ahPsmVA8TZ4P
         yYki4jkZuGLsBZhuvTI5FwB52ypNCzv+tZNOQsryxDs57yX75HsWby3yGfSo7rjEwarR
         t01z0TOTWpT4tFRwIMcFjXga5dQlwtnOWgeLS/EeTLGM+IO91206jAyyB76fq2wjhBC4
         4Qs2Tqosp+F/tw63f1DC/YLufjTScHtwuoAQJxfdFXxY83Iv4G5jOWVyl+agP5ZkshU3
         tZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ccyY/JHq4D3PLCl7N5Le5xwodBVxQCbk5cLiaDjEFw=;
        b=Yo9SAA0R/nFgUw+KpV2FUP/ykTLSS8yGYY7MLFCVDnDuqv4R27qg+A8dn3qOqx6kDs
         1kW0BUJ2HXKa8zW3r7n653h7WqiO7+iZ6drgRMoEXBqZIf6pZ6icL8dks13cS80ig6vO
         dJSaGmeeAkM7/NrMH57IcYMhpbEezENr9QI6AMgZLwShckQm+L5o+yR7vWPOrxUjuoev
         M43k/ThFwhlfZngqvmWcunL1mZkE/lEhG6InO6CcabxG0JynuDCgSc7aXocSRwca4rnV
         zv+hjDNLaKONHdNTOH1nKu98qfM7KPrDoQYVPjY1kFXqQ09LG65dhkZKWx22VvICTsZo
         x8wQ==
X-Gm-Message-State: AOAM531ZOUFMlnw9OVVN3k5v4uiLH+xCWiwU5br+Xbe2ZxycDhiRfLVA
        exrIt7+3+i6Pd9doAxD66Lo=
X-Google-Smtp-Source: ABdhPJx2jLFxmDE9qTYw6Qz+MBqtFoeNRTBU/qZxwnXqlpVbCbPeeKH1h7TjhV5KgZWFB2gS5ae13A==
X-Received: by 2002:a17:902:758f:b029:d2:ac2f:3a79 with SMTP id j15-20020a170902758fb02900d2ac2f3a79mr6879952pll.59.1601555500390;
        Thu, 01 Oct 2020 05:31:40 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:31:39 -0700 (PDT)
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
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 22/28] scsi: 3w-sas: Drop PCI Wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:55:05 +0530
Message-Id: <20201001122511.1075420-23-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
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

