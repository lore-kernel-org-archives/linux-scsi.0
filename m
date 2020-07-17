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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B699C433EA
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36B6820704
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tla2d0uz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgGQGgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgGQGgk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:36:40 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2045C061755;
        Thu, 16 Jul 2020 23:36:40 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id 72so5037822ple.0;
        Thu, 16 Jul 2020 23:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IdweH5iSZf0gdMKKw0PG0GQ37VlTq8MURVu5SpxFL8o=;
        b=Tla2d0uzwL1jiJhk8Xy4SWhGoLxTIV7vpzA3TI0h26Fkn/e6UQnQLbb0DVgTlrJe2d
         2rg4QtZUhkmmjqoRHXVoF2RvbZLtT0fzYqaq2Z39zXmsJpQDcvYNdyNsD2m6kYAFvbtG
         ZaEXzt/+tf+Us0sBFLJ+7ZvqgPh+NTZHb1aM+HChElK8VZU1jPTNFSWEitdhDUiEBY/d
         GVCr74u5nwTMWzuyZQfXiLx0x9l6ASq+AHw/ndL01AoaXit/ZlUjeypqjbHY46xEqBmi
         J9xM5/VOJh+c7yjCiMdQxqg3BfBdM9P1vf3Jja2R4Qg7+bhkgZFV358NKfnYtXG4sTtm
         0dQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IdweH5iSZf0gdMKKw0PG0GQ37VlTq8MURVu5SpxFL8o=;
        b=Se4WpY2PO1d7nq6Cts0dc5VPkiJQO3WssgCjJ339nZ9CfUocXmhVJugkCnWMfmhKNm
         43cNyt5HoRSkv9FLjtSNszyaQVV0yDE0jEHUd2uAuy5v41TgzPFK60SqOe7Z65i68Ve4
         MXimlbdqZeG5S1N2zR/X0uhyEjZonkB9AL7fAixrY6XRZqmeqIZdz7X9KkFskXqtXGOz
         2+z6KQptMYqSJ5cib5TVAsCoXDC3joEXI9jap0eR+o6JgPMBC/APOLYXsVb+z3ZbeCcw
         dn7oEfmSEuPAGCLNas4T2ull8C7qlAyRuRVsifyMt9C4bJe/MJrzmLqk6r9hbUQavsHq
         ibMg==
X-Gm-Message-State: AOAM530AZ4cK4eOM7yrZWoZBiGmsw+MuwVIaNcD8CaF8rnKdoc4nDqce
        7P4fro/FKYG8XmP4JAMNG/Q=
X-Google-Smtp-Source: ABdhPJxxEZLAu75l5OO5swXwmM5p5783xFE71Z7eVoXFUTwXL4uCMhKZp0MW6oBEAMMTy0YPKR5HXA==
X-Received: by 2002:a17:90a:204:: with SMTP id c4mr8185240pjc.165.1594967800185;
        Thu, 16 Jul 2020 23:36:40 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:36:39 -0700 (PDT)
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
Subject: [PATCH v1 02/15] scsi: aacraid: use generic power management
Date:   Fri, 17 Jul 2020 12:04:25 +0530
Message-Id: <20200717063438.175022-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
References: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With legacy PM hooks, it was the responsibility of a driver to manage PCI
states and also the device's power state. The generic approach is to let
the PCI core handle the work.

PCI core passes "struct device*" as an argument to the .suspend() and
.resume() callbacks.

Driver was using PCI helper functions like pci_save/restore_state(),
pci_disable/enable_device(), pci_set_power_state() and pci_enable_wake().
They should not be invoked by the driver.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/aacraid/linit.c | 34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a308e86a97f1..1e44868ee953 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1910,11 +1910,9 @@ static int aac_acquire_resources(struct aac_dev *dev)
 
 }
 
-#if (defined(CONFIG_PM))
-static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused aac_suspend(struct device *dev)
 {
-
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	scsi_host_block(shost);
@@ -1923,29 +1921,16 @@ static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	aac_release_resources(aac);
 
-	pci_set_drvdata(pdev, shost);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 }
 
-static int aac_resume(struct pci_dev *pdev)
+static int __maybe_unused aac_resume(struct device *dev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
-	int r;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
-	r = pci_enable_device(pdev);
+	device_wakeup_disable(dev);
 
-	if (r)
-		goto fail_device;
-
-	pci_set_master(pdev);
 	if (aac_acquire_resources(aac))
 		goto fail_device;
 	/*
@@ -1960,10 +1945,8 @@ static int aac_resume(struct pci_dev *pdev)
 fail_device:
 	printk(KERN_INFO "%s%d: resume failed.\n", aac->name, aac->id);
 	scsi_host_put(shost);
-	pci_disable_device(pdev);
 	return -ENODEV;
 }
-#endif
 
 static void aac_shutdown(struct pci_dev *dev)
 {
@@ -2108,15 +2091,14 @@ static struct pci_error_handlers aac_pci_err_handler = {
 	.resume			= aac_pci_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(aac_pm_ops, aac_suspend, aac_resume);
+
 static struct pci_driver aac_pci_driver = {
 	.name		= AAC_DRIVERNAME,
 	.id_table	= aac_pci_tbl,
 	.probe		= aac_probe_one,
 	.remove		= aac_remove_one,
-#if (defined(CONFIG_PM))
-	.suspend	= aac_suspend,
-	.resume		= aac_resume,
-#endif
+	.driver.pm	= &aac_pm_ops,
 	.shutdown	= aac_shutdown,
 	.err_handler    = &aac_pci_err_handler,
 };
-- 
2.27.0

