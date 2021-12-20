Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6C5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhLTOES (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbhLTOEP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:15 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D82C061401
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:15 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id a23so9490221pgm.4
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=Li9ZzYgTscm9Nk8n6eURg7S43BpiKZ0rpUu8JuH19uE=;
        b=cTklcMig4SVzV7jKszV7QDzPI32ZuaBEVdLV/s8+5YugY4yQZApKqLuJA7aO/n0gDH
         X/hZjIl8IcSURp/OvaIw5xUT20SoXBQsruyuzXpt2Y3Esq2oMzRPXRufJeEnrjkLDEJg
         WBY9Vh5oqeU0Vp1Pxi6DUmHkxdehMwMd4PmNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=Li9ZzYgTscm9Nk8n6eURg7S43BpiKZ0rpUu8JuH19uE=;
        b=a7eqaaAqosIwSgNI4njhx/k8Xx68RoqNgIvDgngxu04yfw2bxlksfnTaAQblfQRtG6
         ddv9aP1+MpF5+v1/tSwEtf/38Dq/5TXsjQkV+qv8dd70LCxbUJYL/OZKaZkugIsBiBEs
         IXpfHheXaL8/gKmyPJ+9xYS7NipMmoc4CjF+ep9FQ1dIM+N7lNqRXMy51groUXsxa0Wg
         UDUPh6vYXMPWJBx8zdGvSu3t2zwMOYFupsBGPZdiI1BCJapRMQMDYzvjBpobK0DSgMvh
         be5GOvUEHN35VDaxTcV/0R1+6iM9nmwuZ+euqDr0iti/dJSVg+0cZ6Yg7OximTk7gCyB
         JePw==
X-Gm-Message-State: AOAM532P3OQguSHlor7HnElBOC0OfldXim1IuzTu9xDN0itSRiFUGarm
        EBlaH+um5hAtqPpENc+2DOVmbMYD2/RjI0sWHO7kQQr6THDdw7PRf8EXw28drvHPz01PjFcR5yc
        Rfh5s29nzXg92n0oeeYo+//7QFZfDzHHrYy/aNXvBqYEzRfCP97QVKxWGIDtXh2UWRMSLaD+dqe
        xzc3opNhFm
X-Google-Smtp-Source: ABdhPJx1MqniG1GTqb54ZPqOQAFm0hFVwlUKHW8pfWGmOFdn9AEgIBxai5JvkHPF3x5RaelHgsKwVg==
X-Received: by 2002:a62:78d3:0:b0:4ba:7141:83e9 with SMTP id t202-20020a6278d3000000b004ba714183e9mr16360470pfc.83.1640009054671;
        Mon, 20 Dec 2021 06:04:14 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:14 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 06/25] mpi3mr: Add support for PCIe Managed Switch SES device
Date:   Mon, 20 Dec 2021 19:41:40 +0530
Message-Id: <20211220141159.16117-7-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002b57d205d3945d87"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002b57d205d3945d87
Content-Transfer-Encoding: 8bit

The SAS4 Controller firmware exposes the SES devices
in Managed PCIe Switch as a PCIe Device Type SCSI Device
(MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_SCSI_DEVICE).

Driver is enhanced to handle this device type by
 - exposing the device to the upper layers and
 - not updating any hardware sectors & virtual boundary
settings as these settings are needed only for
NVMe devices.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 40 ++++++++++++++++++++++++---------
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index cdbd1cb..fe3cfd5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -147,6 +147,7 @@ extern int prot_mask;
 			MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC
 
 #define MPI3MR_DEFAULT_MDTS	(128 * 1024)
+#define MPI3MR_DEFAULT_PGSZEXP         (12)
 /* Command retry count definitions */
 #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
 
@@ -389,6 +390,7 @@ struct tgt_dev_sas_sata {
  * @pgsz: Device page size
  * @abort_to: Timeout for abort TM
  * @reset_to: Timeout for Target/LUN reset TM
+ * @dev_info: Device information bits
  */
 struct tgt_dev_pcie {
 	u32 mdts;
@@ -396,6 +398,7 @@ struct tgt_dev_pcie {
 	u8 pgsz;
 	u8 abort_to;
 	u8 reset_to;
+	u16 dev_info;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e887d31..14621dc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -742,11 +742,18 @@ mpi3mr_update_sdev(struct scsi_device *sdev, void *data)
 	switch (tgtdev->dev_type) {
 	case MPI3_DEVICE_DEVFORM_PCIE:
 		/*The block layer hw sector size = 512*/
-		blk_queue_max_hw_sectors(sdev->request_queue,
-		    tgtdev->dev_spec.pcie_inf.mdts / 512);
-		blk_queue_virt_boundary(sdev->request_queue,
-		    ((1 << tgtdev->dev_spec.pcie_inf.pgsz) - 1));
-
+		if ((tgtdev->dev_spec.pcie_inf.dev_info &
+		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) ==
+		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE) {
+			blk_queue_max_hw_sectors(sdev->request_queue,
+			    tgtdev->dev_spec.pcie_inf.mdts / 512);
+			if (tgtdev->dev_spec.pcie_inf.pgsz == 0)
+				blk_queue_virt_boundary(sdev->request_queue,
+				    ((1 << MPI3MR_DEFAULT_PGSZEXP) - 1));
+			else
+				blk_queue_virt_boundary(sdev->request_queue,
+				    ((1 << tgtdev->dev_spec.pcie_inf.pgsz) - 1));
+		}
 		break;
 	default:
 		break;
@@ -848,6 +855,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		    &dev_pg0->device_specific.pcie_format;
 		u16 dev_info = le16_to_cpu(pcieinf->device_info);
 
+		tgtdev->dev_spec.pcie_inf.dev_info = dev_info;
 		tgtdev->dev_spec.pcie_inf.capb =
 		    le32_to_cpu(pcieinf->capabilities);
 		tgtdev->dev_spec.pcie_inf.mdts = MPI3MR_DEFAULT_MDTS;
@@ -864,8 +872,10 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		}
 		if (tgtdev->dev_spec.pcie_inf.mdts > (1024 * 1024))
 			tgtdev->dev_spec.pcie_inf.mdts = (1024 * 1024);
-		if ((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=
-		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE)
+		if (((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=
+		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE) &&
+		    ((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=
+		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_SCSI_DEVICE))
 			tgtdev->is_hidden = 1;
 		if (!mrioc->shost)
 			break;
@@ -3190,10 +3200,18 @@ static int mpi3mr_slave_configure(struct scsi_device *sdev)
 	switch (tgt_dev->dev_type) {
 	case MPI3_DEVICE_DEVFORM_PCIE:
 		/*The block layer hw sector size = 512*/
-		blk_queue_max_hw_sectors(sdev->request_queue,
-		    tgt_dev->dev_spec.pcie_inf.mdts / 512);
-		blk_queue_virt_boundary(sdev->request_queue,
-		    ((1 << tgt_dev->dev_spec.pcie_inf.pgsz) - 1));
+		if ((tgt_dev->dev_spec.pcie_inf.dev_info &
+		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) ==
+		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE) {
+			blk_queue_max_hw_sectors(sdev->request_queue,
+			    tgt_dev->dev_spec.pcie_inf.mdts / 512);
+			if (tgt_dev->dev_spec.pcie_inf.pgsz == 0)
+				blk_queue_virt_boundary(sdev->request_queue,
+				    ((1 << MPI3MR_DEFAULT_PGSZEXP) - 1));
+			else
+				blk_queue_virt_boundary(sdev->request_queue,
+				    ((1 << tgt_dev->dev_spec.pcie_inf.pgsz) - 1));
+		}
 		break;
 	default:
 		break;
-- 
2.27.0


--0000000000002b57d205d3945d87
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICnHgsysu2Px119BAAJ9
iph46UXlEh6rWTdSkO9jg1u3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBX3s58ifGCZSgxiWxqvDpZEDFxT79hhgUR6W4m
nvOIE1ZmMZy5CJB7Ibp5eFNfTokJi5oh3EYc2anc7Q9xssBYwuY9stLO7atR7Z9jFUVxYaaOrOly
VoF0JrHYzAhBNXDJkhG0FtrDUHteBiam/Ve4IsVNGqMLNuMWwyDQiNY/RNRn70euZRMC/pdbVYmO
8r7+AFhexW5qJ0w1y2RxGjJq3zTV/JA/BBaJsE85TZK1E0KepTh+bvHdjjcQQNkFiS2GAxX7pNqi
6YmGMoeX/9Y8hRLZclsNuhDPf/prDZYwd6Ko5AHP42yPUfuFmyseI75uNVhhM5E9yS42WPuyk7Tb
--0000000000002b57d205d3945d87--
