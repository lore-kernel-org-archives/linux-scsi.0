Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5F2384224
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 20:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774643051; cv=pass; b=S/BmTxUGRmgzG1AD4mEVJa6Ocmn5pcj2LUJbB6qbj5nRxIcpZqEiryYTBsqSlPCLttY6/Aurq9ZF3+/+W0DrE6llboJir8I7NHUzEPxZVQgXVnvSWXnQWxeCZoDRT491UTr1UILHLSuZ3AXftxAUYBsuajIlCvpjzOx35rQeJw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774643051; c=relaxed/simple;
	bh=fe8HYEgNDSZEJwtPnP9d7rdRK4mOuzWO1Arb10bM66I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yb6NcVfovtm+xS+fstGOiPLxB8KOZ968Ob9iE740ihXvaQjip5d7a+JyNVdfiWbIlji82pjfZJtQuHR6rs6ffpxI6XVSIcXhHrs9Xz9xUBFdQx+/YQYyab1srduhz9Ewnt87i9WOQKjlCaULMA27QxME/W914Nt2JSHDnnwUYK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VuqQy0dF; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VuqQy0dF"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-66b0f489f3aso3006381a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 13:24:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774643047; cv=none;
        d=google.com; s=arc-20240605;
        b=eo6coFueO/lDW3EYwJtAHXqgnlpazNLh7Ft11KaQ2wXUv687i6AOKA5i6Ri/HJ9/tc
         zgMrPFMdis7WgRusV9wzCm+3zFPYNJbjpjYBZkujmpmwr8DttciMCui4KdWrM1mjJAYl
         /VInIz1/U/3jX+dDzz4WkTo5dITNe52uZgDBOEYb7sLhnnZw7OayOLgeAWGDKNVF7Z1Y
         XW9M3Y7Pa9iUE/w+d2uakIJH50B/d3myehyuw3z+r/Wkbqu1TxWYUq2qWlwfW3t4H25f
         bAVZC4Fdsu5RmzoKVxTNDANehpWM9VCjnruptfwXUPDKw9yKGyKtl1EoEIcgtgTpbwKv
         FM7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9WeOtA6rLKd2feImk1nWk/a5NsEeM0kN8oqqyEId0bQ=;
        fh=PhjM2NcQbjiEKzS4pL2OPd8RaOpvHJIrSNKrKX35N6s=;
        b=VMS9XO+HAdMhOuda9wEa67CXFbysCLjcdn1Oi7ZF6y6nZ/aQ1zF1P1ZfYa9qoTaz5P
         AuBatwUf/nGQ3A8xY6p8oDSDWESONTpr2DmvHZ/NtNeIZARyU1Fc8XRWdc02l+aGIwN/
         j6CudANpBJK2SqLruYYiXQ/fxhf1ZIW55SjBRqWy4lI2dK8FeCT2tTpdxeuowJp8ZZAJ
         EGLslJhDX7k604WzI9ERM9h09cfOpPTDsbpBnv3y9+oE70mwUjWOft6DIg+8s/hvq+28
         Uv/tv3WPSO7P/ufjD4CM87cBSEtENMnfNVl6CtiwyCZsxT6as5cva+lYbLGKtLkpGh8P
         SF5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1774643047; x=1775247847; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9WeOtA6rLKd2feImk1nWk/a5NsEeM0kN8oqqyEId0bQ=;
        b=VuqQy0dFFUKCW5LFnvEaxGiKsvA7wZMtgk9MpLPdPYNG0CjRWontr06l/oScJ9SlL1
         r9wEtzgkdnjKi0jIFmkCWVMcUt1DKXUUnD7yfUC1jgsUScQbM2/1SadvK6JBbSkmQYv4
         qSJ68sbS0T6VZPCTKM6GaMbq+iX9Q7TUrvklbvVXtraoXJ2iQJiNf1CCxINzF8kNLKwP
         NOvf4x8hp0t8wrVujWooo56OYrlQ2VJYEsTv/8AoqFdQu5mfMcrvLthjlYiwU3SoH/Us
         hlNdeZy9StxdLBHAoU7DXMvu0AqipWs5uVJE/jJHuiXn0PFfRmPiYl7JPpxJvKz+0G7z
         /5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774643047; x=1775247847;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9WeOtA6rLKd2feImk1nWk/a5NsEeM0kN8oqqyEId0bQ=;
        b=iqnTKD97qlQ13uEmHpDkEw0MtlgtG28JPJBjrJXM0MkEbL2pUVFmkb48pqcpVUzeOe
         sN2LO2oNAal0zE94M0VjdrrBnvBQEw84wkoAF9xgpttPr3Wdh65iCascglCE3J4iw5Mz
         F+EGb7aCUnSojQEANh3ut+ZeLlXlq6+XsvGXk8iRxK7FKD5wYWiKto3H1pZIH8MJeO4t
         lrPmOcC+/jG50PALLr6FdnMt4Ebl8wMdZPrPAFDzG5i901+oFghvIj6+gQcoCKOkdz05
         h+BvQLm/vhzzqxbSMpQ44TcvAxU3ZSTw75JjtRyBvjlkQdm+wLxnd1OHze0LXffcs31R
         ee+g==
X-Forwarded-Encrypted: i=1; AJvYcCVIl0fwsOndaba65i66+I0jzCpqq04xRv7hNJOxkYpXLFwZd9bx7z6MlM95S4fX/UKCaCesW6B9EkP+@vger.kernel.org
X-Gm-Message-State: AOJu0YyF11VIhjWKCmA8hTfUbFmfCh7qvUNmxw3UFgj2O2TbCYfEmC/c
	6R4hnhtfXDe+fslKGOHQIQwNcTm+1ktvAa5FJ50Dc5F9EuchWA6aeHmX8rCpVqa2JkmQNd9Y5Tu
	Ta3mNf/L5yuXaU1cLT15k7TF5TLyfkwmnMGxggtYYAQ==
X-Gm-Gg: ATEYQzxJHMALuIwHZKzf4i03IMoXXiqPg2BXxKA2ftGAgMTu3kOwa5mtbEFQuDZMYss
	sNBOPK0VPJQ4OAZwu5AsCtE+0l06C2fFU72VTQkAQD+Q0NLhlhXPQNxFWDTB2jXM2YyvgEPPCuZ
	3YFy4nvpRIUepn+I9wynHh37auXvk2Lm1ksZkfdYXbXuZlE7YOlEGPDp9pOes0T4VVDb1+YAkav
	quxjWKRsOAHQZaS+Ws5Klqh0IaVjgsImk7WmEczvPXmt3bNnU0bhndyuf3Fb4cek68rw4aRnsnm
	p4myeY7uxklVn7bFryImW3SC7OGPOoLXxRxsRrej
X-Received: by 2002:a05:6402:46db:b0:66a:199d:138 with SMTP id
 4fb4d7f45d1cf-66b28c66cbemr2039826a12.20.1774643046839; Fri, 27 Mar 2026
 13:24:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260327184706.1600329-1-vladimir.oltean@nxp.com> <20260327184706.1600329-10-vladimir.oltean@nxp.com>
In-Reply-To: <20260327184706.1600329-10-vladimir.oltean@nxp.com>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Fri, 27 Mar 2026 20:23:54 +0000
X-Gm-Features: AQROBzCjrloDfUGTlNvOpQXdM4anVOjHCl2P0WQRB2XbIrpLYVg7AhYSjcExBJI
Message-ID: <CADrjBPqMwtrae7LB9A8xipg6R0rHGewe69awQ_jJnsf=2c=eTw@mail.gmail.com>
Subject: Re: [PATCH v6 phy-next 09/28] scsi: ufs: exynos: stop poking into
 struct phy guts
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, dri-devel@lists.freedesktop.org, 
	freedreno@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-can@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-pci@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org, 
	linux-usb@vger.kernel.org, netdev@vger.kernel.org, spacemit@lists.linux.dev, 
	UNGLinuxDriver@microchip.com, Bart Van Assche <bvanassche@acm.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Chanho Park <chanho61.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Mar 2026 at 18:48, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> The Exynos host controller driver is clearly a PHY consumer (gets the
> ufs->phy using devm_phy_get()), but pokes into the guts of struct phy
> to get the generic_phy->power_count.
>
> The UFS core (specifically ufshcd_link_startup()) may call the variant
> operation exynos_ufs_pre_link() -> exynos_ufs_phy_init() multiple times
> if the link startup fails and needs to be retried.
>
> However ufs-exynos shouldn't be doing what it's doing, i.e. looking at
> the generic_phy->power_count, because in the general sense of the API, a
> single Generic PHY may have multiple consumers. If ufs-exynos looks at
> generic_phy->power_count, there's no guarantee that this ufs-exynos
> instance is the one who previously bumped that power count. So it may be
> powering down the PHY on behalf of another consumer.
>
> The correct way in which this should be handled is ufs-exynos should
> *remember* whether it has initialized and powered up the PHY before, and
> power it down during link retries. Not rely on the power_count (which,
> btw, on the writer side is modified under &phy->mutex, but on the reader
> side is accessed unlocked). This is a discouraged pattern even if here
> it doesn't cause functional problems.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
> Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>

> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Peter Griffin <peter.griffin@linaro.org>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Chanho Park <chanho61.park@samsung.com>
>
> v5->v6: collect tags from Alim Akhtar
> v4->v5: collect tag, add "scsi: " prefix to commit title
> v3->v4: none
> v2->v3:
> - add Cc Chanho Park, author of commit 3d73b200f989 ("scsi: ufs:
>   ufs-exynos: Change ufs phy control sequence")
> v1->v2:
> - add better ufs->phy_powered_on handling in exynos_ufs_exit(),
>   exynos_ufs_suspend() and exynos_ufs_resume() which ensures we won't
>   enter a phy->power_count underrun condition
> ---
>  drivers/ufs/host/ufs-exynos.c | 24 ++++++++++++++++++++----
>  drivers/ufs/host/ufs-exynos.h |  1 +
>  2 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index 76fee3a79c77..274e53833571 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -963,9 +963,10 @@ static int exynos_ufs_phy_init(struct exynos_ufs *ufs)
>
>         phy_set_bus_width(generic_phy, ufs->avail_ln_rx);
>
> -       if (generic_phy->power_count) {
> +       if (ufs->phy_powered_on) {
>                 phy_power_off(generic_phy);
>                 phy_exit(generic_phy);
> +               ufs->phy_powered_on = false;
>         }
>
>         ret = phy_init(generic_phy);
> @@ -979,6 +980,8 @@ static int exynos_ufs_phy_init(struct exynos_ufs *ufs)
>         if (ret)
>                 goto out_exit_phy;
>
> +       ufs->phy_powered_on = true;
> +
>         return 0;
>
>  out_exit_phy:
> @@ -1527,6 +1530,9 @@ static void exynos_ufs_exit(struct ufs_hba *hba)
>  {
>         struct exynos_ufs *ufs = ufshcd_get_variant(hba);
>
> +       if (!ufs->phy_powered_on)
> +               return;
> +
>         phy_power_off(ufs->phy);
>         phy_exit(ufs->phy);
>  }
> @@ -1728,8 +1734,10 @@ static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
>         if (ufs->drv_data->suspend)
>                 ufs->drv_data->suspend(ufs);
>
> -       if (!ufshcd_is_link_active(hba))
> +       if (!ufshcd_is_link_active(hba) && ufs->phy_powered_on) {
>                 phy_power_off(ufs->phy);
> +               ufs->phy_powered_on = false;
> +       }
>
>         return 0;
>  }
> @@ -1737,9 +1745,17 @@ static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
>  static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  {
>         struct exynos_ufs *ufs = ufshcd_get_variant(hba);
> +       int err;
>
> -       if (!ufshcd_is_link_active(hba))
> -               phy_power_on(ufs->phy);
> +       if (!ufshcd_is_link_active(hba) && !ufs->phy_powered_on) {
> +               err = phy_power_on(ufs->phy);
> +               if (err) {
> +                       dev_err(hba->dev, "Failed to power on PHY: %pe\n",
> +                               ERR_PTR(err));
> +               } else {
> +                       ufs->phy_powered_on = true;
> +               }
> +       }
>
>         exynos_ufs_config_smu(ufs);
>         exynos_ufs_fmp_resume(hba);
> diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
> index abe7e472759e..683b9150e2ba 100644
> --- a/drivers/ufs/host/ufs-exynos.h
> +++ b/drivers/ufs/host/ufs-exynos.h
> @@ -227,6 +227,7 @@ struct exynos_ufs {
>         int avail_ln_rx;
>         int avail_ln_tx;
>         int rx_sel_idx;
> +       bool phy_powered_on;
>         struct ufs_pa_layer_attr dev_req_params;
>         struct ufs_phy_time_cfg t_cfg;
>         ktime_t entry_hibern8_t;
> --
> 2.43.0
>
