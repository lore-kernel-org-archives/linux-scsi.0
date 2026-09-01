Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093753955C3;
	Tue,  1 Sep 2026 09:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788253443; cv=none; b=mtGTBNBNpmTu7qCjnj73hQlCGykHztnrjhoZdQIGTcZ58Te9xXvdZhEj/rptC1rdJUXECOYfX3lOM2VCtIrMC5KtE7Xyxu+Icd0B17VPeXqGjutwDf0dPo0enOv5D+Ezs98huG+lxTlI0KGKoL9z10mZXWFK5bS7fvqIkxd1QYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788253443; c=relaxed/simple;
	bh=gbRdi7x5euyd1idU4Oe5KtmUG/kGfIVOPnF86jvsO1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZvpGNYVctveZAfLWkxKMjiDZfqgIgxCfmbmVOkPV4o3dKLCdL1Y4l/d+80uzrB7Cu7pVRtDUCeSF2zPFavq7ZR8ZI6+fT8MuLhSyE3RbyCMFTcojP4m0uz1YY43x+Kt2/d9nYnx1XT1ciqep5W0Zv/ZqPePBq91I/bLZYE0o9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlyqKzj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlyqKzj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C001F000E9;
	Tue,  1 Sep 2026 09:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788253441;
	bh=n4jDt6DvrGcEdmaneGLqalWUgeKau8MsOp/T1T1IoOE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BlyqKzj5iXYYVHJUCAfCEJauzidAKdxejzLRRu3N6gkMKb66iR3I+dyjHOYz81Zxq
	 WfJPg72h3IUQUy0Lvq8uxHPJJsjhdQ74CAoJVAUDHj0IHWpveaarnDTtDx2IyPXhYo
	 9oD4ojNo0k0LRnZDg7yXuxrpUvD5gAREIORJfD1Pn0Nn+CTxcWxI3BM6cNEAyuba7v
	 O3lePR9S70i/AmlZGx6aw05vsXbm9a9aOcoWzdU/4hm2GKNgZMb47YrgpvaRcKdpLW
	 LfETwbhy7ZYJIrCP5FwDMy6GOmRgKhVa0LySLxIfjbK54X+BSJeaRAfLLkNg2WPoeJ
	 fAkdRpkXSllyA==
Date: Tue, 1 Sep 2026 11:03:56 +0200
From: Niklas Cassel <cassel@kernel.org>
To: alistair23@gmail.com
Cc: mst@redhat.com, eperezma@redhat.com, linux-kernel@vger.kernel.org,
	xuanzhuo@linux.alibaba.com, jasowangio@gmail.com,
	linux-scsi@vger.kernel.org, mkp@kernel.org,
	virtualization@lists.linux.dev,
	James.Bottomley@hansenpartnership.com, alistair@alistair23.me,
	Alistair Francis <alistair.francis@wdc.com>
Subject: Re: [PATCH 2/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
Message-ID: <apaU_L_hHZXxuB8e@ryzen>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
 <20260901014650.2728658-3-alistair.francis@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901014650.2728658-3-alistair.francis@wdc.com>

On Tue, Sep 01, 2026 at 11:46:50AM +1000, alistair23@gmail.com wrote:
> From: Alistair Francis <alistair.francis@wdc.com>
> 
> This patch adds a VirtIO SCSI endpoint build on top of the VirtIO PCIe
> endpoint. This is a similar approach to the NVMe PCIe Endpoint
> (drivers/nvme/target/pci-epf.c) but for SCSI.
> 
> This does end up being somewhat similar to the pci-epf.c code, but
> re-written for SCSI.
> 
> This approach allows a PCIe Endpoint device (tested on a
> radxa-rock5b) to setup what appears to be a SCSI device, using an
> existing SCSI backend (tested using scsi_debug).
> 
> At this point a host can connect over PCIe, ensure virtio_pci and
> virtio_scsi is loaded and on PCIe rescan will see a scsi device.
> 
> There are two main pain points with this approach though:
>  1. We have to use the Legacy SCSI VirtIO driver. This is because the
>     Raxda Rock5b (and AFAIK all PCIe Endpoint hardware) can't add
>     capabilities. So we can't advertise the VirtIO Common configuration
>     capability, which means we can't be a modern VirtIO SCSI device.
> 
>     This is unfortunate, but there doesn't seem to be any way around
>     this, at least with the current hardware.
> 
>  2. We have to pin scsit_pci_epf_poll_cfg_thread() on a CPU in order to
>     respond fast enough to the host. This means we effectivly burn a CPU
>     to read and write some values. But as there are no intterupts
>     generated on these events and we need to be very quick there isn't
>     another option.
> 
> Assisted-by: Devin:claude-opus-4-8
> Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
> ---

(snip)

> +static int scsit_pci_epf_dma_transfer(struct scsit_pci_epf *scsi_epf,
> +		struct scsit_pci_epf_segment *seg, enum dma_data_direction dir)
> +{
> +	struct pci_epf *epf = scsi_epf->epf;
> +	struct dma_async_tx_descriptor *desc;
> +	struct dma_slave_config sconf = {};
> +	struct device *dev = &epf->dev;
> +	struct device *dma_dev;
> +	struct dma_chan *chan;
> +	dma_cookie_t cookie;
> +	dma_addr_t dma_addr;
> +	struct mutex *lock;
> +	int ret;
> +
> +	switch (dir) {
> +	case DMA_FROM_DEVICE:
> +		lock = &scsi_epf->dma_rx_lock;
> +		chan = scsi_epf->dma_rx_chan;
> +		sconf.direction = DMA_DEV_TO_MEM;
> +		sconf.src_addr = seg->pci_addr;
> +		break;
> +	case DMA_TO_DEVICE:
> +		lock = &scsi_epf->dma_tx_lock;
> +		chan = scsi_epf->dma_tx_chan;
> +		sconf.direction = DMA_MEM_TO_DEV;
> +		sconf.dst_addr = seg->pci_addr;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(lock);

You should not need to take the mutex if you instead use the
dmaengine_prep_config_single_safe() API, see:
a0fba0a49f77 ("nvmet: pci-epf: Use dmaengine_prep_config_single_safe() API")


> +
> +	dma_dev = dmaengine_get_dma_device(chan);
> +	dma_addr = dma_map_single(dma_dev, seg->buf, seg->length, dir);
> +	ret = dma_mapping_error(dma_dev, dma_addr);
> +	if (ret)
> +		goto unlock;
> +
> +	ret = dmaengine_slave_config(chan, &sconf);
> +	if (ret) {
> +		dev_err(dev, "Failed to configure DMA channel\n");
> +		goto unmap;
> +	}
> +
> +	desc = dmaengine_prep_slave_single(chan, dma_addr, seg->length,
> +					   sconf.direction, DMA_CTRL_ACK);
> +	if (!desc) {
> +		dev_err(dev, "Failed to prepare DMA\n");
> +		ret = -EIO;
> +		goto unmap;
> +	}
> +
> +	cookie = dmaengine_submit(desc);
> +	ret = dma_submit_error(cookie);
> +	if (ret) {
> +		dev_err(dev, "Failed to do DMA submit (err=%d)\n", ret);
> +		goto unmap;
> +	}
> +
> +	if (dma_sync_wait(chan, cookie) != DMA_COMPLETE) {
> +		dev_err(dev, "DMA transfer failed\n");
> +		ret = -EIO;
> +	}
> +
> +	dmaengine_terminate_sync(chan);

I don't think dmaengine_terminate_sync() should be called on each DMA transfer, see:
bd00d2c4a1b2 ("nvmet: pci-epf: Remove unnecessary dmaengine_terminate_sync() on each DMA transfer")


Kind regards,
Niklas
