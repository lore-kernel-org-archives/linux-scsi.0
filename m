Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329B4339A8
	for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2026 05:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.228
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775886569; cv=pass; b=kNtjrTMFybaRuwe07dyEuVf//DCEAWtSR8LCm2YieFh4PEjT08iMgGC4jVeSonCNocfiVMCjX97/VL51lVhoac8SPObRIVz5eaLrG00f/eTrwq0jEcRjBgRc02jI9h24nbUGaksrsnETtpxmy1ZcKFp49mxBo8Cm+HUJwssWiNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775886569; c=relaxed/simple;
	bh=HzErF3to4qHHnkYCpwTmJxU75vBeFZRUD5A0EUDftxk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mz2uuuqUTd7rrD2FiSSN8r+SNyhyrHVQx2TP1PJFCh/EQZih9pHm++c/xBq8gyKzTwBTYgzBUHr6LPXSAoweDZbkgMn+z+pzAUrdU6xTEZMUTmBoCBsQiVvRxtY5BqKAc8Qn65JQZ1Hmz+SEPK1ZeAY8YEeDLRtgMyDey6NufH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JbTDcHRm; arc=pass smtp.client-ip=209.85.215.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JbTDcHRm"
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-c70f91776fcso1184736a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 22:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775886567; x=1776491367;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MkaMSv4gNYELP/V1Z6Ic1X6Z78iTFAlZFDXtwyjWug0=;
        b=HVDrqMCHjlmmW9ionVaSGbiqdkDHKEmaPfHqu2/hfXYkzOtfwLNdHAe27rOdYmjn9z
         tgigWnFItJwqyLbcFjyKzcZXf0Xo+Axz1Ze246Ds7/obkibMJHsOb3sLgINyIZrMVaDv
         EugKxUWIktvdF1lMhgcddW7jkClHqDx67Rhc/Az91CfXMEa+HAQRa/CICC1eLGgPQjAQ
         UuguXdrNosovJatn9Dhj6fgXmrT0GEAyuXJb5qIHvGr9udDs8iwp/0dIt1iWyVYuvsOe
         xdhMVchAyAvf8fVB6rz6NzKqbKwCA1Q2Jv+BcFlF8Y9Nj+TcJbF1b0Hl5o2lQkNNWStV
         DO1A==
X-Gm-Message-State: AOJu0Yy4lklQm2BIlg86LNmCLgomOqekqP89oGRSekOGFjwTg8ZLZp4y
	Hj2fxrUNjLtVp6UMLIRqztZn88+cLltduocBMT700DuapaFlkEBGPn9zIBymKZ3WdEBOZYUPef1
	K9g3duoVFjuI9H5K4NGCNolwRWTC4evvkxTy3JhBqerxh/GVnDmpru/gi1W9KWIO2NyDvcRjbIf
	Z9dxc+qa3KXlh5wF7IziDtINwezQJQ/8Xhn4kK1DkmNJxFHJJIrpP58zG7traqK4J7P+i93LCPR
	DpDHI17MuzM2sCb
X-Gm-Gg: AeBDiessdR2nibz/2xoFfQEiD+kWxFcp2upmK9h6shbr+ZpwS7sSFxWuP1N4sc2s/GE
	ohOrx5nuvqyC0Q0rf+MIs5lHXNHRbuy561ocZYSw83JbfM72wNCiNB8nxybam9AgIsGVJygFINY
	I6zjhSsZ3RpT/eXziKmkLf3TZaDxN/xDW2btg30oImt6Wu3oUmXGDNj5cMr9uN4gHDThMdrdEqk
	NTptghl+tN/7TyJgiVd/f7FxNwvX1e4Ua1b9F7XjnKizFhuj/ozMWD9EYRbWwBAw1y1kNcoQ2rg
	tv+9zKMsVuAEE/M40G6PkhNmVtfeyx++4CMh3BOuYmD7fgafU+BKUKUDRuNOQ2RFQNu6f7yxvqx
	o4jOLOAIfkcT3IDm4VvgsMA8p7gUPHVUPQvv3eDym6E1wO7jFoLLUFgtjwqL4dJR7CHu/7RV/Oh
	qdAghKImVaub1pasF7MEwjIrB1SFGzsAk4yXmTtDPOpw2+OaEwK8IkPeOD
X-Received: by 2002:a17:903:704:b0:2b2:ae0c:ad0d with SMTP id d9443c01a7336-2b2d591b960mr43017775ad.5.1775886567199;
        Fri, 10 Apr 2026 22:49:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b2d4f36345sm3307245ad.46.2026.04.10.22.49.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2026 22:49:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b9c0bdea9faso228396066b.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 22:49:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775886565; cv=none;
        d=google.com; s=arc-20240605;
        b=MCjxh6sqSfIPKQQAudyvfuH6OdHBUgEve2l1W+i2N47ZX5SRL9RSy6Ef7xKuWXZ8xX
         qAncFhUOx3BvJ3mzC9ZwEbIAazmXMaD47SLBtmUyNQhU72isuQVScnWpuKlIiXYdKWRp
         qqIrDP9L0XKhKs/X1z+R9T8YOE14pQPbPDz17Z3VDsz6ngBUh91fizvkgiOHGP9AAqzM
         fMnxJIuAXCgo1yfqOaZ4u4oqA3ScZCtwhIKW80SUOSJu5M+TmArn97gONc/LONZOtYQ2
         JGPode3RFrKulykqv3OzQks6kxQ9nSkz/wo50PkXH+KTNJe5u4ofXsYbgF1WJtTNPdUB
         9k/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MkaMSv4gNYELP/V1Z6Ic1X6Z78iTFAlZFDXtwyjWug0=;
        fh=KmZFTdeRDh45FNemcpaylRVUo9aVYQI/IQBZyEqxPSU=;
        b=cbJgbX/1n8DmtyEnA+hVYt+jLw3UZa/r2V6bq7h+GR2ExVd5JDJLjpbLphNpvo0MV6
         pTk7UQoztvZIz56l3izOztwwId+cwYfZnUC9BD9z7T3VslAvleJNLExArMoDt4m9LIxx
         TaeHZZADemT51KT0w7kiZtBtgTSsnMGUSiVIaBX4tI97BovhvR3Lo9Aqr3DqI1NmvF10
         lBCD6lojJ9rvc4vAIWAouDVaMOZ9ULSbTy4oh+JTbt/iLwfsU061ukpcav5Zx2x0pLYi
         w/CAW41ezm/KBCkcSGf+eRJ4WaUNSxLEK0BvO0CenA/YcCCsj73Qio4pVijWC8NxxrgE
         p4aQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1775886565; x=1776491365; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MkaMSv4gNYELP/V1Z6Ic1X6Z78iTFAlZFDXtwyjWug0=;
        b=JbTDcHRmp1XKwZnWIlA4pWk7T3RMWooqvuKFCdxFDo7qtUHGpK0zSwjVLAoBANyaoD
         3tYKyFtDuHHVN6CVqdrvjkfM2OlBP+98J1QthBis556fwSlSrPktLW6QoRuTj0hmRth0
         wDQVc0NdihrfTZtPUtmFLmTrw03j0OW/KQeSE=
X-Received: by 2002:a17:907:9709:b0:b97:87e4:7f40 with SMTP id a640c23a62f3a-b9d726572b5mr334064366b.27.1775886565003;
        Fri, 10 Apr 2026 22:49:25 -0700 (PDT)
X-Received: by 2002:a17:907:9709:b0:b97:87e4:7f40 with SMTP id
 a640c23a62f3a-b9d726572b5mr334062966b.27.1775886564467; Fri, 10 Apr 2026
 22:49:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409184217.32992-1-ranjan.kumar@broadcom.com>
 <eec3bbd3-5503-423b-bb3e-22657026d573@kernel.org> <adkqob9VZ-G6mrsW@kbusch-mbp>
In-Reply-To: <adkqob9VZ-G6mrsW@kbusch-mbp>
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
Date: Sat, 11 Apr 2026 11:19:11 +0530
X-Gm-Features: AQROBzC0AvpwG8JoxrkNeTejPAZUHI6liB6BxxJp1xS2RHQ0II3s0jbXa-Qe3e0
Message-ID: <CAMFBP8P6H1Xc6YBs9KDUrp4V-5pPxTxeeAYyomeOeyjiQYYH9w@mail.gmail.com>
Subject: Re: [PATCH v1] mpt3sas: Limit NVMe request size to 2 MiB
To: Keith Busch <kbusch@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com, 
	stable@vger.kernel.org, Mira Limbeck <m.limbeck@proxmox.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000e44086064f28cfa6"

--000000000000e44086064f28cfa6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Damien and Keith,

Thank you both for the review and the clarifications.I will submit the v2 p=
atch.


On Fri, Apr 10, 2026 at 10:21=E2=80=AFPM Keith Busch <kbusch@kernel.org> wr=
ote:
>
> On Fri, Apr 10, 2026 at 06:11:22AM +0200, Damien Le Moal wrote:
> > On 2026/04/09 20:42, Ranjan Kumar wrote:
> >
> > >             if (pcie_device->nvme_mdts)
> > > -                   lim->max_hw_sectors =3D pcie_device->nvme_mdts / =
512;
> > > +                   lim->max_hw_sectors =3D min_t(u32,
> > > +                                   pcie_device->nvme_mdts / 512,
> > > +                                   (SZ_2M / 512) - 8);
> > > +           else
> > > +                   lim->max_hw_sectors =3D (SZ_2M / 512) - 8;
> >
> > I am very confused here: SZ_2MB assumes that you have an SSD with a min=
imum page
> > size of 4K, which can fit 4K / 8 =3D 512 PRP entries, each referencing =
4K (one
> > page), so a maximum of 2MiB. However, if I am not mistaken, there is no=
thing in
> > nvme specs that forces the MPS field to be 0 (which leads to a page siz=
e of 4K).
> >
> > So this seems incorrect to me, even though that will probably work for =
the vast
> > majority of SSDs out there, some exotic ones will not be correctly supp=
orted.
> >
> > Keith ? Am I missing something here ?
> >
> > Or do we simply do not care about SSDs with a minimum page size > 4K ha=
ving
> > their maximum command size truncated ?
>
> Spec doesn't require it, but industry converged on that as always being
> the minimum supported page size. The nvme driver rejects any device that
> doesn't support 4k pages because they can't be reliably supported on a
> lot of archs, even ones with larger page sizes. So it should be a safe
> assumption that everyone supports 4k since no on is complaining. :)
>
> On the patch, I initially left the "- 8" in the calculation to account
> for page offsets. But it's not necessary because that gets absorbed in
> PRP1 within the command, so we'd have at most 512 entries in the PRP
> list for a 2M transfer.

--000000000000e44086064f28cfa6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zZSItX49nLoa4TBbzuCzoINrv59QeSCVlVdAYussUS3840ZjvcYHSQx3tqYcBN+an07lDASmGEM5
7PEXJPVInjl/Fva3ksL3r8anR4PWc3Xz5jLD8Xg6BU4zmIcR/t1GlqWuz8uTWmQtm40C9m91Q9a+
2alIIV6BTs8IG2ELtt4EfcVvi5af+Hu878sGeBtMx6Z9ljoKl3MfvDdtUNO4bkJ97a7PXy/CKxiy
TApQj4qg9SKQcsH0xzQan67XeXjkvk4frNDhRikCAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQUfLdm66N7GfDsoL8cYp3s4YdO
isMwDQYJKoZIhvcNAQELBQADggIBAA/lnAxDb9jbesclnBxWIKUSxAMIrq4XKO5WKHUYIOOzd2sL
o59fH9AWg1AfVONfWIUNdWDrmNNLs0+drSKaZbGx2RWMbaL9ubo7+BTQV33ZRBxnnkmc9QszlOo5
m6FB9uPOGB9LvJMCkJ8S7hNc9G/p7dB79s1IKc8JGEDIrsgX3s4xSCJA20WdePHY5rLh5ySwXyI2
3sVTUC+oK0HJFRo+TpdMMtdpOetWzIkUbGceiOA2ur8372+0KOmvlIHA/jEnW3BRfmB2vmdk+raY
C/xbXY9JEfS6D881+X/90w+cCQ7nuA1OELebS1RbSdXT6YkRDPWYA/DPFhOYCAiMwVAPRaAH1AQc
8J8yTDigwRUCq4qKCYU9YnqQh3YZRbUYnW+i3+rAO2SUbKl0VM5y0tq+GOGLC7w+v6yGossZmy+6
3w72qp/Colr4r5ZaROb+L2FXqk4tL/HfkRhliyPPPNIjre2mIkvFuShk5A5FcvQYCzDtejAz9JHq
ZVJ1ZD+auQDbIUxT+Dn9bI5XkQnWJ9KrlcORtztdYTDafN8VQuweS3JY0X/VCNBNZkiYXd7fzOza
hvkw/S+v8cIfiakLKBREtiBHqWLdVf5CNDVYpd17yz0LGz0TKARbfuK/EiKflA10pnnnOB33Ru9D
WPp9aHW3szGYr3+H9AHS6IDwkIxyMYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMDcMaKRu9LrbAxERoMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCDq7oak
R3tBXasfd7nyLCT9NkhQmHde5+gYGVmOe3wfbjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjA0MTEwNTQ5MjVaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC8a9mLabIAXWhROPRM2E+qKImhWQuq7f5LpEvDuyRx
3eCFgqohyiD8YP3YhUZcpuNyWj5HFN2DUIZH4ZLl5RQN+aZi3ECVMh0jufm5fgCQvmoxF2/ldqdv
PWUuTRnnwHJoNW7uMosvFmvoiVrq4vuODCMJU3Q+yZqxbyQBVTeDgQT8P6c3vLmpewxLAo+1EUxk
nu2D1Jq992n0xhRHGyObAo7g89U2kVcIz60N2Rx3KFXvP0hjjkQnPIGjyRPeBzdHBo2qFSu+oaZU
dy/c93Idi79aZUHB0xR1N8HaWRhMZHwysGRrXjMDNt8Inut2KySJ0dFql2I/pjq6kcNgox1R
--000000000000e44086064f28cfa6--
