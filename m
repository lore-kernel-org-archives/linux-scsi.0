Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79BBC433EA
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9780D20704
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B15O9is8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGQGia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgGQGi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:38:29 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF88C061755;
        Thu, 16 Jul 2020 23:38:29 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j19so6189902pgm.11;
        Thu, 16 Jul 2020 23:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BmYWixz0aTv3tC/NVtl+PgP5U+VPOImgYj6l6MODrn0=;
        b=B15O9is89PmX5an+uhM//ru71UM53jvDp3CejX0ogqr/+64eYgHITIjTbjOASxPvSf
         LEfLfM7E0XeG5y70TdtaSH/5/fV7SYxE9oKrUJZk10ICoCodnxEMIICJZ1CkSKY8JDJT
         /udWMKXmEtF2qhVgaHW4uLfZHODaY/vYfBw/qFLpBksJBw3hNJouno5XHevbHBoEMRI/
         3H5LSqqrCeXYjhGV3G1pNNsCoA+YMgmX8Eg2n56oGTf5AdKDk60CgfumYPATFqdqMtBt
         SHnnX7VQ7lq8V8EC0GjS1S/Wn9VBZ1iyDInvk5SGMEpAd/Vkxt2FugTMntAmGFeZS1iy
         XaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BmYWixz0aTv3tC/NVtl+PgP5U+VPOImgYj6l6MODrn0=;
        b=S1J+IGxwgcn5esfCJgs44gfPxt9hY2J5qB9JPHcfG4EpvBa7Ch0iuERDD7EoOXPc9o
         VKY//rZjXQjBjDKh+x9ZVXtmBWcqywY1kdAvFtk1MDojp9iwPd37KZqiFJSKPHADjmXZ
         WoZCwmSjjSTifqTVDd9J5wgp+IjdZmyD3iwho0gWsMJc1wzVMGJUS9JRkXS/L85cbhok
         uca4SOunM+80WIkmDm6U0ll1t1xqDhVfaE6BOuCPDojlTbhNGH15gL+I6oOGQJkTlm7k
         TUxVKaH0nAGXc/wESVKRs3bhixigfd+5KD8j//ZGyzySOm9Mz8q6wsKgWqx7eto9wOfs
         5F5g==
X-Gm-Message-State: AOAM532uozeo+hvy3uh6PPBjwtarWlTFjECDOnncmABRdtU2VsWKRspa
        MGOzew6aenYwGajOIbBukrs=
X-Google-Smtp-Source: ABdhPJxGCQWL/9E1w9acU0hXq4cs5O3+hjFZKLMA2/nH5aPGnWddfFiiN6ogP/l2PN+DUhGR05YEHA==
X-Received: by 2002:a63:4f4d:: with SMTP id p13mr6909259pgl.400.1594967909160;
        Thu, 16 Jul 2020 23:38:29 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:38:28 -0700 (PDT)
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
Subject: [PATCH v1 12/15] scsi: 3w-9xxx: use generic power management
Date:   Fri, 17 Jul 2020 12:04:35 +0530
Message-Id: <20200717063438.175022-13-vaibhavgupta40@gmail.com>
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
"struct device*" type. Use to_pci_dev() and dev_get_drvdata() to get
"struct pci_dev*" variable and drv data.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/3w-9xxx.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..c15dcfda3957 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2191,10 +2191,10 @@ static void twa_remove(struct pci_dev *pdev)
 	twa_device_extension_count--;
 } /* End twa_remove() */
 
-#ifdef CONFIG_PM
 /* This function is called on PCI suspend */
-static int twa_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused twa_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
@@ -2214,32 +2214,21 @@ static int twa_suspend(struct pci_dev *pdev, pm_message_t state)
 	}
 	TW_CLEAR_ALL_INTERRUPTS(tw_dev);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 } /* End twa_suspend() */
 
 /* This function is called on PCI resume */
-static int twa_resume(struct pci_dev *pdev)
+static int __maybe_unused twa_resume(struct device *dev)
 {
 	int retval = 0;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
 	printk(KERN_WARNING "3w-9xxx: Resuming host %d.\n", tw_dev->host->host_no);
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
 
-	retval = pci_enable_device(pdev);
-	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x39, "Enable device failed during resume");
-		return retval;
-	}
+	device_wakeup_disable(dev);
 
-	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
 	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
@@ -2277,11 +2266,9 @@ static int twa_resume(struct pci_dev *pdev)
 
 out_disable_device:
 	scsi_remove_host(host);
-	pci_disable_device(pdev);
 
 	return retval;
 } /* End twa_resume() */
-#endif
 
 /* PCI Devices supported by this driver */
 static struct pci_device_id twa_pci_tbl[] = {
@@ -2297,16 +2284,15 @@ static struct pci_device_id twa_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, twa_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(twa_pm_ops, twa_suspend, twa_resume);
+
 /* pci_driver initializer */
 static struct pci_driver twa_driver = {
 	.name		= "3w-9xxx",
 	.id_table	= twa_pci_tbl,
 	.probe		= twa_probe,
 	.remove		= twa_remove,
-#ifdef CONFIG_PM
-	.suspend	= twa_suspend,
-	.resume		= twa_resume,
-#endif
+	.driver.pm	= &twa_pm_ops,
 	.shutdown	= twa_shutdown
 };
 
-- 
2.27.0

