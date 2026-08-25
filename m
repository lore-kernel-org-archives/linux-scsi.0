Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0187F402442
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659966; cv=none; b=FclT2yvtlgb8soG5yNgE6rGx11HQxEHO6e6GLoOXYbS9XRSLHBxd6C/IGzXnmk48rKhTSGXpY8aOKz4zsWoefmSosX2EZUPQ26TE1nEfLSCrkMu3/7bUlih2JvjhVUNYnmkGVVo+Ao561iNs/+fpyY4dPw6Hca16BSJMMRckFvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659966; c=relaxed/simple;
	bh=RDYGuDX3saZE4VAjJf44eQqDtgB5VJZ6R6escmozeT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T8IBLSHihFAw0JchD2cYbSn/izKDsLo7U6vWjfo77v3HRahKwAxw8gxN/TZlztHqV0p79si7BGpUvhsmeLUylmBt4kYSIkB5DIKS1hYiGFLX/UBcpCIRpuMhAlk7bfBPlsswvALvrFQjKhwCG+mILPn46131Rs3BqRht3wNsFO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fNTjWYTF; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fNTjWYTF"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso3537812a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787659938; x=1788264738;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=P6SDOF27+ItoER+n2jjmZ821V02dhA5auVq6hlCQPGY=;
        b=nI2W9QrPg3ZMnrAw1k2YfJlBzJ8HfTjBixSMyko5+f9V0wEyc4hDM1PYMARa+bCgrG
         H2p3EwmNUv88v2eI4h6PdZwcVxeAkYn7rVoRq1AFTs9Z5nvwwYd05snwptj+0wJSHEQV
         y+18C1bgX0DpgwqTd87FfR5RlGUjD7kzKTOu7ZOz8BEhxsDhTbzzMpRFn2t2dYgTDhPM
         fDEbdD9tKKyMDHiuTXp070USzyomXOvzompdUUXpC8QhKncxa+yGyLVUrdgtjoYtD+ty
         VW+AQ0gLojZPa+0mhx56b7qcN1mgcWQPD6/mi1msLFvJN3CL2LwMq4/tKBMefsTVKIGq
         jyuQ==
X-Gm-Message-State: AFuF++lvt6QnkJa+3JRqV6YwE/lm9b8O5sG3s+ERWKvHTPPISJA8iWox
	uglqP9ybYoEChgoOCzIrZD8qBNLx8BpDmy4mI0AcIdL8Q1kGWeoKjfvZBLRcv6Pa5fdqNHRQFdd
	V1gOF+/6ZGDszxwQEh/II82OxgCSiJbG6hLboJMySpO5ZPXOoAA7+rNwx2nd4wBpMaDxODQVVHd
	jT9uOgD3sgbGFhr7Rn6Geod83eqRY0vrnkj+NH7FTikcnPJEf9c2kJCEbIaIez6xZTbX01kOHfu
	wYdqpln4mnZKuDlMedBGKR6
X-Gm-Gg: AR+sD126hD8F3AKMbMu7gxnE5fevvRb2IkVWTLkk294qp/oKsp8385ODLvh2A+P/F1b
	FS8wNwqJoAlr5sYCRSnQXc0HPAHLa8j3rXMYI2J4U8CVb1H5VqVc1sCu6G2Uks/IytKrNypWssC
	PaZZMuzl/J6FK21m2EwmsLn275C/g16lAwu91zYW5MBFRwwR1OenbBI82rOsac7i3MJzCyEanV6
	JIqnlpZWROuM7N4PHuUpk52R0ORbGuir15MaomuLEmSzmmv96GO68+zAmn0hkvO11oVVuiyNUTT
	TRLj+EXlChnL+k1iuM6gKg4i/kR0gNPgRXQiExOQWbfHfkAV5Z/47xVZRlrHzWkH3NE5dwEEKGX
	6bOeArGUl/hKj7OWafsuZLOXB0+FKQBdFW9vUAHpMKl2UeHlfgmbzYS07DcuT5676oekEiVx7i+
	hRmC7r485WXonceyjMO8PzF4fqs6J6R4dh4Skw249ZrQoplA==
X-Received: by 2002:a17:90a:c890:b0:38e:5b59:c2ff with SMTP id 98e67ed59e1d1-396462ff43cmr13622070a91.3.1787659937904;
        Tue, 25 Aug 2026 05:12:17 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39645a92f58sm1253530a91.5.2026.08.25.05.12.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:12:17 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a5c483cdc7so988067a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787659936; x=1788264736; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P6SDOF27+ItoER+n2jjmZ821V02dhA5auVq6hlCQPGY=;
        b=fNTjWYTF0bwR0qRs8Lf2V9/yHORhTYsh3k1y3eHv/ufzuAjvOdltkBsTW6529OP66H
         9K0Y+j5cs5tz/NVt2ad5XWQBCuEBSl3SiXKC9hk5iI8BAlfIdk2aAFUlf88YB92TLVmD
         8TT4dej8xT5MiRfzTUoSAiHk7PTiDPFSlI0cg=
X-Received: by 2002:a05:6402:904:b0:6a5:d8f0:dc12 with SMTP id 4fb4d7f45d1cf-6a5d8f0dd65mr1013514a12.14.1787659935924;
        Tue, 25 Aug 2026 05:12:15 -0700 (PDT)
X-Received: by 2002:a05:6402:904:b0:6a5:d8f0:dc12 with SMTP id
 4fb4d7f45d1cf-6a5d8f0dd65mr1013401a12.14.1787659935076; Tue, 25 Aug 2026
 05:12:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-10-chandrakanth.patil@broadcom.com> <20260818181837.C92C21F00A3A@smtp.kernel.org>
In-Reply-To: <20260818181837.C92C21F00A3A@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:42:02 +0530
X-Gm-Features: AcwNN1VEesFIQdThk6uaXBboA13wMzC22B1ZfOrGv5ksv9EjkYh1t4IpIPJFo9I
Message-ID: <CABvwm=ORbcCE1h8pzm8zVmXP3h-YaPsPaLRxoYXzwNhnwp0zPQ@mail.gmail.com>
Subject: Re: [PATCH 09/17] mpi3mr: Fix target device reference leak in device
 removal handshake
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000007b9ea60659de0393"

--0000000000007b9ea60659de0393
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:48=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Memory leak of tgt_dev reference in mpi3mr_target_alloc() error =
paths.
> - [High] Memory leak of tgtdev reference in mpi3mr_get_port_id_by_rphy() =
when hba_port is NULL.
> - [High] Memory leak of tgtdev reference in mpi3mr_sas_port_add() error p=
aths.
> --
>
> --- Patch [9]: [PATCH 09/17] mpi3mr: Fix target device reference leak in =
device removal handshake ---
> commit d4f3aa04629aa5ef9b7db8bd5ef68d81cfceef82
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix target device reference leak in device removal handshake
>
> This commit fixes a target device reference leak in the device removal
> handshake. It drops the reference acquired by the device lookup once the
> state has been updated.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3=
mr_os.c
> > index 7ae4b4fad3f4a..b18e7ea873030 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -2522,6 +2522,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr=
_ioc *mrioc, u16 handle,
> >               tgtdev->state =3D MPI3MR_DEV_REMOVE_HS_STARTED;
> >       spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> >
> > +     if (tgtdev)
> > +             mpi3mr_tgtdev_put(tgtdev);
> > +
> >       if (drv_cmd)
> >               goto issue_cmd;
>
> [Severity: High]
> This isn't a bug introduced by this patch, but since this commit fixes a
> target device reference leak, I noticed a similar pre-existing leak in
> mpi3mr_target_alloc() in drivers/scsi/mpi3mr/mpi3mr_os.c.
>
> If the validation checks fail, the function sets retval =3D -ENXIO and ex=
its
> without releasing the acquired tgt_dev reference:
>
> drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_target_alloc() {
>     ...
>     tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
>     if (tgt_dev && !tgt_dev->is_hidden && tgt_dev->non_stl) {
>         ...
>     } else {
>         retval =3D -ENXIO;
>     }
>     ...
> }
>
> Does this cause a permanent memory leak of the target device structure?
>
>
> [Severity: High]
> This is a pre-existing issue, but there appears to be another leak in
> mpi3mr_get_port_id_by_rphy() in drivers/scsi/mpi3mr/mpi3mr_transport.c.
>
> The code retrieves the target device and takes a reference, but it only
> puts the reference inside the condition block that checks if the device's
> hba_port is non-NULL:
>
> drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_get_port_id_by_rphy() {
>     ...
>     tgtdev =3D __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc, ...);
>     if (tgtdev && tgtdev->dev_spec.sas_sata_inf.hba_port) {
>         ...
>         mpi3mr_tgtdev_put(tgtdev);
>     }
>     ...
> }
>
> If a device is found but its hba_port is NULL, the function exits without
> releasing the reference. Does this result in a persistent memory leak?
>
>
> [Severity: High]
> This is also a pre-existing issue, but does mpi3mr_sas_port_add() in
> drivers/scsi/mpi3mr/mpi3mr_transport.c leak a reference during error path=
s?
>
> When adding an end device, a reference to the target device is acquired. =
If
> any subsequent setup or allocation fails, the code jumps to the out_fail
> label. The cleanup path handles freeing the SAS port structure but seems =
to
> bypass calling mpi3mr_tgtdev_put():
>
> drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
>     ...
>     if (rphy->identify.device_type =3D=3D SAS_END_DEVICE) {
>         tgtdev =3D mpi3mr_get_tgtdev_by_addr(...);
>     }
>     ...
> out_fail:
>     ...
> }
>
> Could this leak the target device reference during port addition failures=
?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D9

Thanks for the review.

New issues:
- None. This patch specifically fixes a target device reference leak
in the device removal handshake by calling mpi3mr_tgtdev_put().

Pre-existing issues:
- The other reference leaks pointed out (in mpi3mr_target_alloc(),
mpi3mr_get_port_id_by_rphy(), and mpi3mr_sas_port_add()) are
  pre-existing in the driver and will be addressed in a separate
follow-up patch series.

--0000000000007b9ea60659de0393
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
oIHHMC8GCSqGSIb3DQEJBDEiBCAHy4+nQjn39JVqAbyj5v0IS8/o0a3Z8rdEtC4g8o8PJTAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjEyMTZaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBczEYcQqRW
Las/cR+VvuYXLtT9jU5H6FMjY5j7VCIH5bmoscoZm6aBnf0YeAiBcZ3Scd1bJlN1gFa36r9PAXxM
Kdj7+kdmBzR+H2NhhDW1ABoZNClHcppRctiyLPoHS/6vdjYtgsQrWUepPtfJlF/r3Zm/tYNxVfER
aJPqB9L/mj9kg38PoktWezy43cpAC7HBGlpMpu2jbUczD9IYH+LS52+47Jmd77nIfZHKf6mu53tg
fmvkqN0qkKjkTOyO4w/BZzsM6+ObnMmDYQZsSkLt1wFkXhzzBgMT+IwtU7th2B0Uv2kvZDLn29ao
2isDsZMRCy8x0GPfcr+Wq5lr1S/m
--0000000000007b9ea60659de0393--
