Received: from mail-dl1-f97.google.com (mail-dl1-f97.google.com [74.125.82.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D79A30BF69
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 06:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775715253; cv=pass; b=ewnKEKcSVmXv2CFX7+9/RFPZvPfGdjSKPQtobqpcvy+3IBvoDZltFUX/kFHj8cdPc20cMuYjZyneOTJLbqOgt5vuAF28rgOFuEdWzvdKQYMJiH7ZwrfmAu8IHTtpgKJZlqw6Kb7aE5bG08PvI9y8ReA9xeh9ATImg+uIhOcYdT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775715253; c=relaxed/simple;
	bh=osluSe/+gtxp0BwQiUZqR0JmeGsM+j7SxsiF+4WV+CI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NVoe6FpQI3jy5HahhXkjkALD1RPLnMcLBR8uXkNVxB9HPxPYrFdIAayRsT85KgevhY+9Bpc1Hzx4KtUDVxal5UtZNyQuE3EDXUDmzIp555HWh9RIQuAk0gUB9g4VFthBkklQuC2GT+WRSc7gDGw5JREmyxGh1M/GT0Cr+B//lss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gEUR2qfT; arc=pass smtp.client-ip=74.125.82.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gEUR2qfT"
Received: by mail-dl1-f97.google.com with SMTP id a92af1059eb24-12c2575ff49so359241c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2026 23:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775715251; x=1776320051;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=osluSe/+gtxp0BwQiUZqR0JmeGsM+j7SxsiF+4WV+CI=;
        b=SKn6LQP3f6ToZ+MxSBSwN7V9tTlU5yecrafATUMbmf2BIj/o3fDRlSBaIdUqP7Zey8
         KzLm2LphuGCUrCbILeE8TT6e/8FajqGzRvVp54UrOk6+y1dJtYI8tAgqaaUsPgKNUej/
         osW11eHsKx60bmAnfGSh+F8yqJzXT3/zL8VXCJZkEBy2/Fi8DTqEFxiIua32tEFgDGpU
         TfAekG0uWCJoddIRRMoVigcupqcbZYqk4Dd/owa1nbW80G9TsqjHziO4FIRY56xadmT/
         2Fqtenanauk6gvlN14pQJjllHPDNwJbKayBqR7vSBDzMxM+uqihMawMk55vXln/H4Uy6
         OmEA==
X-Forwarded-Encrypted: i=2; AJvYcCViVsaHVgKBpfE+83OOaCe2LwpFkMxKcLaDrewsh57luamEGgza5ATzQMSzHrpvxSEe8ABUEW2vSXOK@vger.kernel.org
X-Gm-Message-State: AOJu0YzBJ1dGs0SjvpIe9sJBVJmglKFLfXR9AhRzqQqVgUdhzozeglqk
	cTQYSOhtnzbljyphUGshPrDv1D4dU+lMVcWBPfEKz1GRE+2kbc0C+Qb8EnJylmAdPxofViyNMS0
	1WLFqm4XAhoIZshvL1D2nM8WxH6j3nxLWevz4UJzYzGm4lHz72cY4t+kBTAPKuJxYaCKkHhO/rF
	yCkoAgil/CI9Go/Mpx4tmmXEw+/EPSxsQw3tIKyxEFcM0jEKYxs32ncQyprAd5RKaBFEzL/oIJ0
	cCTIpSwu9DEfsZX
X-Gm-Gg: AeBDievvK6hVMqenEZIpLGXujNPk7Ksdj31GIW1zuIOjbABJwm4pEXRMVU6BcpqNsnB
	LZEkS86X3jCOxV42EirR3TjB7FyqGLHT/tWB3xY172/8zMxHGAjebF5L70h/xQoSJh7Wqb2XPMY
	6m5Ph6HMhmU5npeLhxo5C0C0+9UQJwSN19XINURwhWN+g6BLoZJy09o78sFF1Itc79uACYvBfVh
	EpJvURWEznZ5PyvmyflAvHL06bmDAo3Li50HD72xPc3hWKqLTvRl8J61SizSkDwPMSv2IyUc2xC
	BQFyBnuLnqYA68xodRlQM9YPSsUgTBZ+1yL56kZBcryaakWU/Op21V8vY/irQ4C5uAZ0dzfUcvC
	ipacvPav1zJw23uI/J8mjuWBX/kPI7E+1glDGv3EvY4RkH4G5mKOcTf2HHtFBByIHleLCFf0xDY
	uD10ITH+hRzwPBomgszwmzPzhXi8b48LtDm20L2nIdms36wD7Ay/axSODV
X-Received: by 2002:a05:7022:6713:b0:122:153:d161 with SMTP id a92af1059eb24-12bfb745308mr13378542c88.17.1775715251286;
        Wed, 08 Apr 2026 23:14:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-24.dlp.protect.broadcom.com. [144.49.247.24])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-12c028eab4csm1022653c88.3.2026.04.08.23.14.10
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2026 23:14:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a277331b57so533705e87.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2026 23:14:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775715249; cv=none;
        d=google.com; s=arc-20240605;
        b=QEAtZMMNvB8mAYwhOQzTFsNnC9Wlo6aKWD+yAF2uUPmNBzRmi30kTzZ1iL5wgwOjHc
         4y8MkkudwF1SUihaVUbBI5r/CVr+l6SdEdyUlEm9furC+bGYNPcQhBXrX5YJTgWeC/l6
         PdWqj/dRq1V0mJv8zx3do8DIN7rX/o32L1ny5MmIg7FifJg0Ny0er1jNGCuGUpIBJp/U
         7rjfwk2Xd3KhrzYDxTxHh7RlW6D2Rk7/T30BJWTqZb3HpNOSH5Gm2sK9QQMbZ3aPah+H
         bCltrbFOml6fDVMBPKElZWK8A9Olfh4pqgjJPO8xGMxXt4KwAAT3Sduw4/Dz5kaJe7kQ
         ouQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=osluSe/+gtxp0BwQiUZqR0JmeGsM+j7SxsiF+4WV+CI=;
        fh=FNq7JqXaxxKlQ8tZjTrJ0tkIqtkwrCJelSYMtXT2Cwk=;
        b=F5dNwIdhrUww0IQBFmbeshVWMVr7fdEEGOU5M+Yz16W2V8lbULgWIpB+8TryTO2h6o
         5e5s9e9fpgBnye6sOliyoUQb1XtHWnvbqmU6IwYdvSzZX55daXodIdrv+6kBzL+fb2Z5
         fSTSokuMQjqtuDIX5SzHmAY6hyEH/npqeHkPwoXCiO4HQFp00/0nQVbFTJSdApfxk48Q
         5YRC3RmZWhEjjScMnBAkzvQB/mOJyNaRjeFHNRq8Sx+3aWgrqMAT6o6raPhYDF0npesj
         m3BZnvVfrf6ZstPD4zDCEd3SqxDn/yYwLZVr3VTaQdxgmnsF5v+NFPHD6qzrUXZpN+P9
         GzTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1775715249; x=1776320049; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=osluSe/+gtxp0BwQiUZqR0JmeGsM+j7SxsiF+4WV+CI=;
        b=gEUR2qfTMOP/555TmDNoLw7GbcEA/WYwSH460aNPY/pJoOMxwPJfuukUVQb0WswXgo
         csl3sU3CLVqOABJtMYzUjpG+Q00N2PA1MZEkpTMFTJIMwuEvcPSYHoBfIHP67GiN+/fE
         JZprhqxIRXYqWm6Zpwel3FFEXOJJKFhcmOLck=
X-Forwarded-Encrypted: i=1; AJvYcCWcCZAxJPJmMRMjdyf7Njwzqu8l74zPdDYjNMhgiyHg36hyJkMycGt9BviKyXGipodEkmQK/X7nixBr@vger.kernel.org
X-Received: by 2002:a05:6512:3408:b0:5a3:d1d0:543d with SMTP id 2adb3069b0e04-5a3d1d055femr7496206e87.27.1775715248874;
        Wed, 08 Apr 2026 23:14:08 -0700 (PDT)
X-Received: by 2002:a05:6512:3408:b0:5a3:d1d0:543d with SMTP id
 2adb3069b0e04-5a3d1d055femr7496193e87.27.1775715248294; Wed, 08 Apr 2026
 23:14:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402074637.92417-1-sumit.saxena@broadcom.com>
 <20260402074637.92417-3-sumit.saxena@broadcom.com> <1d0d35fe-5e9d-44b7-9dcd-48289f9d9f53@acm.org>
In-Reply-To: <1d0d35fe-5e9d-44b7-9dcd-48289f9d9f53@acm.org>
From: Sumit Saxena <sumit.saxena@broadcom.com>
Date: Thu, 9 Apr 2026 11:43:42 +0530
X-Gm-Features: AQROBzCVjmKw5QHlEaQJks9SwSAuJmE0_wfvSzYRI3X6FIYaKsKaSGMO2VQiGqw
Message-ID: <CAL2rwxrU=pW9yhXGGh_Vd67OdSHp4tDGDxQtxcE=GZvfYb4j3w@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: align nr_active_requests_shared_tags to avoid
 cache line contention
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com, 
	James Rizzo <james.rizzo@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000a7a57d064f00ec11"

--000000000000a7a57d064f00ec11
Content-Type: text/plain; charset="UTF-8"

> A possible alternative is this patch that removes
> nr_active_requests_shared_tags:
>
> https://lore.kernel.org/linux-block/20240529213921.3166462-1-bvanassche@acm.org/
Sorry for the late reply. Let me test with your patch.

Thanks,
Sumit

--000000000000a7a57d064f00ec11
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ifscJ8gSasrjdgcsGC9lCyPXLwfNEU5C3Mbnua8OK6sTBpf6mvY88HW/6AoKiSpfo5jxCZQOm4Zz
oJWD5ea7ThJ2XdDk1rRtGUkwFgN9GRNfOoiIwkkA7EdEfV0eQkVqNgkqUyBSABXcduul2sd4/JQO
SsVmTdSKid7L6yZsqk5b3Xj+GMJwPdRfeKP2SRoys0SVnajc9Di+9Jy7uGKxxtb562egZauDFX/0
o0UgYfZrbwWfzJDYMLKzlrOD0M8yGkD8BnyIiVECAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQURSmmYGaiq6dg3CEvXQGHEXJF
8xwwDQYJKoZIhvcNAQELBQADggIBAAl0pcCjujKdwmgtiGl2naEY5wB4G601Kuu3032tR7wmgZLg
k+lg9fhAA0boPsi1FE1Pwb93YDBGr/naS/oQ9JglSMeEVzeRvCqjFS4FpouBAFHB77c8w3ZwJ3+t
FSRJW9SbW0DADBn5t8GAjv2aSm5vDorqFe9MKOYEe50yYDQEUAsEt5QkrLTcEx9ntvVb25MxI8vM
bdfqna+/TyCmFmnGAz58jiw5DxLn++6wMmAk0SeUEuMrAlRIyhte6BBSBQ5cL1P+DWSqQbm/pwCq
NhySSLNtTi2dKJvvg6Ax9au913KiJj6uZfPlh6/0kaVKM5GhIABUcm3c6g2qD7ITJxB/p1kjYKLa
hVrtrjK7000lHKTPFr6MWB4Ggx7yKQ9yIlPMKKF/Lj8FabYCqeM5ovG7kaK8FYXug5vjNjN0nedR
X3P8o+8aL6WFIAAAKm2DqZh3252Gcken8v5c+f0SXWSJFvemfFNgrJiQFnFVrOE5v7qwvM/KvVCA
dYm4Ph9QYI0sm+Xitx8MkdOJtq5mcPWowGi8UiCgkOidv4ki1SA0wptfquUhbfS9b2M3XUHCEIUX
4ECvIjR3f+E0NbBIfPccWfYUaDLvo2qhLYS3KQbhKdXcJ83ha17mbVNZbDDo9upNcLO/oPyDbCNF
J6UpXZmis1wnCynhK4kQfwFhW7H+MYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMdI2Nfq/Vk8dzZMUnMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCC5g+Ru
SZduGCUX3w1NFAYVk9axkv6EyptltRtbS+4ScDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjA0MDkwNjE0MDlaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBGrGCvsAps332SgXjzwKL7pCpKEsgql2mXacMG1Zd5
zayn32vq811td8yQXJX3WAlO1h+1Buj428LhdjjTkDB4+GZiABEY5QQCghrSFhicYbBE0HqEFDY2
JpJoTALqIoKck2JsBPZnmpUXaWuIZyiIZyLEa8546opemJdiNUnef1QCUftr2fDvjEI7OZaZIDIn
uHV7xUGghYVZxKXvlve0NRjMU7fEOcDCSfFGXi057KnYHK1uvORh9sIADXBn0tUlLbki2E6m5UKi
5g7XpSKJZCl91bAoX85IxDX1r0EWbb/JSoD1khmo+tNDqGDBDAGwWzw52hxEeF/nfnd4TJVJ
--000000000000a7a57d064f00ec11--
