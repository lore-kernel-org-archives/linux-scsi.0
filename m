Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9437C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 13:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46191206B2
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 13:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cs19gE2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHNNEr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 09:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgHNNEl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2020 09:04:41 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21347C061384
        for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2020 06:04:41 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id x7so4214941qvi.5
        for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2020 06:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XcDbRQtSghiU9DqGRxzecSu1VwWzO14/NOKbmgPJ+oQ=;
        b=cs19gE2k+trT+eX9ssTRve4jF5Y9fN0BUse22O4vB4MKwsIWFyY0IguN9SXAIYGvQU
         Pn0iLrQlD7pfr3XDSRZdBpWpzfQRPMtW1gvRHywgxxJJ0tpl0PpYOO/tZjIVLiLPEasY
         JwQBuWp44rm/kkcbCotP+9uOQe/smaXS70YvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XcDbRQtSghiU9DqGRxzecSu1VwWzO14/NOKbmgPJ+oQ=;
        b=qZR/9XnGtGgRMrvmKI9Bijdn58cvrlSNayhEFIDIuje1ngoH+5AlOkn67A4Kf0KRRx
         emsgWB0JVr49BXxiQ2C7QaOisrd4Tqm5FWUPk8luivIiY23j9HV3gMa42Zueb0YSYDdr
         kk4hpF2TE0lNxGwjWkZDwKkJVuliCulLylZo931y1TM63r0SDdiya654QsJm1zccX8DL
         rNNJJiKSSYH2KlhClHwdK3I0HAqso5WdKFmJxoBfLX0w4bZ3UOdTVf87wD1B5wujHCmS
         hiz06C2WdMYH1N5TC/cEuI/66mNLRw/QxacCwKYTBSD6clqYh/GX59JxWzwwRTNj/VTU
         DJ2g==
X-Gm-Message-State: AOAM5338dDdL9e411iDxlGXZtZalBCRHkRRsJDN5E0ePCua/4tvZHtRb
        B0V0/xSmliH2rIp7t0d36lMYNQ==
X-Google-Smtp-Source: ABdhPJwvZDDzPo37VA6DNRdDEhnG+SNoZQdAizN11AdU+va0wBqgqrqydKg+CAx6Us/KBdNistW/Sw==
X-Received: by 2002:a0c:c409:: with SMTP id r9mr2590007qvi.123.1597410280030;
        Fri, 14 Aug 2020 06:04:40 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y3sm10395820qtj.55.2020.08.14.06.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 06:04:38 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1] mpt3sas: Add support for Non-secure Aero and Sea PCI IDs
Date:   Fri, 14 Aug 2020 13:04:26 +0000
Message-Id: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch will add support for Non-secure Aero & Sea adapters' PCI IDs.
Driver will throw an warning message when a non-secure type controller
is detected. Purpose of this interface is to avoid interacting with
any firmware which is not secured/signed by Broadcom. Any tampering on
Firmware component will be detected by hardware and it will be
communicated to the driver to avoid any further interaction with
that component.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
Print warning message instead of error message.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 121 ++++++++++++++++++++++++++++++-----
 1 file changed, 105 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 67270e0..cb76b7c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10092,6 +10092,34 @@ void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
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
@@ -10099,8 +10127,8 @@ void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
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
@@ -10109,6 +10137,9 @@ static void scsih_remove(struct pci_dev *pdev)
 	unsigned long flags;
 	Mpi2ConfigReply_t mpi_reply;
 
+	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
+		return;
+
 	ioc->remove_host = 1;
 
 	if (!pci_device_is_present(pdev))
@@ -10188,12 +10219,15 @@ static void scsih_remove(struct pci_dev *pdev)
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
@@ -10763,6 +10797,10 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
@@ -10852,6 +10890,20 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 		case MPI26_ATLAS_PCIe_SWITCH_DEVID:
 			ioc->is_gen35_ioc = 1;
 			break;
+		case MPI26_MFGPAGE_DEVID_INVALID0_3816:
+		case MPI26_MFGPAGE_DEVID_INVALID0_3916:
+			dev_warn(&pdev->dev,
+			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Invalid",
+			    pdev->device, pdev->subsystem_vendor,
+			    pdev->subsystem_device);
+			return 1;
+		case MPI26_MFGPAGE_DEVID_INVALID1_3816:
+		case MPI26_MFGPAGE_DEVID_INVALID1_3916:
+			dev_warn(&pdev->dev,
+			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Tampered",
+			    pdev->device, pdev->subsystem_vendor,
+			    pdev->subsystem_device);
+			return 1;
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
 			dev_info(&pdev->dev,
@@ -11043,9 +11095,14 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
@@ -11070,11 +11127,15 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
 
@@ -11105,8 +11166,11 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
 
@@ -11141,10 +11205,13 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
@@ -11177,8 +11244,11 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
 
@@ -11193,8 +11263,11 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
 
@@ -11342,6 +11415,14 @@ bool scsih_ncq_prio_supp(struct scsi_device *sdev)
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
@@ -11354,6 +11435,14 @@ bool scsih_ncq_prio_supp(struct scsi_device *sdev)
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

