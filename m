Received: from mail-ot1-f100.google.com (mail-ot1-f100.google.com [209.85.210.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C503E122B
	for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 07:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777360971; cv=none; b=RlQ4fl/6EnDRBFr4oieGIk+qrEiuGhYg4dQQttbYR/m8pmLkx/oz4Yuj7WUdqBPSezCyrqm4WeiELBI9e0h2ubJ87LdvB7VJ7HdYYCPPI8h+vebzEy7vY7UWwbzlqeD8+VWr+hMS+PvDugzpKuBcUAfOff9+ThR0sLsAez1Gxwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777360971; c=relaxed/simple;
	bh=sCasQG+ObA0ksGwj1TE+ZQrk2nCjsz6H92qsa+NhxQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RIMNoSHySrCyvvSmcHX57JB32Ge5BHS+dVmo+172CokMX+3pLMT6TlLcsNrm7oShFLOkBr0DQ3K8YgC7+kryaGcmCsqUgaTreIasrJ/qZ5bE7r2KM/lpRg/d4BkFRu+dJ6+3bR+SZGddmPCdOnpDSsg7AXCL0RkkjalTgiRVFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=eqtPJC+1; arc=none smtp.client-ip=209.85.210.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eqtPJC+1"
Received: by mail-ot1-f100.google.com with SMTP id 46e09a7af769-7dcdd1b492eso6920270a34.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 00:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777360969; x=1777965769;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCasQG+ObA0ksGwj1TE+ZQrk2nCjsz6H92qsa+NhxQU=;
        b=H+R4nUCOTn5Cfn8R0n2UIf2aDU3FNQxolZAotvE0xiuRzKm3BumiII07ZImkqajePk
         O7HIRIPMHwGAzWGEBOj6TZ1VJgxWTq5mlf/5Sk5FVPKGjg+pLav8H4jNkucFrj1s9eHr
         3ksBBHLEHEk+aGLZYiuuOjHQarqym4UePsDh4c6754jxUGwnYRVuI/bXQO0rjPT6O7l+
         Bxx3PrvMdXSA9QCMZTgtO0tkX7qIq09VvaRWxn3frae9Vvt7XRA6Hr2sdvhnCseFlgXj
         D1hiYak11+blWMfSBjA7lgMZA+5vSVfuUx/GyC1wNs9rjcUm1SrqC9w/7IrJzt7/nxJ/
         K3mA==
X-Forwarded-Encrypted: i=1; AFNElJ+0nG8YssjJLpezjr9ICtS5+jP+rroqMFX/MIBs6faXrykd3BEF7tocHlwoJ4q3wylC0/gZgpQFskH1@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9FBynAyY7+4aHg7Jo7tEb15MJj6sWNq/aID+odazKk2VsQVQd
	+mm0OiVpWmiP3upTNmYOM4ryngYnLpJ6qcvFWWftydhjZXwlX7IceszxrJlfxBHb9kezx49K7Na
	z8MSboptXe3bCUpSYCCXl1+n2kBX9/MLRTi0JQAS9Nrw2CAWomqp+q/34bJfDuZo6NvZSILCEN2
	zQdproc7jvcthtY0P1PVuBK12gx7DVTuUGuAsLav6j5DG0n33xHlC+5g64AUJp9USnA4OK9w0vQ
	XahT8Gzqu3Xq6RE
X-Gm-Gg: AeBDiesUShIHx1uN2aU3Lrgkvw0px6U/YRthXTggnRGfl2DXW45ebOK+sJctpSNknT7
	byqArkouo8EZhrZdn3KUqYiSyLeCXNd8X0ZnuYqCumMQFO9KzaJNsqHJbHs0vY9R2ENuLLE7DKa
	mBEmrxavChSVJYlfmMSzzZLH9q3iSxIR3tx7AoKyE092+daRg0r1+UYy7i6A52GN5TaQe9dpWfu
	FHIhoBiccYpsRuPqU3RXsTgmE/pyDCjgrrYzV8aIalKwOmFn5mZTMaxkh96EWNnzvo0NoE9rJIt
	S1bpQFqdVG87Qj/UAyIKNiVjgU4Bzm8EjPcpQP7LF8K4Er6kmNf3e33xkoTGCPBnlq8Tofmwecf
	I0EHWHXnAwQeeBvj2HsskWMPzZq6jCikAvPbwGcAfUnQbFOxfUr5KLm16evz3qjJltHXpkkEMrW
	HeVSyF51PJMDR8orw=
X-Received: by 2002:a05:6830:2801:b0:7d7:f70b:5b0e with SMTP id 46e09a7af769-7de9a2944c1mr1117368a34.12.1777360969339;
        Tue, 28 Apr 2026 00:22:49 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7de985f0fddsm162604a34.3.2026.04.28.00.22.48
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Apr 2026 00:22:49 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a2c98f8b69so5651996e87.3
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 00:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1777360967; x=1777965767; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sCasQG+ObA0ksGwj1TE+ZQrk2nCjsz6H92qsa+NhxQU=;
        b=eqtPJC+1K8sYMw8yx3Ul7wAxT/gpI2eNlU+kLq/c1025dnMZ4w41zsfmeQV8AtFbCi
         ih8Nt6GEwyfbxoXZroUE0wbukpyiOQ4Np2fkePQWB+2XqZwRuTHOFYiOKfz5LeVbOuXS
         irrdWRc/UhG2Qx+fFLyyESXLciwYqYFI7p0tg=
X-Forwarded-Encrypted: i=1; AFNElJ+RhcHbI1j38JhqGG6KIhJlUDu9/0JMFUT9BzIZwc77DvVV4/a9GcqsI4gxaWetC7M9Q9JK81G/3Me1@vger.kernel.org
X-Received: by 2002:a05:6512:318b:b0:5a3:6d02:846e with SMTP id 2adb3069b0e04-5a74661651emr619577e87.36.1777360967250;
        Tue, 28 Apr 2026 00:22:47 -0700 (PDT)
X-Received: by 2002:a05:6512:318b:b0:5a3:6d02:846e with SMTP id
 2adb3069b0e04-5a74661651emr619555e87.36.1777360966639; Tue, 28 Apr 2026
 00:22:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
 <20260420113846.1401374-2-sumit.saxena@broadcom.com> <a27a04be-6c41-4d7f-b697-b04c4fe9dc8c@oracle.com>
 <CAL2rwxr+7tD1BfxKJCn70wyPT34=sfFMfUNAV63SAW0BxQ-0Ug@mail.gmail.com> <4fa5c202-e884-41ce-8160-f3dcc289293f@oracle.com>
In-Reply-To: <4fa5c202-e884-41ce-8160-f3dcc289293f@oracle.com>
From: Sumit Saxena <sumit.saxena@broadcom.com>
Date: Tue, 28 Apr 2026 12:52:09 +0530
X-Gm-Features: AVHnY4I_Y2zSeEtpWQMNVK9ClUVulz-5YpSZ6l2phD4u8Er7emLFwcXf6uaM24I
Message-ID: <CAL2rwxrmp2J89LZK1srVoSnqayOJ8cfiEiHYUzzyyqwNMT-v=w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] scsi: scan: allocate sdev and starget on the NUMA
 node of the host adapter
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com, 
	James Rizzo <james.rizzo@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000001db5b80650801946"

--0000000000001db5b80650801946
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 1:57=E2=80=AFPM John Garry <john.g.garry@oracle.com=
> wrote:
>
> On 24/04/2026 12:33, Sumit Saxena wrote:
> >> For the actual shost allocation, we still use kzalloc() in
> >> scsi_host_alloc(). However, shost associated device is often a pci
> >> device, and we probe pci devices in the same NUMA node it exists, and =
we
> >> try NUMA local allocations by default, so nothing is needed to change
> >> for the shost allocation - is this right?
> > shost allocation is not an issue, I will drop changes related to it.
>
> But you have not made any changes related shost allocation and I am
> questioning why.
Yes, sorry for the confusion.
>
> Further to what I was saying, even though most shosts are based on PCI
> device, not all are and I think that it is worth making this same change
> for shost allocation.
Ok, I will add similar changes for shost allocation in v3.
>
> > The tests indicate that at times sdev and starget are allocated to
> > remote NUMA node.
> > So, I will limit these changes to sdev and starget only.
>

--0000000000001db5b80650801946
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
MjAyMwIMdI2Nfq/Vk8dzZMUnMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCAzTlJQ
YNTJM70HIKQCX6DcAw3sV6rERomQr84S9F83cDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjA0MjgwNzIyNDdaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAA/8LX1oU002tUIr5hRJZh563wxboTOjui3Cu3YrUl
xusGqQ73zO9Vlq1gSOWhFMdJi2W2AcDfHbwkercgAuLDNTc5qZGaTFXaTZgXpB2cEtOTiXnehEcr
udhtbCNQyKCjX3/kSOMBvd2WRJ8+cpq5qvnQn36H7ppt415p8m+tqR5KRx57o5Lw+xM7pczBZ5SX
DCHlEAlM2y6ghQBC6izmxgfIi6lO681ZtaZpgHydJn+hVVV7m4zbhuN+XPyWK0gCl0+sDsFWghXq
tQ5p3rrUGiRkfdDHckBhJA0l1/eUrXWLEeZgMRc3d7hpciu4e4KJO3RYh6uoOtcHWlgLqDmo
--0000000000001db5b80650801946--
