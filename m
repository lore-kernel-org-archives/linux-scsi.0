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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B758CC4727F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C65D20B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ynw4vNSw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732312AbgJAM3n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731888AbgJAM3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:29:43 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEACC0613D0;
        Thu,  1 Oct 2020 05:29:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s31so3925911pga.7;
        Thu, 01 Oct 2020 05:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=myfhugrrkv0aDEdYCgYP11ATu35KzXWAY+Dl3giNZCY=;
        b=Ynw4vNSwrPMXOQXuozN5l7J/dx8FjDMUhnYrzZMwYofxkySKCqe2dCaGsMwiyKUxqr
         VR4PG9EJRl6i0R87X/GGQ7kxmqvGy4bJFi0Kmk3iY4vFe77rn30pF9fWFgcs09rDJT2v
         yXOQ7evG/5Ua0FpdirrRgXWBJQpdwugrQ/BebxA0PU2qjBJrfzgvX+0algpuiQRQBxyC
         GopickCUn9S5Jak3UzhJYVZliwAoUV+aH5CE70JUdqiWBMXz+WGC+pHniq/N0vanyO08
         PhkQ/JqrD26topnez2NRweMFLh8VaY99mjP4QcYa+6g6OfUmNl6djOuYYoteFiVolcNK
         QJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=myfhugrrkv0aDEdYCgYP11ATu35KzXWAY+Dl3giNZCY=;
        b=FRodU0UJKVZUnaVUAwppk6MsY8vmrNWG4mb6tuVUqYvRHm0vUbXVe+8l7wfzqjJR6p
         4tVl+63Trx/UPkVcdLJBoQk7eLdFJsIX83qIiuFLta6xc30yFbLSJldCqXb+a9F/cggt
         f67cCUQOpLUCHW23RzLzyG7G20b3oxDZWK6gOGXLLsr+GxdymKGT0iIR9nUEkV1mw8tq
         882/esBiF6RD+guo/oXJ6ESBwxfEAuNXEqhchE2JpcKMI40aafkOvlj3q04fK0szj7VK
         k9D4HYtbQOvbn436QEs1PIa5n1esJj2oFey5w95UD5y55MNyyk/cnmFxUrATZjIQQgPQ
         G98Q==
X-Gm-Message-State: AOAM533nwnwtBRjA4QGiiMP6ZNFXUomwgFWgwHt4F3MWgL1szK+eNXh2
        vDWPvmCwnrgH7ybztklJpC8=
X-Google-Smtp-Source: ABdhPJy2flIto3LrD2kgbvoK+WEbGAqit9JPlOlT1LIXRYdWXUoQMItkP3OhFTO4T4MvcHacMCU8aQ==
X-Received: by 2002:a17:902:dc82:b029:d2:8cba:90d6 with SMTP id n2-20020a170902dc82b02900d28cba90d6mr2500939pld.19.1601555383075;
        Thu, 01 Oct 2020 05:29:43 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:29:42 -0700 (PDT)
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
Subject: [PATCH v3 11/28] scsi: esas2r: use generic power management
Date:   Thu,  1 Oct 2020 17:54:54 +0530
Message-Id: <20201001122511.1075420-12-vaibhavgupta40@gmail.com>
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
 drivers/scsi/esas2r/esas2r.h      |  5 ++--
 drivers/scsi/esas2r/esas2r_init.c | 44 +++++++++----------------------
 drivers/scsi/esas2r/esas2r_main.c |  3 +--
 3 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 7f43b95f4e94..6ad3e0871ef0 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -996,8 +996,9 @@ void esas2r_adapter_tasklet(unsigned long context);
 irqreturn_t esas2r_interrupt(int irq, void *dev_id);
 irqreturn_t esas2r_msi_interrupt(int irq, void *dev_id);
 void esas2r_kickoff_timer(struct esas2r_adapter *a);
-int esas2r_suspend(struct pci_dev *pcid, pm_message_t state);
-int esas2r_resume(struct pci_dev *pcid);
+
+extern const struct dev_pm_ops esas2r_pm_ops;
+
 void esas2r_fw_event_off(struct esas2r_adapter *a);
 void esas2r_fw_event_on(struct esas2r_adapter *a);
 bool esas2r_nvram_write(struct esas2r_adapter *a, struct esas2r_request *rq,
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 90bc3489964b..f6bf76f49d15 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -640,49 +640,27 @@ void esas2r_kill_adapter(int i)
 	}
 }
 
-int esas2r_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused esas2r_suspend(struct device *dev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
-	u32 device_state;
+	struct Scsi_Host *host = dev_get_drvdata(dev);
 	struct esas2r_adapter *a = (struct esas2r_adapter *)host->hostdata;
 
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "suspending adapter()");
+	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "suspending adapter()");
 	if (!a)
 		return -ENODEV;
 
 	esas2r_adapter_power_down(a, 1);
-	device_state = pci_choose_state(pdev, state);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_save_state() called");
-	pci_save_state(pdev);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_disable_device() called");
-	pci_disable_device(pdev);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_set_power_state() called");
-	pci_set_power_state(pdev, device_state);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "esas2r_suspend(): 0");
+	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "esas2r_suspend(): 0");
 	return 0;
 }
 
-int esas2r_resume(struct pci_dev *pdev)
+static int __maybe_unused esas2r_resume(struct device *dev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct Scsi_Host *host = dev_get_drvdata(dev);
 	struct esas2r_adapter *a = (struct esas2r_adapter *)host->hostdata;
-	int rez;
-
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "resuming adapter()");
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_set_power_state(PCI_D0) "
-		       "called");
-	pci_set_power_state(pdev, PCI_D0);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_restore_state() called");
-	pci_restore_state(pdev);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_enable_device() called");
-	rez = pci_enable_device(pdev);
-	pci_set_master(pdev);
+	int rez = 0;
+
+	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "resuming adapter()");
 
 	if (!a) {
 		rez = -ENODEV;
@@ -726,11 +704,13 @@ int esas2r_resume(struct pci_dev *pdev)
 	}
 
 error_exit:
-	esas2r_log_dev(ESAS2R_LOG_CRIT, &(pdev->dev), "esas2r_resume(): %d",
+	esas2r_log_dev(ESAS2R_LOG_CRIT, dev, "esas2r_resume(): %d",
 		       rez);
 	return rez;
 }
 
+SIMPLE_DEV_PM_OPS(esas2r_pm_ops, esas2r_suspend, esas2r_resume);
+
 bool esas2r_set_degraded_mode(struct esas2r_adapter *a, char *error_str)
 {
 	set_bit(AF_DEGRADED_MODE, &a->flags);
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7b49e2e9fcde..aab3ea580e6b 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -346,8 +346,7 @@ static struct pci_driver
 	.id_table	= esas2r_pci_table,
 	.probe		= esas2r_probe,
 	.remove		= esas2r_remove,
-	.suspend	= esas2r_suspend,
-	.resume		= esas2r_resume,
+	.driver.pm	= &esas2r_pm_ops,
 };
 
 static int esas2r_probe(struct pci_dev *pcid,
-- 
2.28.0

