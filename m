Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463C63C0610
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 15:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786719860; cv=none; b=lnWymthvGhTTT+rxXC5rKAlPFD2Hv07P6qdJIAEjbRwfxSIwPJf9ZUI0uchIMzetMW5LwyqGssKZMMiIhMwR2h+SxIQoJ5wHDvQh4CNMN6riVvrKpQ/cU0+EC98FF0946WcmMQ2WJ/EiOzB+51F49FiBGVBm8h4sVDTgCGazCls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786719860; c=relaxed/simple;
	bh=MFKBPcjvjrHtEwT/der+Ht5lyqZ5sPHFGoY6X6kPeNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IQqUHboEXi3kVG9k2ULLzD61iicJtpHDSPwRs0SH9JMHrEDM9OIVCHaxcZ0iLDz3MVxgY1edWEgWpx437K1v+0BByXG2kyRe+NHOhbQb/Cj2ZUPCV9ctzPwk3bD2IxVO2mqmZ9aomc+xv7myEEj5VzrbSXvZTgttXMB9ZXud2kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bo94Tu7S; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bo94Tu7S"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so954217a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 08:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786719858; x=1787324658;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O0r3yG9cQJBWGdRbEaw1Tj5O1yEGEWz4BN84WHUlxEI=;
        b=PsOrU2v1HL7xsXqmdM2ZlJgwmeFu2VsY0n4QYD/sMTDfr0qTmLs6DoK0qIea8aLlFU
         IOBBmL01XqWBxJxlBNPO+IInS8Aj8n4ndgXoQO8Lmxev2lfOvR+UxfzgbVNl/JC/T/cJ
         xK3yK4qktGXxEPH6OqU7BO6h8nBg7Tb4Ex9bxGBNoEp3UeaRCsuSKlaLPz/t95L8oCgl
         EnsCvSFgGIMkUFKIholHhb4fMyJohIBQR/moTzguivj62dWwhnsdd8xarxUnk1xtgiog
         yNga5gmnlbH0JYZMoQYR9Y4tC2h0LdM5A5P/O7h/yitwfVLBvQWz4IqQfDtrzTTwPVXZ
         HyvQ==
X-Forwarded-Encrypted: i=1; AHgh+RqqQ7VVev/7TMz0zGiHDWXrfXtBQfi3k2jYk7sWHro1GfVZmsBq5tPunJcxnLHo8Il5Ze3y0kZSNEES@vger.kernel.org
X-Gm-Message-State: AOJu0YyVX+kJPT0TQHQQQ5rd6M5/JtW+8MxwWRGDZBvoLlqzcMVp98k1
	YOUrDXqkx673276yFdBfYvfjwKelU/xCxLJY2dTCFbju2jywF7GSYL9HvenrAJCQIPGvHh9Wn2V
	gZybWgSMzziA1QZnS+xUAlqr0XI4u4b+eRRoLzFkgJCzOqynjxZ5ZOQ6x6ThgXiQqbdBjpFF9C6
	5nDv+w2Gs+7kH6Fj8hshi2I60WF80oGmR7NAGh891PrLa/P6GLXhrVCgySny1PJvom9WcNJupzB
	NkduWnEJ24=
X-Gm-Gg: AR+sD122l1fnrfHfVquOlPdfDGeDuYGgHXtR2AnxiQK1aaB//wRyYR8bNgVdRJmKjT/
	N/oupILDUsKvAqYx5Tr8WxQZwnCABDE8954RmApu9YRldrShSmwIZ4YHynNLI39mNF26f/bTK7/
	C6Zx0ZO1DXuk/SVgAVvk05NJOmBwEXhWMiJttJ45ttZ+/BavvJKVTe+BFFNor7B1gx8BjKO53rQ
	9eeeHG51wORT45FXOwSdl4NixwRBy0Cog1F0Tzh2Foxit78eT0cVifyaGLfF/JhZCh9Bnd3vAZO
	gNStr40tvf9iSD8cxfe52Z16MpoKAYGKCEaomqKTynUZgj/McwxkQxuTATOIdKHfZGi0lTwx8wO
	jm6kLCid4oqx37q5Xcv7InzzWPtQcz6AB9a0siD+UXx4ngBpjUbtXmvjLPnmE7w25MbkOTD59JK
	eHGmaF3oyiSvG4vrEHS9hrpL/w0rU=
X-Received: by 2002:a17:90a:dfd0:b0:38f:23d6:b4ad with SMTP id 98e67ed59e1d1-3933b792985mr7372133a91.8.1786719858045;
        Fri, 14 Aug 2026 08:04:18 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-395002f9d0csm15a91.2.2026.08.14.08.04.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Aug 2026 08:04:18 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66c70cfe719so1667209d50.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 08:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786719856; x=1787324656; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O0r3yG9cQJBWGdRbEaw1Tj5O1yEGEWz4BN84WHUlxEI=;
        b=bo94Tu7SvFj2XUt4TiLIIuRrnYjKqZTQ1dzmPO+ap2PMoMiCjdX38KDfbFTw8kWRCv
         o6+iim6tOOFfbrRiqUcOnSNxu6+EEHgoR7wL3eF2CLWvLQA2Wy4GFsb1TkxZY1ZAlBNk
         SLsIDdMDYYNVYttty4FQKkMpnnvLoHq0rxdWU=
X-Forwarded-Encrypted: i=1; AHgh+Rp7sUoQBH1IbH/aIhl/XtA/lADvX3jxL8IzUAS8PUvl9PxFMPBI3NWbGqqEIzKWBT+jZWuC1kH+zrI2@vger.kernel.org
X-Received: by 2002:a53:e84b:0:b0:66b:1841:adeb with SMTP id 956f58d0204a3-66c72b76c31mr1710936d50.12.1786719856493;
        Fri, 14 Aug 2026 08:04:16 -0700 (PDT)
X-Received: by 2002:a53:e84b:0:b0:66b:1841:adeb with SMTP id
 956f58d0204a3-66c72b76c31mr1710917d50.12.1786719855953; Fri, 14 Aug 2026
 08:04:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <an1trOAUeQmYEus_@stanley.mountain>
In-Reply-To: <an1trOAUeQmYEus_@stanley.mountain>
From: Paul Ely <paul.ely@broadcom.com>
Date: Fri, 14 Aug 2026 11:04:04 -0400
X-Gm-Features: AUfX_mzG6W16Muh9d5YCAekrtKwbf-q00QrsChAv00JnjRXpHLnT5C5h96vg92A
Message-ID: <CAEQnVQmH-5hKN-LduEFkPNz92cndybWj9CFM=fC0mOzwovpgsQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: remove unnnecessary NULL check
To: Dan Carpenter <error27@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	Nigel Kirkland <nigel.kirkland@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000006343370659032294"

--0000000000006343370659032294
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 3:09=E2=80=AFAM Dan Carpenter <error27@gmail.com> w=
rote:
>
> The "evt_dat" variale is non-NULL at this point so there is no need to
> check.  Delete the check and pull the code in a tab.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_bsg.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index c95165905483..7354ae9ba8e5 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -1329,10 +1329,8 @@ lpfc_bsg_hba_get_event(struct bsg_job *job)
>         else
>                 bsg_reply->reply_payload_rcv_len =3D 0;
>
> -       if (evt_dat) {
> -               kfree(evt_dat->data);
> -               kfree(evt_dat);
> -       }
> +       kfree(evt_dat->data);
> +       kfree(evt_dat);
>
>         spin_lock_irqsave(&phba->ct_ev_lock, flags);
>         lpfc_bsg_event_unref(evt);
> --
> 2.53.0
>

Yes, evt_data was already checked for NULL and the follow up check has no v=
alue.
Looks good.

Reviewed-by: Paul Ely <paul.ely@broadcom.com>

--0000000000006343370659032294
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
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIL+r28Pb9qa1M3angIF6SvMD9qlK
iBVlpRFH4lo2vmhXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MDgxNDE1MDQxNlowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAGnln064Nbsk8UmPbyql0e7/8T5tj/E2XAdTvHGkewXuZuk79Obiw7d86oOUeiDV
CmHnGr2OaQ+ncRniTaMafez4iuOnQrFu2tjxO+kZuh3WFfUdlfYCmPZo3WEXtPzv0f9MZGQo42Yr
mtEfu+dwxXq/4mDJN6XK2HSwvfhBUZ3dfpTMHHe4aZeRN2oqaA4GAfrnFPWRptNw5vQ7L3jERgja
x4DINLiyp4PE9KiR66wa75HUhG7+VAGwZVYcPLzsN8q+ALLDSUW/8qb8oASNisoxkPlHrM7ikSGE
Vzog+acr0fktPSZiojdFWCaoUJmMR6k6AvDJ+vGNOnaNG3mOkP4=
--0000000000006343370659032294--
