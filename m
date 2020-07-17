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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8FFC433F1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AECF2071A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:37:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IweNWT3F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgGQGhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgGQGhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:37:08 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B93C061755;
        Thu, 16 Jul 2020 23:37:08 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o1so5040926plk.1;
        Thu, 16 Jul 2020 23:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bpDL8hP0A1+XBDIs+//qQv7nf7yzkQKaBmD5iZnM/EU=;
        b=IweNWT3F37KxrySTtbOS9oR9BBnblpwmSbjNHt5+mxd+w9Fa1JuOTIzXAQOyu7P4qk
         FymNOj0SYUs2nArqC0F2SMinNNbQwK888kKqN0wGCnXNu6/XUd7AeejFbggCGKnOlolu
         0yLPS6M9waAxVMo3JSwtnC7j0gba08ooWEMZ7lx+nzN8lPwmw/C7ZrJ23iXlfif8oL9s
         EtoHOCIdDicj7Q9ZvAaRvEZsX+i8sHvFLUBPNYfv0dxcd1C7pPGEgDkvl3IXBOZCfsq8
         trotl3ZgLzqCd3ew8eCJeqkMeY3McKIY4mSIdX3f3oxwQhN1rpsuw7azajPNrHPpwBG0
         ol2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bpDL8hP0A1+XBDIs+//qQv7nf7yzkQKaBmD5iZnM/EU=;
        b=Adh68M9lRsnyCfJhc3DtPXs62VDdc76jx3LcpOlRMyzgZYnpe4RFksY/KLACCpf+l8
         SHwtG7l7z1exBvHgqlBo7pM9Hjh+Xw1++5Z7SJyVBVS+7Ep0X1/Bx2ns0TehJvE6/wPS
         NIaqtldOU6ZdIygYZgVduMS7T/Hgmb6yyyjfSL+bH9hzwJ3hilQrQIZsKp6audkM2Za6
         R1P5JLUl65mUdipUeW3+LSswmJudRM+VT3ZpizB68yucTCb113NYuBhJRblhWexiEZiJ
         gE39MM3O0RSNVx1H3vtdmTZsVtzPSCT7DZMI+Dkfo9AEn+oJfY6cDstlQS+IWuFegCgo
         B0hA==
X-Gm-Message-State: AOAM531DONlVbMopaQ6UueXA/qQ1JBB8m1bIcO5+h4uDOsYVfD6ZOZKs
        aXjUw0I5MxYk6mmIHr6UY3Q=
X-Google-Smtp-Source: ABdhPJw+PiIo4bkP9JRIPLqYBkIFKaXE2tEy/mGPbiN03Pt+08kENWVwHfeH2m5T5g2/tKRQTK45/w==
X-Received: by 2002:a17:902:c405:: with SMTP id k5mr6613793plk.233.1594967827749;
        Thu, 16 Jul 2020 23:37:07 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:37:07 -0700 (PDT)
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
Subject: [PATCH v1 05/15] scsi: arcmsr: use generic power management
Date:   Fri, 17 Jul 2020 12:04:28 +0530
Message-Id: <20200717063438.175022-6-vaibhavgupta40@gmail.com>
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

Driver was also using PCI helper functions like pci_save/restore_state(),
pci_disable/enable_device(), pci_set_power_state() and pci_enable_wake().
They should not be invoked by the driver.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 35 ++++++++++++--------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 30914c8f29cc..7e098ddcc4f5 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -113,8 +113,8 @@ static int arcmsr_bios_param(struct scsi_device *sdev,
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int arcmsr_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
-static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);
-static int arcmsr_resume(struct pci_dev *pdev);
+static int __maybe_unused arcmsr_suspend(struct device *dev);
+static int __maybe_unused arcmsr_resume(struct device *dev);
 static void arcmsr_remove(struct pci_dev *pdev);
 static void arcmsr_shutdown(struct pci_dev *pdev);
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);
@@ -213,13 +213,14 @@ static struct pci_device_id arcmsr_device_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
 
+static SIMPLE_DEV_PM_OPS(arcmsr_pm_ops, arcmsr_suspend, arcmsr_resume);
+
 static struct pci_driver arcmsr_pci_driver = {
 	.name			= "arcmsr",
 	.id_table		= arcmsr_device_id_table,
 	.probe			= arcmsr_probe,
 	.remove			= arcmsr_remove,
-	.suspend		= arcmsr_suspend,
-	.resume			= arcmsr_resume,
+	.driver.pm		= &arcmsr_pm_ops,
 	.shutdown		= arcmsr_shutdown,
 };
 /*
@@ -1065,14 +1066,14 @@ static void arcmsr_free_irq(struct pci_dev *pdev,
 	pci_free_irq_vectors(pdev);
 }
 
-static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused arcmsr_suspend(struct device *dev)
 {
-	uint32_t intmask_org;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)host->hostdata;
 
-	intmask_org = arcmsr_disable_outbound_ints(acb);
+	arcmsr_disable_outbound_ints(acb);
 	arcmsr_free_irq(pdev, acb);
 	del_timer_sync(&acb->eternal_timer);
 	if (set_date_time)
@@ -1080,29 +1081,21 @@ static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
 	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
-	pci_set_drvdata(pdev, host);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 	return 0;
 }
 
-static int arcmsr_resume(struct pci_dev *pdev)
+static int __maybe_unused arcmsr_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)host->hostdata;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
-	if (pci_enable_device(pdev)) {
-		pr_warn("%s: pci_enable_device error\n", __func__);
-		return -ENODEV;
-	}
+	device_wakeup_disable(dev);
+
 	if (arcmsr_set_dma_mask(acb))
 		goto controller_unregister;
-	pci_set_master(pdev);
+
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto controller_stop;
 	switch (acb->adapter_type) {
@@ -1137,9 +1130,7 @@ static int arcmsr_resume(struct pci_dev *pdev)
 	scsi_remove_host(host);
 	arcmsr_free_ccb_pool(acb);
 	arcmsr_unmap_pciregion(acb);
-	pci_release_regions(pdev);
 	scsi_host_put(host);
-	pci_disable_device(pdev);
 	return -ENODEV;
 }
 
-- 
2.27.0

