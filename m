Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FD9D268
	for <linux-scsi@vger.kernel.org>; Wed,  5 Jun 2024 09:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717581103; cv=none; b=WhnL74ka5tRjsrMY5Up9y9K9KY5l9iOaA4W4N2a8C8HyScmUSDXdcIwKKP50gllCKMBaNY0mCNZ8BoSQwUgMO6T8GHp/e38OLs+A1VhchEoGzsLxYyqneG0+T0O8eGubvh5QCTkt+uWM1XzgRHPUBdheJL+gCgkw+6xP4jELQKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717581103; c=relaxed/simple;
	bh=5U85MxkZ+7k0QvMwzq/cHaMAl8wnbvfw4xBPwIvOXxQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=oq7aEOZImwiy6XF4q6xREPCvHrUfo807+X2CHCQP9gK9SUAF2OaLYe2/SwT5OIY1EPAzh8W88V+W9Msxn09Nd2Wz4JSLpwGRHl5u88rLcs3eEZgO5yqf+uUnjVQPBuY45qDBKNiQ/QtPo544qX8GdSU6edNA6mYPDZCuSh/lMx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PHwRywKV; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PHwRywKV"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1f48b825d8cso18091115ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jun 2024 02:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1717581100; x=1718185900; darn=vger.kernel.org;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ARHYU8BL7C7Z4iQvHh+w5PwvecYH3NCBSaPAck/S/DA=;
        b=PHwRywKVqAhCIu7fF3vtGMvk5gnE2eYAilZibhSQ2KvKR9SZ2aHmfraJNygIXdnymY
         zDhY0xEZrK5ma71rHbF62sPVE5VLEiYzx3J0QCK7MzqE+mDJFxMfl4qUIXqeHglpBIBM
         j+1ZAXR2iXZiQKp+eHSNMSQTgQyn2nluO1vKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717581100; x=1718185900;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ARHYU8BL7C7Z4iQvHh+w5PwvecYH3NCBSaPAck/S/DA=;
        b=aVuRd4uJQ00VlM5lLhLgLN1MN6+T3KJ86MJrFzDIkd1ICd6p57mPbFbHVk8PZw7De3
         K1Gdm0E9pB7o8L0OZv00LODw/sJi9Ek0JswDcb11sri5QU8QyhOCICX7HosMIErVCaR3
         eMTZD7QZlck4xmCT+oxwGxEpHo2ZSa5XYlaHEbLvM4Dk4OX1Ix9Bt2YTS92SvZVDS3OZ
         wrBvMn0Mkcm1NAmmlXFrRWsGd/TReSRqYkQtl5UXbpnphBtKgOS2riNuH65a//2Zb/NH
         IC2bcRS886WGgYMfZ/0IRFKhsL7uRhlCnWia1pALtFx4hv5aKFViJPu1N3jtIZ0SLr4g
         YvuQ==
X-Gm-Message-State: AOJu0Yz9vN/NDXjb0YLoKZ6r3CTxL7/nRiLB7wzWPm4/msZ7Vm8puXZz
	tHQ2RssKft6zHm59TljXj6+j6Kfuemg69USbGzWW7JTUOfj30TqIkEooyq/dnqXKjs+moMvLT/T
	X9izLSuFrSrIE9kmPR/kgwSh8cs45RYGX3p4Zx2Rv9DGiczDPN7dMTvI4YFUUM8P/0GSK6CXOfG
	/mYTrx08n3QMDdNN/rHzgkmlxaBUkT3oUR6sXgDo+s68oKYw==
X-Google-Smtp-Source: AGHT+IHJnaKtqLKo7L8nRNPoG1ZdvCZjMOnPz419YOvyNqERxG8fm/3WoTKtrRrmQD4MkEqxijaEcA==
X-Received: by 2002:a17:902:e809:b0:1f6:751b:f0d with SMTP id d9443c01a7336-1f6a5a11f20mr23025985ad.22.1717581100306;
        Wed, 05 Jun 2024 02:51:40 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f673a9ef86sm58002285ad.56.2024.06.05.02.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 02:51:38 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v4 0/5] mpi3mr: Host diag buffer support
Date: Wed,  5 Jun 2024 15:18:35 +0530
Message-Id: <20240605094840.14968-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000654ff5061a2183c9"

--000000000000654ff5061a2183c9
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

Ranjan Kumar (5):
  mpi3mr: HDB allocation and posting for hardware and Firmware buffers
  mpi3mr: Driver buffer allocation and posting
  mpi3mr: Trigger support
  mpi3mr: Ioctl support for HDB
  mpi3mr: Update driver version to 8.9.1.0.50

 drivers/scsi/mpi3mr/mpi/mpi30_tool.h |   57 ++
 drivers/scsi/mpi3mr/mpi3mr.h         |  157 +++-
 drivers/scsi/mpi3mr/mpi3mr_app.c     | 1080 ++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c      |  426 +++++++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c      |  113 +++
 include/uapi/scsi/scsi_bsg_mpi3mr.h  |    3 +-
 6 files changed, 1825 insertions(+), 11 deletions(-)
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_tool.h

-- 
2.31.1


--000000000000654ff5061a2183c9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIWHdC37gITUWgNQ8h7TQS6dusBs5+2d
GicpLb/2MUf5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDYw
NTA5NTE0MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCffTUv9lzhJJ0YM8xY4hAJd5Xy0St96/1YFsbuRVqVOF4fyeP5
0w+N3rR8WP5YdJR2JmJFBgpdRQZIAVf/LvOTJhdKBbeyVYEBPnbxg3LTrkcxknw11NHSqO9H+p7Y
yUsZHzs4moVbX6Lo6wiBMdrEEYRufoOIA+Y7vonUgXnc5iwg5rlFPAy78CIEQ7NDxDglXHspeNKD
ditVQ8SccojVwI4qg68TVoPIRWY/3vwqUD8MY08/0CWe2Zk9/eTGpCRPxe3F9jXK7cpYk5Mifv+T
id1lcN27TuLL4ZFe9rzRlIAIeTa/B3HdGaoWSx4w5uNZsba/bT59q8DQaFjplYit
--000000000000654ff5061a2183c9--
