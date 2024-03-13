Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991BA125CF
	for <linux-scsi@vger.kernel.org>; Wed, 13 Mar 2024 10:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710324623; cv=none; b=fWPx20F1r3dWuiNvRuQJc/4UQyfqXVPRhR/gI6fVUTqjNBPa02Oyl3pEVo84DsHSd6JMifXoI2zXC8HyjD2snKe62xIKujMVEJBnbEQy9Y8egjaKkooiozwM1sgiVcplelG/WTKVc/aKfiRoDtZF/9/e/INbfnww5YtM56Hshlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710324623; c=relaxed/simple;
	bh=IC/z1jUnnRr250OdkJzUKaAZupN21kXqJ8YjuRBEvIA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=nnbyQsVhkglraTSVPryfaz4vzSfwSt/1dMN4I/4H7VBiUxE+XU0l4wt8JYbG+WixHo9yKg7BOfhXu22ziNogAip4GmfzuH0vB74W+oYFNX36sWTAppYU10qL/cvKXooiOzaNCmkJB5GblACnMctwV7pto6OdC1Jy7CPk25e8CAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gDxq+MVn; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gDxq+MVn"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6b54a28ebso665832b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 13 Mar 2024 03:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1710324620; x=1710929420; darn=vger.kernel.org;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M7IiDjLcLZmDwEQOp7MEMa0bJgdBiNqkxLvAXINa4Do=;
        b=gDxq+MVnFjVd1akwoKF+Vc2Uu39YhFcmXMVN5zYW8Cq3EWV9vd4cLNxdqbX5SnbsCS
         Tnmva56LNRGTT3gXPBw0mS3FaC8CvHS+mJ2lvuLiEpBQz0Iu3wIITxDMzs3Mbz0Rc0dM
         xy+RnzWh7ujFuMzg4xQWuA6mN9AU3TNJEGRcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710324620; x=1710929420;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M7IiDjLcLZmDwEQOp7MEMa0bJgdBiNqkxLvAXINa4Do=;
        b=oxuucPxDDVIjEBS3WrH5LGKhnaG2f1f3PRo+8EwgpekPLzbRGqAaKnYGjzVClmUNqp
         yA56xtsUR90lFRSV6kMZ3ZOzar6caw9OJgzO3QKO6fN5lRApT4Q45qhNOqzOJCb4AlRN
         s20Tgc9074vXDLjYi7r10ia4Lk5v4pVClyWNMN2lnOlLJs01sWGYhmtPWQx+0ixbtllI
         HjjPosx/Ydfs65U8YkozMqyV/vtJU7uoensWe1hjvFPKWufad361A0L5wGf/0tmMruyj
         OGJE0h0vzItxzn98NYTY7e+0lgVLc7MQ24YTy3lLdFoe5U84h9m1stYHYNEPCyxRijNX
         VUtg==
X-Gm-Message-State: AOJu0YykFwpvH9S19l0Fa6v6sV08ketm5KVHoASHYS+TKSq4IlcT1sNX
	Sq9dxk7PVq/26z37b3F7FUbopclkWEBIeSSwHyyBXlPspvcPuQLnSbNrTR3Ri+fSnpXXiJF7FOj
	8C3h2P9agCKmzeTkTPE4y3uyrRRaDbV+cKRHn7GER4o+NyeIPGAP1j7ZRsOmcHgRcoAs3FmW80E
	pMKu75AWrJWjhhnc7H/WhRkrd602TAwRjVg+0O/KKCqPlTww==
X-Google-Smtp-Source: AGHT+IGBnO05LijGvEdjM71KrGV3ZP9W9ClLOw5Y7D7fUK/WZbQ/zsnj0iyE7NDsp74chLvX69mbGg==
X-Received: by 2002:a05:6a00:cd3:b0:6e6:878b:fbc3 with SMTP id b19-20020a056a000cd300b006e6878bfbc3mr2600544pfv.32.1710324619792;
        Wed, 13 Mar 2024 03:10:19 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id j18-20020a056a00175200b006e5af565b1dsm7570337pfc.201.2024.03.13.03.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 03:10:17 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v4 0/7] mpi3mr: Few Enhancements and minor fixes
Date: Wed, 13 Mar 2024 15:37:39 +0530
Message-Id: <20240313100746.128951-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000722d4e061387fb54"

--000000000000722d4e061387fb54
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Few Enhancements and minor fixes of mpi3mr driver.

Changes since v3:
- Mistakenly ORING was left which is fixed.

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


--000000000000722d4e061387fb54
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIG+R/zwe7OHBbaYVbLhELc4cS8Ju2HJ4
2k92IgMzULTNMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMx
MzEwMTAyMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBSY0se1TiN4bAEFf/AhS22dvDU4T+uGd8l6Ym0X81woNXOmXRK
Nr+N8leQAzN37djWTbxrUjcIufvIKwBpjTrpYrlzr00lOby9uzuMUK9qNnJJB52mrO65XnX+RIQ0
J2D/6weJszXZu0/aafLnDDdFD2Y0CmiHuF5qRwatzolnsptMs9e87mg/oGw0ARYgd7HRgbJN47H/
fVJ4a0WlR9GkVUbQJ56YxBv5WcRYoMItTC2YBKjcSJdVLTzTqV9lVYMwBK+RtcGBW1tAiSDD+pKE
pv05aqHLErTPPaQVr3qP2k7sgLCDaJtpOHq7iYFtLCP805xDIiDMTYXCl7yqYF7i
--000000000000722d4e061387fb54--
