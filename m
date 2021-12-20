Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025B7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhLTOEE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhLTOEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:04 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3DC061574
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:03 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id v11so5638183pfu.2
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=/SdJHiAbb7WIOgehbVUNue7aYUoDGxZ5gTvy9HY6RCM=;
        b=DTn0Lb2/ru7dPta3eQ1htTgyl0fgHr+rZzyNGO7k3DoDUSvKRTglEuLnJ58GQnM2fn
         Zvtq/E5grWwPBAxz817uLySEdd7yXqSNYNZVnQoVaVc3liZz8WRM4dTXFrZUP/sT63sD
         5+OW0qrwpEndTZGdwaRHDqIpH4qxj7hikyMxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=/SdJHiAbb7WIOgehbVUNue7aYUoDGxZ5gTvy9HY6RCM=;
        b=bN82dKwRSDe0MuEuwwRFkkvEDBHQIqBrS8q37XOqNOyEOrm7eCyiSZOJnbmmNbsc68
         OJItD1QNlBjPxQ2xgsWgCvwPwwesV8v3qkuP2+PM2qTNWR0732sIcPmq4brvsEqyPWbL
         rkwEHwarCsWAj6iZG1i7A7OE/RF/woMgD7YdOwT8JEeM9vYvarm7HAg01SW7uEqzoRXu
         8osWk/1+hQ55e7KcljabyrM+Fol/NoMD2TtcIkub6sKptBxo8xEzn59c71Zdzcl8Lcf5
         4SKybVxGI05/xTnIPw+bOB4enk5cUSG/Nmy3c9drdozAJl9I9bGaykq7cAJoAKo688jE
         MwVQ==
X-Gm-Message-State: AOAM531c4tmFx6nh0tjqMQNp8FgoqvcPb7EJROqtVMGmGUEcxnMZ75k6
        XXaRrsUSP8jnjM0+uXPgpdXHsKFmvyyAQsjZw2Cbij3c9aDkUUjQOKxuBDgmd1eL9MBC5sI//kR
        mr/+JGUnKcAxJVtgIDbRmWi+BHqhKldboyNPXcppDQRwXRu1ivCIyokFrsXuDAu8fb7tf0Xnj4p
        2E4Srz6LXw
X-Google-Smtp-Source: ABdhPJy8uisA1yOwhcPpCof9imU8LvxHcfbOGayLx44WHMlMgI/sRzEgAlZty+JUfjMkElSVC3Lq9g==
X-Received: by 2002:a05:6a00:124d:b0:4ad:574d:4d2f with SMTP id u13-20020a056a00124d00b004ad574d4d2fmr164443pfi.24.1640009042897;
        Mon, 20 Dec 2021 06:04:02 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:02 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 01/25] mpi3mr: Add debug APIs based on logging_level bits
Date:   Mon, 20 Dec 2021 19:41:35 +0530
Message-Id: <20211220141159.16117-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000761a3105d3945c16"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000761a3105d3945c16
Content-Transfer-Encoding: 8bit

Add debug print functions which will print messages based
on logging_level bits enabled.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_debug.h | 133 +++++++++++++++++++++++------
 1 file changed, 109 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi3mr_debug.h
index c085bb0..cef61c5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
+++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
@@ -14,27 +14,20 @@
 /*
  * debug levels
  */
-#define MPI3_DEBUG			0x00000001
-#define MPI3_DEBUG_MSG_FRAME		0x00000002
-#define MPI3_DEBUG_SG			0x00000004
-#define MPI3_DEBUG_EVENTS		0x00000008
-#define MPI3_DEBUG_EVENT_WORK_TASK	0x00000010
-#define MPI3_DEBUG_INIT			0x00000020
-#define MPI3_DEBUG_EXIT			0x00000040
-#define MPI3_DEBUG_FAIL			0x00000080
-#define MPI3_DEBUG_TM			0x00000100
-#define MPI3_DEBUG_REPLY		0x00000200
-#define MPI3_DEBUG_HANDSHAKE		0x00000400
-#define MPI3_DEBUG_CONFIG		0x00000800
-#define MPI3_DEBUG_DL			0x00001000
-#define MPI3_DEBUG_RESET		0x00002000
-#define MPI3_DEBUG_SCSI			0x00004000
-#define MPI3_DEBUG_IOCTL		0x00008000
-#define MPI3_DEBUG_CSMISAS		0x00010000
-#define MPI3_DEBUG_SAS			0x00020000
-#define MPI3_DEBUG_TRANSPORT		0x00040000
-#define MPI3_DEBUG_TASK_SET_FULL	0x00080000
-#define MPI3_DEBUG_TRIGGER_DIAG		0x00200000
+
+#define MPI3_DEBUG_EVENT		0x00000001
+#define MPI3_DEBUG_EVENT_WORK_TASK	0x00000002
+#define MPI3_DEBUG_INIT		0x00000004
+#define MPI3_DEBUG_EXIT		0x00000008
+#define MPI3_DEBUG_TM			0x00000010
+#define MPI3_DEBUG_RESET		0x00000020
+#define MPI3_DEBUG_SCSI_ERROR		0x00000040
+#define MPI3_DEBUG_REPLY		0x00000080
+#define MPI3_DEBUG_IOCTL_ERROR		0x00008000
+#define MPI3_DEBUG_IOCTL_INFO		0x00010000
+#define MPI3_DEBUG_SCSI_INFO		0x00020000
+#define MPI3_DEBUG			0x01000000
+#define MPI3_DEBUG_SG			0x02000000
 
 
 /*
@@ -50,11 +43,103 @@
 #define ioc_info(ioc, fmt, ...) \
 	pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
 
+#define dprint(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_event_th(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_EVENT) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_event_bh(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_EVENT_WORK_TASK) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_init(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_INIT) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_exit(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_EXIT) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_tm(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_TM) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_reply(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_REPLY) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_reset(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_RESET) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_scsi_info(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_SCSI_INFO) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_scsi_err(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_SCSI_ERROR) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_scsi_command(ioc, SCMD, LOG_LEVEL) \
+	do { \
+		if (ioc->logging_level & LOG_LEVEL) \
+			scsi_print_command(SCMD); \
+	} while (0)
+
+
+#define dprint_ioctl_info(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_IOCTL_INFO) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
 
-#define dbgprint(IOC, FMT, ...) \
+#define dprint_ioctl_err(ioc, fmt, ...) \
 	do { \
-		if (IOC->logging_level & MPI3_DEBUG) \
-			pr_info("%s: " FMT, (IOC)->name, ##__VA_ARGS__); \
+		if (ioc->logging_level & MPI3_DEBUG_IOCTL_ERROR) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
 	} while (0)
 
 #endif /* MPT3SAS_DEBUG_H_INCLUDED */
+
+/**
+ * dprint_dump_req - print message frame contents
+ * @req: pointer to message frame
+ * @sz: number of dwords
+ */
+static inline void
+dprint_dump_req(void *req, int sz)
+{
+	int i;
+	__le32 *mfp = (__le32 *)req;
+
+	pr_info("request:\n\t");
+	for (i = 0; i < sz; i++) {
+		if (i && ((i % 8) == 0))
+			pr_info("\n\t");
+		pr_info("%08x ", le32_to_cpu(mfp[i]));
+	}
+	pr_info("\n");
+}
-- 
2.27.0


--000000000000761a3105d3945c16
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFXNoi6MSSLpUdqHD1Ld
vEQUEzI6BKqQ+IEw/JfwBLb5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCCQ+5p4fgvcds26Vez4uKIPiD+uORhea3C8AeM
NjcRt71p/oscXRw9GhZekZssBMmEs/GxxdKRvW6yx2FejdnUsRt08s4MrfUVPfn6q447CeHK21bo
DGyfp1kJ30wTK2Q23Bvcr1DocfyzWp7ZWTCIDFaYSfjwFsOn5YiKvCM6XkZUVmWPBkXCFFX3K+LV
TJfPEDJCA2iy78qG9PNGkhTh8hhw3jW/xU4SZpjquye+xrzHmZ/LkJPRzSj5kwbqyuPLXsABCAiP
eDVaPVW3jzBy25xZV5e0hFjPe4ddygX2CAJsHc3kTjT0TuS0ZRTwgUmPBnX0iUPLoeUaxY8i/Cng
--000000000000761a3105d3945c16--
