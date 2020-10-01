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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD5BC4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D946620B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k7GKoiAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbgJAM2E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732048AbgJAM2D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:28:03 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CEEC0613D0;
        Thu,  1 Oct 2020 05:28:03 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id l18so1894269pjz.1;
        Thu, 01 Oct 2020 05:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4T8XvHSCCKBEvcExwNjwW62MsEy/1YjMUFgvIQB5ws8=;
        b=k7GKoiATiSxjT+F9rfYPUKEXdcXcEVFwTV8Ldohq5M5ctIOadQKeOXqZ7COD+LFNkW
         xJFWjfC43YY7ntIrA8MADedQcYARCXs3KlhMdKrP+tNVn5941RzEGzKfs4KFnctsc6sQ
         vD3bb+KDPIsfTS4qwlX+VJbWibkh4O5XOf8ceoTpBEwBMj6rxB3CIf6uYGpycNJ/rgtv
         h81Mj2nvmk5piuRy7umzrv3CFMP6H5ahDMBpulwMvWF2l6hmJFAv86Y3CCRuLNQh7E68
         r7Ah63vSHCjcP4h2pqv9//GVLUfGTOqRuJ3HzOUVRUcNOSYEIto46mkr05ULO5ntnPkA
         74Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4T8XvHSCCKBEvcExwNjwW62MsEy/1YjMUFgvIQB5ws8=;
        b=D+cnDpMehafDTZ7bCKEAc9fiXMmD07MJHcoM54bk48g1vhfCgAPOS5m/23IrldpNOx
         csl5xt5rIXPG9Cm2IiPrtsNht+q2g9LNJzptesNi28f2g1o0HEWObxpltCRPI8R//aig
         MhoDjzEV8NLBbMqW0dFVOI0SvN1hxlB2czkpNUUtKciV3FTdIDQhVHxbAqVB5StgIpxy
         53+I0Bs3gsV7uKU0RcXggcFyBJ3/D26SY1RIDk3Ip9Rs5/5yBCvIDYCDS48YoiXJ5CeP
         J/qnZG57dJTXs2m0do83eoUVlYLNBi/fhpA41x+Rd5dXnWLMCqoQ0UFNN7YAtp69Xq+B
         It8w==
X-Gm-Message-State: AOAM532tLdvdN31icHUKmRFvS2/Qeb0oTA8wVwsPhVelGFizp7WYnGEA
        34Fgt4v+bPSQBpe7Z+1Zv3g=
X-Google-Smtp-Source: ABdhPJxuLh9trbu2zHl2tlaTucRQjVNAPfjayrHOdJidMlZ1JGhKEcFq5fQgu4N2gmE6GpuQMiaSkQ==
X-Received: by 2002:a17:90b:34e:: with SMTP id fh14mr6980697pjb.186.1601555283391;
        Thu, 01 Oct 2020 05:28:03 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:28:02 -0700 (PDT)
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
Subject: [PATCH v3 02/28] scsi: megaraid_sas: use generic power management
Date:   Thu,  1 Oct 2020 17:54:45 +0530
Message-Id: <20201001122511.1075420-3-vaibhavgupta40@gmail.com>
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
 drivers/scsi/megaraid/megaraid_sas_base.c | 51 ++++++-----------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 93ade9915ec0..72aa7fabe051 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7539,25 +7539,23 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
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
 	struct megasas_instance *instance;
 
-	instance = pci_get_drvdata(pdev);
+	instance = dev_get_drvdata(dev);
 
 	if (!instance)
 		return 0;
 
 	instance->unload = 1;
 
-	dev_info(&pdev->dev, "%s is called\n", __func__);
+	dev_info(dev, "%s is called\n", __func__);
 
 	/* Shutdown SR-IOV heartbeat timer */
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
@@ -7587,47 +7585,29 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
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
+ * @dev:		Device structure
  */
-static int
-megasas_resume(struct pci_dev *pdev)
+static int __maybe_unused
+megasas_resume(struct device *dev)
 {
 	int rval;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	u32 status_reg;
 
-	instance = pci_get_drvdata(pdev);
+	instance = dev_get_drvdata(dev);
 
 	if (!instance)
 		return 0;
 
 	host = instance->host;
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	dev_info(&pdev->dev, "%s is called\n", __func__);
-	/*
-	 * PCI prepping: enable device set bus mastering and dma mask
-	 */
-	rval = pci_enable_device_mem(pdev);
 
-	if (rval) {
-		dev_err(&pdev->dev, "Enable device failed\n");
-		return rval;
-	}
-
-	pci_set_master(pdev);
+	dev_info(dev, "%s is called\n", __func__);
 
 	/*
 	 * We expect the FW state to be READY
@@ -7753,14 +7733,8 @@ megasas_resume(struct pci_dev *pdev)
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
@@ -8507,6 +8481,8 @@ static const struct file_operations megasas_mgmt_fops = {
 	.llseek = noop_llseek,
 };
 
+static SIMPLE_DEV_PM_OPS(megasas_pm_ops, megasas_suspend, megasas_resume);
+
 /*
  * PCI hotplug support registration structure
  */
@@ -8516,8 +8492,7 @@ static struct pci_driver megasas_pci_driver = {
 	.id_table = megasas_pci_table,
 	.probe = megasas_probe_one,
 	.remove = megasas_detach_one,
-	.suspend = megasas_suspend,
-	.resume = megasas_resume,
+	.driver.pm = &megasas_pm_ops,
 	.shutdown = megasas_shutdown,
 };
 
-- 
2.28.0

