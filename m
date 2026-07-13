Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879C72DA75C;
	Mon, 13 Jul 2026 12:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946284; cv=none; b=o9udKcLF9jRnu3NEKAEPa8mR5saRxZ8AOWraOMdrReSUcZS0lfotiy9zDZEcFt1Sbj5gssrGmcRU+S7z4WLepStqHHjpe9XP4mbomp7IHhVsKfc3fnI7xZx2SLr2m0XotX/IHFwWTSiGQT/t8m7iye8C7ePVhOtc+blVPwXqjxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946284; c=relaxed/simple;
	bh=F2kU75yS8tXKghXusuQPLNzkIvpTTw+rQSykO/qlDlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nm1X642rum8oCD790c8GRdyVonwbEZZOTQOcTcCy17M8lW1cpTnjON95E73PAVGqg69sxoHizmemLThQc83lpyesd/1osV/xOK1etWBYNh2AvT3xPF6KMJ3pZmHe/LXdP02mF2ava9FrOxgCRY8HfZUVCHdo6AvFPUYAtU99tz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXbLMSYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXbLMSYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75D81F000E9;
	Mon, 13 Jul 2026 12:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783946283;
	bh=zZxDNhRLltG4YTlq4WnJRUzpRD8ef1hSBbexfSAmotg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OXbLMSYM5ZBiiygAxE55G8L1OBxwgglhq93YUiwA7kmPPEf9IVIXKqQLZdSk/44K1
	 633KMNkVsAdZ2p7IfqSV2zJEkkYn2TIWyqN0dtsMHzuz5PWwH4wdRH+XkZU8q40yiJ
	 xsuj4Hn0+I6mvZn8p5dYkD5flFNbWqHQvXkoSCt69PvIwYGcDcgoi08WbBgyYFonZV
	 Vk2OZ2PeCDhfv1d9kauP4vIVvKO4wNt0sq2wpthpGH2BzGngkv8mKDUKlTx4DwOfe3
	 5WW7KfYUGGhDuv6Jggw+UtnW6sub7Q60jIGK8N+PTA5KkGxJYMHVlGBOUpmN8pY0MX
	 PhKZf7LI0PpHA==
Date: Mon, 13 Jul 2026 12:37:59 +0000
From: Yixun Lan <dlan@kernel.org>
To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
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
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add UFS Host driver support for SpacemiT K3 SoC
Message-ID: <20260713123759-GKD106000@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <wjbz5tp7vjrsjwjaiu3n7du5ksbrlsduuxhwg2wriyxshkrqd5@t3sdxr6ua2sg>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <wjbz5tp7vjrsjwjaiu3n7du5ksbrlsduuxhwg2wriyxshkrqd5@t3sdxr6ua2sg>

Hi Anirudh,

On 22:40 Sun 12 Jul     , Anirudh Srinivasan wrote:
> Hi Yixun,
> 
> On Thu, Jul 02, 2026 at 02:31:34AM +0000, Yixun Lan wrote:
> > This series try to add UFS support for SpacemiT K3 SoC, the controller
> > components consists of System Bus Interface Unit, UFS Host Controller
> > Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
> > Management Entity (DME), Transport Layer, Network Layer, Data Link
> > Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
> > block diagram can be found in SpacemiT website, chapter 9.7.3 [1]
> > 
> > Please note, in order to test this driver, the UFS clock driver[2] here
> > should be applied first as a prerequisite patch.
> > 
> > One known issue is that the device will occasionally raise BKOPS interrupt
> > when doing some high load test, log from dmesg shows
> > 
> > [  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 1
> > 
> > Link: https://spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=en [1]
> > Link: https://lore.kernel.org/all/20260630-06-clk-ufs-support-v1-0-cf7521d1d0fe@kernel.org/ [2]
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> 
> I see this during probe on a k3-pico-itx. Does the UFS chip on board
> have an RPMB block on it? Is this error of any concern.
> 
It's probably true of having a RPMB block, but not used in K3 platform, so can ignore

> [    5.957864] ufshcd-spacemit c0e00000.ufshc: ufshcd_scsi_add_wlus: BOOT WLUN not found
> [    5.963319] bus_add_device: cannot add device 'ufs_rpmb0' to unregistered bus 'ufs_rpmb'
> [    5.971155] ufshcd-spacemit c0e00000.ufshc: Failed to register UFS RPMB device 0
> 
Maybe disable CONFIG_RPMB to silent this? I've not tested this option locally

-- 
Yixun Lan (dlan)
