Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3AA257AF2
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 10:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754908618; cv=none; b=AviG/iXQJ+vdXCkBCfgBFCv3t6X0B1eamBo0MDW/V7gdMPENGVF+xiApmh6usbHXYT0Qrbo2IOMMRczJYXBEpwXdXvioj4VVkvOGLmi5egB0HrOlqgDDBBiGJUgyH8gYFtLthwwp8eZ55hdP2SFplmPStck45LKmqzpJ8XGMqiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754908618; c=relaxed/simple;
	bh=ZlINc14VWUGvhsbkiJxaz5nAiZb5hto7zC//xbDgiS8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CQwKLGxj4dG7FM4KpA3S/hKuUKTLje2ZKSJ7d2E3JzKLl2rZCZBsMUmRHZS3HAKmXwUGSfRFO/Myq9JRBwwCIybh87DdjNUP3Gxx9r1JFn+LJpAIwXI2kYWw3PvC9WsvsK6L5C+5iaJ/AXzWXLrb045iGXANMLGVoGdLnPBaHWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AAf08AOk; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AAf08AOk"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-24049d1643aso29851355ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 03:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754908615; x=1755513415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m/dzN/Y/1B1aORISd3Z/2eMdwMy3KN/lOSlqD0N9ZLw=;
        b=cUhuWmR/nJo6OqZGnycc9xET08+MN5Z5NHfX548NHdz8sDg+GdLdxYwY9J0AkGEyKg
         EOe+o7sx6gZ8qk2aH8CRBZM6+ChC174LHirTPDgBJLZMeyaiTOGsnoVYcffa3ImblGpa
         3Rmt1IspPoCtYYIQ9j7QE/tw6iskcHifgqr7HnVjuxJlhbIgWfUkLl22IvbODYhyl63h
         hzKxUSM8Xq3J6QEtcI5XKzXSnkQAJwUDYde3cxxLfVGFw4oyUZuWVDE8V4sjtiKnWuYg
         DBTOyAB4TJeSrI1RZD0sCx6CoCkyZ0J5sNgPV3mf9dC/XHH2xU2pso/XslAbr3TQqlT/
         E8JQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzuoApPgz5C+p8szwkyIkWtN3cVA/TAtNZGGUgHaMNX0/ltv9WZo0Rt4qnJAwGqd+Q2VwB0Ocn2k1O@vger.kernel.org
X-Gm-Message-State: AOJu0YxrjrV3p9M61/3i0dobuWIv8JBQj1zSuRihwABWfiRy3O6FBINg
	Sd1VN8wNX1o/FAummXJfE/TdQGErTc34Aa+ud045T4eEnM/06P9lNfSWpT9Rh48SQ8StwcWrdJS
	2t9Pb+DcInH00C+9amt2nnrMT3gfw3hvu7M70csjk3FB9xCKqqnUg93LqvhIKVyN1yHBeO8IWE/
	TpyM0PdXPnHWBFx6qWYolIG/Ocl+BZOv4GwNqE1zXPxHL86SN9DkSfbcKbUfx73/6WQDYdt+at6
	QoKCkNivmoS8QPM1hmg4UE=
X-Gm-Gg: ASbGncvAzcbUIFbj+izA0Ex6gZSFumomOpcOs6RuyIfOCWswThEk1GOxaIV+lX2Hwip
	QoLdrn1EEhFirN0d26UxKgDZ/yxCk2PHN31uexrrQ0AZ+Hm1csvqLVK7patQv+EjoPWdCMcI1IZ
	VuplSuG0a2L2OHMGlZ/xa1ATBjddg4mSDRtzuXuaM96XsXQVQoYrIhQCiC+Psv4y8M/F9Em9WQJ
	vsYBlYLtLA+4r5G+vDOXujiupLtVYLKx94biiBApiHEQIS5rh05hM/HqiQ+AAD/mvwZQb85e9vH
	BnrJBDqaSEl3Az34gHz7bGt4MItGs5JuRacbuzWSBEAnu1Fr0j1sOOGsNNbzRAdkS3nTd/4ZsHb
	o1iwbs+xqNRO3pjxdJ57mMxMxSIOm31wSwfqBT2ZMe54DgzdPyhtVqwWDeTo3JcS8giEmhbfb2i
	fQIILujA==
X-Google-Smtp-Source: AGHT+IEoiSd8i2d7PrL6+D6MEj/1cjsx72n2Y8eN6cuRJtPnsa32WdfJbmpmIFWXP9sCkJ/sjY2Cb65w8q74
X-Received: by 2002:a17:903:4b43:b0:240:25f3:2115 with SMTP id d9443c01a7336-242c1ff406cmr176545295ad.12.1754908614998;
        Mon, 11 Aug 2025 03:36:54 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-119.dlp.protect.broadcom.com. [144.49.247.119])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-241e899b5a7sm16652825ad.72.2025.08.11.03.36.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Aug 2025 03:36:54 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3323679cd0bso17920891fa.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 03:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1754908613; x=1755513413; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m/dzN/Y/1B1aORISd3Z/2eMdwMy3KN/lOSlqD0N9ZLw=;
        b=AAf08AOkHU1PukFvmORokpf4QHopM8DMF0/MAjQt89RLzmhwgVKPiwsRHRkyg2bXRm
         U6n52II7u8Uq3cfY1o4Q4fuf0N4K7UyJvPda66SXFv35QgiRUlsU946e0aCttmcEF3M9
         anwKIUcyYeJ3KzkB26y7cl7q5+cr9ze4eg9iQ=
X-Forwarded-Encrypted: i=1; AJvYcCVPsfkxVCzd8pXi9F0vhVt0s4EVd6YUlOp31UUIVW1adD1CbBaivGHi7kTJkEzSgvyGsCewnd3ZHKAj@vger.kernel.org
X-Received: by 2002:a2e:b8d6:0:b0:330:d981:1755 with SMTP id 38308e7fff4ca-333a210d629mr31287151fa.6.1754908612713;
        Mon, 11 Aug 2025 03:36:52 -0700 (PDT)
X-Received: by 2002:a2e:b8d6:0:b0:330:d981:1755 with SMTP id
 38308e7fff4ca-333a210d629mr31287081fa.6.1754908612199; Mon, 11 Aug 2025
 03:36:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250811052035.145021-1-shivani.agarwal@broadcom.com> <7c7aedbf-389d-4e5a-83d0-33c51cda1d8a@web.de>
In-Reply-To: <7c7aedbf-389d-4e5a-83d0-33c51cda1d8a@web.de>
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
Date: Mon, 11 Aug 2025 16:06:40 +0530
X-Gm-Features: Ac12FXwNglXMtrgIIpAb8_5Z4UtmkHGLxNPDlnxZm1tW0Yi4PWiSy2OxteVobxs
Message-ID: <CANTE3ihiPx2GZDcUWcO-YR8h-tNrsCtJ=jH7Kzd08Y8qDxZk9A@mail.gmail.com>
Subject: Re: [PATCH v5.10] scsi: pm80xx: Fix memory leak during rmmod
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Sasha Levin <sashal@kernel.org>, Viswas G <Viswas.G@microchip.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Ajish Koshy <Ajish.Koshy@microchip.com>, 
	Jack Wang <jinpu.wang@ionos.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-scsi@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com, 
	stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Tapas Kundu <tapas.kundu@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000804da8063c14800b"

--000000000000804da8063c14800b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2025 at 1:30=E2=80=AFPM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> =E2=80=A6
> > +++ b/drivers/scsi/pm8001/pm8001_init.c
> =E2=80=A6
> > @@ -1226,6 +1227,16 @@ static void pm8001_pci_remove(struct pci_dev *pd=
ev)
> >                       tasklet_kill(&pm8001_ha->tasklet[j]);
> >  #endif
> >       scsi_host_put(pm8001_ha->shost);
> > +
> > +     for (i =3D 0; i < pm8001_ha->ccb_count; i++) {
> > +             dma_free_coherent(&pm8001_ha->pdev->dev,
> > +                     sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
> > +                     pm8001_ha->ccb_info[i].buf_prd,
> > +                     pm8001_ha->ccb_info[i].ccb_dma_handle);
> > +     }
>
> May curly brackets be omitted here?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/coding-style.rst?h=3Dv6.16#n197

Thanks, Markus. I agree with you and have no objection. However, for
the stable branches, we usually keep the patches unchanged.
I think it would be good to remove these curly braces in the Linux
master branch as well. Should I go ahead and submit a patch for the
master branch too?

Regards,
Shivani

--000000000000804da8063c14800b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iRPJW7xMdyXlghl13B29WFHBvkcVJoRG7X1q9hGiJ6cP+UffhEHqOIAfa+w9JdtfPmRdIei9rDMG
13qTNm0LSI5pyK2hrV1mJ69tfsMsfB7sejsTuTOfw/7DV6KBse6HCG6+EopHpBKz+ZrTMOJo5UxE
en1o7UfNuVpRJRpTSkEXMRntyMcIEyWmGBpUN644f3dX8Wrd6HHYhLRqATO+uwIDAQABo4IB3TCC
AdkwDgYDVR0PAQH/BAQDAgWgMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDov
L3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5Bggr
BgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUG
A1UdIAReMFwwCQYHZ4EMAQUDATALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUF
BwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEEG
A1UdHwQ6MDgwNqA0oDKGMGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2Ey
MDIzLmNybDAnBgNVHREEIDAegRxzaGl2YW5pLmFnYXJ3YWxAYnJvYWRjb20uY29tMBMGA1UdJQQM
MAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFAApNp5ceroPry1QLdugI4UYsKCSMB0GA1UdDgQWBBSm
eEP07C50BiHJ6M3vZhTU/COMnzANBgkqhkiG9w0BAQsFAAOCAgEAGDK7XvmoOTcNaefKnzjIfKKD
wCbRX7fLxL0keAQAmiQNgNd7eDc/Cnlnf29QH0YYVWllIGMIiHpdfJP+W/lbdMxvCDQ/NWmnuBJ1
HgH/cJpD69x6sybVo2zvbeavlHsFLCWpfDfgY9p8j/flVo1SWPcQG+udOqyXwh+nGwHhiuKAiEBy
jBEEs+ngv59U/j1cvJ9pXlaGTC9NOkP1XliIs3nlytpQXJG1weyZzkY4DZf4klN3cHOSQTvF7vjy
aY7hNcp1YrHDxsqoKdQvazng3Y96w/GEAgcaZhITyrH6mCC8+/oJC3HpM0k4K7Z2Vi1m1v3Jq/Kn
lQkI8Dv80Uhgt6bvS+KOVU1vLDk5B7tcy4kSASakBiXbjOIQTjGUFAFM45yN+Tv2vS8o4QbX2nRl
8yzOosbR0aM7SFOnifxUub/2hhQl5W1ZNeoOL1bZUskIQ+VsgxQxNtqMXf7uupJq2sVzutbf3lEh
Z+E/GB50TcPGfgSBH3kP9JH9Wd8oXJ3PN02vpjq/h3ffJEPGIPtqYkaFjI7dzhC/XpW5+A+J232c
qsnzyHW2U8vSWC5M3Mo4f8tGkjBS4qQS/eFgGz6KLcwD1SjhPzgp5NZN2W2jYEVoPmBNAeNnm/tW
lDghRb6zt3dVU5NEcysBUTIydLMkLuoWGzgRJx8fFpe/qziOJKsxggJXMIICUwIBATBiMFIxCzAJ
BgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWdu
IEdDQyBSNiBTTUlNRSBDQSAyMDIzAgxdbqmjX1toyzmQTGMwDQYJYIZIAWUDBAIBBQCggccwLwYJ
KoZIhvcNAQkEMSIEIOyZsF/EZr9UY9sn0SgzJ7df5XeBlNevmWV5WucHmHNjMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDgxMTEwMzY1M1owXAYJKoZIhvcNAQkP
MU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAswuCQnRa9zy1/Pu9Pn
L+IfU9Er4FLnLn6+mciixXSbtUNU5zjeU5Ld5uieSbMsEvE8oURRKL/uW01o+Lox2cWEL73iJQt2
UhymzWluj6x0JP3Juw5AqeeNiqatAOTnsDzvPWctguCei0HTKRK9wocmmzA9vPviwKWKSialj4Ws
tIu2zQj+gTqW1y+hVbKWxv7necl5KcKDv4RJIbnuxPPBaDQyEZUDAj7dPVD7ta1b4GSEcg5OXW2v
5pSR8lOq/vZyNKNS4QoO7JjqUNYXQFXXeSoAVM1tewRfinRDcKNsO1r5+OFxfs1aoJnwieqQ1q0o
cGGxlY1tiybWqHZXXoc=
--000000000000804da8063c14800b--
