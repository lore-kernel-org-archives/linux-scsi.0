Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7025320ED
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 00:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728346654; cv=none; b=A+crLjGrO/9CKKum1kcGMwtHwJUdNL1ftT0yPyz0kX0cgi5v5ZTKbjBD31KGydaMyIF6b5rkY3MYbRxXAK3CyCkjuZZZn/L2akbiS2nOAMQlIT/AY+2Wb8NaI1hJgY9r947u5uUJ2/XPLT2n7/jwOne6f31kfSL4HVU7FPtbGIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728346654; c=relaxed/simple;
	bh=nkk6dxhoFGfnov0sv6S8hDu56tAClI8UierkVRAh62c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b6YKrXGbd4HaOssvrceQkpq4iOMWPt29g3XKDxiueTyAfA19gCcGWzlKLo71T+vcrwlCVkUtq/6fvTm5NkBdqeqcZfPRBfOrQdeD6R5nSS8LTrJNZWhpvJsz1PD7c0aHvH2yzC+m+KkP61hiwZ8OLWP90dmdQtzI5i/oDZswC2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=J9CZ36f+; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="J9CZ36f+"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2facf48166bso56977441fa.0
        for <linux-scsi@vger.kernel.org>; Mon, 07 Oct 2024 17:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1728346650; x=1728951450; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LA8KLVSSI7wRi/YH0koyUZvdJTpboHmd9zw9Dns7pvo=;
        b=J9CZ36f+88rvHV1SVGx1Ks3qIASm1cU2tvDLk8tHW6Q8TOW7bGrLqhLYPk0xdfLRUk
         YOK52d1SONkEMYQt3RtOevyqt22AzyQ+kO+ou1uRdMi7XTlf1VarozYKgs2m1caJDk8C
         0s0x7dGbHIKVJ5jC58ynAP+19GS+dpXC4XkS0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728346650; x=1728951450;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LA8KLVSSI7wRi/YH0koyUZvdJTpboHmd9zw9Dns7pvo=;
        b=SUVMSFfs2LI8fNJWjXb8Cvk8TYkg/xDkzTENOL17SE+3oVEvpHLG9w5vxzyDqdQ1wQ
         zljcPlBmuIUFKWfKIrcu/tYFjIzzHRkf7aOwgyzIC6KS8ySkc52D2ecKSBN8MY/RvbEI
         RjPWNA9GeiB2F38FZ/Q/X95HCEAVfHHjvFeRdXNI5SwvvqYsJGD4uIQdZ1xjORcNVh/t
         xIyNiaV3Cn3MPvfSoled1Q4C/IjMtIdnKqPSOU+E9wvzX7hJHWqDHOVW0UiP9PC9JQ+F
         N/G1hln92QkLl/TyIQdj2LBoKSI02Y3saMBCgLtqF8vDM7ZNBIOZ9qqZPg+cziMjUQP5
         dreQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVDi2S1S34oaYCGgbhq7e219Z/Nzyl+rDWotFvOCvotZ4pcbe3PBfKw6lrr3hH9rdCtkJ3fOT3PAtm@vger.kernel.org
X-Gm-Message-State: AOJu0YzQsX6gvBIjEbuEa1XdpejItUEL/HVqEdvwVW1v9hvBcwyy8PpP
	+XmECxpmnpQ6UmlNwc9uye4GX6S5+pKnOClbbsLGUrgESo2wAzsv42PEQp76afr7B+ZKtqooKGN
	AaZpIrr2Agj2LRyACVJUBw93fSLVlpHosSBs=
X-Google-Smtp-Source: AGHT+IHUDo7cIp2QRgh/EyUOWdgoaUomTWT5iv52trfvhUdQkiEnnDyqcjzSi08+HOz3BrarR4tlZT1gDL9jCev+RZI=
X-Received: by 2002:a2e:a543:0:b0:2fa:d67a:ada7 with SMTP id
 38308e7fff4ca-2faf3c4169emr69465781fa.23.1728346650490; Mon, 07 Oct 2024
 17:17:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240928-driver-fixes-for-mpi3mr_fw-v1-1-fc340a71e19a@gmail.com>
In-Reply-To: <20240928-driver-fixes-for-mpi3mr_fw-v1-1-fc340a71e19a@gmail.com>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Mon, 7 Oct 2024 18:17:12 -0600
Message-ID: <CAFdVvOwhPoyZ1+28utM62SKJHN6Q7Sryx_Sq_U45wM4FJKmu7g@mail.gmail.com>
Subject: Re: [PATCH next] scsi: mpi3mr: fix uninitialized variables in mpi3mr_bring_ioc_ready
To: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000002d9e0c0623ec1065"

--0000000000002d9e0c0623ec1065
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 28, 2024 at 3:17=E2=80=AFPM Abdulrasaq Lawani
<abdulrasaqolawani@gmail.com> wrote:
>
> Initialize the `start_time` & `elapsed_time_sec` variable
> to prevent errors when calculating elapsed_time_sec.
>
> Signed-off-by: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index f1ab76351bd8..f93968b76883 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1363,7 +1363,8 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc=
 *mrioc)
>         enum mpi3mr_iocstate ioc_state;
>         u64 base_info;
>         u8 retry =3D 0;
> -       u64 start_time, elapsed_time_sec;
> +       u64 start_time =3D 0;
> +       u64 elapsed_time_sec =3D 0;
>>Thanks for identifying this issue, however, we need to do some additional=
 changes on top of this, Broadcom engineers will submit a better patch soon=
.
>
>  retry_bring_ioc_ready:
>
>
> ---
> base-commit: 40e0c9d414f57d450e3ad03c12765e797fc3fede
> change-id: 20240928-driver-fixes-for-mpi3mr_fw-2fac1a9bda03
>
> Best regards,
> --
> Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
>

--0000000000002d9e0c0623ec1065
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
v82E+npLwqC8bSHh1m6BJewfpawx72uKM9aFs6SVpLPtN6a5369OCwVeEwkk2FeFU9tZXWBnI4Wu
d1Q4a3vhOColD6PdTWv74Ez2I3ahCkmpeEQ1YMt61TUH3W8NUJJeYN2xkR6OGsA1AgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
VyBc/F5XGkYNCP9Rb96mru8lU4AwDQYJKoZIhvcNAQELBQADggEBACiysbqj0ggjcc9uzOpBkt1Q
nGtvHhd9pbNmshJRUoNL11pQEzupSsUkDoAa6hPrOaJVobIO+yC84D4GXQc13Jk0QZQhRJJRYLwk
vdq704JPh4ULIwofTWqwsiZ1OvINzX9h9KEw/+h+Mc3YUCO7tvKBGLJTUaUhrjxyjLQdEK1Xp/8B
kYd5quZssxYPJ3nl37Moy/U9ZM2F0Ivv4U3wyP5y5cdmBUBAGOd94rH60fVDVogEo5F9gXrZhT/4
jKzCG3LclOOzLinCkK2J5GYngIUHSmnqk909QPG6jkx5RJWwkpTzm+AAVbJ9a+1F/8iR3FiDddEK
8wQJuWG84jqd/9wxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAFN6p96
yj6ClrBicb1kKiQXwSGTUahmEjiD4bNptNGCMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI0MTAwODAwMTczMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAE5l3ofSuvNFlOns4U6/C3LXi4
LcTfRsUZNBWzcmH50mfmD77G/GIwT0gU9Hl50PC7w7cXwp+W9mAG0Yrx/KzHO2F7Pbyyasz5dAPX
fGQoDgbnz/kKv9fn2wOFOP/s0rC69DwuM7kyOzkdR++HhosMVd6RhKEG0UELolLL7vX2ypI0NjfG
Ce1Ru0oftNmFu7Smj+s1B9Kpyj5ajtAJcJDWj9TvBNRYIkXjxfUgV3P0yDnFkBM5D8oM1SZa+3FG
umiy9sKHCK2X/R++F7yJ3ixv5UT0LHVMEY542XGG628eoH9ElzymOk1KM9/nbxcUhtvMxNVNt/8r
HFH964LZ4F/6
--0000000000002d9e0c0623ec1065--
