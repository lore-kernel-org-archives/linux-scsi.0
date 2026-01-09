Received: from mail-oa1-f97.google.com (mail-oa1-f97.google.com [209.85.160.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66663033E1
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 23:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768002305; cv=none; b=iDcbpp5OcrHm/zQEcjGJU6cbq6hU1B2IXZ7hmDV7CL6SoVL3l/2BZbgWKlNKoNJ99dfWP1RafAaCHgDklcm4bQxTtmcn9pH1tR08Td9xMPrpk6FxSHDwhAdxmyneoYiPQp5jzqeGRGw6s6MIs0k3pzjZuLksuMezuib40EAGGV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768002305; c=relaxed/simple;
	bh=L0RF7aH2Oy0IAJwCigt294RWPSjJd4G913yVpKp8umo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cZshD6xybzYqXwL5SxSIu9nsq2Smv2Rn/HS0YfMjUxPfhhgOscQkHS8JWcX7a+pKxDsDo4Z1N3fhQ/rDi/AqGvmGTunkyayqWxH0ncj2cHLI20j227kHJaVWtcaYjgrSFgQWVEPrX7EgauKgbr5zAkeRJw2/hHUUGlOqFfMB47c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=TjIvV7Mb; arc=none smtp.client-ip=209.85.160.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TjIvV7Mb"
Received: by mail-oa1-f97.google.com with SMTP id 586e51a60fabf-3ece54945d9so1792759fac.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jan 2026 15:45:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768002302; x=1768607102;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOgHmhcwKZxYQxiG5tMnzbmrhve1b+VRedxnj4RiCtI=;
        b=BB50zT7WU29uGQs8qKNYE2cp4XYkGn/G+H7lA2KJIiXxXdU5dGcoPrOC7BlpLMLMV9
         DlzBV71kvCbvyaLWByGzSvzqnpgI8JKk5e28jKhzDmVFsfIA5BUFYZDlWPV08QoyiS+M
         9MPMWgvXcBNk6Nbw6rWO5qaiEohLjVmpz+OuKfeOdjvvhHOcNsdnttp9ACUydUdxDQP7
         mxV+e7H10OhcUy+O/IHbzLC7wS3QVIPmhptLHlRBy6W8zhKGFMSqlJ42QuLKWOhbujwl
         l6S49L9SNOeFByS9AZC5cTUc1sN/x539dzV+J8KrgYAf6A9oWrdtjVnossoe2ntv2oyE
         KYFg==
X-Forwarded-Encrypted: i=1; AJvYcCWX21JFkOcn0r71Gcao1Xxxe6PbBPSo/u9L8WBGfcNvNk7B0mOOACTqb62HNnQls4qv9+mZ11h97d7+@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5djy1OqDcWq8oOBJ3mfyQ/MUSTPRUZL+PBG3FQhLS3BXLiDTG
	tCKbgct4AIoDgd1f2J4GWGG9bbzmNpVH+KVamX0adU0F4bfEz1d5q4v9p7gu9IxRkN1lbQZ20wW
	TTC0XgC9xZlMKoq6qp5TCKw9a2JyGroiAZaDZ1uPDeIB7ll1KkquWJ7nCXcKS/ctXqvVWvhQFrz
	R7uI1BjVdnHWCEuNdaLkGLsRogstB2YIy+/xvffB3cvj4uf6lZTRFZnxBlGoZu2Yx4ztOTG+2GJ
	REJGdsGU6itS/J8MQ==
X-Gm-Gg: AY/fxX66vKwTd6mzzpYn9OHJyvxA79yKvPpTGeCDCSeO8WyzzkOOGY20gprC26vHlPk
	P5wJWUMtx4zxxsuei5WHkuC9+AUJUuY88clYiWjX8qFgkizHTBSdZt5mmjECmroMoJBp6RxhXz0
	MYASZPZ7uBsfS4VYmidN69gnPp6nBRkzVr1OppdZ8FTcPQfIviBSPX7yrI62oIQFO+jrrCalWYg
	AGehuXw+F9FxuW0lBgv4PkmRUzMTqOrlNuQVK9fZdmpahPItkhRTGS52MbNn5PJctRp5FHvDSZR
	m+JDZ+ugZ0udmBgek5Q69QHqLaXa5XfDlinBZLynrp89eh8zUp/LYhmW1+S0u1V791bzSivbS7E
	rUEkN3fEOISSgr+nvUY2jmxW4/pQLfomJ1gt/OR8gO2cS6qrOWaaFw8LX1Cf/eC8EGeQnw4hAYS
	1QMqQBvN2JN+jRO3jpulMNAkBp2l8LF3RQJLYbF55TL4Rp4Enh
X-Google-Smtp-Source: AGHT+IGmt5QQ7SGakCx44rUbyp/PePJnPywap3wSioT/WLofcLz0INPK2G0y+ccnG6VLk1hsWTFEUER2SdH0
X-Received: by 2002:a05:6870:239a:b0:34a:605c:58d2 with SMTP id 586e51a60fabf-3ffc0bfb742mr5324950fac.47.1768002302312;
        Fri, 09 Jan 2026 15:45:02 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-3ffa4a9e3bdsm1320527fac.0.2026.01.09.15.45.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jan 2026 15:45:02 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38301605df8so19615671fa.2
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jan 2026 15:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768002299; x=1768607099; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aOgHmhcwKZxYQxiG5tMnzbmrhve1b+VRedxnj4RiCtI=;
        b=TjIvV7MbKLLx7TIx9V8N3koEoMIC/WMNsscERyUIrkS3AxRyehF9mdjwN+fxwMzqjj
         U4/gN7MaY6GT1nkvhnBQ2jfXlA88auPGBncFiMM9FP0hYwdc8mBTh1AjEuCY53j3PRWC
         FLXHhjyGo8WIozaJnLxveVrkDwkf849Gu5XtM=
X-Forwarded-Encrypted: i=1; AJvYcCUIvp8UdNdo50qjeZAc/aIKvs87uzrawR9G3MAuUXs/vtV6faIFgnbn6zDfZNVzqYkpJn27iMwKCfK1@vger.kernel.org
X-Received: by 2002:a2e:bc21:0:b0:383:1d66:c204 with SMTP id 38308e7fff4ca-3831d66c785mr11713171fa.38.1768002299315;
        Fri, 09 Jan 2026 15:44:59 -0800 (PST)
X-Received: by 2002:a2e:bc21:0:b0:383:1d66:c204 with SMTP id
 38308e7fff4ca-3831d66c785mr11713121fa.38.1768002298841; Fri, 09 Jan 2026
 15:44:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250721110546.100355-1-ranjan.kumar@broadcom.com> <058aa1ec-3243-4063-90d0-278c870accca@kernel.org>
In-Reply-To: <058aa1ec-3243-4063-90d0-278c870accca@kernel.org>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Fri, 9 Jan 2026 16:44:40 -0700
X-Gm-Features: AZwV_Qh8HJBYST59O7TNmIQs_G2U4IIVsvmraD4xvg_srqzi1xyZuO49mvipwYY
Message-ID: <CAFdVvOwFX+bH-XfvGGyMkU=HcEr2hob+b4dLr=pbAU+48gUn8Q@mail.gmail.com>
Subject: Re: [PATCH v1] mpt3sas: Set DMA_BIDIRECTIONAL for additional SCSI commands
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, Christoph Hellwig <hch@lst.de>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000009d5f00647fd1dec"

--00000000000009d5f00647fd1dec
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2025 at 7:28=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> On 7/21/25 20:05, Ranjan Kumar wrote:
> > Extend DMA direction override to handle additional SCSI commands
> > (SECURITY_PROTOCOL_IN, SERVICE_ACTION_IN_16 with RELEASE) that
> > require bidirectional DMA mapping, in addition to ZBC REPORT_ZONES.
> > This avoids issues on platforms that perform strict DMA checks.
> >
> > Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> > ---
> >  drivers/scsi/mpt3sas/mpt3sas_base.c | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas=
/mpt3sas_base.c
> > index bd3efa5b46c7..8aec475fc7a4 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> > @@ -2686,8 +2686,22 @@ static inline int _base_scsi_dma_map(struct scsi=
_cmnd *cmd)
> >        * (e.g. AMD hosts). Avoid such issue by making the report zones =
buffer
> >        * mapping bi-directional.
> >        */
> > -     if (cmd->cmnd[0] =3D=3D ZBC_IN && cmd->cmnd[1] =3D=3D ZI_REPORT_Z=
ONES)
> > -             cmd->sc_data_direction =3D DMA_BIDIRECTIONAL;
> > +
> > +             switch (cmd->cmnd[0]) {
> > +             case SECURITY_PROTOCOL_IN:
> > +                     cmd->sc_data_direction =3D DMA_BIDIRECTIONAL;
> > +                     break;
> > +             case ZBC_IN:
> > +                     if  (cmd->cmnd[1] =3D=3D ZI_REPORT_ZONES)
> > +                             cmd->sc_data_direction =3D DMA_BIDIRECTIO=
NAL;
> > +                     break;
> > +             case SERVICE_ACTION_IN_16:
> > +                     if (cmd->cmnd[1] =3D=3D 0x17)
> > +                             cmd->sc_data_direction =3D DMA_BIDIRECTIO=
NAL;
> > +                     break;
> > +             default:
> > +                     break;
> > +     }
>
> Very broken indentation. And the comment above this hunk would need to be
> updated too.
Will fix it in the next version of the patch.

>
> This really has to stop. The need for modifying a data buffer content whe=
n
> translating between SCSI and ATA is nothing new. HBA hardware designs tha=
t
> cannot handle that internally are simply broken and should be fixed. Or b=
etter:
> make your HBA use libsas and rely on libata-scsi SAT.
>
> The commands above are not "performance" commands as they are generally n=
ot
> issued in the hot path under heavy read/write workload. So even if they a=
re a
> little slower because of the HBA double buffering, that's fine. Relying o=
n
> unauthorized accesses to host memory to replace the HBA internal bufferin=
g is
> probably not faster at all anyway.
>
There were multiple attempts to work this around in our firmware in
the existing generation of the products  for the last few months and
with the limited memory resources available in the controller,
performing double buffering of the commands for 1024 drives were
resulting in resource unavailability and commands getting timed out
and resets. So no controller firmware level solution is viable at this
moment.
> I was already very sad/disapointed to stumble on the report zones issue. =
Adding
> more commands to this is really not desired at all. Where does it stop ? =
After
> all, you are not doing anything like this for translating ATA log pages t=
o
> mode/vpd pages, right ? So the HBA *is* capable of double buffering, no ?
>
> Your commit message says nothing of the use case that this fixes. Is ther=
e an
> actual problem in the field without this modification ? Without a better
> justification, I am not in favor of this and would prefer the fixes to go=
 into
> the HBA firmware.
There are no real use cases we have encountered. What we want to
protect is if one such command is issued we shouldn't end up in IOMMU
fault, with that said, we have two options

1. Change the dma mapping as mentioned in this patch
2. Modify the drivers to fail the specific commands as unsupported.


>
>
> --
> Damien Le Moal
> Western Digital Research

--00000000000009d5f00647fd1dec
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
sSZnSg7MxujpJBCm+g8vnbIR8SWb0eV8h7CavGO5RewupoUc/ooDtIJ4kBH4bCyT2+v9DUPwul9z
7gZz4B++Tv+mYYmb5Nmnvzo83USm+h0YxbUWtQ7v6oKhXF6pBQdI4acDPbBp2Vuwi1Gy0nzCNmoo
Ky393ZfqW9aiFC1exrFdGMj5WjcG1b55CV+trdm06wNkEYQhlk/qcuonvOEVWDlAeNgxdjSBGeEt
30aAhK9xxZwoFiA5lrEITC0fyVM5WqEdQyhCDDmuL1Pxbnmicgb+n38fJKvDOccCAwEAAaOCAd8w
ggHbMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggr
BgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1l
Y2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2Ny
NnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGg
MgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5
LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWlt
ZWNhMjAyMy5jcmwwJgYDVR0RBB8wHYEbc2F0aHlhLnByYWthc2hAYnJvYWRjb20uY29tMBMGA1Ud
JQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFAApNp5ceroPry1QLdugI4UYsKCSMB0GA1UdDgQW
BBTVF8c3GxGultX16jUfOliHU08JEDANBgkqhkiG9w0BAQsFAAOCAgEAOFYJRypA90OeGligbie9
axD8F3GvemPLFBOUGoUvB9DgF5L5AVuIobF4DufYRL4YlYupU01lUcASDB7DTUl4N7dhl5RKuwAS
LOzyDMyNN/BJVxFulsJE79SliIblN3NByjrFtphAaJLlO0WHiLsHZoex6zY7fOXGhnyJwKidXH4f
IXNzDjE7Y4Rhk/FIWqWAvaSBiVmLCIubjq3/VOPkyEeT+y6Z9YWl5lhytKCsotrqVIHOvrhQzDIM
v3JJyXEPlhTThGVSJi35NgVsJ1iK0rpQIUAlq1zeHigvlOM8zQkWvcuJAt34m5m++3utuFGQEgmR
oD/iK0LTVY8rD+csqM1m7V7hmlFo0yXM/ye2+mY4wmYa5hron2S79u3c33ddqPImu2D3Wd1OqIVA
4Id9v/Nuc8PJQDDYQC/bvD3oJCYZBTcbYjYIGioZ5d1nzdd4DRzyR1Kz/+h55Ej0dWrSjyAIs8Dq
6u6Wr8JWVrGWt8Q0REQz+7ICA9eUrzYh7a+RhGxkH9E42ix6TLRh7aHovyPFUv5D9wFFsDFLb3EU
DtNmSWbmVkTi5hQsBGEHSQ2ZpXnuoZakPTdL25iukxy6o6iUMUP2NfYtDkQq8yQDYZnI5HP+zo5S
MS2ZCEw0Pmiw+cDbuu8JjVX8pZFtaLpUpG58VhlLbfzlO6JZYD6qvNYxggJXMIICUwIBATBiMFIx
CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxT
aWduIEdDQyBSNiBTTUlNRSBDQSAyMDIzAgwgZ8cwp+D8N/uediswDQYJYIZIAWUDBAIBBQCggccw
LwYJKoZIhvcNAQkEMSIEIK+Z55KjT/repv6pCVQQyL6dhRpHVEAMoZOlybxy8gCYMBgGCSqGSIb3
DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDEwOTIzNDQ1OVowXAYJKoZIhvcN
AQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0D
BzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADAUxbzIVdQZ85ib
F8SzbkagHUzF7RfK6021dwZ6Hdl/K2bTCW8WR/+5408czlF04U9nn7VZpegJGCeC8wKPkKtYPimj
dpBtafRrGU62iIVJwTj72rYG7oneGMw1Ik6atoSgirxzqUTukuW4Fb5yqikk2w++6yrOcnbFtMmN
FT2XY9UYYN22vvQCmODgivUodYQogTBSQt2UfgtlEOnw7cKm5zhYWOvcQbu2hkEebjPpn/KJ94yv
49T9CrGIHDPZ+f3DbPSAam3f/lIcUs/jj71qAB/UNKEitrPhTMVExwqwq5Ylef7pmKzW/QviWHeu
/g3o/LifEnLynnxjGFnuhmI=
--00000000000009d5f00647fd1dec--
