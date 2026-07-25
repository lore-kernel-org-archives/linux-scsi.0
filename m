Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D602E2EEE
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2026 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991064; cv=pass; b=I/FawKKyTZYRBL6MVPDLbmiNTDwnoSAc/Obe9Xw9wIyhsLQNIX8agXxGeGr1n3gCIO+C0JRH2Hvkm5zwa/05BMt/AbMB3wwigE5JbrHxnMAYg7Oi9nnvC5PB1nWbYla3dpq+C8W7Ut5hYGoOD6Bo5fM2ehV8LXGlWzZIiGFAzEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991064; c=relaxed/simple;
	bh=szwjKwTuz+yNKvdBSprSzOYxNaUpFRKs+Hx1+fytJsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RrGoiXlduwynK5ihRkN08sih6GR0uE+I2SDdB4HbuOxDzBDbSUZBz7a3NQy8eRjWomJZzlmrDAmIKa4YA9BAyMPQHgnY6gFInGaI1bbkNJWHQrxC5Tf6RepQf4ir3bwr4vyeKLpYen01OrzadlpabHR+lzHpD5zJkn8nFEtKqXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=D6mkLxNr; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="D6mkLxNr"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6689f36ae56so1570051d50.3
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2026 07:51:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784991061; cv=none;
        d=google.com; s=arc-20260327;
        b=CCoxCfhV4Zj+IFJzAnzuB6qKWMs66yl4npjosl6hDYSHNhfJWmNnPyEcqpV2HxAM1c
         t5gTnS2shv/AvQlrwnkVJu0GMgnikok2f0P42YkCLrhFVPALLEo8ifelU9yNFjtokeKb
         cIL683xL4aQeOpf8en8ExavmERW46c2eAbmufu4NyRiuq9JS+e2Rtqkv3mY9RVqDPHrS
         IeK+V9A5c2wymx3ynBrXs90EQZ23jluWANuqAEfM0k32TYj++ofTChB/5Ju5N/LpV06J
         6c6Z0CUYwJsxsgEYi3kkPuILdKnTvtqh3YMNg2gCmiPeJ6ZzXZ0DGujMGf2S17SQqEYj
         7ztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pnFY+NL1wMs6HQctnpLrg5MSHuL5XLJldyr4+uKR9zM=;
        fh=7T885nt0PUE5/FkSvulNxxMowUJl2j20lVHbMoCa53o=;
        b=HNDwV/RdrQoGoDZMq3HUXF+HWOIvgOE7fidcFvQ837UrbSQ7Md0rzEBwGtHiq2Qxs2
         QOeGixycbFBHfAk9K+eaG+fd4I6e40L8qWeWiuXRdD4mMhE5RlrarvbpaI0GR78ZT4Oe
         Sjn0rD9Zi+r2bzIChVKrUiekohvfxJ5YQjjLy/QV/EcLpYBShmOYh2MevoiPXnutMWxv
         n0cUzaz6leFRldf0QmB3vviq8fW7+Ic1j2+CUy6+E6rBq9drKpg4hvJUXbEsIIK6LSBI
         +4IncG+9yrIVh/Owd+Ge8ZKdRU8EfU3+1UwkrDSXLypqwcKTxt26Lpqlgp7cwb7QKcGF
         Zviw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1784991061; x=1785595861; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pnFY+NL1wMs6HQctnpLrg5MSHuL5XLJldyr4+uKR9zM=;
        b=D6mkLxNrMx7ZOuG9IBzlKwQ4jOU/JZaA/PBfJMrnB45cwUpt+qt4XnZJaSX3a15Ngw
         S8wf+BNtyllzw0gBCA1EYavRJXAQp1qTcv94PDbD2Yx/VSkId2TEzUjsLZryQFT68O5n
         0RcCb3NkGLm15MBQtgh0daaHHxaZ1EA5QuD1uvSR91S6QjeHzXUm0LpgKNwR227HnCiY
         CGlOaFYksokO//0F+GBiEIdbX9NEz+NWcws874+skagAuslTowv93OyeVMgXPGWLuLnS
         81kB2VJOzMWWtK6bHIDJGCs6mc5mjM5OFMQppfRkyqWDGSBfG/OOeQ7TZvZvY0crITTV
         rd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784991061; x=1785595861;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pnFY+NL1wMs6HQctnpLrg5MSHuL5XLJldyr4+uKR9zM=;
        b=cflpOYGeju6L6BouugO8PQ3KcqiSDw3/TJ+Sae5aR5q0jlbULAwWauALqoSDPx+pm3
         BNj/NaGaZhDnolZIFeufdh62hbaIU4SFYPD74lQICnvsHGLK0skzO4Ez6vl9FPYXOnkj
         tR/+VIPADrzn5yQn8K2oouDlXFczOhZYefwiMzoPxmHvs16GW6wYCuaZkWaEytte5QR1
         8DFyiU/rPXkBhWDD45jBWft1ix7JNhJBYnYdpvp4tGxq4kVpbGcYDKx8BzoVAbpAmqza
         4e5wFNKJekHgk74xa+CnmUR8i5ZSroTfhdXVvKjwn9cACL6ma+4GBBtrr6kBpg6YYa9f
         49Gg==
X-Forwarded-Encrypted: i=1; AHgh+Rq0O8/3o0dGQfohGd/viIiCXwPO/xifsmcovvdSe2hiMI+66xj1ifu7y7pNeGe4I0klQkM/BeSaJAHA@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4lgIjombIZGy5kRupwBmwFiIgNwLVAov3xG9/LpcO9ZEPlQym
	lCparDWKNrXKC/ajXacIaGt0BucbtwEmjrk8An4PFPLSa3+OghOlWlaMkG3saRma+uqRHaq22yl
	WaPhLOxh0v3y8bn+D873f6INLK7oIJpZWtvV9tBDCiA==
X-Gm-Gg: AR+sD12iNluzCf/QJtiEy5FTcRDa6TPnjg1loEiRGVVEChFChL4QUyIxIXR2aMh8M8W
	KoU8YSk9t93Mhcs35KSmRPE1MlPr9wB8zLVj5+XUIhiQ9ere14EkYi4E12ICKzigB5Mb37ND18w
	+fOe26NVCy9csoHmFGfHJ0E6gIpYpyfdJJtrj3ZQHz7fMERAwfWr1LSL72fiD8SXAQrdQhB+bbS
	XwfVrjk27pROFd7Ive4WWdsi17l7VnAxCp4oBTPUS2onKwQrUJI/qCtHwgrYw8dRQKfaiCce/gX
	oqXv6ufAQ1sG5yRCu6UzphJ4rD0ThdNKO3D81slQkCBSzcASC0Y=
X-Received: by 2002:a53:acd0:0:10b0:668:98b:dc54 with SMTP id
 956f58d0204a3-668c7a3fc07mr491029d50.41.1784991060853; Sat, 25 Jul 2026
 07:51:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org> <7x3b4sttnc4oxkuvxmpkihfi76lkapjcigo7khgcgfytvol7w2@v5ykuyrk2z3m>
 <20260725091824-GKA77545@kernel.org>
In-Reply-To: <20260725091824-GKA77545@kernel.org>
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Sat, 25 Jul 2026 09:50:50 -0500
X-Gm-Features: AUfX_mxi8h9KJVu9G6xUZkOpr4TATQAXRS0gOluTWc4FpB0HNeql-4Yjcvl9SVk
Message-ID: <CAEev2e8z3cJn+ALoqu=ZoozpTJ6vO_eTgiDrSjC4nOC1XK57FA@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller driver
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yixun,

On Sat, Jul 25, 2026 at 4:18=E2=80=AFAM Yixun Lan <dlan@kernel.org> wrote:
>
> Hi Anirudh,
>
> On 15:16 Sun 12 Jul     , Anirudh Srinivasan wrote:
> > On Thu, Jul 02, 2026 at 02:31:36AM +0000, Yixun Lan wrote:
> > > SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Control=
ler
> > > which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 a=
nd
> > > M-PHY v3.0 standard.
> > >
> > > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > > ---
> > >  drivers/ufs/host/Kconfig        |  12 +
> > >  drivers/ufs/host/Makefile       |   1 +
> > >  drivers/ufs/host/ufs-spacemit.c | 931 ++++++++++++++++++++++++++++++=
++++++++++
> > >  drivers/ufs/host/ufs-spacemit.h |  90 ++++
> > >  4 files changed, 1034 insertions(+)
> > >
> > > diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> > > index ff170c0b6da0..4f53b7f7688f 100644
> > > --- a/drivers/ufs/host/Kconfig
> > > +++ b/drivers/ufs/host/Kconfig
> > > @@ -132,6 +132,18 @@ config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> > >     bool
> > >     default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO
> > >
> > > +config SCSI_UFS_SPACEMIT
> > > +   tristate "SpacemiT UFS controller driver"
> > > +   depends on SCSI_UFSHCD_PLATFORM && ARCH_SPACEMIT
> >
> > Can you add SCSI_UFSHCD_PLATFORM and SCSI_UFS_SPACEMIT as modules to
> > riscv defconfig (or just add the former and add a default y if
> > ARCH_SPACEMIT in this Kconfig entry). This will let defconfig kernels
> > to boot with persistant rootfs on these devices.
> >
> Ok, will consider adding one entry to riscv defconfig, but this should be
> handled in another separate patch, for making it as module or built-in dr=
iver,
> I'm incline to choose latter one, but would be glad to hear different opi=
nion

Module sounds good.

> --
> Yixun Lan (dlan)
