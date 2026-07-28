Received: from mail-vs1-f100.google.com (mail-vs1-f100.google.com [209.85.217.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0A73A7D73
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 12:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785243432; cv=none; b=G7pDv3g3NbhWi/HBgAxZCqhf0umKp5bNXU86fQLoYid5lrKfleDiEOgmxTkwnrfa8Ww8Kl6/VzsW9vzrBuM+uAcRSXoAB7+6OlKNO/7S3BoOrRanP1Pi3VHnCO8HVEHvvVWOMv94kidNDLuTAHesAmFQvf+9xvynOt9N5PMjYVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785243432; c=relaxed/simple;
	bh=6occsP+QFOdw2VS8CrAc7TI7gFRwd/Y/buHQqK9/jg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J1jbqws/9U+adQGMx8pirXhF9KTzDGg4dft+Z+mjNcC5tn/QPeFyP7FrQkc1XX31JaxgmADTBDyYXtan9mksw17BHBbq8LUHA3pVwtM/jS0INzEZYfA9Oypr42O+0nv9Xe+3Gpb7Owx7vigSXb8fbhIP3Dsy7CFJgUmm2ktGEG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fz+x5K/V; arc=none smtp.client-ip=209.85.217.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fz+x5K/V"
Received: by mail-vs1-f100.google.com with SMTP id ada2fe7eead31-74dceb46291so1355326137.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 05:57:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785243430; x=1785848230;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d2q2Ma2hgQ2l1UlXaea5AdfMgpdZSW2O7TFyvHTZ/PY=;
        b=SrjjcSfCzx0dU6Zf+ZEpAfmtj2//mVkEQBcRfcJ0zGMN0Emq0MVDO8LX9oFgzNvtH+
         UQ+EcSaRhdM/t+mdRrUKOMjYrLh3TXb4PZpZQ6E/w/AHLl7jDiTjk7N5WFTBNBnfQ34u
         jz6tehXp6PqafnY+XVa97J0k0eCG/ncDzJHmx39FWJDZUwo9nb84R8UItkaTaSkD+HZr
         TmceSC8z5COGf1Rbwc9d+GLSRCn6iMRoGveqSXWaHMPI9qmvgnihH3fE/I6NpZ1Bg8aN
         9UPOLEJef7BEiRKa3WHRCBOlwjqFvubEFU6cxzNyLcmd8OdVwQ0wO0WphMiA1kebnE4O
         +ICQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr+nVB6n89AmfQrX/Km2VvOSpb79bPbmDE0b+nlOhhsoyNRrcvTnHEvvVYhRlFo+3kZoGfNJM3gTZSx@vger.kernel.org
X-Gm-Message-State: AOJu0YxRbLmhApp4dfb9AqAKh/FNwLuB93mTGRKyKIE2ecJ+hVAlyatY
	6co6W4GIssMPgh6+OO4PbwW2sSf8nfy629qOKlssZNlNeqEWxJJ1d1RCOnFgZv2ixHPZC5p7wrR
	o+MXEsvyRfuGlYsC+J3qx646FlYXdaVDtaQO8OqeiKahBJurVzYhl+O/D3Zk8aVcrvckiiHqnfw
	XO38iJbOIQDQV2/gqppcCIzoU4Oif7T3ulDkXJVOmEL7XR1IkbKjzoz1ITliCo0GeNabxhJLiPX
	bRgbtECsz8=
X-Gm-Gg: AR+sD12yRtE20FlPU89aV9ONxk6dR8gYg8zUGgTe6OtmV2sxHef63gxjeA2ZMiYe/1E
	RdnpmAjll8K1pMyumt0qJQ3ydEHie/FVuz0tJ523Uo79Xy+VrcHLtrS4su6vl3r5uFbPKq8gVXJ
	FZYqVcS/gSRdLzonTsM6EihT0OP+AZ37x6GNZMWkQoDnOAr+kEv41dV9xiadAUFWyzMDXvYCi+i
	FweaDsgvdWq5RoDShr/rVdegJ8H6/KOn9ZsMtfDYmakOIdoj7GdQIdh98stsp1e4K/uYSPMqr2E
	U0xuw+OPG/HQTPd66xClNZ+foIRFFJzcUVNP9yrEkl/9ikdX6zhfOckchL+Q+V2FxCIUB3M/ddc
	Hmvzuv/+NueuN4mXZc2QZJt2SJ77AwiLlQIQh2ZUwE7ykEoT2kKCB2C88pGH2uPmcOaB0/MUy7U
	cfJPzVYgL84lcYdztBH3m18GtJjxt8Yg==
X-Received: by 2002:a05:6102:1487:b0:740:2717:a1b2 with SMTP id ada2fe7eead31-7549f251658mr1131654137.1.1785243429951;
        Tue, 28 Jul 2026 05:57:09 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-7503346989csm741671137.5.2026.07.28.05.57.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 05:57:09 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7f5b54da461so55879357b3.3
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 05:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785243429; x=1785848229; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d2q2Ma2hgQ2l1UlXaea5AdfMgpdZSW2O7TFyvHTZ/PY=;
        b=fz+x5K/Vvv2rlXc23Vc2uxDlcabamM9FphyH857pPoQZDQmfEgLIA/sUzN9sK9v6mq
         H9R9XfJfg12IVYWri+LAHLtC7XgzrwtHoUR66J6xBZE6SejrLZZskl4Sc5jpKQk5H7fP
         dEDVPAOFURa3gxYt1eRg4UCvpaKeBFNAWnlPk=
X-Forwarded-Encrypted: i=1; AHgh+RpTRXieFif9ZwwIlw0RdFH6Js5Xj2cshKt1PYyiTXEJ0BcuAMXbpW3WqURBnmvGIElfr/baHmeuNdyV@vger.kernel.org
X-Received: by 2002:a05:690c:6a03:b0:80c:9983:5e5f with SMTP id 00721157ae682-81f9926f658mr7561107b3.31.1785243429195;
        Tue, 28 Jul 2026 05:57:09 -0700 (PDT)
X-Received: by 2002:a05:690c:6a03:b0:80c:9983:5e5f with SMTP id
 00721157ae682-81f9926f658mr7560967b3.31.1785243428753; Tue, 28 Jul 2026
 05:57:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com>
 <CABPRKS_Ek4JHDs9pBg2nium+AjHhM_JQ8su1=vrcOg+xME7PjQ@mail.gmail.com>
 <3cf79f92-a492-45f4-838b-dcbef0a44147@flourine.local> <CAEQnVQmMfc96nWdC+0UA=vUrhHPSK38=rg+h3742AHTWD9qXYA@mail.gmail.com>
 <3f8f6510-5751-425d-bb61-59c46565dd9c@linux.ibm.com>
In-Reply-To: <3f8f6510-5751-425d-bb61-59c46565dd9c@linux.ibm.com>
From: Paul Ely <paul.ely@broadcom.com>
Date: Tue, 28 Jul 2026 08:56:57 -0400
X-Gm-Features: AUfX_mx1510NJC1C7zgElBr2xPzAaglzWYzgZ3RCdnlwuFkl_enicCa9gt2eXAk
Message-ID: <CAEQnVQmRL32cjAn1bOHgEuyFtpvNFu=Nt6dq6jy8V-BUFBBZMg@mail.gmail.com>
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix race conditions in ELS retry handling
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Cc: Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, thinhtr@linux.ibm.com, 
	James Smart <james.smart@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000073d83d0657ab608f"

--00000000000073d83d0657ab608f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Kyle,

Sorry for the long delay.

I think the routine lpfc_cancel_retry_delay_tmo needs to do the
test_and_clear_bit op first and without a lock.  The Linux BitOps guarantee
atomicity.

Then the timer_delete_sync needs to run next.  This two operations are
the primary
purpose of the routine and try to close the window with a schedule
retry delay timer.

I think the hbalock around the evtp->evt_listp is correct.  The
evtp_listp is a phba->worklist
controlled element so the coarse grain hbalock is required.

The rest of the patch looks good.

I'll post my version to the bug we are using to track this issue.

Thanks

Paul

On Mon, Jul 13, 2026 at 12:26=E2=80=AFPM Kyle Mahlkuch <kmahlkuc@linux.ibm.=
com> wrote:
>
> On 6/18/26 8:39 AM, Paul Ely wrote:
> > Hello Daniel,
> >
> > I have been testing Patch 1 of 3 for a while now but no reproduction.  =
I
> > reviewed Patch 1 of 3 yesterday with Justin and we think it needs some
> > minor rework.
>
> Hi Paul,
> If you have a reworked patch I'd be happy to test it.
>
> Thanks,
> Kyle

--00000000000073d83d0657ab608f
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
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIN+V9vR7fw7R2KVbNr3nrfOcywAa
Qwj7yRGkK6M8S4lWMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MDcyODEyNTcwOVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAFN13JwM+KWIMYSbdJpQEauKJ/4psQ5sfkIG1nOy84M/l8SihBSR4XVotV0VGf6D
xobVenw3w/hAcgJ6GSxE1OU1UlGma1d1wbHUfFG6u7aHE80AoRLMklS1vwnfMhBPHi2DJ9PWgvS2
Q4NUxt20FeXHEB6wSTC2CgJK6wLSzkDxe9a4kUGzrCOdEH7uWP85pbE3isVgsptfkk3w0Tl0AM6M
GJbYhC5Y1gsbF5eftOVUorzRiVp38OjGxPBvFcN1dyVw7yHdTfZzSKWMkpRBIbjJFx8D4lnQD8Dh
CvBQiD2sBQbvCeMhIqWeU+4lpj7XpoxGiXTNVbKBLByl6pfoM28=
--00000000000073d83d0657ab608f--
