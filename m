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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C417C433F7
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0B1122CB1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PBs20ij9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgGTNhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgGTNhy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:37:54 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008A2C061794;
        Mon, 20 Jul 2020 06:37:53 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p3so10313992pgh.3;
        Mon, 20 Jul 2020 06:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qP/lw2OrWNJnMcQg/XtLZOmUZ9RFHua2vKNQYNPkmuc=;
        b=PBs20ij9CfDSVkVn+RaQUG5fj1gktc26Oy0Dvr3oNVU7k7ZDL8JOe7QDjkS9LUSG9I
         pwtiUs9nWtk3BWxeYWPo+WzpVRP5d8iXegrjhrVm6Gd4kqTheF9Jj9mwAQfFvdxvOUwo
         a5Ri3SR9GFVjaHAFXbyV11Z7LU++RkSknIgHN/FnZexLX1c8Htq7vz1VcPr8JZ8w/1Pr
         4N8LojHNPFXXfaoo9q8+0Ip0idFJ6hZx8DAp6hrR30Y/dfWejFidBhhIaItfuY0icKSE
         ZBwchB6V7hv3t+v6/woqqhWTBHkDSb489gMTN6tDSXC/5j+f9qy/Zx1aAUdp2ei7NHBO
         SIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qP/lw2OrWNJnMcQg/XtLZOmUZ9RFHua2vKNQYNPkmuc=;
        b=jNQkRjDIeaFRJQLVia5NYsyN4pTmwRH8lkXjW+BfRFB6sGz3WcXF0d0dN8+nBMHAix
         o59Dlnb2zrLF8PQuCvhfPJWIb1AqpbCoEeiFXRo3bKnjacGFcnMlulwF1Kh1gI5ILeZp
         00POoAscrfpPdFC5Up54Cq9CUE0hMDVgjBJlh1fiokFhbXq15dSNh+siHSY3MyYxV3Rn
         ma5mD1D5tLH24InsvpNYfb08BxsFmokZDEo9/Kl6tSsmskocIuyYm3LYCH93CwL0FTsU
         1Vfddwu7YtR4vgvucOSJZnxAvFtpk9exvb5Yy2IMX0K2xG4R+kiWKButaumbRm9zpxpo
         +whQ==
X-Gm-Message-State: AOAM531ASDs7g8FNr1zEctsk/I3U+21Bfusf1vDaTtncGvqto2kiVLO7
        YSkykCd5vKJNTmiBquyT8+4=
X-Google-Smtp-Source: ABdhPJxVcEI9vj+VkSrnExQJ5pjS1IaJwUzUyKXnm+2ao+8/m0qxgbZ0qslCpMyjvURUTfAG8Oazgg==
X-Received: by 2002:a63:ce15:: with SMTP id y21mr18997162pgf.163.1595252273465;
        Mon, 20 Jul 2020 06:37:53 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:37:53 -0700 (PDT)
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
Subject: [PATCH v2 08/15] scsi: mpt3sas_scsih: use generic power management
Date:   Mon, 20 Jul 2020 19:04:21 +0530
Message-Id: <20200720133427.454400-9-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

The driver was calling pci_save/restore_state(), pci_choose_state(),
pci_enable/disable_device() and pci_set_power_state() which is no more
needed.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 36 +++++++++++-----------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 08fc4b381056..f3c6e68b2921 100644
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
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	pci_power_t device_state = pdev->current_state;
@@ -10875,9 +10871,7 @@ scsih_resume(struct pci_dev *pdev)
 	ioc_info(ioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
 		 pdev, pci_name(pdev), device_state);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
+	device_wakeup_disable(dev);
 	ioc->pdev = pdev;
 	r = mpt3sas_base_map_resources(ioc);
 	if (r)
@@ -10888,7 +10882,6 @@ scsih_resume(struct pci_dev *pdev)
 	mpt3sas_base_start_watchdog(ioc);
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 /**
  * scsih_pci_error_detected - Called when a PCI error is detected.
@@ -11162,6 +11155,8 @@ static struct pci_error_handlers _mpt3sas_err_handler = {
 	.resume		= scsih_pci_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(scsih_pm_ops, scsih_suspend, scsih_resume);
+
 static struct pci_driver mpt3sas_driver = {
 	.name		= MPT3SAS_DRIVER_NAME,
 	.id_table	= mpt3sas_pci_table,
@@ -11169,10 +11164,7 @@ static struct pci_driver mpt3sas_driver = {
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
2.27.0

