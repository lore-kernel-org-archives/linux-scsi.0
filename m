Received: from mail-oa1-f99.google.com (mail-oa1-f99.google.com [209.85.160.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A101624DF
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781789984; cv=none; b=Ks+PslMFEm5p/eSdprpEXg+1tlX+O33kRxYY3vxQih3iYQtNaLhJsD4Tdb+YN0LWYja3i90m7zuzi2Mys13nBg9xA497jFUN3aDwHqwj6D5F7HcOnDYiSpgaoccXxBocbwYPKmZdg1BYa8+2MM5DUgpkDMiF1cnDNJgM1SxECgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781789984; c=relaxed/simple;
	bh=uccKY89vdISqeaEJsYD5ThW13WupOTtKX4lAnl5S5eA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IlLBU19zHNcNhHiY1wJzIbq5yNhhRtU1S6VHnjp8nmILEMI0gx3yjtZxjgBIMoOkEV6ioieNX798z6cuQOFCFhvBA2JBW45DXiCvij8p/DBH9CLoPCk+fh9WC1j8W91bkqrqcfD1G3fLm5EzbjtaBwJJcPcYcoZ3wRkv0bsoXvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GmO/X7kH; arc=none smtp.client-ip=209.85.160.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GmO/X7kH"
Received: by mail-oa1-f99.google.com with SMTP id 586e51a60fabf-43d3a0dabb0so680485fac.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 06:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781789982; x=1782394782;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5JxiypfqVPKigingCF+VnDPCnwDPNT0FMQDtrw3STTA=;
        b=OyLWwNSjPP+icq37V/vwv0HjEA6663xzz4X6IEoP4Ob2u1h63+diVnGFI9AaisNL0Y
         W2nkI5wvyx6oIUV7B4g5eks4CX7I4haWFzKIvtNHem7r9wzQx29jb5juFyPXSKQojcfm
         PPNjKE5u+8Cc3S9Kw9ElNlO6X6TF1WHKUTchc3HUABx1XujR/5iQjzyPTIDCNOAKJa8A
         2FbLzA2fqpgQlArdS6iToK1WmFLW4q+2f3/5P5wY+WFaYEUQw20vGr9lEEaSNpcFPhiy
         jXEr2vQoFa2Ey+gb3Hgxt21VjzCGFCWzdeWOTjdUkgd8jfza51vqUqMxCkO0lvA0oVwh
         vbFg==
X-Forwarded-Encrypted: i=1; AFNElJ+acbUe65fm26ddxVz67RbF1pmRL0M9fQDPutpBhexubdCRtFRWIpJDFYbTQy/e0S69lYXBHnmHda58@vger.kernel.org
X-Gm-Message-State: AOJu0Yz18M+aTOGbjMzgDpImrRfcOwOkOzJhlybklR7nwLLnvhwBgL2a
	mnFFbsFGqnxf1eBjqzfkvZleWVhvzfpSx49UUWJdh91XhUsVQBANWR5ndOUQViBN6R0emWe5Wc+
	tdmwvle6EpfGQdXKb656ILFlONMLTeZwbP7cxW0ehxUoM3h9iZ7GV9NxPSgN9c0n3voiPF7pJsj
	/pPdgVCNgm6fuOiO73VQRzlzxOXZbx09xE3e9t2PvcdxIS5Bdqqm+YiYhkB5bIxROpqUmZj0BUA
	aHnDezIKPU=
X-Gm-Gg: AfdE7ckDWeQA5SS2J0CEVRxdjpmew54ayh+DM9gvcUMXoGuFkyF4Yy5wZdXBIvatdy9
	5SpiEkYjm7rjpZscjXtiQXd05kshq/kecp+70tOksYNYkk/vonYXyGGoEV+8+UXF8TYzSW8VWZH
	7h1qBMujkMxcDBBs722xpPBFo4Sz63zClqQD3SCd5rZql8ITy3QmanFVPBkLRwAAuABP9Gzxrpv
	GE/1FnQ9tMVl8HToRINgMRqUFtl94YaM1V8Xkkx17Sl457HHjDSsMJ1MSPHPW5CiKgAEMeh9m4/
	1EIiD/b9nmV9qOBkT0hSKJJWiye5GLAjIJSfsKzz0vh10OGbpANx9m4l36cS8+RiIeaCHflElSo
	YYPF6Kus0//wZDqCk8BmXrUmNpibB3Ph90QHKYiRl7lGzayF1r/pjasla4Ff8gD7cQB/VlGcebj
	OVYES3dtfYbKuOgvZuL/XGspgG/9DLhsVNO4jVfw/W
X-Received: by 2002:a05:6871:50c6:b0:43a:ef08:6551 with SMTP id 586e51a60fabf-4466bf92904mr6604021fac.5.1781789981789;
        Thu, 18 Jun 2026 06:39:41 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-18.dlp.protect.broadcom.com. [144.49.247.18])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-44309013d75sm848723fac.13.2026.06.18.06.39.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jun 2026 06:39:41 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7ff5a7f8e60so15343397b3.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 06:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781789981; x=1782394781; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5JxiypfqVPKigingCF+VnDPCnwDPNT0FMQDtrw3STTA=;
        b=GmO/X7kHPJ/9jSlqc8yvDY/d48xZ/nj+b9GA42uy8GPpy6VvPIiGG8DQce4XUWxC4x
         jp4k9y2+2BsfTaGp8Cu/Spf/jlru0I065swEbUyeSzrKhUuO0oHGP7UO5XWrvP9jsxTJ
         iD2aGs6q+sD1FhmWzX0tDSVAziyPs0HOz/dU4=
X-Forwarded-Encrypted: i=1; AFNElJ8xIJ7C422S15PQB2K8pn8SYoeAfD1bX/mpeZBWKpTMuN685Ioj/OZTMTUJRD6B6B8/d8FnJj5xYLSw@vger.kernel.org
X-Received: by 2002:a05:690c:9b0a:b0:7dc:9693:57b0 with SMTP id 00721157ae682-7fe5ff70384mr96845557b3.42.1781789980678;
        Thu, 18 Jun 2026 06:39:40 -0700 (PDT)
X-Received: by 2002:a05:690c:9b0a:b0:7dc:9693:57b0 with SMTP id
 00721157ae682-7fe5ff70384mr96844987b3.42.1781789980017; Thu, 18 Jun 2026
 06:39:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com>
 <CABPRKS_Ek4JHDs9pBg2nium+AjHhM_JQ8su1=vrcOg+xME7PjQ@mail.gmail.com> <3cf79f92-a492-45f4-838b-dcbef0a44147@flourine.local>
In-Reply-To: <3cf79f92-a492-45f4-838b-dcbef0a44147@flourine.local>
From: Paul Ely <paul.ely@broadcom.com>
Date: Thu, 18 Jun 2026 09:39:28 -0400
X-Gm-Features: AVVi8CfhQbyv571vum5m_G4lES88LEcoZSlBfwLwcVIVo9upeZyfTLzecKi1krE
Message-ID: <CAEQnVQmMfc96nWdC+0UA=vUrhHPSK38=rg+h3742AHTWD9qXYA@mail.gmail.com>
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix race conditions in ELS retry handling
To: Daniel Wagner <dwagner@suse.de>
Cc: Justin Tee <justintee8345@gmail.com>, Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	thinhtr@linux.ibm.com, Justin Tee <justin.tee@broadcom.com>, 
	James Smart <james.smart@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000e42b530654874ec7"

--000000000000e42b530654874ec7
Content-Type: multipart/alternative; boundary="000000000000d33fe80654874ee5"

--000000000000d33fe80654874ee5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Daniel,

I have been testing Patch 1 of 3 for a while now but no reproduction.  I
reviewed Patch 1 of 3 yesterday with Justin and we think it needs some
minor rework.  The hbalock is not required around the bitops functions but
generally, yes, it does seem to
close a hole with ELS Delay retry.  I wanted to review the logs again today
to see what is necessary to get this race in the first place because
Broadcom stresses this path a lot during our testing and we just don't see
this.  Our reproduction of this issue
on x86 and P10 with the Avocado framework did not produce the same crash
either; the crashes were very different.

Is a bug opened at SUSE for the crash?  I would like to see what testing
SUSE is doing to produce this.

Paul





On Thu, Jun 18, 2026 at 7:42=E2=80=AFAM Daniel Wagner <dwagner@suse.de> wro=
te:

> Hi Justin,
>
> On Mon, Apr 13, 2026 at 09:28:38AM -0700, Justin Tee wrote:
> > Broadcom is currently reviewing this patch set and will report back.
>
> Any updates here? We just started to see crashes in our QA which
> show the same backtrace. I am going to ship these patches to our QA to
> see if it addresses the issue we are seeing. But it would be great to
> get this reviewed too.
>
> Thanks,
> Daniel
>
>

--000000000000d33fe80654874ee5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-size:small">Hel=
lo Daniel,</div><div class=3D"gmail_default" style=3D"font-size:small"><br>=
</div><div class=3D"gmail_default" style=3D"font-size:small">I have been te=
sting Patch 1 of 3 for a while now but no reproduction.=C2=A0 I reviewed Pa=
tch 1 of 3 yesterday with Justin and we think it needs some minor rework.=
=C2=A0 The hbalock is not required around the bitops functions but generall=
y, yes, it does seem to=C2=A0</div><div class=3D"gmail_default" style=3D"fo=
nt-size:small">close a hole with ELS Delay retry.=C2=A0 I wanted to review =
the logs again today to see what is necessary to get this race in the first=
 place because Broadcom stresses this=C2=A0<span style=3D"background-color:=
transparent">path a lot during our testing and we just don&#39;t see this.=
=C2=A0 Our reproduction of this issue</span></div><div class=3D"gmail_defau=
lt" style=3D"font-size:small"><span style=3D"background-color:transparent">=
on x86 and=C2=A0</span><span style=3D"background-color:transparent">P10 wit=
h the Avocado framework did not produce the same crash either; the crashes =
were very different.</span></div><div class=3D"gmail_default" style=3D"font=
-size:small"><span style=3D"background-color:transparent"><br></span></div>=
<div class=3D"gmail_default" style=3D"font-size:small">Is a bug opened at S=
USE for the crash?=C2=A0 I would like to see what testing SUSE is doing to =
produce this.</div><div class=3D"gmail_default" style=3D"font-size:small"><=
br></div><div class=3D"gmail_default" style=3D"font-size:small">Paul</div><=
div class=3D"gmail_default" style=3D"font-size:small"><br></div><div class=
=3D"gmail_default" style=3D"font-size:small"><br></div><div class=3D"gmail_=
default" style=3D"font-size:small"><br></div><div class=3D"gmail_default" s=
tyle=3D"font-size:small"><br></div></div><br><div class=3D"gmail_quote gmai=
l_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Jun 18, 20=
26 at 7:42=E2=80=AFAM Daniel Wagner &lt;<a href=3D"mailto:dwagner@suse.de">=
dwagner@suse.de</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);pad=
ding-left:1ex">Hi Justin,<br>
<br>
On Mon, Apr 13, 2026 at 09:28:38AM -0700, Justin Tee wrote:<br>
&gt; Broadcom is currently reviewing this patch set and will report back.<b=
r>
<br>
Any updates here? We just started to see crashes in our QA which<br>
show the same backtrace. I am going to ship these patches to our QA to<br>
see if it addresses the issue we are seeing. But it would be great to<br>
get this reviewed too.<br>
<br>
Thanks,<br>
Daniel<br>
<br>
</blockquote></div>

--000000000000d33fe80654874ee5--

--000000000000e42b530654874ec7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iId6lRoDnFAsEvnaOMvg29iSc9gZaFsMAV8NLrmVgatBLqETEHgQ4n1BrE2+pRoymE80Zf+Qe5W6
GF5zYMjxe2smznZoexz/BISo+5QDZaKZKtmoZ3ApyLjKz1G5Q2hUhmZWHvMu/eGSXP59UaUUmelW
ZlVs3E0h345YpaGuBNlquYm35nQ3ehYjm2jqaIh7F7K0+eF5TPjcMLpqnpak12xIx6BCxmFi8Oqu
Gb9+KrrAD+KPgqzjyZZxdVcCAwEAAaOCAdkwggHVMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8E
AjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxz
aWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDov
L29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EM
AQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwIAYDVR0RBBkwF4EVcGF1bC5l
bHlAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFAApNp5ceroP
ry1QLdugI4UYsKCSMB0GA1UdDgQWBBTc34vK15RY7h33segpWeDeAloTGDANBgkqhkiG9w0BAQsF
AAOCAgEAb0hABkNonbsXXPrDOwB9B9lRtVhdRszakaT0zWubTTtHAV/XTebY1b4caUC2iX9AJvr0
XTJrFAiLtJ6eeP6yQOjD+rBprWauwPUzydJWEftECpX/lbPgZLBSHx22euCSnIm8HNj8o0bMi+Ii
plCW6kU56G1krQY0jrqDJCFgH4Wmp1TrKi36iVTIXyYLDtPOcSXe9hLmeUlQuL4nAoB8EsI45w4a
5Wi/xS7vGQLXzXAQ2SY6Yuseqhh+QcXvzeb0uVB54edC4HFrVX9DtFzHXoyB9s0C29MZm2zpFPNS
DgwnsmTsvpPuLELuuaJvIKnSHHR9FKrmQZbmz/i6KyBt0enmjNk7I7vAKQa8IqZxSrjvR6tYExiq
BP9ZuiXJnuqoPujFE7kphkUjmK76yv8904eZNflTvcEDpthD1boifOzT78iQ3fbuytR8LKx7tzGV
Ga9+dcLBcR/eP85Vmc9NW1frtO3dRd26+DHs1lXX96Em5AAlvBgDw8b1GfyEvfimBkxTIWxR3mBB
jAMkNKrfvV7NxS9AfcFu4fvxuBJc+t2FN1zBc8VyVyn9ZBeJ2DYS9uQ2x00QPXMHqVlAT5fBanmS
n1fgcSTdHEy1fzVZIAtM1XMIWy03bJKNBwUebgxHKHSUCZ7VSMHE4jyERMCqkvTxU6h4JJ7YzRrU
jhXYo8oxggJXMIICUwIBATBiMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAyMDIzAgx9OiWw8dVRSIkn
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIKoXy6OY0K6xJI2VZsOcZvaszfMy
en4G17GutjrjGLU1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MDYxODEzMzk0MVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBALB5S8Q02YjsPxzyu0q7FUQED28FhtY6oq1mTMTeCyJfAkECyXyrTqYRntvRHLWT
08zrfVTZGS7sECyJPa9xzfEKpabQi3w9YobCAiQj60f67HrMtgzQFvrCWrJNS+WLwQ8pFlIejEff
+Jzjj/UOjRmbr+4A4cKCdaqtE6TuVTkWh18WAtS50gJwBfQigVJ03Bfm5ztpRAouVKW8Nfi+CYUU
dXQ8+DLnIVHRGHDoTTVJJxU9CgOtXPTEp0+aujqa3KCYBOjglwM48Co7dY9k2Lhzch/f3cTxL91j
swj2i73LrhkUZGW+PGuiHUCderL6whxG4brDroTCehsHEYwtzMk=
--000000000000e42b530654874ec7--
