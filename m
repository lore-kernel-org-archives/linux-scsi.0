Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2905BC388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAA9222268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jhuPycR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgKBQyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbgKBQyf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:54:35 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B20C0617A6;
        Mon,  2 Nov 2020 08:54:35 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id b12so7115351plr.4;
        Mon, 02 Nov 2020 08:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9uM1XyBCr19CDVWn9sf0w7KO65sKBGQo8/F3BUibYX0=;
        b=jhuPycR6Z/wfvaaHNzXfc6OMqTM4Mq+Ig3Ee77rGMzNXYvQWVO633PGQk5JKhaF3b6
         3/iDxbTuFjPIBsUcSennmmHy02QR0xJUXKu9e8ClWUpoEUOEwI0NWhEjW810xOAKmzuy
         /fSnVWnf5zZphYFflkfjQfj6sC4ywREOnDbN5ck3and1bq5EmfSJaDj1Og5DkJ+ReaMN
         XbEcC6KXbk7Q9qP4VEON/GLc4LBchBug/PQf+FRuPfxkpcy30ZO66ng832u4aZ2U5sRB
         DnAgJGb7VLmXnm04ensXzXggKuWR2GJPsBUn9sBClxGDEFjHwXL7IKkzgAD+oi7AQtKT
         4haw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9uM1XyBCr19CDVWn9sf0w7KO65sKBGQo8/F3BUibYX0=;
        b=UGSuNGW8e02oOfdeHikjgmZbbvGUosptE6hlN02E7Y96zT1wFnvqerK5agSpGVTX5U
         p/AClG4sJVQmnf2MHKVmRPCcrmvEAw7Rtsk7AwdTKIqtN8iHT6esUtrajW4Iq0KAoc2c
         H1GpXV5mtevAEsOGAXtCTm0iykFM/jOLQQJ+VxUkbrp1tyQ+cEFCFk0OjuPiIHa+LvEU
         4cAJorVbjCL3pV+ILhVK0UM/xX4jZYd/ZPtIq+YKERo98CuDf/fz29tqNsilkOo4cxEe
         nhl7+GoEB3YKYSTRWPHIgJb4YbC0E/bgCkAAkbIHhjwu2MHjlEgvtSDJIRXNnMoUY6Ck
         gPEQ==
X-Gm-Message-State: AOAM5306scDJudcy3hJXrc7BFNOgwprraqOgz18CporZ9684Wkr7S+Gy
        BLEld4X2Nc40ViFluLxfMCc=
X-Google-Smtp-Source: ABdhPJy6QlJL7rYPIqq+l9/hn/Ik10ZaEmiHPX/5F8UA/Oua+uxbilOEwf4GgfFLo04ls0CNL2F2nA==
X-Received: by 2002:a17:902:9b95:b029:d6:991d:118c with SMTP id y21-20020a1709029b95b02900d6991d118cmr18181316plp.4.1604336074711;
        Mon, 02 Nov 2020 08:54:34 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:54:34 -0800 (PST)
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
Subject: [PATCH v4 22/29] scsi: 3w-9xxx: use generic power management
Date:   Mon,  2 Nov 2020 22:17:23 +0530
Message-Id: <20201102164730.324035-23-vaibhavgupta40@gmail.com>
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

