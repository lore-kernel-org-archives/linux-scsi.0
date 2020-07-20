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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D09CC433EB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E330122BF3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OD83R4Lz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgGTNiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgGTNiH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:38:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6CEC061794;
        Mon, 20 Jul 2020 06:38:07 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t15so10121882pjq.5;
        Mon, 20 Jul 2020 06:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aOCvJ9OMLita4DjSQELNt/vTBzDq7eNN9v6xYwF0scM=;
        b=OD83R4LzuLPOKPuafSlh3v4a55b2Ecp6kTwYEiHVDJDk2+HkF2h7VkIrZpgjs6gZqw
         J3BQn2zNKflD6y2jeiR7QrLwjahilGelf7tIlZNxNJgXQzAg6KS9c52sEznTgwmX1/iA
         YFaTfp671XO8D0+u41Mnh9OJUg3VhWhQES2viS5RLWU24ueUDT4AXxlWiWAXXY+xiLLD
         pMpVW4+eHbE06PHneK+ZL71wX1F/NQRja0PPWKbiz7SUFSAkWgedLGJrS9CQMSlSiQmF
         iw6Ic/14I6uT5HL0hv3ocKH5vCifp67pRZ32iNiz3+IYVVlA6gdJGXm4lQsIVQtUK/xO
         gHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aOCvJ9OMLita4DjSQELNt/vTBzDq7eNN9v6xYwF0scM=;
        b=aiIqiYYxrpq35FD1C3YFxS8SNYp3/PzC5i/qofttN88vg8+0oQKlQkStMAmkhaaA3S
         rpTV1vAKJB0MG1lEcT0O3fkVmKSKdg4ZG6Zev2KH5avAoRB3pAPssun1oN+kMXAa83Dr
         kdVgvTgDk5QMuZsw6y2isg1yGFAyoR8+l3cxRzdE1I1DyeeDzaHZSw2rTHeadf53yQ0s
         qXkJlh3ocMP2GyLrytCXq+qdiuZ/f/uaU82Rfg6UvXo03y7uYkWBEv+UuogBaxHRBu6u
         YjV5RkI5iQxqPKKtcpRSKl4+mS3uW3sRCMGNTQ587c44z1l8oLcuvZ/uS/5MYvAXyECn
         kXFw==
X-Gm-Message-State: AOAM530kkdFveZb7hpSAeUsG+KY/UPVXx6aZqxKg+IK1l7WH7ptJugym
        J/Q3q+a0btZ6KHJuzyrAjt0=
X-Google-Smtp-Source: ABdhPJzrefgWJlwsiQew1HwItWjyQCmIWZSd6P3bWOaQNyPa/ldeUDgobqi5a4RL5HGhLFbm4Uq72A==
X-Received: by 2002:a17:90b:384c:: with SMTP id nl12mr24442140pjb.108.1595252286558;
        Mon, 20 Jul 2020 06:38:06 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:38:06 -0700 (PDT)
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
Subject: [PATCH v2 09/15] scsi: lpfc: use generic power management
Date:   Mon, 20 Jul 2020 19:04:22 +0530
Message-Id: <20200720133427.454400-10-vaibhavgupta40@gmail.com>
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

The driver was calling pci_save/restore_state(), pci_choose_state() and
pci_set_power_state() which is no more needed.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 100 +++++++++++-----------------------
 1 file changed, 33 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6637f84a3d1b..a36309b48144 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12452,8 +12452,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 
 /**
  * lpfc_pci_suspend_one_s3 - PCI func to suspend SLI-3 device for power mgmnt
- * @pdev: pointer to PCI device
- * @msg: power management message
+ * @dev_d: pointer to device
  *
  * This routine is to be called from the kernel's PCI subsystem to support
  * system Power Management (PM) to device with SLI-3 interface spec. When
@@ -12471,10 +12470,10 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
  * 	0 - driver suspended the device
  * 	Error otherwise
  **/
-static int
-lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
+static int __maybe_unused
+lpfc_pci_suspend_one_s3(struct device *dev_d)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev_d);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -12488,16 +12487,12 @@ lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
 	/* Disable interrupt from device */
 	lpfc_sli_disable_intr(phba);
 
-	/* Save device state to PCI config space */
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
 	return 0;
 }
 
 /**
  * lpfc_pci_resume_one_s3 - PCI func to resume SLI-3 device for power mgmnt
- * @pdev: pointer to PCI device
+ * @dev_d: pointer to device
  *
  * This routine is to be called from the kernel's PCI subsystem to support
  * system Power Management (PM) to device with SLI-3 interface spec. When PM
@@ -12514,10 +12509,10 @@ lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
  * 	0 - driver suspended the device
  * 	Error otherwise
  **/
-static int
-lpfc_pci_resume_one_s3(struct pci_dev *pdev)
+static int __maybe_unused
+lpfc_pci_resume_one_s3(struct device *dev_d)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev_d);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	uint32_t intr_mode;
 	int error;
@@ -12525,19 +12520,6 @@ lpfc_pci_resume_one_s3(struct pci_dev *pdev)
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"0452 PCI device Power Management resume.\n");
 
-	/* Restore device state from PCI config space */
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	/*
-	 * As the new kernel behavior of pci_restore_state() API call clears
-	 * device saved_state flag, need to save the restored state again.
-	 */
-	pci_save_state(pdev);
-
-	if (pdev->is_busmaster)
-		pci_set_master(pdev);
-
 	/* Startup the kernel thread for this host adapter. */
 	phba->worker_thread = kthread_run(lpfc_do_work, phba,
 					"lpfc_worker_%d", phba->brd_no);
@@ -13294,8 +13276,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 
 /**
  * lpfc_pci_suspend_one_s4 - PCI func to suspend SLI-4 device for power mgmnt
- * @pdev: pointer to PCI device
- * @msg: power management message
+ * @dev_d: pointer to device
  *
  * This routine is called from the kernel's PCI subsystem to support system
  * Power Management (PM) to device with SLI-4 interface spec. When PM invokes
@@ -13313,10 +13294,10 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
  * 	0 - driver suspended the device
  * 	Error otherwise
  **/
-static int
-lpfc_pci_suspend_one_s4(struct pci_dev *pdev, pm_message_t msg)
+static int __maybe_unused
+lpfc_pci_suspend_one_s4(struct device *dev_d)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev_d);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -13331,16 +13312,12 @@ lpfc_pci_suspend_one_s4(struct pci_dev *pdev, pm_message_t msg)
 	lpfc_sli4_disable_intr(phba);
 	lpfc_sli4_queue_destroy(phba);
 
-	/* Save device state to PCI config space */
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
 	return 0;
 }
 
 /**
  * lpfc_pci_resume_one_s4 - PCI func to resume SLI-4 device for power mgmnt
- * @pdev: pointer to PCI device
+ * @dev_d: pointer to device
  *
  * This routine is called from the kernel's PCI subsystem to support system
  * Power Management (PM) to device with SLI-4 interface spac. When PM invokes
@@ -13357,10 +13334,10 @@ lpfc_pci_suspend_one_s4(struct pci_dev *pdev, pm_message_t msg)
  * 	0 - driver suspended the device
  * 	Error otherwise
  **/
-static int
-lpfc_pci_resume_one_s4(struct pci_dev *pdev)
+static int __maybe_unused
+lpfc_pci_resume_one_s4(struct device *dev_d)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev_d);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	uint32_t intr_mode;
 	int error;
@@ -13368,19 +13345,6 @@ lpfc_pci_resume_one_s4(struct pci_dev *pdev)
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"0292 PCI device Power Management resume.\n");
 
-	/* Restore device state from PCI config space */
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	/*
-	 * As the new kernel behavior of pci_restore_state() API call clears
-	 * device saved_state flag, need to save the restored state again.
-	 */
-	pci_save_state(pdev);
-
-	if (pdev->is_busmaster)
-		pci_set_master(pdev);
-
 	 /* Startup the kernel thread for this host adapter. */
 	phba->worker_thread = kthread_run(lpfc_do_work, phba,
 					"lpfc_worker_%d", phba->brd_no);
@@ -13696,8 +13660,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 
 /**
  * lpfc_pci_suspend_one - lpfc PCI func to suspend dev for power management
- * @pdev: pointer to PCI device
- * @msg: power management message
+ * @dev: pointer to device
  *
  * This routine is to be registered to the kernel's PCI subsystem to support
  * system Power Management (PM). When PM invokes this method, it dispatches
@@ -13708,19 +13671,19 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
  * 	0 - driver suspended the device
  * 	Error otherwise
  **/
-static int
-lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
+static int __maybe_unused
+lpfc_pci_suspend_one(struct device *dev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	int rc = -ENODEV;
 
 	switch (phba->pci_dev_grp) {
 	case LPFC_PCI_DEV_LP:
-		rc = lpfc_pci_suspend_one_s3(pdev, msg);
+		rc = lpfc_pci_suspend_one_s3(dev);
 		break;
 	case LPFC_PCI_DEV_OC:
-		rc = lpfc_pci_suspend_one_s4(pdev, msg);
+		rc = lpfc_pci_suspend_one_s4(dev);
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -13733,7 +13696,7 @@ lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
 
 /**
  * lpfc_pci_resume_one - lpfc PCI func to resume dev for power management
- * @pdev: pointer to PCI device
+ * @dev: pointer to device
  *
  * This routine is to be registered to the kernel's PCI subsystem to support
  * system Power Management (PM). When PM invokes this method, it dispatches
@@ -13744,19 +13707,19 @@ lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
  * 	0 - driver suspended the device
  * 	Error otherwise
  **/
-static int
-lpfc_pci_resume_one(struct pci_dev *pdev)
+static int __maybe_unused
+lpfc_pci_resume_one(struct device *dev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	int rc = -ENODEV;
 
 	switch (phba->pci_dev_grp) {
 	case LPFC_PCI_DEV_LP:
-		rc = lpfc_pci_resume_one_s3(pdev);
+		rc = lpfc_pci_resume_one_s3(dev);
 		break;
 	case LPFC_PCI_DEV_OC:
-		rc = lpfc_pci_resume_one_s4(pdev);
+		rc = lpfc_pci_resume_one_s4(dev);
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -13936,14 +13899,17 @@ static const struct pci_error_handlers lpfc_err_handler = {
 	.resume = lpfc_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(lpfc_pci_pm_ops_one,
+			 lpfc_pci_suspend_one,
+			 lpfc_pci_resume_one);
+
 static struct pci_driver lpfc_driver = {
 	.name		= LPFC_DRIVER_NAME,
 	.id_table	= lpfc_id_table,
 	.probe		= lpfc_pci_probe_one,
 	.remove		= lpfc_pci_remove_one,
 	.shutdown	= lpfc_pci_remove_one,
-	.suspend        = lpfc_pci_suspend_one,
-	.resume		= lpfc_pci_resume_one,
+	.driver.pm	= &lpfc_pci_pm_ops_one,
 	.err_handler    = &lpfc_err_handler,
 };
 
-- 
2.27.0

