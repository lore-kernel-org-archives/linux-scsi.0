Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91927C55178
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AD5922258
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FNiyl1hX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgKBQyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgKBQyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:54:03 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73560C0617A6;
        Mon,  2 Nov 2020 08:54:03 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w4so1059280pgg.13;
        Mon, 02 Nov 2020 08:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VhabbmrVlKfIcloXKiUycGjVLZHaLqGck6HUDFpjzd4=;
        b=FNiyl1hXUBQIr2AqRDMiQQrHQtakYZefo7BHUUaFEaNe3AON3Ra5wz0jv1lYLopD/J
         9q8+190FFV4gQaefv/2wGEECM1DanKSBBp6LpCc5bFyiS/gJ+vAWZ2XhBgvBprgyn077
         FtvPNPx+RM9xASBAwpDud3V4EfOVN+Dh/9fc+LvsrT2IGgKnHDRKA1uwwlTf8TFb4Mo7
         Xe3hTU/lEOs5umAd2rcm6QQ20EQOL36vlpNKBpAt/kwzfLP8K3TFO6RzPr+MypS1qIDV
         vuob7yY27jvqqNGxWe15ZTzBVzQdcCPRfXzff+iC9VGLk3vk1aq6qMg6V2WoZ2bF7s5E
         YD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VhabbmrVlKfIcloXKiUycGjVLZHaLqGck6HUDFpjzd4=;
        b=etcvYIQRsfAcgWccS/1ttbZOzfAQKrx0/PFAhM+H1BBhHlIND6ShCVwAHZcAOrR/kX
         P/6Ewa8JGI3B0iCf4HttrHI8CmixXcXtv9MpoSRkY/jsRYqt1JkAvKagIvciXKIzVnmq
         DpbrykCdNbJhOVStoB9CGB6AAzbq8LEpfIqS6DslCgzVyOdvpisT7nmQuoVlPGTTnWJ3
         UA7fyM5il8BjLYmB+Gtk3ywobeKo18FkTA/kM6l3NxXVn/xeJFDtI7/rV6DWYzySpNcN
         3ZkaNaC8dnzbeeUrYdT2zu6jGzObTIyqOXyRMMCDJJFH3GFauiVuTdjcDNyKBzCT69FZ
         FkKg==
X-Gm-Message-State: AOAM5309TZOT0f/P8k13KvBt4kSmN9Juci8JmxT0uysqYy2FwmgOsrAg
        cGAYL4dhn0roGfDuG1L3cOU=
X-Google-Smtp-Source: ABdhPJxw8lCwnUiNaQAX76vwhA4YIcPI6dIqpyLBz643suOBf7Pk6OZM1tXuc9wBPSC5zsTj+b76jA==
X-Received: by 2002:a17:90a:4a15:: with SMTP id e21mr4038914pjh.130.1604336042989;
        Mon, 02 Nov 2020 08:54:02 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:54:02 -0800 (PST)
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
        Xiang Chen <chenxiang66@hisilicon.com>,
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
        Balsundar P <balsundar.p@microchip.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v4 19/29] scsi: pm_8001: use generic power management
Date:   Mon,  2 Nov 2020 22:17:20 +0530
Message-Id: <20201102164730.324035-20-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
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
 drivers/scsi/pm8001/pm8001_init.c | 45 +++++++++++--------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index d47ed9a33173..7a732fd09b38 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1257,23 +1257,21 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 
 /**
  * pm8001_pci_suspend - power management suspend main entry point
- * @pdev: PCI device struct
- * @state: PM state change to (usually PCI_D3)
+ * @dev: Device struct
  *
  * Returns 0 success, anything else error.
  */
-static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused pm8001_pci_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
-	struct pm8001_hba_info *pm8001_ha;
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 	int  i, j;
-	u32 device_state;
-	pm8001_ha = sha->lldd_ha;
 	sas_suspend_ha(sha);
 	flush_workqueue(pm8001_wq);
 	scsi_block_requests(pm8001_ha->shost);
 	if (!pdev->pm_cap) {
-		dev_err(&pdev->dev, " PCI PM not supported\n");
+		dev_err(dev, " PCI PM not supported\n");
 		return -ENODEV;
 	}
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
@@ -1296,24 +1294,21 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
 			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
-	device_state = pci_choose_state(pdev, state);
 	pm8001_printk("pdev=0x%p, slot=%s, entering "
-		      "operating state [D%d]\n", pdev,
-		      pm8001_ha->name, device_state);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, device_state);
+		"suspended state\n", pdev,
+		pm8001_ha->name);
 	return 0;
 }
 
 /**
  * pm8001_pci_resume - power management resume main entry point
- * @pdev: PCI device struct
+ * @dev: Device struct
  *
  * Returns 0 success, anything else error.
  */
-static int pm8001_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused pm8001_pci_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
@@ -1326,16 +1321,6 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	pm8001_printk("pdev=0x%p, slot=%s, resuming from previous "
 		"operating state [D%d]\n", pdev, pm8001_ha->name, device_state);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	rc = pci_enable_device(pdev);
-	if (rc) {
-		pm8001_printk("slot=%s Enable device failed during resume\n",
-			      pm8001_ha->name);
-		goto err_out_enable;
-	}
-
-	pci_set_master(pdev);
 	rc = pci_go_44(pdev);
 	if (rc)
 		goto err_out_disable;
@@ -1396,8 +1381,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 
 err_out_disable:
 	scsi_remove_host(pm8001_ha->shost);
-	pci_disable_device(pdev);
-err_out_enable:
+
 	return rc;
 }
 
@@ -1480,13 +1464,16 @@ static struct pci_device_id pm8001_pci_table[] = {
 	{} /* terminate list */
 };
 
+static SIMPLE_DEV_PM_OPS(pm8001_pci_pm_ops,
+			 pm8001_pci_suspend,
+			 pm8001_pci_resume);
+
 static struct pci_driver pm8001_pci_driver = {
 	.name		= DRV_NAME,
 	.id_table	= pm8001_pci_table,
 	.probe		= pm8001_pci_probe,
 	.remove		= pm8001_pci_remove,
-	.suspend	= pm8001_pci_suspend,
-	.resume		= pm8001_pci_resume,
+	.driver.pm	= &pm8001_pci_pm_ops,
 };
 
 /**
-- 
2.28.0

