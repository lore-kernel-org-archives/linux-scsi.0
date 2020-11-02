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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E39C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 703FE22258
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vEvEad+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgKBQy4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbgKBQyz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:54:55 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354B5C0617A6;
        Mon,  2 Nov 2020 08:54:54 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id b3so11637876pfo.2;
        Mon, 02 Nov 2020 08:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yCf+5pBHtGakI8vGh3iG+XqVcPWuJKKA8L3HBDKw1hc=;
        b=vEvEad+H+eWgs40nHp0nELDOrVYmOjvKeE8TdSmqxH7ZmAMRXi1eSZ7qutoPGgA4u5
         WPdcoQo385A3T7OpTMB3cbQGMlWXACIioV9OSZuSn1tb9mjhz+tj2cS8C8O9M7V96FFF
         CymO2EIqjBX5jAxCBOdANWVLSoEo23UDAbpv3+JYCr6jWz83uCmS12oETvsUt9MAcatU
         xwat4DGT9+NnfQV771nNYlSURM1Mz3blHVjX/ho9fOd4dJtCSWgja3vUa/N0CGM073BC
         lv4+c8nj+FtUU1dwarFxLyqWq66qErjq6j7camqsETu6KfU+dtlzGEK0Zb9YOnx/HI4L
         SSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yCf+5pBHtGakI8vGh3iG+XqVcPWuJKKA8L3HBDKw1hc=;
        b=G5RtMx2aD1A22TZb1YtBFGSrmA7YfKsV/ToA9ekDN2Qx688WgHS7dQFz36J2F+1cbx
         VSTaKgz5hWHQ0qf/RFIEp8vw/8vGVF4uVqUdY2n4C73LocQESJejfiG/ZRhgPbizNcRD
         lkn8lu99hOQLPyB69LRFpZ3/gwj2O8mskyyrPd0uxOX8jdRKoNw3R7aP8kstbkuy4Fa4
         OfIFVQPL5kJcbu12TVaIBBB1PGKKV0BNpxaAPl9o0hsYfuSkA94lPmOMXnFefMGWwh6G
         8tggIRTmvhwY7OJvHPNE1vDE34C7xBMPlSwRNpSvvZeHBdu3kWcAga6qxMM+TlNxnL4p
         7UHg==
X-Gm-Message-State: AOAM53383huwKn01AX9E9O9VkGOGZ+xf3jBFI0wUlwEwnDbe+SC/QsWY
        wBJbbwk5wY2OpXT2Vg04up4=
X-Google-Smtp-Source: ABdhPJzNTDOXtAD5WGfTQNsPSzEj202Ojni4ZSsnXTsIRIn/f/5a2YTj/Xz6GogQ3JzQYLUvqUiQUQ==
X-Received: by 2002:a17:90a:4a15:: with SMTP id e21mr4041783pjh.130.1604336093729;
        Mon, 02 Nov 2020 08:54:53 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:54:53 -0800 (PST)
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
Subject: [PATCH v4 24/29] scsi: 3w-sas: use generic power management
Date:   Mon,  2 Nov 2020 22:17:25 +0530
Message-Id: <20201102164730.324035-25-vaibhavgupta40@gmail.com>
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
 drivers/scsi/3w-sas.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 0b4888199699..b8f1848ecef2 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1756,11 +1756,10 @@ static void twl_remove(struct pci_dev *pdev)
 	twl_device_extension_count--;
 } /* End twl_remove() */
 
-#ifdef CONFIG_PM
 /* This function is called on PCI suspend */
-static int twl_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused twl_suspend(struct device *dev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct Scsi_Host *host = dev_get_drvdata(dev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
 	printk(KERN_WARNING "3w-sas: Suspending host %d.\n", tw_dev->host->host_no);
@@ -1779,31 +1778,18 @@ static int twl_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* Clear doorbell interrupt */
 	TWL_CLEAR_DB_INTERRUPT(tw_dev);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 } /* End twl_suspend() */
 
 /* This function is called on PCI resume */
-static int twl_resume(struct pci_dev *pdev)
+static int __maybe_unused twl_resume(struct device *dev)
 {
 	int retval = 0;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
 	printk(KERN_WARNING "3w-sas: Resuming host %d.\n", tw_dev->host->host_no);
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	retval = pci_enable_device(pdev);
-	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x24, "Enable device failed during resume");
-		return retval;
-	}
-
-	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
 	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
@@ -1841,11 +1827,9 @@ static int twl_resume(struct pci_dev *pdev)
 
 out_disable_device:
 	scsi_remove_host(host);
-	pci_disable_device(pdev);
 
 	return retval;
 } /* End twl_resume() */
-#endif
 
 /* PCI Devices supported by this driver */
 static struct pci_device_id twl_pci_tbl[] = {
@@ -1854,16 +1838,15 @@ static struct pci_device_id twl_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, twl_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(twl_pm_ops, twl_suspend, twl_resume);
+
 /* pci_driver initializer */
 static struct pci_driver twl_driver = {
 	.name		= "3w-sas",
 	.id_table	= twl_pci_tbl,
 	.probe		= twl_probe,
 	.remove		= twl_remove,
-#ifdef CONFIG_PM
-	.suspend	= twl_suspend,
-	.resume		= twl_resume,
-#endif
+	.driver.pm	= &twl_pm_ops,
 	.shutdown	= twl_shutdown
 };
 
-- 
2.28.0

