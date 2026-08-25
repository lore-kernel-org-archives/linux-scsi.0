Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2993955CF
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659647; cv=none; b=lvePJ8EaTtOqKAS2wSGU7yvibJG7kK0CrixOLyJBL4n2zdNFJ7AASRZ7+HEchSg/isGqgyT6b7jMRyqpKHwZ/2A3RNAN1/w+8tqaHFEPyCh+BExU6pWKt1bneKq2ILRW4lYuIBbYy3Lc8EWkXwLQdazhZaHlotJdb16+36BYIxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659647; c=relaxed/simple;
	bh=Rb0mzp+6ZwOpG5E+YurH8qA1xdeHuG2ZVvBynh0KLUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sJKXzJyzYsBY5eBdpktL73c+7iKk+m/asDYeyFY7amgVFosv+WaJWMlcklzaFH37bW5kTq2zkBHQhvMTwSMZxtAxk4kGM78kNt8AGUclVhUczVzEG1BctHSWe37ThDDhB5DO7NQx3zbBEIT94AAQnt1ky/Fh02GZQQNzRtcD2KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=O4hPu84J; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="O4hPu84J"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-84874b52eabso5927483b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787659645; x=1788264445;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cUVVOGOtSO5A1+WI5VqLSWYIYI5F6yabeSHIANosSXI=;
        b=be71aExzKelhDQJW6kOKaq6oka8bPIvFk3tEYdWOTVpzI4yuUfz3VcLjn2yoD0FIfE
         D4LrTQYMujUD6WYNlyx3MCldrc62m5oEyjau7MxQhAmL6ch1cj+jVJKZQfHr/P+PSyPi
         hvvInhzv7nKbP3WxYyo6bqeei99JigX5kBvtPWi18HeS/6+LCNmA31J9ujZDYCPYurOi
         HcJDPPaHPP/LzJaO/0DD1W9sD1o9kWu0TnZpUKdhs01oYLQHK82RiFht2sKeK+SGlYW3
         z36/fCRhwd6jDp84seWFjZ6bxo8vsYdepLE0f/r4LH2hriIQ/lRvbA9NHBDJvrhf6JNN
         pUfA==
X-Gm-Message-State: AFuF++mZ4159nu2wkzhSrgO70iWwhwp84XEwt+IE9Tp+XA3lpf+cfHka
	q3Eu0s29KKgRU4/+bUmAVSYgyLzofKuKuU5ez4epr6OPizIyVLQwyhsjlTSVBzy56nKeHsmUp4/
	GVLI6xxCCVsK/O15I0fsB7ogzAaQBNiOqdJ6qg36Z0eGXNiW0uurrf7mTYiRQBWxNocfD+dsZ/V
	8Iee6tRV8MSmDiJB9tMbeoCvAMTGPYJJWsCbQ01gpUNHkg4m/oP8Ot2XN+xPlJfa6EThQJ02yM0
	M/3uQXoSG2N1Gkd6G47xgfn
X-Gm-Gg: AR+sD13C05fz94MnRXVybhVs7ssuVsg+eVHUmkxjYsbWW305uOg92rnPy45G8idfquP
	GVVJPBuXz+aE6xhiRUSmsJZqiypTOpLYb8kJATr+ErHEioGUtpHTLL5VjedJogwZ7VJPrPW3bGG
	i7sICZyuXOZ5BEyiwhYMnGZt6QyPnwCOO9WPQP9K5CNvfoslI3cQ+E7/+485FKCxJL1muriYQZt
	T94ZAUB+Ex8NjyXCS7GP/Gq54WlB9ulGYpFRwfE65yjABKOLQtgXzbWigOzf2jDCU+9DWVyus0F
	ZT97PED8c0mzw2IMhxHzqz041qB8FMlGfM/RjwfLvFGstXCMWlcRh2lrQ9s83O05nT8ntT/aWsm
	dMAMbpV22ELghrtRWujnUNiGCrX492aeW8I+Gnwe+aD/2TDynKI+FgTVvBodE761nwLfynRLbE+
	/8T4Cm5G4MXohebh9kxnNFjHV1KayOzOBO1TxeWHehRzY=
X-Received: by 2002:a05:6a00:340f:b0:848:8715:c2d9 with SMTP id d2e1a72fcca58-8523c7f0d5dmr12993985b3a.2.1787659645166;
        Tue, 25 Aug 2026 05:07:25 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-85210950706sm4892014b3a.4.2026.08.25.05.07.24
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:07:25 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c16711b9473so397635366b.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787659643; x=1788264443; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cUVVOGOtSO5A1+WI5VqLSWYIYI5F6yabeSHIANosSXI=;
        b=O4hPu84JhKiUyVyd5+EcFEWNxvYMf2hx0NKF+kwsbQBO4VATdIdgAEpLGs74Sub1yo
         9nbesaK1ZBjQx2ADblfM+a9s5mG50bzneO7l8h3kkCebuMksDhQKT8JxNveSj8QDjlCq
         +RBBXJlypBLHM9C5krsnZjZMnA6EDAOwV1ow4=
X-Received: by 2002:a17:907:e008:10b0:c25:254:292e with SMTP id a640c23a62f3a-c2502542c16mr165074766b.0.1787659642924;
        Tue, 25 Aug 2026 05:07:22 -0700 (PDT)
X-Received: by 2002:a17:907:e008:10b0:c25:254:292e with SMTP id
 a640c23a62f3a-c2502542c16mr165067266b.0.1787659642359; Tue, 25 Aug 2026
 05:07:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-7-chandrakanth.patil@broadcom.com> <20260818181106.04AE11F000E9@smtp.kernel.org>
In-Reply-To: <20260818181106.04AE11F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:37:09 +0530
X-Gm-Features: AcwNN1VRRyOKEi3sH19OogBOfQbFXj8_CujrPRUzOrQeAoUuS1fdYkbdo9yCdd0
Message-ID: <CABvwm=NMKu4P-Hxj2P=R=K3yRgNABVTce+tQkpE_dDs2FG0fVg@mail.gmail.com>
Subject: Re: [PATCH 06/17] mpi3mr: Fix out-of-bounds reply frame access
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000000572a70659ddf2c1"

--0000000000000572a70659ddf2c1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:41=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [Low] The newly added modulo operation `((phys_addr - mrioc->reply_buf_=
dma) % mrioc->reply_sz)` implicitly performs a 64-bit division, causing a b=
uild failure (linker error) on 32-bit platforms where `dma_addr_t` is 64-bi=
t.
>
> Pre-existing issues:
> - [High] An integer overflow in the reply pool size calculation allows a =
malicious or compromised device to trigger a massive out-of-bounds DMA writ=
e, leading to host memory corruption.
> --
>
> --- Patch [6]: [PATCH 06/17] mpi3mr: Fix out-of-bounds reply frame access=
 ---
> commit 144f6c8866bb0bb9ede9699c897280faf1028d42
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix out-of-bounds reply frame access
>
> This commit tightens the validation of reply frame addresses by requiring
> the address to be frame-aligned and ensuring a whole frame fits within th=
e
> pool.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3=
mr_fw.c
> > index 681868716ebdb..5e61448d8dbc6 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > @@ -128,7 +128,8 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc =
*mrioc,
> >               return NULL;
> >
> >       if ((phys_addr < mrioc->reply_buf_dma) ||
> > -         (phys_addr > mrioc->reply_buf_dma_max_address))
> > +         (phys_addr > mrioc->reply_buf_dma_max_address - mrioc->reply_=
sz) ||
> > +         ((phys_addr - mrioc->reply_buf_dma) % mrioc->reply_sz))
>
> [Severity: Low]
> Will this modulo operation cause a linker error on 32-bit platforms?
>
> Since dma_addr_t can be 64-bit on 32-bit architectures (like x86 PAE), us=
ing
> the modulo operator on it might implicitly perform a 64-bit division. Thi=
s
> typically results in an undefined reference to __umoddi3 during the build=
.
>
> Could this be avoided by using explicit division macros like div64_u64_re=
m()
> or similar?
>
> >               return NULL;
> >
> >       return mrioc->reply_buf + (phys_addr - mrioc->reply_buf_dma);
>
> [Severity: High]
> This is a pre-existing issue, but does the reply pool size calculation in
> mpi3mr_alloc_reply_sense_bufs() suffer from a 32-bit integer overflow?
>
> If a device provides crafted values for maximum outstanding requests and
> reply frame size, this multiplication might overflow:
>
> drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_alloc_reply_sense_bufs() {
>     ...
>     u32 sz;
>     ...
>     sz =3D mrioc->num_reply_bufs * mrioc->reply_sz;
>     ...
> }
>
> If this overflows, an undersized DMA pool would be created. Later, in
> mpimr_initialize_reply_sbuf_queues(), the driver loops over the expected
> number of buffers and writes out-of-bounds DMA addresses to the hardware:
>
> drivers/scsi/mpi3mr/mpi3mr_fw.c:mpimr_initialize_reply_sbuf_queues() {
>     ...
>     for (i =3D 0, phy_addr =3D mrioc->reply_buf_dma;
>          i < mrioc->num_reply_bufs; i++, phy_addr +=3D mrioc->reply_sz)
>         mrioc->reply_free_q[i] =3D cpu_to_le64(phy_addr);
>     ...
> }
>
> Could this allow a malicious or compromised device to trigger out-of-boun=
ds
> DMA writes into host memory?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D6

Thanks for the review.

New issues:
- The 32-bit build issue is valid and will be fixed in the v2
submission. switching to do_div() for alignment checking to avoid
64-bit division issues on 32-bit platforms.

Pre-existing issues:
- The reply pool size calculation overflow is a pre-existing issue in
the driver and will be addressed in a separate follow-up patch series.

--0000000000000572a70659ddf2c1
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
oIHHMC8GCSqGSIb3DQEJBDEiBCBDJ5XJ89IBzL1OjVZHFDAyAk7jF4U9INPCWSGsiHBYmDAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjA3MjNaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQACMkZ3zx8M
DelULhFCenbtVc1uT3e4uZbvkgpc2PhyRGv6s8eaOorKRuVHBJshFjRgQNVgQxNGS+Mm+ZUn2OyS
1B6tDc6ueGUkn8JOs85304NTX0dKo5juK5sUxrakrGDC3zVRESz9VcO/8/I85lSUKFzFLD0uHNXU
FYXreTMp43QXsXyunQx+xzx0n/nzAc2LIiDCGqTiSItkdty8iQAJekfIffYZP7OxZF9BVnsXEbyH
UnKvHWI6Ha7pTHy913vbvK4IkILZLyYovoKEnu1pyqukVXNYAdQQjXnIzJ4hITzFs625+hfCl0X1
gN90pkn/SseUqSVUdUR6o6lj/x7B
--0000000000000572a70659ddf2c1--
