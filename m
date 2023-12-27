Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2EA44394
	for <linux-scsi@vger.kernel.org>; Wed, 27 Dec 2023 11:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="F3ZVAyx1"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7ba87489f97so230449439f.1
        for <linux-scsi@vger.kernel.org>; Wed, 27 Dec 2023 03:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1703675287; x=1704280087; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=nS7Hu9JUpjdQ1JPI7Aio1wGA3XY9FxBx5jjocn17oRg=;
        b=F3ZVAyx1Zc8EHd7Z+SYmxSyzlzK0ThsoIvXrYl5K6mHXDxPhh1AEWINS1eUqEUGfbi
         3cUcmkKYt4wL3+aVNckyB6MkJmQ0chQ+oxjKMsBEV6LDL525hYLXkyUk6DFrRbIShZSy
         6lVgLYFtG9MCkUa9XXXLPk6qXeATHAu2J1hqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703675287; x=1704280087;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nS7Hu9JUpjdQ1JPI7Aio1wGA3XY9FxBx5jjocn17oRg=;
        b=gdHXK9Ku2QofK96zWyvHJxFR1vMOLy4NEVZuS1DWYakJPW8pyBzDzolZ8n7oj00Woj
         rQOsGtAFv5Al6P63on/JAvUIoWoBVlf6r5nPOov64uwRKlvgXQqGvhRt5AiKz1SYWime
         IMNo0kiRa9m5Dyoq5voSq3MDqGShyR9GKDI445/1+Y9+FYdeStjbxNBmxMwHnk5HdCCx
         uQFFJWY9dPpOyBZNQExN24bJQd43eKB5g6/h8eGEIB6llzd67e8dL2O7rdzO3/+QyA2N
         inz8ueJnOKJFuId8YhrvEUUIMWI+FQFNP+sdAQ5WLM+US9dbxZ7dGQgOtLcbb1V3uX3+
         KiCw==
X-Gm-Message-State: AOJu0Yy5Evn3QKXt+9JE1R2cApIzQQPiylbfF35MnjHsQi/uPI3h/moN
	HNuZuHSezX8mJBQch3lTpetky/WjaR7WSTUp+AH1AIYb4fRFSSvlUdDLhCTPsFm0umW0ITNdzg5
	rXDrpX+nnTyFJkcHMmrqfhkTn+PwA/4BWqVvnzMsXSRtwbMPysdRptSK0X9hc54giBMWO5bPJdP
	ufdrywZe4tWlGLfuT8
X-Google-Smtp-Source: AGHT+IGqIkarPwmsTyCFA6zcvBCx1Z/f+0610R++A5P0zMHkLaF93Seat+H+OecJPFpWRsix2LOMmg==
X-Received: by 2002:a6b:7014:0:b0:7ba:965b:fde6 with SMTP id l20-20020a6b7014000000b007ba965bfde6mr8787184ioc.33.1703675286520;
        Wed, 27 Dec 2023 03:08:06 -0800 (PST)
Received: from localhost.localdomain ([192.19.252.250])
        by smtp.gmail.com with ESMTPSA id n10-20020a1709026a8a00b001ab39cd875csm11699179plk.133.2023.12.27.03.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Dec 2023 03:08:05 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 1/2] mpt3sas: Reload SBR without rebooting HBA
Date: Wed, 27 Dec 2023 16:36:09 +0530
Message-Id: <20231227110610.18276-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231227110610.18276-1-ranjan.kumar@broadcom.com>
References: <20231227110610.18276-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000004bf81c060d7bd091"

--0000000000004bf81c060d7bd091
Content-Transfer-Encoding: 8bit

Added a new IOCTL command MPT3ENABLEDIAGSBRRELOAD.
As a part of firmware update operation, applications use this IOCTL
command to set the SBR reload bit in the Host Diagnostic register.
So that HBA firmware is updated without power-cycling the system.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 97 +++++++++++++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  4 ++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 54 ++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.h   | 10 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  1 +
 5 files changed, 135 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8761bc58d965..da1497cadeb1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7914,26 +7914,22 @@ mpt3sas_base_validate_event_type(struct MPT3SAS_ADAPTER *ioc, u32 *event_type)
 }
 
 /**
- * _base_diag_reset - the "big hammer" start of day reset
- * @ioc: per adapter object
- *
- * Return: 0 for success, non-zero for failure.
- */
-static int
-_base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
-{
-	u32 host_diagnostic;
-	u32 ioc_state;
-	u32 count;
-	u32 hcb_size;
-
-	ioc_info(ioc, "sending diag reset !!\n");
-
-	pci_cfg_access_lock(ioc->pdev);
+* mpt3sas_base_unlock_and_get_host_diagnostic- enable Host Diagnostic Register writes
+* @ioc: per adapter object
+* @host_diagnostic: host diagnostic register content
+*
+* Return: 0 for success, non-zero for failure.
+*/
 
-	drsprintk(ioc, ioc_info(ioc, "clear interrupts\n"));
+int
+mpt3sas_base_unlock_and_get_host_diagnostic(struct MPT3SAS_ADAPTER *ioc,
+	u32 *host_diagnostic)
+{
 
+	u32 count;
+	*host_diagnostic = 0;
 	count = 0;
+
 	do {
 		/* Write magic sequence to WriteSequence register
 		 * Loop until in diagnostic mode
@@ -7952,30 +7948,67 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 
 		if (count++ > 20) {
 			ioc_info(ioc,
-			    "Stop writing magic sequence after 20 retries\n");
+				    "Stop writing magic sequence after 20 retries\n");
 			_base_dump_reg_set(ioc);
-			goto out;
+			return -EFAULT;
 		}
 
-		host_diagnostic = ioc->base_readl_ext_retry(&ioc->chip->HostDiagnostic);
+		*host_diagnostic = ioc->base_readl_ext_retry(&ioc->chip->HostDiagnostic);
 		drsprintk(ioc,
-			  ioc_info(ioc, "wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
-				   count, host_diagnostic));
+			     ioc_info(ioc, "wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
+				     count, *host_diagnostic));
 
-	} while ((host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
+	} while ((*host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
+	return 0;
+}
 
-	hcb_size = ioc->base_readl(&ioc->chip->HCBSize);
+/**
+ * mpt3sas_base_lock_host_diagnostic: Disable Host Diagnostic Register writes
+ * @ioc: per adapter object
+ */
 
+void
+mpt3sas_base_lock_host_diagnostic(struct MPT3SAS_ADAPTER *ioc)
+{
+	drsprintk(ioc, ioc_info(ioc, "disable writes to the diagnostic register\n"));
+	writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
+}
+
+/**
+ * _base_diag_reset - the "big hammer" start of day reset
+ * @ioc: per adapter object
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+_base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
+{
+	u32 host_diagnostic;
+	u32 ioc_state;
+	u32 count;
+	u32 hcb_size;
+
+	ioc_info(ioc, "sending diag reset !!\n");
+
+	pci_cfg_access_lock(ioc->pdev);
+
+	drsprintk(ioc, ioc_info(ioc, "clear interrupts\n"));
+
+	mutex_lock(&ioc->hostdiag_unlock_mutex);
+	if (mpt3sas_base_unlock_and_get_host_diagnostic(ioc, &host_diagnostic))
+		goto out;
+
+	hcb_size = ioc->base_readl(&ioc->chip->HCBSize);
 	drsprintk(ioc, ioc_info(ioc, "diag reset: issued\n"));
 	writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
 	     &ioc->chip->HostDiagnostic);
 
-	/*This delay allows the chip PCIe hardware time to finish reset tasks*/
+	/* This delay allows the chip PCIe hardware time to finish reset tasks */
 	msleep(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
 
 	/* Approximately 300 second max wait */
 	for (count = 0; count < (300000000 /
-		MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
+	    MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
 
 		host_diagnostic = ioc->base_readl_ext_retry(&ioc->chip->HostDiagnostic);
 
@@ -7988,13 +8021,15 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
 			break;
 
-		msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC / 1000);
+		/* Wait to pass the second read delay window */
+			msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC/1000);
 	}
 
 	if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
 
 		drsprintk(ioc,
-			  ioc_info(ioc, "restart the adapter assuming the HCB Address points to good F/W\n"));
+			ioc_info(ioc, "restart the adapter assuming the\n"
+					"HCB Address points to good F/W\n"));
 		host_diagnostic &= ~MPI2_DIAG_BOOT_DEVICE_SELECT_MASK;
 		host_diagnostic |= MPI2_DIAG_BOOT_DEVICE_SELECT_HCDW;
 		writel(host_diagnostic, &ioc->chip->HostDiagnostic);
@@ -8008,9 +8043,8 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 	writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_RESET,
 	    &ioc->chip->HostDiagnostic);
 
-	drsprintk(ioc,
-		  ioc_info(ioc, "disable writes to the diagnostic register\n"));
-	writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
+	mpt3sas_base_lock_host_diagnostic(ioc);
+	mutex_unlock(&ioc->hostdiag_unlock_mutex);
 
 	drsprintk(ioc, ioc_info(ioc, "Wait for FW to go to the READY state\n"));
 	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20);
@@ -8028,6 +8062,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
  out:
 	pci_cfg_access_unlock(ioc->pdev);
 	ioc_err(ioc, "diag reset: FAILED\n");
+	mutex_unlock(&ioc->hostdiag_unlock_mutex);
 	return -EFAULT;
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 6d0bc8c66700..de60ef8a7908 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1366,6 +1366,7 @@ struct MPT3SAS_ADAPTER {
 	u8		got_task_abort_from_ioctl;
 
 	struct mutex	reset_in_progress_mutex;
+	struct mutex    hostdiag_unlock_mutex;
 	spinlock_t	ioc_reset_in_progress_lock;
 	u8		ioc_link_reset_in_progress;
 
@@ -1790,6 +1791,9 @@ void mpt3sas_base_disable_msix(struct MPT3SAS_ADAPTER *ioc);
 int mpt3sas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
 void mpt3sas_base_pause_mq_polling(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_base_resume_mq_polling(struct MPT3SAS_ADAPTER *ioc);
+int mpt3sas_base_unlock_and_get_host_diagnostic(struct MPT3SAS_ADAPTER *ioc,
+	u32 *host_diagnostic);
+void mpt3sas_base_lock_host_diagnostic(struct MPT3SAS_ADAPTER *ioc);
 
 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 147cb7088d55..5299dc297c04 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2543,6 +2543,56 @@ _ctl_addnl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	return 0;
 }
 
+/**
+ * _ctl_enable_diag_sbr_reload - enable sbr reload bit
+ * @ioc: per adapter object
+ * @arg - user space buffer containing ioctl content
+ *
+ * Enable the SBR reload bit
+ */
+static int
+_ctl_enable_diag_sbr_reload(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
+{
+	u32 ioc_state, host_diagnostic;
+
+	if (ioc->shost_recovery ||
+	    ioc->pci_error_recovery || ioc->is_driver_loading ||
+	    ioc->remove_host)
+		return -EAGAIN;
+
+	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
+
+	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL)
+		return -EFAULT;
+
+	host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
+
+	if (host_diagnostic & MPI2_DIAG_SBR_RELOAD)
+		return 0;
+
+	if (mutex_trylock(&ioc->hostdiag_unlock_mutex)) {
+		if (mpt3sas_base_unlock_and_get_host_diagnostic(ioc, &host_diagnostic)) {
+			mutex_unlock(&ioc->hostdiag_unlock_mutex);
+				return -EFAULT;
+		}
+	} else
+		return -EAGAIN;
+
+	host_diagnostic |= MPI2_DIAG_SBR_RELOAD;
+	writel(host_diagnostic, &ioc->chip->HostDiagnostic);
+	host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
+	mpt3sas_base_lock_host_diagnostic(ioc);
+	mutex_unlock(&ioc->hostdiag_unlock_mutex);
+
+	if (!(host_diagnostic & MPI2_DIAG_SBR_RELOAD)) {
+		ioc_err(ioc, "%s: Failed to set Diag SBR Reload Bit\n", __func__);
+		return -EFAULT;
+	}
+
+	ioc_info(ioc, "%s: Successfully set the Diag SBR Reload Bit\n", __func__);
+	return 0;
+}
+
 #ifdef CONFIG_COMPAT
 /**
  * _ctl_compat_mpt_command - convert 32bit pointers to 64bit.
@@ -2719,6 +2769,10 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 		if (_IOC_SIZE(cmd) == sizeof(struct mpt3_addnl_diag_query))
 			ret = _ctl_addnl_diag_query(ioc, arg);
 		break;
+	case MPT3ENABLEDIAGSBRRELOAD:
+		if (_IOC_SIZE(cmd) == sizeof(struct mpt3_enable_diag_sbr_reload))
+			ret = _ctl_enable_diag_sbr_reload(ioc, arg);
+		break;
 	default:
 		dctlprintk(ioc,
 			   ioc_info(ioc, "unsupported ioctl opcode(0x%08x)\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index 8f6ffb40261c..171709e91006 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -98,6 +98,8 @@
 	struct mpt3_diag_read_buffer)
 #define MPT3ADDNLDIAGQUERY _IOWR(MPT3_MAGIC_NUMBER, 32, \
 	struct mpt3_addnl_diag_query)
+#define MPT3ENABLEDIAGSBRRELOAD _IOWR(MPT3_MAGIC_NUMBER, 33, \
+	struct mpt3_enable_diag_sbr_reload)
 
 /* Trace Buffer default UniqueId */
 #define MPT2DIAGBUFFUNIQUEID (0x07075900)
@@ -448,4 +450,12 @@ struct mpt3_addnl_diag_query {
 	uint32_t reserved2[2];
 };
 
+/**
+ * struct mpt3_enable_diag_sbr_reload - enable sbr reload
+ * @hdr - generic header
+ */
+struct mpt3_enable_diag_sbr_reload {
+	struct mpt3_ioctl_header hdr;
+};
+
 #endif /* MPT3SAS_CTL_H_INCLUDED */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 51b5788da040..ef8ee93005ea 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12240,6 +12240,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* misc semaphores and spin locks */
 	mutex_init(&ioc->reset_in_progress_mutex);
+	mutex_init(&ioc->hostdiag_unlock_mutex);
 	/* initializing pci_access_mutex lock */
 	mutex_init(&ioc->pci_access_mutex);
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
-- 
2.31.1


--0000000000004bf81c060d7bd091
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFk5dpKAooqgF7EdKjEcKnOFJX8/5eNo
tHNRez132mfEMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMTIy
NzExMDgwN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBTAmPfPfW23FZAjqWUMsroWJ45dbhNqml5gWYHsuGTeWvJ5k31
x/HIuLwH+bCSb5WvuMvDoNt2TGCzhd3FSOV4jeJG2SB7SAEpW59JrSlAZEmtPXPi6RldBYggQPcW
YxRj62xn6+6eHJr1MsudY1yPV8GYW/T4Z6aziOx0o3utKRZoVqzwA/ZnvNW0hDySfLtWNJMweyQk
mwDW7gaqQynVoj/qEetT0Ujnq+y425Q3dKUdOdz4wx3/Xn2kwPJRt8ccDp/MbZo6mOyXT1pRj6S0
BF7reHAZQS4SKWhHSNcEbkG/O298Jt95xupHZi6VLVkXZ/cy+zcmvRDpn9eWb1A0
--0000000000004bf81c060d7bd091--
