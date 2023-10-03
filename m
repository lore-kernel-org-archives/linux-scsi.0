Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53A7E7544B
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 11:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbjJCLAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbjJCLAF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 07:00:05 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CC3B0
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 04:00:00 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c60778a3bfso5925935ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 04:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1696330800; x=1696935600; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PCJjBG2EmioeBWHfRoQl576X1AejGlq+N1hbuWIMVJ4=;
        b=RHlmlB6ypMHBllHF4Oss054BFIfAlS3xYIIhCZRVJV3zlTl6bpfeMgbZJLMkCxR6zB
         Z2cXaiR1RHUBHS/WJ2cvDu1Khi1/uxWhKEnnNrira7+LLCejQs6IhSK1Cl3lIgG8FmYE
         Thh4mDdVmq+xAF3qxudNn6qSpri9tYMFU/f5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696330800; x=1696935600;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PCJjBG2EmioeBWHfRoQl576X1AejGlq+N1hbuWIMVJ4=;
        b=rqKhokZ2YRoeaqTVIeiARN92KxtfB3sOVssrOq/jwzwAY06NsG1EfCxxxa+QopwvZZ
         Pf4CNXwUJvVQuyd5s+J/aVK12enxNQHQ4Ipi5jmjsa2daNN9QJRKb32EoGBhwRH1bo7z
         iGo+wAFyaHmbmoQ5Va24hVjuboP2Ae1OZaexHZQR1KyvenDDWyMIZ6PhxkaTB0iFT5Yy
         RjQsH4HWUWOX7ISOpifzUhf0lDPhggp5av67bns6mFdl/otI2z33NJ+qNiWjiPqpe5Cg
         5NAcg5U85X/FQyW1tYgWl54V8tF+YM5I/20e2ruf/Yee25mqeizmh/wQLrWMCwV4401v
         CY1w==
X-Gm-Message-State: AOJu0Yzw4Qsy4dk6Rrg3B5/36pkwxxoqLtQM+o/C+mZ/mQJV53z08eFs
        er69651DqGCv4qs3G+LwyGTZSD1vHpBbLsIrmaiQEovtvkFU6Ja4VdKZF3M7PjdX7ekSsLuA+T1
        Xx4H1aeYjwLBa/jQKoPEIu6o4SEGdN/40QsKhP3VVEoIfxWMHdNssOPTsAXKGvyMHyIOecreZhx
        Fn4clpWRE5paAdXRSS2ChQ
X-Google-Smtp-Source: AGHT+IHUjH/dr4FxjIBVlmAqJekrdPXAMrWuoFNhrCJZX5LAnAiw5cqz4HQPCqxOXHNaTZfkfsbhfg==
X-Received: by 2002:a17:903:428b:b0:1b8:2c6f:3248 with SMTP id ju11-20020a170903428b00b001b82c6f3248mr13995588plb.39.1696330799804;
        Tue, 03 Oct 2023 03:59:59 -0700 (PDT)
Received: from dhcp-10-123-20-35.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b001bc6e6069a6sm1211909plh.122.2023.10.03.03.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 03:59:58 -0700 (PDT)
From:   Chandrakanth patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com
Cc:     Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] megaraid_sas: Increase register read retry rount from 3 to 30 for selected registers
Date:   Tue,  3 Oct 2023 16:30:18 +0530
Message-Id: <20231003110021.168862-2-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231003110021.168862-1-chandrakanth.patil@broadcom.com>
References: <20231003110021.168862-1-chandrakanth.patil@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c47f060606cdca4f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c47f060606cdca4f
Content-Transfer-Encoding: 8bit

In BMC environments with concurrent access to multiple registers, certain
registers occasionally yield a value of 0 even after 3 retries due to
hardware errata. As a fix, we have extended the retry count from 3 to 30.

The same errata applies to the mpt3sas driver, and a similar patch has
been accepted. Please find more details in the mpt3sas patch reference
link.

Link: https://lore.kernel.org/r/20230829090020.5417-2-ranjan.kumar@broadcom.com
Fixes: 272652fcbf1a ("scsi: megaraid_sas: add retry logic in megasas_readl")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e1aa667dae66..3d4f13da1ae8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -263,13 +263,13 @@ u32 megasas_readl(struct megasas_instance *instance,
 	 * Fusion registers could intermittently return all zeroes.
 	 * This behavior is transient in nature and subsequent reads will
 	 * return valid value. As a workaround in driver, retry readl for
-	 * upto three times until a non-zero value is read.
+	 * up to thirty times until a non-zero value is read.
 	 */
 	if (instance->adapter_type == AERO_SERIES) {
 		do {
 			ret_val = readl(addr);
 			i++;
-		} while (ret_val == 0 && i < 3);
+		} while (ret_val == 0 && i < 30);
 		return ret_val;
 	} else {
 		return readl(addr);
-- 
2.39.3


--000000000000c47f060606cdca4f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQfwYJKoZIhvcNAQcCoIIQcDCCEGwCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3WMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
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
XzCCBV4wggRGoAMCAQICDEdtED9Zj45VgZuf5zANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwOTM0MzhaFw0yNTA5MTAwOTM0MzhaMIGa
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGzAZBgNVBAMTEkNoYW5kcmFrYW50aCBQYXRpbDEuMCwGCSqG
SIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAOPMhBafUXswA97gXTj1d5WoUBuCuq3xszdg5lAM1AHavwkVYXn9nKUH
7QgAR6GV/PyPyloLcAeIkTarJRpxB885+xOyR4EAA8zRk9mirwq7GotMjSmRA81Ne5tpqZObHbsv
ELVogt2xoFkQFwDZznRDVQ1RRWO8gLU/7clg4TWqNxSsRF7PfM2U1sk6If8qHVMdtHLukGibl0Tv
4SxjDQ1M8uqWXeJcdYM4lQc+PSKyTNqPy/KLt1enu6lmA236FXBhPFSg3+EeZ9Ma7ZMj++uMpnwz
jLZb2F4wVMfuh/ZTi4ty6G3wQ/OIFcK4EkaKubAqreTT+LEu5XOFi10KHncCAwEAAaOCAeAwggHc
MA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
dDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFs
c2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+
oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
tI7aNGRrv6gHqOPkFli9EdvR2xcwDQYJKoZIhvcNAQELBQADggEBAI0Px1+MF4ubFWlBurQFxZRv
/K8V2fysp6NhKRpdJ43KozsApD438TU9DdNe8wW1MrCV3sRXZhlEkkukkfppzYRuoemmIdd4Rajh
Dh+uglOx3CYSKKOEWSbVIaDVMBQvVtqfZlGJgLRmLpO2agb8V/eY85IoMoM9hJkTll7OoTo+Lhon
W2v5XKnfV6+4iODhAb65bwLbcNq6dxzr1Yy/fGnIBfoR2qrX9UBDDxjZRpxJGdt7i0CcvsX7p2ia
SgP+hUBq9GTgLiFqCGyh/gCm2DTB/TyYel0QsIP29qWC1F5mG+GOoSjagi/2SxnNI6LzK+4xfgvc
80IlL0UapzuyZFExggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgxHbRA/WY+OVYGbn+cwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMooJH1a
aIhMvMYZ22Hf49yP/7vOxTGWytwapdP73MqkMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMTAwMzExMDAwMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBus6YUOumwI06YvROBHJs5pT/0
m3OQv3Ozjdkn5b4pIUIGqYlLERca8MkXcqArsGKhFvqLt5vkocZK1Xf6g40ps2SRqDhzw62xr4Hc
qe3RalBp79EUNW28XsqgKg8sFi4VqAWEx8q3hfZvChELUAFzQ3zGfrhwmIQw45dU0McJhIqr9Wk+
uY9m1642EAvuFEsUFsn9dVboSgpw8bCspjh9HXYLwF3niSkEooxTv4wAmbMI6U7Y0NrMb5559tQI
nRh2cUbdAq3br6k+Poo4Ayjv81oyqkrN8iz0KXsRpiduCBqRjeVSH+WMl12s2lZWfpSD4ZKkPq8X
O0HY/RE8aUwT
--000000000000c47f060606cdca4f--
