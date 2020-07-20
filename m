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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934EBC433F1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68D9222CB1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aIWS1iDS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgGTNh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGTNh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:37:27 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88993C061794;
        Mon, 20 Jul 2020 06:37:27 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b9so8701870plx.6;
        Mon, 20 Jul 2020 06:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bpDL8hP0A1+XBDIs+//qQv7nf7yzkQKaBmD5iZnM/EU=;
        b=aIWS1iDSUm2VTLaN9ACrEdgMlbuhD4ZZWpEBNAl0ATKxHpck66GEgX77MUFDxES/14
         ihg909GqmZH8kZAoTh96f4sUM6TYCfyINKyU61WdoGG5cSpr4ijjn5r+Kzd1iFB2S9eq
         82rCoH2ETCz3u3co90YsoIsiXgQGjPvyQztyxR3+ZmmhY9SDMqGeNw7o/G6Xv11lIAxk
         e8QZ157i0DgGjc9ndtVj2nP1AQttFhyZP03QifoznI3bgrv9w+/Q/6hweGSLvLSJBpDr
         hXqZlu5t/rUXymJU/6B0p7TZGAdlySbMrAYGCyw004g2l40OE4f15xlsGLs8MmdjWKGU
         Zmxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bpDL8hP0A1+XBDIs+//qQv7nf7yzkQKaBmD5iZnM/EU=;
        b=V3cqzUYKZTXLOv1HUccBnw6nmLmBQV3fjbLXd1p1d11a0Xxd3kg1ANdtWpSmj08KpW
         0DhS1oul3uSrrr66AjZ82a7tJtE8Q0UO4nAu62fD5yOFxm5usaBtlQrKNsl46AZAqMpa
         a/fO9JAcFddZ43DpHIJWqWx6CbMYGz5pRB1pdc3cYY7vy9T04AS/OORffhdDFUanL8q2
         5UyIUgUhLwlzbUjlXI4XQyIbSuq+W+gdtpJU9hxlEPnlhQSRpeHITJjLRE+/sp39w/45
         EGKY/K5bahk7mwDqfIwT9uYqB/Ryu3OOW/189vrNuSbgeiQRc9eRGCf7r+ojWR0O8Doo
         CMPQ==
X-Gm-Message-State: AOAM532MR02qoTH8vjJY5iLFEHd4w7kUWeBoRZT4jdUz5LXjpgYP2Xbz
        NiE56MTzUzTE+xtj8OSLB8I=
X-Google-Smtp-Source: ABdhPJwATblenhS1dEt8I55FiSAhco/yd1XFQJzqKKNvo5kMw2YTTJ66SHhtFKHhbd7Yu8kkl4nUJg==
X-Received: by 2002:a17:902:b207:: with SMTP id t7mr5567455plr.135.1595252247070;
        Mon, 20 Jul 2020 06:37:27 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:37:26 -0700 (PDT)
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
Subject: [PATCH v2 05/15] scsi: arcmsr: use generic power management
Date:   Mon, 20 Jul 2020 19:04:18 +0530
Message-Id: <20200720133427.454400-6-vaibhavgupta40@gmail.com>
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

