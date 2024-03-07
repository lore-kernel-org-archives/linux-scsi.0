Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6465442052
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 15:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824269; cv=none; b=ndNB9TAl9IPT88G3KpBeG52WPYu0PEYa0OjNFUmix3+tEJAVYR43alRBJFm7HVL3UcBvnABSUIdg2PLvyoHlrY2FuRGVCBJlYNcsfVXHGIHpuazfXJaTl7smshqoYK2ll873oytsPyWdArQ3mWVIp1bm5D0G5DOTAxoiNX8JVjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824269; c=relaxed/simple;
	bh=1CibaacyXixV38TXnmmU2/sNNhKhU5AMIrCjzr8Ceu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8+u0I/Y0kYHTy67oYXFqd06fyQjbIt7ezjPrZ+s4vDCQPoe2k0lk4fQsxW66VG5F+THG57IE6MiMFAvR33IRunpYYWUPZurhVbr56UxfpNqRe4bQgCCVaBafKyyZlxSv1DE+mXyQvAb/bMWtVme3pRCK4lQJmcgE95GyUsgmCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=XmsCDT1o; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XmsCDT1o"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e5d7f1f25fso775711b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Mar 2024 07:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1709824266; x=1710429066; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=DddCbvku4wj7gn16QJaenD+x5prFG+RKvZlcgRz2whA=;
        b=XmsCDT1ooNLfNqhlnbxQsCtEnwj99Nna8BulxAXt0fBv5vaVFP2gVrXKDiMHPRIuEe
         i6WXbysJ4fDCg+gfatleha5oKt/CUNndj7VkXJyEIEo5vue0jmNYcS/sLmddqR7KCCqX
         C5/OV45kRR0LPyBKQHoMRHjIIA4rC0K1roaQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709824266; x=1710429066;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DddCbvku4wj7gn16QJaenD+x5prFG+RKvZlcgRz2whA=;
        b=Jvk9OMpxjTptCLd1HbO2WlGKtHkRcgkpAUmj6LiOroSgepVb6OLuAN/OEg4I1wOjK2
         FCQdTmR0f32OBcl1Syb08Wv4Fo29Ty17LN9ULWBRT39DeD4y66umZNhhShZY2NFSq1r5
         r0pjo483T8al/oXUnH0fqCWAYc7cfFlWzgJCxjQJVLwjLpzY1aXYFKOY5nP7PCE3l4PH
         K3TK20MnG8ceeDIkO7YxAOfqoHCWOOY3xLfsXy+i+jzoZVcidiNukffy7N70NeZ+3oWE
         dXtrHhgeHHcrtkaymFylpCH6ro89est72co+CcjK+itRNSx154SE/OVqq3C2slvAfaYP
         /mUQ==
X-Gm-Message-State: AOJu0Yzs1M3PvSKBfGad3wbdMEGA9Bso9vbgnMJ+haCKJ4R6EIdxtGYd
	z9Lfdx70grvQKdy3eHf7FMPKV0Y2LY2WESbGX7rizmIfpifwp60DuU80IR/lf09T/6hikIdTV9o
	ltbwXkuUs/3dwrJMqnvoYEl2eKM5b+yDY0dBF8+67pCsWsuDlQVn0CM26cXCXNy8lT9Igf/11YL
	2nrh4EbXHh/L2aUCkbV0vzh5U3xpkuJD3KkdWKUTjNistje3N9
X-Google-Smtp-Source: AGHT+IFC5xZhM2oyMDMVIW1DmxMUBMptEtG0/Ua8O49+pXT5dLSO2VKUpK+Zdi9gxnZBOZog4uFGaw==
X-Received: by 2002:a05:6a00:2d20:b0:6e6:1822:1315 with SMTP id fa32-20020a056a002d2000b006e618221315mr13788527pfb.23.1709824266236;
        Thu, 07 Mar 2024 07:11:06 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w17-20020a056a0014d100b006e58da8bb6asm12009906pfu.132.2024.03.07.07.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 07:11:05 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 6/7] mpi3mr: Update MPI Headers to revision 31
Date: Thu,  7 Mar 2024 20:38:24 +0530
Message-Id: <20240307150825.7613-7-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240307150825.7613-1-ranjan.kumar@broadcom.com>
References: <20240307150825.7613-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000000c79aa0613137c16"

--0000000000000c79aa0613137c16
Content-Transfer-Encoding: 8bit

Update MPI Headers to revision 31

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  3 +++
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     | 20 +++++---------------
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 18 +++++++++++-------
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           |  8 ++++----
 5 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 35f81af40f51..6a19e17eb1a7 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -309,6 +309,7 @@ struct mpi3_man6_gpio_entry {
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_GENERIC                     (0x00)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_CABLE_MGMT                  (0x10)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_ACTIVE_CABLE_OVERCURRENT    (0x20)
+#define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_ACK_REQUIRED                       (0x02)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_TRIGGER_MASK                       (0x01)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_TRIGGER_EDGE                       (0x00)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_TRIGGER_LEVEL                      (0x01)
@@ -1315,6 +1316,8 @@ struct mpi3_driver_page0 {
 	__le32                             reserved18;
 };
 #define MPI3_DRIVER0_PAGEVERSION               (0x00)
+#define MPI3_DRIVER0_BSDOPTS_DEVICEEXPOSURE_DISABLE	    (0x00000020)
+#define MPI3_DRIVER0_BSDOPTS_WRITECACHE_DISABLE		    (0x00000010)
 #define MPI3_DRIVER0_BSDOPTS_HEADLESS_MODE_ENABLE           (0x00000008)
 #define MPI3_DRIVER0_BSDOPTS_DIS_HII_CONFIG_UTIL            (0x00000004)
 #define MPI3_DRIVER0_BSDOPTS_REGISTRATION_MASK              (0x00000003)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
index 47035b811902..7df242190135 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_image.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
@@ -198,16 +198,17 @@ struct mpi3_supported_devices_data {
 	struct mpi3_supported_device   supported_device[MPI3_SUPPORTED_DEVICE_MAX];
 };
 
-#ifndef MPI3_ENCRYPTED_HASH_MAX
-#define MPI3_ENCRYPTED_HASH_MAX                      (1)
+#ifndef MPI3_PUBLIC_KEY_MAX
+#define MPI3_PUBLIC_KEY_MAX                      (1)
 #endif
 struct mpi3_encrypted_hash_entry {
 	u8                         hash_image_type;
 	u8                         hash_algorithm;
 	u8                         encryption_algorithm;
 	u8                         reserved03;
-	__le32                     reserved04;
-	__le32                     encrypted_hash[MPI3_ENCRYPTED_HASH_MAX];
+	__le16                     public_key_size;
+	__le16                     signature_size;
+	__le32                     public_key[MPI3_PUBLIC_KEY_MAX];
 };
 
 #define MPI3_HASH_IMAGE_TYPE_KEY_WITH_SIGNATURE      (0x03)
@@ -228,17 +229,6 @@ struct mpi3_encrypted_hash_entry {
 #define MPI3_ENCRYPTION_ALGORITHM_RSA2048            (0x04)
 #define MPI3_ENCRYPTION_ALGORITHM_RSA4096            (0x05)
 #define MPI3_ENCRYPTION_ALGORITHM_RSA3072            (0x06)
-#ifndef MPI3_PUBLIC_KEY_MAX
-#define MPI3_PUBLIC_KEY_MAX                          (1)
-#endif
-struct mpi3_encrypted_key_with_hash_entry {
-	u8                         hash_image_type;
-	u8                         hash_algorithm;
-	u8                         encryption_algorithm;
-	u8                         reserved03;
-	__le32                     reserved04;
-	__le32                     public_key[MPI3_PUBLIC_KEY_MAX];
-};
 
 #ifndef MPI3_ENCRYPTED_HASH_ENTRY_MAX
 #define MPI3_ENCRYPTED_HASH_ENTRY_MAX               (1)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index 85b91583bacf..028784949873 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -101,6 +101,8 @@ struct mpi3_ioc_facts_data {
 	__le16                     max_io_throttle_group;
 	__le16                     io_throttle_low;
 	__le16                     io_throttle_high;
+	__le32			   diag_fdl_size;
+	__le32			   diag_tty_size;
 };
 #define MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_MASK          (0x80000000)
 #define MPI3_IOCFACTS_CAPABILITY_SUPERVISOR_IOC               (0x00000000)
@@ -108,13 +110,13 @@ struct mpi3_ioc_facts_data {
 #define MPI3_IOCFACTS_CAPABILITY_INT_COALESCE_MASK            (0x00000600)
 #define MPI3_IOCFACTS_CAPABILITY_INT_COALESCE_FIXED_THRESHOLD (0x00000000)
 #define MPI3_IOCFACTS_CAPABILITY_INT_COALESCE_OUTSTANDING_IO  (0x00000200)
-#define MPI3_IOCFACTS_CAPABILITY_COMPLETE_RESET_CAPABLE       (0x00000100)
-#define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_TRACE_ENABLED       (0x00000080)
-#define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_FW_ENABLED          (0x00000040)
-#define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_DRIVER_ENABLED      (0x00000020)
-#define MPI3_IOCFACTS_CAPABILITY_ADVANCED_HOST_PD_ENABLED     (0x00000010)
-#define MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE                 (0x00000008)
-#define MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED            (0x00000002)
+#define MPI3_IOCFACTS_CAPABILITY_COMPLETE_RESET_SUPPORTED     (0x00000100)
+#define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_TRACE_SUPPORTED     (0x00000080)
+#define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_FW_SUPPORTED        (0x00000040)
+#define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_DRIVER_SUPPORTED    (0x00000020)
+#define MPI3_IOCFACTS_CAPABILITY_ADVANCED_HOST_PD_SUPPORTED   (0x00000010)
+#define MPI3_IOCFACTS_CAPABILITY_RAID_SUPPORTED               (0x00000008)
+#define MPI3_IOCFACTS_CAPABILITY_MULTIPATH_SUPPORTED          (0x00000002)
 #define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_SUPPORTED      (0x00000001)
 #define MPI3_IOCFACTS_PID_TYPE_MASK                           (0xf000)
 #define MPI3_IOCFACTS_PID_TYPE_SHIFT                          (12)
@@ -159,6 +161,8 @@ struct mpi3_ioc_facts_data {
 #define MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR              (0x00000002)
 #define MPI3_IOCFACTS_IO_THROTTLE_DATA_LENGTH_NOT_REQUIRED    (0x0000)
 #define MPI3_IOCFACTS_MAX_IO_THROTTLE_GROUP_NOT_REQUIRED      (0x0000)
+#define MPI3_IOCFACTS_DIAGFDLSIZE_NOT_SUPPORTED		      (0x00000000)
+#define MPI3_IOCFACTS_DIAGTTYSIZE_NOT_SUPPORTED               (0x00000000)
 struct mpi3_mgmt_passthrough_request {
 	__le16                 host_tag;
 	u8                     ioc_use_only02;
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index 1e0a3dcaf723..fdc3d1968e43 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -18,7 +18,7 @@ union mpi3_version_union {
 
 #define MPI3_VERSION_MAJOR                                              (3)
 #define MPI3_VERSION_MINOR                                              (0)
-#define MPI3_VERSION_UNIT                                               (28)
+#define MPI3_VERSION_UNIT                                               (31)
 #define MPI3_VERSION_DEV                                                (0)
 #define MPI3_DEVHANDLE_INVALID                                          (0xffff)
 struct mpi3_sysif_oper_queue_indexes {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 07accf01be0f..0f102ba49759 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1280,7 +1280,7 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 			    mrioc->shost->max_sectors * 512, mrioc->facts.max_data_length);
 
 	if ((mrioc->sas_transport_enabled) && (mrioc->facts.ioc_capabilities &
-	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED))
+	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_SUPPORTED))
 		ioc_err(mrioc,
 		    "critical error: multipath capability is enabled at the\n"
 		    "\tcontroller while sas transport support is enabled at the\n"
@@ -3677,8 +3677,8 @@ static const struct {
 	u32 capability;
 	char *name;
 } mpi3mr_capabilities[] = {
-	{ MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE, "RAID" },
-	{ MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED, "MultiPath" },
+	{ MPI3_IOCFACTS_CAPABILITY_RAID_SUPPORTED, "RAID" },
+	{ MPI3_IOCFACTS_CAPABILITY_MULTIPATH_SUPPORTED, "MultiPath" },
 };
 
 /**
@@ -3960,7 +3960,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		    MPI3MR_HOST_IOS_KDUMP);
 
 	if (!(mrioc->facts.ioc_capabilities &
-	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED)) {
+	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_SUPPORTED)) {
 		mrioc->sas_transport_enabled = 1;
 		mrioc->scsi_device_channel = 1;
 		mrioc->shost->max_channel = 1;
-- 
2.31.1


--0000000000000c79aa0613137c16
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIC+3q7UkAd/O7vv1+F8aEhorqW0fXx1W
fotdIQSLzWhzMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMw
NzE1MTEwNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDmIJUKJPand77n4E5U/JFbHKs2PMyGY/h3oW737+BArbEhiYUZ
cfM4WZaCAID8L+eM0WWr7iwiv3Kw/CYb3+hzCBze/RUPJ73jyVieqg0o56s+r30VgyIJo+GOq9r3
2n6H0IYO+LWVFfqTOupqK9CJOXFryl7OZtTGTTFUVUwIgzt9t7fNWaCSwCAZVQJ3RqOKNKbXsR9j
wM0aQpMSKE7wLVV2zS3JRL4woqyhiV+fnUMwry38L01XSsOq3F1rPiGayz9jwJIQgZ5jacqZKzG2
o7VtIsfRuZKk2/DtwEzjsDlP+8JuzNYjgPVVNAjoX9Ja1scja15OOnHT3UU+gb0L
--0000000000000c79aa0613137c16--
