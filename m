Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECF4C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C0C22BF3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L5mvZu6Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgGTNgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgGTNgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:36:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FD7C061794;
        Mon, 20 Jul 2020 06:36:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z3so9053471pfn.12;
        Mon, 20 Jul 2020 06:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=624qkN4yg02IbR91iT0KJtyB2F7+A2PWVFd6FOnEiqw=;
        b=L5mvZu6Y0PA/kxQgFWSzGFIhD9m8Jb1w+tZvC2qWKhreKxa5MBc8oyTzu1XK4/CRk7
         co0nr0Dq5dw6386etbWbqRYudb4iNlhzqXG/1p0h5mX3WMewWmIV/IUUJH3KcxDcVIed
         hJrSeRmZCUdq9CeDxDvschlP68Cb6kKFPEiiBQxMr5Gtcms4/JlOPu6vf2xwh93BaB1T
         cyIOiQeHbPvp2j9CHU9qGtr7axaj3TIvvkeLYQjOQtsWpgAdtm67cYi4IRq9mKG/mGs1
         yNegdIqI3fNvUv25T5MfoOvXfLYoEWptGYHyAHk4mDQpriDnDXrjmIr9PFNLz08qEj1G
         zwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=624qkN4yg02IbR91iT0KJtyB2F7+A2PWVFd6FOnEiqw=;
        b=HXUF1vgnxzLZEzJmr2kx5wqthbJC2VQqQVDh2M0Yv7+pEjuaoGQ6W9X/yxeFF47NU5
         jOSb9w5uldkniwKCCmE0BE8cmVqB+1Hom/HtZC85dOSHft3sETkZXsH3eMJXL1FxAxLm
         CWTIg6/cWO6Px6eAbRs/ZGStdN7fMngcNzHuGFRibPGSFxJ++yjH8zf4/NAkM/FmeDKi
         BQwgWiHsDL5IjOZXDv2qCRYACPnUuDRI19Zp7JrVgrGtAsx9vAofRGNm+g6eejeot+PM
         QDrjeXC19E/B+c8PSP6LCiaCkeN8A3ji/VVY7orsFa0SiyIgExJiu5mwf4N4PX8izd8Z
         xSPA==
X-Gm-Message-State: AOAM531F8zxNTC/YKtMyzRA8JJoYJXrEg2XTReC+kk/NRRuSi/u5nJsg
        QhDoyBr/OmPWXN6O7g0ropU=
X-Google-Smtp-Source: ABdhPJzeeILAH5AKHFbrob9musiOlBQpaGjZJAQG5Cea6/C3CZQGhp3zWQsxd/pgAYKPg646RFCxRg==
X-Received: by 2002:a63:475c:: with SMTP id w28mr19421733pgk.222.1595252212684;
        Mon, 20 Jul 2020 06:36:52 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:36:52 -0700 (PDT)
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
Subject: [PATCH v2 01/15] scsi: megaraid_sas: use generic power management
Date:   Mon, 20 Jul 2020 19:04:14 +0530
Message-Id: <20200720133427.454400-2-vaibhavgupta40@gmail.com>
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
.resume() callbacks. As the .suspend() work with "struct instance*",
extract it from "struct device*" using dev_get_drv_data().

Driver was also using PCI helper functions like pci_save/restore_state(),
pci_disable/enable_device(), pci_set_power_state() and pci_enable_wake().
They should not be invoked by the driver.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 61 ++++++-----------------
 1 file changed, 16 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 00668335c2af..4a6ee7778977 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7539,25 +7539,21 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	megasas_return_cmd(instance, cmd);
 }
 
-#ifdef CONFIG_PM
 /**
  * megasas_suspend -	driver suspend entry point
- * @pdev:		PCI device structure
- * @state:		PCI power state to suspend routine
+ * @dev:		Device structure
  */
-static int
-megasas_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused
+megasas_suspend(struct device *dev)
 {
-	struct megasas_instance *instance;
-
-	instance = pci_get_drvdata(pdev);
+	struct megasas_instance *instance = dev_get_drvdata(dev);
 
 	if (!instance)
 		return 0;
 
 	instance->unload = 1;
 
-	dev_info(&pdev->dev, "%s is called\n", __func__);
+	dev_info(dev, "%s is called\n", __func__);
 
 	/* Shutdown SR-IOV heartbeat timer */
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
@@ -7579,7 +7575,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	tasklet_kill(&instance->isr_tasklet);
 
-	pci_set_drvdata(instance->pdev, instance);
+	dev_set_drvdata(dev, instance);
 	instance->instancet->disable_intr(instance);
 
 	megasas_destroy_irqs(instance);
@@ -7587,48 +7583,28 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 }
 
 /**
  * megasas_resume-      driver resume entry point
- * @pdev:               PCI device structure
+ * @dev:              Device structure
  */
-static int
-megasas_resume(struct pci_dev *pdev)
+static int __maybe_unused
+megasas_resume(struct device *dev)
 {
 	int rval;
 	struct Scsi_Host *host;
-	struct megasas_instance *instance;
+	struct megasas_instance *instance = dev_get_drvdata(dev);
 	u32 status_reg;
 
-	instance = pci_get_drvdata(pdev);
-
 	if (!instance)
 		return 0;
 
 	host = instance->host;
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
+	device_wakeup_disable(dev);
 
-	dev_info(&pdev->dev, "%s is called\n", __func__);
-	/*
-	 * PCI prepping: enable device set bus mastering and dma mask
-	 */
-	rval = pci_enable_device_mem(pdev);
-
-	if (rval) {
-		dev_err(&pdev->dev, "Enable device failed\n");
-		return rval;
-	}
-
-	pci_set_master(pdev);
+	dev_info(dev, "%s is called\n", __func__);
 
 	/*
 	 * We expect the FW state to be READY
@@ -7754,14 +7730,8 @@ megasas_resume(struct pci_dev *pdev)
 fail_set_dma_mask:
 fail_ready_state:
 
-	pci_disable_device(pdev);
-
 	return -ENODEV;
 }
-#else
-#define megasas_suspend	NULL
-#define megasas_resume	NULL
-#endif
 
 static inline int
 megasas_wait_for_adapter_operational(struct megasas_instance *instance)
@@ -7931,7 +7901,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 /**
  * megasas_shutdown -	Shutdown entry point
- * @device:		Generic device structure
+ * @pdev:		PCI device structure
  */
 static void megasas_shutdown(struct pci_dev *pdev)
 {
@@ -8508,6 +8478,8 @@ static const struct file_operations megasas_mgmt_fops = {
 	.llseek = noop_llseek,
 };
 
+static SIMPLE_DEV_PM_OPS(megasas_pm_ops, megasas_suspend, megasas_resume);
+
 /*
  * PCI hotplug support registration structure
  */
@@ -8517,8 +8489,7 @@ static struct pci_driver megasas_pci_driver = {
 	.id_table = megasas_pci_table,
 	.probe = megasas_probe_one,
 	.remove = megasas_detach_one,
-	.suspend = megasas_suspend,
-	.resume = megasas_resume,
+	.driver.pm = &megasas_pm_ops,
 	.shutdown = megasas_shutdown,
 };
 
-- 
2.27.0

