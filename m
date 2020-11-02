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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5D2C55179
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3BAA22268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k39IdQvP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgKBQxn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgKBQxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:53:42 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57D8C0617A6;
        Mon,  2 Nov 2020 08:53:41 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id z24so11300702pgk.3;
        Mon, 02 Nov 2020 08:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cb4ySFnlLhJ+JhmjzTriCdxevKzKPzQ3J+4RmScEJzI=;
        b=k39IdQvP1VxpzbrTjqwHF03rdVaMGcVa2DaAthYQylkXsudCrqFgaVQbrIkBPu/FNd
         QgQXKMyda64eqPigNDlcm9mGheOisop4qdbgVCJzw/ubGzQlkcqdWK3Ar8yut9n/KnyQ
         SAnY1Kh1+u+17/F6wFRuhDjO/O6qf3hPw0T/D/zKjUT0WpkTMqVkzB11aE+sX2AfqC17
         YTgY8W09DxEpecirzY99zQk2JIxo+vtDeGk7LqtBvr9sFweFACof13OVigrSUDEJcDz6
         7GOJBI8ll20grnDg10A5kSpOhmxPsTrbhoicpFhGMjh3GPD5QiPt5+o6hQln2PxKRop2
         5DnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cb4ySFnlLhJ+JhmjzTriCdxevKzKPzQ3J+4RmScEJzI=;
        b=cryl0I5XaQozGAaJoSCP8wKWARe6gyb2x+qGcBJbDle0azaHG7R2YQNyh1cytUxxKj
         tGbY9gDG36l3qfnCqdt0n89XJl22/wXQTV96SXgxRtLnB3Iovu2/rvt8Zgh0TBmIblN0
         6ev0mv6zAFXYD2OQsY/UX8lwOq8AM99/omjcZKbvTNIuq5v+Bzs3n7f7JMOlpJYJTWXi
         UmNG32sNphUwjxULVhaDzc07h5g5xlKUfqDmGLChqDlvrXBpuZeDbmxCvsn7TBNcuV9p
         PQN2we6sW87r7M8zVxJIJ727X81yct7Tm6mHpTqUdZWsRi/Erk83VNSWEOv+C92d/3sk
         H9Ng==
X-Gm-Message-State: AOAM533eidQBhR7f7HROlErO7BVgu9fLY9z6/WrzcG0ZNBki9wUCl1Zs
        N0GLn35WlQrI3JwOP24tbOk=
X-Google-Smtp-Source: ABdhPJyDgyx30V3H6BJoMMsQFczZcCAejBuc6H/HGyKQkmU7mR9yTb65KORXvUYyjWd/Sjka5RxOJA==
X-Received: by 2002:a63:7c46:: with SMTP id l6mr8264187pgn.301.1604336021260;
        Mon, 02 Nov 2020 08:53:41 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:53:40 -0800 (PST)
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
Subject: [PATCH v4 17/29] scsi: lpfc: use generic power management
Date:   Mon,  2 Nov 2020 22:17:18 +0530
Message-Id: <20201102164730.324035-18-vaibhavgupta40@gmail.com>
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
 drivers/scsi/lpfc/lpfc_init.c | 100 +++++++++++-----------------------
 1 file changed, 33 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ca25e54bb782..bf12328a5e45 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12581,8 +12581,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 
 /**
  * lpfc_pci_suspend_one_s3 - PCI func to suspend SLI-3 device for power mgmnt
- * @pdev: pointer to PCI device
- * @msg: power management message
+ * @dev_d: pointer to device
  *
  * This routine is to be called from the kernel's PCI subsystem to support
  * system Power Management (PM) to device with SLI-3 interface spec. When
@@ -12600,10 +12599,10 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
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
@@ -12617,16 +12616,12 @@ lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
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
@@ -12643,10 +12638,10 @@ lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
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
@@ -12654,19 +12649,6 @@ lpfc_pci_resume_one_s3(struct pci_dev *pdev)
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
@@ -13423,8 +13405,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 
 /**
  * lpfc_pci_suspend_one_s4 - PCI func to suspend SLI-4 device for power mgmnt
- * @pdev: pointer to PCI device
- * @msg: power management message
+ * @dev_d: pointer to device
  *
  * This routine is called from the kernel's PCI subsystem to support system
  * Power Management (PM) to device with SLI-4 interface spec. When PM invokes
@@ -13442,10 +13423,10 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
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
@@ -13460,16 +13441,12 @@ lpfc_pci_suspend_one_s4(struct pci_dev *pdev, pm_message_t msg)
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
@@ -13486,10 +13463,10 @@ lpfc_pci_suspend_one_s4(struct pci_dev *pdev, pm_message_t msg)
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
@@ -13497,19 +13474,6 @@ lpfc_pci_resume_one_s4(struct pci_dev *pdev)
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
@@ -13825,8 +13789,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 
 /**
  * lpfc_pci_suspend_one - lpfc PCI func to suspend dev for power management
- * @pdev: pointer to PCI device
- * @msg: power management message
+ * @dev: pointer to device
  *
  * This routine is to be registered to the kernel's PCI subsystem to support
  * system Power Management (PM). When PM invokes this method, it dispatches
@@ -13837,19 +13800,19 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
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
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -13862,7 +13825,7 @@ lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
 
 /**
  * lpfc_pci_resume_one - lpfc PCI func to resume dev for power management
- * @pdev: pointer to PCI device
+ * @dev: pointer to device
  *
  * This routine is to be registered to the kernel's PCI subsystem to support
  * system Power Management (PM). When PM invokes this method, it dispatches
@@ -13873,19 +13836,19 @@ lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
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
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -14065,14 +14028,17 @@ static const struct pci_error_handlers lpfc_err_handler = {
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
2.28.0

