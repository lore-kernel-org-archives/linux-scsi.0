Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE68407567;
	Thu,  3 Sep 2026 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788436315; cv=none; b=LDxR0CKFL4L5xl70mfZkdQHP+ysb+5/5QXB9gi0121ppFs8EzhgooxZUHFZ5vBIoVbvlVBY3OAHkS4O3ShwfmbXAA5Y/K2tZnAjH8Pl/2CgAAGfyapiSql8ohl/eGpcbdP/M41HZhV8P2+Cq+0wQw4bTdoYTSungqj0uUTKSbEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788436315; c=relaxed/simple;
	bh=+/jK6oDr1A0YdtR0Qrqozxz9Lrcm1FWSzYGzuQvNGlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=seah9Xr3p9NROoQtPdXhyf8cxFrL7CS7qtE+8Ov5wtraZgsyWhMoLejobkp6m3Xvm340ivpYx8gmicn/MdlIPg9WtGSSi2GzNRWfvNE1O/+bV8fd9r/e0Q/irL795BP3m1mxxOvIMkHpWlZWj04nYmvWBsfv3OrQYeoZDmnViTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuJ8oNK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuJ8oNK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B501F000E9;
	Thu,  3 Sep 2026 11:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788436309;
	bh=dxyY9Tzkz8LZbbS4IdiWykaLcoxazFbZtCM7LZDUqSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NuJ8oNK2NqKz656HJoV8/Ca7eW08ej/LNpGO3nMZsr85ZCF3x8TabWpESy22HicL5
	 1GmkBVPXaNMkGlecBlWwxgVKnX1bRAm/brINsNYTYqZxyI58jQVq6m6Ftbyy68huA5
	 771E6L5zaCxC7pmxP529toEp92hNd7eVmMG+mBGmoxPTSKKt+NG3JR6WelvTIRl79e
	 Ni2GC2vIn+0tETkV5S4d/700LCZq9735EoS8q/qH+Yv7qaKjmRFJFH4aDmqeNqG8YO
	 pZvUGjcNdN80nIt4IyMr83Dk5/IQK3bBlwEJMOgN2Uyuy9aHJ7bv1nhCveJk5RBfpc
	 b+L3QjobJDw3g==
Date: Thu, 3 Sep 2026 13:51:29 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Niklas Cassel <cassel@kernel.org>
Cc: alistair23@gmail.com, mst@redhat.com, eperezma@redhat.com, 
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com, jasowangio@gmail.com, 
	linux-scsi@vger.kernel.org, mkp@kernel.org, virtualization@lists.linux.dev, 
	James.Bottomley@hansenpartnership.com, alistair@alistair23.me, 
	Alistair Francis <alistair.francis@wdc.com>, linux-pci@vger.kernel.org, Shunsuke Mie <mie@igel.co.jp>, 
	Frank Li <Frank.Li@kernel.org>, Koichiro Den <den@valinux.co.jp>, 
	Kishon Vijay Abraham I <kishon@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 0/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
Message-ID: <akvzpivrbg3b3jra6ibga6j637pwqkwnnzs6q2ymcn5ixrdym6@wniqpspkcknt>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
 <apaOZeeDBIRlpB7b@ryzen>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apaOZeeDBIRlpB7b@ryzen>

On Tue, Sep 01, 2026 at 10:35:49AM +0200, Niklas Cassel wrote:
> On Tue, Sep 01, 2026 at 11:46:48AM +1000, alistair23@gmail.com wrote:
> > From: Alistair Francis <alistair.francis@wdc.com>
> > 
> > This series adds a VirtIO SCSI endpoint built on top of the VirtIO PCIe
> > endpoint. This is a similar approach to the NVMe PCIe Endpoint
> > (drivers/nvme/target/pci-epf.c) but for SCSI.
> > 
> > This does end up being somewhat similar to the pci-epf.c code, but
> > re-written for SCSI.
> > 
> > This approach allows a PCIe Endpoint device (tested on a
> > radxa-rock5b) to setup what appears to be a SCSI device, using an
> > existing SCSI backend (tested using scsi_debug).
> > 
> > At this point a host can connect over PCIe, ensure virtio_pci and
> > virtio_scsi is loaded and on PCIe rescan will see a scsi device.
> > 
> > There are a few pain points with this approach though:
> >  1. We have to use the Legacy SCSI VirtIO driver. This is because the
> >     Raxda Rock5b (and AFAIK all PCIe Endpoint hardware) can't add
> >     capabilities. So we can't advertise the VirtIO Common configuration
> >     capability, which means we can't be a modern VirtIO SCSI device.
> > 
> >     This is unfortunate, but there doesn't seem to be any way around
> >     this, at least with the current hardware.
> > 
> >  1.2. Legacy virtio devices only have 32 feature bits and therefore can't
> >     set the VIRTIO_F_ACCESS_PLATFORM (bit 33) feature. This means the
> >     vring_use_map_api() function will return false.
> > 
> >     Currently Linux endpoint devices use the legacy virtio interface as
> >     they aren't able to advertise the Common configuration capability.
> >     As most PCI endpoint capable PCIe controllers do not allow modifying the
> >     capability list, and thus are unable to advertise the Common configuration
> >     capability. This means the device's inbound TLPs fault on the host
> >     SMMU because the vring descriptors carry raw physical addresses.
> > 
> >     This series adds a quirk that forces a subset of legacy virtio devices
> >     to use the DMA Map API (vring_use_map_api() will return true),
> >     which fixes this issue.
> > 
> >     It's unideal that we have to hard code a quirk to basically just
> >     advertise the VIRTIO_F_ACCESS_PLATFORM feature, but (see 1) as we
> >     are stuck with legacy virtio devices there isn't much else we can do.
> > 
> >  2. We have to pin scsit_pci_epf_poll_cfg_thread() on a CPU in order to
> >     respond fast enough to the host. This means we effectivly burn a CPU
> >     to read and write some values. But as there are no intterupts
> >     generated on these events and we need to be very quick there isn't
> >     another option.
> > 

Most of these pain points will go away if you use virtio-msg [1] transport
instead of the virtio-pci transport. Using the virtio-pci transport on a real
PCIe device without a way to trap and emulate the config space requests will
always be racy.

- Mani

[1] https://lore.kernel.org/virtio-comment/cover.1781514628.git.bertrand.marquis@arm.com

-- 
மணிவண்ணன் சதாசிவம்
