Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FA4152DF5
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 14:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715093345; cv=none; b=r3f5THHVIuHljSTUms9vDo/7o8yAXFnifXvIsU6X/RZRg4yihbJfWQRsw7+8M2f/VGSWHi2xmqJHvN7T5f4GVOy8dEWkTIcBai9q9c/bpIcg0PdJztx66jNRN6uxyK3a/oldPMxu6EfTvC57LeG9r9Doy0xbynnczZaVHzO63kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715093345; c=relaxed/simple;
	bh=iYe8munOBQc0xnks2RPXHFDtygTg9eqAD9N+NUUGXwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QRL5hBIR2hdqN87DIASaWDTZkxd65eUKIJtjk7SqCB9GvxBV0tVcae2OWRWcS2EAnFLRPEb5YAVXh2dw3HOrGdf5cKqcXbGXCiz3NNx3OJhG5IsZQLZNU10HY2mldxIkz20UqzchAhkXw9nqOC3ZGt01HCgtPhEru07BQUqnM4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JKTebI7u; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JKTebI7u"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2db17e8767cso40766741fa.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 May 2024 07:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1715093342; x=1715698142; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5CguZQ3BYOiJL5kgFENEXSFuOlL41CogLa/xdPoGdDA=;
        b=JKTebI7ulXFik5Fu0QI5jbK5z78uiD3DENlATjEUYOPWP2lMjN89P23mNnE4E8qVvw
         +6c+rsJDL//YDYRwMimaMaJ0b1NSsTkTdbffQY33TJoV2eHazcyP9a5fiNPbCi+ap0oF
         mUTuSu6Gd58jNh34sTCztHBlCs2Xh8uLJM/Yg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715093342; x=1715698142;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5CguZQ3BYOiJL5kgFENEXSFuOlL41CogLa/xdPoGdDA=;
        b=NCrlHhSkDZhsWVjwry7udOe88yMXN5VHaXXq56ikAk9IpBkBU/01idcypSu28wVEi/
         pHfRIVwnT1aIjr/MPKUAaDqF3JgYinjgwMpjTLzaHgkoQMZ+EhOOKIw6RFt8ivwKnbQg
         iOK7XP4+gBardS9VbZQWOZ+j8ASh8CTpXUgMv6IEEwmkT9T2/cjyK5iGc/KOcEPcCWz4
         9iG+FzS5yztEdHoL7ZULLyB9sf4ag3Q7g7btpWT4FtsGYKXmF1M6gd+lM/7V/qLyOTLi
         c7JDW1730Uir3KjMogu74mwIHafSNepvL3cs/ZRtWgW411yA40QxLd4KgbByMfkoT2V2
         wocg==
X-Gm-Message-State: AOJu0YxfUUJ6VQ6kdBSPf4Mer1j6M/0G1/INfg1KLZIMgRCpj9EJMOxy
	/j8ti1pdVrinoACUcxlf8FI4OPFQXO5qwjlcag5H28KWNHZIbyJqDSgryCDO5E+ZV93LFJOjILN
	Pjz/ViIlRji9CYPzymiaMAL/xm6WWbJmFbm5g+8ApSWCbxMJ0
X-Google-Smtp-Source: AGHT+IGQym1MRdzqSuukSJiCpBeFVkcfALrl22nJzCBYP3JzARJwR49+bfrLeaOWtKRPcf2XmMUmb+tVoxAvsEshkwE=
X-Received: by 2002:a2e:9e07:0:b0:2e0:e40f:3b41 with SMTP id
 e7-20020a2e9e07000000b002e0e40f3b41mr7681579ljk.0.1715093341630; Tue, 07 May
 2024 07:49:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226151013.8653-1-thenzl@redhat.com>
In-Reply-To: <20240226151013.8653-1-thenzl@redhat.com>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Tue, 7 May 2024 08:48:43 -0600
Message-ID: <CAFdVvOwuAc3TdtA=Z-z=NHWYken4n9zcUJbh177NxREX4NaHcw@mail.gmail.com>
Subject: Re: [PATCH] mpi3mr: sanitise num_phys
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, chandrakanth.patil@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000006b03e00617de49e9"

--0000000000006b03e00617de49e9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024 at 8:14=E2=80=AFAM Tomas Henzl <thenzl@redhat.com> wro=
te:
>
> Information is stored in mr_sas_port->phy_mask, values larger then size
> of this field shouldn't be allowed.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>

>  drivers/scsi/mpi3mr/mpi3mr_transport.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index c0c8ab586957..352f006c8fe4 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -1355,11 +1355,21 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_ad=
d(struct mpi3mr_ioc *mrioc,
>         mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
>             mr_sas_port->remote_identify.sas_address, hba_port);
>
> +       if (mr_sas_node->num_phys > sizeof(mr_sas_port->phy_mask) * 8)
> +               ioc_info(mrioc, "max port count %u could be too high\n",
> +                   mr_sas_node->num_phys);
> +
>         for (i =3D 0; i < mr_sas_node->num_phys; i++) {
>                 if ((mr_sas_node->phy[i].remote_identify.sas_address !=3D
>                     mr_sas_port->remote_identify.sas_address) ||
>                     (mr_sas_node->phy[i].hba_port !=3D hba_port))
>                         continue;
> +
> +               if (i > sizeof(mr_sas_port->phy_mask) * 8) {
> +                       ioc_warn(mrioc, "skipping port %u, max allowed va=
lue is %lu\n",
> +                           i, sizeof(mr_sas_port->phy_mask) * 8);
> +                       goto out_fail;
> +               }
>                 list_add_tail(&mr_sas_node->phy[i].port_siblings,
>                     &mr_sas_port->phy_list);
>                 mr_sas_port->num_phys++;
> --
> 2.43.2
>

--0000000000006b03e00617de49e9
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
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIELtXgc6
pUBosYeMR1TfhVom1TcVXX0XkU/IBPpESW1XMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI0MDUwNzE0NDkwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB6GJpjt+3I0bge/2fyAXFZoDtz
l6XdkDWxnBe7WUQcc0M4XQNef31b13vjETDmt/hpJnUpljKxxeCJ982b7hRVNmb3BaZKTjJo+xFU
oRttJQUFm7xgpZNyzUl/eHiNtllSMTKVjS8QL2z6iZZG+uQVSWegHnKBy6TGiNxf2/qVdsYfCuIn
Estffbg75K8gDdi91C7PXx839yRsFYtTSQCZRengrhhM6eBUgLIDe3G2FXNnXmngpTqM4b8e2TpS
6FL7a6eFyaP2cWmiJzogwSPOliG48Wop6bNKe8rhYVIMCUvQPSUKdkUYPchq+b04NYD01tu5//ZP
34sx+niqzf6c
--0000000000006b03e00617de49e9--
