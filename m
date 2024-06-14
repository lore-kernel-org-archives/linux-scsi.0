Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515D042064
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 05:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718343186; cv=none; b=UHJJ51Vaw7+7FfWfEcSoGEtYxN8ydhKfIg7gG7RvexYxHbYsd1BDozsBLq/hgJs1YLFw+B53TmwbdR0Q12I3XvyUlWPgEpi1vC1SBjOkfZb6wWQLUhIbBrvUDyrYePi26SOiyANDpwS/zQKP4pUCB0JcKyYQzSkEJJwRt5pNllk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718343186; c=relaxed/simple;
	bh=BupNbaet3a10DtX8fq4B0pbTB9kFPovlKijsk5zElls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H2lS5EL4Zgx6gW9s6AEDejquBPIX5NzL2qyiBjWmqIVRjBJa9j9NJlXZx2ZP2kEWX7n63jr4fNZGA9HE8NzHh1fjMGeKuJCh14xBh6vXKohvvexMHLirqNNJ9TbUh0aSc8UKIyoQf0Ir23hRtfvJA4lN9UADVfAF44SMVEZahgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=WiLL9SsV; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="WiLL9SsV"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57a4d7ba501so2026988a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jun 2024 22:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1718343182; x=1718947982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o8ARRkQgQLeSzGpDyFDHG3CG5SMLQRwzzC+kAYB6yiU=;
        b=WiLL9SsVhxlDYeDBncnCHj8PuT3+B0x7hx2DDaHPisAY/7M1tM8A1yfaw/I/DSmBtA
         D6vRYu+NNrFJFaE/LmPdxC9tXut+NtSvBtw37dlh0rfyQIG3lFoP89FLZ6/Qh1K9B9nk
         nZ27P+6WgNMeWRQwIhJwHXjI6clrQLhUS4UhGLsrVGR+j2dO7f92/MfdUIctIzRtOHOr
         TCSn6mcyKsMb2BYIE/4uQYKWQp+gzXHPjGjxBTHRw596CRrYcvvAXEopOm997YFHbpbI
         +7Iavq4hmsLOiKupTjrHhBh4VqKLngoTxuZ7gelOmOYNer0butZdX5Xq/M45xEGczKZN
         9QNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718343182; x=1718947982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o8ARRkQgQLeSzGpDyFDHG3CG5SMLQRwzzC+kAYB6yiU=;
        b=kG510vIPtqFYGGGFt5xD2IHpuUD1pLoYMLx/6cgDKAeZoh//UjygSVAs7MWjmd1zlA
         0IchwyMSszMEwjI6ufAtkN7G6/MwsIen5Y6vEh2y5KvEP3pNHMO+Jw3WdngqyhsZ92oN
         IdqaexDV7AkHyxyx4akudoPIOn6ZsTnLdbFRmQhzyjOpxT8CuYE/fjPJvscjJdrY/7M8
         CvVm8ixIw3fzWMwttwCKKrhVc8FDOjVmUzT1qVaazok8rbBmRVsJ6RoBvDZBes0ufbNE
         lZkiUA0KMNqv+1ig3LaX+fsdVZdWE0PWOp0vQHChQslPy++eMVIsMT/26TufbE3cYu1a
         nhSg==
X-Forwarded-Encrypted: i=1; AJvYcCUFnys9Wcn59sHpnIvL7Mp1WemuoejdN/wdh232jGl2oNRezfqPpXyrYp78wxNU9p/+1AW8BVw7PszOit2Bo2wou/wkJ8P0AM/XYA==
X-Gm-Message-State: AOJu0YxEPNYag/RzfrPI9cm7I/uCi90bgheR1AvWzkRt/FuQ8bnrVRlx
	AU3i7w6oHBFgojs4je2CgEy3m4CSllYyst2fImKUl9LoV45J6n8do8ce/CavrvJSt3NJQAtu2jl
	dke3ppu+rgHP0sU59zv/Qy+cF3JXf/DCPzipcrQ==
X-Google-Smtp-Source: AGHT+IGTgVboz/ujcRsWq103qFWwrdS6joYaGKHoQsgk5YzRRr2+LI4jztKjeI6DNFtQgYBvlNW2w9j9iSbzdp79sMc=
X-Received: by 2002:a50:8d0e:0:b0:57c:6114:3efb with SMTP id
 4fb4d7f45d1cf-57cbd6496fdmr1053552a12.6.1718343182608; Thu, 13 Jun 2024
 22:33:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240607175743.3986625-1-tadamsjr@google.com> <20240607175743.3986625-2-tadamsjr@google.com>
In-Reply-To: <20240607175743.3986625-2-tadamsjr@google.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Fri, 14 Jun 2024 07:32:51 +0200
Message-ID: <CAMGffEmgcKh1xGOrRNsBq_GrEbL0a1UdG3dgg6Mg0vrsKzW_Vg@mail.gmail.com>
Subject: Re: [PATCH 1/3] scsi: pm80xx: Set phy->enable_completion only when we
 wait for it
To: TJ Adams <tadamsjr@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 7:57=E2=80=AFPM TJ Adams <tadamsjr@google.com> wrote=
:
>
> From: Igor Pylypiv <ipylypiv@google.com>
>
> pm8001_phy_control() populates the enable_completion pointer with a
> stack address, sends a PHY_LINK_RESET / PHY_HARD_RESET, waits 300 ms,
> and returns. The problem arises when a phy control response comes late.
> After 300 ms the pm8001_phy_control() function returns and the passed
> enable_completion stack address is no longer valid. Late phy control
> response invokes complete() on a dangling enable_completion pointer
> which leads to a kernel crash.
>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: Terrence Adams <tadamsjr@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
> index a5a31dfa4512..ee2da8e49d4c 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -166,7 +166,6 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, e=
num phy_func func,
>         unsigned long flags;
>         pm8001_ha =3D sas_phy->ha->lldd_ha;
>         phy =3D &pm8001_ha->phy[phy_id];
> -       pm8001_ha->phy[phy_id].enable_completion =3D &completion;
>
>         if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
>                 /*
> @@ -190,6 +189,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, e=
num phy_func func,
>                                 rates->maximum_linkrate;
>                 }
>                 if (pm8001_ha->phy[phy_id].phy_state =3D=3D  PHY_LINK_DIS=
ABLE) {
> +                       pm8001_ha->phy[phy_id].enable_completion =3D &com=
pletion;
>                         PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id=
);
>                         wait_for_completion(&completion);
>                 }
> @@ -198,6 +198,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, e=
num phy_func func,
>                 break;
>         case PHY_FUNC_HARD_RESET:
>                 if (pm8001_ha->phy[phy_id].phy_state =3D=3D PHY_LINK_DISA=
BLE) {
> +                       pm8001_ha->phy[phy_id].enable_completion =3D &com=
pletion;
>                         PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id=
);
>                         wait_for_completion(&completion);
>                 }
> @@ -206,6 +207,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, e=
num phy_func func,
>                 break;
>         case PHY_FUNC_LINK_RESET:
>                 if (pm8001_ha->phy[phy_id].phy_state =3D=3D PHY_LINK_DISA=
BLE) {
> +                       pm8001_ha->phy[phy_id].enable_completion =3D &com=
pletion;
>                         PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id=
);
>                         wait_for_completion(&completion);
>                 }
> --
> 2.45.2.505.gda0bf45e8d-goog
>
