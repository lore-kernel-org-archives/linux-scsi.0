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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E32C4727F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F1E21707
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ofdgbCx8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732315AbgJAMcb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731936AbgJAMcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:32:31 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFA0C0613D0;
        Thu,  1 Oct 2020 05:32:30 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z19so4332169pfn.8;
        Thu, 01 Oct 2020 05:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=upZZCj+92lnDUoFs3NcTq8HG6EWLzQTAbL5PyvIZ1Ek=;
        b=ofdgbCx87Pg7KvGsN+h1/pPg6myPm0W8WPZNSr0j/mogOK2OYugSZ8RvKrd11oNp58
         IRzR2iJfUfRkbx+PmFkA74gJPOFvuCUevKhMJhQRHZS4jYtdUy/wjOFvgUZ4e5j74E0T
         wYDHAoEH6AMkcuwHJlV9Wi2AydAdFs3z5vzjjWjMA5OOjsEyN5THqaAv/WErFGqhHK1l
         06tRJytiTLsv7nRT3z51a9U3Efe5mKihVqTzIkVWEa+XOYCxTQhFY1ELUP9ZPtPeIa1d
         oTl1gxbYbNdVYibvuNm+CtPTD1N0sUeTwEqingLkfWeq4pVZNv8DpgsvklbaJwHFlGar
         38KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=upZZCj+92lnDUoFs3NcTq8HG6EWLzQTAbL5PyvIZ1Ek=;
        b=nHwv5ef/XkcTZ1abvAs2owCm9vqbxrYpCXw8aTsdX/WFYbaDg9UhPi56/lVYMm5EM4
         S3Ai3nsp3sUd2spXLbSnq1yt3H2xiqWvR75NIvZ4RMwbHZHFrg9Z1AW1I1j9ArgQlKxh
         lzEsBFvnwHQlXhdlhcX3eVfAc0ZpPCvpKOKI1iPL1DowCwMVB+yjwsj2TRe2FhXtW5im
         h/yBQS12SGL6GJ0keuBi9Qkov3cUcbKx0K7RAOa0phujOj6nTliDDnh5MsuUHk+TIBlC
         j9rorVmxD1Sy8eyyqAemCHmFF3msRyOmUQzRWn123jemPHjmArh79tCsAc1pDZVrsAPO
         h7Mg==
X-Gm-Message-State: AOAM530pJWYK2fkzOQpdiyNI3bN2xicPTuyRD8gbA8ZGnedOCPE/ek5b
        5PZIVYq/IoESQWIPKJ+nA+g=
X-Google-Smtp-Source: ABdhPJyLBix4KXS5HBL5+h0SdbuccaR4mOzkejrjegKjDBqh4tozo/80gsbk6MuG+wZ7gFvLk4ygJQ==
X-Received: by 2002:a17:902:b191:b029:d2:6277:3898 with SMTP id s17-20020a170902b191b02900d262773898mr7502813plr.10.1601555550493;
        Thu, 01 Oct 2020 05:32:30 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:32:29 -0700 (PDT)
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
Subject: [PATCH v3 27/28] scsi: pmcraid: Drop PCI Wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:55:10 +0530
Message-Id: <20201001122511.1075420-28-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in pmcraid_resume(), and
there is no corresponding pci_enable_wake(...., true) in pmcraid_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
pmcraid_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/pmcraid.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index aa9ae2ae8579..7674b8481f35 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5274,7 +5274,6 @@ static int pmcraid_resume(struct pci_dev *pdev)
 	int rc;
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 
 	rc = pci_enable_device(pdev);
-- 
2.28.0

