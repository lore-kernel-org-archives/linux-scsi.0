Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4330B3D3311
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 05:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781588153; cv=none; b=oenHIwUxySy1Z+WLMErj3fBQc0D4NcoYRfDVzSO5Ez/1r7+FD/F5XmGBB8RwhWkNhvYfwXJPYJNf2hnXJQWa2EYHkUIsVCt6gEDLr0Dbnj3dj6DuNf/QU5AErW0gGb6M8w939xuo7SpZswSoaHiSpJ2w/T0zSrn/ubRg7lubvtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781588153; c=relaxed/simple;
	bh=y7N3/u0OsrEjlkWJIJ5OphcW+jiH7V5hEQlDaXf+Xgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1Q6//qaUK9Ws3XRkN55qVSWAUjV3eB0ikh4e80LBTB8paLYz1KfTmU+arUL/zYgckBg4Npp/YLWns3enjOkxv0ZMeqq+PHRs6oJ3N5u9eViGlVgPwhWagR032Jsgyzc2GRdzW7Nhk0/5t1VMcLorpYFadTPU1JzIcqO/s6XT8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bw9djGwH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bw9djGwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C97A1F00A3A;
	Tue, 16 Jun 2026 05:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781588152;
	bh=G1Mw2a7qoi+boOLpzB9qaRc3RlovOt1XSTdOWigzRUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bw9djGwHj7Sx60ELJVMYy+f8hljc6iGEliq2ik8N5YzAnacPD7I37mOi5nvsElhpy
	 supxUYcYGxtqcpCMygQ5eJEDJ+atRBQqaTEmye+bL5mDnghZDMffTctZgrz2khqlJk
	 qwL6Ol14Uqufo8OKVSUtSxogKzpslWDT0moWKoZO0IpFrMZVj7KlU/qBdLtlzXoIJR
	 2tFakOO7roYh4lswSbOoFY0mqhBprZ5Zn+idFzcBx6TXZmhe9Yx6sTeqPCApK7rNmD
	 naII2cDEZz331Hekwl3QOFepL1iAvsVbERdP2RuZP36zNr6GgWw1ZJ9/PBudbFvvLI
	 54AcdgLJMi49Q==
Date: Tue, 16 Jun 2026 07:35:45 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com, 
	peter.wang@mediatek.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v9 0/2] scsi: ufs: Add support for static TX Equalization
 settings
Message-ID: <xow5me7cu2a3ksidppgw3zchjpydj5s65r77jzg22xrrbjol4g@nlvgcccr6gxu>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>

On Mon, Jun 15, 2026 at 06:28:32AM -0700, Can Guo wrote:
> Hi,
> 
> This series adds support for board-specific static TX Equalization settings
> provided through Device Tree.
> 
> This series is based on the earlier TX Equalization enablement work and
> persistent storage/retrieval of optimal TX Equalization settings work:
> https://lore.kernel.org/all/20260325152154.1604082-1-can.guo@oss.qualcomm.com
> https://lore.kernel.org/all/20260424151420.111675-1-can.guo@oss.qualcomm.com
> 

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> Background
> ==========
> 
> UFS v5.0/UFSHCI v5.0 adds HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
> and M-PHY v6.0. These specs define TX Equalization for all High-Speed
> Gears (not only HS-G6) to compensate channel loss and improve signal
> integrity at high speed.
> 
> For HS-G6, M-PHY uses PAM4 1b1b line coding. Pre-Coding may also be
> required depending on channel characteristics.
> 
> This series adds vendor-neutral DT properties:
> - patternProperties: txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6]
> - fixed property: tx-precode-enable-g6
> 
> All properties use per-lane Host/Device tuples and accept 2 or 4 values
> for x1/x2 lane configurations:
> - txeq-preshoot-g[1-6]: values 0..7
> - txeq-deemphasis-g[1-6]: values 0..7
> - tx-precode-enable-g6: values 0/1
> 
> These properties carry board-level SI characterization data used as static
> TX Equalization settings for each High-Speed Gear.
> 
> Example DTS snippet
> ===================
> 
> The following x2-lane example shows the expected DT encoding:
> 
> 	ufs@1d84000 {
> 		lanes-per-direction = <2>;
> 
> 		txeq-preshoot-g6 = <1 2>, <3 4>;
> 		txeq-deemphasis-g6 = <0 1>, <2 3>;
> 		tx-precode-enable-g6 = <1 0>, <0 1>;
> 	};
> 
> Relationship with Adaptive TX Equalization
> ==========================================
> 
> Adaptive TX Equalization remains the primary path when enabled.
> 
> Static TX Equalization settings from DT are board-specific baseline values,
> but when adaptive TX Equalization is used, static settings are not final:
> - If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
>   those retrieved settings override static DT settings.
> - If retrieval is not available/valid, TX EQTR runs and trained settings
>   override static DT settings.
> 
> So static DT settings are a fallback and are intended for cases where
> adaptive TX Equalization is not enabled/used.
> 
> No behavior changes for platforms that do not provide these properties.
> 
> What this series adds
> =====================
> 
> 1. dt-bindings:
> - Document txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6], and
>   tx-precode-enable-g6 in ufs-common.yaml.
> - Define tuple encoding for host/device values per lane.
> - Add per-property value validation ranges in schema.
> 
> 2. UFS core/platform integration:
> - Parse and validate per-gear DT TX EQ settings during platform init.
> - Store parsed values into per-gear TX EQ params and track DT origin using
>   the from_dt flag.
> - Integrate static-state handling in TX EQ flow so DT-provided entries are
>   fed through the adaptive TX Equalization path and then converted to
>   normal runtime params.
> 
> v8 -> v9:
> - Fix DT schema shape for TX EQ properties to use proper uint32-matrix tuple
>   form (nested rows) for tx-precode-enable-g6, txeq-preshoot-g[1-6], and
>   txeq-deemphasis-g[1-6].
> 
> v7 -> v8:
> - Replace split HS-G6 precode lane-list properties
>   (tx-precode-g6-host-lanes/tx-precode-g6-device-lanes) with a single
>   tx-precode-enable-g6 tuple property in the binding.
> - Update parser in patch 2 to read tx-precode-enable-g6 as Host/Device
>   tuples and validate full lane coverage and 0/1 values.
> - Rename is_static to from_dt for clearer semantics in TX EQ params.
> - Update commit messages for clarity and consistency.
> 
> v6 -> v7:
> - Add DTS properties example in the cover letter.
> - Replace tx-precode-enable-g6 tuple encoding with split lane-list
>   properties:
>   tx-precode-g6-host-lanes and tx-precode-g6-device-lanes.
> - Update parser in patch 2 to read optional u32 lane-index arrays and
>   treat unlisted lanes as precode disabled.
> - Refactor patch 2 TX EQ property parsing to share a single helper for
>   txeq-preshoot-gN/txeq-deemphasis-gN array read and validation.
> - Dropped Reviewed-by/Acked-by due to code changes.
> 
> v5 -> v6:
> - Use num_elems instead of count in the per-property validation loops for
>   clarity (patch 2).
> - Change else if (lpd > UFS_MAX_LANES) to a plain if after the !lpd early
>   return, per kernel style (patch 2).
> 
> v4 -> v5:
> - Extract the body of the per-gear for-loop in
>   ufshcd_parse_static_tx_eq_settings() into a new helper
>   ufshcd_parse_tx_eq_settings_for_gear() to reduce indentation depth
>   (patch 2).
> - Mark lpd and num_elems as const u32; rename sz to num_elems for clarity;
>   use %u format specifier to match (patch 2).
> - Replace size_t with u32 for the element-count variable (patch 2).
> - Emit dev_warn() when lanes_per_direction exceeds UFS_MAX_LANES
>   (patch 2).
> 
> v3 -> v4:
> - Add Acked-by from Manivannan Sadhasivam to patch 1.
> - Remove spurious dev_err() on the lpd guard in patch 2 (lpd == 0 is
>   normal on platforms without lanes-per-direction in DT, not an error).
> - Improve comment above the is_static condition in patch 2 to read
>   "valid but static, i.e., populated from DT" for clarity.
> 
> v2 -> v3:
> - Split the DT TX EQ binding into semantically separate properties:
>   txeq-preshoot-g*, txeq-deemphasis-g*, tx-precode-g6-*-lanes.
> - Place precode properties in properties (fixed keys) instead of
>   patternProperties to satisfy dt-schema meta-schema rules.
> - Restrict precode property to HS-G6 and document per-property ranges.
> - Update the core parser to consume split properties.
> - Drop unrelated arch/arm64/configs/defconfig changes from patch 2.
> 
> v1 -> v2:
> - Improve the commit message of patch 1.
> 
> Can Guo (2):
>   dt-bindings: ufs: Document static TX Equalization settings properties
>   scsi: ufs: core: Add support for static TX Equalization settings
> 
>  .../devicetree/bindings/ufs/ufs-common.yaml   |  58 +++++++
>  drivers/ufs/core/ufs-txeq.c                   |  15 +-
>  drivers/ufs/host/ufshcd-pltfrm.c              | 156 ++++++++++++++++++
>  include/ufs/ufshcd.h                          |   2 +
>  4 files changed, 230 insertions(+), 1 deletion(-)
> 
> -- 
> 2.34.1

-- 
மணிவண்ணன் சதாசிவம்
