Received: from hall.aurel32.net (hall.aurel32.net [195.154.119.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE4E3815E8;
	Mon, 27 Jul 2026 15:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.154.119.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165893; cv=none; b=RN5PLACqZdVbtQaKlRE4PvOxzZ9gUH9U01POcGLcZljUav6ACLei3W9cGFKFVnFj5QHJMP1+9sakqrXNxPquShzOr/Ey9/2gn4bkUfbVf9+2vi203hUNMon8XS/IffLRmaxqc4cdMNBzZ/tzn7nX9Wc6e2j6rKH8HCGaCKg02Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165893; c=relaxed/simple;
	bh=FJpOlBy2S/XoBZDiGh6c9vnD4PM+zA7zeXI+r4BVUPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oc/renG/CgiPfj0Px/cuqOTFxMxi9ApIO/PalNd3q123dVibNVfjsg5N61LHUfgbUrr3O0+DVqJOnHwYLwOV/5ajzUC/n92vHv+OiQfaOh5BwAbHgEyx7MJd3FDbkoWug7M4phtS9n0M2gZGFqw18c4nk94HK2FOgrPOHpEC7Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net; spf=pass smtp.mailfrom=aurel32.net; dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b=ddq2pVYQ; arc=none smtp.client-ip=195.154.119.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b="ddq2pVYQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=93gQyKs/Loc50T0J0Ycz+Bfql8No0r2Sptp8WTz9pkU=; b=ddq2pVYQC9FeOWffCFBQ5sGKJX
	T5kZnOZDOP04yCpIfBjoYeGAV1f9C6QYWwdonbdvcds1Q6ADdHgABKrbJ+S+trTG8Tp+vhkTo1ErT
	TPLx9Gn95sBGPJYc5z5rxeE8W7CkAo1VMt56BH3/kBqkvWthkdnHW6kJI5QmiaZgnsS6cLsnP4eAO
	UcU3GLz1GxaC1WlxaJxdrnx0IedePVJIXr2qxbcF5QZP77rYwIGB7Vn7Ybdi2FWpEdTR/erJ5ADhd
	Xh+RyDt1lTpCqZK5Q/vmFLlxUoTMilOvNoeTNYHrpgtu+w+12/RyCa8rUiOFb/TV+Ui1XyWcWHsgP
	9flGjf0Q==;
Received: from authenticated user
	by hall.aurel32.net with esmtpsa  (TLS1.3)  tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <aurelien@aurel32.net>)
	id 1woMpm-0000000HTK4-3XKG;
	Mon, 27 Jul 2026 17:01:38 +0200
Date: Mon, 27 Jul 2026 17:01:34 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Add UFS Host driver support for SpacemiT K3 SoC
Message-ID: <amdyzkFplQqJvMl1@aurel32.net>
Mail-Followup-To: Yixun Lan <dlan@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
References: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
User-Agent: Mutt/2.2.13 (2024-03-09)

On 2026-07-25 10:37, Yixun Lan wrote:
> This series try to add UFS support for SpacemiT K3 SoC, the controller
> components consists of System Bus Interface Unit, UFS Host Controller
> Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
> Management Entity (DME), Transport Layer, Network Layer, Data Link
> Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
> block diagram can be found in SpacemiT website, chapter 9.7.3 [1]
> 
> Please note, in order to test this driver, the UFS clock driver[2] here
> should be applied first as a prerequisite patch.
> 
> One known issue is that the device will occasionally raise BKOPS interrupt
> when doing some high load test, log from dmesg shows
> 
> [  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 1
> 
> Link: https://spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=en [1]
> Link: https://lore.kernel.org/all/20260630-06-clk-ufs-support-v1-0-cf7521d1d0fe@kernel.org/ [2]
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
> Changes in v2:
> - fix missing interrupts property
> - move ufs node to k3-com260.dtsi
> - convert freq-table-hz to operating-points-v2
> - rework reset_control, fix header and drop global variable
> - drop dump_host_regs() debug interface
> - converge and refactor dme_set() operations
> - massive reduce of busy delay() loops
> - drop vendor specific hce_enable_notify(), fallback to default
> - drop unused member from struct ufs_spacemit_host
> - add COMPILE_TEST support to Kconfig
> - comment style fix
> - Link to v1: https://patch.msgid.link/20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org
> 
> ---
> Yixun Lan (3):
>       scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC
>       scsi: ufs: spacemit: k3: Add UFS Host Controller driver
>       riscv: dts: spacemit: k3: Add UFS support
> 
>  .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml |  56 ++
>  arch/riscv/boot/dts/spacemit/k3-com260.dtsi        |   4 +
>  arch/riscv/boot/dts/spacemit/k3-pico-itx.dts       |   4 +
>  arch/riscv/boot/dts/spacemit/k3.dtsi               |  27 +
>  drivers/ufs/host/Kconfig                           |  12 +
>  drivers/ufs/host/Makefile                          |   1 +
>  drivers/ufs/host/ufs-spacemit.c                    | 686 +++++++++++++++++++++
>  drivers/ufs/host/ufs-spacemit.h                    |  79 +++
>  8 files changed, 869 insertions(+)
> ---
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> change-id: 20260605-08-k3-ufs-support-c8b308e415e2

Thanks for this new version. Patches 2 and 3 are:

Tested-by: Aurelien Jarno <aurelien@aurel32.net>

Regards
Aurelien 

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
