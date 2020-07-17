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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36349C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 108AD20737
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhCnWrlV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgGQGil (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgGQGik (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:38:40 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F0DC061755;
        Thu, 16 Jul 2020 23:38:40 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id o22so5913619pjw.2;
        Thu, 16 Jul 2020 23:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RikripnxLVJhOyZ4XpmPQ2DJ6E1+wwTxP7b6l3InheE=;
        b=VhCnWrlVuIyz7AwVCui94KEiOuUNmyxncfxqbFZc11QEkHWcxnnJ+iV88ox/biZaip
         XaYJ5BYRSQxlg8+5A310LaFxR7+XOjGIRdDV/8CtAPW+YsOgAj4Bp0lS3FMIaREzVglE
         nAeJafR5YmL6JRZ61jZe7FAwvCSkHYzg6CM3+DTV84yDjW+b7a4//u7u5hRmGRnd0iem
         FiVfKXTzGHrXEfbr2ty44lIX0Z+FCnzg/s+QJaCCFBdS8rR8KhuUJXtvKO4pzLh4lewQ
         71IgnJkFXcG3xRpOWNf7O/peLrCsnHTj5h8ud4yEyBQqlkIgpMHhoXoBNHcjfFv2zxyQ
         PUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RikripnxLVJhOyZ4XpmPQ2DJ6E1+wwTxP7b6l3InheE=;
        b=SbOgXKzw3ZU5jlJgxu8o0WqjJeaJdeLTyE6zLomVgDS3VsWLmCv38eQ5HkLhCfYM0n
         1E6e7S26XqvtVwrhKoQNRYBY5nzEKT+SAphhUGrEv4aGY9L3ToSCTqnQvopDo9pjM5sG
         eWvgRkjmSZ/tJfF8emEZ41X0iNTg1aO74NEcnUBz/jA++lt0eEo6BF16Q+3Nq0h52j4I
         qThpZ4aS4+ieCUMf88AwWWbD9XhpCF0iO0ntSqrXgfo/fZmW+lx24LeRIzniT9hpMWnM
         SKkGUt2aURvegCn5RsdLDt4ZRPXgSMlgvzvPyaaTyrek3Np6TWZu/gMjV+NkXiBAC1qZ
         IqfA==
X-Gm-Message-State: AOAM530eEjjBdnX9sCUq75DjYnrWfMRR00VpcGMN6GVWVYTRNege4Twq
        F8f7Qp2LPPtOysZfyVpj73g=
X-Google-Smtp-Source: ABdhPJw7YE0e6HZJF+/KkxyNrXDNr/YXVjAKIvA0OlzHmaQS+1qgZgZOiOd5na4GnyGLDQX2K/BZvw==
X-Received: by 2002:a17:902:7791:: with SMTP id o17mr6591565pll.224.1594967920217;
        Thu, 16 Jul 2020 23:38:40 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:38:39 -0700 (PDT)
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
Subject: [PATCH v1 13/15] scsi: 3w-sas: use generic power management
Date:   Fri, 17 Jul 2020 12:04:36 +0530
Message-Id: <20200717063438.175022-14-vaibhavgupta40@gmail.com>
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
 drivers/scsi/3w-sas.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index dda6fa857709..efaba30b0ca8 100644
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
@@ -1779,32 +1778,21 @@ static int twl_suspend(struct pci_dev *pdev, pm_message_t state)
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
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
 
-	retval = pci_enable_device(pdev);
-	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x24, "Enable device failed during resume");
-		return retval;
-	}
+	device_wakeup_disable(dev);
 
-	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
 	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
@@ -1842,11 +1830,9 @@ static int twl_resume(struct pci_dev *pdev)
 
 out_disable_device:
 	scsi_remove_host(host);
-	pci_disable_device(pdev);
 
 	return retval;
 } /* End twl_resume() */
-#endif
 
 /* PCI Devices supported by this driver */
 static struct pci_device_id twl_pci_tbl[] = {
@@ -1855,16 +1841,15 @@ static struct pci_device_id twl_pci_tbl[] = {
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
2.27.0

