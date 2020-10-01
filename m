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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE29DC4727F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7566F206CA
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:30:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQQEPTYs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732178AbgJAMa1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731987AbgJAMa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:30:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5CDC0613D0;
        Thu,  1 Oct 2020 05:30:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k13so4370654pfg.1;
        Thu, 01 Oct 2020 05:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7rgufBpw93V8mG4rKsbALHUTh6KZISs0E2Oa73Zj8nQ=;
        b=IQQEPTYsZAyFdCQMzgShYX9XD3kMKT7z9vH7pMuIDi6Ei0TkMv+wM9MJedgCBQbbaB
         AbqCwrP7+a/XnWVlL/bj88wlr2pl/WQ2kmUOhQrPDFuNLVyGhlpxd/7/7fzjfNx2phEv
         ysK+Cu4vORuD71ieEnpxFyTzLncFMamyvDCiFiLTzz64AW72X8BbzJrkd7hY+rds91nC
         x5U5aj2F4s2F3wpyvYQT/v0ghNWIiyVNFkCKqXTY9pDxZ39B3bu9R3+zAWNr5/QBSiDK
         vG+KTSWYYxn2mUGxlQpxrCOyuVFxlczOjVM/GustJurog32TRjcnlxPUJG30C3/IDEES
         9UFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7rgufBpw93V8mG4rKsbALHUTh6KZISs0E2Oa73Zj8nQ=;
        b=G8sE065Lz24U9737imTu5gSUOMMF0uQ1psg1+YIkvH9mp5NtiEa6tx4h/xFdCJOBQc
         KXAvAZRLCFzflyXE/DC9m+vWTaWsI+rDixfZiDuwyy+F3zyXUMocfl4xvjQ7uEuqlpFV
         x4/8GDr+12p6YXxOMCvzQBJZCG5tCVpXR/fntvSX0w+jfYEY3T6grc1lrKY9r+WyElql
         C4gGKtGKdrjEbhRNa5Nr8apqyQLYsC91z9shvW6zDAr2ciEgDGRsBILOa76yAYiomEj3
         mV0VJ8G07iUab6nRRXo8jtAFu/o7K5PGWb59JRTRM8tDHOetZIfHFYiDGXtrjZ/rS1sz
         2cOg==
X-Gm-Message-State: AOAM531hPV2QjULYnnLTfc7QmFdCkX5myrKIh1um3+J/sLU1OhgrsFLL
        QfdYW7ZA/sXrGU4Z+htTIDg=
X-Google-Smtp-Source: ABdhPJxBsH7cHoNMekIO6E7c1Lz4xgNz6S5K0NhR5o6UOdEqCbv12kSwZbqhxobu5u1HFxuJpNwXPg==
X-Received: by 2002:a63:457:: with SMTP id 84mr5936764pge.191.1601555426990;
        Thu, 01 Oct 2020 05:30:26 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:30:26 -0700 (PDT)
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
Subject: [PATCH v3 15/28] scsi: mpt3sas_scsih: use generic power management
Date:   Thu,  1 Oct 2020 17:54:58 +0530
Message-Id: <20201001122511.1075420-16-vaibhavgupta40@gmail.com>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 34 +++++++++++-----------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ce3dfe26691f..6691b7cddfff 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10829,44 +10829,40 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
-	pci_power_t device_state;
 
 	mpt3sas_base_stop_watchdog(ioc);
 	flush_scheduled_work();
 	scsi_block_requests(shost);
 	_scsih_nvme_shutdown(ioc);
-	device_state = pci_choose_state(pdev, state);
-	ioc_info(ioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
-		 pdev, pci_name(pdev), device_state);
+	ioc_info(ioc, "pdev=0x%p, slot=%s, entering suspended state\n",
+		pdev, pci_name(pdev));
 
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
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	pci_power_t device_state = pdev->current_state;
@@ -10875,8 +10871,6 @@ scsih_resume(struct pci_dev *pdev)
 	ioc_info(ioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
 		 pdev, pci_name(pdev), device_state);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
 	ioc->pdev = pdev;
 	r = mpt3sas_base_map_resources(ioc);
 	if (r)
@@ -10887,7 +10881,6 @@ scsih_resume(struct pci_dev *pdev)
 	mpt3sas_base_start_watchdog(ioc);
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 /**
  * scsih_pci_error_detected - Called when a PCI error is detected.
@@ -11161,6 +11154,8 @@ static struct pci_error_handlers _mpt3sas_err_handler = {
 	.resume		= scsih_pci_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(scsih_pm_ops, scsih_suspend, scsih_resume);
+
 static struct pci_driver mpt3sas_driver = {
 	.name		= MPT3SAS_DRIVER_NAME,
 	.id_table	= mpt3sas_pci_table,
@@ -11168,10 +11163,7 @@ static struct pci_driver mpt3sas_driver = {
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

