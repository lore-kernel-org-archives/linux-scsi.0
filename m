Received: from mail-qv1-f97.google.com (mail-qv1-f97.google.com [209.85.219.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645D44E4C26
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 19:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789673755; cv=none; b=XlnSXrUHN5gfHGBJ7HkxRgWlYEfuMSmDH4ICf/wlhmA89P3J59HqN4EAr/NB2F6h4WSpzSUzbCLbDDxuv0C0OrDu4u5YOJ4ht8kZizcOHQHW9wRhtsR8ENRwiDDM5wePb1rdGyxfRsdWoNeJA53dCENTjTPZnbIXpUKfiqXuJNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789673755; c=relaxed/simple;
	bh=IVvdY6GKkh8kihWaZoq9CrXMkEaISiiCstSsCctWjGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ozk+qbmHcxyxNoiKxGgE4PlgHk7KiHrGkhMjnIujyWbpfpGhyoyRDZkk0wiY1lPMHMG+1zyNJNjyKmDWA2GLOGyxymRHYQyDpVjPJ4ossiFpjCK6X27HZ/iJ62inCDa4fzT/kUVPZGRdgUJrfn7l1GB4heVyRL49zgRGjJBhMUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PU5pbl7j; arc=none smtp.client-ip=209.85.219.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PU5pbl7j"
Received: by mail-qv1-f97.google.com with SMTP id 6a1803df08f44-90e7bde5596so86426d6.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789673753; x=1790278553;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0r2LQq6dqJ/lWtA+iPMc2kXJa0NnT91GIYShDmX0YAE=;
        b=Z9j5LX+rrnLqhgN03nOJGSvqthJD9rZ/blZ7xu+K5NxQWwtwZZZvA/GkBOuQvrv8Sj
         7bOSEWaJBLyZPw2qLqb8sZCMlUTXSfktI+CQiuDb4HpgzvELpw90pHmQ85XXNKmIwkil
         1y35lF3KR0fpsYJMxvzR8Bhfs/Ebek9VNkyWAtRCeJaEvXmK1v7tk/8kDHuqphQFbere
         38RgTqMdNdkXbeLBFTneYcwrYVssvpocKtHo9pCSIFDjezQU9FBUhVuNNLaElLoK8Sm2
         sn0hRMBUGkloMxekzoK7juf3Gp9SZz4d3c1BVTVQMUiPSuiCnNfGbWUtv5/GEucGBNoV
         W10w==
X-Forwarded-Encrypted: i=1; AKwUvByB9Y62YeWRrErlU1y94j53+Q3OkFacW/k1cinmDWvgb7/cht6/+LPDFjVtlTNfGLTSMruMewl74hio@vger.kernel.org
X-Gm-Message-State: AFuF++nrG2gdRqqBOEVpkp7u5yF8j8+3Y3ZyaAM4EW46VrPRgtLR5pFd
	9WalAw5rJThAZKlpTSb/9CgX1yP7tCEcU7jpykhaQ8k9MxnOmuVPfDBe1G17hYC1LQ2e9hklWlE
	EPVX2fSm89+iwvgvrc38pfqY8LD8GNJjOiyYiVwUsMHdNnEY+qSd27TeEUThkD8nVQVAq99E+4m
	fAaKa8rPTJ3n5d6BGiVI8tkI0lUAzMki3Cbng+Fy6crRqYi/lcQQqRf64MmWx8C7xQMUV2vxivE
	+kv0W12Nf4=
X-Gm-Gg: AYBFou0siUYLOXKeD+9wPpGjx05N9UPNOoHyxzWgxDMNRrKm9Ev0nscDgC+NiG4wncx
	LpFzy6ysxP2lplzwSjn/pLztWZ45IW7Bfeoo5duq1ZzNNw+ZVp1MU/E/TkKP2VxuacdzPqiZ5x4
	fUuawOd5TpA4Vf6+JEu0sWzab2fFn+8da7nONndIfjZ+LTIBbesGFZqg/0KassC+jrovWCaaxAr
	ydjCIYDGTYOIrkt7l4iI6glU+RC/sah6UczDNb6VuXUMPiTd7nLJhL1ih919KdDfhGRMFbtMh/T
	+hEArXV++e0QC1SZP746td3EvQY+FtaSCRqfEAY+eHtVuL+dcI7J5txNZ3LWguNkR4elquhouWq
	NOenWoS/lhUS4yLS9mUZBdqXp1ckhYPfCmjEdnOUW8gkecv8nWTeOgoXnRZgxeUo5cBlg0/IwWK
	GwyAFpgf9BjSU5aCjNPzs0/BmrKF7Wdg==
X-Received: by 2002:a05:620a:440e:b0:927:25f5:ee08 with SMTP id af79cd13be357-93bb7937073mr1289596485a.43.1789673753196;
        Thu, 17 Sep 2026 12:35:53 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-98.dlp.protect.broadcom.com. [144.49.247.98])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93b7814dc0esm65647885a.3.2026.09.17.12.35.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 12:35:53 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-88b853e209fso10919997b3.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789673752; x=1790278552; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0r2LQq6dqJ/lWtA+iPMc2kXJa0NnT91GIYShDmX0YAE=;
        b=PU5pbl7jd+n0tnYslGkWuHU1Qex92zRkpTmTqK53P1AR83oGZZjXQZq5b1uQZpFVpc
         JJG7kNpy2sSib+FJr0RzfU2THjrPd2weecfyM8oDpFa0RynfHlMIu+ryp8PXbDW9ZDQq
         OIL+OkAQfuKhK6nbV2G6vsM7Dh7PcR3TC0y8E=
X-Forwarded-Encrypted: i=1; AKwUvBwyOQHXVrnnyCewYifF3upYiLlfukTjfxwsn4z0OtibSUz0ysfTlnjY3nDvjjxbCpx5HvzAEpAoqlWl@vger.kernel.org
X-Received: by 2002:a05:690e:b8c:b0:671:3aae:2509 with SMTP id 956f58d0204a3-6717fc66f8dmr64565d50.12.1789673752423;
        Thu, 17 Sep 2026 12:35:52 -0700 (PDT)
X-Received: by 2002:a05:690e:b8c:b0:671:3aae:2509 with SMTP id
 956f58d0204a3-6717fc66f8dmr64554d50.12.1789673752037; Thu, 17 Sep 2026
 12:35:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917144758.2157707-1-vulab@iscas.ac.cn>
In-Reply-To: <20260917144758.2157707-1-vulab@iscas.ac.cn>
From: Paul Ely <paul.ely@broadcom.com>
Date: Thu, 17 Sep 2026 15:35:39 -0400
X-Gm-Features: AcwNN1W4sikGhRrgV9jodJ2E_SlAFtpDAos2SAQFSJSVma5aO7-ubQj-1khCaws
Message-ID: <CAEQnVQnWk2ADAvLEVCrgNE=dtf3D4DJ-UcosUQgGDj8=AMnA2A@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix ndlp reference leak in lpfc_release_rpi()
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: James.Bottomley@hansenpartnership.com, james.smart@broadcom.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, stable@vger.kernel.org, 
	Nigel Kirkland <nigel.kirkland@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000004b45f7065bb2e44e"

--0000000000004b45f7065bb2e44e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Wentao,
I need some time to read this one and test it.

Thanks

On Thu, Sep 17, 2026 at 10:48=E2=80=AFAM Wentao Liang <vulab@iscas.ac.cn> w=
rote:
>
> lpfc_release_rpi() only drops the node reference and frees the mailbox
> memory it took when lpfc_sli_issue_mbox() returns MBX_NOT_FINISHED.  The
> SLI-4 issue path can also return -EIO without submitting the command, in
> which case the completion handler never runs and both are leaked.
>
> Clean up whenever the command was not handed to the port.
>
> Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taki=
ng")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_=
nportdisc.c
> index 9c449055a55e..055f44ec7b94 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -1142,7 +1142,13 @@ lpfc_release_rpi(struct lpfc_hba *phba, struct lpf=
c_vport *vport,
>                                  ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_=
flag);
>
>                 rc =3D lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
> -               if (rc =3D=3D MBX_NOT_FINISHED) {
> +
> +               /* Only a queued or completed command is handed to the
> +                * port; other results, such as the -EIO returned by the
> +                * SLI-4 path when it cannot submit a non-polled command,
> +                * leave the mailbox and the node reference to the caller=
.
> +                */
> +               if (rc !=3D MBX_SUCCESS && rc !=3D MBX_BUSY) {
>                         lpfc_nlp_put(ndlp);
>                         mempool_free(pmb, phba->mbox_mem_pool);
>                 }
> --
> 2.34.1
>

--0000000000004b45f7065bb2e44e
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
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIEK3aGlC40WOC+3p1yHPclATJEFR
VE6X9S5DLGhLLG9OMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MDkxNzE5MzU1MlowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBALdIrpvI8/LHFctDl7uvC5XlKGsljY2eR/MCUECRhRqO5+uMhim78RnoNGuJyJhi
iVjfdMqwt+P+R3QH2g+08p9VfU31FsUvo4vIlZgLhnHVn8AWtodvpxmxKCCsrpfsqsY7lS+X2TG2
O5mUbVUOzoiCxSyGVCyD8rOLndN+Q78Wcb7xQPcDB2Skm0K0I3syrHEPlaKyvbqOE/a8pUR4W8yn
ow/8SywUTxfRfV+2J4Wn5OdzL4vwDf1pYietRie0vi2+KVyVuVrf+/nwj3IMqIQWS5bwiJjTHa2Y
fAvXQx/7tn1y1/EJMdivjATbi16xSi39E3YOYbmuwCEr/7TbEVk=
--0000000000004b45f7065bb2e44e--
