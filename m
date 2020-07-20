Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABBDC433EA
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B472F22B4D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTvtzKf5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgGTNhC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgGTNhB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:37:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1141C061794;
        Mon, 20 Jul 2020 06:37:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 1so9066389pfn.9;
        Mon, 20 Jul 2020 06:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IdweH5iSZf0gdMKKw0PG0GQ37VlTq8MURVu5SpxFL8o=;
        b=dTvtzKf5u14KTq3Qo4MS32B2wl3t0WwDIS6RZq2AzhGyAoF9c79LmsKHFc0f1IPSLj
         H42PPKKSzbx3QpvK1j7NY81Jl8p1fZFDFJMwPviE9PgkiEywwkBD5MFV3zxGG7TQHKUt
         UxqtM9QQF07xBO7yHVKv7nvObBFohg7proJXwcy/LmNCyIqwl+T5ZgzA3LU9h6Uq5K2z
         Zo126c+A2Ce6/oTXUcijlJ9Dsaj1CL8+4NL0AM3U7Fhc1R1wsuvIKZ7d0BrIHEXgyM+W
         Hli9LWEG/CRXGpWhzAJoZmtk4C5k5MgZDEzemhdwouEABGxCRGznPAjgo9V+OZ+54nDy
         m1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IdweH5iSZf0gdMKKw0PG0GQ37VlTq8MURVu5SpxFL8o=;
        b=P8Yzv96v5/gg9tHxzDvu++OW0/GCkn8jPKjSx7kRuKhscHxbuYlTCPSjsDoMybdMIh
         cX7lwveB8qyswZasP4KYGKtCKXwnHIpp+bgxEXeWTDw8T78pglgsQVA+CzCLZutKZh5S
         ZttR5CeKDW6S2KpxCNpXqAHOs1Mz+Fvd0kEP0FtpBzpitwRBh3L3f7GVETlkwUDpp0Zq
         XBt4V1M200RgCGI3zF4cx233EqQvo3gm5m63INK6HRtMOLLzBMBSVqEcv/BaNTXxTRCV
         GVkyHezJBt3Q5nRB3Wjd4lTlZPK97P8ziChJYS0OFWBDfNA9PLVZemn5C2CyzfoHD/lI
         RKNQ==
X-Gm-Message-State: AOAM532FINwVH85tta3CO08iyaPOL9/yh/hJjr2D0LnfmuA8dklitChV
        9WooBlReRv07fyqWKDfoLrk=
X-Google-Smtp-Source: ABdhPJyHcL/kBC1X6AD+L1l5fyG+XyKuNwUWeYclFGNiwkT/aXyqBb90T/V83ukb8VZSqg6g9i0cgA==
X-Received: by 2002:a65:43c1:: with SMTP id n1mr18160536pgp.67.1595252221196;
        Mon, 20 Jul 2020 06:37:01 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:37:00 -0700 (PDT)
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
Subject: [PATCH v2 02/15] scsi: aacraid: use generic power management
Date:   Mon, 20 Jul 2020 19:04:15 +0530
Message-Id: <20200720133427.454400-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
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

