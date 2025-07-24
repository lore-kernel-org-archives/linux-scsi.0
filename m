Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033C5482FF
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 04:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753330196; cv=none; b=mW/0ztdP4zm5kRtjkh/fSq4FGaELGuqiTJB+UtA7VMuY5mobUQfvkfWM3VWFIPW8V0MlEwKVDZcE600RnodKJ5ij3pS3N6InyQaokjuF4vTyOf0N17NTGT62AzFOYRU80pbZ+PcPHXTO7eSSISXteFgBa5aRFVhyJ1cV2pZZM24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753330196; c=relaxed/simple;
	bh=4knXdHgbO1eYLgj0fAggltR+2diNhG5qD4yRs9uCKHI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H9JCfQch7giyy+mZvSA3eM0NrNi2nsRsv2T+0yaB1nSk9hbHkNrD9oW5xl/irwavyqgg6/USmHOcXrvdO63UONkvcUDqcHG7bMc71Ys9wyTq/tr/tjZPlFqOArwveqv2wW31+mVD+/bsR4H4vdCenDvVFiToA4ZFljIQPopr/7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Coum5b6c; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Coum5b6c"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-32f2947ab0cso4340221fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 21:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1753330193; x=1753934993; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cmhtz6JiG3dqFybzAslliRpp6H9FnjVxvgtFlv+e8hQ=;
        b=Coum5b6c3Qs76gCdyZBJeRgHF6tBy4Uct3iZ6kEw4l3gK+Yr94dtuGgtXEH8EHQcE6
         mcKYtmff7VAbEpe5rWZxi4K1h7IhYT5D1d8xnEKsaOHHl0di1ph4GGbF0NiMIiGsaXgr
         035jPsTHO6GHNHzuSklwb5jjtTyOhBp7sDFww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753330193; x=1753934993;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cmhtz6JiG3dqFybzAslliRpp6H9FnjVxvgtFlv+e8hQ=;
        b=rCEZYOO4Khe5gbKzGwLV4anJHrRaWAuRvrzitGyGgNTpNWYdFiAAKbPW8Vgca9qlGT
         qhi/9Z5nCfyNKTHX4UnhaNS3td9uC/eSvnNi1Ne4CSPFadnnKsFvgctP1KOo8pD14ClG
         IkDSYCbzC1g1VRdYl8R09nmbavnm2d7wHRziPGkxnZ+egs8QVik7B7ReWDvDRgDbgeHM
         f3p0+7jk+2hlTCEArtZ8z2XDFhK1BSCcv6G7TGQkYAey1tsYRaZFbIuHKbbSDpiIgfL+
         lWbtkiyidan9Yo/XSP/r2E3bz6o4lTWJ/8XWg3mwkRe1QAUtIb4wfbc30qfKoDgTF94F
         DVTQ==
X-Gm-Message-State: AOJu0YzYeUM3EmPX7mU1UPqcKqFdldKw1AmQo6cIkUm7Z3TuVkfu2U/i
	W8inmIwMhea3pm83mr3YmUrEN1piUZs0qErMECqT5UboklS1Ihoc8zFXFhh3/k9TsqTpmNUonNj
	FkXJ9ANjtFJDNrxXJkElV6sKkeyt7KngB7dzVV2c=
X-Gm-Gg: ASbGncuQd25ArTzrRNQr0rUemGUvs5U33ztMduyWFpbUepIlhAqIt8JBPdISAU0Nrva
	aveplEGI+qy8SaXS4ZvT/COtmtRdhQ3JKKfuBnIQYss7SSnTs+z5hlAQ5zXfZu8o+pp2/ohhqon
	+cfEBluSKQeKbMqipKbw0naKoldp3xjVbgfIGZ+UKmmgNU8d+z6+zJLgk77zy4J293zTLoTAai0
	36Y
X-Google-Smtp-Source: AGHT+IGO7UxTzh4q589cBeNDKAh97T0sB692VaIPsmI4vjW0lFgBxyH7T9XOliBXWMqW9H+B3pw8NeYWx+BX1FsT+/Y=
X-Received: by 2002:a05:651c:b0c:b0:32a:885b:d0f with SMTP id
 38308e7fff4ca-330dfcfe48fmr16853641fa.24.1753330192979; Wed, 23 Jul 2025
 21:09:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250723153018.50518-1-thenzl@redhat.com>
In-Reply-To: <20250723153018.50518-1-thenzl@redhat.com>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Wed, 23 Jul 2025 22:09:35 -0600
X-Gm-Features: Ac12FXwk-SDqBhRcvCja9bh1y2dwuJYzBemlGhKmknGtTCWu49Va-y-BjshjcvE
Message-ID: <CAFdVvOxk_Q91rs16+NcWhUfqrv4YNSe7mioU2Za4bKDMV41TMg@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: Fix a fw_event memory leak
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, ranjan.kumar@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000005b2066063aa4ff14"

--0000000000005b2066063aa4ff14
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2025 at 9:30=E2=80=AFAM Tomas Henzl <thenzl@redhat.com> wro=
te:
>
> In _mpt3sas_fw_work the fw_event reference is removed, it should
> be also freed in all cases.
>
> Fixes: 4318c7347847 ("scsi: mpt3sas: Handle NVMe PCIe device related even=
ts generated from firmware.")
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>

>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 508861e88d9f..0f900ddb3047 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -10790,8 +10790,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, str=
uct fw_event_work *fw_event)
>                 break;
>         case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
>                 _scsih_pcie_topology_change_event(ioc, fw_event);
> -               ioc->current_event =3D NULL;
> -               return;
> +               break;
>         }
>  out:
>         fw_event_work_put(fw_event);
> --
> 2.49.0
>

--0000000000005b2066063aa4ff14
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
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIAxVml1C
eseJ+Saa4kCG3ORWUr0fUtvc0VLbgudmDffVMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI1MDcyNDA0MDk1M1owXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFrNN1phl+Z5EbRhmFBL7isB1SAkowbotjQVMssWFST1
FNbsUuYY0GcPnLZH9iGYbhewIoOYb7jjefV3OzA/cRurWmsyRViP04vHfY+4UkoWeTBxKGCWgeYx
NjolyKuGpsh1nAsc7P9o/3YogGYoljQBEGPiUcKarg7lJJh2Y7MM4e91aWzgthZl8Ei2MRwlGW6v
toMi8WlMkt7GaOoGZYrQMsZUdAX3oQWXFdBoMJYVuY73/OezN03QAE6eAi6vydpjPnQ6iWNp8zJT
p2+pMfbz/uWd2rIQHSfZSNp4i1+QrStG7StBE5CsTgDNHs7dw88Wf0JTzxhDl8THD5HXL94=
--0000000000005b2066063aa4ff14--
