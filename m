Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5F5C636CC
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Feb 2023 10:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjBHK0X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 05:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjBHK0T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 05:26:19 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE664390B
        for <linux-scsi@vger.kernel.org>; Wed,  8 Feb 2023 02:26:17 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id r8so18762052pls.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2023 02:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tU0pzJAdafi0cf2+lDO1OzHSKgdJRzFnU90EpXA6UrM=;
        b=AsqLMWG4EcsvgLD4vXGXWxnEuFMOV9eiqSZrSA/5Y2uthRx0Dd1GEB3yiHVSDX91Q8
         VBO2wQAHbb12TEdm/p/R55tohNTLyxSh6fwDivoNY0xQ92BuSUqNwci0c4SfsiQojnje
         PmTu74ns8D2aHtynkVGCynnnNORPSLCC6Odn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tU0pzJAdafi0cf2+lDO1OzHSKgdJRzFnU90EpXA6UrM=;
        b=yEMmDi2Nlas/r7OoDU8tvVGM2JrWokrH58OhXhPyfFp5whncntzanLDHeHZRc9eOTN
         gzu3C9R6zCBOKNC6lMnFRFvNzJim8ifS3em+fkjA2BltPliMwmBuk5orTlMgxBhyZy/K
         48EUZgvmmrHuRmnUJf6w1B9JJdd+QUSMgHwY6WmkBBXM+CbhEQdem2oyNSyxLfYBEgKZ
         EsfDH+kdkAPQ6p/vGcvvuzzJbIj/F8+Fq4boPk4ANbcb9XZzweR74YGz/sOZo974GvBE
         bSff12WCG4XFXVXo4GwaX9bv2LQT7oCrjVZuQVUCYYNeDlpy3ho6Qh47SgifIltgGc+n
         VcdA==
X-Gm-Message-State: AO0yUKWkthxKrfknvI+MwPRLGUPrAcPGK+RKmPUvD8gYjaJepMzgGHoi
        MAVrR2jn90cJFrdNW6XLYDUknu6zHcjHR5D2Lp0xz90cOikgAw7qbND2C+af/qmwbsKc8rUp4L4
        jFAHHvL4tJPJ+2j5ALc7gwVDPJYW4bc5PjwoMi48LKtn7c9c2O9Utfq1s6Lo8Qtlq5xpO0ThMs3
        CbwAkgYnU=
X-Google-Smtp-Source: AK7set/mS66s0SWzHc1Br/jk7ke6cDKUx3kLRvqLytmQaAxE9DH7zfTYsMeIugxHRbD+Ojo9uErSag==
X-Received: by 2002:a17:902:e40a:b0:199:1fa0:853e with SMTP id m10-20020a170902e40a00b001991fa0853emr1379554ple.48.1675851977074;
        Wed, 08 Feb 2023 02:26:17 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id m21-20020a170902bb9500b001947222676csm10544349pls.249.2023.02.08.02.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 02:26:16 -0800 (PST)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 1/2] mpt3sas: Reload SBR without rebooting HBA
Date:   Wed,  8 Feb 2023 02:26:02 -0800
Message-Id: <20230208102603.23264-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d1b72a05f42db152"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d1b72a05f42db152
Content-Transfer-Encoding: 8bit

Added a new IOCTL command MPT3ENABLEDIAGSBRRELOAD.
As a part of firmware update operation, applications use this IOCTL
command to set the SBR reload bit in the Host Diagnostic register.
So that HBA firmware is updated without power-cycling the system.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 75 ++++++++++++++++++++--------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  4 ++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 54 ++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.h   | 10 ++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  1 +
 5 files changed, 123 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4e981ccaac41..594b19d06058 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7920,26 +7920,20 @@ mpt3sas_base_validate_event_type(struct MPT3SAS_ADAPTER *ioc, u32 *event_type)
 }
 
 /**
- * _base_diag_reset - the "big hammer" start of day reset
+ * mpt3sas_base_unlock_and_get_host_diagnostic- enable Host Diagnostic Register writes
  * @ioc: per adapter object
+ * @host_diagnostic: host diagnostic register content
  *
  * Return: 0 for success, non-zero for failure.
  */
-static int
-_base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
+int
+mpt3sas_base_unlock_and_get_host_diagnostic(struct MPT3SAS_ADAPTER *ioc,
+	u32 *host_diagnostic)
 {
-	u32 host_diagnostic;
-	u32 ioc_state;
 	u32 count;
-	u32 hcb_size;
-
-	ioc_info(ioc, "sending diag reset !!\n");
-
-	pci_cfg_access_lock(ioc->pdev);
-
-	drsprintk(ioc, ioc_info(ioc, "clear interrupts\n"));
-
+	*host_diagnostic = 0;
 	count = 0;
+
 	do {
 		/* Write magic sequence to WriteSequence register
 		 * Loop until in diagnostic mode
@@ -7960,15 +7954,55 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 			ioc_info(ioc,
 			    "Stop writing magic sequence after 20 retries\n");
 			_base_dump_reg_set(ioc);
-			goto out;
+			return -EFAULT;
 		}
 
-		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
+		*host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
 		drsprintk(ioc,
 			  ioc_info(ioc, "wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
-				   count, host_diagnostic));
+				    count, *host_diagnostic));
+
+		} while ((*host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
+		return 0;
+}
+
+/**
+ * mpt3sas_base_lock_host_diagnostic - Disable Host Diagnostic Register writes
+ * @ioc: per adapter object
+ *
+ */
+void
+mpt3sas_base_lock_host_diagnostic(struct MPT3SAS_ADAPTER *ioc)
+{
+	drsprintk(ioc, ioc_info(ioc, "disable writes to the diagnostic register\n"));
+	writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
+}
 
-	} while ((host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
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
+	if (mpt3sas_base_unlock_and_get_host_diagnostic(ioc, &host_diagnostic)) {
+		mutex_unlock(&ioc->hostdiag_unlock_mutex);
+		goto out;
+	}
 
 	hcb_size = ioc->base_readl(&ioc->chip->HCBSize);
 
@@ -8013,10 +8047,8 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 	drsprintk(ioc, ioc_info(ioc, "restart the adapter\n"));
 	writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_RESET,
 	    &ioc->chip->HostDiagnostic);
-
-	drsprintk(ioc,
-		  ioc_info(ioc, "disable writes to the diagnostic register\n"));
-	writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
+	mpt3sas_base_lock_host_diagnostic(ioc);
+	mutex_unlock(&ioc->hostdiag_unlock_mutex);
 
 	drsprintk(ioc, ioc_info(ioc, "Wait for FW to go to the READY state\n"));
 	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20);
@@ -8034,6 +8066,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
  out:
 	pci_cfg_access_unlock(ioc->pdev);
 	ioc_err(ioc, "diag reset: FAILED\n");
+	mutex_unlock(&ioc->hostdiag_unlock_mutex);
 	return -EFAULT;
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 05364aa15ecd..73f2b243729e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1367,6 +1367,7 @@ struct MPT3SAS_ADAPTER {
 	u8		got_task_abort_from_ioctl;
 
 	struct mutex	reset_in_progress_mutex;
+	struct mutex    hostdiag_unlock_mutex;
 	spinlock_t	ioc_reset_in_progress_lock;
 	u8		ioc_link_reset_in_progress;
 
@@ -1791,6 +1792,9 @@ void mpt3sas_base_disable_msix(struct MPT3SAS_ADAPTER *ioc);
 int mpt3sas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
 void mpt3sas_base_pause_mq_polling(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_base_resume_mq_polling(struct MPT3SAS_ADAPTER *ioc);
+int mpt3sas_base_unlock_and_get_host_diagnostic(struct MPT3SAS_ADAPTER *ioc,
+	u32 *host_diagnostic);
+void mpt3sas_base_lock_host_diagnostic(struct MPT3SAS_ADAPTER *ioc);
 
 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index efdb8178db32..4a250ec0d6b9 100644
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
index 8e24ebcebfe5..61d17c6400a8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12259,6 +12259,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* misc semaphores and spin locks */
 	mutex_init(&ioc->reset_in_progress_mutex);
+	mutex_init(&ioc->hostdiag_unlock_mutex);
 	/* initializing pci_access_mutex lock */
 	mutex_init(&ioc->pci_access_mutex);
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
-- 
2.31.1


--000000000000d1b72a05f42db152
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAh1tVRTq4xtYJa7UwEaXEHfqWfBnbOy
NwQO540BNs06MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDIw
ODEwMjYxN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCwJYRdjtYOEnlcagPnHUEalMHOLWcCUuUM5mlHNep/cPt2A54l
R7vbYeEbsoR3oJYfdBm6LdgG734bYDRbi96Xp9Dgg4lsnPANVRfH4YVPdfuUqUvk9CIIPNGYyWvV
w3cV7JJODzBarMRU6co6nCUW5xPDjrI+GJcIaOWgMUotk5eMDaGrchReL+l9Li1kE8Cr3cnBl2Uh
dWS+iI/Et/wZXpEygUGquzWktyStZ+beAS4w+skf7a2krecJoermqg9YIfaTcVTFca+N1mU9zzQX
47zlCb5wG1s8IrkuPFbNhBlvMYchFsASwkW0m7RxPTySRTbhkUbpNJYWpwiOAZ2o
--000000000000d1b72a05f42db152--
