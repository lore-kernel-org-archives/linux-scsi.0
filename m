Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D433883CBD
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706712198; cv=none; b=sWvZ2IaiIs3g/9C2fhKjqehsg7qvHJS6Uvx9ohPIs2DAW+nGPeShvriIuDSBKrPI6cJhhxpjWYZ7mYyo2kqNZsETTtCDIHfI8lfBi2PQ0UnylKxCoXy3nq+kr/GTdVUo08oWrLZLgm5nD3EqhUq2WT6Dsvu7Ycb0TJbhQ6jIZu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706712198; c=relaxed/simple;
	bh=M78GbXVX1Z7+fT3TYn6k9sezDbRhCQWHTNCFY1+ekJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cuYpQPaxC2QrQ/boqfXme0N9H4g6josBHBW4chO/H5KZLD1fhRsGpCZzjfLXTj11vYke1wMM5vUzncDkiwZxU/+pMLHeOt3nrKaci8Si+w/iILIZUDnY3s5vdpNCs9AeuZuv1Q+RRNTTs2HRjJspE6RdjGpj19HF2my/h9F98xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=EOgvezOK; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EOgvezOK"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7d5bddb0f4cso1587040241.2
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 06:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1706712195; x=1707316995; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RxGH3G3NyAZn2lHtH4gm7cZDJgmr1UlWIEb4a6A26Xo=;
        b=EOgvezOKwUJupSkZC7QP+elmHoItI9Ky/zJgF8KM9rBT0a51UW4UBMYARYapvgr06T
         PBC+/R0C4U1m265TojwSXiFUOUYrm3rGrqECmsAhJEbdoLriks3Lx/0Uew+6XR/IuTu3
         kkcVRmjRqZtoaxPy/XLFbjoHf9L8esMPgH5Kk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706712195; x=1707316995;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RxGH3G3NyAZn2lHtH4gm7cZDJgmr1UlWIEb4a6A26Xo=;
        b=Dyo0cajqYScP1mBT+H4LA/O0X0OZ4zH0vGZ/asHRyPGnMxKoBuOm9ze+210qWAsPqu
         TADJ2ZhhWWAjQ42LYuDX5kMNJlfD48jfQDjVYmYVrhvTvrZO2YjudKXvLoYzlLadvCEj
         X6zb7k7pdSXm4STyXQccoalPbkLD4ommxetXMdDYQK1ztOK6UoLWzpVzg4LgfaGbVW3Y
         e6fR5SKlVz61ANjQ1H5i55R2DOfVOZoVmUkDkFWtGAJPf2Xqs2nBH+W/yw+fF/+XNLuO
         xo2XvqD+mo1PpdvuuTKUAMtE/CpIOoXqwtsoGj1A1fNgMUTyCHLKe/KVNdbH8N6bYHL7
         ACmA==
X-Gm-Message-State: AOJu0YwBoGeO8ysJjQ+kj+buRV/5aq65SNFYbY1lGWuHcok5mSHKNoJt
	SSGKKRVUUQ/fIvSvDXhVkvesMwpZzxYVSHif8G+phjPs2wjkpf49PRtHdXYYl8NMGb1elZL7Zpc
	j0vvfpaWzWVkrX+KlMtZOzl75dthl0eKjpdptPi4CFq4VnUEkZC0t2o3NYVnhwpFAB3fjvcilR7
	7IQ50PdL72snuQcfZx8v0VJlYzuP7z8folKQ==
X-Google-Smtp-Source: AGHT+IFOtFCbbzsMciouXxs5L1FLLKn2q+dIPgNM3jaDoKrHZW7K9S/Q/9oqBFalQ3CX9kpp1FWDbAKO9IypIHPfxmw=
X-Received: by 2002:a67:c50d:0:b0:469:8f23:9e54 with SMTP id
 e13-20020a67c50d000000b004698f239e54mr1424222vsk.43.1706712195363; Wed, 31
 Jan 2024 06:43:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231220162658.12392-1-dwagner@suse.de> <CAGx+d6cGuC8S2+_ipyKMtOxNQ5a0RW_H46jrwWJjwRx5TRw-ww@mail.gmail.com>
 <bhbx4emtgs4dxwryeorgq2igq3b2lu3k2ycdyn4ebwpbw4kxtp@aijstnvpilho> <seilf7ml5oymtl7etdblfj3obtah7b36ygjw5vvql46suksm53@mk3xrjiyq3v3>
In-Reply-To: <seilf7ml5oymtl7etdblfj3obtah7b36ygjw5vvql46suksm53@mk3xrjiyq3v3>
From: Dick Kennedy <dick.kennedy@broadcom.com>
Date: Wed, 31 Jan 2024 06:43:04 -0800
Message-ID: <CAGx+d6e=AJ3dN3sqkW_Wgz+rKoVzO05fyEMbe58vwdNoWge1AQ@mail.gmail.com>
Subject: Re: Re: Re: [PATCH] scsi: lpfc: use unsigned type for num_sge
To: Daniel Wagner <dwagner@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Smart <james.smart@broadcom.com>, Hannes Reinecke <hare@suse.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000029335606103ee609"

--00000000000029335606103ee609
Content-Type: multipart/alternative; boundary="0000000000002399dd06103ee61d"

--0000000000002399dd06103ee61d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, I got distracted.
The change is fine.

On Wed, Jan 31, 2024 at 6:41=E2=80=AFAM Daniel Wagner <dwagner@suse.de> wro=
te:

> On Wed, Jan 17, 2024 at 11:56:27AM +0100, Daniel Wagner wrote:
> > Hi Dick,
> >
> > On Fri, Dec 22, 2023 at 10:04:50AM -0800, Dick Kennedy wrote:
> > > The change is good, however, I  don't think this was really the
> > > problem.
> >
> > I tried to write the commit message based on the bug report we got. So
> > yes, it's possible the it is not correct as I was not really involved
> > and might missinterpret it.
>
> Any chance to get this moving forward?
>

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--0000000000002399dd06103ee61d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sorry, I got distracted.=C2=A0<div>The change is fine.=C2=
=A0</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gma=
il_attr">On Wed, Jan 31, 2024 at 6:41=E2=80=AFAM Daniel Wagner &lt;<a href=
=3D"mailto:dwagner@suse.de">dwagner@suse.de</a>&gt; wrote:<br></div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1p=
x solid rgb(204,204,204);padding-left:1ex">On Wed, Jan 17, 2024 at 11:56:27=
AM +0100, Daniel Wagner wrote:<br>
&gt; Hi Dick,<br>
&gt; <br>
&gt; On Fri, Dec 22, 2023 at 10:04:50AM -0800, Dick Kennedy wrote:<br>
&gt; &gt; The change is good, however, I=C2=A0 don&#39;t think this was rea=
lly the<br>
&gt; &gt; problem.<br>
&gt; <br>
&gt; I tried to write the commit message based on the bug report we got. So=
<br>
&gt; yes, it&#39;s possible the it is not correct as I was not really invol=
ved<br>
&gt; and might missinterpret it.<br>
<br>
Any chance to get this moving forward?<br>
</blockquote></div>

<br>
<span style=3D"background-color:rgb(255,255,255)"><font size=3D"2">This ele=
ctronic communication and the information and any files transmitted with it=
, or attached to it, are confidential and are intended solely for the use o=
f the individual or entity to whom it is addressed and may contain informat=
ion that is confidential, legally privileged, protected by privacy laws, or=
 otherwise restricted from disclosure to anyone else. If you are not the in=
tended recipient or the person responsible for delivering the e-mail to the=
 intended recipient, you are hereby notified that any use, copying, distrib=
uting, dissemination, forwarding, printing, or copying of this e-mail is st=
rictly prohibited. If you received this e-mail in error, please return the =
e-mail to the sender, delete it from your computer, and destroy any printed=
 copy of it.</font></span>
--0000000000002399dd06103ee61d--

--00000000000029335606103ee609
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
KmQYmvvS69Yzni2ICLsrDnobRTQz+WU28a6Tom8jGCqdhb+M5vcQfd25irVB5mWTQSD/V0I4zzBC
RkPU8Z1cENcCpTGKiTIlxOcXqcGCfODOBp+b5t1LlI8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZZGljay5rZW5uZWR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUtdd4o7T03rmODooWDc+RholN
rvQwDQYJKoZIhvcNAQELBQADggEBAI7UnYAv1qdInCyVDoDFaQuWAbKCTIWSoBrfkGLmwnhlh/kD
6LUi0C5XGf1AtRHavNTJjv66Y7nieJzRwS2iu8UL+ymplb4DoW0zJLZsbS411vfBe/ce3jf1dKJz
+3Ae/9Rq2QXWZEn+8iryPGmX14yXMn8dNF031CdyjXiT2jLPdImXG8S85z0PJUWi8H3XZwkZG0Ob
Fy1OMqIo9Gb7bX6oTI2ynYefTa5tI3eT0Wdq/HbfJzwO0WmsvsilPyv5wmW8STXcM4MeqyDC34RR
R9PD82a4t2AfSBbyuvgQwwF6KMyuk4zR+dHIiVqmbgA7MFUsGl+5JEaheEErdWYuO0oxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxQn0c/D7RhpijTAm4w
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOdYdHt2VH7jaIDzU0rTU2izSL6QpNp2
+6zkmjG/6RQQMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDEz
MTE0NDMxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBMsfpFdM9Gb9DyzwQR+iw4yInHJ+qVsHtdEw0QjqJsW5bOYiIE
INszDGNMFIVJ0NC37UKbsPYoMvzWdc2u4Ou8t6KRbsaTuVrMmjB6PTK4k49Mn4IqAtdHLIIZfNmG
2MEdksyf9J1OKvs1b+FEze41rBiZG0mmuc+rqhLHrm7DQAWVHJkDe4YdxFgX+sFlg09T8XLrDnCl
JCb4fDCP2HbHBq//BViNOTkDBzRMoR06vNr5FoWeaZ8A/n0BUSyxA6emQWBdMR9a3hSOINDzdI9P
OAWnzWeguDt+hC7eqJ05OQZdQYOjQefMDvAtyQQZecePAl3c+dcTeX3uK+obOyqB
--00000000000029335606103ee609--
