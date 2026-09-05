Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F71231836;
	Sat,  5 Sep 2026 15:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788623209; cv=none; b=qqIQATRwzAwFmGyYu/71oWshIqkUMPyl/Msd4J25mXbrGHg/pcOehSQXqIyH1IBoK0CV9lkz/mRoBOB9VSg1QUS3pPCUO1jzYbBJ5lRMIYhPrNYrbflJFoNTHEtxGJNtSr8ax39ko8GVVgPzj9d8rx8CY+YPTzzpDz5B2eIazAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788623209; c=relaxed/simple;
	bh=Wm4i3RlG+WiwpK0bIxp1LJWCbMunH4VFrRWPdQdxkJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vr1VXdtUq0Z8pIDXNdrA/usNC/cJhdoRzD5ymFUZwqd+IWdOJasu9h3BWo5sMe1yy0TTLxB9Gz7NZ9OxFxM9L1ZnP1VG1RtHpvjw/PC2dvVKdLkuMIn0q08bxJEef5QnhEr8l9VRCbYCSWLGXocFQbeY4sL612BfLFFaPsst5rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3nkgg5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3nkgg5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2311F00A3A;
	Sat,  5 Sep 2026 15:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788623207;
	bh=EWrtaZFF+hPliejaz2Y2aRmbyfVI9skekhB6+RxymI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c3nkgg5pVOSd4645yCWRUJ41AGgqSvr0H2xZ6SXJWZVZZz8xcVu5glh2+fwe86Yuv
	 Ke9cmlwKy2rFe/caIFOZZsH4jKMR8BoI7gBQnfWxwkGQKW4FKpTHiyDwLs2KIe5ccz
	 rE9oJK1YLeJwTLEq7CxAm4BIt0df5LT/mkfVfNomynsL1J4Jb9qQu9RXM3hMvQ8LjE
	 CDXJz1vpHlrLxcjHmGAdzl0VBdmx2VW/mfq00chqZpQd1X5tBl7ifHASmhSmJ27DA0
	 mz8GJtIU9dkwFMM14ngAR5W/ISWCiaMQQtBHSN0NlvOsjdf98FeXIZd1N0TQlC/uEx
	 YM2Qidx2s8FmQ==
Date: Sat, 5 Sep 2026 17:46:36 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>, alistair23@gmail.com, 
	mst@redhat.com, eperezma@redhat.com, linux-kernel@vger.kernel.org, 
	xuanzhuo@linux.alibaba.com, jasowangio@gmail.com, linux-scsi@vger.kernel.org, mkp@kernel.org, 
	virtualization@lists.linux.dev, James.Bottomley@hansenpartnership.com, alistair@alistair23.me, 
	Alistair Francis <alistair.francis@wdc.com>, linux-pci@vger.kernel.org, Shunsuke Mie <mie@igel.co.jp>, 
	Frank Li <Frank.Li@kernel.org>, Koichiro Den <den@valinux.co.jp>, 
	Kishon Vijay Abraham I <kishon@kernel.org>
Subject: Re: [PATCH 0/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
Message-ID: <iwgm2faqg2ame5wqaoajcgxxdbarjpczlwthkrgznybnc2xqmd@olscuoqftvdo>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
 <apaOZeeDBIRlpB7b@ryzen>
 <akvzpivrbg3b3jra6ibga6j637pwqkwnnzs6q2ymcn5ixrdym6@wniqpspkcknt>
 <795ac93a-9377-4503-9dc4-58f21c815f71@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <795ac93a-9377-4503-9dc4-58f21c815f71@kernel.org>

On Fri, Sep 04, 2026 at 09:12:11AM +0900, Damien Le Moal wrote:
> On 9/3/26 20:51, Manivannan Sadhasivam wrote:
> > On Tue, Sep 01, 2026 at 10:35:49AM +0200, Niklas Cassel wrote:
> >> On Tue, Sep 01, 2026 at 11:46:48AM +1000, alistair23@gmail.com wrote:
> >>> From: Alistair Francis <alistair.francis@wdc.com>
> >>>
> >>> This series adds a VirtIO SCSI endpoint built on top of the VirtIO PCIe
> >>> endpoint. This is a similar approach to the NVMe PCIe Endpoint
> >>> (drivers/nvme/target/pci-epf.c) but for SCSI.
> >>>
> >>> This does end up being somewhat similar to the pci-epf.c code, but
> >>> re-written for SCSI.
> >>>
> >>> This approach allows a PCIe Endpoint device (tested on a
> >>> radxa-rock5b) to setup what appears to be a SCSI device, using an
> >>> existing SCSI backend (tested using scsi_debug).
> >>>
> >>> At this point a host can connect over PCIe, ensure virtio_pci and
> >>> virtio_scsi is loaded and on PCIe rescan will see a scsi device.
> >>>
> >>> There are a few pain points with this approach though:
> >>>  1. We have to use the Legacy SCSI VirtIO driver. This is because the
> >>>     Raxda Rock5b (and AFAIK all PCIe Endpoint hardware) can't add
> >>>     capabilities. So we can't advertise the VirtIO Common configuration
> >>>     capability, which means we can't be a modern VirtIO SCSI device.
> >>>
> >>>     This is unfortunate, but there doesn't seem to be any way around
> >>>     this, at least with the current hardware.
> >>>
> >>>  1.2. Legacy virtio devices only have 32 feature bits and therefore can't
> >>>     set the VIRTIO_F_ACCESS_PLATFORM (bit 33) feature. This means the
> >>>     vring_use_map_api() function will return false.
> >>>
> >>>     Currently Linux endpoint devices use the legacy virtio interface as
> >>>     they aren't able to advertise the Common configuration capability.
> >>>     As most PCI endpoint capable PCIe controllers do not allow modifying the
> >>>     capability list, and thus are unable to advertise the Common configuration
> >>>     capability. This means the device's inbound TLPs fault on the host
> >>>     SMMU because the vring descriptors carry raw physical addresses.
> >>>
> >>>     This series adds a quirk that forces a subset of legacy virtio devices
> >>>     to use the DMA Map API (vring_use_map_api() will return true),
> >>>     which fixes this issue.
> >>>
> >>>     It's unideal that we have to hard code a quirk to basically just
> >>>     advertise the VIRTIO_F_ACCESS_PLATFORM feature, but (see 1) as we
> >>>     are stuck with legacy virtio devices there isn't much else we can do.
> >>>
> >>>  2. We have to pin scsit_pci_epf_poll_cfg_thread() on a CPU in order to
> >>>     respond fast enough to the host. This means we effectivly burn a CPU
> >>>     to read and write some values. But as there are no intterupts
> >>>     generated on these events and we need to be very quick there isn't
> >>>     another option.
> >>>
> > 
> > Most of these pain points will go away if you use virtio-msg [1] transport
> > instead of the virtio-pci transport. Using the virtio-pci transport on a real
> > PCIe device without a way to trap and emulate the config space requests will
> > always be racy.
> 
> There is nothing inherently racy about the config space. It is about the fact
> that most PCI endpoint controllers:
> 1) Do not raise an interrupt when PCI BARs or config space is written by the
> host RC, and
> 2) All PCI endpoint controllers that Linux supports do not allow drivers to
> create extended capabilities in the config space that can then be emulated in
> the endpoint driver (enabling that would require 1 to be supported, obviously).
> 
> (2) can be delt with quirks. Not great, but simple enough. And in this case, we
> need it more because of the virtio-pci specs, which are not great to start with.
> 
> And for (1), the only real problem that causes is that an endpoint driver needs
> to poll PCI BARs/submission queues to see if the host issued commands. Again not
> great, but that works just fine. Alistair's point about burning a CPU doing that
> is simply so that we can reduce command latency and get good enough performance.
> 
> We went through all of that already with the NVMe PCI endpoint. Works well
> enough and does what is intended, which is the same here for the virtio-scsi
> endpoint driver: create a platform where one can emulate a SCSI device to
> experiment with new features etc. This is all intended as a development/test
> tool, not for production use.
> 

The race is inherently present in the way the virtqueue setup is done. Spec
defines many registers with side-effects. Like device_feature_select,
device_status, queue_select, queue_reset etc... Fabricating responses for these
registers properly would require trap-and-emulate as the endpoint cannot
reliably generate the response, once written. It may work sometimes, but not
always.

> I do not know virtio-msg. First time I hear about it. And I am not sure if there
> is a standard way of exposing a SCSI host through that.
> 

virtio-msg is a message based transport, just like virtio-pci. It has no
knowledge of the top level Virtio protocol. Using it will eliminate all the
shortcomings of the virtio-pci transport as the config steps between the
driver and device is message-response based.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
