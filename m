Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9C5C4727F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A7D121481
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+ygD2UH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgJAM2g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731946AbgJAM2g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:28:36 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791C9C0613D0;
        Thu,  1 Oct 2020 05:28:36 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u24so3942428pgi.1;
        Thu, 01 Oct 2020 05:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8kLo0gZF2UOxlz4SENenPZS/3x2aIQArUFdn3IjxG9Y=;
        b=G+ygD2UHHwE9QZJ1oE1FgDI12pyXUUyL1CzamuZ70w/mrL1bysB4o1u9EpLtah7hyJ
         jXwC0S4A+Zeqty7/8Hnn2Ani0rKdSzkhWXcasGcfwvckdnqhoOPbSbxVr0kvv5osCH2Z
         NjT2eJy3RVOO5Tm6hVQqEQR5rxEcPGL4lWNsqQ280jE4qLXmaPPbU2EYJFMps1IClVqT
         FF+zazMB6unFU5pkwVm2rrs+ioNrXysIjVBqToVAJmjlMMW3p5fsmE68PSd2PD69HmE/
         7gEtPgNw1x/vrOW42dSIaeQ8cTb1BeiKZeuXeFKbVsDxSAWJY3VhMwtKAOFwESGws/Tq
         ZaUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8kLo0gZF2UOxlz4SENenPZS/3x2aIQArUFdn3IjxG9Y=;
        b=gj9qgrL+Aequ8jFRysVVnyHX2+eOXcqxSB1dacFYYKIUVPgq8MXv1oeO4rfRz46Tbt
         OAOIwT/6aNvFLPMnbRictiyL9MxId01Nto1NPwseqkM4fXTCplgM07JdDTdKKg4SoAGc
         7DceYAwbOb4Q7mT9hK1INrDnjTlxiac+fNO7HVLJVGt9T18xWjKDpB6RkiVBOu2X/Mq9
         1wqb1j+C+quqnutRPGe4JPI/ouFm9oXGsiBuzaX7SaCEKsw0BwtIls3yk2Gk5dhHzFeF
         yB/oGzEZ8wlAjN0Ecu3j+S1JnnUaCbtz6ELVm3xn4joKZGckM4W9haVkQO0+hLlP7Y3t
         Ue9Q==
X-Gm-Message-State: AOAM530odC/aNfqVpD9tJ6YydkQvNhJSLUQIUaeNLcOe1PFohovOYlIO
        b7/Ef6tfPec5+AVHv35zF4c=
X-Google-Smtp-Source: ABdhPJygIiBhJ8/JdESriF9fL7Ps2GK9iJhtR+3q//LmPe7qK5BFguWcEgPqIJXgifk1kqiHXDCTbg==
X-Received: by 2002:a63:2e42:: with SMTP id u63mr5960797pgu.292.1601555315957;
        Thu, 01 Oct 2020 05:28:35 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:28:35 -0700 (PDT)
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
Subject: [PATCH v3 05/28] scsi: aacraid: use generic power management
Date:   Thu,  1 Oct 2020 17:54:48 +0530
Message-Id: <20201001122511.1075420-6-vaibhavgupta40@gmail.com>
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
 drivers/scsi/aacraid/linit.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 289887d5cc79..4740b7afa612 100644
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
@@ -1923,28 +1921,14 @@ static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
 
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
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	r = pci_enable_device(pdev);
-
-	if (r)
-		goto fail_device;
 
-	pci_set_master(pdev);
 	if (aac_acquire_resources(aac))
 		goto fail_device;
 	/*
@@ -1959,10 +1943,8 @@ static int aac_resume(struct pci_dev *pdev)
 fail_device:
 	printk(KERN_INFO "%s%d: resume failed.\n", aac->name, aac->id);
 	scsi_host_put(shost);
-	pci_disable_device(pdev);
 	return -ENODEV;
 }
-#endif
 
 static void aac_shutdown(struct pci_dev *dev)
 {
@@ -2107,15 +2089,14 @@ static struct pci_error_handlers aac_pci_err_handler = {
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
+	.driver.pm      = &aac_pm_ops,
 	.shutdown	= aac_shutdown,
 	.err_handler    = &aac_pci_err_handler,
 };
-- 
2.28.0

