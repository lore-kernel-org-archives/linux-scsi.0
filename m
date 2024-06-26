Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048F717C7B5
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719397800; cv=none; b=tq8Cqgfmgd9sQp9H6MLLFryvi76KignEeI0EjUFIsTAi2kPCNRnoNhMkdq7HA25tnnJfFfy+oK/eUIh82uhZlQcDixsBRbvRasQqeLRQd4LQ6KWOAjC/CvfB3+SaiKyATe45w8rfxtxPoE3moIqsvzCKgpryB1sHbBPcNXPPc2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719397800; c=relaxed/simple;
	bh=mgsm7kXRqjRIguRMoCNYZNYpBZLRZAOPFZ7XwFjCElU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=LIZ4g0ztw/Iq25RUWiAKm8uLiENJwlTys0lYKkrkV3d2kB187vjPwI1u28fYD0W6A4dl5Ht4Kmrcp3d+xsLfXSyHvbLH5Le2jDfh6JAoyqZNtkJhlHNEK+ZFxfMxoerudTtI8nMPdwT+XDYFiLQSRV1bIT41OXV+sD9n1PcOjic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=IGhnkPzY; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IGhnkPzY"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fa55dbf2e7so22256915ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1719397797; x=1720002597; darn=vger.kernel.org;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bf0ybjL5v1jrq+gt5llK4hSogqhZSWKr6CL6luZ8US4=;
        b=IGhnkPzYQT+kATgkIjXNXwgT1dNhgIm2Fa9FETUYv6/3gvni9OhTOZRqH7OA0F294E
         KrzvQP0KuOuftZeicp/GQtXx5Ke/PeRtEZXaj09XZw3CLOjKhbkk+SnWmPsxYOaLsRL0
         IrrCze4xlzbtw5wmsn3dH3r3ptsyLigy3xO9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719397797; x=1720002597;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bf0ybjL5v1jrq+gt5llK4hSogqhZSWKr6CL6luZ8US4=;
        b=pAuuC2GK4q8FcOPdknDzmBncT7mnsPDekD6C2q7FkBGhusbUDWu7S4jb2ifyH3lqsp
         0n2SUzSIsuHb43N5npKSksaKWtisvYF4J0g88Oqvh5x5bvToFFHLHUw2U3WWypVVsQ9R
         +hpR5zwEoaESO8KM8f3PIy7l+n6rsGm526D+VUaKAbGUgD64zcbu9xXWHrxBCcnReUZs
         DaXDDslpi6mV5syt02md4gT/ZI1Ns3xbW6w4AJiU/aIKtGD5qBhMUviDFa7zHACVPIKP
         6hpY9myOUW63YixHktMxKiuw345SwFuGDBefiWg7G7aTW5DmDjM+ESncKbd/3junU7sX
         9KVQ==
X-Gm-Message-State: AOJu0Yw3kEJcKf9j6mr1klExdRFgWsSJIL7fEoFpBySfiauSu6pLWJTV
	gWBjOBvugu7pkYW3qoClePHHDsdmaUwB6FaFj6k6sE59+rCBeyY1TFZss32jIN4tMA3RJuegDL4
	GUCJZQhr8fh+7NYrSxtGDyzl3DIorbq07Bzcr4nqXe/ybZVCg7mhaivxglFraql1JkoVVOCxWHU
	YV8esZ0+HVz5xgEke17nkVZw4qM6JugEvLQaSt66SHROW2GA==
X-Google-Smtp-Source: AGHT+IHIL5I8z3zcHAKNuuTqJ1ZBkzLNJic+OVmQMQRB3pO+jCbMyr51UbnYBYtmrUD5XejFaPTpPQ==
X-Received: by 2002:a17:902:ea08:b0:1f9:c52f:d9b5 with SMTP id d9443c01a7336-1fa15944ecbmr127315845ad.66.1719397797128;
        Wed, 26 Jun 2024 03:29:57 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9ebbc7ccasm96051055ad.299.2024.06.26.03.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:29:55 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v6 0/4] mpi3mr: Host diag buffer support
Date: Wed, 26 Jun 2024 15:56:42 +0530
Message-Id: <20240626102646.14298-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f5f63e061bc87e41"

--000000000000f5f63e061bc87e41
Content-Transfer-Encoding: 8bit

The controllers managed by mpi3mr driver requires system memory to
save hardware and firmware diagnostic information, this patch set
enhances the drivers to provide host memory to the controller for
diagnostic information.  This patch set also provides driver changes
to push kernel messages into the diagnostic buffers reserved for the
driver, so that the information will be available as part of debug
data fetched from the controller.  In addition, support for
configuring automatic diagnostic information is added in the driver.

Change since v1:
- Fixed test robot build warnings

Change since v2:
- Fixed test robot build warnings

Change since v3:
- Dropped mpi3mr-Dump-driver-and-dmesg-logs-into-driver-dia.patch based
  on Martin Petersen comment

Change since v4:
- Dropped mpi3mr-Driver-buffer-allocation-and-posting.patch

Change since v5:
- Updated Patch description 

Ranjan Kumar (4):
  mpi3mr: HDB allocation and posting for hardware and Firmware buffers
  mpi3mr: Trigger support
  mpi3mr: Ioctl support for HDB
  mpi3mr: Update driver version to 8.9.1.0.50


Ranjan Kumar (4):
  mpi3mr: HDB allocation and posting for hardware and Firmware buffers
  mpi3mr: Trigger support
  mpi3mr: ioctl support for HDB
  mpi3mr: Update driver version to 8.9.1.0.50

 drivers/scsi/mpi3mr/mpi/mpi30_tool.h |   44 ++
 drivers/scsi/mpi3mr/mpi3mr.h         |  133 +++-
 drivers/scsi/mpi3mr/mpi3mr_app.c     | 1080 ++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c      |  272 ++++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c      |  113 +++
 include/uapi/scsi/scsi_bsg_mpi3mr.h  |    3 +-
 6 files changed, 1634 insertions(+), 11 deletions(-)
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_tool.h

-- 
2.31.1


--000000000000f5f63e061bc87e41
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILTf2+KafXP9JFJiEnh9OQJ3C4NWUcAX
YeYWVyuqLjFZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDYy
NjEwMjk1N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBi2iPqbYg+aq7q9ADk344bKYNkb0rw6xQWiAkeolCA0t75OGOW
aA+0tNm9N9kdM81HoX4CKiA9NLmNR68llWRF6WCejU0g3keS6893ZKK9wxg8usciPu3cbsJz0TL9
aGCGuj4KNNJlBGjvsp/BWzIFk9OwWS8rHjnYE+cOT6aN2iHoqOhIDWlfwJylIL4BNXe9sgS/upd8
Lov1A8jif6s0cc+QUJXhDBuV4UpK40+PTv/qMdv+uFHvcZt+0JoMtmQeCFy7FxV8BHTvf9HIDmR9
GQnxodG8uC6AxsjngRplCZjMsmY11lQL1SoM6+0nWSzOXDnv9VJWLQrLrzbOUpss
--000000000000f5f63e061bc87e41--
