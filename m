Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6277183CD4;
	Mon, 12 Aug 2024 15:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723477306; cv=none; b=hZssj/IRp9c3i2q0/2T74HxQuLWgtUaoA4+MBSkXzOLBtKtsmpJlVczpWUep51mG7bj+JvT8X/bcV6LR6NfLX7VIRPe4n8AsTj1GgpAl+IHKJ79MKigjtnCcwC9nv2BUb5PSm2I895zw6kZW0u60ItMG1Zu9ItOjfIlUgj4ZCgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723477306; c=relaxed/simple;
	bh=arsBk47r35SMOp52SqQFyYG+SAqKjNHI+0xwr4ON+z4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IC74X1RgulW2W0zlFhuihJzN5NzLFnZBnWQpoClcmR8QCJH72nFtl+2lAHf5npK7TEzxHpRjM+5+Nzf6pQRrZGFOCBmPlzDuLPMB5+IAUreQ4TYYrr6CU7/Zb9M8zM7DpudoTjQAqbRRoAMVDAbjeXwV8gRqmKiIAWv9j6W+uqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U+btOPwY; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U+btOPwY"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52efc60a6e6so5865950e87.1;
        Mon, 12 Aug 2024 08:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723477303; x=1724082103; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=arsBk47r35SMOp52SqQFyYG+SAqKjNHI+0xwr4ON+z4=;
        b=U+btOPwY2+cOKIhAdZzvNOC3q8B0HhR89RBRykA8OVkcpbrBUcIwS4WfLjA19AxMOY
         J0AzWBlIbO6QPgL0di/dlH8Kw4eKIJ7EW5luOLZlaf/PrVoHYZzX8lOJiy+XZ2/A4hi3
         sdlwDJMyMGxSRqt6sWXz/TeVD4VGI3CeKcBaGXsvEVS8PWvG8EDVC4JO1d7KWbaJlJYs
         E5bcPjiTyxYSBn5w9faCFQHFHLzVeodanoyR8h/5wmnUGSJ7pG3JO9h/t60Okpbl0WJU
         SOpcZL+aNS0O9jxlQR6LSPVV1j5Bh35duU0+DUg8mi0mfwKY42oEM8dosbx8EloGUBoH
         iaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723477303; x=1724082103;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=arsBk47r35SMOp52SqQFyYG+SAqKjNHI+0xwr4ON+z4=;
        b=TsIDQrdhSDiCvH8g5XpxQnKpcObG+rVO3fsjKNBclJb3EVqXadRViNfEkEBxOBpjFY
         eX0iXtY0akV6NBopK3u/BptzdyOP2zBClZhEpkwiwiwRx+T8Y6A8B1PMMSO5JK7LrDon
         PrtWKW8ET6z1o6o0g2JZVrXhRUAqFhqK+zQUZP5B7sH3eo+r/QI/YqePNpgWp5YopaPD
         XacQIGjE8lQkm2Dn2Xk/MiJKYlUeeQmT4YqfzIUjnoJgvElXPmNT++X5QnWdwwr7NkwP
         Mx+QoT+cTmxJhzq4oFLzNd84x3PDdbXw09VB28jH3Uz9f6Nn8w2zCoT2cg+fTTtdArSO
         /F+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtZNAVIAgpBrUMqgyCuC2DeBkpTaKE79bjh6r0Uu//DuRFkZ5PG8A4oz/VbDKEM3syDENKtjzpTiem+P9rjWg6VqOuwQ9wOhNz7HyA5urgwbh9+XYUhqhz9OYvsQaK2TENMZRic+VGVA==
X-Gm-Message-State: AOJu0YxHeTkI1qXGnURRqibrt7qFhOlqALeojyD+i7B5WeCRI+9Qrm4J
	y7T1anbuZnVHc9H1dFVQ6qTTlFkQi6JRfN/+wMYqIOj17QhS7w29
X-Google-Smtp-Source: AGHT+IHhPDOj1w85n0McFlGpR3+md0Z5T6agj0fCRtNd7sYXOTVF0xidjMjYkDpSUqg4kHNi3fEe3g==
X-Received: by 2002:a05:6512:3190:b0:52c:e3ad:3fbf with SMTP id 2adb3069b0e04-53213684160mr381665e87.42.1723477302469;
        Mon, 12 Aug 2024 08:41:42 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bd187f4e19sm2184694a12.20.2024.08.12.08.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 08:41:41 -0700 (PDT)
Message-ID: <f4de493e53b6d2ea543d10bc07a030b32b1e2107.camel@gmail.com>
Subject: Re: [PATCH v1] scsi: ufs: core: introduce override_cqe_ocs
From: Bean Huo <huobean@gmail.com>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
  bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com, 
 beanhuo@micron.com, adrian.hunter@intel.com, h10.kim@samsung.com, 
 hy50.seo@samsung.com, sh425.lee@samsung.com, kwangwon.min@samsung.com, 
 junwoo80.lee@samsung.com, wkon.kim@samsung.com
Date: Mon, 12 Aug 2024 17:41:40 +0200
In-Reply-To: <1723446114-153235-1-git-send-email-kwmad.kim@samsung.com>
References: 
	<CGME20240812065927epcas2p4ace98e8757a76e62efa3165de719408a@epcas2p4.samsung.com>
	 <1723446114-153235-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-08-12 at 16:01 +0900, Kiwoong Kim wrote:
> UFSHCI defines OCS values but doesn't specify what exact
> conditions raise them. E.g. when some commands are nullified
> or cleaned up, Exynos host reposts OCS_ABORT. Even if
> an OEM wants to issue them again, not fail, current UFS driver
> fails them because it set command result to DID_ABORT.
>=20
> So I think it needs another callback to replace the original OCS
> value with the value that works the way you want.
>=20
I'm not clear on OCS was initiated by UFSHCI, but could you explain why
it can't be altered within UFSHCI?



> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
> =C2=A0drivers/ufs/core/ufshcd-priv.h | 9 +++++++++
> =C2=A0drivers/ufs/core/ufshcd.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 4 +++-
> =C2=A0include/ufs/ufshcd.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 1 +
> =C2=A03 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd-priv.h
> b/drivers/ufs/core/ufshcd-priv.h
> index ce36154..4dec6eb 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -275,6 +275,15 @@ static inline int
> ufshcd_mcq_vops_config_esi(struct ufs_hba *hba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EOPNOTSUPP;
> =C2=A0}
> =C2=A0
> +static inline enum utp_ocs ufshcd_vops_override_cqe_ocs(struct
> ufs_hba *hba,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0enum utp_ocs
> ocs)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (hba->vops && hba->vops->ov=
erride_cqe_ocs)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return hba->vops->override_cqe_ocs(hba);

it is useless until you should introudce an usage case.


Kind regards,
Bean
