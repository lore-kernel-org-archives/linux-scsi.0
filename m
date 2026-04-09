Received: from mail-yw1-f227.google.com (mail-yw1-f227.google.com [209.85.128.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD302E06E6
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 06:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.227
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775715478; cv=pass; b=NJE1iYhWNoiB2RXxBSDac5/KlrN4eHsgB4v1bQ24yBx5qVj6lJDuPV0BBtjP9kOKV3Hx9zdm7EVA9wDTB7Ncfot2m8RsQUgOnkfXU5ytujh4oW7aJbtGzb+jAPTQ8ZPmi08cCTuqwmXkug63MXC+K6uy77QpGT2kYQE21gBZpME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775715478; c=relaxed/simple;
	bh=rS8Hd3jwYXjVSWStDrYuOpd8W926zGes8grqOSYi+ug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rnWHCJQxxvkU6BvBfNieOp7qL8zGZWQ9dQ5Ob6l7XRS16XjcrhGqzltWie95q/V8Vu7dU9S1VnEUrJf33K7rUp/NKxnQuMGB3N+tNxtOFGI65WXNhLjcCDY/ZS6IFSxRF4kScq7NusYreESYn9vACVAEUZ9SZOppoXnkb0QK6Dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=U/4nOvZ9; arc=pass smtp.client-ip=209.85.128.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="U/4nOvZ9"
Received: by mail-yw1-f227.google.com with SMTP id 00721157ae682-79d991c7b6aso5087997b3.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2026 23:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775715476; x=1776320276;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rS8Hd3jwYXjVSWStDrYuOpd8W926zGes8grqOSYi+ug=;
        b=LAM51/q+QiyJ6s8BW9oYxjpOAbWu7aNz4h6FpTb0DIWqkgZqKBu2w7LHVwwGNsVKfA
         gY5ZCXzqXdFiU2m0uaUvgX0wdQnWa74k41571l44b1GkTHSZsJjrqhPSDMlfLQbiw1Vg
         aWvDlfHeAuVodyEe/crOk5JEkiXv4SQuXW/uJAy68EjLv5ibcxy561iCsIU+U9eG9KqZ
         fNrOYCCJDJnxJXKcGrkoWi9SahENWbaJqzfCd81lIpoW4pIW+cIhZ9KC0/0TDUAHZR58
         qiHJlEEyvlSPECZ8NHGE1Q/Q8/yn9fW5FwCCmrXM0BNzwtPZSTNrl5ONBk7LmDlzmpoa
         cGow==
X-Forwarded-Encrypted: i=2; AJvYcCXWYzQzofAP5rROGqkxqc72pz6KZtyyXijwP8EX0m67HOvrhvm7Hima4s6BzOO/nbGEBgYAYx/hZbyc@vger.kernel.org
X-Gm-Message-State: AOJu0YxClCFJXH7BGKvTwyFuLyH5nFc6cC0uUQvKo2Vwb/kyjGmRTY/d
	TEbxDIp8xfZLUAQ5FKY3SRxEQbjDZ/Id3bfShaJJS4ThXaXZXAULUoAoGYnm7gY9q2Qw9dYKE+M
	NJSXuTrN7TLZnKXIGcNiLjad1MRK+kI3MWGwNKfmycTrRt2BN4n/5TYbHc4gLIXLPHlEeEGgQ54
	hU2qLFhiH0AJcWYXwtMRapuo1hoilsU9wycjhkH/o/H6lgLj1j8Ze+GHpSrfhnkjzA7K4Z2F4BA
	unhwfsYSeidq/zE
X-Gm-Gg: AeBDietSGQRDaamH185AX7u/eu46owVHtqCr2LklIbEJ3CKeijuPAkUiZU5YAFHI8Qu
	R0qjFB122KprMk7+myVOZFJsK8/2TOJoe15skkF1pRSAyZld88J1WGPpAOiGNDUkxsAZ6PwkQiO
	zrvargaTaQZ5WiAWkh9zp5QibCwCj3OuZ6hupExVC1RFQbCMbuQDihefCcEaGRGuklZETUPVJUL
	B9mdfQcAS80ldmkaU2Qe+B4tO1SxOekt0H9lg81MTs+ZsC77HYHZ5V8neoi5IGrwcnxtrjM3jVy
	R66/Eb1jCJpnv5j7MbtdjoZ2wUyRFZnnmEEGKNZiOKSh9K0TbQJAuorTV8iQAuM55zyYygB/1E5
	kQInb4W2RYkP6J3LBuKma2PahTtwlMmSu6nQDtNKFcJdRyiAy2pEUFyRLH7RHs4ko9mWqX3tZfz
	sIPYlRcHTJoKlfw5mhEJ3IBlxjMhouNg/5RFYiRy5hDlQq+rmsCsYYjXnA
X-Received: by 2002:a05:690c:dd6:b0:79b:cf31:9767 with SMTP id 00721157ae682-7a4d2ff0c6bmr232993257b3.3.1775715476214;
        Wed, 08 Apr 2026 23:17:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-7a37080af8dsm16854247b3.19.2026.04.08.23.17.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2026 23:17:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a2c9141ed4so259748e87.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2026 23:17:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775715473; cv=none;
        d=google.com; s=arc-20240605;
        b=f59+Jlr9VnklhrOnzedV7aeJw6F+r1Y94+fU3RuNJvSPzkPaEex8RH1h2MuGw8gp4V
         5x2b7RxL2IlTJ8uUjVkIjcXFiUUPMw60jnIQkdkyXW9Sbqab40Cp2pfWfx3zAvksJ7Zi
         m0H7WSHEjO/1qqhhnY500W5nIlnWbGDY8Jvv6eW5xfrFW0chDK4/yFwOHHngGvdSzo+X
         EQ7r17PlOT7TA9zzftnzPG0c6jcUiqLENcuAqlMauuKT8/3QL48OyLTpvHxHy72tTNmx
         C1C05sL9bGHURBulUbMD03NWLYIW6naHst6imI6ReCej9Ulr6bI4dgOFmJ00QvhXQm/C
         HzEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=rS8Hd3jwYXjVSWStDrYuOpd8W926zGes8grqOSYi+ug=;
        fh=kRK8kit2fecpXKltSnihduoB51sKHXoxf3xOjbTSfyQ=;
        b=Pcy9XdoQ5CCfv23LX8WMF6i6eeB1MGZXFDYtZTCttTw4bt7q23d6yJVZz69G43pLpL
         avzIp2LiPS3aP1e5mGYRPkomCTkew9/SI6e4G4JIzAbvfhgPhhz9O3nJtqJJWiJdB7OW
         tPTixv4LTzrMXQp/YNaocoMdb/dA/uwvTkBvAh6H9Ra0Zr9QDen9hY7Np7lw8qo/ojB/
         UhLmj+Den3jQRya7Fx6wGfChSIoMNXm+hUkjftBn0soJkVyhRXHrskQWyhydlb8AX6YE
         4YhL9iOEEDerFIczEz+jVTEeApJWTAz3espCbweK6bX1l2iv3SHBAsj27iqqgmrp2dHj
         f8Yg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1775715473; x=1776320273; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rS8Hd3jwYXjVSWStDrYuOpd8W926zGes8grqOSYi+ug=;
        b=U/4nOvZ9i0kDw4nIdbYnC3XU08jtxZ5Gc/B9Pd884HAcvFyqji2RK17KxsoNKLCfFL
         a44DulU6vWTotG41K7fq+T/FJOH9vLNkHgCkopp6PlAVOwZFGvdciH2kC0cgD11kBwBx
         o6qqx/HgK0tX37UVLdn5CfebtIynCqp0EkkPY=
X-Forwarded-Encrypted: i=1; AJvYcCUotNGflu4pm23PUyEattigKVy7sOA3og8aaX/zJV1i4fWHPCHMVOz0+Vi3c3dYtmiogZ5NUTmzPiAi@vger.kernel.org
X-Received: by 2002:a05:6512:39c4:b0:5a0:f95a:1602 with SMTP id 2adb3069b0e04-5a3e7a1b3abmr728033e87.17.1775715473542;
        Wed, 08 Apr 2026 23:17:53 -0700 (PDT)
X-Received: by 2002:a05:6512:39c4:b0:5a0:f95a:1602 with SMTP id
 2adb3069b0e04-5a3e7a1b3abmr728014e87.17.1775715472968; Wed, 08 Apr 2026
 23:17:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402074637.92417-1-sumit.saxena@broadcom.com>
 <20260402074637.92417-4-sumit.saxena@broadcom.com> <fd582bae-a090-48d4-a4eb-b2db6c10c26c@acm.org>
In-Reply-To: <fd582bae-a090-48d4-a4eb-b2db6c10c26c@acm.org>
From: Sumit Saxena <sumit.saxena@broadcom.com>
Date: Thu, 9 Apr 2026 11:47:26 +0530
X-Gm-Features: AQROBzDUquBm5kMJ6J7syFlVbc5mzRztWCArYbjMRZL4e7qdDMCJme1mb4poIFc
Message-ID: <CAL2rwxryLK1_kna6Ho4EFoSMxzJgfznZkU-6NgUACczP_GV79Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] scsi: align scsi_device iodone_cnt to avoid cache
 line contention
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com, 
	James Rizzo <james.rizzo@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000000c00f6064f00fae2"

--0000000000000c00f6064f00fae2
Content-Type: text/plain; charset="UTF-8"

> Has it been considered to change both iorequest_cnt and iodone_cnt into
> per-cpu counters?
We're testing with per-cpu counters, initial results look good. Once
the testing is complete,
I will post the next version.

Thanks,
Sumit

--0000000000000c00f6064f00fae2
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
MjAyMwIMdI2Nfq/Vk8dzZMUnMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCCOIq1q
zWts6fUqqIlaUKTHtNH1yGnQG90NUWlIst8FLDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjA0MDkwNjE3NTNaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCfk4edYgzjs74uNdMkE3M/HHCNJC5g1uLPzTwDKIBu
0PzhB8MQ9vaSVs8ODVEVNvpV6e92pd4PwEWWKz63mOwxTrmOGjwTVrNr3xkpfUVY9KxDyCCykJuj
eyeH1A/iw53g4Q+yugbXjunxRAp9tYf9gMSEjnD43NIC0gEeoQY3CUN4EF5Ecr9BSTM055N2GZOr
ACb+p/LNB/u1UKQx2VGF2/skd3/dG2AUulv/YGklo/A46O/rzHVJn8E+PGVS3Mb4cY8GV/PUI7xz
eVGUtEN7HOZkBFp+LUzrIRoH643Rq+j7xmM1k6G7t/0raxZP+RuvTSiFmGxTUMLxdO2g/HCW
--0000000000000c00f6064f00fae2--
