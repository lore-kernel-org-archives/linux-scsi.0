Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7819B2FE056;
	Sat, 25 Jul 2026 10:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784976819; cv=none; b=Plugop0XSBlo1RYwXQCPQeOCnygFJS0Jy2Hr3rftOqUy065Siy5B/O/7NwTzIYlqOTZHmkuKfj9Hn+g9PohwRBb4h/09nmj9hUYsb4TcM802J7htVom2anpLGcgkGsGoZHBMi/rpxS56bZTUUxdyAJxgebzhGz9X4cpa5/rzNDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784976819; c=relaxed/simple;
	bh=vHeb/5/aOUTU3DkhwHSmG2bMbF3YL7NQ49i07mbZEiI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Nd66xfTAftostT5GLr8smaXKH1E/3Of6FkmmabaZ55dao3cjW7CR0zOTFUAmmMJsbAUKJLPlk9GIg33Mn43gFf8DJu5RNtia4vGHr0oEbsTSFxpoNiXFbGekcQpf4CVer8trO2tlG3n5yNXcO4OHJGRZBv7KhkKZZGRoXRI4UYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QouIOOgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QouIOOgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14EE1F000E9;
	Sat, 25 Jul 2026 10:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784976818;
	bh=o6jszJVAYI2iYvuy/c6ssGCy05jTC6n2nEAyU1nsnN4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QouIOOgdd3dERpnuqo/H/1qqc75oheHZM/BB6CftzIOd8M/T8PgWuquGKjr/ogJJz
	 Y7rztDGPJfD2B+kK9GsRXWzM/VBl1siukyH96xsKX5T5oSU5Ph1w6bVXHqFCOX/mkJ
	 e5LBLZj0r00HMecxqHu+AAS6Y6sPD2VHYkqDg4m61zSnS4X1razF2i77g0YstdLZ3y
	 EsagbEq2avxE56LiTmtM1YKdxpBsYCP7Jrlp7njMBH/6glBHUl4I6BkQ7aVKxsg4ym
	 zmxO4Wwoi0cJcr/xkuGl8oF7OJh2G2BXd0+935n3IkPXJepnnBC79piL10qk6sBBQk
	 LeKiB1aYQcuFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] riscv: dts: spacemit: k3: Add UFS support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: conor+dt@kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260725-08-k3-ufs-support-v2-3-45036a2a2418@kernel.org>
References: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
 <20260725-08-k3-ufs-support-v2-3-45036a2a2418@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 25 Jul 2026 10:53:37 +0000
Message-Id: <20260725105337.C14EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Typo in the UFS reference clock frequency in opp-2 (192 MHz instea=
d of 19.2 MHz).
- [High] UFS device is hard-reset upon entering the Hibern8 suspend state.
- [Low] The device tree references an undefined clock macro CLK_APMU_UFS_RE=
FCLK, which will cause a fatal compilation error.
- [Low] Invalid use of bitwise OR to combine negative integer error codes.
- [Low] Missing FSM state dump in workqueue context as claimed by the event=
 handler.
--

--- Patch [3]: [PATCH v2 3/3] riscv: dts: spacemit: k3: Add UFS support ---
commit c3b7015d657d8f4204038196ab74adb7966ad486
Author: Yixun Lan <dlan@kernel.org>

riscv: dts: spacemit: k3: Add UFS support

This commit adds UFS Host Controller support for the SpacemiT K3 SoC. It al=
so
enables the UFS functionality on the Pico-ITX and CoM260-IFX boards.

> diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/s=
pacemit/k3.dtsi
> --- a/arch/riscv/boot/dts/spacemit/k3.dtsi
> +++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
> @@ -469,6 +469,33 @@ usb2_phy: phy@c0a20000 {
>  			status =3D "disabled";
>  		};
> =20
> +		ufshc: ufshc@c0e00000 {
> +			compatible =3D "spacemit,k3-ufshc";
> +			reg =3D <0x0 0xc0e00000 0x0 0x40000>;
> +			clocks =3D <&syscon_apmu CLK_APMU_UFS_ACLK>,
> +				 <&syscon_apmu CLK_APMU_UFS_REFCLK>;

[Severity: Low]
Does this code reference an undefined clock macro? CLK_APMU_UFS_REFCLK is n=
ot
defined in the included headers, which will cause a fatal syntax error duri=
ng
device tree compilation.

> +			clock-names =3D "aclk", "ref_clk";
> +			resets =3D <&syscon_apmu RESET_APMU_UFS_ACLK>;
> +			interrupts =3D <135 IRQ_TYPE_LEVEL_HIGH>;
> +			lanes-per-direction =3D <2>;
> +			operating-points-v2 =3D <&ufs_opp_table>;
> +			status =3D "disabled";
> +
> +			ufs_opp_table: opp-table {
> +				compatible =3D "operating-points-v2";
> +
> +				opp-1 {
> +					opp-hz =3D /bits/ 64 <491520000>,
> +						 /bits/ 64 <19200000>;
> +				};
> +
> +				opp-2 {
> +					opp-hz =3D /bits/ 64 <491520000>,
> +						 /bits/ 64 <192000000>;

[Severity: High]
Is there a typo in the UFS reference clock frequency for opp-2? The frequen=
cy
is set to 192000000 (192 MHz) instead of the standard 19200000 (19.2 MHz) u=
sed
in opp-1. This will cause the OPP framework to incorrectly configure the
reference clock, likely preventing the PHY from locking or causing the
controller to fail.

> +				};
> +			};
> +		};

[ ... ]

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c

[ ... ]

> +static int ufs_spacemit_check_hibern8(struct ufs_hba *hba)
> +{
> +	u32 tx_fsm_val_0 =3D 0;
> +	u32 tx_fsm_val_1 =3D 0;
> +	int retries =3D DIV_ROUND_UP(HBRN8_POLL_TOUT_MS * 1000, 100);
> +	int err =3D 0;
> +
> +	do {
> +		err =3D ufshcd_dme_get(hba,
> +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> +				     &tx_fsm_val_0);
> +		err |=3D ufshcd_dme_get(hba,
> +				      UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +						      UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)),
> +				      &tx_fsm_val_1);

[Severity: Low]
Does this bitwise OR corrupt the error code if ufshcd_dme_get() fails? Since
ufshcd_dme_get() returns standard negative integer error codes on failure,
combining them with a bitwise OR will result in a nonsensical value, which =
is
later printed in the kernel log.

[ ... ]

> +/**
> + * ufs_spacemit_event_notify - Handle UFS error events
> + * @hba: host controller instance
> + * @evt: event type
> + * @data: event-specific data
> + *
> + * Handles error events from UFS core, dumps registers immediately
> + * and schedules FSM state dump for later execution in workqueue context.
> + */

[Severity: Low]
Can we update the documentation or the implementation? The docstring states=
 this
function schedules an FSM state dump for later execution in a workqueue con=
text,
but the implementation only prints a warning message and takes no further a=
ction.

> +static void ufs_spacemit_event_notify(struct ufs_hba *hba, enum ufs_even=
t_type evt, void *data)

[ ... ]

> +static void ufs_spacemit_post_hibern8(struct ufs_hba *hba, enum uic_cmd_=
dme cmd)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x80 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x80 },
> +		{ UIC_ARG_MIB(0xdd), 0x57 },
> +		{ UIC_ARG_MIB(0xdd), 0xd7 },
> +		{ UIC_ARG_MIB(0xe8), 0x57 },
> +		{ UIC_ARG_MIB(0xe8), 0xd7 },
> +	};
> +
> +	if (cmd =3D=3D UIC_CMD_DME_HIBER_ENTER) {
> +		ufs_spacemit_check_hibern8(hba);
> +
> +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +
> +		/* Power down M-PHY */
> +		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +		/* Keep reference clock enabled, assert device reset */
> +		ufshcd_writel(hba, MPHY_DEVICE_RESET_ASSERT,
> +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);

[Severity: High]
Does this code actively hard-reset the UFS device when entering the Hibern8
suspend state? Writing MPHY_DEVICE_RESET_ASSERT asserts the RST_N pin, which
wipes all internal state in the hardware.

When exiting Hibern8, the core will issue a DME_HIBER_EXIT command, but sin=
ce
the device has been reset, it will require a full DME_LINK_STARTUP sequence
instead. This mismatch will cause the resume process to fail.

> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260725-08-k3-ufs-=
support-v2-0-45036a2a2418@kernel.org?part=3D3
