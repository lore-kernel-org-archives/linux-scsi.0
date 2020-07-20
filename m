Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EFDC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FBD222B4D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZitzKSot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgGTNie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgGTNie (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:38:34 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3027C061794;
        Mon, 20 Jul 2020 06:38:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w17so8684454ply.11;
        Mon, 20 Jul 2020 06:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BmYWixz0aTv3tC/NVtl+PgP5U+VPOImgYj6l6MODrn0=;
        b=ZitzKSotSMYuVxFddRWQGcSOld//v5PMyrinmWCo2p4XajxA2YScunUFT0+FoToQPR
         JR69sfeEpBkunQ/hysGs4cPHZu9IJ0GllHhp4fiNCABn9BkcKAdDsEZA2AL5Y3qJS1NF
         2VexKaVr5eljdRN3vZTGVCjsfNBUgOs1ms8NQjXZIAgt7bjvu0R98JlgS6vEPMRvvkjE
         BrYQ5PYaRrKki+z7I6HgxHark/qqOEtCXyP/oeyLJqOjSTe2jhEJuk7BX7oLxnTiTnEN
         W/zZ5yE4YeRPySiOu1FuIxB4U/hyiiQIVyXI9qSxOjdrv8bxRt+WRH9Llk9HRxGdkN7f
         cLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BmYWixz0aTv3tC/NVtl+PgP5U+VPOImgYj6l6MODrn0=;
        b=GcnwWr0gk2ZcnUZ1CLhOS1DdkJ2duCtgkL+HIIlJV2Gpdzd2xKRmpI3/WI3uuIbr4l
         IyeC9PvLfHhibdVznAl9av4gBEoasxNkoRqbJ1U4qA/v/3Z3nZIhuk3JFym3Ze7VbWU2
         1l7nuvUAphE1IGGRDkps3Acil23xXhZMKB1Zz6bzHLXRxYf4qdyUZrlorM9fTJtdAwWX
         mvbHrvGJEKfxwDTtKpxSLFhjBmX7EzgxY3GUztzMreZPHNAmrTVFlshqjCMn9K36GwgS
         RaNTFxxV24oakwSM2XcplwR4P19puXDVG2QYbmgBEerPwVJYC6SjHdK1PY8PDGytr4c3
         jtRg==
X-Gm-Message-State: AOAM532dmcoOvpZaZntUaj4+8rGKKn9sYd5gz9OR+vEf2OgQzAwGdTNJ
        eQ4x0vBBPQ0Mr2fptb07h8M=
X-Google-Smtp-Source: ABdhPJxT2OzZDQ83ttwu6CQFTDlgDPHGcMfjy/aLex6+Ho5gCYlPQjBRTDaVJh74isGNN4QRbSg4XA==
X-Received: by 2002:a17:90a:dd44:: with SMTP id u4mr22101207pjv.203.1595252313489;
        Mon, 20 Jul 2020 06:38:33 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:38:33 -0700 (PDT)
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
Subject: [PATCH v2 12/15] scsi: 3w-9xxx: use generic power management
Date:   Mon, 20 Jul 2020 19:04:25 +0530
Message-Id: <20200720133427.454400-13-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
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

