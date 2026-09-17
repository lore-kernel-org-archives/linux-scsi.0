Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93C24F68C9
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667629; cv=none; b=sfTb7Ifm9zM960sW6874+VOuwdycRpikVy2gwktBF0IRiamzxHXiywdy7HH0sap11/GwBiBcSQEEZLnA8MoS3K2yUcWKNlM7Zu2mSxNSklwbKxaKY+rU7EFWMZLrrszzgcJ2ksiwC2yyQb/yaIThPqXyWYhKL8mbdB7dpAUXtbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667629; c=relaxed/simple;
	bh=5hmd10FwXB8zE3aN1tY3REf5RmKqUGyqWJpWFttEG0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bDzTHCTxa/K4XilYXV2KPcFwkwdrs3ZQJx65ItqAAylAZWRd8p7j1qoKRUl5ap/rs5NlJJEkZ/RaMr/1961sl4aGxmn7KXm3j3fEpIWdQHzeS0h3NxfXGsb74ut3OQgZn0LaoXwq92ATJ7rJvP3PR49Ar3BN2THNePwUttF+xQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=E4zKgOsa; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="E4zKgOsa"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2dd665f341aso3992655ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 10:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789667627; x=1790272427;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v5FYjX5MS5+2bXfhcJe4JwiDOrRRG7zEtMiMz6iO0F0=;
        b=UhViUp6mg8adNPZU0JIfzh8CB4dshutZ7MpMVQjXtp+1rUXucwCNk3XXlP49itRoOk
         NxgAeQUsJ71K1aQouAtaZmfaRrEuJ2IErox1og3buRbfvGfgnPirFJ5RxJN8dyP4vYDn
         FL/fuWw41ATMD0QJeBQEng18bIPoxzLVD91mvPA00Vr/ZQT34ZVxZTiEDG/dKG7cXHlS
         Z0PReL/M7Kw6ifl4A30ijsygS3PopFIhCYJX8we6jEkbn25xFenSKR9RB7JkK4PFrYdX
         COTiPh+wVSvKYbKs2cj5bmfwbadl+YDmYCd2YH5VVxQ+RLa6CIH+OtjMfGyZn+484vcc
         GSvw==
X-Forwarded-Encrypted: i=1; AKwUvBxEgDgaWGAJUntyHJaT1RekMOp6KUsPHgnuAtY5Fx7YkZj6bCS/4L8A9+FxV1hcXKYk7svqYOg7Muet@vger.kernel.org
X-Gm-Message-State: AFuF++kopaiJyR/NcTOZKXzNcCc1ClKbfEN+GEBSRDkxQNmML7E6g3yM
	RKcQKthmRJiKpR0VueEssf8eAT1Z2Hc6xlOYNyvezExIqteoGp+kLYzb2yU5mXA/KeCZbpfht/1
	3xEZ9+RS7R744/8omNXbjhk3KpU+odKcpbd0YvMgBljibEu7kdMoY8C1h0LEBI7JhpRmzZ2QLh8
	g55hQ8fYnBqmu/x48SLvSJ7PR+8AQwu/0Goy3RLtY7J5cCE7Zd6KqNtcrP6xOI26stNaklC7Fpq
	J1ZnOy9xGs=
X-Gm-Gg: AYBFou2YsqdVuFShxGWRkG8XHgfsMQInqbek9Myp310/fEgdt1QniiOIekTJahNlN5I
	RDveJiWM3UjMXEtq6B4Q0hWNBtkVMH3Qk/+i+7LT0hfVn+WRQp588QbGIvl0zUZt0nHW6QBWtHB
	BPjfqjrOjXOPFG+85Olll2Ovp1723JAHw+5UKl/o6DWyH3MvaeedWBH+FYcoRYWfCLYMU2dMrUd
	dTOV2qrAG6qi7i/Ppx8e5IzMFjxgN5dj4PW6afHm9mznMUzd/mD8JqCrGCX1LSPH3hHo1fPHGR+
	u0Y4x1JxfNqfnfK4Q/fYWKXm+f70IWuAxnd/1Ysy3zL6gsXTpZ9TbVVv1xNpzP6cY/4km0TbGGu
	1fJrCtyh57+8f+tRCBxPmghGsblJFSbrUKFZEZRgKbjZBFw3ObJn2rMuf8i8LvEtu8lRXmuKHX9
	PJoIMVtOe1em/NOkS4oVIKaipWiabebg==
X-Received: by 2002:a17:90b:5105:b0:39d:eca3:e296 with SMTP id 98e67ed59e1d1-39e1e49a1e1mr16404551a91.17.1789667626683;
        Thu, 17 Sep 2026 10:53:46 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39e35d7c196sm1924963a91.2.2026.09.17.10.53.46
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 10:53:46 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-66ce3040ea9so1081474d50.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 10:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789667625; x=1790272425; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v5FYjX5MS5+2bXfhcJe4JwiDOrRRG7zEtMiMz6iO0F0=;
        b=E4zKgOsanUt3AvV1xRUjdekxa9j7pfErCcHliCiTD9j4hYflPuhK7orcLqV1chLYr6
         ZmHpZQMd1bivNFUqlvxwemZHAAUIRnif/zFY/QklphbaOJpicbdjDm9iBozNZCTtgTZ9
         aqZZOnzSg7f1NiiLhc6vsQ3BPV2VGez6aulSQ=
X-Forwarded-Encrypted: i=1; AKwUvByPwwcTYaWLLgNaGgyPelK76BG/Z9HupxqQFhkrrUKnOZ07obJFI4Uexjx1nM1uKDFI3yMyXTNo/RSf@vger.kernel.org
X-Received: by 2002:a05:690e:11c9:b0:671:2eed:f6e2 with SMTP id 956f58d0204a3-6716e67b2e2mr1641442d50.89.1789667625300;
        Thu, 17 Sep 2026 10:53:45 -0700 (PDT)
X-Received: by 2002:a05:690e:11c9:b0:671:2eed:f6e2 with SMTP id
 956f58d0204a3-6716e67b2e2mr1641424d50.89.1789667624859; Thu, 17 Sep 2026
 10:53:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917144144.2157444-1-vulab@iscas.ac.cn>
In-Reply-To: <20260917144144.2157444-1-vulab@iscas.ac.cn>
From: Paul Ely <paul.ely@broadcom.com>
Date: Thu, 17 Sep 2026 13:53:33 -0400
X-Gm-Features: AcwNN1XhR9hLdZum0kChzoBiVLekPzh5f-zyg-qvxD07X9ScTna8L9o5vqVJVrg
Message-ID: <CAEQnVQnqdFCLqdA+zPOrcLhG+AWb-Tuqj3OKD3X4141FidQ1bw@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix ndlp reference leak in lpfc_issue_ct_rsp()
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: James.Bottomley@hansenpartnership.com, james.smart@broadcom.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, stable@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000182946065bb17782"

--000000000000182946065bb17782
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Wentao,

Broadcom has already fixed this issue via an AI security scan.  We
plan to release the patchset very soon.

Thanks for finding it.

Paul


On Thu, Sep 17, 2026 at 10:42=E2=80=AFAM Wentao Liang <vulab@iscas.ac.cn> w=
rote:
>
> lpfc_issue_ct_rsp() stores the reference returned by lpfc_nlp_get() in
> dd_data so that the completion handler can drop it, but when lpfc_readl()
> fails the function bails out to issue_ct_rsp_exit and frees dd_data
> without dropping that reference, leaking the node.
>
> Release the node on that error path too.
>
> Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taki=
ng")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/scsi/lpfc/lpfc_bsg.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index 7406dfa60016..f9e9896c348b 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -1545,6 +1545,7 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg=
_job *job, uint32_t tag,
>         if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
>                 if (lpfc_readl(phba->HCregaddr, &creg_val)) {
>                         rc =3D -IOCB_ERROR;
> +                       lpfc_nlp_put(dd_data->context_un.iocb.ndlp);
>                         goto issue_ct_rsp_exit;
>                 }
>                 creg_val |=3D (HC_R0INT_ENA << LPFC_FCP_RING);
> --
> 2.34.1
>

--000000000000182946065bb17782
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
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIIhjctkzj2CkZGJJf7f6RRc9btwZ
0Y7XtKACKqJoTNWwMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MDkxNzE3NTM0NVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBACNt+Bfa46ustc7u+XQJJcXhMmcIMneyaQyOGGkrIBGP0ks99JUOFl7hPUKcnq3C
S2M0XAcEihdleJObixB32Hp11neOOjFzz5UHDetUFBH1FYYYIXJfKR+vKx4FTRgJLChjA+yjyPwL
rOIsf805D5z5VgAZj6mIyjrAlrE01nFWgtFbRzY48QvkHa79AAq+gC99IVT+KZi8gDCDDrTMcsUF
A7mZz08GQhgqC+wpyd6XHjxYi0dj+G7a1hu7ne7Nhk1gD5UoBvFfmPJ30MRGy4nJZqhCIWoPFHIv
jruj3eEJJF2jjIs3uG2wVpUB+yFG1O1XH1i7y4vuOGNU3M0RfPM=
--000000000000182946065bb17782--
