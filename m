Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE3FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 12:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiCVMXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 08:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiCVMXk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 08:23:40 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F2185952
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 05:22:11 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x2so1771911plm.7
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 05:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=D5RImeLHIqIE8z+kAhAEPG2Wa79Ke4rURZopgrpZ5Lk=;
        b=BSi3HloJ0thzK/uQWt1Ta+KfjTLbtdTiv1ldsV59m62XZA+qved4V1jqBTWIJdpZl0
         x15vkQjIjFfCjktC8jTgPN/rEitBUle1PhULRBhQ37Per0DszhmmbumONkD8SgwGgJ4t
         M4uh2VO4fIQwtSh/7a24lJ3D1IOpXEDQR9FNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=D5RImeLHIqIE8z+kAhAEPG2Wa79Ke4rURZopgrpZ5Lk=;
        b=vzsqW5A4kveIpSE68M2gcJr5H12HuXCKPr6xqZj1cB5a+KEDIAkG5XUd9winIn8ak/
         ZSgHNiK+L81qfu989T5+3nyp/3sUWlR0m933fQkGE0toX3BbWgIQSi8l3524mnHsJFoz
         t0o2YoD8/qJcKI6alupkHcBi5BzFI0NCdAajvC2uaYjxr2jt9A5a4/4OGVDOZwi5/8y6
         6KCpRDwqvHGMcPhSLvD28XmZ2ASQVcffegLFycVfjgB1d2V+y3wWp1+F1WHz7fm1efdG
         zAorN+IpHNdzpQQJ5Xdu+ocQb3brJPQCJ2FVN87UIQfQ04Xgsl+8KbPPSDB2HjGpzO/0
         vODQ==
X-Gm-Message-State: AOAM533CSFby5GNvb3JfJlf3bqu7AJrjJ66nx0TRhzNKvvIXZxE5dJgp
        LFWJpPbVQwKsdyDt2UFqXRquTryuHrK3uZ7UxT14xXrSTqTAzJUwi4YsA1T0zLNeBYgTYjaP1T2
        3sfDmOoevE2kd5CHF1sFigLar6/JJs3sYoEzwv91bEvv+REq9L8OMCqY8lzKgTHIUhvOTDekVCI
        rL1T6MN+HryQ==
X-Google-Smtp-Source: ABdhPJwe821sjrmT+RH9NGuLSWBEW6FX8eW6H1v1KqlgPIxPl0ORQYebC1CYYHLWo+B0bU7OGFy/lQ==
X-Received: by 2002:a17:902:f701:b0:14d:7cea:82af with SMTP id h1-20020a170902f70100b0014d7cea82afmr17595792plo.71.1647951730252;
        Tue, 22 Mar 2022 05:22:10 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d11-20020a056a0010cb00b004e1b76b09c0sm23225259pfu.74.2022.03.22.05.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 05:22:09 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 7/7] mpi3mr: update driver version to 8.0.0.69.0
Date:   Tue, 22 Mar 2022 08:21:07 -0400
Message-Id: <20220322122107.8482-8-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220322122107.8482-1-sumit.saxena@broadcom.com>
References: <20220322122107.8482-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000840ee905dacda92f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000840ee905dacda92f
Content-Transfer-Encoding: 8bit

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 22426f71c720..354337ad2169 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -54,8 +54,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.0.0.68.0"
-#define MPI3MR_DRIVER_RELDATE	"10-February-2022"
+#define MPI3MR_DRIVER_VERSION	"8.0.0.69.0"
+#define MPI3MR_DRIVER_RELDATE	"16-March-2022"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.27.0


--000000000000840ee905dacda92f
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
XzCCBUwwggQ0oAMCAQICDChBOkGaEPGP0mg3WjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMzAxMzJaFw0yMjA5MTUxMTUxMTRaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFN1bWl0IFNheGVuYTEoMCYGCSqGSIb3DQEJ
ARYZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAOF5aZbhKAGhO2KcMnxG7J5OqnrzKx30t4wT0WY/866w1NOgOCYXWCq6tm3cBUYkGV+47kUL
uSdVPhzDNe/yMoEuqDK9c7h2/xwLHYj8VInnXa5m9xvuldXZYQBiJx2goa6RRRmTNKesy+u5W/CN
hhy3/qf36UTobP4BfBsV7cnRZyGN2TYljb0nU60przTERky6gYtJ7LeUe00UNOduEeGcXFLAC+//
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEXDujYUnZeuZUfOubvhB+2VEQWwsMsq
H+4uiGXz6KNeMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MjEyMjIxMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCKSMq8Yp+KeJnfSBXwYxyw4gM8bK+U7hnmsa+GfDo6KaI0lp+f
6Dx0haYVJN7EnuUozyfpM0h2tjJ5mlJonMW3XRX85JfSXJUQwn62YbYEjpnpYJxmxqS+09dX0TRu
yQe0HgwTpzKJ5yo31Ehha6xPNQEYGSh8mCseRYmDg9E4YZD6JxkYK+lVCaRAe3L7g2AODdJM3+5V
SLeQo0pF1tXmVkJIRgR7BgG3p/v0uJesbrkibQjCSCwnqA4tjk+pEYlhibTAo4vEu8YaKHIjRqAQ
25mB/0myvGmOdaWUXPu009+gzQZAqJPbmozPsh4GeAe8uxU9KvRtgW8KCDRlVYpB
--000000000000840ee905dacda92f--
