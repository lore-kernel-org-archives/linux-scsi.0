Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6570A2737F8;
	Thu,  2 Jul 2026 02:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782960386; cv=none; b=dmd5LRuIQ/it3zTGY9W+LCVjPtz0S5AH+Oq3akfwjCVFRgj+EiGGO0/DYDpTY8oKkovC9r6cD04z0cT06C+P4M4n8v+tOBgnunyAjMYM989rh2LBs6eM5ihN5jCRak4Tup3bGJ/Pt/Bhv/LJgcHm2/8xZi+T6IBY5OM9JMcnmzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782960386; c=relaxed/simple;
	bh=ogCFN93/ZjeojubEtm6hREJVvqMP/qL71DV1h7Oanbs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F9X3p8sTReu39pVx+vnZ21C7vHcthniD9MbeOwXvnC0Y/oqvInGDJQh4Omxq013c3NMaJaSiEo4xXW2EK9AMbDUd3PWIfBGsAzNQvpOqBkp/nSgvfGwyj22tFKoG2XVw3u9cQKHvKWSf1rBCdt+IlgGirTTurRYCDpJerT0Krqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpxy08xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpxy08xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D811F000E9;
	Thu,  2 Jul 2026 02:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782960385;
	bh=e5XcNdvdgls6+YNIiAgmWxZnVCvxdie81ZvxlHAbZRk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kpxy08xPYxX+AAgmiNmtF/hpcPbknLjqkalv9b5/hS4H5ItufaQWfoglIcr4rBDG1
	 iKC8rV7zMLde6Byvr99L605OCz3RfnpWoYc4WNZxz3bN+grx/sc2FFoIHSM91Z/DwL
	 +Mv4v1NZCBL9k3WxT5EDrDL8Cq+tEqjd0rwT2qOxZMF5b05nJCAsnaotelWA2Mpfyh
	 FABImQgf0JXL54bAfQnM3ZtxiQ5VbfPE8+liWqKCyVLSCOwAbwRI9TuTEa8vfFApuK
	 uNPSuLyGCKeD3zomo6dhOAQ7ilIZx5hUX8LdmjG8coWgUtNGfxFUiDrUtb1xhpqmDP
	 S/pSmA4VEC7OA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: robh@kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 02:46:24 +0000
Message-Id: <20260702024624.A4D811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Critical] Incorrect bitwise logic and inverted polling condition in `ufs=
_spacemit_hce_enable_notify` cause a guaranteed infinite loop and kernel ha=
ng.
- [High] Missing cancellation of `fsm_dump_work` upon driver removal leads =
to a Use-After-Free vulnerability.
- [High] Asynchronous hardware access in `ufs_spacemit_fsm_dump_work` lacks=
 PM runtime and reset synchronization.
- [Medium] The driver uses massive `mdelay()` calls in sleepable contexts, =
unnecessarily stalling the CPU.
- [Low] `ufs_spacemit_dump_host_regs()` uses a large GFP_ATOMIC allocation =
for a single log message that will be truncated.
- [Low] `ufs_spacemit_link_startup_post_change()` fetches a hardware state =
that is discarded, and its return value is ignored by the caller.
- [Low] `ufs_spacemit_wait_mphy_pll_lock()` open-codes a 10ms polling loop =
using `udelay(1)`.
--

commit cd15fb1a128c7213cfc272df0441215d19da3d01
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: k3: Add UFS Host Controller driver

This commit introduces the UFS host controller driver for SpacemiT K3 SoC.
It adds PHY initialization, quirks, and power management features for stand=
ard
JEDEC UFS 2.2 operations.

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 0000000000000..be475f5566a83
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c

[ ... ]

> +static void ufs_spacemit_dump_host_regs(struct ufs_hba *hba)
> +{
[ ... ]
> +	buf =3D kzalloc(VENDOR_DUMP_BUF_SIZE, GFP_ATOMIC);
> +	if (!buf)
> +		return;
[ ... ]
> +	dev_warn(hba->dev, "%s", buf);

[Severity: Low]
Does this 2048-byte allocation need to be GFP_ATOMIC, and will the dev_warn=
()
print truncate the output? The printk subsystem limits lines to LOG_LINE_MAX
(usually 1024 bytes), which might silently drop the later M-PHY registers in
the buffer.

[ ... ]

> +static int ufs_spacemit_wait_mphy_pll_lock(struct ufs_hba *hba)
> +{
> +	int timeout =3D MPHY_PLL_LOCK_TIMEOUT_US;
> +	u32 val;
> +
> +	while (timeout-- > 0) {
> +		val =3D ufshcd_readl(hba, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +		if (val & MPHY_PLL_LOCK_BIT)
> +			return 0;
> +
> +		udelay(1);
> +	}

[Severity: Low]
Could this open-coded polling loop be replaced with readl_poll_timeout()?

[ ... ]

> +static int ufs_spacemit_link_startup_post_change(struct ufs_hba *hba)
> +{
> +	u32 tx_lanes;
[ ... ]
> +	return ufs_spacemit_get_connected_tx_lanes(hba, &tx_lanes);
> +}
> +
> +static int ufs_spacemit_link_startup_notify(struct ufs_hba *hba,
> +					    enum ufs_notify_change_status status)
> +{
> +	switch (status) {
> +	case PRE_CHANGE:
> +		ufs_spacemit_link_startup_pre_change(hba);
> +		break;
> +	case POST_CHANGE:
> +		ufs_spacemit_link_startup_post_change(hba);
> +		break;

[Severity: Low]
Are we discarding the tx_lanes state here? The function
ufs_spacemit_link_startup_post_change() populates the variable but never us=
es
it, and its return value is ignored by ufs_spacemit_link_startup_notify().

[ ... ]

> +static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
> +{
[ ... ]
> +	/*LCC_DISABLE*/
> +	mdelay(50);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_LCC_ENABLE, UIC_ARG_MPHY_TX_GEN_=
SEL_INDEX(0)), 0);

[Severity: Medium]
Is it safe to block the CPU completely with mdelay() here? Since
ufs_spacemit_apply_dev_quirks() is called from a sleepable context during
initialization and reset, could this use msleep(50) instead?

[ ... ]

> +static void ufs_spacemit_fsm_dump_work(struct work_struct *work)
> +{
> +	struct ufs_spacemit_host *host =3D container_of(work, struct ufs_spacem=
it_host,
> +							  fsm_dump_work);
> +	struct ufs_hba *hba =3D host->hba;
> +
> +	/* Safe to call blocking functions in workqueue context */
> +	if (ufshcd_is_link_active(hba))
> +		ufs_spacemit_dump_fsm_state(hba);
> +}

[Severity: High]
Does this lockless link state check properly serialize against concurrent
host resets? If the error handler triggers a hardware reset concurrently,
this could access unclocked or resetting hardware since it doesn't acquire
hba->host_sem.

[ ... ]

> +static int ufs_spacemit_init(struct ufs_hba *hba)
> +{
> +	int err =3D 0;
> +	struct device *dev =3D hba->dev;
> +	struct ufs_spacemit_host *host;
> +
> +	host =3D devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
[ ... ]
> +	/* Initialize workqueue for deferred FSM state dump */
> +	INIT_WORK(&host->fsm_dump_work, ufs_spacemit_fsm_dump_work);

[ ... ]

> +static void ufs_spacemit_remove(struct platform_device *pdev)
> +{
> +	ufshcd_pltfrm_remove(pdev);
> +}

[Severity: High]
Will this leak or cause a use-after-free if the driver is unbound while
work is queued? The host structure is managed by devres and will be freed
after ufs_spacemit_remove() completes, but there is no cancel_work_sync()
for host->fsm_dump_work to ensure pending items finish executing before
the struct is destroyed.

[ ... ]

> +static int ufs_spacemit_hce_enable_notify(struct ufs_hba *hba,
> +					  enum ufs_notify_change_status status)
> +{
> +	struct ufs_spacemit_host *host =3D ufshcd_get_variant(hba);
> +	u32 enable_val, val;
> +
> +	if (status =3D=3D PRE_CHANGE) {
> +		enable_val =3D CONTROLLER_ENABLE;
> +
> +		if (hba->caps & UFSHCD_CAP_CRYPTO)
> +			enable_val =3D CRYPTO_GENERAL_ENABLE | CONTROLLER_ENABLE;
> +
> +		if (!host->first_hce_done) {
> +			host->first_hce_done =3D true;
> +			dev_dbg(hba->dev, "First HCE enable\n");
> +		} else {
> +			val =3D ufshcd_readl(hba, REG_CONTROLLER_ENABLE);
> +			if (val =3D=3D enable_val) {
> +				ufshcd_writel(hba, enable_val & (1 << CONTROLLER_ENABLE),
> +					      REG_CONTROLLER_ENABLE);
> +
> +				while (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) =3D=3D
> +				       (enable_val & (1 << CONTROLLER_ENABLE)))
> +					;
> +			}
> +		}
> +	}

[Severity: Critical]
Will this while loop hang indefinitely?=20

CONTROLLER_ENABLE is 1, so (1 << CONTROLLER_ENABLE) evaluates to 2.
The expression enable_val & 2 evaluates to 0 (since enable_val is 1 without
crypto).

Writing 0 will disable the controller. The while loop then checks if reading
the register returns 0, which immediately evaluates to true and creates an
infinite loop resulting in a hard kernel lockup.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702-08-k3-ufs-=
support-v1-0-1a64a3ab128f@kernel.org?part=3D2
