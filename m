Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850BE242D63
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 17:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753984339; cv=none; b=Hbyz1KNpCKkvfmmpmwFafEPYXItOZFvGGY9ZcJLEI8gcBTeIZSBg8V6LuKl9xL/u4bYXhWRz59UONnlBuTUHes+tnlKmdZIYbsjufd1Qzt9fyA4VqUimRUgulR+rO7ImG2n8vndXoCOuO/9j7o8OesEj8D0xdbvQK0ZypO8lx/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753984339; c=relaxed/simple;
	bh=P79qlG9i7PeXFBhyYi8UV/N5oSiSCkmpu3PuXdFYDL0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=knsQSZHRDK7Mlhv3C/dqyxUuc9tiUShE1+BsvRLbEem5TPzzTLofcVM61cAkao6CtZb5Vqqso7Y8ZS1x96yuP2CliIFpHCbDCAFfS07hCocv2S9eo8BUpcDH3gELpTq9p3QCjLitrMA49tg1jFypDYRSOs6dUHduNjm8aNjE/so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dzwG6coV; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dzwG6coV"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-33211f7f06eso5917771fa.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1753984334; x=1754589134; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xv4pmNqc7b10p35ne7lVzeVRY83kFI6B6P65K1NKtDo=;
        b=dzwG6coVM7FQkH3mSOFhIyopXlojxKS9bTwHxJ/Ms50yt8nrj9KwxHI5EgNBA8CuWz
         UfeI5D1P6xaUMbt7+fFjmU9Q1vppvpaU6gT5c6HmwFlq3fm2nPpHul5ymr6sPfJFfB/M
         wt6/vVWGAHtrOf2/SiTnt7+EIUyiLlX3MzPcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753984334; x=1754589134;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xv4pmNqc7b10p35ne7lVzeVRY83kFI6B6P65K1NKtDo=;
        b=GB5vMgU73E4Qxd5tb2fSqfUbCYz7w+bJSiOtyYV2T2FxsL+3+vvs+Vg7HlATOBsHFC
         NPFGGGtf7rlrxUDXY8i4Nac+JW7TKQOYNYs9Zp6648nuqHloUZ9mUFeHSalwE8knXrCa
         omMVBUcP4ko/18W6SaS81QsZJbqLHAYS6HvxTr2as88T0aJS2gTPF4A2UB00P2KtwCyP
         F+FU9M92DHw4yt+6KliEsefZDaAQdO9RG02qiId4e04GxjvQfuZg484rtGXLKDo57xcP
         pDLDTn6bfPIkpxVOhKBDnABXTNaq+P5FAFuFHswcPO68Sqmp1z7Nw8/Sjp0/BzIi7O5H
         IaTg==
X-Forwarded-Encrypted: i=1; AJvYcCUb4bm6f7fXQcLza/t5X+ZzokN6wQaBdu5W6dYunLlRjswAFSblLd3o19CK3+tbsyN0zINnWCaNGLHs@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/rA3KZsRZqHBT6IAWPD+X0tO1+qLus/WXV5zCFd2B1bDmOEnv
	5gkbtLDRiToygbHjmjXQz8KJnMNw3dMLN6GkeJuvj0C4dFdUd8+3kQD3SfnsCJZeYhD95EiLYiM
	jCX++F+UzZFL9tZTmzeAagcmNxoUECv8+UuD3cL0=
X-Gm-Gg: ASbGnct26o08ujSGzhEwZaTsnLhRl5B88G4s3zU5ZfxP8xhSfEuKx06uDRvGSt/O0FQ
	xlDLH913D5KzPE5bl3vLmkTKdqnwGPGsqqceUUZ++QFmGKEQDyKpfgct2aTtCg8lvUXhfKBbfGD
	PHPcajujkD0oNNF6jusGhlkt7yel7tlENsP/dkA+xRKuIv6aTJn0Ojf2IBIqdd46B8Fpj2yQE+W
	nZQJkBC2XY/5JTwUQ==
X-Google-Smtp-Source: AGHT+IG5PZurRI5LiDHiLaAftktQ8WPNkX88NCZd1O5e2zYvEmu3MlepJGeTRScjm2Dlw4AoAqz5sf3iw4Den4kQXrQ=
X-Received: by 2002:a2e:a016:0:20b0:32a:8855:f214 with SMTP id
 38308e7fff4ca-33224bd600bmr14909431fa.27.1753984334505; Thu, 31 Jul 2025
 10:52:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250721110546.100355-1-ranjan.kumar@broadcom.com>
 <aH8oUpyOhTlo-sZc@infradead.org> <CAFdVvOx2RCtwc2H-K=QOQ+fG2=5s-TN4oOd0qJsCXvzfOpM69g@mail.gmail.com>
 <aICAoqAYPsy2ErLg@infradead.org>
In-Reply-To: <aICAoqAYPsy2ErLg@infradead.org>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Thu, 31 Jul 2025 11:51:56 -0600
X-Gm-Features: Ac12FXymO2kHL332LPZT3HZD0suhB_Qm_cX1QOVmF8ac1c0ejFmJiZTm9cfnoyU
Message-ID: <CAFdVvOwW1QA5hhCdxYhnE7vVtG3s15JWf25N5DJnD15_-waxtw@mail.gmail.com>
Subject: Re: [PATCH v1] mpt3sas: Set DMA_BIDIRECTIONAL for additional SCSI commands
To: Christoph Hellwig <hch@infradead.org>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000003a7ad6063b3d4d34"

--0000000000003a7ad6063b3d4d34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2025 at 12:26=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Tue, Jul 22, 2025 at 09:06:10AM -0600, Sathya Prakash Veerichetty wrot=
e:
> > There is a resource issue which prevents SATL from doing double
> > buffering and RMW of the contents to map the data from SATA drives to
> > the host buffers for the specific commands.  Our firmware changes
> > leads to performance and functional issues, So we are left with either
> > failing those commands in the driver or changing the mapping, We
> > decided to go with changing the DMA mapping as we know those commands
> > require both read/write access to the buffers.
> > Any functional issue of changing the DMA mapping?
>
> Well, we have to change the mapping to make your broken hardware work.
> But these kinds of hacks in firmware are really problematic.  When an
> application does a passthrough of a SCSI command it can very much
> expect that the payload is not changed by a call to SG_IO, and this
> breaks it.
>
Agree, that is the reason, we don't want to change the mapping outside
the driver.  In this case, the problem is with reading the payload
(the write access was already available in the default mapping).  We
tried a couple of long term solutions in the firmware and with the
current hardware capabilities they were not successful.  The other
option we have other than modifying the mapping is to fail the
commands but that will result in functional failure. So we took the
least impactful approach.

--0000000000003a7ad6063b3d4d34
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
v82E+npLwqC8bSHh1m6BJewfpawx72uKM9aFs6SVpLPtN6a5369OCwVeEwkk2FeFU9tZXWBnI4Wu
d1Q4a3vhOColD6PdTWv74Ez2I3ahCkmpeEQ1YMt61TUH3W8NUJJeYN2xkR6OGsA1AgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
VyBc/F5XGkYNCP9Rb96mru8lU4AwDQYJKoZIhvcNAQELBQADggEBACiysbqj0ggjcc9uzOpBkt1Q
nGtvHhd9pbNmshJRUoNL11pQEzupSsUkDoAa6hPrOaJVobIO+yC84D4GXQc13Jk0QZQhRJJRYLwk
vdq704JPh4ULIwofTWqwsiZ1OvINzX9h9KEw/+h+Mc3YUCO7tvKBGLJTUaUhrjxyjLQdEK1Xp/8B
kYd5quZssxYPJ3nl37Moy/U9ZM2F0Ivv4U3wyP5y5cdmBUBAGOd94rH60fVDVogEo5F9gXrZhT/4
jKzCG3LclOOzLinCkK2J5GYngIUHSmnqk909QPG6jkx5RJWwkpTzm+AAVbJ9a+1F/8iR3FiDddEK
8wQJuWG84jqd/9wxggJgMIICXAIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEII0FD5Ik
4Sk8IxN2CxGMZWjeKS/HHp1HarCMZPRteii1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI1MDczMTE3NTIxNFowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJpSOtPXVjwh1LnPvdiH4HYQpeOhLcjeeSbBcNTDeaDZ
3oSmdzOm3qUhZG3mYLItxpPuvlvcE3Ppa06nssvnjSLBRCW0o3QbJ68DZQ7DyvbcwD63yvpmlZpl
lze7mitEf330RQTduxMBNzZFUcCgUWiZBTDw/zrMbKwusYodhp3lPQS/RsLa5QYo5HjwkHJCupMl
xIczD81IIIfICWvhXLwE2Uo7DbJ+OHByfcdl3pWjeq866rHPL/nX4S+/2IizuwRUiuYwuU2HUF8W
Bz7ZAe4Q8SsPmNeBNXLMDbljuvBCBXgBE91uAedOub12vVd6QYgCCk5+oWm2/+XJ7q71OkI=
--0000000000003a7ad6063b3d4d34--
