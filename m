Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB441E519
	for <linux-scsi@vger.kernel.org>; Wed,  4 Dec 2024 16:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331037; cv=none; b=TVQK+fkk3C50y5NUb4MI8n5/jhbCybRE5DnXLh6Y+RSpsiOwFziKbLKAaWjyU8WqYbB10xiLW7IepFcYDevGTuNSwTBUwnTSxQu5d46Uvc+XPOk+CDseM8B95jURJpqlR6cTXASwJiMTiHAebfW6I4k3CpqnS51ULEXM9UQLWgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331037; c=relaxed/simple;
	bh=cOvxnz8nA5vmSJ0d8Nz5OX9cYRshN45UbkNlKX2/dYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fLzruLv8VDzsAgHSIEYD+vuRf9qAbuZ1DSFSx0OU0msa87YyUhLko1DLbiGZ01QuuPoJ29lWb+8aM+11tXx2/wvBjxDeFQYthmfirmGZDFltEaTd/W4WmFZbdO9SjTiV3eD+ms3WOhmHZU7hXYVt4iB0JKZWZxC66KaLuSxJx4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eDQ+LDN6; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eDQ+LDN6"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa549d9dffdso1100297466b.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Dec 2024 08:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733331033; x=1733935833; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pdsq6JfjPcCpm2zveC7HsrJs7Jt7/a28/pHa3OaP64o=;
        b=eDQ+LDN6SWg0nzMthjXVm4O6F/wAMuKlMux5pf0p9ni8sPolWzhpJ2lsOZTuCRaZSY
         fwiMDY1hkdu56UBiIcj8q/bITnvI6G3GCxmdXoDpKeFBv0GuuepU+gr/FraRt6MPE8MZ
         QAH1CMfBEyBjXvcxKMoPRe1zGN3VhmT1fuF9x1z+57ji9DXQAGCKhO1tkwN8v6MlUfkn
         kXeJt8YW+e8ObcS6Z0MDxcO9AjnP25Cg7P4+mYRBcAbStHVRRPpM00JoHr3ZYIh69VQs
         3ZhdcYgMVv+Mwlc+N09mSL7eQaPoQifOYgyBef6e0Ic1Di+IBsya1gZu3H5D8nXkS7ga
         PUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733331033; x=1733935833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pdsq6JfjPcCpm2zveC7HsrJs7Jt7/a28/pHa3OaP64o=;
        b=mJ340t4sUQqQlBTvfnuQnTxK2BAeJs4HkC6FdprGxc68LLraF7UTP9UWT5yjcs4YRk
         5AJuJA/EXNLG6VPaI2uPoOUjrCJQg8K6ozXiMcDe6h+ScPdyg+aWK2b1yLZpyGrdsr4L
         qM4oTCp2CbjR1eOqkHhmfRB0zvs8LePU56XnUy6rxqOucyZ35loxZEyMuZLDOOjUHDhN
         0YkD9NWGKRTpEKV2pkl4QIUe4hZNXm6K0wh33U3eFX9Jb52Ocdhk53yM6jLktj11RQpp
         3pg4Jc/poCVB91Cn+1R/lEft5VcZZ5hb5vlTpMT9ewNPBMoComqGqQH54i9ZTFrjmYdG
         gRqQ==
X-Gm-Message-State: AOJu0YzM6EqLSVmAwQE0HTTI14tr/j5wTXGUbmrxaXsQHtNPVWtiXz5g
	IGfvXgjpXMk+FRiwQhIDIWmEesR0KUmP0nsK1Y/PnATG8rb3zQ2J7Kv8KBrf51zYUKYaGDYn50b
	l7LpucMBBuM+6F8g8tSsmHMyo443AZScEnExsQs1+Jd3Wbp48NZ0=
X-Gm-Gg: ASbGncs7sHSBE6L5j0P64XaydzcJfuedccJLcps2LmY8uyLgs32peIXNwYRMNpRm987
	vr344VZlYPZChYEXnIUWneAtxHOCqSEGS
X-Google-Smtp-Source: AGHT+IFH4YdfNYTUv4szeMdmJ2p030B64ITseH5nsh/PHsAkBW16kx5x2mQtfQDO2MLGReAJizp9hsxYoac5cfuXDCk=
X-Received: by 2002:a17:906:3099:b0:a99:ecaf:4543 with SMTP id
 a640c23a62f3a-aa5f7d8d1abmr556552566b.25.1733331033338; Wed, 04 Dec 2024
 08:50:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241117194604.13827-1-leeman.duncan@gmail.com>
In-Reply-To: <20241117194604.13827-1-leeman.duncan@gmail.com>
From: Lee Duncan <lduncan@suse.com>
Date: Wed, 4 Dec 2024 08:50:22 -0800
Message-ID: <CAPj3X_XGSQswf=iw_7ekfDaed6JGZMs_+=Rb9fgTKZ9Cj0TYAQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: iscsi: fix sysfs visibility checks for CHAP
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.org, 
	open-iscsi@googlegroups.com, lduncan@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I see there's a spelling error in the description, so I'll resubmit.

On Sun, Nov 17, 2024 at 11:46=E2=80=AFAM Lee Duncan <leeman.duncan@gmail.co=
m> wrote:
>
> From: Lee Duncan <lduncan@suse.com>
>
> The username and password checks were backwards for the sysfs
> visibility checks, so correct them. This likely went unnoticed,
> since the visibility/writability for these attributes
> (username/password and mututual username/password) are all
> the same.
>
> Fixes: 1d063c17298d ('[SCSI] iscsi class: sysfs group is_visible callout =
for session attrs')
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tran=
sport_iscsi.c
> index fde7de3b1e55..81c57e0e8d90 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4587,13 +4587,13 @@ static umode_t iscsi_session_attr_is_visible(stru=
ct kobject *kobj,
>         else if (attr =3D=3D &dev_attr_sess_chap_out_idx.attr)
>                 param =3D ISCSI_PARAM_CHAP_OUT_IDX;
>         else if (attr =3D=3D &dev_attr_sess_password.attr)
> -               param =3D ISCSI_PARAM_USERNAME;
> +               param =3D ISCSI_PARAM_PASSWORD;
>         else if (attr =3D=3D &dev_attr_sess_password_in.attr)
> -               param =3D ISCSI_PARAM_USERNAME_IN;
> +               param =3D ISCSI_PARAM_PASSWORD_IN;
>         else if (attr =3D=3D &dev_attr_sess_username.attr)
> -               param =3D ISCSI_PARAM_PASSWORD;
> +               param =3D ISCSI_PARAM_USERNAME;
>         else if (attr =3D=3D &dev_attr_sess_username_in.attr)
> -               param =3D ISCSI_PARAM_PASSWORD_IN;
> +               param =3D ISCSI_PARAM_USERNAME_IN;
>         else if (attr =3D=3D &dev_attr_sess_fast_abort.attr)
>                 param =3D ISCSI_PARAM_FAST_ABORT;
>         else if (attr =3D=3D &dev_attr_sess_abort_tmo.attr)
> --
> 2.43.0
>
