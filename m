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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7297C47420
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6548821707
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZzb3EcU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732232AbgJAMbb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731987AbgJAMba (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:31:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65E0C0613D0;
        Thu,  1 Oct 2020 05:31:30 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id x16so3941995pgj.3;
        Thu, 01 Oct 2020 05:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9uM1XyBCr19CDVWn9sf0w7KO65sKBGQo8/F3BUibYX0=;
        b=nZzb3EcUjTYpCRdQAX3xmBANibn8WqIzGcBrd3W6p89cEtprf6OSZWiMpMuzQCqz7l
         DLTk6SbEUdDfOoQ29zSTEol5F2yPN2p7Dc6zE5rVYK2nuQe1rldK/QMwFbghEBPY7tYz
         +7NMIKvBS2hy8a+5tKkIUPRdrNWx5q5pUWSpxeRMYexZ8IOtdSrZpaTF2DkBXs+/eYia
         XGRYIvY96aIJ2r+nofhnxdNpBDCs0zd8b2MgxeGJO6ctuXpylq1xBukWrPjplHayi0zV
         bKIQJh3VbZUGi39zmjAgktNDPf8uk9EPqD3JjGPawFYB4E/R901uAyWIh0kZQHNdyNvQ
         XIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9uM1XyBCr19CDVWn9sf0w7KO65sKBGQo8/F3BUibYX0=;
        b=n//7tg+mzVRiPfa11FDAk6j2M87QZmjwHLQiLjZAKcwAXOvevbUhcK8EbUErA+HRlk
         okYK3ZCcvwpUFdTYsd/yhlzpGjAgjal87lj1pwehz5CIZgAzxsYACgQPxryuul2MkIo+
         qOQ8JCMERb6pXpa09ctGknrypPJ73JdnI8pbC3VRhkyuycSbjKi8PdcIMjTLRUFKMSt0
         39lf6LoZ6sqT1RgIYM0x/cwbvdTWFIBIChLF60/yjPpJMxRKICft+15NDHlMLIlZ2dIK
         3WaQtXKc8hqaSkHqIbfeswiyI8dBM0ha/I4+gRo+xtm2Cj9PPPTGspNQOfg8cxlC74Qi
         bpuw==
X-Gm-Message-State: AOAM533ysUtsKjtvLlbZuCFYX2PEjviAiOuLCUBOS+5QBOGWmMOG0MRk
        ytoHIAcTCxiY0x6whZsvOLQ=
X-Google-Smtp-Source: ABdhPJxGhxM79NkvfOxZ0wQbj6bjRlnLTRjAkhtufgv4O5/RVevsS/GoXarVQFu027om5zbBF/ehhQ==
X-Received: by 2002:a17:902:aa04:b029:d3:8b4e:e5ef with SMTP id be4-20020a170902aa04b02900d38b4ee5efmr2953510plb.65.1601555490385;
        Thu, 01 Oct 2020 05:31:30 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:31:29 -0700 (PDT)
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
Subject: [PATCH v3 21/28] scsi: 3w-9xxx: use generic power management
Date:   Thu,  1 Oct 2020 17:55:04 +0530
Message-Id: <20201001122511.1075420-22-vaibhavgupta40@gmail.com>
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
 drivers/scsi/3w-9xxx.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e458e99ff161..b4718a1b2bd6 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2191,10 +2191,10 @@ static void twa_remove(struct pci_dev *pdev)
 	twa_device_extension_count--;
 } /* End twa_remove() */
 
-#ifdef CONFIG_PM
 /* This function is called on PCI suspend */
-static int twa_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused twa_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
@@ -2214,31 +2214,19 @@ static int twa_suspend(struct pci_dev *pdev, pm_message_t state)
 	}
 	TW_CLEAR_ALL_INTERRUPTS(tw_dev);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 } /* End twa_suspend() */
 
 /* This function is called on PCI resume */
-static int twa_resume(struct pci_dev *pdev)
+static int __maybe_unused twa_resume(struct device *dev)
 {
 	int retval = 0;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
 
 	printk(KERN_WARNING "3w-9xxx: Resuming host %d.\n", tw_dev->host->host_no);
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
 
-	retval = pci_enable_device(pdev);
-	if (retval) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x39, "Enable device failed during resume");
-		return retval;
-	}
-
-	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
 	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
@@ -2276,11 +2264,9 @@ static int twa_resume(struct pci_dev *pdev)
 
 out_disable_device:
 	scsi_remove_host(host);
-	pci_disable_device(pdev);
 
 	return retval;
 } /* End twa_resume() */
-#endif
 
 /* PCI Devices supported by this driver */
 static struct pci_device_id twa_pci_tbl[] = {
@@ -2296,16 +2282,15 @@ static struct pci_device_id twa_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, twa_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(twa_pm_ops, twa_suspend, twa_resume);
+
 /* pci_driver initializer */
 static struct pci_driver twa_driver = {
 	.name		= "3w-9xxx",
 	.id_table	= twa_pci_tbl,
 	.probe		= twa_probe,
 	.remove		= twa_remove,
-#ifdef CONFIG_PM
-	.suspend	= twa_suspend,
-	.resume		= twa_resume,
-#endif
+	.driver.pm	= &twa_pm_ops,
 	.shutdown	= twa_shutdown
 };
 
-- 
2.28.0

