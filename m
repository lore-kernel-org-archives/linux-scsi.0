Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93923BBF0
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 11:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710157082; cv=none; b=hgQ1B2msgB2FGIlakJlKPCvsv/Xj0d13J7K9h0uQA8ZL1TeJqIKuwwhLzCX6wI2gQnnXM9Ec4Xof5DrbXD4V0+OqaSyQCOmwZAnSyGlAwTC9Y0p66Rt2EHoHxvFWW/8lFbajnXzlqtQXRNEUCDqx1Pm2oI9Y93XeMOG7NdKRpOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710157082; c=relaxed/simple;
	bh=ITHy56DWZ0RorXQAH12zpOQQc7OhNS6WEYCjdxSHGPE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O3H8NGHl7Kkoy/5nfwCVauG4Xt6GnGH+EFpooeNBXW1ZM9nE/f4S5YmVQK4aAObnBELEdZDhaRrpJ4x7MDuFC9hH8oJO1wp+HDO0YMGKguk26cFokSmYdplUZVdVoPiQSCR24C7pBfGsPzcefhe33q1SPGpgLLk4wY1Hi5vkvGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UcrT0Ola; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UcrT0Ola"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-29b7b9a4908so1629620a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 04:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1710157079; x=1710761879; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=0eegRfjJHv1whYpDpJR6iOXJMEceoubavlXR5qbSzFw=;
        b=UcrT0OlaXx+zUYIEOZrnzgY6mHBKs363CPUg32BAEODwMZ08qjfJlxDW4d8pev+IZb
         MgWEI3w1MGqB/rUUW8K4bzhzpwZlQcAk2gj3USgtq5rsdjNMiPDGhV5Z1gG8kgd6k1ZG
         KpOqhyIuYymZnSDl1c4H3NHFe/P3XhHkq7vzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710157079; x=1710761879;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0eegRfjJHv1whYpDpJR6iOXJMEceoubavlXR5qbSzFw=;
        b=OL8A/y6SvalTpl8Wx7VrXy1NO9RTLtsRZqFxyu18mbqVdre7VEECNFVGAFfP8SV9rm
         YnY5D7/9IEskvwCE8NNq2PXpIVAeakpg3wS1UVTy6xY6OuP1Ye6hxupBdkkUb6K3NIot
         xby2IcPyGT8p7QL426dfXfDBteVqlfn1Ah9jv+CISAe1TqyipcAc16MBidNy9C86Eyk6
         UQFn0Rmv46MlOHWU4ujAYAeNXAAyAj4ZBdPh0oCDSG59VrjQgZt9tK/uD32HOC2kjWRz
         Zwzox+2eZF8ZSSQ9z8yFjcz9kv6b48cwYTVfXQrViUY7/ZpSHfCPxlS6uwCa3oyHFdaU
         VpTQ==
X-Gm-Message-State: AOJu0Yw0tOkBjmS0Wu61e5p1YdTORmxt0MUR9cdrOeEbRtQlbzMW45qv
	dsxgz07FalrLAb+cEqhQ2GR/c8zxAp9ENfhUejbDVPKZXW7x+f8SoATgbJhUGm5jE2q7ZOmOqRa
	w6841jrcvAVpUsK+NB9Q1v3oX6g48dlPXOfboK6DPBzBRobYB6nccxLPzzqVtQ+62VLd0nVdQ1E
	dMLnqTzCmBMKlsKhUBcv5VupkXuP86NCmSTfiD93hzvkeTNg==
X-Google-Smtp-Source: AGHT+IHd6FIz8VWBDVi5lEUDqZDmtWqpaV9lqW2oTMMOWZOKeKJYq1tdRUYIUHLUgmoIW97klEdLpg==
X-Received: by 2002:a17:90a:cb09:b0:29b:c402:9d65 with SMTP id z9-20020a17090acb0900b0029bc4029d65mr3877260pjt.5.1710157079208;
        Mon, 11 Mar 2024 04:37:59 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id ay3-20020a17090b030300b0029ba5f434a8sm3982655pjb.26.2024.03.11.04.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 04:37:58 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v3 6/7] mpi3mr: Update MPI Headers to revision 31
Date: Mon, 11 Mar 2024 17:05:13 +0530
Message-Id: <20240311113514.108795-7-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240311113514.108795-1-ranjan.kumar@broadcom.com>
References: <20240311113514.108795-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000404663061360f90f"

--000000000000404663061360f90f
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


--000000000000404663061360f90f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDExX4+q15YXlYbDuOzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjExMTQxMjAzMThaFw0yNTExMTQxMjAzMThaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFJhbmphbiBLdW1hcjEoMCYGCSqGSIb3DQEJ
ARYZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAOgccBnKTcRY5ViAG6iAGKWZ8pjYBaC0yPSOnu903VijdPFPnRdvshVcVxr6QvmlBCzKJaet
zZlOdDzH9Sh5FfHxwia1H790mce+cjggA6koNdslP25m4SfoAUcvLxNk1koVjbyxvNPG40Mlg8f8
Dp9JubCHz3kEFHjItKFkpS8CHMR1Hx4Cnws434zD/pz1TMUmYyq1kma0Vi8YPVlwkaHgq4J/9Lw/
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
fotdIQSLzWhzMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMx
MTExMzc1OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCVgklqIU31qqdGemrHYVQqj8uo7iMJkNOvfJI8B2KVAUXMWCvj
sgu0G15ikHEiAVQWkKp9eintnKtByM0J5ciJ7fgLzWAUtZnVMjI3sOsZ2IoNYlpZIwfGoaAJQbMh
FVdE5Ia6SAl6vb7Ei2Xg6NxE8mbNYSeOxS601lbwYC4AG66f3mjmQBDp1Zz3QfKSGh8sssZPY+18
bYIsn059UnE+B8n/GDBofuxadPP+spMX18xBta62bGcQgEJ5R18NmcKb3yCr6wYRHVzzf8AV5xhJ
ub8B0GEqey79SpS8IC1SYKSDe5ovfcoVvbRJe0pIUE0YmPqZVrHCyRMtm0GY+9AS
--000000000000404663061360f90f--
