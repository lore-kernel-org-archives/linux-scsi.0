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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DC1C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDB322277
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSlnE7WO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgKBQzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgKBQzo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:55:44 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF14C0617A6;
        Mon,  2 Nov 2020 08:55:43 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 133so11606802pfx.11;
        Mon, 02 Nov 2020 08:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1YdlygNrEXUlcZfght3UiooWvJCdKrIM8fi0Iud6y9Y=;
        b=DSlnE7WOf8he6FwOZCHT0o0XLzJMz58pzJ8F8DkrkD5UT5XNdt4xRz8jQ+ehq9l8Np
         wIw+a9CV1/PHPbvYYAtenesSaPDQ6MbHpwtdOv89La0LK+/mL0g0NLcCo7HmahFBnp6G
         9hLADmmoaDc4d40gKXJbNmthS2Cnl1TrjysQVV+TfK9fy12cnhMJd+g/DcAiCwphLpRD
         OwODZPwdwRvHZHTqVc+0SZt50nyKFXzDL/uy5vCNJtZFDLUjTTn2sTiGNqOLK6woOdNx
         4uEj0KnUBhRMVdwRQR04iYpkHu3sBiuVuRLAnDTvrY6MoGdNG8/88lEG3MSVbfkDufGg
         eNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1YdlygNrEXUlcZfght3UiooWvJCdKrIM8fi0Iud6y9Y=;
        b=G68NmBk9R184yf4xrkyvNgZhwCgckYNexns3uhKVdxQmMeDGwi0RP4CI4dlifXvaKB
         PPu3jJasUfwkpEoiKp/FD/Fpv449vZLW+wRtRpXKPAjWu74mOW4GKOjjirMMAYukNeg4
         3KpADnr6b6DYsjFJNlBim2X9KhkblEcBSFVkHcSkjXfsVEU1KJOAVlAb9yt/YeBNlr6q
         Q2XK1fmjnqIJHRYaVcaEgguxDfw4QjQrlYyPup2oyCsOiPAUtrReWMfJZl5u1lcjTh+q
         WErCZPSXB4R9t0CDeaW9B/CEuyhUxRXbSvg6AvZPYTSz6Kx4BPGjOtuxoAmy8OAGe83G
         jH2g==
X-Gm-Message-State: AOAM532DlfPNvBwJHUPgqaYvXMBPzJVixPywfSOXYY3pLFsKKVH15Q18
        Sr5vQNphTzp6cAASngK5Rk0=
X-Google-Smtp-Source: ABdhPJyKCCtMCVaSvU3Is+RZvy6q7HpSGUGMl4yzO6ssLEtChPuyUb5A8lINnWDTzVhEeOe929D7+Q==
X-Received: by 2002:a63:1c45:: with SMTP id c5mr10089758pgm.357.1604336143430;
        Mon, 02 Nov 2020 08:55:43 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:55:42 -0800 (PST)
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
Subject: [PATCH v4 29/29] scsi: pmcraid: use generic power management
Date:   Mon,  2 Nov 2020 22:17:30 +0530
Message-Id: <20201102164730.324035-30-vaibhavgupta40@gmail.com>
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
 drivers/scsi/pmcraid.c | 43 ++++++++++--------------------------------
 1 file changed, 10 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 5c767cd8ffc3..834556ea21d2 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5234,53 +5234,37 @@ static void pmcraid_remove(struct pci_dev *pdev)
 	return;
 }
 
-#ifdef CONFIG_PM
 /**
  * pmcraid_suspend - driver suspend entry point for power management
- * @pdev:   PCI device structure
- * @state:  PCI power state to suspend routine
+ * @dev:   Device structure
  *
  * Return Value - 0 always
  */
-static int pmcraid_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused pmcraid_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pmcraid_instance *pinstance = pci_get_drvdata(pdev);
 
 	pmcraid_shutdown(pdev);
 	pmcraid_disable_interrupts(pinstance, ~0);
 	pmcraid_kill_tasklets(pinstance);
-	pci_set_drvdata(pinstance->pdev, pinstance);
 	pmcraid_unregister_interrupt_handler(pinstance);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
 	return 0;
 }
 
 /**
  * pmcraid_resume - driver resume entry point PCI power management
- * @pdev: PCI device structure
+ * @dev: Device structure
  *
  * Return Value - 0 in case of success. Error code in case of any failure
  */
-static int pmcraid_resume(struct pci_dev *pdev)
+static int __maybe_unused pmcraid_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pmcraid_instance *pinstance = pci_get_drvdata(pdev);
 	struct Scsi_Host *host = pinstance->host;
-	int rc;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	rc = pci_enable_device(pdev);
-
-	if (rc) {
-		dev_err(&pdev->dev, "resume: Enable device failed\n");
-		return rc;
-	}
-
-	pci_set_master(pdev);
+	int rc = 0;
 
 	if (sizeof(dma_addr_t) == 4 ||
 	    dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))
@@ -5333,18 +5317,10 @@ static int pmcraid_resume(struct pci_dev *pdev)
 	scsi_host_put(host);
 
 disable_device:
-	pci_disable_device(pdev);
 
 	return rc;
 }
 
-#else
-
-#define pmcraid_suspend NULL
-#define pmcraid_resume  NULL
-
-#endif /* CONFIG_PM */
-
 /**
  * pmcraid_complete_ioa_reset - Called by either timer or tasklet during
  *				completion of the ioa reset
@@ -5832,6 +5808,8 @@ static int pmcraid_probe(struct pci_dev *pdev,
 	return -ENODEV;
 }
 
+static SIMPLE_DEV_PM_OPS(pmcraid_pm_ops, pmcraid_suspend, pmcraid_resume);
+
 /*
  * PCI driver structure of pmcraid driver
  */
@@ -5840,8 +5818,7 @@ static struct pci_driver pmcraid_driver = {
 	.id_table = pmcraid_pci_table,
 	.probe = pmcraid_probe,
 	.remove = pmcraid_remove,
-	.suspend = pmcraid_suspend,
-	.resume = pmcraid_resume,
+	.driver.pm = &pmcraid_pm_ops,
 	.shutdown = pmcraid_shutdown
 };
 
-- 
2.28.0

