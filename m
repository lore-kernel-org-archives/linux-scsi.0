Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFD63B1ED1
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669475; cv=none; b=u68pYDBoqh8EOlnqdqvh1OsNAA/jewlQ6k3Z+cgfNZfXSfdApQQIF6PgbwZ9SJEVOw5pFF8/t6NF7enRp3+uacEdvlVeDRRu/yo+T9l79fc78KobEZ5f1gI6oZmNH6QisaBMgTFuL79e5vxIlZNClspuQL316wR5wwoyyhxsvEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669475; c=relaxed/simple;
	bh=/XqbITDW3HCOIs2R9Zo+ahjWzKUCgs0TtJRa8Eu6Y/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ekh3CqcmjfagLVdtITHQV6MVDpue1HMhUXkZbxc6TIQ008J+waBc6MQYpet6XPO9sA+t/d5JyNaSGQIEZqRACAxMcUV71dnB1y9EbM1mFrMGhrG2QLdX1k+kAGizJkB4EYj9Phn5wImDTMmoXjAKtd49CgL0XHocv28d9bVrrck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SDO01+wA; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SDO01+wA"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-7f84a55cc06so247002a34.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 11:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789669472; x=1790274272;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vISMg5YITWHhV5lEgM91t36EAMMobqPmVCv67mUkzFE=;
        b=erz3ZNfJnTy/IIH7YUHlMmSsZYLBt287ej/QQl9rbRzl6whF85sLhBTzKWWHz35ABt
         gLiLPVLDJc1/3vDoUVyG4UYbtfxeIctDCNFazwpXcJ1Ixkh9TB4Z9JSHl1BASCrwWV5L
         JU+TQCV6GpWie1FW0PVDLLRdsxWuvzgtbHlQaBx5QNAqXC9qzQgYHiCq30YeWYNQCFTS
         lyr+FzMYBkgQwWqa6hNatcepTXFdSxLOZSUDCnLNPuzuTNChGdlMIXYCzI5INidAIlQT
         y5xE/osG5NCnXwNdcdf+X2P1c7bVOYmm0pmFhtW9FgfoEnvbWeb89jh+Ci14gg6IKQRi
         M9Zg==
X-Forwarded-Encrypted: i=1; AKwUvBzY9ygBTqyzhodixioyOo6KJJo4v/shrVsaA6gi1Ts8SxSL/Wuv2eCGuMk0CvS0OmCnLVeWzsfqijeP@vger.kernel.org
X-Gm-Message-State: AFuF++lz9pUES7IByKcDnuM0FFYBTihwL9u1PnOyp4ybSScp4XNtnpOO
	PYZ63x+tiylIEhg7q9GBHEdYs27OusVfag6kRLpSrQPPdLrMdFCAVeyH997I0uSXnugUAdjs85a
	BryLPIkYQL8hmhmN8+pefe9YZyUHLkkHpX5PcC63DUKBkwXXBTfwKNBEaESAEM51YWvvBRPlgRi
	LWIeOOGd6DS9IXVm5av9BfwIlyiYR1AMQHEGS6xt793kVYxQ9R0egrl/dh99mKlYsHo2vGcKp0K
	qCIjapaKOc=
X-Gm-Gg: AYBFou1tNXhisnV0GMrrunDUCJ53jBFSlEAJ+M+1xzFT4eOkJhjiv3wyXsjZjC7Gmqz
	nbYH1t+XRyeL245aouYs3dmBQ/vS2NNW4M0l61iWSEM3GcZgqq1Un5AmW7Kgg7PZYAJRM/LR5c+
	ie1yv+/+aCshfhmzcJo6clNBdGvy3cvBfDdIjXDCvx1F7CsSn816VcH09czkg/lRgknWE5YaE45
	w4W4mYOFPnGQLtnIV7oQEsHVM2QVfb6pkmpDUGH72/RjGQLTkUsFn2Ooq9SOylVZ4lLiXB2eh2G
	tMO99q8dTIiG+BENxHD3CjmqxAt8sJqFiNhC/2AxmdLcqUlQKO1gQkAlYXmw8FhEYPbPJSCD+Uz
	VrLbGFQdhNuYhJ1LG/O7FUFeN25UmOVUZTXvBOjWX8z8rsR5OI6udD/hsZgcMh85W1j5A4GvrzR
	5sF6eoQasi/BfblqcloQDbgLZo3EB+HAxf
X-Received: by 2002:a05:6830:4708:b0:7f4:edd8:b7eb with SMTP id 46e09a7af769-80b2c181868mr8489251a34.6.1789669471825;
        Thu, 17 Sep 2026 11:24:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-80c46fb719asm1858150a34.7.2026.09.17.11.24.31
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 11:24:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6711a336db0so1369118d50.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 11:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789669471; x=1790274271; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vISMg5YITWHhV5lEgM91t36EAMMobqPmVCv67mUkzFE=;
        b=SDO01+wApLoNcquM4MXzU/eAnD/4g0WbMZYlm+CKy+BnJI9m0B1WEJszO1dYuy7BwQ
         ZUG3cW+9Qk9bxPnBcTKS112OJ/dLPq/VWr8d2omxMbS1H1IEPx1vgNM7gYLgCI8liIKA
         INrdma9MxT6ioqtZO411QcOSZYWCZgORBgL/k=
X-Forwarded-Encrypted: i=1; AKwUvByFcw4RGNOzA9U/7BUybqChbyAFy1TC95giWdjvejbpb8PiTV2H2vrdDyp4rYDHjArAbNG49zuexQL1@vger.kernel.org
X-Received: by 2002:a05:690e:4006:b0:671:1fe8:857 with SMTP id 956f58d0204a3-67163200c49mr2419151d50.28.1789669470823;
        Thu, 17 Sep 2026 11:24:30 -0700 (PDT)
X-Received: by 2002:a05:690e:4006:b0:671:1fe8:857 with SMTP id
 956f58d0204a3-67163200c49mr2419135d50.28.1789669470409; Thu, 17 Sep 2026
 11:24:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917144543.2157614-1-vulab@iscas.ac.cn>
In-Reply-To: <20260917144543.2157614-1-vulab@iscas.ac.cn>
From: Paul Ely <paul.ely@broadcom.com>
Date: Thu, 17 Sep 2026 14:24:18 -0400
X-Gm-Features: AcwNN1VMhDZ1_EmxVgkc7yX7JJxmLKdMeZXKRCKFJwbgA26mdzPFZ77RhjFQqCw
Message-ID: <CAEQnVQnhp4HR862=-CdB9P9aAor=i2ATaNyKF71q6MiiVRi_7g@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix ndlp reference leak in lpfc_nlp_reg_node()
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: James.Bottomley@hansenpartnership.com, jsmart2021@gmail.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, stable@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000019e95d065bb1e5a1"

--00000000000019e95d065bb1e5a1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Wentao,

Broadcom has already fixed this issue via an AI security scan.  We
will be pushing the patch very soon.

BTW:  using NVME_XPT_REGD is wrong for lpfc when in NVMET mode.  As
you correctly noted, When in NVMET mode, lpfc does not register NVME
rports with the nvme transport.  That flag is reserved for initiator
mode that does register nvme rports with the nvme_fc transport.

Thanks

On Thu, Sep 17, 2026 at 10:46=E2=80=AFAM Wentao Liang <vulab@iscas.ac.cn> w=
rote:
>
> In the NVMET case the driver takes a node reference in
> lpfc_nlp_reg_node() because the target does not register rports, but
> lpfc_nlp_unreg_node() only releases that reference when the
> NVME_XPT_REGD flag is set, and the NVMET path never sets it, so the
> reference is leaked until the node is torn down.
>
> Set NVME_XPT_REGD when the reference is taken so the existing put in
> lpfc_nlp_unreg_node() balances it.
>
> Fixes: 0614568361b0 ("scsi: lpfc: Delay unregistering from transport unti=
l GIDFT or ADISC completes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/scsi/lpfc/lpfc_hbadisc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> index f3a85f6c796e..9e920eaff9ef 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4664,9 +4664,15 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct=
 lpfc_nodelist *ndlp)
>                         }
>                 } else {
>                         /* Just take an NDLP ref count since the
> -                        * target does not register rports.
> +                        * target does not register rports. Mark it as
> +                        * an NVME transport ref so that
> +                        * lpfc_nlp_unreg_node() releases it.
>                          */
>                         lpfc_nlp_get(ndlp);
> +
> +                       spin_lock_irqsave(&ndlp->lock, iflags);
> +                       ndlp->fc4_xpt_flags |=3D NVME_XPT_REGD;
> +                       spin_unlock_irqrestore(&ndlp->lock, iflags);
>                 }
>         }
>  }
> --
> 2.34.1
>

--00000000000019e95d065bb1e5a1
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
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEII+hlAZ6QR6yxeELhsuwkdsz+K8E
4uRxdr/JOy0aZTa8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MDkxNzE4MjQzMVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAHQYHaKpe0Z+PZB3vOdabzz9Nrb+YjQRRx6EXw64L3e9TyFQSzFUmf1oZRf7p3Q0
2JhXDT/6L+80YkBNpcz1VCNHIp8uu3h6mK6rfGlgiEip3T2SI5rUDMAQ95sC+wYp9Rksh9zvuP0l
zjWFKGwbhvPo7QmnI6jXzoAP7Cg0ZRRpLs2cwp5O1v1PSX7wRnBjE/oHpzEw5m8WrGo0ijhQYqXj
Mi8neGCdFz2a+nJ/9zquFeTsqgkJW4dvZCxz+MUvJEpFOC2Q3h4ZMoCK3iVErHTwOHUy/hoFaVFL
aTcbnKHD5l+fQyrPzJ0dkfJi6ivWKLIAgnQkIPIBHhET4ncGPZc=
--00000000000019e95d065bb1e5a1--
