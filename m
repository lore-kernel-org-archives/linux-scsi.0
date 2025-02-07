Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6341DE3C8
	for <linux-scsi@vger.kernel.org>; Fri,  7 Feb 2025 10:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738922999; cv=none; b=Hr6TRYQNt5tiS5ye8hoeYKM+4qQcCuBt/4XokFREnQwxarljOAE4lt5sAGOZF2FZpwjYHeHdQFHtsWP1LNpb8wZtQoE6qFPB0nqfEq6P3RteAsadGJCTFi3ZrqaQlTkZBU/FhzfSiVs3g0v8QX6xyQISUjvaWUwmAdkNaNupZFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738922999; c=relaxed/simple;
	bh=fozwRqctrOxLpSdO3MevSvRd0gXJ8hjbI9tSkvTXnUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=opGSGXCNNKMrB078eZerzFWY2trL2moQApZCj+WNxW8NvajAsg1t1WqjhRevnu0OGKlwI8m3G1zdK3vWkKmBE/wy58SlZmj2F9bgudRPVud/Q8PlC4dz2QQKiw0On43tfR/nM2yNBzFS2avZkhS3b/JZjCaKLPX3Zxi8KMweLdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UgdOYb+f; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UgdOYb+f"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e5b16621c28so1499181276.2
        for <linux-scsi@vger.kernel.org>; Fri, 07 Feb 2025 02:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738922997; x=1739527797; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aMlnBxSr88oKxJqvSdzTpvP2j51w5II8vu4/hm//nuA=;
        b=UgdOYb+fenojnKOhxNJTz2QVnJ1FnCk5Q/GCA8INtVsJi4YQZ3IlwR7Wd3x/ROOdaV
         RPy6SQ8pvMyQSD6/CiK20h4jWfOlfsGwD8/CODs6ZsXjnSZkl3TnGLu68IhLqIlmNSSX
         /q82AfXS1GTT7uYbwLQVY3lZjn34LHxYny1R4c6LsQD60+FQxOB1TQ+Wuyq6iuz8lxF6
         q9ga2WPBiIlf6Kohstxb5CeOCXeX2RfCIWGBVQwrcuGMqZ/uLlU/SpvSQpbYByCzyumQ
         Nfl3RD0FkJDrwi9kRTNFMIDI1CLDg85foG8Dr5YTQBBTD3YNMHbR2TvdAgxjDfKhg7pK
         8FJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738922997; x=1739527797;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aMlnBxSr88oKxJqvSdzTpvP2j51w5II8vu4/hm//nuA=;
        b=m0DTyKKftdIq3FX/KM1JSWXwYuCtDhP7nAx9bJnyyxvofTdziM/q5tVtQubwJj9BFt
         bJzzcoCmUYsczFC4VAP+cehg1S/Jf5tOmkCLY9k/teLJcEGQvggnMAK4Bk0l6u7ZU4Ec
         AkmI8KpxKx7GPEC3WiwB0UsvNsLC32tz4g/n4XltG/aAgk4stlnPiHLe9h1KCW+ac/sP
         6s3OnAMYlJCz2RCHWI/357h1g16qXRoaGYR6qwakTV9FEB57lu1WHpV7y0G3PrmVLLUi
         QD6jQ2/gLejTKii+d43tspl1n6ksibu7DyS3TPHwmc2s03wAgyKDxfpMYtZzrJGfM5l8
         kpYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkuAIj/kzgpMv3NbPh9w8AVQeGyRPqHFf/NOYWCfGja+Y5IoK8FAmGZNZY4P/LQtsIWx3W9dWWc8fK@vger.kernel.org
X-Gm-Message-State: AOJu0YzdR1zQTqdl71ChauCBIGcAwLFo3qRVgBegzTDkuq7VF4iGMm2k
	sjXf5M8IpxNvYUEyBXBsh8Zh+bzAo4pmJQlCzYS5RbPakomioRp+F3wuqtMpV8CiVvrgdolZ9g+
	rMNTRyncODr48AnJgEw7hxmTB+l24JLeiZ9WPwg==
X-Gm-Gg: ASbGncvz08fa7EejLhO4q6LG1VJYTAVZ9mLBJbv85ioxC/EF47UVA8GNVhnZmSdg+5k
	TeNhiZhC+SmAYpRKEoBOeGCMlAhElOjCoyDQN6BgmyKJqsnMySgVVW8Hrma4Qw5N6VZFh/B0Gyg
	==
X-Google-Smtp-Source: AGHT+IHoiInh1hUMnE6qERiHNS3cS8CKAY9eNIzyp9FkL/HZJzjp42lBKNL5doKpGdV1ysL98ISo0TrNPBDVJXuqONw=
X-Received: by 2002:a05:6902:1147:b0:e5b:44a6:6a49 with SMTP id
 3f1490d57ef6-e5b461e3b73mr2069997276.27.1738922996853; Fri, 07 Feb 2025
 02:09:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1738736156-119203-1-git-send-email-shawn.lin@rock-chips.com> <1738736156-119203-7-git-send-email-shawn.lin@rock-chips.com>
In-Reply-To: <1738736156-119203-7-git-send-email-shawn.lin@rock-chips.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 7 Feb 2025 11:09:20 +0100
X-Gm-Features: AWEUYZlh5I7dXTfcGIsd-Bb5BhscOMYbYEdqLf2ekINZFP8SE-lE7AuxpmHbrEo
Message-ID: <CAPDyKFpzfyacXidTwU1ec9L4058k3Mrx43MS0JTnukgwqci6BA@mail.gmail.com>
Subject: Re: [PATCH v7 6/7] scsi: ufs: rockchip: initial support for UFS
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>, linux-scsi@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Feb 2025 at 07:18, Shawn Lin <shawn.lin@rock-chips.com> wrote:
>
> RK3576 SoC contains a UFS controller, add initial support for it.
> The features are:
> (1) support UFS 2.0 features
> (2) High speed up to HS-G3
> (3) 2RX-2TX lanes
> (4) auto H8 entry and exit
>
> Software limitation:
> (1) HCE procedure: enable controller->enable intr->dme_reset->dme_enable
> (2) disable unipro timeout values before power mode change
>
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>

One minor comment, see below. Nevertheless, feel free to add:

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

[...]

> +#ifdef CONFIG_PM_SLEEP
> +static int ufs_rockchip_system_suspend(struct device *dev)
> +{
> +       struct ufs_hba *hba = dev_get_drvdata(dev);
> +       struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +       int err;
> +

The below code seems to require that the device is runtime resumed.
Maybe that is guaranteed by the upper UFS layer, I don't know. If not,
we need a pm_runtime_get_sync() here - and thus a corresponding
pm_runtime_put_noidle() in ufs_rockchip_system_resume().

> +       /*
> +        * If spm_lvl is less than level 5, it means we need to keep the host
> +        * controller in powered-on state. So device_set_awake_path() is
> +        * calling pm core to notify the genpd provider to meet this requirement
> +        */
> +       if (hba->spm_lvl < UFS_PM_LVL_5)
> +               device_set_awake_path(dev);
> +
> +       err = ufshcd_system_suspend(dev);
> +       if (err) {
> +               dev_err(hba->dev, "UFSHCD system susped failed %d\n", err);
> +               return err;
> +       }
> +
> +       clk_disable_unprepare(host->ref_out_clk);
> +
> +       return 0;
> +}
> +
> +static int ufs_rockchip_system_resume(struct device *dev)
> +{
> +       struct ufs_hba *hba = dev_get_drvdata(dev);
> +       struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +       int err;
> +
> +       err = clk_prepare_enable(host->ref_out_clk);
> +       if (err) {
> +               dev_err(hba->dev, "failed to enable ref_out clock %d\n", err);
> +               return err;
> +       }
> +
> +       return ufshcd_system_resume(dev);
> +}
> +#endif
> +
> +static const struct dev_pm_ops ufs_rockchip_pm_ops = {
> +       SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_system_suspend, ufs_rockchip_system_resume)
> +       SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_runtime_resume, NULL)
> +       .prepare         = ufshcd_suspend_prepare,
> +       .complete        = ufshcd_resume_complete,
> +};
> +

[...]

Kind regards
Uffe
