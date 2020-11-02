Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89733C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31C6422277
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:55:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EqBfrFxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbgKBQzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgKBQzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:55:13 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAD3C0617A6;
        Mon,  2 Nov 2020 08:55:13 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id z24so11304338pgk.3;
        Mon, 02 Nov 2020 08:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6TT5IHBGfMGaGX7Gmtu8Tm24mP0xvbXIdvxm/B+0he0=;
        b=EqBfrFxF3+hGpsiNVPo8B7GgJAUlGeMlNhH4lysYEpmhzxoV8GNoyu/v9Zgu3a4eD+
         /l1IOopOJ9pacDJCFInIx35HkiAgm40qHSIp/3I6CQf3pZzipCXNyg/vurrrRZOivvqO
         CrmOgAFw6h1Kg5IBW4wOJ+8UwWIel6QPoukYqeIVOdJgEiySCg+RxGKzSKishp1brJI3
         g+rw57xfHlZWaa4hiv+58wFpMOtLvcqp9Ht86Iz2795uzAYQtUpdptGiFEaLnS7kzKIG
         /u1u/vQTEjEXMDnqc3LfIyIQDBiQLVYY5FdWrkFqx/aGb9x51pauemc/gZCjOLQa2pHS
         LZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6TT5IHBGfMGaGX7Gmtu8Tm24mP0xvbXIdvxm/B+0he0=;
        b=E2EIEioekDMKHNW62ooDgpT63G5yWuBGAOaXpWaJTEauTWAyAjJBMz0Yqe7XUtXnOO
         x5YorXaDsYLADzF8/PlEqjjeYvmYisz0bFjre6vBmEh5NeZ9OZLk3P1MJ0sXll7a4mOi
         rHybdqm7EbalsuCFoOLt4/mdu3HO+svUSYXQzdzNNps/XS6KBI/7J9AknpwteC2F7Ea9
         5fqai6OqkCoCHZQRpa7rkBOCB+CVx1+Oe3H/yogEyU6ZmtN8WWKQL673XO2psmVq3btb
         7NxAcNFVSAmvCMh2iwX5UHeBqV6NgUuQrfaL4pXRFbnuzR8KAARRMf0TX4f5I2a4S18c
         8tfg==
X-Gm-Message-State: AOAM530INj99C2eWd+ARLNT8CokZXxwI7VUsgBRNEijxBe6QOtxMQHLO
        rFCaQyjT6tU0AmQENgPQCBI=
X-Google-Smtp-Source: ABdhPJxSqIjszVQ7UUpwB2fQQhrisUvUQEw43M/qAx4xbj3NgP0iA3aMYeRnvG7fJ414uX2K3G8LgA==
X-Received: by 2002:a63:e80b:: with SMTP id s11mr14105089pgh.380.1604336113148;
        Mon, 02 Nov 2020 08:55:13 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:55:12 -0800 (PST)
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
Subject: [PATCH v4 26/29] scsi: mvumi: use generic power management
Date:   Mon,  2 Nov 2020 22:17:27 +0530
Message-Id: <20201102164730.324035-27-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
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
index 7cd9c70e32dd..bbf0faac1f05 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2568,46 +2568,26 @@ static void mvumi_shutdown(struct pci_dev *pdev)
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
@@ -2627,12 +2607,6 @@ static int __maybe_unused mvumi_resume(struct pci_dev *pdev)
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
@@ -2642,11 +2616,12 @@ static int __maybe_unused mvumi_resume(struct pci_dev *pdev)
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
@@ -2654,10 +2629,7 @@ static struct pci_driver mvumi_pci_driver = {
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

