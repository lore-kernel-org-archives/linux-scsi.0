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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A0AC4741F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EDC220B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MRsd2Wno"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732273AbgJAM3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731888AbgJAM3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:29:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E098BC0613E2;
        Thu,  1 Oct 2020 05:29:07 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id j19so1886625pjl.4;
        Thu, 01 Oct 2020 05:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nFScM+arNxRtQeZvbbAHYBWlDLtA4fLReR+nPVgLlBM=;
        b=MRsd2WnoH84TSpfdS0xsAvvPKUvk+hWZ2jQyWrlHyJno4rRc/WvqtEJNAREGXx8lpc
         /aCIT/eymCmbHgVRPLsgUxGj6G8VePygO3I9hpnIBR++cdiovm6tHtXu+JXXLlKCL0xX
         mdPMbym0b+f4+UI7k89TE1GdFB57FAS9jxNNZ6KjQNV/tGEIItv9SeVBRVP13Jqwkunq
         kaEVvQVpvesS6iUFLdoLZzp+PWvlHcKTl8HXXadHCnqSUZFd2BgdSS0lpha9Er/EIFkk
         KGhmBW6jFGZ+srVHjpVRZBT3KuUsqIZ3x5TmeSFQrxPePp5t7lYj2SFjXJPncs34uTlD
         +Y5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFScM+arNxRtQeZvbbAHYBWlDLtA4fLReR+nPVgLlBM=;
        b=BXDBgChYU+IijkwS60m2SfxToYQ52E6/UQPZccE8PelWNOkih5q/ahSwYMAKDe93dw
         7CPxP+YUn6o2uAwquDamzap7yKwQdGYQegzEnWQANMM0pc1HqYFAXxiBogSbYg73UQ86
         Lf2m/IQx5DBiGa31LcS+NXd9e+rPdfOLW5HBzNzUa8QatAnh/7c3P4GjN7l3E9O4/MKv
         DAobW9MPOQVFGu6EXGrFKq4CGV4CRWd5ZlIjHQ/KplkPbA/DaG4n7HF+B1J5zCQqjH9G
         9DXdWe6mk/WJ0gKsvIhWqRCKeAwYivz2t5nq6rPEWoTFL4+HjMN0oWMd6T7LPujGA9Qs
         SGYw==
X-Gm-Message-State: AOAM533v5fdZnZzmoq6jbPMCXPH8pLrDNkkcDGh7XTDnuCUGtgG15k3s
        adwNebqHR+ii2JuxDToLCj8=
X-Google-Smtp-Source: ABdhPJwQJMPHi93RFnwt6p0B1nWePCTdTn//Wk9AHwIXspt4V69jOm3D2hO/uhuP3PPE6FF1Js5Dgw==
X-Received: by 2002:a17:90a:bd0e:: with SMTP id y14mr6924794pjr.58.1601555347469;
        Thu, 01 Oct 2020 05:29:07 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:29:07 -0700 (PDT)
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
Subject: [PATCH v3 08/28] scsi: arcmsr: Drop PCI wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:54:51 +0530
Message-Id: <20201001122511.1075420-9-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in arcmsr_resume(), and
there is no corresponding pci_enable_wake(...., true) in arcmsr_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
arcmsr_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 30914c8f29cc..6ed2ad10bede 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1094,7 +1094,6 @@ static int arcmsr_resume(struct pci_dev *pdev)
 		(struct AdapterControlBlock *)host->hostdata;
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	if (pci_enable_device(pdev)) {
 		pr_warn("%s: pci_enable_device error\n", __func__);
-- 
2.28.0

