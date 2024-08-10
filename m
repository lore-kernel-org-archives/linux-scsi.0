Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BCD14D71E
	for <linux-scsi@vger.kernel.org>; Sat, 10 Aug 2024 09:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723282107; cv=none; b=Al4cdyJDHwVfCZFJubmWp6Kjur/D7L7IMMNGtLOuztcQroEOzhELZn00bTNz0BFbmU1luWgNcdYzRjeXoltXkbjoUCdFTWg6x6Wr0wZ7suSmXRLA7kzOfWECrzM20o/lig7VaCtgulXh6AZUD/+Ys9cGVSlXg4A/awYM9jWFKXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723282107; c=relaxed/simple;
	bh=GYRfJlzoRsjtp007RotS27ekMFfs/VYre5OmZ1l6ue0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3+mRtwxukJp+d6Gxs+40pcackGFk7XNELSERvErMBWWzOecX3W8io+gc0TsHZOq2oChPiOaj28FjkUAP8y+psvRKJJBH97xuxruK4K3YfBpgGkcYoj1KpgwsVtkweX3suqrxoPj5OXU5ZICuYOFDYoUD/86DvBJR2lhQDTQjq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d0fkYGqE; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d0fkYGqE"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-260f81f7fb5so1736811fac.0
        for <linux-scsi@vger.kernel.org>; Sat, 10 Aug 2024 02:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723282104; x=1723886904; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=POxk62T02uNYfGYqWbrOQkk1jdML19M7AItpdTradPY=;
        b=d0fkYGqERypruMfvMHaFDkb7mutAPkUDjRIEHRI7ZzjCMFVKc1e5LoK5A7UBK8yGBk
         8m2uSn7IcXewS0maWIBRPBFpUSf7qwXbR35eGbkbw/wPUrZpuI1SpWosmtYrhUgd6EBV
         /dcpWAIdks3zNz8K29e70KUh6c7lzS1JqcQLClMko4aLlvRGJPoh9S5wiDqkRejN24Qj
         u9xc41Zn/UkPQNaSHtf8aH4OKAcdX6HL5uvfNhZyqrKI8mWUk7rcz7780hoECR273RK0
         BEUntp6nO/Z47mgW5HcA1Q0MQmPhzKsw5ijQleo21Zy2/AS9LJbTJxAMKeD3BRYck6R2
         ddJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723282104; x=1723886904;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=POxk62T02uNYfGYqWbrOQkk1jdML19M7AItpdTradPY=;
        b=gW72vJepFbs8DsCcWDTHUiUnkG/cksv96XbYcMJVl9AXC4JxdVdu4xxUXjaP9gXO4Y
         c8+7hvdirVdLKyaSd3RfWqDZX91lXtYPx8AC6K3ga1EHBtORED4zOMtm/txtg5OLWQAn
         nWsrl8JbiFTR7jz8mV+IcubWf3hnxeMa6GPze/rwcaMT2aiB/0xMcpVXrJP5xp/6TJLq
         YwXvPzNly7feqdZRGXRtyYUnHAoQrTv1hAb/Ibv722faMIJZqUlvI1qC6fzRtk7Nq9LM
         H3KZOozkJHkfp7bCkQsOJGogdviiKI6qhPD0KK+UnYMMM0dQxeyiR4ie8Y54Vh3Xap9l
         +J/g==
X-Forwarded-Encrypted: i=1; AJvYcCUZ2PnY5gzP0ep8DC4gcjQsDmPneFCqtj4JxdVaapLETtKpHkOtIeft+TmRr/xIzBSIcg/7dWXdWlTc4WvXyl70CuAW1i3KOjg3zg==
X-Gm-Message-State: AOJu0Yzho3Xw+sEiAjFoeiTQdmgT2t19FYo8gCEqcsbV4XdK7JRpPQBP
	drE2dgV1qIs/B8nG6KbwLTI+Fpdpz2viJHy2O8KgbCAMKkzzbtzBiluD/MtK2w==
X-Google-Smtp-Source: AGHT+IGxXpic2tbSmJIvmZMe7QV/huh6dtAslPZVPvo5/1EPsxoFJhDufcj4j0iJA3dkRUA/5lFElA==
X-Received: by 2002:a05:6870:828c:b0:268:a79a:be0d with SMTP id 586e51a60fabf-26c6302463dmr4360557fac.47.1723282104349;
        Sat, 10 Aug 2024 02:28:24 -0700 (PDT)
Received: from thinkpad ([220.158.156.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e58a7b6csm947588b3a.60.2024.08.10.02.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 02:28:23 -0700 (PDT)
Date: Sat, 10 Aug 2024 14:58:17 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/3] scsi: ufs: rockchip: init support for UFS
Message-ID: <20240810092817.GA147655@thinkpad>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
 <20240809062813.GC2826@thinkpad>
 <421d48b7-4aa7-4202-8b5f-9c60916f6ef6@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <421d48b7-4aa7-4202-8b5f-9c60916f6ef6@rock-chips.com>

On Fri, Aug 09, 2024 at 04:16:41PM +0800, Shawn Lin wrote:

[...]

> > > +static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
> > > +					 enum ufs_notify_change_status status)
> > > +{
> > > +	int err = 0;
> > > +
> > > +	if (status == PRE_CHANGE) {
> > > +		int retry_outer = 3;
> > > +		int retry_inner;
> > > +start:
> > > +		if (ufshcd_is_hba_active(hba))
> > > +			/* change controller state to "reset state" */
> > > +			ufshcd_hba_stop(hba);
> > > +
> > > +		/* UniPro link is disabled at this point */
> > > +		ufshcd_set_link_off(hba);
> > > +
> > > +		/* start controller initialization sequence */
> > > +		ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
> > > +
> > > +		usleep_range(100, 200);
> > > +
> > > +		/* wait for the host controller to complete initialization */
> > > +		retry_inner = 50;
> > > +		while (!ufshcd_is_hba_active(hba)) {
> > > +			if (retry_inner) {
> > > +				retry_inner--;
> > > +			} else {
> > > +				dev_err(hba->dev,
> > > +					"Controller enable failed\n");
> > > +				if (retry_outer) {
> > > +					retry_outer--;
> > > +					goto start;
> > > +				}
> > > +				return -EIO;
> > > +			}
> > > +			usleep_range(1000, 1100);
> > > +		}
> > 
> > You just duplicated ufshcd_hba_execute_hce() here. Why? This doesn't make sense.
> 
> Since we set UFSHCI_QUIRK_BROKEN_HCE, and we also need to do someting
> which is very similar to ufshcd_hba_execute_hce(), before calling
> ufshcd_dme_reset(). Similar but not totally the same. I'll try to see if
> we can export ufshcd_hba_execute_hce() to make full use of it.
> 

But you are starting the controller using REG_CONTROLLER_ENABLE. Isn't that
supposed to be broken if you set UFSHCI_QUIRK_BROKEN_HCE? Or I am
misunderstanding the quirk?

> > 
> > > +	} else { /* POST_CHANGE */
> > > +		err = ufshcd_vops_phy_initialization(hba);
> > > +	}
> > > +
> > > +	return err;
> > > +}
> > > +
> > > +static void ufs_rockchip_set_pm_lvl(struct ufs_hba *hba)
> > > +{
> > > +	hba->rpm_lvl = UFS_PM_LVL_1;
> > > +	hba->spm_lvl = UFS_PM_LVL_3;
> > > +}
> > > +
> > > +static int ufs_rockchip_rk3576_phy_init(struct ufs_hba *hba)
> > > +{
> > > +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> > > +
> > > +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(PA_LOCAL_TX_LCC_ENABLE, 0x0), 0x0);
> > > +	/* enable the mphy DME_SET cfg */
> > > +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x200, 0x0), 0x40);
> > > +	for (int i = 0; i < 2; i++) {
> > > +		/* Configuration M-TX */
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xaa, SEL_TX_LANE0 + i), 0x06);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xa9, SEL_TX_LANE0 + i), 0x02);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xad, SEL_TX_LANE0 + i), 0x44);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xac, SEL_TX_LANE0 + i), 0xe6);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xab, SEL_TX_LANE0 + i), 0x07);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x94, SEL_TX_LANE0 + i), 0x93);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x93, SEL_TX_LANE0 + i), 0xc9);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x7f, SEL_TX_LANE0 + i), 0x00);
> > > +		/* Configuration M-RX */
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x12, SEL_RX_LANE0 + i), 0x06);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x11, SEL_RX_LANE0 + i), 0x00);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, SEL_RX_LANE0 + i), 0x58);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, SEL_RX_LANE0 + i), 0x8c);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, SEL_RX_LANE0 + i), 0x02);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, SEL_RX_LANE0 + i), 0xf6);
> > > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, SEL_RX_LANE0 + i), 0x69);
> > > +	}
> > > +	/* disable the mphy DME_SET cfg */
> > > +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x200, 0x0), 0x00);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0x80, 0x08C);
> > > +	ufs_sys_writel(host->mphy_base, 0xB5, 0x110);
> > > +	ufs_sys_writel(host->mphy_base, 0xB5, 0x250);
> > > +
> > 
> > Why can't you do these settings in a PHY driver?
> 
> As we have ->phy_initialization in struct ufs_hba_variant_ops,
> which asks the host driver to use it to initialize phys. It doesn't
> seem to need to create a whole new file to just add some smalls fixed
> parameters. :)
> 

So the PHY doesn't need any resources (clocks, regulators, etc...) other than
programming these sequences? If so, it is fine with me.

> 
> > 
> > > +	ufs_sys_writel(host->mphy_base, 0x03, 0x134);
> > > +	ufs_sys_writel(host->mphy_base, 0x03, 0x274);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0x38, 0x0E0);
> > > +	ufs_sys_writel(host->mphy_base, 0x38, 0x220);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0x50, 0x164);
> > > +	ufs_sys_writel(host->mphy_base, 0x50, 0x2A4);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0x80, 0x178);
> > > +	ufs_sys_writel(host->mphy_base, 0x80, 0x2B8);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0x18, 0x1B0);
> > > +	ufs_sys_writel(host->mphy_base, 0x18, 0x2F0);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0x03, 0x128);
> > > +	ufs_sys_writel(host->mphy_base, 0x03, 0x268);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0x20, 0x12C);
> > > +	ufs_sys_writel(host->mphy_base, 0x20, 0x26C);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0xC0, 0x120);
> > > +	ufs_sys_writel(host->mphy_base, 0xC0, 0x260);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0x03, 0x094);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0x03, 0x1B4);
> > > +	ufs_sys_writel(host->mphy_base, 0x03, 0x2F4);
> > > +
> > > +	ufs_sys_writel(host->mphy_base, 0xC0, 0x08C);
> > > +	udelay(1);
> > > +	ufs_sys_writel(host->mphy_base, 0x00, 0x08C);
> > > +
> > > +	udelay(200);
> > > +	/* start link up */
> > > +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(MIB_T_DBG_CPORT_TX_ENDIAN, 0), 0x0);
> > > +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(MIB_T_DBG_CPORT_RX_ENDIAN, 0), 0x0);
> > > +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
> > > +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID_VALID, 0), 0x1);
> > > +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(T_PEERDEVICEID, 0), 0x1);
> > > +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, 0), 0x1);
> > > +
> > > +	return 0;
> > > +}
> > > +

[...]

> > > +static const struct dev_pm_ops ufs_rockchip_pm_ops = {
> > > +	SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_suspend, ufs_rockchip_resume)
> > > +	SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_runtime_resume, NULL)
> > 
> > Why can't you use ufshcd PM ops as like other vendor drivers?
> 
> It doesn't work from the test. We have many use case to power down the
> controller and device, so there is no flow to recovery the link. Only
> when the first accessing to UFS fails, the ufshcd error handle recovery the
> link. This is not what we expect.
> 

What tests? The existing UFS controller drivers are used in production devices
and they never had a usecase to invent their own PM callbacks. So if your
controller is special, then you need to justify it more elaborately. If
something is missing in ufshcd callbacks, then we can add them.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
