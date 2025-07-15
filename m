Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C7F2571B6
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 04:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752552910; cv=none; b=hOvL5tJN4gK+PRLpqkAhoqQrkKeaiAxw6GQ+Ueo7NpSu0bFfUdjxemeLDvmcJdvrsQYibE1/Ol/evql/QrTjMPDTI1Lw83Y5KlwIUS2nR3lIPLFpHkXNRoum01Y5e05bnQOUr5ycEJ3a2IaZm8/aHujbeAkjWt7bMAedQJwUZ8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752552910; c=relaxed/simple;
	bh=g3kHmLgp+ydHN3htYHPArcnd7ofR2eV12tadzkw0R9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IhBWJGd+12p8mL1hc7xzZrZ6auOSEh0YdUGydpl4a9A6ZgMmCwAFycCHZqgzaKocEjzi1U3ArHsewnppCbwFdx/YGvFDQ7PWBkzldziaMYE5loZJsRcmg48B+IXKgM9qWFzZrYe1dfqkj6hFbr5lSLlBVYqvfZRFelr1rCC33Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NxY12gzj; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NxY12gzj"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54d98aa5981so6635594e87.0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2025 21:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1752552906; x=1753157706; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e8MMl0Vc51jEH2Bhn+oDJLDatGD+U8vFR9E3AlCVPe4=;
        b=NxY12gzjHqkuoNOhY6McD41KmZr+wjTFAGvNOh3GzujMszwWjb+0I58EQtACN/ViUA
         +dfTqbYmReQDzb67m2H61g56SVWtExOBAEP4yctlBhc4STP+M9Zrl3kmxS3KkUq1vRMv
         33Oep3fgK39U7m81sBnMZZ9OxKK0vHd7qk0aU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752552906; x=1753157706;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e8MMl0Vc51jEH2Bhn+oDJLDatGD+U8vFR9E3AlCVPe4=;
        b=ieONhX0pqnFiABZrZxJE+dnZQI/+SJUG1zeLtpGlmSBVOVtkyLh0P4Q7T1cW4C/9ht
         blQYV4Uai+NW6jXBZca9in6bUpG4L68zs1ZaMV/EWSs1Vk+HLEpo0MXpCAGNUR4uSdBS
         2+7d366rATzRRzVQvnQJfwK9PXTEBC61PVbFwN3xZzRxnMysQwHiF7QPmT6KkiCtyPON
         u/xcsJUUHwxcMD66Jcaq8Y5xs5366hR8afJA+UhXpgkHrS8+T8Q9FpUBYaG/TBepy0wg
         nxZnEprwAvFFpCzaDaQAEU7HoGkTyuXV8A4rYuIiorOX6paSGBRBguH9/DiWg+Q8sRLz
         33vw==
X-Forwarded-Encrypted: i=1; AJvYcCWhBkiDYQ/fjJNYMe737jWAxo+q0TCCT7mC1QI9rG4tqY2qIiTb9Mx0FFnfn4QlN0dsRPTtMT6nOB7q@vger.kernel.org
X-Gm-Message-State: AOJu0YwJYQlvst0ojMaNTCXL7WPVWkTol4CIw8TIV06/PdgYktBA3eny
	07A+/poJzbo06yFJTkXCfx0h8ahRI0E3huyHeNR+Oe2Wl+5A4Q4UVHSvAiRbR6IgliKYxthI73o
	O+t9zDv62JBpW4FrfwrenW8Xq2EdIHCjN46EfyHnQeLFfh642imb5
X-Gm-Gg: ASbGncsuYPa399krseye2+QRq+n9A0J3KWHloXbCc8mB639UI+YAlWo21Ql5E6RHf0a
	JEb6B5fO9laaUiVXmg+j8TK7ah1k1Q9KUiHR2bCzkmFsx8vTwH2lQ9Zd4VQyPegi+ppdyUuLH8b
	lqQzBM89Jhpq3f2sOQ7xljjKYcg+LXgOWsb/UlBrlDOmUr+dwfoufbEfPsJQ4Df6n4lRkdu4Y2S
	+Hs
X-Google-Smtp-Source: AGHT+IGTXXcFjZa27on7wAcwjuPfAYXV8gl6M42raK1PWAGai4Eq4m9AvmrCrTCtskK63zWK+CCDeq4VAuNOM529cXE=
X-Received: by 2002:a05:6512:130e:b0:553:2e82:1632 with SMTP id
 2adb3069b0e04-55a0464fe5amr4405606e87.44.1752552906364; Mon, 14 Jul 2025
 21:15:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624061649.17990-1-ranjan.kumar@broadcom.com> <yq1y0syceen.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1y0syceen.fsf@ca-mkp.ca.oracle.com>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Mon, 14 Jul 2025 22:14:49 -0600
X-Gm-Features: Ac12FXyDGjqDyuu-L_V7t9PTJKR--u3_ksxu_rtnkLLbo3qmJKHU_PkDGlAX5bQ
Message-ID: <CAFdVvOwjy+2ORJ6uJkspiLTPF05481U7gcS4QohFOFGPqAs8ig@mail.gmail.com>
Subject: Re: [PATCH v1] scsi: Fix sas_user_scan() to handle wildcard and
 multi-channel scans
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org, 
	rajsekhar.chundru@broadcom.com, sumit.saxena@broadcom.com, 
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000007681490639f00572"

--0000000000007681490639f00572
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 8:03=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Ranjan!
>
> > user_scan() invoke updated sas_user_scan() for channel 0, and if
> > successful,iteratively scan remaining channels (1 to
> > shost->max_channel) via scsi_scan_host_selected().
>
> Two questions:
>
> 1. Channels? In 2025?
The mpt3sas and mpi3mr drivers support both SAS/SATA devices and NVMe
drives (Tri-mode support). The NVMe drives are exposed as generic SCSI
devices by the controller and they are identified through persistent
ID (which is nothing but an target ID) whereas the SAS and SATA
devices are exposed through SAS transport to the kernel as they have
associated phy/port data structures from the controller and in there
the ID assignment is done by the SAS transport layer.  Hence if same
channel is used for both SAS/SATA and NVMe there will be an ID
conflict so both mpt3sas and mpi3mr drivers reserve non-zero channel
for NVMe devices.
>
> 2. Why special-case channel 0?
The SAS transport assumes channel 0 for all SAS/SATA devivces, so we
do not want to mess with that and use the non-zero channel SCSI type
of scanning and let the SAS transport handle channel 0 for SAS
transport specific scanning.

> --
> Martin K. Petersen

--0000000000007681490639f00572
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
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIALbSzd2
xnY5SbOuZeRHXrIWULugZFLzN9PeTzx1U+81MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI1MDcxNTA0MTUwNlowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAEeFnnWs9aQy9/K9hmYpM54IHmRUjiN+WHf6QRgUpu0B
4MlGk7n6QCezT/SojzEmkcpXwL38A2D0hXlNX0/sIn6zoB+4KSGswtrDdePlurxfuo1qgtlY45tX
XMjOLYK8RvgT5gIadoEfWvZRDDSms/r/OVzKUOHy1Pthld/e51/6BOemi3ycXXBV5uLbd7lMcRYR
/8N0IA72OsHkks6w2+KoZXFQzGF8SKsx4QYMlqaeeDrS4uHBQX1ebxNzqKjSekuQXAZE2XYXAW3h
xjN87N0dSfWtuRTOtQVM4yU4d/IHqhvqL1HWsOvsFtbZ/SYG4pyK/bptidn58VBamqy2qP8=
--0000000000007681490639f00572--
