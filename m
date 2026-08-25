Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414C73FF8A5
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660343; cv=none; b=ePCsF0mUdIDjDbve8r6ylERXwKI57UOYiCjeyoxu5+SrUkym37sKdvZBLz8hi1PekCCpuJOdrnJTPEBF3wiLyvockYnHt7WEsUqTs9IzL/yLe/OkRe73u9YtQNK6qA/bIWdKwDnmr+Y2mu4Ue9QU1E8RTWqmauTslJLEScVeEcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660343; c=relaxed/simple;
	bh=36mKIjqZJRLMQZi0zKfwUj1PH7igk64eNJGJLwUAaGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uKFDzKmshhkPMwnmVs3lw7yy7+lPj4bKE7R/uSF2AToDrC4gG24SGw28Q7+3DNCBhCMgwDF9dV+zTpkVmj48cqJlasEY5eMVk5JH3qi3fZbUY8pVqtm9rGD6/Srd1wy2kqDEYcZADoZ5YxHhbqwlJeXyDhJl/bCgC48/yT7Cm+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=T5wSUe2I; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="T5wSUe2I"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso3207070a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:18:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787660337; x=1788265137;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EWknq6+Vvre7ycyzJHEaXu7Zn/EmTTFqTUaMwJXgjFw=;
        b=Y+n0aN/Mo9nEi30QyYLZ/xfbrY3IpPAi+Jof0ZdkVntOMFt4l+F7L19AAa4eaINgrJ
         mA6UHLA4v0zfYREzEh4Hun6ZmmBTEb7zktES02IzQ6MGAM7Tx6bp04XmUpLpX/rZFV/E
         VDfbnIHZpCeWFGmBWcdbLiWVIVaaguFPZm+HQaqsCeEt6oQW98EegQruLMG86fF6KRNC
         biUlzxWPjoC9lpbW1c3EhqbeuNkjfu2QjkLrMBGLhcs/zfxqWm4hKv6uvTgwlVgay5Ey
         b4ERTqo7L0eUDpGmWw/Gw0jaTDlEMhuvLKyobFMPGR5tTmz7fARnH7UgodNvyD4I/iML
         O/Dw==
X-Gm-Message-State: AFuF++k2eYBGIz3cOqz7UE+uRgGeuJBi82o7k3ujoKlcQQjJF6pNAdgL
	570BsRwpGmM70cJz5skPAEiIX2HQtEiCILwENjVhi4JpmqV+jDQXudDhUAGr7+tODLzYktp0fRg
	DgN1OCQ5xTh7LABvNractOmg1xI5BlQyxHWpdBDSnRVo6KdK8C2Va58quKfSnbS7kv1bo3Q9U19
	Lfd0DdNExOewyldtpkmHBeNuyJkUsHiy/joLd+0qyYUAUIIdBuWJzVUyk7JCehLqDj49ZNo8sNQ
	H8mxyeFUlvBYnFUnnZz2vT5
X-Gm-Gg: AR+sD12ZPE4Z4l7R5/pwN7xwe61zydM6WiGUfbQvOub8PTFA4JAc2xYezpWTcZkqB7r
	CKGguMZAvwLAHwfMZ23ZT92Jqz5VushwbosEH7byHocSjM6BI5ZyXiVYc/yi1mLBr783OZJlC3a
	NVlaOFk+YmU5dCA+YTlFgDFYO2SJSABJNIv1OTstQ54IpzFfx2uyMTFLq7CCaxpchoCrTPTCLng
	nbhsCmNjFpN4JkuhvCilglFIQlL3D5NjnEsp89nzeij8ht247+mD6v2GaT9rIkmk3yWIR1FdxHK
	s8OmfdyoujiPgPdYS1clkvb4iwVeDcnyfMjUu1p9F8CWdLoP8KwgvQ5EM/lPccU+7dafCVCp84i
	egO1FcPWgKkkH3ScqYWwc2af+RhI+n9kv5pZMVs/7q9kXfM/YWcw8ecoEDztGIBLpAVz4YlMWG7
	GaSkNoqapGPtI4Y08ErRc51ciyhP7uyohj8vUQB/ur79g=
X-Received: by 2002:a05:6a00:b53:b0:848:46a0:3d74 with SMTP id d2e1a72fcca58-8520ba16ce2mr43485656b3a.9.1787660336092;
        Tue, 25 Aug 2026 05:18:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-852102693cdsm4823906b3a.2.2026.08.25.05.18.55
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:18:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1f3117bc6bso428794566b.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787660334; x=1788265134; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EWknq6+Vvre7ycyzJHEaXu7Zn/EmTTFqTUaMwJXgjFw=;
        b=T5wSUe2IaX7vR1DrosqSJ9DMbL6I+FdHNZIw07t97gLxqQC7sOUXSMbP19fdDaK1K2
         4TQp/LnQF+CskZuLdBphtu5BqmVapA2hL24ZPtJLCQdzVSwbaKg/ipuFH/Ouda4UMw+9
         m69WLSv3f7uwZQ+1RM8l55RaTLy5wCt2o+XKo=
X-Received: by 2002:a17:907:9814:b0:c21:792:8257 with SMTP id a640c23a62f3a-c24e5ad9556mr685265866b.15.1787660333775;
        Tue, 25 Aug 2026 05:18:53 -0700 (PDT)
X-Received: by 2002:a17:907:9814:b0:c21:792:8257 with SMTP id
 a640c23a62f3a-c24e5ad9556mr685258966b.15.1787660333235; Tue, 25 Aug 2026
 05:18:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-16-chandrakanth.patil@broadcom.com> <20260818182113.87AB51F000E9@smtp.kernel.org>
In-Reply-To: <20260818182113.87AB51F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:48:41 +0530
X-Gm-Features: AcwNN1XkQGQuLfaz-UIJhGXKKDnlqy0-3fcVPcLuKUO5yXgp_qhpfANSELUcxkw
Message-ID: <CABvwm=Nx8Skq+1eTcE09G8byqd_FXnSRZLFrCOdcdALKYiLtTA@mail.gmail.com>
Subject: Re: [PATCH 15/17] mpi3mr: zero out diagnostic buffer status memory
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000003586ff0659de1b02"

--0000000000003586ff0659de1b02
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:51=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] An integer overflow in the bounds check of `mpi3mr_bsg_upload_hd=
b` allows a malicious user to bypass the check and read arbitrary kernel me=
mory.
> --
>
> --- Patch [15]: [PATCH 15/17] mpi3mr: zero out diagnostic buffer status m=
emory ---
> commit 76872b40f16cd1ab1c93f0a03cc6bd1fb6b3db94
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: zero out diagnostic buffer status memory
>
> Memory allocated for the BSG diagnostic buffer status is not zero'd
> before it is copied back to user space. Several fields in this
> structure are reserved and never written by the driver. Use kzalloc
> instead of kmalloc to zero out the allocated memory.
>
> Fixes: 78b506984ebe ("scsi: mpi3mr: Add ioctl support for HDB")
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi=
3mr_app.c
> > index f5b48c95cf055..0cdcb8d236d37 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> > @@ -1244,7 +1244,7 @@ static long mpi3mr_bsg_query_hdb(struct mpi3mr_io=
c *mrioc,
> >
> >       length =3D (sizeof(*hbd_status) + ((MPI3MR_MAX_NUM_HDB - 1) *
> >                   sizeof(*hbd_status_entry)));
> > -     hbd_status =3D kmalloc(length, GFP_KERNEL);
> > +     hbd_status =3D kzalloc(length, GFP_KERNEL);
> >       if (!hbd_status)
> >               return -ENOMEM;
> >       hbd_status_entry =3D &hbd_status->entry[0];
>
> [Severity: High]
> This is a pre-existing issue, but while reviewing this file I noticed a
> potential integer overflow in mpi3mr_bsg_upload_hdb():
>
> drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_upload_hdb() {
>     ...
>         if ((upload_hdb.start_offset + upload_hdb.length) > diag_buffer->=
size) {
>                 dprint_bsg_err(mrioc,
>                     "%s: invalid start offset %d, length %d for type %d\n=
",
>                     __func__, upload_hdb.start_offset, upload_hdb.length,
>                     upload_hdb.buf_type);
>                 return -EINVAL;
>         }
>     ...
> }
>
> Can upload_hdb.start_offset and upload_hdb.length wrap around during addi=
tion?
>
> Since they are 32-bit unsigned integers controlled by user space via the =
BSG
> interface, a large start_offset (e.g. 0xFFFFFFF0) and a small length
> (e.g. 0x20) could wrap to a sum that passes the bounds check against
> diag_buffer->size.
>
> Would this allow a malicious user to bypass the check and read arbitrary =
kernel
> memory when the subsequent copy occurs?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D15

Thanks for the review.

New issues:
- None. This patch specifically ensures diagnostic buffer status
memory is zeroed out using kzalloc() before copying to user space.

Pre-existing issues:
- The potential integer overflow in mpi3mr_bsg_upload_hdb() is a
pre-existing issue in the driver and will be addressed in a separate
follow-up patch series.

--0000000000003586ff0659de1b02
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGpzCCBI+g
AwIBAgIMAgfxQ1Z7DrZKmCE/MA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEwMzUwNFoXDTI3MDYyMTEwMzUwNFowgekxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEOMAwGA1UEBBMFUGF0aWwxFTATBgNVBCoTDENoYW5kcmFrYW50aDEWMBQGA1UEChMNQlJP
QURDT00gSU5DLjEoMCYGA1UEAwwfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTEuMCwG
CSqGSIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAJwyF5qSHwwr1zJWkKvkMnY7V/sVFYYjTpjgxS4XA76pD6eLsZvS
4J73HkKSNEzORxBE7OyZSnuBJ9zeeRcypuItG9YrHm+0OSF0psIWsH15FBYJ0nvsUnlFbCSNvOdr
Co0WJ1KTe/7caj014uRZM2j7zH1vC+9fjEgrJdDRZakZXarl8M7k9okvVj1N+EuHiYUMvsAuMadE
a3p31Z6QdvMpr+30UdJXHshV1mXca+UBpCx26GbY6NgxhHM2LtHiaCK8Vn4HMofDkFg4nQ6eK4ai
uCiTtPj5aNlkdpcCzcZ+j1eCu6ZfPIq2ycwDaHi8d6Dwcgm+XoxDmD97Ehp2FOkCAwEAAaOCAeMw
ggHfMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggr
BgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1l
Y2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2Ny
NnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGg
MgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5
LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWlt
ZWNhMjAyMy5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTAT
BgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNV
HQ4EFgQUyqNnwId/JCbRPslVl3nm48YRek0wDQYJKoZIhvcNAQELBQADggIBAKPmllSh8cRXzNRs
3OATCVDgrdOfIsZMB9UVXcYQ+HtR1fu9bafeyuuupF9gcCmi+onLsANYRKaEDjC8h+V5FMAgm6TI
bww4EFGpWvP/XEVKrpcpMkYNMLw89lagx9ZZDhx9DmfQMI9gG9MPpCkSMEPnJvEs7gqtOo08aL1+
ts10tGfePsHF/I42Da21hJIJ01XN+Z91y//1cJkHwCBvDmoB8gdMXp3g4sjzahTxRZ25BdZB9W+n
0jfWJXFKtp9MYS1SaVo17usfrlTeyaH3zPyDvfAfGoLB5+i8vyVL6wta2vgVpfsL9iwhbJnAIxr+
ljECWkh1weDJw3UnV6nooG1RztnwqbG4eAG/KSCToXgVH9qSDv5S1lve5mvhv9AHzLjGLs+QtMeg
WEdMM4G0PWyibzGgNrmVgKaLjV6EMo/IZW7KjBtvjyKQZhes90D4GyxXv+/mrTo2rruz53+FoSc/
nuyLmg/SxnnZRaf7JGHFvu0IbwkeINwdHynAanOg9AD4zits7k7jjQ0fwIdhCaoRA3ao7PXUL1t8
LfSp/K5DCYsrXNqitPmQaAAGAiG4d4WDxBev6vtoyH7ejLcuCKkxCefrLO5qYnuDHsMNCObdslAe
tMVer+USn6AqB//6EwmqdiLr4o20UQ79jxNFMAEKdwyNkA8mVCVUAtTe3mPrMYICVzCCAlMCAQEw
YjBSMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xv
YmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0EgMjAyMwIMAgfxQ1Z7DrZKmCE/MA0GCWCGSAFlAwQCAQUA
oIHHMC8GCSqGSIb3DQEJBDEiBCCkvFQFQzHbteOogCBf5h9UF0zyzRqqiWGOzpu73nQ+LjAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjE4NTRaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAQjdHv5Qx/
HdMReiJW+IAiJUa9aIyfhOsqjY4KHDeJzXRIl35eINVaqKsRt6AfE5Y9Ao2gHoN271TTE9peOXjR
sewvyC1077HD9CNOYmoCYGL9wbdy0I+PZH1CL7lXD7KMa6fRdsH5UD6KmkoucFMisomqIJXW93cO
BLL/0YFvqdgfpDemtFAOgyEW/q6I/LlKzLVLMO/bah3WIBjpmZkw2JMS0sidINPgrye7hSHXDgpY
zKz15cT8dbEMNfoMjo/WXXbfaoPeUQQ8IX8pLyhnvv0ye6oOQokPMA0lt/tu494jxCE6TopBHDn6
n+kdmNrEBEThYxXSVkyreW2XXBzj
--0000000000003586ff0659de1b02--
