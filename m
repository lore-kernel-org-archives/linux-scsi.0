Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B0F18FDDC
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 09:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729242507; cv=none; b=LPBX06/3ljyhvyVUMwWVrjzDHAxwXXm9l6/niXTdkUeF2EO0CyNtP4lsiES5bQJ6cNp/X2pxgCSFjGUTBtlFGyK6erBOvApDjJzZHcwnxlVaKtQj91L0xjsgF8b0sdOBveHaI+Ch0NmETDD3zA5SNWR1ixyKcafLZvrLmUS43W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729242507; c=relaxed/simple;
	bh=0B/3DutOh0bILa/djnA0u1nChw5bsTsXPOu72uE41Hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lxj+R8i0E50JKdOPk5Fs+rhG6FTRmFFzQqwkOZNYcfqrqr3mrQf7h32D98rdpckP+OWpmbGyDtWqlxXKYkk1cm2v8m1Puv62Eq1m3E08mvAFJi85dOo+ef1kg4YrPBWb1Tss5giVnKV7IMu+dADld/fdgMuFqEAJnLL21SzYkrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hkE3nH68; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hkE3nH68"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6e35f08e23eso17894047b3.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 02:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729242505; x=1729847305; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJ6VE13c11G61wAxeas2h5gnGo/zqasBkmWrvIHrfEI=;
        b=hkE3nH686p700bhL6NxbcWucik0bLUhoiwL5Sk6hBnlMPPMJOZU+auCbZ6KNGVLJ22
         mHulkRxj0y8hBxplJgR/glloZdu7f/D41keqH9RdL3Bc5kwqcV8ag8M6USXOry9HNKh0
         WoPBuX3tNoD2PVaF8Gw2jf8F+vmA94mGX9eCGSjmXvVQrgsESEsglJkXfLAmbiRnbpcj
         30cKUuIG5s1o8p6VLcFvAB+JRtAAMc7goESTuw4UhV1TlAk4OKDqzePvDT163jwdJTm/
         avKRyNSHFc3XBn6VIyMxZZn4eugv3NVKmDdNjkBEjbTIThTV6vtrvxvg+Oi1/Sre8JvE
         b7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729242505; x=1729847305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tJ6VE13c11G61wAxeas2h5gnGo/zqasBkmWrvIHrfEI=;
        b=hov4WDJy7cWgUY4Fhmi0+zVPeHXrUlhyWde6g+qEjewVPYrg8ckDHZeKhikFOHiafM
         le5WKYKB3KzR62kxlh6KTJcFyZtwvUlZe/fd1YzLOgvDBkaBpun+BT6IVK/pF7mezwvL
         CUwWz5KTZXJvawbLHJ3Q420JcowBUoCZYw+l2PYrQjkhRsmCbb29gIQi182mt+FZsrtD
         lMR7evBUi+CcOl6Pn9+iBeSSfpkcDdJHO525k6NXXmzNGbMGRmXw6Mrm5bNaxIor5BlW
         eR5gg87Vl4sp0XB9vOxv1UUDnJ3jDp5JhZXm+vRuY9tAiNYbdy9OWWWD5l+Wf3gXz68X
         ECUg==
X-Forwarded-Encrypted: i=1; AJvYcCUhllw0+uXbzGEsMj0LECioAU0vlrb4dQA2pxrxB5E8BSDa/UbEhfukUGzn55kksBrfStCwa569V+5M@vger.kernel.org
X-Gm-Message-State: AOJu0YyD9TTJIJBhpND99L4eM5OftStTi0VQdqIvRb/qgfKvikr7O6sN
	WrD9EB04+JgtEupBKmb9OnMmR3vp4NaUPkiDrQU9Y1ioZGgAkaEvWwz12pbCuS+9O27L8i+CtGI
	ZaJMGzdLpRFKHFHRN3AuDLiMYUJ+4r+KWS872Mw==
X-Google-Smtp-Source: AGHT+IGLAR84NKVTp2k0U1wv1KUEMLaS/54P9n3Cejrb2qBl8a6BURD7jrtNldf/aXhGh7hy47DHJ/mFxpHljVTmPDA=
X-Received: by 2002:a05:690c:2b08:b0:6e3:2e50:8c0c with SMTP id
 00721157ae682-6e5bfd89092mr12731487b3.41.1729242504598; Fri, 18 Oct 2024
 02:08:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1728368130-37213-1-git-send-email-shawn.lin@rock-chips.com>
 <1728368130-37213-6-git-send-email-shawn.lin@rock-chips.com>
 <CAPDyKForpLcmkqruuTfD6kkJhp_4CKFABWRxFVYNskGL1tjO=w@mail.gmail.com> <3969bae0-eeb8-447a-86a5-dfdac0b136cd@rock-chips.com>
In-Reply-To: <3969bae0-eeb8-447a-86a5-dfdac0b136cd@rock-chips.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 18 Oct 2024 11:07:48 +0200
Message-ID: <CAPDyKFo=GcHG2sGQBrXJ7VWyp59QOmbLCAvHQ3krUympEkid_A@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] scsi: ufs: rockchip: initial support for UFS
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>, linux-scsi@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Oct 2024 at 03:21, Shawn Lin <shawn.lin@rock-chips.com> wrote:
>
> Hi Ulf
>
> =E5=9C=A8 2024/10/9 21:15, Ulf Hansson =E5=86=99=E9=81=93:
> > [...]
> >
> >> +
> >> +static int ufs_rockchip_runtime_suspend(struct device *dev)
> >> +{
> >> +       struct ufs_hba *hba =3D dev_get_drvdata(dev);
> >> +       struct ufs_rockchip_host *host =3D ufshcd_get_variant(hba);
> >> +       struct generic_pm_domain *genpd =3D pd_to_genpd(dev->pm_domain=
);
> >
> > pd_to_genpd() isn't safe to use like this. It's solely to be used by
> > genpd provider drivers.
> >
> >> +
> >> +       clk_disable_unprepare(host->ref_out_clk);
> >> +
> >> +       /*
> >> +        * Shouldn't power down if rpm_lvl is less than level 5.
> >
> > Can you elaborate on why we must not power-off the power-domain when
> > level is less than 5?
> >
>
> Because ufshcd driver assume the controller is active and the link is on
> if level is less than 5. So the default resume policy will not try to
> recover the registers until the first error happened. Otherwise if the
> level is >=3D5, it assumes the controller is off and the link is down,
> then it will restore the registers and link.
>
> And the level is changeable via sysfs.

Okay, thanks for clarifying.

>
> > What happens if we power-off anyway when the level is less than 5?
> >
> >> +        * This flag will be passed down to platform power-domain driv=
er
> >> +        * which has the final decision.
> >> +        */
> >> +       if (hba->rpm_lvl < UFS_PM_LVL_5)
> >> +               genpd->flags |=3D GENPD_FLAG_RPM_ALWAYS_ON;
> >> +       else
> >> +               genpd->flags &=3D ~GENPD_FLAG_RPM_ALWAYS_ON;
> >
> > The genpd->flags is not supposed to be changed like this - and
> > especially not from a genpd consumer driver.
> >
> > I am trying to understand a bit more of the use case here. Let's see
> > if that helps me to potentially suggest an alternative approach.
> >
>
> I was not familiar with the genpd part, so I haven't come up with
> another solution. It would be great if you can guide me to the right
> way.

I have been playing with the existing infrastructure we have at hand
to support this, but I need a few more days to be able to propose
something for you.

>
> >> +
> >> +       return ufshcd_runtime_suspend(dev);
> >> +}
> >> +
> >> +static int ufs_rockchip_runtime_resume(struct device *dev)
> >> +{
> >> +       struct ufs_hba *hba =3D dev_get_drvdata(dev);
> >> +       struct ufs_rockchip_host *host =3D ufshcd_get_variant(hba);
> >> +       int err;
> >> +
> >> +       err =3D clk_prepare_enable(host->ref_out_clk);
> >> +       if (err) {
> >> +               dev_err(hba->dev, "failed to enable ref out clock %d\n=
", err);
> >> +               return err;
> >> +       }
> >> +
> >> +       reset_control_assert(host->rst);
> >> +       usleep_range(1, 2);
> >> +       reset_control_deassert(host->rst);
> >> +
> >> +       return ufshcd_runtime_resume(dev);
> >> +}
> >> +
> >> +static int ufs_rockchip_system_suspend(struct device *dev)
> >> +{
> >> +       struct ufs_hba *hba =3D dev_get_drvdata(dev);
> >> +       struct ufs_rockchip_host *host =3D ufshcd_get_variant(hba);
> >> +
> >> +       /* Pass down desired spm_lvl to Firmware */
> >> +       arm_smccc_smc(ROCKCHIP_SIP_SUSPEND_MODE, ROCKCHIP_SLEEP_PD_CON=
FIG,
> >> +                       host->pd_id, hba->spm_lvl < 5 ? 1 : 0, 0, 0, 0=
, 0, NULL);
> >
> > Can you please elaborate on what goes on here? Is this turning off the
> > power-domain that the dev is attached to - or what is actually
> > happening?
> >
>
> This smc call is trying to ask firmware not to turn off the power-domian
> that the UFS is attached to and also not to turn off the power of UFS
> conntroller.

Okay, thanks for clarifying!

A follow up question, don't you need to make a corresponding smc call
to inform the FW that it's okay to turn off the power-domain at some
point?

>
> Per your comment at patch 4, should I use GENPD_FLAG_ALWAYS_ON +
> arm_smccc_smc here in system suspend?
>
> >> +
> >> +       return ufshcd_system_suspend(dev);
> >> +}
> >> +
> >> +static const struct dev_pm_ops ufs_rockchip_pm_ops =3D {
> >> +       SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_system_suspend, ufshcd_sy=
stem_resume)
> >> +       SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_=
runtime_resume, NULL)
> >> +       .prepare         =3D ufshcd_suspend_prepare,
> >> +       .complete        =3D ufshcd_resume_complete,
> >> +};
> >> +
> >> +static struct platform_driver ufs_rockchip_pltform =3D {
> >> +       .probe =3D ufs_rockchip_probe,
> >> +       .remove =3D ufs_rockchip_remove,
> >> +       .driver =3D {
> >> +               .name =3D "ufshcd-rockchip",
> >> +               .pm =3D &ufs_rockchip_pm_ops,
> >> +               .of_match_table =3D ufs_rockchip_of_match,
> >> +       },
> >> +};
> >> +module_platform_driver(ufs_rockchip_pltform);
> >> +
> >
> > [...]

Kind regards
Uffe
