Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500B7C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26EBC20838
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:28:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Vxrjekg2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgG3I2k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgG3I2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 04:28:38 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95230C061794
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:28:38 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z18so20482178wrm.12
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QvBhIPCl0NCUKKI08AGJ/K2X61Xbci2yU8aEgFQNC2E=;
        b=Vxrjekg29ozKRu+v0f8JEs91kkgSehwNVc4GPzpBXbsNCDeORWiRa/tUzyCmL7pXcT
         hDLpGKdbKChozsJZ21ouQlUYnkQQq3nEpAPiRhAfyoEZiQq75kyncs6BU9HjWTtBYrsa
         1nWrcuNtN3+F9UxDGBKMR7+v3pHmErPGORnjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QvBhIPCl0NCUKKI08AGJ/K2X61Xbci2yU8aEgFQNC2E=;
        b=NedF/0XJj8qxnPwiaVQf6e7cdU6JB6xxk4HBkLlbCpmDJiRxfLFJrY4PzX3lWFcwis
         3iRKijnHBw7YC4WwqFn2d+W0gFQS2Ch37wAwIoXM1NhuLa++/g9yC5lrQnKRZNTpzXRw
         N7bF+2i0eNOKhLAQvJqNIYgMM7ILkaARE7ZDJEAi7kEu1wospPP2CGRYWgPUI6PN1Snl
         txjOqhO6uNqQ/cmAtL3F6mDywHqH7L6jzz1FAeOe/dl7jHqjGF08ngVytPHcyh4XdjFj
         WYNhz8dWV1URVIklNH9MjAfdYSL3A9Re2C2diia+/6sTOMt94m0mZAf4l9SxwpT7tFgy
         ClBw==
X-Gm-Message-State: AOAM533FJ/O7mhsbxVzqblapqrBlPzXMmY4e0srrNx2alNpR0VEb74Mr
        gAxL0woWGi9s/JkUyWY76Wd1Yw==
X-Google-Smtp-Source: ABdhPJzhyZeMwPsQoEfh0mH7kcBnd5fDZPjwzDwBN/LlOe+s2xeKzcrBZmVXz/KHK+WeOwUknXUr8w==
X-Received: by 2002:adf:d84f:: with SMTP id k15mr1618384wrl.176.1596097717103;
        Thu, 30 Jul 2020 01:28:37 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d14sm8890638wre.44.2020.07.30.01.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 01:28:36 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Add support for Non-secure Aero and Sea PCI IDs
Date:   Thu, 30 Jul 2020 08:28:22 +0000
Message-Id: <20200730082822.22343-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch will add support for Non-secure Aero & Sea adapters' PCI IDs.
Driver will throw an error message when a non-secure type controller
is detected. Purpose of this interface is to avoid interacting with
any firmware which is not secured/signed by Broadcom. Any tampering on
Firmware component will be detected by hardware and it will be
communicated to the driver to avoid any further interaction with
that component.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 121 ++++++++++++++++++++++++++++++-----
 1 file changed, 105 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 08fc4b3..a19caf7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9889,6 +9889,34 @@ void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
+ * _scsih_get_shost_and_ioc - get shost and ioc
+ *			and verify whether they are NULL or not
+ * @pdev: PCI device struct
+ * @shost: address of scsi host pointer
+ * @ioc: address of HBA adapter pointer
+ *
+ * Return zero if *shost and *ioc are not NULL otherwise return error number.
+ */
+static int
+_scsih_get_shost_and_ioc(struct pci_dev *pdev,
+	struct Scsi_Host **shost, struct MPT3SAS_ADAPTER **ioc)
+{
+	*shost = pci_get_drvdata(pdev);
+	if (*shost == NULL) {
+		dev_err(&pdev->dev, "pdev's driver data is null\n");
+		return -ENXIO;
+	}
+
+	*ioc = shost_priv(*shost);
+	if (*ioc == NULL) {
+		dev_err(&pdev->dev, "shost's private data is null\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+/**
  * scsih_remove - detach and remove add host
  * @pdev: PCI device struct
  *
@@ -9896,8 +9924,8 @@ void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
  */
 static void scsih_remove(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
 	struct _sas_port *mpt3sas_port, *next_port;
 	struct _raid_device *raid_device, *next;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
@@ -9906,6 +9934,9 @@ static void scsih_remove(struct pci_dev *pdev)
 	unsigned long flags;
 	Mpi2ConfigReply_t mpi_reply;
 
+	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
+		return;
+
 	ioc->remove_host = 1;
 
 	if (!pci_device_is_present(pdev))
@@ -9985,12 +10016,15 @@ static void scsih_remove(struct pci_dev *pdev)
 static void
 scsih_shutdown(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 	Mpi2ConfigReply_t mpi_reply;
 
+	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
+		return;
+
 	ioc->remove_host = 1;
 
 	if (!pci_device_is_present(pdev))
@@ -10560,6 +10594,10 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	case MPI26_MFGPAGE_DEVID_HARD_SEC_3916:
 	case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
 	case MPI26_MFGPAGE_DEVID_HARD_SEC_3816:
+	case MPI26_MFGPAGE_DEVID_INVALID0_3916:
+	case MPI26_MFGPAGE_DEVID_INVALID1_3916:
+	case MPI26_MFGPAGE_DEVID_INVALID0_3816:
+	case MPI26_MFGPAGE_DEVID_INVALID1_3816:
 		return MPI26_VERSION;
 	}
 	return 0;
@@ -10649,6 +10687,20 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 		case MPI26_ATLAS_PCIe_SWITCH_DEVID:
 			ioc->is_gen35_ioc = 1;
 			break;
+		case MPI26_MFGPAGE_DEVID_INVALID0_3816:
+		case MPI26_MFGPAGE_DEVID_INVALID0_3916:
+			dev_err(&pdev->dev,
+			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Invalid",
+			    pdev->device, pdev->subsystem_vendor,
+			    pdev->subsystem_device);
+			return 1;
+		case MPI26_MFGPAGE_DEVID_INVALID1_3816:
+		case MPI26_MFGPAGE_DEVID_INVALID1_3916:
+			dev_err(&pdev->dev,
+			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Tampered",
+			    pdev->device, pdev->subsystem_vendor,
+			    pdev->subsystem_device);
+			return 1;
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
 			dev_info(&pdev->dev,
@@ -10840,9 +10892,14 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 static int
 scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
 	pci_power_t device_state;
+	int rc;
+
+	rc = _scsih_get_shost_and_ioc(pdev, &shost, &ioc);
+	if (rc)
+		return rc;
 
 	mpt3sas_base_stop_watchdog(ioc);
 	flush_scheduled_work();
@@ -10867,11 +10924,15 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 static int
 scsih_resume(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
 	pci_power_t device_state = pdev->current_state;
 	int r;
 
+	r = _scsih_get_shost_and_ioc(pdev, &shost, &ioc);
+	if (r)
+		return r;
+
 	ioc_info(ioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
 		 pdev, pci_name(pdev), device_state);
 
@@ -10902,8 +10963,11 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 static pci_ers_result_t
 scsih_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
+
+	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
+		return PCI_ERS_RESULT_DISCONNECT;
 
 	ioc_info(ioc, "PCI error: detected callback, state(%d)!!\n", state);
 
@@ -10938,10 +11002,13 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 static pci_ers_result_t
 scsih_pci_slot_reset(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
 	int rc;
 
+	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
+		return PCI_ERS_RESULT_DISCONNECT;
+
 	ioc_info(ioc, "PCI error: slot reset callback!!\n");
 
 	ioc->pci_error_recovery = 0;
@@ -10974,8 +11041,11 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 static void
 scsih_pci_resume(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
+
+	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
+		return;
 
 	ioc_info(ioc, "PCI error: resume callback!!\n");
 
@@ -10990,8 +11060,11 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 static pci_ers_result_t
 scsih_pci_mmio_enabled(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
+
+	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
+		return PCI_ERS_RESULT_DISCONNECT;
 
 	ioc_info(ioc, "PCI error: mmio enabled callback!!\n");
 
@@ -11139,6 +11212,14 @@ bool scsih_ncq_prio_supp(struct scsi_device *sdev)
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_HARD_SEC_3916,
 		PCI_ANY_ID, PCI_ANY_ID },
 
+	/*
+	 *  Aero SI –> 0x00E0 Invalid, 0x00E3 Tampered
+	 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_INVALID0_3916,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_INVALID1_3916,
+		PCI_ANY_ID, PCI_ANY_ID },
+
 	/* Atlas PCIe Switch Management Port */
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_ATLAS_PCIe_SWITCH_DEVID,
 		PCI_ANY_ID, PCI_ANY_ID },
@@ -11151,6 +11232,14 @@ bool scsih_ncq_prio_supp(struct scsi_device *sdev)
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_HARD_SEC_3816,
 		PCI_ANY_ID, PCI_ANY_ID },
 
+	/*
+	 *  Sea SI –> 0x00E4 Invalid, 0x00E7 Tampered
+	 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_INVALID0_3816,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_INVALID1_3816,
+		PCI_ANY_ID, PCI_ANY_ID },
+
 	{0}     /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mpt3sas_pci_table);
-- 
1.8.3.1

