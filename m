Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFE91BE86E
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730732896; cv=none; b=oszFOky+EPgV7mn3HOIwJ+yjowZKJ/r0C08GS9xkE4BEdr+FpQiOwyfwtsZl82m1pDum5HRGlLTxJtzy9EJsi077KV4pz8ETvqDrPPaatXZgo1mHfPN0cCtIxgilWMCMmBQDTd2bZCY4Kntv+93fVE0u99686t9ksHrgeK3j9cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730732896; c=relaxed/simple;
	bh=hI1wQ/fZNIAIQ/ZGwRLRxWBlSdPDkqRQnUGOX3vJ9To=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LPZ7u11gaPQBxEvxguoPmiSywgzvJnDxssHYtFCMtRkBVxdrYXk9yNa1RZpDZE5/+KRDko33EhBdVJSQEFXqRdpScbVEetYpei9udL3nZvA8nsLnNYArDXQIkCDHQ2HLug0BBCy7WoyshFL4/nMZ1Drnt/bIQNpjII0MsDz7KjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kBrrHCBc; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kBrrHCBc"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20caea61132so38313415ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2024 07:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730732894; x=1731337694; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fTaUplHrH7M+dnB2sEL6yj29zt9plqFajNCOZAfkhqU=;
        b=kBrrHCBc8gUd+/hPU4mIMEi8/pxZn5tr1cR8J+h0ZBGbuI5tmjOUQ4zz/Wn3yNsDQ5
         e2w7QYWd8Oen8cr3ZKbS95DeNGEKbYQKKj6jsiPawuW/4IZzxrz0qrUbdJI6HfjgBnQJ
         jny4vL2Fo3Q1UflB2RidWdST/PlWSv7E7LnCuELjwgwYShlKyUDFsggP9Nhunn65GDD1
         /37zwh0FZ4g9VpXwLcCQf+h3uF2vHcbPfxLEEnROa2w6tXtYd5IY1Uz70uV8xRpUmbtv
         9y0oMFrx2ex23lT16/xykJ2AdJaRlQycw0KKuqd9Mg7/FdXsRCbRBAuCIT/4ZN6bWugz
         IjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730732894; x=1731337694;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fTaUplHrH7M+dnB2sEL6yj29zt9plqFajNCOZAfkhqU=;
        b=VopmsmyhqdnIFnlQMQDwL87e5qSXQ1CTFZtNr9Iq8pVBgyt/E6uFXx02uqhYwmHM68
         UXNKf0Q7D3F2ARlArpDLRg1QHXQUk8FPL5W/l5s2Rl03ZJ6269lFoUNlJVu5uRoh+ZPV
         gLqc8sSwJQhreV0xKTfBKo97Ie1O0d5hVoJrcx2gbNc+aV8ewsg08WlJhZ6u1T4Cqf+7
         JGbr/MrJ7mtKvxCHzVxHBalCq3IaOhoDx0EIDhxtS+/P4em7o+8SWh47XEuAtkg6L5Bg
         OWHrZtoUop2n7Ms0uI1LcoyCPIuclAyJ9OxqbU6C89Kwz5PZqWAjSnM1H84MtGCmCwri
         1EEg==
X-Forwarded-Encrypted: i=1; AJvYcCUy2XKznHPOrVxBNu/SkM2afE4rR8QnJopCg+2jELwzHnIErLj1Giz6eZJC29yqBTfO5tgI5wpS+bTR@vger.kernel.org
X-Gm-Message-State: AOJu0YwQa/P75hMbyG34PVKp0IPm8qPFw6IUdHtKXbwEqGDt0UES3CkD
	RRvIFZe5wg0l/hiPu1w96L2ujdkxzeEqoYF6DgwrjbsOIAzSgpt1a7/UR4vs5w==
X-Google-Smtp-Source: AGHT+IHOenWnujTBSBIpKLJWamkVwB46u9SIX/kMarM+ODiUVeqEfeHc6c4RexMW87XtzdjqQNduWA==
X-Received: by 2002:a17:902:eccd:b0:20b:59be:77b with SMTP id d9443c01a7336-2111aec8329mr165149345ad.6.1730732893820;
        Mon, 04 Nov 2024 07:08:13 -0800 (PST)
Received: from thinkpad ([2409:40f4:3049:1cc7:217b:63a:40ce:2e01])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057a6815sm62677185ad.135.2024.11.04.07.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 07:08:13 -0800 (PST)
Date: Mon, 4 Nov 2024 20:38:05 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Shawn Lin <shawn.lin@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] scsi: ufs: rockchip: initial support for UFS
Message-ID: <20241104150805.q7g3bfvbsdx3b6u4@thinkpad>
References: <1728368130-37213-1-git-send-email-shawn.lin@rock-chips.com>
 <1728368130-37213-6-git-send-email-shawn.lin@rock-chips.com>
 <CAPDyKForpLcmkqruuTfD6kkJhp_4CKFABWRxFVYNskGL1tjO=w@mail.gmail.com>
 <3969bae0-eeb8-447a-86a5-dfdac0b136cd@rock-chips.com>
 <CAPDyKFo=GcHG2sGQBrXJ7VWyp59QOmbLCAvHQ3krUympEkid_A@mail.gmail.com>
 <98e0062c-aeb1-4bea-aa2b-4a99115c9da4@rock-chips.com>
 <20241103120223.abkwgej4svas4epr@thinkpad>
 <6f3f2d17-4ca2-44ad-b8df-72986d4b3174@rock-chips.com>
 <CAPDyKFqMuFMf0+2+mPZaGGtBRfavg0LTkhbrCeqh7kHeqq-yZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFqMuFMf0+2+mPZaGGtBRfavg0LTkhbrCeqh7kHeqq-yZQ@mail.gmail.com>

On Mon, Nov 04, 2024 at 10:51:45AM +0100, Ulf Hansson wrote:
> On Mon, 4 Nov 2024 at 07:38, Shawn Lin <shawn.lin@rock-chips.com> wrote:
> >
> > 在 2024/11/3 20:02, Manivannan Sadhasivam 写道:
> > > On Fri, Oct 18, 2024 at 05:20:08PM +0800, Shawn Lin wrote:
> > >> Hi Ulf,
> > >>
> > >> 在 2024/10/18 17:07, Ulf Hansson 写道:
> > >>> On Thu, 10 Oct 2024 at 03:21, Shawn Lin <shawn.lin@rock-chips.com> wrote:
> > >>>>
> > >>>> Hi Ulf
> > >>>>
> > >>>> 在 2024/10/9 21:15, Ulf Hansson 写道:
> > >>>>> [...]
> > >>>>>
> > >>>>>> +
> > >>>>>> +static int ufs_rockchip_runtime_suspend(struct device *dev)
> > >>>>>> +{
> > >>>>>> +       struct ufs_hba *hba = dev_get_drvdata(dev);
> > >>>>>> +       struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> > >>>>>> +       struct generic_pm_domain *genpd = pd_to_genpd(dev->pm_domain);
> > >>>>>
> > >>>>> pd_to_genpd() isn't safe to use like this. It's solely to be used by
> > >>>>> genpd provider drivers.
> > >>>>>
> > >>>>>> +
> > >>>>>> +       clk_disable_unprepare(host->ref_out_clk);
> > >>>>>> +
> > >>>>>> +       /*
> > >>>>>> +        * Shouldn't power down if rpm_lvl is less than level 5.
> > >>>>>
> > >>>>> Can you elaborate on why we must not power-off the power-domain when
> > >>>>> level is less than 5?
> > >>>>>
> > >>>>
> > >>>> Because ufshcd driver assume the controller is active and the link is on
> > >>>> if level is less than 5. So the default resume policy will not try to
> > >>>> recover the registers until the first error happened. Otherwise if the
> > >>>> level is >=5, it assumes the controller is off and the link is down,
> > >>>> then it will restore the registers and link.
> > >>>>
> > >>>> And the level is changeable via sysfs.
> > >>>
> > >>> Okay, thanks for clarifying.
> > >>>
> > >>>>
> > >>>>> What happens if we power-off anyway when the level is less than 5?
> > >>>>>
> > >>>>>> +        * This flag will be passed down to platform power-domain driver
> > >>>>>> +        * which has the final decision.
> > >>>>>> +        */
> > >>>>>> +       if (hba->rpm_lvl < UFS_PM_LVL_5)
> > >>>>>> +               genpd->flags |= GENPD_FLAG_RPM_ALWAYS_ON;
> > >>>>>> +       else
> > >>>>>> +               genpd->flags &= ~GENPD_FLAG_RPM_ALWAYS_ON;
> > >>>>>
> > >>>>> The genpd->flags is not supposed to be changed like this - and
> > >>>>> especially not from a genpd consumer driver.
> > >>>>>
> > >>>>> I am trying to understand a bit more of the use case here. Let's see
> > >>>>> if that helps me to potentially suggest an alternative approach.
> > >>>>>
> > >>>>
> > >>>> I was not familiar with the genpd part, so I haven't come up with
> > >>>> another solution. It would be great if you can guide me to the right
> > >>>> way.
> > >>>
> > >>> I have been playing with the existing infrastructure we have at hand
> > >>> to support this, but I need a few more days to be able to propose
> > >>> something for you.
> > >>>
> > >>
> > >> Much appreciate.
> > >>
> > >>>>
> > >>>>>> +
> > >>>>>> +       return ufshcd_runtime_suspend(dev);
> > >>>>>> +}
> > >>>>>> +
> > >>>>>> +static int ufs_rockchip_runtime_resume(struct device *dev)
> > >>>>>> +{
> > >>>>>> +       struct ufs_hba *hba = dev_get_drvdata(dev);
> > >>>>>> +       struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> > >>>>>> +       int err;
> > >>>>>> +
> > >>>>>> +       err = clk_prepare_enable(host->ref_out_clk);
> > >>>>>> +       if (err) {
> > >>>>>> +               dev_err(hba->dev, "failed to enable ref out clock %d\n", err);
> > >>>>>> +               return err;
> > >>>>>> +       }
> > >>>>>> +
> > >>>>>> +       reset_control_assert(host->rst);
> > >>>>>> +       usleep_range(1, 2);
> > >>>>>> +       reset_control_deassert(host->rst);
> > >>>>>> +
> > >>>>>> +       return ufshcd_runtime_resume(dev);
> > >>>>>> +}
> > >>>>>> +
> > >>>>>> +static int ufs_rockchip_system_suspend(struct device *dev)
> > >>>>>> +{
> > >>>>>> +       struct ufs_hba *hba = dev_get_drvdata(dev);
> > >>>>>> +       struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> > >>>>>> +
> > >>>>>> +       /* Pass down desired spm_lvl to Firmware */
> > >>>>>> +       arm_smccc_smc(ROCKCHIP_SIP_SUSPEND_MODE, ROCKCHIP_SLEEP_PD_CONFIG,
> > >>>>>> +                       host->pd_id, hba->spm_lvl < 5 ? 1 : 0, 0, 0, 0, 0, NULL);
> > >>>>>
> > >>>>> Can you please elaborate on what goes on here? Is this turning off the
> > >>>>> power-domain that the dev is attached to - or what is actually
> > >>>>> happening?
> > >>>>>
> > >>>>
> > >>>> This smc call is trying to ask firmware not to turn off the power-domian
> > >>>> that the UFS is attached to and also not to turn off the power of UFS
> > >>>> conntroller.
> > >>>
> > >>> Okay, thanks for clarifying!
> > >>>
> > >>> A follow up question, don't you need to make a corresponding smc call
> > >>> to inform the FW that it's okay to turn off the power-domain at some
> > >>> point?
> > >>>
> > >>
> > >> Yes. Each time entering sleep, we teach FW if it need to turn off or keep
> > >> power-domain, for instance "hba->spm_lvl < 5 ? 1 : 0" , 0 means
> > >> off and 1 means on.
> > >>
> > >
> > > We had a requirement to notify the genpd provider from consumer to not turn off
> > > the power domain during system suspend. So Ulf came up with an API for
> > > consumers, device_set_wakeup_path() setting the 'dev->power.wakeup_path' which
> > > will be honored by the genpd core. Will that work for you?
> >
> > Yes, that works. And we may need a symmetrical call, for instance,
> > device_clr_wakeup_path() to allow genpd provider to turn off the power
> > domain as well.
> 
> The PM core clears the flag in device_prepare(). The flag is typically
> supposed to be set from a ->suspend() callback, so there should be no
> need for an additional function that clears the flag, I think.
> 

Yeah, that's my understanding as well though I didn't look into PM core deeply.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
