Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A464C4727F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C0020B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eEW+Bq2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbgJAM3T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731888AbgJAM3T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:29:19 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CA6C0613D0;
        Thu,  1 Oct 2020 05:29:19 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 5so3925007pgf.5;
        Thu, 01 Oct 2020 05:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gmS7YS0DYtnClD0w40MsdNzZxacHM1ziMOHmrUQ2hbc=;
        b=eEW+Bq2OFiAcFjiQ/Kh6k50Y+/jrfCr5zJgWHOXUF9hUA59/xEPLAC5NIH6AcsJBMX
         BDM5+3mWvmHQZpeEMRBTROgyKQ7Jida8YlMzGvfIr2M1+O7Qcy6+udFsjda+DF+B0FlJ
         a7k9ZIDbJgn2wWQSo/gHKzibWDxWlBAUTg9N5F9uNfEGJURBwfz8FL/ogjHqkOT40L3p
         t5OhMhSR3Vv2A3Inm8JLsOF6VmgbVWwHMl7/ozsy8H3cccXX5fZA4E7wO+/3r/JABzjE
         N3EBLbeNHJVkX5vl2hmg/XpJJN8f5akAJ5CEneJr/necgvUzjo01UgBRkG70MAjprecp
         weuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gmS7YS0DYtnClD0w40MsdNzZxacHM1ziMOHmrUQ2hbc=;
        b=mYqFq9KVqhcjj2zP/Bf4IumAT8Q87YIFS9yARKdZ7yp+5VC87hKOzIv0ZA+45xoIrH
         Q2mMyq9Q6tG6ibPZCUZvaHBEfRzz+rxt5cilYyZLOwRmXZp0w6zu9kRavnS95CM3Tzn0
         Uw0+PN5Bv56FESiwy+i2BMV3mleJnj/S6HpI3YEB298dLNfjDoEJYM60z/WrXkpXXvbm
         etd6xK44QRiezNR/lhPB1izlHAGA9HvfxJXxdjNMpiJkYJgAvFOoRsApquTKCejHdHt0
         lOANqmR3fp6/IYpPnRLVwANOIQLVMyRXl7OZoCSziTaa+t2HE7FfwReDMNfxMtrt32o1
         DlTQ==
X-Gm-Message-State: AOAM530AVr5FZrWfiAqEKxIzxElBk3HlEUOwd2iQ+nC1Ags2ZscbI21K
        GnZn4IUQXrXE+T7dydAM3Mw=
X-Google-Smtp-Source: ABdhPJwLO4BrCq7cf6OgUMx23vEZaXY9wyYutL8lxvt8uRhaE9u6WKIypSkdMK4htyWuRqaw/lpc+Q==
X-Received: by 2002:a63:544a:: with SMTP id e10mr5895346pgm.284.1601555358804;
        Thu, 01 Oct 2020 05:29:18 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:29:18 -0700 (PDT)
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
Subject: [PATCH v3 09/28] scsi: arcmsr: use generic power management
Date:   Thu,  1 Oct 2020 17:54:52 +0530
Message-Id: <20201001122511.1075420-10-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
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
 drivers/scsi/arcmsr/arcmsr_hba.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 6ed2ad10bede..43848b467d8c 100644
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
@@ -1080,28 +1081,19 @@ static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
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
-	pci_restore_state(pdev);
-	if (pci_enable_device(pdev)) {
-		pr_warn("%s: pci_enable_device error\n", __func__);
-		return -ENODEV;
-	}
 	if (arcmsr_set_dma_mask(acb))
 		goto controller_unregister;
-	pci_set_master(pdev);
+
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto controller_stop;
 	switch (acb->adapter_type) {
@@ -1136,9 +1128,7 @@ static int arcmsr_resume(struct pci_dev *pdev)
 	scsi_remove_host(host);
 	arcmsr_free_ccb_pool(acb);
 	arcmsr_unmap_pciregion(acb);
-	pci_release_regions(pdev);
 	scsi_host_put(host);
-	pci_disable_device(pdev);
 	return -ENODEV;
 }
 
-- 
2.28.0

