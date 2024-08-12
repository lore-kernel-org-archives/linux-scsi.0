Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1533F9E8
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2024 15:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723476673; cv=none; b=B2aOGXDLpmOfqnmYgAqUokuglNDkfwyd6SmKXjWQRnanXSWf1tzkszeHwlukNky56EG/xuomCuYGGjWGqP5b4Vwo9Vh6qM8YM5ZgLxPVB9ThTjnZ1PDxxm1sOAivYiNvy+d1mgde3AERfDaDx5aYB8tQI5hrCjgal5bB4zhTSOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723476673; c=relaxed/simple;
	bh=PJ87ZpMSdZPez8j5qM101mJvIEWnLh2m8xHAf5it33E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hf/oYl8fCACprE6Arhzlma1zV58v/CR7G4jq0QgoypGkVv8FhykBzc01rXW2OmdIFw+hvch+XDkxzqkUSTouGl92B6YxoOYYzDH5YM6XCBo3oaZtr7uIwVKAoPqe82dAfsGVOgRu3lllClnqeKfePJ6e/MUy+I/2yTgCgGUtaVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CQBPegWv; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CQBPegWv"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ef2cce8be8so48503861fa.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2024 08:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1723476670; x=1724081470; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zUO+rsDbVAAq3OUOWZzI2Wf8rpoSPqve0lBI1WU0B5w=;
        b=CQBPegWvinwyp7cPfRBMQg09nOIWIiMT41E6z9NCPezuL8jf/bjOaVuU7SGoabGEMB
         p4eYRIetOatCOeGdM9Si3lNUkSWUT5kkzCBfadZTPm3K7EcdbK/RAPLYQA+YJ5O+CoHt
         DyiGab40qz0tgPd+CQHod2tbbyA7g46cfkcwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723476670; x=1724081470;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zUO+rsDbVAAq3OUOWZzI2Wf8rpoSPqve0lBI1WU0B5w=;
        b=gmWt1hOrbwDqcF/vX2m8cEmiiDPBtopO5j42i28vBXXsn+IMPLqle2un2xmviRfnbP
         bhY2UlLH/19RUhGiAIVAwIbO3jYV+MmDsHyEdIXMuA6MeoNvdQxtC7SFVKoXkmV+Idoy
         YZApmvwaDPRFzAb8bdmuCoqvNPAjDiQBKIFgmfRIpLcbLuAmjpYwj/8Aec0qE0DvJj7+
         RCBKkia4u4Tz+ueX+R2whq3iav1+Bfas1zDat4ouyaYIyLDEEHFrvMAubPusfbrXrGiT
         4NUUWAlWh25HTz1DyRb13uvUjNppY6rgrAAEB0FQdt16B+kmLo/rnCBYEfNGg1/162Tj
         0Ocg==
X-Gm-Message-State: AOJu0YzJyIf+K/tHsKzcqlBk6CWlkIY3X50HRxTbSnBGTU43kj+mpUM/
	b5GD0nQyApU53zsYJtEUuzqevfTgRpfnhWyEdkXRYdjMRJg+fIbHjFLNOYxmi9vzDYMgAiNoIIA
	hjjVtxHTu5kPJwfrnykID5FA58b1k+epZ/kA=
X-Google-Smtp-Source: AGHT+IHC048r2FFZ2/hYHkWeOOn3elNgSJwhvezEX2uQ0bOu9WD9d+sU9lYgX806eBbqQ7hd5+Kfujg53yieBi3XD9o=
X-Received: by 2002:a05:651c:1509:b0:2ef:1d8d:21fd with SMTP id
 38308e7fff4ca-2f2b71463f8mr4896481fa.2.1723476669188; Mon, 12 Aug 2024
 08:31:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com> <20240810042701.661841-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240810042701.661841-3-shinichiro.kawasaki@wdc.com>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Mon, 12 Aug 2024 09:30:52 -0600
Message-ID: <CAFdVvOy61KkOmcU0mQqfOh3BOxAt1cb-wPO8GpLukWFopo=iaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: mpi3mr: Avoid MAX_PARE_ORDER WARNING for buffer allocations
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com, 
	Ranjan Kumar <ranjan.kumar@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000b57cf1061f7e2e8d"

--000000000000b57cf1061f7e2e8d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 10:27=E2=80=AFPM Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> Commit fc4444941140 ("scsi: mpi3mr: HDB allocation and posting for
> hardware and firmware buffers") added mpi3mr_alloc_diag_bufs() which
> calls dma_alloc_coherent() to allocate the trace buffer and the firmware
> buffer. mpi3mr_alloc_diag_bufs() decides the buffer sizes from the
> driver configuration. In my environment, the sizes are 8MB. With the
> sizes, dma_alloc_coherent() fails and report this WARNING:
>
>     WARNING: CPU: 4 PID: 438 at mm/page_alloc.c:4676 __alloc_pages_noprof=
+0x52f/0x640
>
> The WARNING indicates that the order of the allocation size is larger
> than MAX_PAGE_ORDER. After this failure, mpi3mr_alloc_diag_bufs()
> reduces the buffer sizes and retries dma_alloc_coherent(). In the end,
> the buffer allocations succeed with 4MB size in my environment, which
> corresponds to MAX_PAGE_ORDER=3D10. Though the allocations succeed, the
> WARNING message is misleading and should be avoided.
>
> To avoid the WARNING, check the orders of the buffer allocation sizes
> before calling dma_alloc_coherent(). If the orders are larger than
> MAX_PAGE_ORDER, fall back to the retry path.
>
> Fixes: fc4444941140 ("scsi: mpi3mr: HDB allocation and posting for hardwa=
re and firmware buffers")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>

>  drivers/scsi/mpi3mr/mpi3mr_app.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 8b0eded6ef36..01f035f9330e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -100,7 +100,8 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
>                         dprint_init(mrioc,
>                             "trying to allocate trace diag buffer of size=
 =3D %dKB\n",
>                             trace_size / 1024);
> -               if (mpi3mr_alloc_trace_buffer(mrioc, trace_size)) {
> +               if (get_order(trace_size) > MAX_PAGE_ORDER ||
> +                   mpi3mr_alloc_trace_buffer(mrioc, trace_size)) {
>                         retry =3D true;
>                         trace_size -=3D trace_dec_size;
>                         dprint_init(mrioc, "trace diag buffer allocation =
failed\n"
> @@ -118,8 +119,12 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc=
)
>         diag_buffer->type =3D MPI3_DIAG_BUFFER_TYPE_FW;
>         diag_buffer->status =3D MPI3MR_HDB_BUFSTATUS_NOT_ALLOCATED;
>         if ((mrioc->facts.diag_fw_sz < fw_size) && (fw_size >=3D fw_min_s=
ize)) {
> -               diag_buffer->addr =3D dma_alloc_coherent(&mrioc->pdev->de=
v,
> -                   fw_size, &diag_buffer->dma_addr, GFP_KERNEL);
> +               if (get_order(fw_size) <=3D MAX_PAGE_ORDER) {
> +                       diag_buffer->addr
> +                               =3D dma_alloc_coherent(&mrioc->pdev->dev,=
 fw_size,
> +                                                    &diag_buffer->dma_ad=
dr,
> +                                                    GFP_KERNEL);
> +               }
>                 if (!retry)
>                         dprint_init(mrioc,
>                             "%s:trying to allocate firmware diag buffer o=
f size =3D %dKB\n",
> --
> 2.45.2
>

--000000000000b57cf1061f7e2e8d
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
8wQJuWG84jqd/9wxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHaiq6RK
TOSF17CNexrZb8uyQODWaVEBKEmv0CSz+gCrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI0MDgxMjE1MzExMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCEzUdMAbt7FfY65XbFQFCCVVdQ
9azziVw/mV4SW07AxoAqEDGFWp3g4dtjOla496PgIRkC0cWiXYyYdTXdN399bQ0sHDo1IAq29pwj
wMh5vKqgqp08MClR28L/7isR13bPADENapU8Q4CiOOqx4i8jkF11N7NpiPE3vl0p9FdkqfIxMoKR
Z56DPX5UnJ+IMU9c4f/zY9QhzbM34j0pdC5e7r1hcVQ8xeOCk6tR/lAoHK1Xj8A5l/RP3i9p0xfO
Kvd8B5v94jiyv11okUBBWRBdDG2JYUIhKnLrLQ4m/8vAimfdrVGzdlp30DRY22aLUualcKOxHdSe
4FTNrw/9IjQI
--000000000000b57cf1061f7e2e8d--
