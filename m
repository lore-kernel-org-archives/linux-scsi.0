Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F214D7975
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 19:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789673643; cv=none; b=atlnt7C7L/YaOvy94lVbQA4zwACk3dvYSJhWYda+g3jNzkStZsuTSDDSStgXNq2qNMnvfxaOL3SQgOqYi3OMgsR05R5/RgEjfs2GIfmfA7yK09Of/OEGCSkZ106Uhz/J25mbv8gnnSt5UKvpub0p0LyUOxj8G1H3eOl6lswwnLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789673643; c=relaxed/simple;
	bh=+8gkfNgyD4C+YnRcRs8gtVSvFq/6SS8hdT1SnuDYgn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PAVmtw2steebNsHsSvw+oozuY4rTaX7rqfqq2quj6nivLLawYXVpn8NLE6WpGR09wJZO1yBSwpl3XS1jQYq0Hk/rgjvWLjm3YaHZm2dLSUojV7aGs04rj7zlwp59CGQoB0ib4ekZpzSEvHayRwRmJCxZZJCbmLbBpulOVtT4y+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Pj9FUtYP; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Pj9FUtYP"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-8699f9fd466so15241b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:34:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789673641; x=1790278441;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c01Xdrklr8ZPIk7r6pT0TpDzeDL10OQErlYb9vbUCCM=;
        b=d8F6HufyY7FjG+L5FT+wDjPzgsJb+nar15ZutjT/ZvOCpfCs0CeCJr0AdcU7sD9KEl
         8hj1sTGNoTpWO63WkKkiKT6q1eXSjZAFpWg9Y2+ham9o5oxKsTX0kJRl9meFZXPEaU5U
         MULFPugada9n0b8SdSZPi6Bo5cUol+n5oEjHgQWYQtbMfajtAcataEZY8HkBSUQATLBR
         iRVajio40KVZnh4mofhcKuMlZui++COiqAsEOTTbFiM5nSatdlZ1k22X7n7gYPcE/R7f
         LzE/c5/hnT4ZtSuTnHlXFA7v1m6lGj43QK5QghfT2K/0A4x1I6UvG0LFaiAfYMzFjpqF
         /F/Q==
X-Forwarded-Encrypted: i=1; AKwUvByNOJ0ugwm27zI7AiPCbC6gYNGTrfP16wfpEeNUgGbQ5rA6AGqHMQkN6CS4BfRQ98Ztd2bpr439iwUu@vger.kernel.org
X-Gm-Message-State: AFuF++lP5cl+6QDI04Fzf2kRH9m+hiB7z4v4QJAJpJsZvASGO/1x0Lho
	UXDau/V7HZXBKy3u+nrk1nwhLK3oAMAeqlH4fGOvDnC7pk4fWhzkZAeGrwMcBDH64uD024ioWx8
	KNjqkcvUBI14OKXdUt0Qm1Taca99ra5gz/WEbZTq0HM31pXEEYuvQXC5iNcpi6R8NVFetHfqcCN
	12NWobYbShAsU9dPK7h8DiyZvI3qSOxwY83EFW0PZscAmWlFh0dnrZlcLxCkobk7hMoBr6uSlu/
	2XooauEBMs=
X-Gm-Gg: AYBFou2SuZyQuBB/MbnoViCEgHNWtEjQfqTR+5I1/HN2zodjQ9LNnZnUrLEF1QrhABL
	eW92OfFO5tl1jN1qere3ZICLyRLeZdXlbNJ4KO2bBiwugTVwE2edYbIHncXLwewQjSPxpkAHitP
	JcIrAfsSYF2awUhzmG8MDrjRAFLBSQMwgPeDPT/B7AIYrY3MxvxQMPZyQ5M8XdPc8W7VfJRwxzY
	SuizNttHPRQDKpV+avKPLogfNZW9dJabRZQ21nGsoYHALQFxHIT1mqHZP6loKIPkUbEIzSVI1bO
	HNvdKNo7DOAD/W/+OOid944w0KpfIzZBiR5u47L6CrMRNMDMi790YEd/2/ZRdcyaDT3Cau9Qm3K
	jt/3oFzUtY96UOfGDRpNAlepwm6KlUVSK5JBU7c8KwvraJgQi2qq0OPswhQTa26qJRew+3vpK2g
	wM8r/4YUSDJ/QGv1OSTWPcvQbiVkuUJQ==
X-Received: by 2002:a05:6a00:e10:b0:874:706d:8570 with SMTP id d2e1a72fcca58-874debf6aaemr42459b3a.33.1789673641006;
        Thu, 17 Sep 2026 12:34:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-87200a5d3c1sm1981174b3a.3.2026.09.17.12.34.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 12:34:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66f8a19cf9cso30742d50.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789673640; x=1790278440; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c01Xdrklr8ZPIk7r6pT0TpDzeDL10OQErlYb9vbUCCM=;
        b=Pj9FUtYPTwZ28ZB7Bm+mkXueQ7Flp7pdXdkmTAhVm+skjOY95gxfwOJGLQgauggHgI
         5VaSlzOOMELR0pC9y897cPNJKJOC+wVng7lICUNDJTKKsoxsTVVJJq+prPnMa8PZ56W/
         5h/K1KAP4gxWog0qkqSZ2IXpzAugEN8VfWTEw=
X-Forwarded-Encrypted: i=1; AKwUvBxHoYezck6yVp0j1RFehVP1TL0mI9MuH7IB1l3KAwHgejD5vjhKTrtPCMCFW2OLBs1SXyNgdyg87RCc@vger.kernel.org
X-Received: by 2002:a05:690e:1248:b0:66f:c1bc:8800 with SMTP id 956f58d0204a3-6717fe2682bmr48216d50.89.1789673639655;
        Thu, 17 Sep 2026 12:33:59 -0700 (PDT)
X-Received: by 2002:a05:690e:1248:b0:66f:c1bc:8800 with SMTP id
 956f58d0204a3-6717fe2682bmr48208d50.89.1789673639203; Thu, 17 Sep 2026
 12:33:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917144330.2157527-1-vulab@iscas.ac.cn> <CAEQnVQ=4BOue0djLgtBG6fukuqjvcBknL9EXnSs6R0eYd4jybw@mail.gmail.com>
In-Reply-To: <CAEQnVQ=4BOue0djLgtBG6fukuqjvcBknL9EXnSs6R0eYd4jybw@mail.gmail.com>
From: Paul Ely <paul.ely@broadcom.com>
Date: Thu, 17 Sep 2026 15:33:47 -0400
X-Gm-Features: AcwNN1WrUxjfknpHF_DNHu4FD_QQwisWhKImRf7bB1Eed0nUVQ02cogBTvU8xSw
Message-ID: <CAEQnVQkcDdS=hZ66TBETxs=FguYe8EU8kyu2mCup_M4AnUKSGw@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix use-after-free in lpfc_els_rsp_rls_acc()
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: James.Bottomley@hansenpartnership.com, james.smart@emulex.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, stable@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000094af01065bb2dd1e"

--00000000000094af01065bb2dd1e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixing bad email address list.

On Thu, Sep 17, 2026 at 3:32=E2=80=AFPM Paul Ely <paul.ely@broadcom.com> wr=
ote:
>
> The ndlp has an initial reference when first allocated and the
> lpfc_nlp_put moved is for the outstanding LNK mailbox.  Unless there
> is a driver bug with premature puts on the ndlp, this bug can't really
> happen.
> I would like to test this change before Acking it.
>
> Thanks.
>
>
> On Thu, Sep 17, 2026 at 10:44=E2=80=AFAM Wentao Liang <vulab@iscas.ac.cn>=
 wrote:
> >
> > lpfc_els_rsp_rls_acc() drops the ndlp reference held for the
> > MBX_READ_LNK_STAT mailbox command before it logs the ACC response and
> > before it takes the reference that keeps the node alive while the
> > response is being sent.  If that was the last reference, ndlp is freed
> > and the log message and lpfc_nlp_get() below touch released memory.
> >
> > Take the reference for the ACC iocb before dropping the mailbox one.
> >
> > Fixes: 12265f68ae92 ("[SCSI] lpfc 8.3.18: Add support of received ELS c=
ommands")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> > ---
> >  drivers/scsi/lpfc/lpfc_els.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.=
c
> > index 4e3fe89283e4..bdf8fe3e77a5 100644
> > --- a/drivers/scsi/lpfc/lpfc_els.c
> > +++ b/drivers/scsi/lpfc/lpfc_els.c
> > @@ -8782,11 +8782,9 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC=
_MBOXQ_t *pmb)
> >                                      lpfc_max_els_tries, ndlp,
> >                                      ndlp->nlp_DID, ELS_CMD_ACC);
> >
> > -       /* Decrement the ndlp reference count from previous mbox comman=
d */
> > -       lpfc_nlp_put(ndlp);
> > -
> >         if (!elsiocb) {
> >                 mempool_free(pmb, phba->mbox_mem_pool);
> > +               lpfc_nlp_put(ndlp);
> >                 return;
> >         }
> >
> > @@ -8824,6 +8822,10 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC=
_MBOXQ_t *pmb)
> >         elsiocb->cmd_cmpl =3D lpfc_cmpl_els_rsp;
> >         phba->fc_stat.elsXmitACC++;
> >         elsiocb->ndlp =3D lpfc_nlp_get(ndlp);
> > +
> > +       /* Decrement the ndlp reference count from previous mbox comman=
d */
> > +       lpfc_nlp_put(ndlp);
> > +
> >         if (!elsiocb->ndlp) {
> >                 lpfc_els_free_iocb(phba, elsiocb);
> >                 return;
> > --
> > 2.34.1
> >

--00000000000094af01065bb2dd1e
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
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIPNIcm8D/CSfwkQtqgK7NeT6Q1Qb
nOW5NExJdfvU2ua4MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MDkxNzE5MzQwMFowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAB0SQi8qITpB22VQ0ewhlZFqP8iFc9iSojA66MUU3r5kuAJfyBoTN1ZkMA3BnUM+
XtV1RRoYPMdjp4sVEXmh7ChiOr4o/itND0AG/o07r1UZzsymcc+PhY3Q2MmFtj5h5nMLpvH9lT1O
VyTdNYeut7BeOqRLkcyrJMDaCrd85kkWESAYFie6pPTfu03AoeaOLX9sdS8xaooy65Xx42B4tG0r
r4oEU4sXnx4JaiZmKefoNitYxC75Ow8ntXKIkS55OXIXbwXwtIlr5oLpwqcXOb2PQWJD3v6Ghbtg
UNcJS2EUQC4Tuwqzh4nzSrp1bmgMKrAHXwK7GnlWsjBuGBFcBr8=
--00000000000094af01065bb2dd1e--
