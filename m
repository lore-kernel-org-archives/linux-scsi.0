Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8925EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 13:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354649AbiELNud (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 09:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354703AbiELNua (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 09:50:30 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB01224A397
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 06:50:28 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q18so4904613pln.12
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 06:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=zdCnOF6Ba0xx/Y8+/HAY/7pVmQk9xCTkyF4P4CSvFB0=;
        b=X0vGoh8fTu9zNgMVNrfXfRdpRIYH/ikEsdkQUinuQWw/YUgoKQiqX0yYrpDiCTc6Lm
         vH4tFHCrjPi1aQun6uyQpOkIvFJSFTl+Ln71yVa98Tm/gh8YRPjwvJk4kxJpg40a74T9
         KradyfZiL3pe5uBtKSLgYtqb8uzCYsIqK0fX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=zdCnOF6Ba0xx/Y8+/HAY/7pVmQk9xCTkyF4P4CSvFB0=;
        b=xs7WED27cIySOqYPTksDhV5LsLHyllKQH8scc8NR1K/B8hg2Gb1z13PFH1IZ4wCHi6
         4LEOoc6BhXpKBf3FWlo4GWkkWO7nbgs5dJfOI2JuS/IhVmapWtFhlq3i4iFZaaAvL+58
         l7QCoNSHiQ5i7sOyVtJW316VRt2ogiwlV9Nv/veu9OMYGiIrqDbSlZSxwowtpFY5DFdj
         4ty9BEX66pK/IQoxgeki3Nj3fMArbdktrAdnEToHuQJOvothDCo8ozi5lN4KitwcCmsC
         p7wBjRgxouPxjq0x97ueaZodGIa6jgIyy/DJWF7Py6bif45fyXNgWt0cYli/5pS1B+11
         vhFA==
X-Gm-Message-State: AOAM531JIn4p/oKi0CPq/jNQ9DNcoRxpwnAE8yMcpClHEs4JG39j2oJg
        fvlfKrpskTb0304YYrGFtL2iyDmgbrXSsYMLXjHRijgqW3ir2TuM8sMFRnRJkGBhSGFOjD1bWfz
        WA2MXOWcrm2NJ8aV6GluayQQ5eN47H3StVZc47eNJh0dCDG2DH1k5D9cnvZayIrHZnGt41CMOdx
        58Ow73MdOl
X-Google-Smtp-Source: ABdhPJwl9lNz8CE7Anl4t9GjM/949MlsaOz6sPUfj72aUyVhoGfxWN8LZR6BkqhuDvOkbGcWrSNDhg==
X-Received: by 2002:a17:90a:884:b0:1d9:531c:9cd6 with SMTP id v4-20020a17090a088400b001d9531c9cd6mr10843726pjc.211.1652363427614;
        Thu, 12 May 2022 06:50:27 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.252.250])
        by smtp.gmail.com with ESMTPSA id t21-20020a17090ad15500b001cd4989ff47sm1872409pjw.14.2022.05.12.06.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 06:50:27 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 2/2] mpi3mr: Add target device related sysfs attributes
Date:   Thu, 12 May 2022 19:30:46 +0530
Message-Id: <20220512140046.19046-3-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512140046.19046-1-sreekanth.reddy@broadcom.com>
References: <20220512140046.19046-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002c9a0e05ded0d79c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002c9a0e05ded0d79c
Content-Transfer-Encoding: 8bit

Added sysfs attributes for exposing target device details
such as SAS address, firmware device handle and persistent ID
for the controller attached devices and RAID volumes.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |   1 +
 drivers/scsi/mpi3mr/mpi3mr_app.c | 120 +++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c  |   1 +
 3 files changed, 122 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 584659e..01cd017 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1085,4 +1085,5 @@ int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
 void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size);
 extern const struct attribute_group *mpi3mr_host_groups[];
+extern const struct attribute_group *mpi3mr_dev_groups[];
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index c9b153c..69054a8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1742,3 +1742,123 @@ const struct attribute_group *mpi3mr_host_groups[] = {
 	&mpi3mr_host_attr_group,
 	NULL,
 };
+
+
+/*
+ * SCSI Device attributes under sysfs
+ */
+
+/**
+ * sas_address_show - SysFS callback for dev SASaddress display
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: snprintf() return after copying SAS address of the
+ * specific SAS/SATA end device.
+ */
+static ssize_t
+sas_address_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct mpi3mr_sdev_priv_data *sdev_priv_data;
+	struct mpi3mr_stgt_priv_data *tgt_priv_data;
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	sdev_priv_data = sdev->hostdata;
+	if (!sdev_priv_data)
+		return 0;
+
+	tgt_priv_data = sdev_priv_data->tgt_priv_data;
+	if (!tgt_priv_data)
+		return 0;
+	tgtdev = tgt_priv_data->tgt_dev;
+	if (!tgtdev || tgtdev->dev_type != MPI3_DEVICE_DEVFORM_SAS_SATA)
+		return 0;
+	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",
+	    (unsigned long long)tgtdev->dev_spec.sas_sata_inf.sas_address);
+}
+
+static DEVICE_ATTR_RO(sas_address);
+
+/**
+ * device_handle_show - SysFS callback for device handle display
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: snprintf() return after copying firmware internal
+ * device handle of the specific device.
+ */
+static ssize_t
+device_handle_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct mpi3mr_sdev_priv_data *sdev_priv_data;
+	struct mpi3mr_stgt_priv_data *tgt_priv_data;
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	sdev_priv_data = sdev->hostdata;
+	if (!sdev_priv_data)
+		return 0;
+
+	tgt_priv_data = sdev_priv_data->tgt_priv_data;
+	if (!tgt_priv_data)
+		return 0;
+	tgtdev = tgt_priv_data->tgt_dev;
+	if (!tgtdev)
+		return 0;
+	return snprintf(buf, PAGE_SIZE, "0x%04x\n", tgtdev->dev_handle);
+}
+
+static DEVICE_ATTR_RO(device_handle);
+
+/**
+ * persistent_id_show - SysFS callback for persisten ID display
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: snprintf() return after copying persistent ID of the
+ * of the specific device.
+ */
+static ssize_t
+persistent_id_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct mpi3mr_sdev_priv_data *sdev_priv_data;
+	struct mpi3mr_stgt_priv_data *tgt_priv_data;
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	sdev_priv_data = sdev->hostdata;
+	if (!sdev_priv_data)
+		return 0;
+
+	tgt_priv_data = sdev_priv_data->tgt_priv_data;
+	if (!tgt_priv_data)
+		return 0;
+	tgtdev = tgt_priv_data->tgt_dev;
+	if (!tgtdev)
+		return 0;
+	return snprintf(buf, PAGE_SIZE, "%d\n", tgtdev->perst_id);
+}
+static DEVICE_ATTR_RO(persistent_id);
+
+static struct attribute *mpi3mr_dev_attrs[] = {
+	&dev_attr_sas_address.attr,
+	&dev_attr_device_handle.attr,
+	&dev_attr_persistent_id.attr,
+	NULL,
+};
+
+static const struct attribute_group mpi3mr_dev_attr_group = {
+	.attrs = mpi3mr_dev_attrs
+};
+
+const struct attribute_group *mpi3mr_dev_groups[] = {
+	&mpi3mr_dev_attr_group,
+	NULL,
+};
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f5c345d..d8c195b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4147,6 +4147,7 @@ static struct scsi_host_template mpi3mr_driver_template = {
 	.track_queue_depth		= 1,
 	.cmd_size			= sizeof(struct scmd_priv),
 	.shost_groups			= mpi3mr_host_groups,
+	.sdev_groups			= mpi3mr_dev_groups,
 };
 
 /**
-- 
2.27.0


--0000000000002c9a0e05ded0d79c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQdgYJKoZIhvcNAQcCoIIQZzCCEGMCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3NMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
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
XzCCBVUwggQ9oAMCAQICDHJ6qvXSR4uS891jDjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMzAyMTFaFw0yMjA5MTUxMTUxNTZaMIGU
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGDAWBgNVBAMTD1NyZWVrYW50aCBSZWRkeTErMCkGCSqGSIb3
DQEJARYcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAM11a0WXhMRf+z55FvPxVs60RyUZmrtnJOnUab8zTrgbomymXdRB6/75SvK5zuoS
vqbhMdvYrRV5ratysbeHnjsfDV+GJzHuvcv9KuCzInOX8G3rXAa0Ow/iodgTPuiGxulzqKO85XKn
bwqwW9vNSVVW+q/zGg4hpJr4GCywE9qkW7qSYva67acR6vw3nrl2OZpwPjoYDRgUI8QRLxItAgyi
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILS2wtBkJ4pfr1Cp0WbU
CngTed5GR7f8h0VJVMkRdQahMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDUxMjEzNTAyOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAvikCazo4SqNCDWEzgtvEhs9OajvyroHQThOnA
Mvu7O4a891nSIabf7aPXpUWa4Yb8vA6pP3OAIlGDKmRM8EYMr9Yu7Ax3nBnEiS2+o8KcAEXhZHPR
xE/iZ8S2zyHRVCxTPZxqVn54CFL0z8hK2kRbI/Gh61JD0fNcU2Fm5XRnpgAeHlbUNtFGYNve3W+e
EGZi+mW5PW7F3luEkG3avMjOKC7/hktSOHi8IxWG20j7WckUyrsjc1cW/QIG4qi+H/HAgzjaE+mz
tlmzWO/yXOghbzLaEhKAR+vgANazGQ2Ayq4FuoRyAj+lOQKfJwg0Zhm76oCJAjQobk+YqMESnJUW
--0000000000002c9a0e05ded0d79c--
