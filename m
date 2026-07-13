Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67C42E8B9B;
	Mon, 13 Jul 2026 23:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783987066; cv=none; b=t1JS698JUO5zrFigJwX+4ID9ngTW5efY6bD4TWcA9dSc/oAtuZQ7Mo7wZWECC9gPoyq6/NkqgGHC0pvTt+s7/c4ouzmciHUkqi6PG4DnOtYf64NdM3kzACaFUz63uEuqpjVmgd1AbowOWDNwchIsZXJIlsC1Pz6OQQLlzPT+0Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783987066; c=relaxed/simple;
	bh=024uMThOd6cyS6qgBSZV8Ud/4QoWdnppLmUJ/jWWSvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4KOOi2zjaqoatnQ19zM5hcAiQ6GjUWiO5rP04lUPhtJPk+Zbzeq1SfeKrEvjUYoXEeBo5nTNvwnGdkxIIS1Mw6djRe802IJy8rRTr454qI1EOxQgP9XnUXhvwHozpF0mPq419YtSf+kUPnmBx2I8Lnvf07y66lJ54yyot8XPm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fq7zOW9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fq7zOW9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FE21F000E9;
	Mon, 13 Jul 2026 23:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783987064;
	bh=xIhyR3zgIocehUTam0YtcBB6EqA+r73EXcnFWOui1a4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fq7zOW9xN/onRd4/dFSQRSTXLCOxG14Xv/GM3rN4tHxAaVmnlvkQkaMZvRc5tkni/
	 OmgLQuza8B/thbJq8udck8bYCe2DrMcooTzy28LTcKkDE6c43PVO8w52FDiqolhibu
	 wTPypcN3vs9GoQRP32YsTmjSVfcJkS78xZc8HjTn/uwtr0TGKMirpvK7d63tASXw90
	 GCXbPFkqqySHnXWKNDb7GNCHj0111QOz+PBD/2cx7YOGADFadkD92F0lEmAkoPoz9O
	 pnbIGwJYdNUSdP7qBrxzem0u5tGaLwtXuqBh40GVMuLLzL+d4LfEI7cY/6TZmNMGCy
	 Vq2LNGgiUdlcA==
Date: Mon, 13 Jul 2026 23:57:42 +0000
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
Message-ID: <20260713235742-GKE106000@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <wjbz5tp7vjrsjwjaiu3n7du5ksbrlsduuxhwg2wriyxshkrqd5@t3sdxr6ua2sg>
 <20260713123759-GKD106000@kernel.org>
 <CAEev2e-g3bZcohFf_7b5CaVyi0BeWi5uwLGj6MuhQXp16jiyEQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEev2e-g3bZcohFf_7b5CaVyi0BeWi5uwLGj6MuhQXp16jiyEQ@mail.gmail.com>

Hi Anirudh,

On 09:56 Mon 13 Jul     , Anirudh Srinivasan wrote:
> Hi Yixun,
> 
> On Mon, Jul 13, 2026 at 7:38 AM Yixun Lan <dlan@kernel.org> wrote:
> >
> > Hi Anirudh,
> >
> > On 22:40 Sun 12 Jul     , Anirudh Srinivasan wrote:
> > > Hi Yixun,
> > >
> > > On Thu, Jul 02, 2026 at 02:31:34AM +0000, Yixun Lan wrote:
> > > > This series try to add UFS support for SpacemiT K3 SoC, the controller
> > > > components consists of System Bus Interface Unit, UFS Host Controller
> > > > Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
> > > > Management Entity (DME), Transport Layer, Network Layer, Data Link
> > > > Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
> > > > block diagram can be found in SpacemiT website, chapter 9.7.3 [1]
> > > >
> > > > Please note, in order to test this driver, the UFS clock driver[2] here
> > > > should be applied first as a prerequisite patch.
> > > >
> > > > One known issue is that the device will occasionally raise BKOPS interrupt
> > > > when doing some high load test, log from dmesg shows
> > > >
> > > > [  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 1
> > > >
> > > > Link: https://spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=en [1]
> > > > Link: https://lore.kernel.org/all/20260630-06-clk-ufs-support-v1-0-cf7521d1d0fe@kernel.org/ [2]
> > > > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > >
> > > I see this during probe on a k3-pico-itx. Does the UFS chip on board
> > > have an RPMB block on it? Is this error of any concern.
> > >
> > It's probably true of having a RPMB block, but not used in K3 platform, so can ignore
> >
> > > [    5.957864] ufshcd-spacemit c0e00000.ufshc: ufshcd_scsi_add_wlus: BOOT WLUN not found
..
> > > [    5.963319] bus_add_device: cannot add device 'ufs_rpmb0' to unregistered bus 'ufs_rpmb'

Just checked code under drivers/ufs/, and couldn't find where ufs_rpmb bus is registered,
so this kind of warning/error message is expected, or could UFS maintainer confirm this?

> > > [    5.971155] ufshcd-spacemit c0e00000.ufshc: Failed to register UFS RPMB device 0
> > >
> > Maybe disable CONFIG_RPMB to silent this? I've not tested this option locally
> 
> I'm testing on a distro defconfig, so it has this option enabled.
> 
> Is there anything we can do in the driver to have it ignore the RPMB?

No, but why not disable CONFIG_RPMB in the first place

> If the error is a red-herring, we shouldn't be displaying it at all in
> the first place.
> 

Either fix the code or just ignore it..

-- 
Yixun Lan (dlan)
