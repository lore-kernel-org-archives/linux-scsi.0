Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D64219066E
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719426637; cv=none; b=thfMi78nC/HjEppHruHc6lLl9kYencNXxjBZZk5h+f9SAiXsPB6OxRHXBw12oQvDUE+9Bk8W0iCQg4oWgdHS3YCFPtwelmaz058giIYRh/6uVoJSS2Jc9RqvZ9ssrwUVnoS5QX98mR7MyUjsU6NZPhTBUCyIos4wMK1tXne36CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719426637; c=relaxed/simple;
	bh=uSyMgg4g4qjU0ptp8ouW0W8zPl1vFGIpp9ySJE8pUqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YBoXvi43YmieZRYVmv6ocUTMiKq9+7xIE6ALL21TAlWD9vMsgCO1aY873mnEaQUJr7pxeSMomjB7+nu0m5cem5sCCDIiSl91t0LMCSqBBSbg5AHgOrtb8/JOttp4uGO3l3PzBpA3ocFZyCDRrBpKPum3h+IImvLXK7qD3mB/b0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=F0oiJ8ei; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="F0oiJ8ei"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70673c32118so3155248b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 11:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1719426633; x=1720031433; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=nML488XSiuNPVLa8XjVx+xad7Vl3JfcGGu6uqDyxNGY=;
        b=F0oiJ8eipVG2JFWB+bf79JF813ffEu1v954E5TX5qYNR6Q4jjGNJZsHvV9W+KGyFV3
         jybZU8UV0lB7EJdRgCUOJ0jS3ecvo0b/vUB1dgvbk0n6sO/eKlMYoBSv2dkFfWA0ND/y
         UIp207Q8tPnA80XvWv1p/gpbuiU6awJssnYAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719426633; x=1720031433;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nML488XSiuNPVLa8XjVx+xad7Vl3JfcGGu6uqDyxNGY=;
        b=AMzEvEq4OYUKD46ElN0S13zxbwOW3ozx6Pa8gunPfmn7y7Arl/0eGii0/lSM5quUoV
         2Zd5r5YxlcFJkIwJAD2UxMSJkNNLhxlxCoOgLRbKYPOiB9FqSJjMxzVHFSW5Mzi/JRiS
         DvzBVl1C2bGRm/fYwhZ/+bLDnus1P7bZZA9Ha7m8X2DscGutORTu/tHjE0Cfr3RH6HU8
         uRk9A6XtEoOvufODTpYt2qfP3RGm/yWtPkJYjkQY7KCt3HKOIaK+CkbwXvH6a3EWybw+
         G0XsVyjh+GYXa0VVCq050puRXuoPDa+gK6Hpmf4iXJR1chioZ8wszYNslacioNvRmku7
         JcUA==
X-Gm-Message-State: AOJu0YyMn82xWiQG9Jo9GBw9iKud+p5uHIZWn4HsUGL6kKZZjq1sQIh9
	sO7uH0VLfM0Z8ixTq0o3e4HVN4Hm+cfP3If+tnvAujBH5JO5xsXbHrRdRmBkQMfhc4xuMrtpMl0
	0nA==
X-Google-Smtp-Source: AGHT+IEt7K5GJXQBHGsUthnY6yMw0Jyhi/7FxKje3t4rXmK44tPz4gnw6oQS21q1xWTzyH0+Ua07iQ==
X-Received: by 2002:a05:6a20:3b26:b0:1bd:2b2f:9188 with SMTP id adf61e73a8af0-1bd2b2f95c9mr2778976637.32.1719426633411;
        Wed, 26 Jun 2024 11:30:33 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c6a7csm102703205ad.160.2024.06.26.11.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 11:30:32 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@oracle.com,
	helgaas@kernel.org,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com
Cc: linux-scsi@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v4 1/3] mpi3mr: Support PCI Error Recovery callback handlers
Date: Wed, 26 Jun 2024 23:56:55 +0530
Message-Id: <20240626182657.7716-2-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240626182657.7716-1-sumit.saxena@broadcom.com>
References: <20240626182657.7716-1-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000bc1c95061bcf354a"

--000000000000bc1c95061bcf354a
Content-Transfer-Encoding: 8bit

PCI Error recovery support is required to recover the controller upon detection of PCI errors.
Add support for the PCI error recovery callback handlers in mpi3mr driver.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   6 +
 drivers/scsi/mpi3mr/mpi3mr_os.c | 199 ++++++++++++++++++++++++++++++++
 2 files changed, 205 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index c8968f12b9e6..2b1d5645ba9b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -23,6 +23,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/aer.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -129,6 +130,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_PREPARE_FOR_RESET_TIMEOUT	180
 #define MPI3MR_RESET_ACK_TIMEOUT		30
 #define MPI3MR_MUR_TIMEOUT			120
+#define MPI3MR_RESET_TIMEOUT			510
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
@@ -1153,6 +1155,8 @@ struct scmd_priv {
  * @trace_release_trigger_active: Trace trigger active flag
  * @fw_release_trigger_active: Fw release trigger active flag
  * @snapdump_trigger_active: Snapdump trigger active flag
+ * @pci_err_recovery: PCI error recovery in progress
+ * @block_on_pci_err: Block IO during PCI error recovery
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -1353,6 +1357,8 @@ struct mpi3mr_ioc {
 	bool snapdump_trigger_active;
 	bool trace_release_trigger_active;
 	bool fw_release_trigger_active;
+	bool pci_err_recovery;
+	bool block_on_pci_err;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index eac179dc9370..b71cf273c41e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5546,6 +5546,197 @@ mpi3mr_resume(struct device *dev)
 	return 0;
 }
 
+/**
+ * mpi3mr_pcierr_error_detected - PCI error detected callback
+ * @pdev: PCI device instance
+ * @state: channel state
+ *
+ * This function is called by the PCI error recovery driver and
+ * based on the state passed the driver decides what actions to
+ * be recommended back to PCI driver.
+ *
+ * For all of the states if there is no valid mrioc or scsi host
+ * references in the PCI device then this function will return
+ * the result as disconnect.
+ *
+ * For normal state, this function will return the result as can
+ * recover.
+ *
+ * For frozen state, this function will block for any pending
+ * controller initialization or re-initialization to complete,
+ * stop any new interactions with the controller and return
+ * status as reset required.
+ *
+ * For permanent failure state, this function will mark the
+ * controller as unrecoverable and return status as disconnect.
+ *
+ * Returns: PCI_ERS_RESULT_NEED_RESET or CAN_RECOVER or
+ * DISCONNECT based on the controller state.
+ */
+static pci_ers_result_t
+mpi3mr_pcierr_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
+{
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+	unsigned int timeout = MPI3MR_RESET_TIMEOUT;
+
+	dev_info(&pdev->dev, "%s: callback invoked state(%d)\n", __func__,
+	    state);
+
+	shost = pci_get_drvdata(pdev);
+	mrioc = shost_priv(shost);
+
+	switch (state) {
+	case pci_channel_io_normal:
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_frozen:
+		mrioc->pci_err_recovery = true;
+		mrioc->block_on_pci_err = true;
+		do {
+			if (mrioc->reset_in_progress || mrioc->is_driver_loading)
+				ssleep(1);
+			else
+				break;
+		} while (--timeout);
+
+		if (!timeout) {
+			mrioc->pci_err_recovery = true;
+			mrioc->block_on_pci_err = true;
+			mrioc->unrecoverable = 1;
+			mpi3mr_stop_watchdog(mrioc);
+			mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
+			return PCI_ERS_RESULT_DISCONNECT;
+		}
+
+		scsi_block_requests(mrioc->shost);
+		mpi3mr_stop_watchdog(mrioc);
+		mpi3mr_cleanup_resources(mrioc);
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		mrioc->pci_err_recovery = true;
+		mrioc->block_on_pci_err = true;
+		mrioc->unrecoverable = 1;
+		mpi3mr_stop_watchdog(mrioc);
+		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
+		return PCI_ERS_RESULT_DISCONNECT;
+	default:
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+}
+
+/**
+ * mpi3mr_pcierr_slot_reset - Post slot reset callback
+ * @pdev: PCI device instance
+ *
+ * This function is called by the PCI error recovery driver
+ * after a slot or link reset issued by it for the recovery, the
+ * driver is expected to bring back the controller and
+ * initialize it.
+ *
+ * This function restores PCI state and reinitializes controller
+ * resources and the controller, this blocks for any pending
+ * reset to complete.
+ *
+ * Returns: PCI_ERS_RESULT_DISCONNECT on failure or
+ * PCI_ERS_RESULT_RECOVERED
+ */
+static pci_ers_result_t mpi3mr_pcierr_slot_reset(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+	unsigned int timeout = MPI3MR_RESET_TIMEOUT;
+
+	dev_info(&pdev->dev, "%s: callback invoked\n", __func__);
+
+	shost = pci_get_drvdata(pdev);
+	mrioc = shost_priv(shost);
+
+	do {
+		if (mrioc->reset_in_progress)
+			ssleep(1);
+		else
+			break;
+	} while (--timeout);
+
+	if (!timeout)
+		goto out_failed;
+
+	pci_restore_state(pdev);
+
+	if (mpi3mr_setup_resources(mrioc)) {
+		ioc_err(mrioc, "setup resources failed\n");
+		goto out_failed;
+	}
+	mrioc->unrecoverable = 0;
+	mrioc->pci_err_recovery = false;
+
+	if (mpi3mr_soft_reset_handler(mrioc, MPI3MR_RESET_FROM_FIRMWARE, 0))
+		goto out_failed;
+
+	return PCI_ERS_RESULT_RECOVERED;
+
+out_failed:
+	mrioc->unrecoverable = 1;
+	mrioc->block_on_pci_err = false;
+	scsi_unblock_requests(shost);
+	mpi3mr_start_watchdog(mrioc);
+	return PCI_ERS_RESULT_DISCONNECT;
+}
+
+/**
+ * mpi3mr_pcierr_resume - PCI error recovery resume
+ * callback
+ * @pdev: PCI device instance
+ *
+ * This function enables all I/O and IOCTLs post reset issued as
+ * part of the PCI error recovery
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_pcierr_resume(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+
+	dev_info(&pdev->dev, "%s: callback invoked\n", __func__);
+
+	shost = pci_get_drvdata(pdev);
+	mrioc = shost_priv(shost);
+
+	if (mrioc->block_on_pci_err) {
+		mrioc->block_on_pci_err = false;
+		scsi_unblock_requests(shost);
+		mpi3mr_start_watchdog(mrioc);
+	}
+}
+
+/**
+ * mpi3mr_pcierr_mmio_enabled - PCI error recovery callback
+ * @pdev: PCI device instance
+ *
+ * This is called only if mpi3mr_pcierr_error_detected returns
+ * PCI_ERS_RESULT_CAN_RECOVER.
+ *
+ * Return: PCI_ERS_RESULT_DISCONNECT when the controller is
+ * unrecoverable or when the shost/mrioc reference cannot be
+ * found, else return PCI_ERS_RESULT_RECOVERED
+ */
+static pci_ers_result_t mpi3mr_pcierr_mmio_enabled(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+
+	dev_info(&pdev->dev, "%s: callback invoked\n", __func__);
+
+	shost = pci_get_drvdata(pdev);
+	mrioc = shost_priv(shost);
+
+	if (mrioc->unrecoverable)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
 static const struct pci_device_id mpi3mr_pci_id_table[] = {
 	{
 		PCI_DEVICE_SUB(MPI3_MFGPAGE_VENDORID_BROADCOM,
@@ -5563,6 +5754,13 @@ static const struct pci_device_id mpi3mr_pci_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, mpi3mr_pci_id_table);
 
+static struct pci_error_handlers mpi3mr_err_handler = {
+	.error_detected = mpi3mr_pcierr_error_detected,
+	.mmio_enabled = mpi3mr_pcierr_mmio_enabled,
+	.slot_reset = mpi3mr_pcierr_slot_reset,
+	.resume = mpi3mr_pcierr_resume,
+};
+
 static SIMPLE_DEV_PM_OPS(mpi3mr_pm_ops, mpi3mr_suspend, mpi3mr_resume);
 
 static struct pci_driver mpi3mr_pci_driver = {
@@ -5571,6 +5769,7 @@ static struct pci_driver mpi3mr_pci_driver = {
 	.probe = mpi3mr_probe,
 	.remove = mpi3mr_remove,
 	.shutdown = mpi3mr_shutdown,
+	.err_handler = &mpi3mr_err_handler,
 	.driver.pm = &mpi3mr_pm_ops,
 };
 
-- 
2.31.1


--000000000000bc1c95061bcf354a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
1J8x62/iEVbCstJaE1Nt3oXnL5yBlqX1Ihp8cZLe1weS7Wp/v5Jg2Ks13jeYOKW45xXExpqPPd1f
3meFjTf9K+rGZHb63htWaJtf0NYbE+5yIbXFv21cBxECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUTIFIrhFDaoMEbXuV9O+Y+XgS
kVwwDQYJKoZIhvcNAQELBQADggEBAFyioHqB2PHWcQ5cU8nprPRk37uSWK2x0w7W50jjc0cooz6G
G6pltJ+DvbG7XIzCU8cKHmuyAxoe1+/vhB8yJH78MVdfKDDND7zL/IqfhZedxHcHG5jVqbVH/ufu
H19y4fHxo5bLkybX3UxkN9b3bMsBZ4FFCLSCFgFfjI0BmTx6IoGyi0R89rzD0H1rURy7WTn0ijl1
nERsqENeyGfUTJLcDSURb49qpFqqWweJ7ifC64Iak8wCK2CxCe8lHfTyEgC9MuEa586NMQJDguvw
jlC7kxrgwf4sZ/9Wj/GS2HLzZPkxWCcQIrgNJm2wceHQwPBpM0ZoqL1D2tsFgOA8BvYxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwdgevXLIdo6fbCNI8w
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEII69lP7e1qDQzX4AytIXhoJM87N/vMAi
u7Jcdzuimcv3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDYy
NjE4MzAzM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAIQQJiUPQ6KOLorLrHk/21YuPdT5UTba8darb7Bhk6I5VWxGV2
fYGFoJlwIGBM/CIMORKdDC+kLxVvZL0mdVK2G49MhhOLiEuDDd9nDMrf7QubDhw57Mo4TNRR4WwF
lsPsjWhSbQgyNOgHfLcJmU/EPiSo7HuUSUTqOnAz58q/sVucqzB4loqHJnpOgytuz284OJIx0N64
PQnlHi9N8/z6QFoFTPcDjdCIhumiuBF2RqJ4Wjbx02q0eFlwtBonBCru63rhwJbkMpekiUTYwCGR
z1hKKZHUzPktVtuETqleS7SJ063/oUd7BrosiKlRetPZntmSJ3dSx7/apGKDU7Mi
--000000000000bc1c95061bcf354a--
