Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410083FE7
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 07:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755503159; cv=none; b=t5YtZ7AV9BY75SFks6miOvEl5+pYlLZggTAuIGoc06bp2UOZOi6XMtAiy30DLPP46LgNa5CWXg5isBNlsnLwqxaFuVTzg5Hv/THYjFWGtOqq7N2BcegjQtPk4RmtA6eJX7qDHmv0gdWmPQfGtYUyGnROtpLvclDiCGgcd2ffvrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755503159; c=relaxed/simple;
	bh=lxrCEU5vJ9AZITvtmXWbjHxYgKSqJ0ksV/YYq2qqpsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=efBTndHJ65ElRtUf0Ag1TVU/AebI3wzp8Jf9JZmGjBY0KhU5MCQOEIb/Fe0Ij4MMb836UkJQ7ObZmRzYvqr8q4xOleaBCDAZPGGb/lb1TJ9sSBLYFxx5SemajKcjoWXaDrqRttUkGoLdfnC17WGjYUOIKeRBqWQ49uY/ShDoQAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Ejgge7Hw; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Ejgge7Hw"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61a483149e8so41035a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 00:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1755503155; x=1756107955; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ei+HPjKwvUT7ejrRmtqCcgAxjKia4Jkk5str3P3S/y4=;
        b=Ejgge7HwY6jc/HjpRG0K83Hx7yN/eho7yDlnvp+GBnLKSp99NxBNQigRPR4M67IiFJ
         BY/XIe0gLComKFBMWpT3Y8IN3aaG4UkJ22x3VJMjQfK09VbD/5AyUL6l2Y+oBDnn6YHa
         ONsH737ZCGRJUkq06e8I+nDh2dH5qcwcFF2lJkJkK7J06iUGOqGbKcloSOLqYThkzH+T
         2RXQb/dbrnwc8TmKQUmUFY+BaTRvL4IzKrRqikgSm6FXMI6dGnmkKlZj5D+SIyTE+Tqk
         11NkTiftxWAmwbytjrdimHb3X4nkDZ2OhJyz773CaQwVBAWkU7/kf3OU9vAa9d7gjGOC
         bpww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755503155; x=1756107955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ei+HPjKwvUT7ejrRmtqCcgAxjKia4Jkk5str3P3S/y4=;
        b=nOJzfSAL/JDcs0SnIFhu+7nHQoXNkKHUYRmBHfg+DCaMQSmyG3oRvBz1xmVrIeXkWy
         IpjBjOM10/6a7j+ei+lOz3NRBMgRwSVRv99nvmoR0faIMaPdvw66hL6m6dfhLSwxjx9R
         W7Ahh6sfFGZa9FuyvDuPm/kv3Om/q4I8yHw2PaC7XKG41WFA5btu81Q0eJoBFPzxPkP/
         +iEcyIkmcljX4PER7HVMbW1TykNpUun5rnh9w7phRtNBgvQ41TsNYcjICIGZbx09VGMC
         o6dlOgJaI5WG5nUytynIxIN6J7zyDKKXqL0mp6h3IOiZ3wFLPnEHy7oJxOyWdek4JwNM
         7VFw==
X-Forwarded-Encrypted: i=1; AJvYcCXnOnZQUFhEEiuXjfBud4/sGz3/aEzW8bUlH2IdVjJzn62eTu5x72d343JHiIDW+VZEOp+WGCOpRwBc@vger.kernel.org
X-Gm-Message-State: AOJu0YwBB4gCmEHMUzLzDwGNr30/yzBdRwfBy3zBOU+tOS7zr29kITni
	ZS6y/iJdGbmhllxNdtqUGnB0Cp6s+zlG9qDghjk+vm4uSzondO41Pa8AxaAlnPKTeyNENtvTjsR
	19+ZPZ1zMUEpA9Ig0rVAF5jqbTLNdJ9sQk8h62akjmg==
X-Gm-Gg: ASbGncsKD7HiOlV3iTH9v3uLchF0qP0hOfvGtnQF+ZOTpqAEeWSmMrfiopU8LMI1A8/
	0GdZTR2nLDIL6ElIpHCaiXE2SYUfyBF/NRl2p/X3+dkJiQQ11Bh8MmHB3VRqxS4xiGrWSwH07OZ
	oJP4ryHTVY9QA44N869GhokxnLSgpQfEsw4ZujOxcNfgGC5BhAI3MPqk/YxM37cfFDVX1G1VRax
	US4ejpTLCDjsljhjA==
X-Google-Smtp-Source: AGHT+IHja3wcgkVkImJVSmXPTbdYjF3aHYDpccIVvhrKzOH1XoTW3pkuuLdmzv/qdtyRQ52hzantH1WonqLJdo1Jocc=
X-Received: by 2002:a05:6402:3510:b0:615:ec05:a628 with SMTP id
 4fb4d7f45d1cf-618b04b9edemr4173561a12.0.1755503155402; Mon, 18 Aug 2025
 00:45:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814173215.1765055-12-cassel@kernel.org> <20250814173215.1765055-19-cassel@kernel.org>
In-Reply-To: <20250814173215.1765055-19-cassel@kernel.org>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Mon, 18 Aug 2025 09:45:43 +0200
X-Gm-Features: Ac12FXyeOLeLUcnS0-76dhF1XtIVZzYIbZYnX4EXg_p2tW3azx99jhHm6LWMvEM
Message-ID: <CAMGffE=YD=d7C5aY+n_XXGaUOEHM_YY0Amsgit6Lv1oAAEjTfQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] scsi: pm80xx: Use dev_parent_is_expander() helper
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2025 at 7:32=E2=80=AFPM Niklas Cassel <cassel@kernel.org> w=
rote:
>
> Make use of the dev_parent_is_expander() helper.
>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 8 +++-----
>  drivers/scsi/pm8001/pm8001_sas.c | 5 ++---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++-----
>  3 files changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
> index 42a4eeac24c9..fb4913547b00 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -2163,8 +2163,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
>         /* Print sas address of IO failed device */
>         if ((status !=3D IO_SUCCESS) && (status !=3D IO_OVERFLOW) &&
>                 (status !=3D IO_UNDERFLOW)) {
> -               if (!((t->dev->parent) &&
> -                       (dev_is_expander(t->dev->parent->dev_type)))) {
> +               if (!dev_parent_is_expander(t->dev)) {
>                         for (i =3D 0, j =3D 4; j <=3D 7 && i <=3D 3; i++,=
 j++)
>                                 sata_addr_low[i] =3D pm8001_ha->sas_addr[=
j];
>                         for (i =3D 0, j =3D 0; j <=3D 3 && i <=3D 3; i++,=
 j++)
> @@ -4168,7 +4167,6 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
>         u16 firstBurstSize =3D 0;
>         u16 ITNT =3D 2000;
>         struct domain_device *dev =3D pm8001_dev->sas_device;
> -       struct domain_device *parent_dev =3D dev->parent;
>         struct pm8001_port *port =3D dev->port->lldd_port;
>
>         memset(&payload, 0, sizeof(payload));
> @@ -4186,8 +4184,8 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
>                         dev_is_expander(pm8001_dev->dev_type))
>                         stp_sspsmp_sata =3D 0x01; /*ssp or smp*/
>         }
> -       if (parent_dev && dev_is_expander(parent_dev->dev_type))
> -               phy_id =3D parent_dev->ex_dev.ex_phy->phy_id;
> +       if (dev_parent_is_expander(dev))
> +               phy_id =3D dev->parent->ex_dev.ex_phy->phy_id;
>         else
>                 phy_id =3D pm8001_dev->attached_phy;
>         opc =3D OPC_INB_REG_DEV;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
> index 3e1dac4b820f..2bdeace6c6bf 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -700,7 +700,7 @@ static int pm8001_dev_found_notify(struct domain_devi=
ce *dev)
>         dev->lldd_dev =3D pm8001_device;
>         pm8001_device->dev_type =3D dev->dev_type;
>         pm8001_device->dcompletion =3D &completion;
> -       if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
> +       if (dev_parent_is_expander(dev)) {
>                 int phy_id;
>
>                 phy_id =3D sas_find_attached_phy_id(&parent_dev->ex_dev, =
dev);
> @@ -749,7 +749,6 @@ static void pm8001_dev_gone_notify(struct domain_devi=
ce *dev)
>         unsigned long flags =3D 0;
>         struct pm8001_hba_info *pm8001_ha;
>         struct pm8001_device *pm8001_dev =3D dev->lldd_dev;
> -       struct domain_device *parent_dev =3D dev->parent;
>
>         pm8001_ha =3D pm8001_find_ha_by_dev(dev);
>         spin_lock_irqsave(&pm8001_ha->lock, flags);
> @@ -771,7 +770,7 @@ static void pm8001_dev_gone_notify(struct domain_devi=
ce *dev)
>                  * The phy array only contains local phys. Thus, we canno=
t clear
>                  * phy_attached for a device behind an expander.
>                  */
> -               if (!(parent_dev && dev_is_expander(parent_dev->dev_type)=
))
> +               if (!dev_parent_is_expander(dev))
>                         pm8001_ha->phy[pm8001_dev->attached_phy].phy_atta=
ched =3D 0;
>                 pm8001_free_dev(pm8001_dev);
>         } else {
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index c1bae995a412..546d0d26f7a1 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2340,8 +2340,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha,
>         /* Print sas address of IO failed device */
>         if ((status !=3D IO_SUCCESS) && (status !=3D IO_OVERFLOW) &&
>                 (status !=3D IO_UNDERFLOW)) {
> -               if (!((t->dev->parent) &&
> -                       (dev_is_expander(t->dev->parent->dev_type)))) {
> +               if (!dev_parent_is_expander(t->dev)) {
>                         for (i =3D 0, j =3D 4; i <=3D 3 && j <=3D 7; i++,=
 j++)
>                                 sata_addr_low[i] =3D pm8001_ha->sas_addr[=
j];
>                         for (i =3D 0, j =3D 0; i <=3D 3 && j <=3D 3; i++,=
 j++)
> @@ -4780,7 +4779,6 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
>         u16 firstBurstSize =3D 0;
>         u16 ITNT =3D 2000;
>         struct domain_device *dev =3D pm8001_dev->sas_device;
> -       struct domain_device *parent_dev =3D dev->parent;
>         struct pm8001_port *port =3D dev->port->lldd_port;
>
>         memset(&payload, 0, sizeof(payload));
> @@ -4799,8 +4797,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
>                         dev_is_expander(pm8001_dev->dev_type))
>                         stp_sspsmp_sata =3D 0x01; /*ssp or smp*/
>         }
> -       if (parent_dev && dev_is_expander(parent_dev->dev_type))
> -               phy_id =3D parent_dev->ex_dev.ex_phy->phy_id;
> +       if (dev_parent_is_expander(dev))
> +               phy_id =3D dev->parent->ex_dev.ex_phy->phy_id;
>         else
>                 phy_id =3D pm8001_dev->attached_phy;
>
> --
> 2.50.1
>
