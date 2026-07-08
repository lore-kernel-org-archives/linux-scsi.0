Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20E53E92B9;
	Wed,  8 Jul 2026 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783494670; cv=none; b=kS48VESEXoj0Kq6sxafEhTDHtT2A0Kzt5wPwtGCun5eJfGIA/+NASKzeuUn1OXjZ6YE/QtM3oJuyyUAMdvkV9kPuNtorRczjSo4ewCJI/0hE9t33O/hwVPa43TbizLDyl6YBF+0i0vJSBIVnf9nzLv7iGjvA8wEsnLv9Fk9UzVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783494670; c=relaxed/simple;
	bh=EO8rwZ36YeyLT/sXpw4ATKnuSIm/oXL7+9lYYgob4Rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CcoWOTgQlAN/JvJEZ1OL0YvmBAhkYIe8zDFNR1629hKlL70cDiAKg+KIAc64Q7EpS4jOwv6abkD0wFzJYDwkwg2j0bzd4JOPZN80WdZur1UdB0Ey/FmsAngcapuw2qznUMBIxeQXOxqQ6/rnJzpHCnnFbtFCjzF7Fdt0wxt5qME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+Cp9KOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+Cp9KOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927AE1F000E9;
	Wed,  8 Jul 2026 07:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783494655;
	bh=9lFckwIb4MzKsBiFEkNV2g14zZYu8DPrganDJnFIB54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f+Cp9KODOsntNhrZioFLgu6XB/1aYTT3+tkAtYydVccet0AkopOetcASLqj2E2aLz
	 +q3XG51TaNoalrrULQrWDR2Q7ZG6M4Es7o8dw18Z59NgGLqldEwNcr5PSUVfPY6yi0
	 TZG4nGmsxX4Uau/OsArg0PGCgOTIfI51ZwM9UV4JShInWRzZqBrp8e2TVK3ntKCIJC
	 OSShf7ckqXLuvd485rzh8ozEHoo0YJ6BkHpV5ySMisWkOl01+LILPYLHKEQhKj48D/
	 yYqc9RXX3veVxNC0Nhr63yr9Y/R+F3czrNPmnrwTjE8+0lhh7Q7ggTRmYdFAFuC9Jn
	 1ll3nkp0Dshrw==
Date: Wed, 8 Jul 2026 07:10:51 +0000
From: Yixun Lan <dlan@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20260708071051-GKJ35811@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
 <f46d7520-bc2e-49f7-9049-ecdba2837b5d@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f46d7520-bc2e-49f7-9049-ecdba2837b5d@acm.org>

Hi Bart,

On 07:01 Mon 06 Jul     , Bart Van Assche wrote:
> 
> On 7/1/26 7:31 PM, Yixun Lan wrote:
> > +config SCSI_UFS_SPACEMIT
> > +	tristate "SpacemiT UFS controller driver"
> > +	depends on SCSI_UFSHCD_PLATFORM && ARCH_SPACEMIT
> 
> What would break if ARCH_SPACEMIT is left out?
> 
Should be fine, I see no hard build dependency

> Please make sure that this driver can be compile-tested easily.
> 
I could make it "SCSI_UFSHCD_PLATFORM && (ARCH_SPACEMIT || COMPILE_TEST)"

> > +	u32 host_reg[] = {
> > +		(UFS_PHY_MNG_BASE + UFS_MPHY_RST_CTRL),
> > +		(UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL),
> > +		(UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL),
> > +		0xFFF,
> > +	};
> 
> Can this array be declared 'static const'?
> 
Yes, sure

> The parentheses in the above array definition are superfluous.
> Please remove these.
> 
Ok, will do

> > +	buf = kzalloc(VENDOR_DUMP_BUF_SIZE, GFP_ATOMIC);
> 
> Why GFP_ATOMIC? ufs_spacemit_dump_host_regs() is never called from
> atomic context, isn't it?
> 
No, it will be called from interrupt context

devm_request_threaded_irq(dev, irq, ufshcd_intr, ufshcd_threaded_intr,..)
ufshcd_intr() 
    ufshcd_sl_intr()
         ufshcd_check_errors() 
            ufshcd_update_evt_hist
                 ufshcd_vops_event_notify()
                       ufs_spacemit_event_notify

but I will see if able to move this function to .dbg_register_dump() and
redesign it with ufshcd_dump_regs(), or simply drop it from this version,
 and implement it as a separate patch in future.

P.S, checked ufshcd_dump_regs() also use GFP_ATOMIC for memory allocation,
see drivers/ufs/core/ufshcd.c:174

> > +	len += scnprintf(buf + len, VENDOR_DUMP_BUF_SIZE - len, "vendor specific registers:");
> 
> This function will be much easier to review and to maintain if a struct
> seq_buf instance is created for 'buf' and if seq_buf_printf() would be
> used instead of scnprintf().
> 
should depend on above..

> > +static bool is_fsm_state_valid(u32 state)
> > +{
> > +	return (state == FSM_STATE_ACTIVE || state == FSM_STATE_LS_BURST);
> > +}
> 
> "return" is not a function. Please remove the superfluous parentheses.
> 
Ok

> > +static int ufs_spacemit_mphy_init(struct ufs_hba *hba)
> > +{
> > +	int ret;
> > +
> > +	/* reset all mphy logical */
> > +	ufshcd_writel(hba, 0x003, UFS_PHY_MNG_BASE + 0x0);
> > +	mdelay(1);
> 
> Why mdelay() instead of msleep()?
> 
Ok, TBO, I need to check more widely about the delay functions,
generally there are too many, too long delay()s ..

some could be simply dropped, some could be reduced,
some could be converted into sleepable function..

> > +static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
> > +{
> > +	/* PA_TXHSG1SYNCLENGTH */
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(0x1552), 0x4f);
> > +
> > +	/* PA_TXHSG1PREPARELENGTH */
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(0x1553), 0xf);
> 
> The code in this function is very repetitive. Please convert all the
> ufshcd_dme_set() calls into a loop over an array.
> 
Ok

> > +	/*LCC_DISABLE*/
> 
> Here and everywhere else in this source file, please follow the
> convention used elsewhere in the Linux kernel and change /*comment*/
> into /* comment */.
> 
Ok

> > +/**
> > + * ufs_spacemit_hibern8_notify - Handle hibernate enter/exit
> > + * @hba: host controller instance
> > + * @cmd: UIC command (HIBER_ENTER or HIBER_EXIT)
> > + * @status: notification status
> > + *
> > + * Manages M-PHY power state during hibernate transitions.
> > + */
> > +static void ufs_spacemit_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
> > +					enum ufs_notify_change_status status)
> > +{
> > +	int ret;
> > +
> > +	dev_dbg(hba->dev, "Hibern8 notify: cmd=%d, status=%d\n", cmd, status);
> > +	if (status == PRE_CHANGE) {
> > +		if (cmd == UIC_CMD_DME_HIBER_EXIT) {
> > +			mdelay(1);
> > +
> > +			/* Enable reference clock */
> > +			ufshcd_writel(hba, MPHY_DEVICE_RESET_DEASSERT,
> > +				      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> > +			mdelay(1);
> > +
> > +			/* Power up all */
> > +			ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> > +			mdelay(1);
> > +
> > +			/* Assert ana_rx_hb8_reset */
> > +			ufshcd_writel(hba, MPHY_PU_WITH_HB8_RESET,
> > +				      UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> > +			mdelay(1);
> > +
> > +			/* Deassert ana_rx_hb8_reset */
> > +			ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> > +
> > +			ret = ufs_spacemit_wait_mphy_pll_lock(hba);
> > +			if (ret < 0)
> > +				return;
> > +
> > +			mdelay(1);
> > +			ufshcd_dme_set(hba, UIC_ARG_MIB(0xdd), 0x57);
> > +			mdelay(1);
> > +			ufshcd_dme_set(hba, UIC_ARG_MIB(0xe8), 0x57);
> > +		}
> > +	}
> 
> Please move all the code in this function that is indented by two tabs 
> into new functions to improve code readability and to reduce
> indentation. This advice comes from the Linux kernel coding style guide.
> 
Ok, will do

-- 
Yixun Lan (dlan)
