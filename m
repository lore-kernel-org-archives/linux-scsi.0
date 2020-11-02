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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2957C55178
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A0DC22268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pqGb/ojs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbgKBQxb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgKBQxa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:53:30 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1F3C0617A6;
        Mon,  2 Nov 2020 08:53:30 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 133so11600998pfx.11;
        Mon, 02 Nov 2020 08:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+FYzDpJVo6o7vUtMY5MEW3bJWYDQoUDOxT/IdoR7Mtw=;
        b=pqGb/ojsmTzbDiumh4WtNsiJGH606Ide/pZHjT/+BjoFB9KSMAxpV5CQ/t8AKbvQGk
         XCAnGwApPmGusMpujWANyP8+gZo1ZRlaGApYaRePfDufmZHYy99ou3SXZuLmJXd0dWUt
         OKvifn+K0l7/WMND09NwcnDQuNoic84nBqnSOGIpaivKWdYB4YOrccXAwTuZUTvHTyWZ
         GzJ+y2jstwpxTLlbyW/PVd00XF4no1zmuNRnaB7cO9hRqxD1ZkZGWXtQUr1vebklVT5X
         e1GSX3d+E1PCXauLySvGSrl/ZR5kPQCC6NjKFQ2nJqe2TDljCRvMhydQZKWhjnAodB/s
         QVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+FYzDpJVo6o7vUtMY5MEW3bJWYDQoUDOxT/IdoR7Mtw=;
        b=QEXUREHD7nfDbfL8EGJCI4x7xdcmwzX7jiCm5PVEkJmWXRUD9UwPjvdJ2uRrrV/jq6
         /P6ccw7vTVv7P1HHbbQWSj5AsrU1cnlA8hJ7TWPe3Ipw2aWgr10mqe25JhZHfeWs4Chw
         jp0NEinw/1EQ7BdhIe5AIQTRDcdT6kaBiBygq7OH6OCnPSvKKElu9exVYRhek/K/JFqc
         krRTaKJpUqm8N0xeVhDpYGSwXgqD7EVTVBd3+f50nWVg3lmd7bpgbyTFPtPmiQ2v2Qz+
         9bzcRgPGiUqfFjVk7D0Q1MOMOmqXQnZ3UNLh+h/up8w8BRDB8115UxyySiRNs/KxyZ+R
         EIUw==
X-Gm-Message-State: AOAM533Vd2s77Jgz3s51bO3TjTOswKWUZWLWB+emcoWV0YHvAdOOGz2n
        6/6S3kRXOAOONhsykUQlW3E=
X-Google-Smtp-Source: ABdhPJzZ7HDMBFqkm0MG4EFU8WiBbdUVuQB59efLgHWUNo012dsn+LurOxiWFE0CxiU/fLJiJMq5UA==
X-Received: by 2002:aa7:9341:0:b029:18b:b43:6c7 with SMTP id 1-20020aa793410000b029018b0b4306c7mr3186804pfn.7.1604336010095;
        Mon, 02 Nov 2020 08:53:30 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:53:29 -0800 (PST)
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
Subject: [PATCH v4 16/29] scsi: mpt3sas_scsih: use generic power management
Date:   Mon,  2 Nov 2020 22:17:17 +0530
Message-Id: <20201102164730.324035-17-vaibhavgupta40@gmail.com>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 34 +++++++++++-----------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2d201558b8fb..bc68544856b9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11084,20 +11084,18 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return rv;
 }
 
-#ifdef CONFIG_PM
 /**
  * scsih_suspend - power management suspend main entry point
- * @pdev: PCI device struct
- * @state: PM state change to (usually PCI_D3)
+ * @dev: Device struct
  *
  * Return: 0 success, anything else error.
  */
-static int
-scsih_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused
+scsih_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *shost;
 	struct MPT3SAS_ADAPTER *ioc;
-	pci_power_t device_state;
 	int rc;
 
 	rc = _scsih_get_shost_and_ioc(pdev, &shost, &ioc);
@@ -11108,25 +11106,23 @@ scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 	flush_scheduled_work();
 	scsi_block_requests(shost);
 	_scsih_nvme_shutdown(ioc);
-	device_state = pci_choose_state(pdev, state);
-	ioc_info(ioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
-		 pdev, pci_name(pdev), device_state);
+	ioc_info(ioc, "pdev=0x%p, slot=%s, entering operating state\n",
+		 pdev, pci_name(pdev));
 
-	pci_save_state(pdev);
 	mpt3sas_base_free_resources(ioc);
-	pci_set_power_state(pdev, device_state);
 	return 0;
 }
 
 /**
  * scsih_resume - power management resume main entry point
- * @pdev: PCI device struct
+ * @dev: Device struct
  *
  * Return: 0 success, anything else error.
  */
-static int
-scsih_resume(struct pci_dev *pdev)
+static int __maybe_unused
+scsih_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *shost;
 	struct MPT3SAS_ADAPTER *ioc;
 	pci_power_t device_state = pdev->current_state;
@@ -11139,8 +11135,6 @@ scsih_resume(struct pci_dev *pdev)
 	ioc_info(ioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
 		 pdev, pci_name(pdev), device_state);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
 	ioc->pdev = pdev;
 	r = mpt3sas_base_map_resources(ioc);
 	if (r)
@@ -11151,7 +11145,6 @@ scsih_resume(struct pci_dev *pdev)
 	mpt3sas_base_start_watchdog(ioc);
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 /**
  * scsih_pci_error_detected - Called when a PCI error is detected.
@@ -11453,6 +11446,8 @@ static struct pci_error_handlers _mpt3sas_err_handler = {
 	.resume		= scsih_pci_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(scsih_pm_ops, scsih_suspend, scsih_resume);
+
 static struct pci_driver mpt3sas_driver = {
 	.name		= MPT3SAS_DRIVER_NAME,
 	.id_table	= mpt3sas_pci_table,
@@ -11460,10 +11455,7 @@ static struct pci_driver mpt3sas_driver = {
 	.remove		= scsih_remove,
 	.shutdown	= scsih_shutdown,
 	.err_handler	= &_mpt3sas_err_handler,
-#ifdef CONFIG_PM
-	.suspend	= scsih_suspend,
-	.resume		= scsih_resume,
-#endif
+	.driver.pm	= &scsih_pm_ops,
 };
 
 /**
-- 
2.28.0

