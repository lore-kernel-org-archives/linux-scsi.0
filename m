Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E44C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Dec 2021 05:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhL0FbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Dec 2021 00:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhL0FbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2021 00:31:08 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22950C06173E
        for <linux-scsi@vger.kernel.org>; Sun, 26 Dec 2021 21:31:08 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id m24so10678320pls.10
        for <linux-scsi@vger.kernel.org>; Sun, 26 Dec 2021 21:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=2Sg9i4LaGo2b0OuyMnL/bTS4zYOrL6BLcDBKwRIgdP0=;
        b=byuhtZ/m87dGZ1AhrbkDFTT/K4piMWR8tzy/ZUQHB/zT/51U0Ruag3MmS+FM0mUXUJ
         q+PD4lAXxmivTeVCvx6koj9xJ2vXmncBEF1QcSMIG1dxecC1e8t7q45cQBN7BIi4mxaH
         ysbascaB2uABd/9fN4f2tYYK7LMUlpjR6clSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=2Sg9i4LaGo2b0OuyMnL/bTS4zYOrL6BLcDBKwRIgdP0=;
        b=I9cwfWruqEQFQAtzLm2U2Dm+7TnG9DJAGRK0RfiBx9qrKKgtHv+tgZhvKMLuKwu5IS
         9LKOm//KfHCGhLbweDdtfPlzeBVtQE6UAXQPencR3ykAtysgeiVteT7mJZO+Mu9qT5Yx
         Rw8UwNaskkishS98hYLcN+/vFtCDdnM2DPwqh2rM+2W4kSl1Qs36bLQP7FS3ovfzYFJ7
         jeu+ZPRM1Tn9n4B1/7um9as3kYnd8MKmdqlNlCFnTxPRp/zbdJTMwTp46UkpYG5HBUpX
         oZwlv84rHAFL48cjDmM4xqgCo2jChb9mEbCrmlVHvNwipXNRzgo0LhjPjzXIXTGYXM57
         jk3w==
X-Gm-Message-State: AOAM530Dstz8VwzSCD5aScnTgnXRUDbMiFv6Lqzjbmk6ro8PcrKCWnko
        8Zi38Kqhk6Izn9W+JBnXHs19MUGyGPnJQkvUuPn81x7F5WwLfailWRfNXPnHVMyb3ke2sa9qSw9
        j2aq2oFoNIuOWeFmgBvAPNFY6s3nZEKXHtltf9N3jYbNnWptOR+O1z8GqG3YW2Ji3mmjFteQNmq
        rwon03dcz2eLzF7IM/RdX170I=
X-Google-Smtp-Source: ABdhPJyWsB0n2cfykcuiNoVItngb0uI3CZGfSpDsxPq8wYR5yeoNh6wG5Tza44JOF/I6AylyddkjYg==
X-Received: by 2002:a17:90b:4d91:: with SMTP id oj17mr19423504pjb.224.1640583066878;
        Sun, 26 Dec 2021 21:31:06 -0800 (PST)
Received: from prabu-it-vms-server.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id lk10sm18912588pjb.20.2021.12.26.21.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Dec 2021 21:31:05 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Update Persistent Trigger Pages from SysFs interface.
Date:   Mon, 27 Dec 2021 11:00:55 +0530
Message-Id: <20211227053055.289537-1-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f6a96805d41a02a2"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f6a96805d41a02a2
Content-Transfer-Encoding: 8bit

Updates sysfs provided trigger values into the corresponding
persistent trigger pages. otherwise sysfs updated trigger
entries are not persistent across system reboot.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 87 +++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index db6a759..8b3cd4a 100755
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -77,8 +77,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"39.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		39
+#define MPT3SAS_DRIVER_VERSION		"40.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		40
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 05b6c6a..d92ca14 100755
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3533,11 +3533,31 @@ diag_trigger_master_store(struct device *cdev,
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct SL_WH_MASTER_TRIGGER_T *master_tg;
 	unsigned long flags;
 	ssize_t rc;
+	bool set = 1;
 
-	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
 	rc = min(sizeof(struct SL_WH_MASTER_TRIGGER_T), count);
+
+	if (ioc->supports_trigger_pages) {
+		master_tg = kzalloc(sizeof(struct SL_WH_MASTER_TRIGGER_T),
+		    GFP_KERNEL);
+		if (!master_tg)
+			return -ENOMEM;
+
+		memcpy(master_tg, buf, rc);
+		if (!master_tg->MasterData)
+			set = 0;
+		if (mpt3sas_config_update_driver_trigger_pg1(ioc, master_tg,
+		    set)) {
+			kfree(master_tg);
+			return -EFAULT;
+		}
+		kfree(master_tg);
+	}
+
+	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
 	memset(&ioc->diag_trigger_master, 0,
 	    sizeof(struct SL_WH_MASTER_TRIGGER_T));
 	memcpy(&ioc->diag_trigger_master, buf, rc);
@@ -3589,11 +3609,31 @@ diag_trigger_event_store(struct device *cdev,
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct SL_WH_EVENT_TRIGGERS_T *event_tg;
 	unsigned long flags;
 	ssize_t sz;
+	bool set = 1;
 
-	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
 	sz = min(sizeof(struct SL_WH_EVENT_TRIGGERS_T), count);
+	if (ioc->supports_trigger_pages) {
+		event_tg = kzalloc(sizeof(struct SL_WH_EVENT_TRIGGERS_T),
+		    GFP_KERNEL);
+		if (!event_tg)
+			return -ENOMEM;
+
+		memcpy(event_tg, buf, sz);
+		if (!event_tg->ValidEntries)
+			set = 0;
+		if (mpt3sas_config_update_driver_trigger_pg2(ioc, event_tg,
+		    set)) {
+			kfree(event_tg);
+			return -EFAULT;
+		}
+		kfree(event_tg);
+	}
+
+	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
+
 	memset(&ioc->diag_trigger_event, 0,
 	    sizeof(struct SL_WH_EVENT_TRIGGERS_T));
 	memcpy(&ioc->diag_trigger_event, buf, sz);
@@ -3644,11 +3684,31 @@ diag_trigger_scsi_store(struct device *cdev,
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct SL_WH_SCSI_TRIGGERS_T *scsi_tg;
 	unsigned long flags;
 	ssize_t sz;
+	bool set = 1;
+
+	sz = min(sizeof(struct SL_WH_SCSI_TRIGGERS_T), count);
+	if (ioc->supports_trigger_pages) {
+		scsi_tg = kzalloc(sizeof(struct SL_WH_SCSI_TRIGGERS_T),
+		    GFP_KERNEL);
+		if (!scsi_tg)
+			return -ENOMEM;
+
+		memcpy(scsi_tg, buf, sz);
+		if (!scsi_tg->ValidEntries)
+			set = 0;
+		if (mpt3sas_config_update_driver_trigger_pg3(ioc, scsi_tg,
+		    set)) {
+			kfree(scsi_tg);
+			return -EFAULT;
+		}
+		kfree(scsi_tg);
+	}
 
 	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
-	sz = min(sizeof(ioc->diag_trigger_scsi), count);
+
 	memset(&ioc->diag_trigger_scsi, 0, sizeof(ioc->diag_trigger_scsi));
 	memcpy(&ioc->diag_trigger_scsi, buf, sz);
 	if (ioc->diag_trigger_scsi.ValidEntries > NUM_VALID_ENTRIES)
@@ -3698,11 +3758,30 @@ diag_trigger_mpi_store(struct device *cdev,
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct SL_WH_MPI_TRIGGERS_T *mpi_tg;
 	unsigned long flags;
 	ssize_t sz;
+	bool set = 1;
 
-	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
 	sz = min(sizeof(struct SL_WH_MPI_TRIGGERS_T), count);
+	if (ioc->supports_trigger_pages) {
+		mpi_tg = kzalloc(sizeof(struct SL_WH_MPI_TRIGGERS_T),
+		    GFP_KERNEL);
+		if (!mpi_tg)
+			return -ENOMEM;
+
+		memcpy(mpi_tg, buf, sz);
+		if (!mpi_tg->ValidEntries)
+			set = 0;
+		if (mpt3sas_config_update_driver_trigger_pg4(ioc, mpi_tg,
+		    set)) {
+			kfree(mpi_tg);
+			return -EFAULT;
+		}
+		kfree(mpi_tg);
+	}
+
+	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
 	memset(&ioc->diag_trigger_mpi, 0,
 	    sizeof(ioc->diag_trigger_mpi));
 	memcpy(&ioc->diag_trigger_mpi, buf, sz);
-- 
2.27.0


--000000000000f6a96805d41a02a2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBXAwggRYoAMCAQICDCAc2j96+IoHW5040jANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjQzNTVaFw0yMjA5MTUxMTMwMjdaMIGm
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xITAfBgNVBAMTGFN1Z2FuYXRoIFByYWJ1IFN1YnJhbWFuaTE0
MDIGCSqGSIb3DQEJARYlc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJp3W6i+yVqwmKTbucNHNrAD35AKBa4GklrnUcWS
As4Yz62jxfJOu+dcysfahgpi3JcAhTe/eRMLc5on8ReYZAYCMNJ+jpNKRuf1Abgh6nfhcNf+cuGb
S83CJlqxdJjbnimwwbueitA/edWTFjcULNUDZZEmAPJkbHXmlTlJD8TMdR0ezem/d4niexc4RCyt
YMUhnlcyFg+2OR0MKuT2Q714Ka0IamXFyyXhX5wD9B+ITo5hu+ZtXV2RuOXy0U2bIEQzFPVJ7QA9
hUD4z7+jEN/0xIbuF8EJZMsb6XAT+CFOjnizM5yvGFfmupDlyQ4JuVb86R8v2AEDpXmbdnS1tDkC
AwEAAaOCAeYwggHiMA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUH
MAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNp
Z24yY2EyMDIwLmNydDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3Nn
Y2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAw
SQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29u
YWxzaWduMmNhMjAyMC5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJy
b2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk
1b5I3qGPzzAdBgNVHQ4EFgQURmgYmHXuw9VrKqnEjPBuviQS0CEwDQYJKoZIhvcNAQELBQADggEB
AAp1Yt9kkxViI/9B/AQxLFmuC9wWruix0ajjegaJ/HZ6C1ky/V9QvI1MwweIhBiuk2jttOzO4h87
rADIQnEI3bf5ccaw61CJNqc6Cb4LiEIjPF7py8f6+rHL928xCUnKqeCO2sC0A+k39bCiyHaGo432
eXxWNXxGrLg6/2TuwgOtvbil0hWwK/Wf5ql2YiZXy8wRo9IhHoY/4cJLS/Fay8yKX8IdhEc3pNbu
dDLaJg39U0ikF3NHtNMaXXHgh6TMs3OsWhH4+zlvkC0eSC6dvasGxmpPQPQe/0huBB8gDbzGrRg/
cRn2ctMmNHxZO4EBJ5SzsV/lHimTk+5K39lzkzYxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQ
ZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwgHNo/eviKB1udONIwDQYJYIZIAWUDBAIBBQCggdQwLwYJ
KoZIhvcNAQkEMSIEIEF3SMTn2/2EPC2HHuVjRfK9djOOSFRzSfGvHk6j9zDoMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTIyNzA1MzEwN1owaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA8
0P9z9dqWCRizePaLgTrWwyn615M0mxw48kfCGvU5XmGtpUjslcHxVO+dc9SdVknlUvlLSkFlG42k
kbgYj1QF/DNsKhNX576UfMCSiO+aYH93sQ/T7y1LmXLp/WJ8ax1DcjbcyRd3FCE3bBlQQoB60c/T
uuWgZNYtqDaHeGuYz/u2nvmAzTfkBv1I9rX/fBe+LkjUGJZnDCeWmRfjdoUhKrzCmzF/5Qp7++DH
QJY/hTZZ1u7+j2tnHHc598sGCMXURaFbfNQ5gCzw6T3aHi6vJlCWEWO7Af/OWqtyVP8nXeAwIRcr
X4Shtp/2dVjmCyksFbQkAzDb2NNJCVYd+AZm
--000000000000f6a96805d41a02a2--
