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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582F2C47420
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12DE721707
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jpu/Vb5N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732386AbgJAMbV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731987AbgJAMbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:31:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6269C0613D0;
        Thu,  1 Oct 2020 05:31:20 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t7so1892320pjd.3;
        Thu, 01 Oct 2020 05:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W5RQgrjqJr5D2/1pMUi9WfhBDO4kIlgckrIrr7JrWwo=;
        b=Jpu/Vb5Nw77VU7c9YF9sge1HNLGbWsv3FaRzRsopC6QZ9H7s6CzbkM/xMjlVpKUsjL
         3Lx8PRl0fNXjJbkQqUXYO0hQZIG/KXny9k5CkhZocA8R2t36b+SSk21ceqqjz3UMkHP1
         4YDHMfNIBv50XuKnBJ4Gob4rd0A0o+a7cYgONiZrlPBIENFaXIoKjWT154+U30tkmIMc
         Izc7OZZqbOplD7ySa0U7xr6J3wde4slj3xBVSfDSy8iOFm9F1mXVZ/688/aM98M9rt5u
         /ZS3lJUWndubLlv4U541MzoTIOPWt6f/3ESeTH+QF16ioLJg/YaqcZB64vy3jlZzosKr
         LkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W5RQgrjqJr5D2/1pMUi9WfhBDO4kIlgckrIrr7JrWwo=;
        b=CEA1qcv165RZD1MZGxORAy/m8jrLikN3lgAce3Z4NeGAYCfPgoV6Je4xkhGNL1LYqu
         1q+Re1FENEdWUDdfFwqmJESFKPd90q2QsHHdr9sEIs1lstePodKlbfOUOAtGAOysE9cz
         iPQWE3vfno2WF+7FrDjW9doBZJFg+bL95Q+BVtHsAOj8fjIvgmEssKxsENWkqu4R3Qg0
         SqLrJKRd0mHO+G3H66KYC93iQ4QPkp6JrQwvEieC8hyHu/PHPW8vDPgGz4CfzG/S2El9
         lXM6GNxnksd0wX3AiJAMBcblO9Ut2dWnIrzr2IX9UE6yuXv4hGrRqRh0teRO1kT0nwPn
         6VDg==
X-Gm-Message-State: AOAM533IDR/Wm0jaOUXcXOOjvkRC72xsmgYGuJJwj9E2r/U5wazTTWYv
        nPLkS6caXDWSJIrj0OKak1U=
X-Google-Smtp-Source: ABdhPJz+KCJHSAQgaeGoflykrGaOKtfCro4i2b1LFeI0SBNUzX0loLJxcb9Ye3ccBlGN8YblucDNCw==
X-Received: by 2002:a17:90a:b944:: with SMTP id f4mr7006528pjw.127.1601555480240;
        Thu, 01 Oct 2020 05:31:20 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:31:19 -0700 (PDT)
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
Subject: [PATCH v3 20/28] scsi: 3w-9xxx: Drop PCI Wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:55:03 +0530
Message-Id: <20201001122511.1075420-21-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in twa_resume(), and
there is no corresponding pci_enable_wake(...., true) in twa_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
twa_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/3w-9xxx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..e458e99ff161 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2230,7 +2230,6 @@ static int twa_resume(struct pci_dev *pdev)
 
 	printk(KERN_WARNING "3w-9xxx: Resuming host %d.\n", tw_dev->host->host_no);
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	retval = pci_enable_device(pdev);
-- 
2.28.0

