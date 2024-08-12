Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E484D80C
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2024 04:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723435861; cv=none; b=kEj/ocdY49lvtYiXG/R9OJlKpdya7vBFnMS1YjUggC+EFW+wMRIGYItMJBxNTD+WWJLxCJVgJOmUGK06sWFnomP65cMIZyHKfKWVBjTZxzpSZokq79e0qinRJCctQ19IWbJPSptAKedERNNmf7Tsblprk2sUoogY4cQjRNF4Vm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723435861; c=relaxed/simple;
	bh=qI0bs6rd2DWmdF9ALWTxV+cS9DABMRZx8vBKeOZ3TXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxejAsoEPU2Be5TBvGzw92bSJssOUC4Pdqzbivhp2AjKfBqtDcQn6COv5+AJLXLWF3ENxojg2hERMCTAEwKlc+h4P31tiohZjGLfnsDhrlkDAQEaa/qIGrExXsEFSUZ/kPBmI+u2SPh6G0UJsEAs65zht15CBezgYH9E5lE8sro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kIYaV8iV; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kIYaV8iV"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2cd48ad7f0dso3096457a91.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Aug 2024 21:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723435859; x=1724040659; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KLJJ6so+orZFZFeMUnbOliXPJiE9AqEdrrJRM5sonro=;
        b=kIYaV8iVnycVfKVHutt7KSA9HByAdFSNz61yjx17YsTPOtXe9MP9VTgOBE28sudda7
         g7ROzEFymlj64A4WKR4ODapcn1NaY/4EEcYOCP5Mb9mncgh0agMFK+j4c8qJ2h+5P+mU
         e25ho+JnJmhjoWcvtB7aGugGvedifgjUihTHyiCLqpaQbEeictqFBbiywVCwT80vQMvl
         qg/SwKy4PiphBXMezDQ3nnSSonP7DrCKBNps+LkGmrISGaIMfeTVmvSDVaOQvcDMjK2G
         Kc8+sOgIGNacm8IAKzTpXkPjTI3y57Qzbxau0KUq5ClT7VzPc9LkKG0ZWJFWKxNKXe6n
         lD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723435859; x=1724040659;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KLJJ6so+orZFZFeMUnbOliXPJiE9AqEdrrJRM5sonro=;
        b=jiVXZN5/m71ApwlzOzH98b1oJjJPdWgQH+ZoUVpw023cLjRNFPsEM2qz/DIkDLPCmy
         ixE8EapRs4UKgzziW63nbNDMO63CQRg75hn/X0H7zFwOsmWzuTbz6ez9zZxlNpCOZXM4
         YCh0W7i9En1Gs5DcTNx6gnwiW4PNmme3OI9Vl9s2No1IFgQN8wqzMPxOLa6dQ1W9UdJL
         swCLVdWa68RzM6eb99/mgxL1HyAjHnXAWCl7cWsTRK2faOnGMDdG/KyTFY6xFifMk4Mn
         MV9klf8hXgD19H6fHC6LRa8118zWyU0IWO8JUWqvwSbTtOPqeYqLGzinWRU/k86U37aY
         pslg==
X-Forwarded-Encrypted: i=1; AJvYcCWCElZu6Ja1Fhs+AtwP+oelVFJL8ZH+tNmdQyO0dQCc5bs6ajit2vjfV/Nh0zX6N870FLdCOwKpNzYG3/3jWDz3uwS4y/76QqshgQ==
X-Gm-Message-State: AOJu0YwtSb179n72R8IasYxxCXkDr9YzsLD1yGfLoOFZyHWVuVzMSN/3
	V3T309mBUbjL6GqY2OnR+k3uRWXcy9wVq/GzgB2o17Mp7lvTNq6q/9vqrpSZEw==
X-Google-Smtp-Source: AGHT+IEPC81vW4x96+SZLSLCOeIPTkSbgIYh0EjJcUYkF2idbeM+Vokc34tM9BlI6w/m1L1UpjIOOA==
X-Received: by 2002:a17:90b:4a81:b0:2c2:f2d6:60d4 with SMTP id 98e67ed59e1d1-2d1e7f96d11mr9474880a91.8.1723435859038;
        Sun, 11 Aug 2024 21:10:59 -0700 (PDT)
Received: from thinkpad ([103.244.168.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1c9c82b6asm7130528a91.16.2024.08.11.21.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 21:10:58 -0700 (PDT)
Date: Mon, 12 Aug 2024 09:40:51 +0530
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
Message-ID: <20240812041051.GA2861@thinkpad>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
 <20240809062813.GC2826@thinkpad>
 <421d48b7-4aa7-4202-8b5f-9c60916f6ef6@rock-chips.com>
 <20240810092817.GA147655@thinkpad>
 <3b2617f5-acb1-45c6-993c-33249fd19888@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b2617f5-acb1-45c6-993c-33249fd19888@rock-chips.com>

On Mon, Aug 12, 2024 at 09:28:26AM +0800, Shawn Lin wrote:
> JHi Mani,
> 
> 在 2024/8/10 17:28, Manivannan Sadhasivam 写道:
> > On Fri, Aug 09, 2024 at 04:16:41PM +0800, Shawn Lin wrote:
> > 
> > [...]
> > 
> > > > > +static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
> > > > > +					 enum ufs_notify_change_status status)
> > > > > +{
> > > > > +	int err = 0;
> > > > > +
> > > > > +	if (status == PRE_CHANGE) {
> > > > > +		int retry_outer = 3;
> > > > > +		int retry_inner;
> > > > > +start:
> > > > > +		if (ufshcd_is_hba_active(hba))
> > > > > +			/* change controller state to "reset state" */
> > > > > +			ufshcd_hba_stop(hba);
> > > > > +
> > > > > +		/* UniPro link is disabled at this point */
> > > > > +		ufshcd_set_link_off(hba);
> > > > > +
> > > > > +		/* start controller initialization sequence */
> > > > > +		ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
> > > > > +
> > > > > +		usleep_range(100, 200);
> > > > > +
> > > > > +		/* wait for the host controller to complete initialization */
> > > > > +		retry_inner = 50;
> > > > > +		while (!ufshcd_is_hba_active(hba)) {
> > > > > +			if (retry_inner) {
> > > > > +				retry_inner--;
> > > > > +			} else {
> > > > > +				dev_err(hba->dev,
> > > > > +					"Controller enable failed\n");
> > > > > +				if (retry_outer) {
> > > > > +					retry_outer--;
> > > > > +					goto start;
> > > > > +				}
> > > > > +				return -EIO;
> > > > > +			}
> > > > > +			usleep_range(1000, 1100);
> > > > > +		}
> > > > 
> > > > You just duplicated ufshcd_hba_execute_hce() here. Why? This doesn't make sense.
> > > 
> > > Since we set UFSHCI_QUIRK_BROKEN_HCE, and we also need to do someting
> > > which is very similar to ufshcd_hba_execute_hce(), before calling
> > > ufshcd_dme_reset(). Similar but not totally the same. I'll try to see if
> > > we can export ufshcd_hba_execute_hce() to make full use of it.
> > > 
> > 
> > But you are starting the controller using REG_CONTROLLER_ENABLE. Isn't that
> > supposed to be broken if you set UFSHCI_QUIRK_BROKEN_HCE? Or I am
> > misunderstanding the quirk?
> > 
> 
> Our controller doesn't work with exiting code, whether setting
> UFSHCI_QUIRK_BROKEN_HCE or not.
> 

Okay. Then this means you do not need this quirk at all.

> 
> For UFSHCI_QUIRK_BROKEN_HCE case, it calls ufshcd_dme_reset（）first,
> but we need to set REG_CONTROLLER_ENABLE first.
> 
> For !UFSHCI_QUIRK_BROKEN_HCE case, namly ufshcd_hba_execute_hce, it
> sets REG_CONTROLLER_ENABLE  first but never send DMA_RESET and calls
> ufshcd_dme_enable.
> 

I don't see where ufshcd_dme_enable() is getting called for
!UFSHCI_QUIRK_BROKEN_HCE case.

> So the closet code path is to go through UFSHCI_QUIRK_BROKEN_HCE case,
> and set REG_CONTROLLER_ENABLE by adding hce_enable_notify hook.
> 

No, that is abusing the quirk. But I'm confused about why your controller wants
resetting the unipro stack _after_ enabling the controller? Why can't it be
reset before?

> > > > 
> > > > > +	} else { /* POST_CHANGE */
> > > > > +		err = ufshcd_vops_phy_initialization(hba);
> > > > > +	}
> > > > > +
> > > > > +	return err;
> > > > > +}
> > > > > +

[...]

> > > > > +static const struct dev_pm_ops ufs_rockchip_pm_ops = {
> > > > > +	SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_suspend, ufs_rockchip_resume)
> > > > > +	SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_runtime_resume, NULL)
> > > > 
> > > > Why can't you use ufshcd PM ops as like other vendor drivers?
> > > 
> > > It doesn't work from the test. We have many use case to power down the
> > > controller and device, so there is no flow to recovery the link. Only
> > > when the first accessing to UFS fails, the ufshcd error handle recovery the
> > > link. This is not what we expect.
> > > 
> > 
> > What tests? The existing UFS controller drivers are used in production devices
> > and they never had a usecase to invent their own PM callbacks. So if your
> > controller is special, then you need to justify it more elaborately. If
> > something is missing in ufshcd callbacks, then we can add them.
> > 
> 
> All the register got lost each time as we power down both controller & PHY
> and devices in suspend.

Which suspend? runtime or system suspend? I believe system suspend.

> So we have to restore the necessary
> registers and link. I didn't see where the code recovery the controller
> settings in ufshcd_resume, except ufshcd_err_handler（）triggers that.
> Am I missing any thing? 

Can you explain what is causing the powerdown of the controller and PHY?
Because, ufshcd_suspend() just turns off the clocks and regulators (if
UFSHCD_CAP_AGGR_POWER_COLLAPSE is set) and spm_lvl 3 set by this driver only
puts the device in sleep mode and link in hibern8 state.

- Mani

> Below is the dump we get if using
> SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume).
> It can work as ufshcd_err_handler () will fix the link, but we have to
> suffer from getting the error log each time. Moreover, we need to gate
> 26MHz refclk for device when RPM is called. So our own rpm callback is
> needed.
> 
> [   14.318444] <<GTP-INF>>[gt1x_wakeup_sleep:964] Wakeup by poweron
> [   14.439723] ufshcd-rockchip 2a2d0000.ufs: Controller not ready to accept
> UIC commands
> [   14.439730] ufshcd-rockchip 2a2d0000.ufs: pwr ctrl cmd 0x18 with mode 0x0
> uic error -5
> [   14.439736] ufshcd-rockchip 2a2d0000.ufs: UFS Host state=1
> [   14.439740] ufshcd-rockchip 2a2d0000.ufs: outstanding reqs=0x0 tasks=0x0
> [   14.439744] ufshcd-rockchip 2a2d0000.ufs: saved_err=0x0,
> saved_uic_err=0x0
> [   14.439748] ufshcd-rockchip 2a2d0000.ufs: Device power mode=2, UIC link
> state=2
> [   14.439753] ufshcd-rockchip 2a2d0000.ufs: PM in progress=1, sys.
> suspended=1
> [   14.439758] ufshcd-rockchip 2a2d0000.ufs: Auto BKOPS=0, Host self-block=0
> [   14.439762] ufshcd-rockchip 2a2d0000.ufs: Clk gate=1
> [   14.439766] ufshcd-rockchip 2a2d0000.ufs: last_hibern8_exit_tstamp at 0
> us, hibern8_exit_cnt=0
> [   14.439770] ufshcd-rockchip 2a2d0000.ufs: last intr at 10807625 us, last
> intr status=0x440
> [   14.439775] ufshcd-rockchip 2a2d0000.ufs: error handling flags=0x0, req.
> abort count=0
> [   14.439779] ufshcd-rockchip 2a2d0000.ufs: hba->ufs_version=0x200, Host
> capabilities=0x187011f, caps=0x48c
> [   14.439785] ufshcd-rockchip 2a2d0000.ufs: quirks=0x2100, dev. quirks=0xc4
> [   14.439790] ufshcd-rockchip 2a2d0000.ufs: UFS dev info: SAMSUNG
> KLUDG2R1DE-B0F1  rev 0100
> [   14.439796] ufshcd-rockchip 2a2d0000.ufs: clk: core, rate: 50000000
> [   14.439822] host_regs: 00000000: 0187011f 00000000 00000200 00000000
> [   14.439827] host_regs: 00000010: 00000000 000005e6 00000000 00000000
> [   14.439831] host_regs: 00000020: 00000000 00000000 00000000 00000000
> [   14.439835] host_regs: 00000030: 00000000 00000000 00000000 00000000
> [   14.439839] host_regs: 00000040: 00000000 00000000 00000000 00000000
> [   14.439843] host_regs: 00000050: 00000000 00000000 00000000 00000000
> [   14.439847] host_regs: 00000060: 00000000 00000000 00000000 00000000
> [   14.439851] host_regs: 00000070: 00000000 00000000 00000000 00000000
> [   14.439855] host_regs: 00000080: 00000000 00000000 00000000 00000000
> [   14.439859] host_regs: 00000090: 00000000 00000000 00000000 00000000
> [   14.439863] ufshcd-rockchip 2a2d0000.ufs: No record of pa_err
> [   14.439867] ufshcd-rockchip 2a2d0000.ufs: No record of dl_err
> [   14.439871] ufshcd-rockchip 2a2d0000.ufs: No record of nl_err
> [   14.439876] ufshcd-rockchip 2a2d0000.ufs: No record of tl_err
> [   14.439880] ufshcd-rockchip 2a2d0000.ufs: No record of dme_err
> [   14.439884] ufshcd-rockchip 2a2d0000.ufs: No record of auto_hibern8_err
> [   14.439888] ufshcd-rockchip 2a2d0000.ufs: No record of fatal_err
> [   14.439892] ufshcd-rockchip 2a2d0000.ufs: No record of link_startup_fail
> [   14.439896] ufshcd-rockchip 2a2d0000.ufs: No record of resume_fail
> [   14.439900] ufshcd-rockchip 2a2d0000.ufs: No record of suspend_fail
> [   14.439905] ufshcd-rockchip 2a2d0000.ufs: dev_reset[0] = 0x0 at 1418763
> us
> [   14.439910] ufshcd-rockchip 2a2d0000.ufs: dev_reset: total cnt=1
> [   14.439914] ufshcd-rockchip 2a2d0000.ufs: No record of host_reset
> [   14.439918] ufshcd-rockchip 2a2d0000.ufs: No record of task_abort
> [   14.439930] ufshcd-rockchip 2a2d0000.ufs: ufshcd_uic_hibern8_exit:
> hibern8 exit failed. ret = -5
> [   14.439935] ufshcd-rockchip 2a2d0000.ufs: __ufshcd_wl_resume: hibern8
> exit failed -5
> [   14.439944] ufs_device_wlun 0:0:0:49488: ufshcd_wl_resume failed: -5
> [   14.439950] ufs_device_wlun 0:0:0:49488: PM: dpm_run_callback():
> scsi_bus_resume+0x0/0xa8 returns -5
> [   14.440003] ufshcd-rockchip 2a2d0000.ufs: ufshcd_err_handler started; HBA
> state eh_fatal; powered 1; shutting down 0; saved_err = 0; saved_uic_err =
> 0; force_reset = 0; link is broken
> [   14.440017] ufs_device_wlun 0:0:0:49488: PM: failed to resume async:
> error -5
> 
> > - Mani
> > 

-- 
மணிவண்ணன் சதாசிவம்
