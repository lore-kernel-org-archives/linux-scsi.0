Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B9EC433EB
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 309952071A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sxs5vUMY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgGQGiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgGQGix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:38:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951F3C061755;
        Thu, 16 Jul 2020 23:38:53 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ls15so6059535pjb.1;
        Thu, 16 Jul 2020 23:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WwDPleRnNmF5nIya5pCRA/s+OZ7smPPXMDZ4egsrQq8=;
        b=Sxs5vUMY0V6BCKr7DKEOTGDZCUt/8u3jqwBpxtsn7i9+oINAXq1UxmNprGzSwGRgae
         B33pGfemI+QD5yx7KKdb5J8rkcGrOLBJPMe/rUMwkVYmUTCT8i/OA3Li0NsFc+3+VSHu
         cY39QV5mrxomlxn0m1gBI3bmE6QxqIZEHENHFRq9cnbcbQJEv4oYgWmCHj74OZj3FBln
         d3Q438HeyqrzkNxFVqzMgDFLZaAR70pBctstQdSawn6ms9esp3q3gE12oPOoEEyq8VwW
         hqq9teyF1zi3e5a1OOTzAbH1YQTXxiKbpJocrkO7ogpm74d/6ff5bNFYQKFF1Cl09hCn
         kxfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WwDPleRnNmF5nIya5pCRA/s+OZ7smPPXMDZ4egsrQq8=;
        b=AY2O7YBkOi34ggoYiWIvAAVsvpJApdULQ1YNuo+I00ApCxZVqtaLonboI9gszuqzRm
         iISfm2h7rv6QCD94CTjAT1LHDf8vtmvlVcuG6uc7YpNonH2DYh8uqf2VPQqrtHW3xZt7
         g6BaAnI4wTozi+XPjwppxLQ36a8glp1a2cROTTvdew4DYIF6W2FUfBXK0cm5ZR742Eth
         SRh0KRFig4i86wSi/3OcIQu0HcxgMTz/5m4CrIKKLDR/9/+KlOOm+Qgs+6+z6dHjRWQn
         /7f3Yom1rfXsxRBp6AKGgWUVOXwcsZ2piBWW9jduoaRLq4BMuc0Uo1S4rnMc0BC+ljPv
         C8Dw==
X-Gm-Message-State: AOAM532o3BzURicoRF5DM3GsacBBY7fmRSm/k/8/dnrBTOBoaki0Xflg
        EnFa1rSqFb+gbJKkkq+LceI=
X-Google-Smtp-Source: ABdhPJwE0+aqHhwRs33VeNQMhFBnZtA0plbn4jp/tWiG1YAVOUBgBYpu6+CkU+pOWkvEzgV5SDeYTQ==
X-Received: by 2002:a17:902:8697:: with SMTP id g23mr6410059plo.94.1594967933074;
        Thu, 16 Jul 2020 23:38:53 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:38:52 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
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
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v1 14/15] scsi: mvumi: use generic power management
Date:   Fri, 17 Jul 2020 12:04:37 +0530
Message-Id: <20200717063438.175022-15-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
References: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers using legacy PM have to manage PCI states and device's PM states
themselves. They also need to take care of configuration registers.

With improved and powerful support of generic PM, PCI Core takes care of
above mentioned, device-independent, jobs.

This driver makes use of PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device(),
pci_set_power_state() and pci_set_master() to do required operations. In
generic mode, they are no longer needed.

Change function parameter in both .suspend() and .resume() to
"struct device*" type. Use dev_get_drvdata() to get drv data.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/mvumi.c | 49 ++++++++++----------------------------------
 1 file changed, 11 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 8906aceda4c4..7a6ef8264e47 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2558,7 +2558,7 @@ static void mvumi_detach_one(struct pci_dev *pdev)
 
 /**
  * mvumi_shutdown -	Shutdown entry point
- * @device:		Generic device structure
+ * @pdev:		PCI device structure
  */
 static void mvumi_shutdown(struct pci_dev *pdev)
 {
@@ -2567,47 +2567,28 @@ static void mvumi_shutdown(struct pci_dev *pdev)
 	mvumi_flush_cache(mhba);
 }
 
-static int __maybe_unused mvumi_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused mvumi_suspend(struct device *dev)
 {
-	struct mvumi_hba *mhba = NULL;
+	struct pci_dev *pdev = to_pci_dev(dev);
 
-	mhba = pci_get_drvdata(pdev);
+	struct mvumi_hba *mhba = pci_get_drvdata(pdev);
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
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct mvumi_hba *mhba = pci_get_drvdata(pdev);
 
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "enable device failed\n");
-		return ret;
-	}
+	device_wakeup_disable(dev);
 
-	ret = mvumi_pci_set_master(pdev);
 	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-	if (ret)
-		goto fail;
-	ret = pci_request_regions(mhba->pdev, MV_DRIVER_NAME);
 	if (ret)
 		goto fail;
 	ret = mvumi_map_pci_addr(mhba->pdev, mhba->base_addr);
@@ -2627,12 +2608,6 @@ static int __maybe_unused mvumi_resume(struct pci_dev *pdev)
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
@@ -2642,11 +2617,12 @@ static int __maybe_unused mvumi_resume(struct pci_dev *pdev)
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
@@ -2654,10 +2630,7 @@ static struct pci_driver mvumi_pci_driver = {
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
2.27.0

