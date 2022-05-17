Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4640BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 11:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345427AbiEQLnI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 07:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345395AbiEQLmw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 07:42:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582E52A705
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 04:42:51 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d22so17079454plr.9
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 04:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=0hvgOJ/C1TjrxcZknZE0f/HSVN7iRQzrfRz2O43CLwM=;
        b=KWN5AMCzlRMxtSE2eXXXBVbZf+Pxo8+4a5GTwmh3SwsFWLj7mkfzcntJ9WzKe3n03K
         TVa2xMGt8k0H2BIcQO9Wc6qJIdWSX1cVZDp0VxXTnCsIcQOxyBxdnpZBeyOJyTuLATAc
         4zzkpCNm9DHJcslv42eK15/8ktw47+gA63DUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=0hvgOJ/C1TjrxcZknZE0f/HSVN7iRQzrfRz2O43CLwM=;
        b=Cvxid6HtVZPFaHAqGZD9CHM5olFzuJixN0OQAVqpWUgXfhibFU9kF7ZIPg/dLg2+fB
         rI0F+cNpFKGLgZswbUYIc9o6hOIIOXjdGPdsAiYG+e2Yq1/ywszKd+TWiqvPqOmHWh3t
         9Xhb2Ztsd1dDQGPuqxA8UDSH/GGpKzK9CgKBzAMI7BL62vGDFNdUbiLKotpOOkIMFfDu
         fZe4uPb0xmf+Wi9HpzxjeDstKwGpEkrWpEr7YBddA8djlKCwYTMQkkPcsP1Zux2juFbp
         C/p06a8XEbG+1l4Th+QLC/pa+bnG8sOCqEoQPj5Szy7B1/+trgzAVlTJBf5gQE+lh9UU
         8jzw==
X-Gm-Message-State: AOAM531o/kd5Ch/+qgFyu5+7vU9nbVSFNf5hCEwsbz40V0nF3dtW0nb6
        euyhvshHi3WjFWxRaUBvxGdKA4aauYLOd3Gx3VMn7cAyyrw60HugDfLc/vkw45iv7PAIwTkI4cG
        PdVj6HzLhLpsdAso+pkmk96WwriE9PtsJy+bsdmTidW8aIijHcrnTJ5zWQu5NeZqmft/1Ktx4Bp
        pbY+m68gnL6YQ=
X-Google-Smtp-Source: ABdhPJxk+bB7ydawt/Q+fs0RQS/HbMzA1sYULOeG+J9pYwQ1fDZZ0vBr/P0fhc8RqMMSw6DZzes80A==
X-Received: by 2002:a17:90b:4f87:b0:1dd:100b:7342 with SMTP id qe7-20020a17090b4f8700b001dd100b7342mr35584606pjb.64.1652787770235;
        Tue, 17 May 2022 04:42:50 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o134-20020a62cd8c000000b0050dc7628178sm8795130pfg.82.2022.05.17.04.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 04:42:49 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 1/2] mpi3mr: Add shost related sysfs attributes
Date:   Tue, 17 May 2022 17:23:09 +0530
Message-Id: <20220517115310.13062-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220517115310.13062-1-sreekanth.reddy@broadcom.com>
References: <20220517115310.13062-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f6424705df33a39a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f6424705df33a39a
Content-Transfer-Encoding: 8bit

Added shost related sysfs attributes to get the controller's
firmware version, controlller's queue depth,
number of request & reply queues.
Also added an attribute to set & get the logging_level.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 Changes from v1:
 Used sysfs_emit() instead of snprintf() api.

 drivers/scsi/mpi3mr/mpi3mr_app.c | 143 ++++++++++++++++++++++++++++++-
 1 file changed, 141 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 8138a72..33bad2f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1558,13 +1558,147 @@ err_device_add:
 	kfree(mrioc->bsg_dev);
 }
 
+/**
+ * version_fw_show - SysFS callback for firmware version read
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: sysfs_emit() return after copying firmware version
+ */
+static ssize_t
+version_fw_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+	struct mpi3mr_compimg_ver *fwver = &mrioc->facts.fw_ver;
+
+	return sysfs_emit(buf, "%d.%d.%d.%d.%05d-%05d\n",
+	    fwver->gen_major, fwver->gen_minor, fwver->ph_major,
+	    fwver->ph_minor, fwver->cust_id, fwver->build_num);
+}
+static DEVICE_ATTR_RO(version_fw);
+
+/**
+ * fw_queue_depth_show - SysFS callback for firmware max cmds
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: sysfs_emit() return after copying firmware max commands
+ */
+static ssize_t
+fw_queue_depth_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return sysfs_emit(buf, "%d\n", mrioc->facts.max_reqs);
+}
+static DEVICE_ATTR_RO(fw_queue_depth);
+
+/**
+ * op_req_q_count_show - SysFS callback for request queue count
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: sysfs_emit() return after copying request queue count
+ */
+static ssize_t
+op_req_q_count_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return sysfs_emit(buf, "%d\n", mrioc->num_op_req_q);
+}
+static DEVICE_ATTR_RO(op_req_q_count);
+
+/**
+ * reply_queue_count_show - SysFS callback for reply queue count
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: sysfs_emit() return after copying reply queue count
+ */
+static ssize_t
+reply_queue_count_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return sysfs_emit(buf, "%d\n", mrioc->num_op_reply_q);
+}
+
+static DEVICE_ATTR_RO(reply_queue_count);
+
+/**
+ * logging_level_show - Show controller debug level
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * A sysfs 'read/write' shost attribute, to show the current
+ * debug log level used by the driver for the specific
+ * controller.
+ *
+ * Return: sysfs_emit() return
+ */
+static ssize_t
+logging_level_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return sysfs_emit(buf, "%08xh\n", mrioc->logging_level);
+}
+
+/**
+ * logging_level_store- Change controller debug level
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ * @count: size of the buffer
+ *
+ * A sysfs 'read/write' shost attribute, to change the current
+ * debug log level used by the driver for the specific
+ * controller.
+ *
+ * Return: strlen() return
+ */
+static ssize_t
+logging_level_store(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+	int val = 0;
+
+	if (kstrtoint(buf, 0, &val) != 0)
+		return -EINVAL;
+
+	mrioc->logging_level = val;
+	ioc_info(mrioc, "logging_level=%08xh\n", mrioc->logging_level);
+	return strlen(buf);
+}
+static DEVICE_ATTR_RW(logging_level);
+
 /**
  * adapter_state_show - SysFS callback for adapter state show
  * @dev: class device
  * @attr: Device attributes
  * @buf: Buffer to copy
  *
- * Return: snprintf() return after copying adapter state
+ * Return: sysfs_emit() return after copying adapter state
  */
 static ssize_t
 adp_state_show(struct device *dev, struct device_attribute *attr,
@@ -1585,12 +1719,17 @@ adp_state_show(struct device *dev, struct device_attribute *attr,
 	else
 		adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", adp_state);
+	return sysfs_emit(buf, "%u\n", adp_state);
 }
 
 static DEVICE_ATTR_RO(adp_state);
 
 static struct attribute *mpi3mr_host_attrs[] = {
+	&dev_attr_version_fw.attr,
+	&dev_attr_fw_queue_depth.attr,
+	&dev_attr_op_req_q_count.attr,
+	&dev_attr_reply_queue_count.attr,
+	&dev_attr_logging_level.attr,
 	&dev_attr_adp_state.attr,
 	NULL,
 };
-- 
2.27.0


--000000000000f6424705df33a39a
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDatpNZTGzm2P6YWgSYU
B1cbKtNUZteHyTmCnj/lSNN1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDUxNzExNDI1MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAjXqZxvmiPcC5z6KOI1KjIn/JWt3ipiablgkwN
BLwwu8oqY7CGJritwdjqKpL6gIE3ZQhWuAoczYGcP0pO+4tPr2gHmne7ZvV13D87GR51LYbdD9pL
FeF3jhjzqUExs0jmtN0j21n2OdmmMToLx2t7bXYYkOCEXL/76/0vZkcJYdmF8UoUsuslBTNGxFSG
GjnrduEEFPX/qsxLOtBPwwTEAOWLR8pX7Pj90T0+bYmQ0fYB5CqoeogJyE3IFONCVc/D6QGp28nD
9h4xNHEgFzES3gs69qSmTzyQi72x/82xrJhCPYMovKj84B3sjkGiF4hZjfAidV+kUW5DgVm9If62
--000000000000f6424705df33a39a--
