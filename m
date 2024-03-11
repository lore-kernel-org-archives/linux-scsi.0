Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15D229CEB
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 11:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710157061; cv=none; b=VfL+bM1SwSoT4/oPXdcTmRD7uc3Ux7l8+f5buzGnA4xwsou5wg/WTDqyu0R13RAia8D/SlTvA04IT27dQ4aqFPjCBgikq+vlkEODx4+YgzxbMDwDVXHkb5hz5clJXmM/vTDhyYUlwZLO0nSUWS/dl4U1sWk7Hj9YqrBS+VP5sRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710157061; c=relaxed/simple;
	bh=H9pSwvg9/SE8kuIEbsgU4B4P6A3BKVjuUA7loNdA/zY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=seELLSxs2xEksjDxM+t/84Dd0xB3qbwBKqpH5vq0i935HnsI91OrQuHeLt6b1IAb1ByPq32RKOeVkLd5n0maM6X2vzyd1qF+9KtT5lxig1R0Xce5RbCpt3M1DZ9PlLcnJBJlIuA3wpBQauOyfmEQ3FdoC0AHuDoo7uNxnq72yqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=E6CfLmcR; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="E6CfLmcR"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-29a2d0f69a6so2831733a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 04:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1710157058; x=1710761858; darn=vger.kernel.org;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V5/0YUNoPnHYqjxAVoJuw2kEXGZ4ggTUFDhMVmNNxtM=;
        b=E6CfLmcR/62TBXC9HzIQsp2AD+jvUKwdnchlfDN2GzWdGccjUoEIS2w7UElyPWOrxm
         3VZqOwSMODZZePWN7jEARdFuqgYm6LGnKAONmqOXCkRw0+fpZO+Ym6TBnHq4m2IbCMoz
         JjG517Ku5JshgqU192FIFVao1+RhQimDtVcNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710157058; x=1710761858;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V5/0YUNoPnHYqjxAVoJuw2kEXGZ4ggTUFDhMVmNNxtM=;
        b=ol9dm48sacSdISkH9kNQUISaFrjldS/zqDfK1P9mn2uZI4S1zOpjFsFHaDVCWo1ucQ
         EnChetYN5M9AMpIKj4yfOXNKe0mlBRUc6KDYl4ixN646fOdzYwzhenUaY6kid9CSBgRY
         qDfCT967jf/h1g+iq8B0yOYeWTC60Pe0oHmaEWpT98co4s5Qp6iqScOQTcm0pOAoLPGm
         WdJOpDJQ79bOiCGUd1UUGFtUsUfIFYhaW8M0O2tUmChJbXi6EjjCo6s1LIasgde0mVCO
         IMPRTDzG+bHU2TM/PHU1Q/1E982DwCtvOpmpowP2K6kTpvUL6jnzxbx2sbqaPhdZ6hdw
         E+tw==
X-Gm-Message-State: AOJu0Yxvct9YNgLOGpVdCXN+NuTap0oBTv7Tj96KVoxDE0Gg+M60qZwp
	wK++wIuszhHygVTJtPolujiOTZ55+XMujQB577s0gDoiV4QU/x0bZWmArbF4O9PCc2z1P30nI8e
	pgeEamVce6/y8bWoZDio4e8UW6mUD/kZGy+6LrGzPsMy0ynEVY85CCMrswrk7rLbQmWU4eXPVEm
	LtSvmJl0tywX9yk8F1Z5z5mkfnamyWi2XAFB/sEdmH3SRBYA==
X-Google-Smtp-Source: AGHT+IExHb6tYUwQ79aEPpot1zxRAH3UEfdENuKj2ReV1ZcBWf5np39ToRxvggaI3BMh21BImZtRfg==
X-Received: by 2002:a17:90a:b011:b0:299:2cba:7588 with SMTP id x17-20020a17090ab01100b002992cba7588mr4868862pjq.1.1710157058290;
        Mon, 11 Mar 2024 04:37:38 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id ay3-20020a17090b030300b0029ba5f434a8sm3982655pjb.26.2024.03.11.04.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 04:37:36 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v3 0/7] mpi3mr: Few Enhancements and minor fixes
Date: Mon, 11 Mar 2024 17:05:07 +0530
Message-Id: <20240311113514.108795-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000018334061360f869"

--000000000000018334061360f869
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Few Enhancements and minor fixes of mpi3mr driver.

Changes since v2:
- Fixed test robot build warnings

Changes since v1:
- Updated Function name to mpi3mr_refresh_tgtdevs and
changed logical condition
- Updated the patch headline .
- Reverted the SCSIIOSTATUSREPLY change as it was
unintentionally removed.

Ranjan Kumar (7):
  mpi3mr: Block devices are not removed from OS even vd's are offlined
  mpi3mr: Set MPI request flags appropriately
  mpi3mr: Clear controller-wide flag that is used to  block IOCTLS for
    the unresponsive controller
  mpi3mr: Set the WriteSame Divert Capability in the IOCInit MPI Request
  mpi3mr: Debug ability improvements
  mpi3mr: Update MPI Headers to revision 31
  mpi3mr: driver version upgrade to 8.8.1.0.50

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  3 +++
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     | 20 ++++----------
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 20 ++++++++------
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  2 +-
 drivers/scsi/mpi3mr/mpi3mr.h              | 16 +++++++-----
 drivers/scsi/mpi3mr/mpi3mr_app.c          | 21 ++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 32 +++++++++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 12 ++++-----
 8 files changed, 72 insertions(+), 54 deletions(-)

-- 
2.31.1


--000000000000018334061360f869
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDkqbVBih9mFP1/X53ohykaeMMMa7FK9
9QELBl0PJUNRMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMx
MTExMzczOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAyo+UXlJng9/qnmjHxq/26tGstMwh0IjwLiuqV0lTwBEn5QuXm
A5iPUgVmtNwLhZpHz0/WpbVvkZwZcEow4uLLwyS2ZoyFBoHR0fqdzAuwp/6FFmgk8RXz4RbIT0Ts
sg9Q2/hMi6kXNpbLtJdOpkha9TY5pz9/eSA2hqtimV0+URWCD05SIaHhmd5E+NRAahMpviE7J9jg
ogdfiX0Yr7sSPgIkzB1L04aTs0Tvpr5Q+xCeGmwae2JFgPrLqiHqo/UeJqqprA3h2qk4QOFFAAcd
nfO3/ZrBRxNQm8yjusWpMwpatb4nzJCy2oIkx9YS8fYURPraWkR08mfkvaQSkexl
--000000000000018334061360f869--
