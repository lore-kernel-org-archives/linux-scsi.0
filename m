Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658D720127D
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 17:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750440561; cv=none; b=XKVauNWh/XHpHgA5HatZXZK0qm74sQ3/5IRmXyNyNrVS9Te9OTW/F9AtfbsvFalVz5FpwpVJ0xWBfxbJ3Jia2eeykwwgFOZaQwbN6qEDXxsyesNHr4DJZWuEeKnVJmTRi0ivSy8QfFmIr/u0T3CZhCjVYqbxX50FdKG+tVZsvtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750440561; c=relaxed/simple;
	bh=irAvOdz5zq+YRKPH4KdTIlAlfRkDGKHECtJ4HEcaY3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ldrhXe7F+U4qSNw/V4tOxZI4Ypwy6yZP+RGLaSXALWvSPmFaRxmy4yP4DTJlZr0NKXYgF8qqfsLEAUoAXWZPqIF9Soi6VkKcT3NYMXsb1cuNFQ4GNOwla4dcVIj1y9SSGbQ8Se0RVKn5Oi9f70YsU/CeJajLZU4e/varKi92dLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=eNTx6fIa; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eNTx6fIa"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-32b910593edso14347251fa.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 10:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1750440555; x=1751045355; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=irAvOdz5zq+YRKPH4KdTIlAlfRkDGKHECtJ4HEcaY3w=;
        b=eNTx6fIaT251/VWW6ASDKio4uzD3OpicrJuopl02qDINqfj+ooHd1RzRzApC4mBlJ6
         UbhLIWwlBoA0QvG5STQTJZvR43Cae2Uf4LPqbWfb4wwzag+ksfuyzX/sWbZOSJ40xrN/
         q+UDDUFWtu0BcqWWtzp5ufTl28ePJdodz4bBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750440555; x=1751045355;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=irAvOdz5zq+YRKPH4KdTIlAlfRkDGKHECtJ4HEcaY3w=;
        b=gtipdmEWpXJhhhcALRjTHyHQNgEu3wUWtTjelGGf706LVCOQL+zfrhRUhqCC4dMHFr
         g6IIJ+KwSz1KXVj+gzEbhc5VnCj6kbRS6qvrTMTBQdjQ7QKrhxprlOx7SSnrmntXc/ay
         9IFBr9gK6obEkGvLI03D0dkgWH005GlQlaLrwkRFXN0DGMClOL4XVZ6Qtip/eco3wS/F
         aM5hpKduYgscrCjAf9UCQ8Sycnu1XKnctGlqTq9YFT46zR3wJ+FKOxrN4iDr40uC5rmo
         weLxZg3LxdOMcCYcdxu7SfVDvYcffJGzwrlfcG1NpoYwxcpt6UCicsHCI8vvaeslLspn
         4leA==
X-Forwarded-Encrypted: i=1; AJvYcCW/BoS1bbUopRqrQtMBlCZUpMJc9Hhb8QB385w2jXm8SYtgAEcRPk588D/EP1MaNBYLaKovM27db5lF@vger.kernel.org
X-Gm-Message-State: AOJu0YxSIOBmnsyZnxDmkUHlO+NlL/fzAF4aV3w+KJ7lngA0DYTRNJ6n
	6UjpQoOlPw7iEykdj1gpPYZ3ruEybtWarFJ1bU1vJB0Hx5SkBFKOeO/nUWwLKJS7V47XxYzSkic
	fovu4AdgP2Fb4cL8+A8zz5B9d4qOrnH4YlFpikyQ=
X-Gm-Gg: ASbGnct0epnG7NkZHBjsbJIBYXHqfOaixchGBpoHwfEg9hLoJtae3tbigEX2JTP5x3v
	R2LpmElUfA7z/5Jr62Fp7o/5I2JRtnP2g/8D/m4c4sScG911CmfnAqCzjTTTi5NZNIac+qhQ/Ia
	r1tXvsM103Vie5Bw9FoQFqEBuInLfA4lPrY9M3iDEBn88=
X-Google-Smtp-Source: AGHT+IHB1zN65Agueoyy5vE7UDJnMr0ShkOP5ChcI1pjHjp6Rem2kzAV5lfFJccyVgWY3+VuLOkavo6Zl4BeZ0KWRk8=
X-Received: by 2002:a05:651c:41cf:b0:32a:83b4:c146 with SMTP id
 38308e7fff4ca-32b9901b97bmr11430401fa.23.1750440555496; Fri, 20 Jun 2025
 10:29:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606052747.742998-1-dlemoal@kernel.org> <yq1cyazt8w7.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1cyazt8w7.fsf@ca-mkp.ca.oracle.com>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Fri, 20 Jun 2025 11:28:55 -0600
X-Gm-Features: AX0GCFtS17wb8iDgjS3ZCkzQ8Ax9G7chuej1hzeiUPm73nMOj7D7ruFxkcHTeTM
Message-ID: <CAFdVvOx-yD7qjs0HfpdxxmPH2ZEW-jAHnHTV_TmOZJwum-kynA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000088c6370638043368"

--00000000000088c6370638043368
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Martin,


On Thu, Jun 19, 2025 at 9:00=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Damien,
>
> > Two similar patches for the mpt3sas and mpi3mr drivers to improve the
> > handling of NCQ command terminated due to an NCQ command failure.
> > These so-called collateral aborts must be retried immediately but that
> > must be done without incrementing the command retry counter.
> > Otherwise, these collateral abort commands may endup being failed due
> > to other NCQ command errors.
>
> Applied to 6.17/scsi-staging, thanks!
>
Thanks for taking this patch. We are working with our internal
firmware team on the specifics, if there is any additional change
required, we will push a new set of patches.
> --
> Martin K. Petersen

--00000000000088c6370638043368
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
8wQJuWG84jqd/9wxggJgMIICXAIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIG70PEZe
tPYvo5IemZ9AuTzXB42PxyyPXSzX+lPsTSifMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI1MDYyMDE3MjkxNVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKxtUUnOlMcJFYFt2+rj1nmAl/L1bnV8eSs2yiO5r5Jb
psEgQuQVrCK4LTgRd/xjU70RuE3awK0s0kZep968HUwTxDRQDbN8341ewLRBvFjzm+w9Cv16bseY
ka1joIDy9bc4f/L6Z07xYOdrpgPLpaN5Wm5w978HyxSTO+/NzvLCHBgDXAjem9kAqCiHSBW4KpCO
UPYsLFIgAv9hciSETQ7ER64XpgQeew6jMMILlK4J1BlDga4tL9ILdJZ2jOr1/A0fAUqnbpWEOTkE
pZGTFt3XrHyqzK2vrtVg0z1O6l8lDHUpNcMnxTLlCYEqjU8mSVrVW/3/MxPSWyW5MFCQLeM=
--00000000000088c6370638043368--
