Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D40C61DA3
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 14:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjBXOoA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 09:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjBXOn5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 09:43:57 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846D6168A0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 06:43:51 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id oe18-20020a17090b395200b00236a0d55d3aso2925406pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 06:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EBfCV3N4cxaP2EY+iAGA4R7mNsxrOc/qVawXppIRS/8=;
        b=hej9eYlvFmDPO8RwHXnwBsuIjkofpw9A+GmhQV131NjLCQg2iAWA84GjG5skDEbB1O
         uJWJ7T5Kj0uSo1RvseEZ91AluoNgEVlmJyNOjJcnoD5lhR9oIR/rRVtm73GYA6xitia/
         4Z3Um5dUFQ+7Y0PBT7SDQ6803ZgWWnP5nVaPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EBfCV3N4cxaP2EY+iAGA4R7mNsxrOc/qVawXppIRS/8=;
        b=XqiLRSCCc5D5q6DI0MfMoYemV5a7+eIPm0rLryFSx6XTbssuARNfaDeaQ4+yN3KCbK
         nnoVSd+s2dMSvxoyV1219B1TXzLzMaGErVjtcbzaDgYuvnPMF9IzJvdMhfKKrpZ+Aq7+
         cpYLZPKwwuKbPN4wSa9ycN7a8srNQTOZ1hIvC0lvhRFZkxmIv8lhZlenhWeyxXEJ9QZ0
         SzSULir7zOn3q5sNWNqLaMYswNOA6Hfdsk2nZnNkGYhHsjgHuesOcmEmplRPgAO0prfP
         +Q4tNih1LsvYXalEKBF3Wedg0NFX/G8oyuwHImJ14fXo0EN31QDECMz6Dv/vxBXGMkq7
         E9lw==
X-Gm-Message-State: AO0yUKXD3mu/Ldsg3IcCQ1EZkX6D4KVr9k58hF/YInmam84FoHZixz58
        1RqYluekOGnyB95WHVF6cxf65SYMHg4ps9qtBIxInQh6i8pb8fn9KYDFJNuktQYJ1HQNdFArQTQ
        kvh86QRT3rr6QdE0FXpv6zt1N27q2CYt9Lvp3DT5HYrary4W7+XpMjGIhjGMRjSRV5p74cWmVnq
        r32rdL5tU=
X-Google-Smtp-Source: AK7set+2Ectv2jziuwo0rgByhwIglLrTNfBD+YqGY0QZWOyt9mtvwWtr04FpTTLZqLUZcdvYxzQCcQ==
X-Received: by 2002:a17:902:fb4f:b0:19c:d49f:4296 with SMTP id lf15-20020a170902fb4f00b0019cd49f4296mr2017990plb.67.1677249830659;
        Fri, 24 Feb 2023 06:43:50 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902a9c500b00186748fe6ccsm8911549plr.214.2023.02.24.06.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 06:43:50 -0800 (PST)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH 00/15] mpi3mr: Few Enhancements and minor fixes
Date:   Fri, 24 Feb 2023 06:43:05 -0800
Message-Id: <20230224144320.10601-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006248eb05f57328d6"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000006248eb05f57328d6
Content-Transfer-Encoding: 8bit

Few Enhancements and minor fixes of mpi3mr driver.

Ranjan Kumar (15):
  mpi3mr: Support for Clean device removal of drives
  mpi3mr: Modified MUR timeout value to 120 seconds
  mpi3mr: Avoid escalating to higher level reset when target is removed
  mpi3mr: Updated MPI Headers to revision 27
  mpi3mr: Fixed the W=1 compilation warnings
  mpi3mr: updated copyright year
  mpi3mr: IOCTL timeout when disable/enable Interpt
  mpi3mr: Driver unload crash host when enhanced logging is enabled
  mpi3mr: Wait for diagnostic save during controller init
  mpi3mr: appropriate return values for failures in firmware init path
  mpi3mr: Successive VD delete and add causes FW Fault
  mpi3mr: NVMe commands size greater than 8K fails
  mpi3mr: Bad drive in topology results kernel crash
  mpi3mr: fix admin queues memory leak upon soft reset
  mpi3mr: Update driver version to 8.4.1.0.0

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 112 +++++++++++++++++++---
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  23 ++++-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |   6 +-
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   4 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  18 +++-
 drivers/scsi/mpi3mr/mpi3mr_app.c          |   9 +-
 drivers/scsi/mpi3mr/mpi3mr_debug.h        |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           |  49 ++++++++--
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  79 +++++++++++----
 drivers/scsi/mpi3mr/mpi3mr_transport.c    |  17 ++--
 13 files changed, 260 insertions(+), 65 deletions(-)

-- 
2.31.1


--0000000000006248eb05f57328d6
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINBGK56l88f63lBMU/PuEq09WSDDoHdE
yIu8gfx+OvcmMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDIy
NDE0NDM1MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAI8cogCuyjNIdkq1lclt/SFDUtFXPz3IvIo4daBqFUEtxLHy4r
0N3o8g4qZ1bhLOwAi2BWgzqDyUrExj/AyRmh85jyrsq5tdYAu3bcrrEOzC7oCg3n9fW6cwgOxMht
+qD3qVLWm+Bp7xKRxopGvHWYuTv+fV8ggEsFDNm5XEb8tvFiqTsw2KoI1nDCHVCp0Hwu0Ysx6o6c
/PUCkzO8veEhGBEhf7QZVc5TeKcMRAxwIFV9xWhppTXLOOkzSGMrGgmtLtkCGA62V39ZHPuplxRw
6jcL6S91nTlKmXbydmdYaZWc2a4HdYTCOy+kvYyo2qZ2hffqi0PFLDm3oBl2Jswf
--0000000000006248eb05f57328d6--
