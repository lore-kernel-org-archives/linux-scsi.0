Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9580EC4727F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C36221481
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLG7rUs4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732114AbgJAMaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732075AbgJAMaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:30:19 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ED7C0613D0;
        Thu,  1 Oct 2020 05:30:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f18so4325369pfa.10;
        Thu, 01 Oct 2020 05:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BG4V+85MuR6ufcPlMQYJVSkjLvahD//hnAYu8ukq0+g=;
        b=LLG7rUs4ONQDZHwO3toTKM1EzjbEMOaBcW6uAevZ94Y4Gr+jAUC85f08QFUy9cA+Gc
         NheZRLCYCyoX21wZ1deAbsThK70Ze6j33cllDlN/m5pHVcpfH0icwbVsQOFSKrm2tTrO
         sh/gb0JCSXdwN8kcIaSO4cSIRg/9IrdrUWYNmq7czfoRs4UAfxa4MZB1ht46IA1Q6yBN
         vyIKETbYfjkk8RN6b2pS8/JiFSGGzg5KJM9M7J7WBR3AnMX35mLAS8yh94jeGyG1rwWQ
         vjjYDXf1PDodKLGh1JeVGjS8eKrBpBzIWKGPQO0/KAduiet6kMKbvHl15z13Te/GWaCB
         HU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BG4V+85MuR6ufcPlMQYJVSkjLvahD//hnAYu8ukq0+g=;
        b=WONQ4tpj76dGWEtswAjZdcunZ+qagpcZTXk6letaq9lM60B9aIvfI4+Rcfp0DUF457
         Yx4m8TI4NZMHt/A25iElh7OOiEZWbpvwWoNqEUVqLpcq2Hq7Jh+3MIL43xVwVh7dby+w
         VR0twchisyHqMIYBAQOQWBS4Z4/WFriuN7+TlCHr3zGEdHRI3ORvHYf6r+NW65WiDK31
         TvbnyiPA5nDmo9+ic8U3SnlSboJTezqsA+zK2LNL/vXcFnmckEgpG64XiIJQzJ4EPbY7
         3Oy74uQ+Xu1m33yIt1zdnxQ2biVGpJ/MjPSrIbljVbmEips5EaIe3QVKW0M0EQJOolyt
         yv9Q==
X-Gm-Message-State: AOAM531fHUK2b30kNHtEyxinUFzqhsfHVp+oqBZLSrtLHmJVAqENQciY
        zHXeRU9jfe3BoaHznoDylLc=
X-Google-Smtp-Source: ABdhPJxpcLkoQM3qv+xaqbCqBU3lTkKKGRDya6S4p4gMIwqTyelhPUWUE2zNe5Z5D9JMzciOMlHnog==
X-Received: by 2002:a17:902:ec02:b029:d1:fc2b:fe95 with SMTP id l2-20020a170902ec02b02900d1fc2bfe95mr7521409pld.79.1601555417670;
        Thu, 01 Oct 2020 05:30:17 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:30:17 -0700 (PDT)
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
Subject: [PATCH v3 14/28] scsi: mpt3sas_scsih: Drop PCI Wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:54:57 +0530
Message-Id: <20201001122511.1075420-15-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in scsih_resume(), and
there is no corresponding pci_enable_wake(...., true) in scsih_suspend().
Either it should do enable-wake the device in .suspend() or should not
invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
scsih_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 08fc4b381056..ce3dfe26691f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10876,7 +10876,6 @@ scsih_resume(struct pci_dev *pdev)
 		 pdev, pci_name(pdev), device_state);
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	ioc->pdev = pdev;
 	r = mpt3sas_base_map_resources(ioc);
-- 
2.28.0

