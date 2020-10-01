Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8E0C47420
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8F5620B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GeHv+bOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732401AbgJAMcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731936AbgJAMcL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:32:11 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FB8C0613D0;
        Thu,  1 Oct 2020 05:32:10 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t14so3914705pgl.10;
        Thu, 01 Oct 2020 05:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hrv7wRA+5E+4KqJ7bQMOzG1YJwF6Az+zVhIMy7DopLU=;
        b=GeHv+bOByYv/7nmo32iMHC75G0isZBzRUMMMArTGgzfs7JvMHmpNFXqYjkpdRwGcSX
         bhtqUAN53rSGBzAAnZmZcPat6VFeFAerXN9EaAXMWDs+NTfKG+rBXqeAmEv25g8l1raE
         2ZHoHLIqC2XJ38K0hXyFtf8vtb7O/7VC/+oyuRVK3Lrh/3BInkkLRXL+BhyPYU+Lf2Bx
         JGCVRIQS84xFLCF8CGYiSNvD7MnZuyoTOadztIIem4SQlARGl11jCRTh/WiSMZbe7T6I
         7FpPT+/sjvY2PngX2h4oMdb4Bbjnvs9yjL8llG/eaCnEOgsAGM7omVhMbsH36fkL/eem
         lFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hrv7wRA+5E+4KqJ7bQMOzG1YJwF6Az+zVhIMy7DopLU=;
        b=Yvhmy+jhowqMcfB/KMeClnYmiDtVuTTBrWL7bWPjbkoxS4EyMro55+DQkRBVjpAzjs
         XcJiybzW07eRIb6z3CTuhFnMFg7efhAoEFyZEtQ8y19pcsb92GnWIjHitiWmDq6WlKHz
         cMrtdJQMMHDEV+L2kdDAgNwzjmMH0KtWxOlKyiF8Su51YTME8wvdHuAK01jEaVs1nqKI
         nsYIo9qlADrrfrHLG7lLblyYKhMmAh50P5xTuiUHzhUd4Cg9l2kn/tfl9AU83W+VmiJU
         t6LZjaVnMwtU+Ha7trO3KXD5LlZ+Q1UaajluAlFBgi2BoAlmMK7SYJUoNMXGWwPrp+p4
         D/OQ==
X-Gm-Message-State: AOAM530/GWPBFDLhag/lyq2Yzo4Vy9J15f6Pkbhz83rUxQTRL1KkA2b2
        KGBTmSBHCegVEezIK3FlgWY=
X-Google-Smtp-Source: ABdhPJxQsNaElmb369gzt/Yo9RjTX54ks0xKIenxfw0M+AOwyH7+1Qtq1uXVqtfS/ux6tre3ChN/xQ==
X-Received: by 2002:aa7:94a4:0:b029:151:d786:d5c2 with SMTP id a4-20020aa794a40000b0290151d786d5c2mr6860664pfl.50.1601555530485;
        Thu, 01 Oct 2020 05:32:10 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:32:10 -0700 (PDT)
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
Subject: [PATCH v3 25/28] scsi: mvumi: use generic power management
Date:   Thu,  1 Oct 2020 17:55:08 +0530
Message-Id: <20201001122511.1075420-26-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers should do only device-specific jobs. But in general, drivers using
legacy PCI PM framework for .suspend()/.resume() have to manage many PCI
PM-related tasks themselves which can be done by PCI Core itself. This
brings extra load on the driver and it directly calls PCI helper functions
to handle them.

Switch to the new generic framework by updating function signatures and
define a "struct dev_pm_ops" variable to bind PM callbacks. Also, remove
unnecessary calls to the PCI Helper functions along with the legacy
.suspend & .resume bindings.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/mvumi.c | 46 +++++++++-----------------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 6a25e6918e26..6c710585a628 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2567,46 +2567,26 @@ static void mvumi_shutdown(struct pci_dev *pdev)
 	mvumi_flush_cache(mhba);
 }
 
-static int __maybe_unused mvumi_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused mvumi_suspend(struct device *dev)
 {
-	struct mvumi_hba *mhba = NULL;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct mvumi_hba *mhba = pci_get_drvdata(pdev);
 
-	mhba = pci_get_drvdata(pdev);
 	mvumi_flush_cache(mhba);
 
-	pci_set_drvdata(pdev, mhba);
 	mhba->instancet->disable_intr(mhba);
-	free_irq(mhba->pdev->irq, mhba);
 	mvumi_unmap_pci_addr(pdev, mhba->base_addr);
-	pci_release_regions(pdev);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
 	return 0;
 }
 
-static int __maybe_unused mvumi_resume(struct pci_dev *pdev)
+static int __maybe_unused mvumi_resume(struct device *dev)
 {
 	int ret;
-	struct mvumi_hba *mhba = NULL;
-
-	mhba = pci_get_drvdata(pdev);
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "enable device failed\n");
-		return ret;
-	}
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct mvumi_hba *mhba = pci_get_drvdata(pdev);
 
-	ret = mvumi_pci_set_master(pdev);
 	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-	if (ret)
-		goto fail;
-	ret = pci_request_regions(mhba->pdev, MV_DRIVER_NAME);
 	if (ret)
 		goto fail;
 	ret = mvumi_map_pci_addr(mhba->pdev, mhba->base_addr);
@@ -2626,12 +2606,6 @@ static int __maybe_unused mvumi_resume(struct pci_dev *pdev)
 		goto unmap_pci_addr;
 	}
 
-	ret = request_irq(mhba->pdev->irq, mvumi_isr_handler, IRQF_SHARED,
-				"mvumi", mhba);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register IRQ\n");
-		goto unmap_pci_addr;
-	}
 	mhba->instancet->enable_intr(mhba);
 
 	return 0;
@@ -2641,11 +2615,12 @@ static int __maybe_unused mvumi_resume(struct pci_dev *pdev)
 release_regions:
 	pci_release_regions(pdev);
 fail:
-	pci_disable_device(pdev);
 
 	return ret;
 }
 
+static SIMPLE_DEV_PM_OPS(mvumi_pm_ops, mvumi_suspend, mvumi_resume);
+
 static struct pci_driver mvumi_pci_driver = {
 
 	.name = MV_DRIVER_NAME,
@@ -2653,10 +2628,7 @@ static struct pci_driver mvumi_pci_driver = {
 	.probe = mvumi_probe_one,
 	.remove = mvumi_detach_one,
 	.shutdown = mvumi_shutdown,
-#ifdef CONFIG_PM
-	.suspend = mvumi_suspend,
-	.resume = mvumi_resume,
-#endif
+	.driver.pm = &mvumi_pm_ops,
 };
 
 module_pci_driver(mvumi_pci_driver);
-- 
2.28.0

