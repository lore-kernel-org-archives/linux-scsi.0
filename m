Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F20615FCE7
	for <linux-scsi@vger.kernel.org>; Tue, 14 May 2024 14:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715697117; cv=none; b=OtUnBgAAaQkWrJZ5O4dPEZrkcF7ByDVLz4Q5b8yGa009LIsNPdhzdp7O3DqoJLJNZeLhWrIuNA0bdnMkIzMRcBHKuOYgGmeXVZzZ3cmsKw4zobdifFYylfMrCD3pI1CmeY+M14Noi5m6LSwlEXjb3qFjM5Pg04++hQBbKW+t4fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715697117; c=relaxed/simple;
	bh=fE4e3WKe8MF5hoCpvL28TMOFXk3YjvasogS8BOKoNBU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=B+unBX3ScKVPKwSmSag+XREssJUlHBVO2spoy4j/UpllNgQGORPlDfYzq1lpzQOjpmzmhOszV2mzeFZ1wwQ1eGkdTvxSxqcRAtnZ3aUFT8gzqeYSROzxvkLm1N9gDCQn2R8G/ArWjUosAOa99HH1FXXYhRHn2aymjKndF4nP6zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JLOerwAq; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JLOerwAq"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6f4e59081e6so2956106b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 May 2024 07:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1715697115; x=1716301915; darn=vger.kernel.org;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tBZTCYx1Tp12pnpldz1GJb6ZxDfYMwNbhnzhn81OyTw=;
        b=JLOerwAqOoJC9LESzisYa7oYr2y8GJi8bU1SRdSjmoO9EJyv0itW72XuXjdQ51mqaT
         rKiRouic/1bL7sVCcinMAum660N6KHVZ0VXCr+VGNtk9yhC5LkG1aYikPyeclLmsz0mw
         cUhNkJlRFrZ6rGrF7w8PEDJJWWR2cGI7UERaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715697115; x=1716301915;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tBZTCYx1Tp12pnpldz1GJb6ZxDfYMwNbhnzhn81OyTw=;
        b=iypK3Rv3cfuj7eBVPJby4ry1PWBpnjWlNujJ2uOtmY9/rDEV+pfZWR7VCvJ4zPgW3O
         p9uuEHICZMSAXEfU2Kt+CHMbBMjsOCr8XF+km7/AF9uUJobn3FVj8Awm3td/PhdfX1JB
         G61/wklzffeaH6Bto+ioZCyOvFDX3u+d7oU0eoblHqSuYWuzyh9VD7uYsaSIqvodpTox
         Vlxjf9lZOKypOHGyKuV/BCVh+BEN9YAAXp3Ufb3ajtInuAnWCLBbU2GSNKwiyK3uPqdw
         F/tUf+RN1Ii4HlcpM8MMk3XcN0+1mOdG0A05Nm2924yjPMzgz0vU8gXWIPBCuWDp78kG
         wEIQ==
X-Gm-Message-State: AOJu0Yz2R3gH1GafvNQtKVnX9ez7fOVShQuI4bg1Hh8ldePhgeJoOTeD
	MBEE1d9GmGgZlDCrrNcKXUcyzl52CaTV73k40OJ9je+OYirmstkeHZYZ4LgzvVSsYBEQjTR8ViJ
	Mv3UzFPSvQJLyRatlQgXDPN1gMMSCjSxhZ9n8fwrDzIr8ysd0UwCsS5mbFLMWviAtylYr6G9b0j
	aK+/1KAJ0vXdh5cl+i+KKFj+6Tp1MNG4pXDigyWGs0DVvywA==
X-Google-Smtp-Source: AGHT+IEuFMAwrYkH2je/EplUp6tX3U3E3KoTO5HQVBdqlTuFKTZ9gkd4FPNteKneDxLZdIdn5OWgAA==
X-Received: by 2002:a05:6a20:2d2a:b0:1af:f2c5:118a with SMTP id adf61e73a8af0-1aff2c51408mr7396141637.61.1715697114429;
        Tue, 14 May 2024 07:31:54 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-63560731046sm7849104a12.67.2024.05.14.07.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 07:31:52 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/6] mpi3mr: Host diag buffer support
Date: Tue, 14 May 2024 19:58:52 +0530
Message-Id: <20240514142858.51992-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000015c67706186add2b"

--00000000000015c67706186add2b
Content-Transfer-Encoding: 8bit

The controllers managed by mpi3mr driver requires system memory to
save hardware and firmware diagnostic information, this patch set
enhances the drivers to provide host memory to the controller for
diagnostic information.  This patch set also provides driver changes
to push kernel messages into the diagnostic buffers reserved for the
driver, so that the information will be available as part of debug
data fetched from the controller.  In addition, support for
configuring automatic diagnostic information is added in the driver.

Ranjan Kumar (6):
  mpi3mr: HDB allocation and posting for hardware and Firmware buffers
  mpi3mr: Driver buffer allocation and posting
  mpi3mr: Dump driver and dmesg logs into driver diag buffer
  mpi3mr: Trigger support
  mpi3mr: Ioctl support for HDB
  mpi3mr: Update driver version to 8.9.1.0.50

 drivers/scsi/mpi3mr/mpi/mpi30_tool.h |   59 ++
 drivers/scsi/mpi3mr/mpi3mr.h         |  162 +++-
 drivers/scsi/mpi3mr/mpi3mr_app.c     | 1078 ++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c      |  552 ++++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c      |  113 +++
 include/uapi/scsi/scsi_bsg_mpi3mr.h  |    3 +-
 6 files changed, 1956 insertions(+), 11 deletions(-)
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_tool.h

-- 
2.31.1


--00000000000015c67706186add2b
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKi9YT0ZnWZnJrYGKttJlcTXN+AAT8I6
YdgMxcO8ValOMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDUx
NDE0MzE1NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBL+pJ6FGvIR8UTs9ZlfwcQCAyxoNovz2QcWmV8NeQ+uORFdWgK
7NIy7+ZyralLb5ZhDsuOxj9ApfnLAuHFBVB2JvVkAlPD0rNkTQdhEt3Vbte2Q4x+wR9vAxdkJnZC
K/NJpqd4tWmqB6TcpYB5OdLuzzZ5ZkWwjYo5qChYlETQ1nfElNuHOS3zY1h/rgNTmh8tHbvDpHw9
/1Xm5PgjF9nZ31lxWMULq3bO+1RVngShtxmieNyIC0LZLEnThLNj8xBMDA/smWrnOLM5vrQHbOzi
l9nLps1kNXtTbl+oCmrj9hpIrdDxElAK4FzcGEmzQUpGIvx0eIOzvsZzeXhhdm/c
--00000000000015c67706186add2b--
