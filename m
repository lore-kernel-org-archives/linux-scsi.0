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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C8BC433F2
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA3B20704
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:39:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BCdY58WA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgGQGjF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgGQGjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:39:04 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFBAC061755;
        Thu, 16 Jul 2020 23:39:03 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t6so6218479pgq.1;
        Thu, 16 Jul 2020 23:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3UmYWRJdZF39qPxiyCNEd3/I71syYWtAye2lr9jTA6I=;
        b=BCdY58WADm6UpJ5JU0mlK5H55GHa8V31bdBQgGtb7kbn0e8o1/W+3QfucNtBNjveRp
         DSKQFQfOs2vBGbp2ASOVon7CQG0ksLGwfcZojX15FvAwq13yOsdEuSdkMcyo3hv3w+oP
         kc9HL5fMgxdFTPMPGBSL2mJQGZgBDygRXU7p5B4ASMbpPWlucpYItkdF7xCv9Ruugxiv
         lLUX8eAhFVGYzEN5Arj34lCS8KCcihCOIZSBbYaMoE2PLrZL0OxAFlmDNEp9FYHd2gh1
         rNqV/DB7ytf2DOVbDQh94GlGo86D3wmywofvj6aFujvJlLkKresHOJ5nBS0rw/Wane0h
         k6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3UmYWRJdZF39qPxiyCNEd3/I71syYWtAye2lr9jTA6I=;
        b=B95tpOgytMcdhS06CbmBMoyJuw1xWtV2uu6B5DayZJo2Z3yVLDDTfpprR0nW+D00M5
         6lrI4UjxUp9y7Wo/FnWAR4mUmrVf36MdDflwAt7D+RaWJ5lDKtkE5sl/E3qCjrn5oYkp
         x+GsakMvgSjRsmSyCCsng751jivbSqwfJh1Ixspz/5VppWePykTSe+6aBh3pad82BqkS
         dnbQfNorP1CSllNcYHTYyS1BgPqPN/pQNJ0mI5ScTx6DN5affUwbg2tr/nq4bQ3Th0Q6
         yZ+SHqAVqZnxKtem4+GJdYjTFJ52xrfIV4YmatfIawnYbsJ2p3T23H5rYRuV3gh4XMJo
         2urw==
X-Gm-Message-State: AOAM531OieboY5Ymzie2yVucEDUobZCh8aEG5+49lfSXjz2kaflL7Qvo
        ofbkfNPt1V4Uwt6avFb5YJ4=
X-Google-Smtp-Source: ABdhPJxcmmKECoF0TfV4zG0jknFf/N+8haFoRRYUr/nQQejuy0NkIuTPWwREtvU2q5gTVoS9Ku8PJA==
X-Received: by 2002:a63:8f58:: with SMTP id r24mr7141799pgn.379.1594967943416;
        Thu, 16 Jul 2020 23:39:03 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:39:02 -0700 (PDT)
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
Subject: [PATCH v1 15/15] scsi: pmcraid: use generic power management
Date:   Fri, 17 Jul 2020 12:04:38 +0530
Message-Id: <20200717063438.175022-16-vaibhavgupta40@gmail.com>
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
pci_set_power_state() and to do required operations. In generic mode, they
are no longer needed.

Change function parameter in both .suspend() and .resume() to
"struct device*" type. Use to_pci_dev() to get "struct pci_dev*" variable.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/pmcraid.c | 42 ++++++++++--------------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index aa9ae2ae8579..e5f2667f745b 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5237,54 +5237,39 @@ static void pmcraid_remove(struct pci_dev *pdev)
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
 	int rc;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
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
+	device_wakeup_disable(dev);
 
 	if (sizeof(dma_addr_t) == 4 ||
 	    dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))
@@ -5337,18 +5322,10 @@ static int pmcraid_resume(struct pci_dev *pdev)
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
@@ -5836,6 +5813,8 @@ static int pmcraid_probe(struct pci_dev *pdev,
 	return -ENODEV;
 }
 
+static SIMPLE_DEV_PM_OPS(pmcraid_pm_ops, pmcraid_suspend, pmcraid_resume);
+
 /*
  * PCI driver structure of pmcraid driver
  */
@@ -5844,8 +5823,7 @@ static struct pci_driver pmcraid_driver = {
 	.id_table = pmcraid_pci_table,
 	.probe = pmcraid_probe,
 	.remove = pmcraid_remove,
-	.suspend = pmcraid_suspend,
-	.resume = pmcraid_resume,
+	.driver.pm = &pmcraid_pm_ops,
 	.shutdown = pmcraid_shutdown
 };
 
-- 
2.27.0

