Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC1178F2F;
	Fri,  4 Sep 2026 00:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788480737; cv=none; b=dUynHvc1wK0GRPFuMe4B2JuSYLMsUnWe2BQ+ZmaWVffNBppFfGxLn5omDXPuBqicu9ugq7xoTj78UKiongKGBM5XnMHEBwULtilDOAOfB3fZiBK6bviJjOjiqbMNBADoN5iZFgGidNwYkQ2IQQp6rjlhkB1amCyj3IVRiALn41w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788480737; c=relaxed/simple;
	bh=1oje6I6cprMjdcZ3w+KgH6EanbVWQeayLSc3PmDGyL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tOd39DrQuyQl91FsTprbMOGzFSNl6nT8Zbh8CfsfbuAIjrWJJnqcpp2V2XMS9ulm2vXpObb4o/7eoIA7iV6S/P/lrbxQJnCq6rno4iouKbLnuvQnBLu/nhfmHnMJbXKBmW2baMDlDHKDqC0cMfW/dm3iSeXQX5Oczt+XgALldgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XW9ZtjJd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XW9ZtjJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0081F000E9;
	Fri,  4 Sep 2026 00:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788480736;
	bh=uwU9myAIHfxtIC/MA9ZCvJe1sgh7d4K5eTnJj1GTYxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XW9ZtjJdCEfhzI3DxWMXkt9DtZEB/PYWe755TnnZH/tac17RQJCHcrDOy1PTtv0Wo
	 BbVOQriqqG6KoM1atfZmXUpQV9Oh9vyOoi8QisKTUV2eCe+A+qDkQcB3nYS6J+c5kj
	 GygJk2zJqUKYukpQqfDZqWvtEYGznn53rUeWTfkNNFy14OnDZC6FUMTKufgeP8W+Nn
	 ahCExJ+/ST1mem1vNNM+HLCEQ5wLZzHSdwmT2+D0vkEqu8UWhzpSu7hnbEHwXW24JY
	 6ujse3Q2i8z3fZ3GfubUaORUT1JqibaBOq8g/8xfYlirIP6vkWt2LwfgdqhKABykOs
	 BS3hYKU5XOFhg==
Message-ID: <795ac93a-9377-4503-9dc4-58f21c815f71@kernel.org>
Date: Fri, 4 Sep 2026 09:12:11 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
To: Manivannan Sadhasivam <mani@kernel.org>, Niklas Cassel <cassel@kernel.org>
Cc: alistair23@gmail.com, mst@redhat.com, eperezma@redhat.com,
 linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
 jasowangio@gmail.com, linux-scsi@vger.kernel.org, mkp@kernel.org,
 virtualization@lists.linux.dev, James.Bottomley@hansenpartnership.com,
 alistair@alistair23.me, Alistair Francis <alistair.francis@wdc.com>,
 linux-pci@vger.kernel.org, Shunsuke Mie <mie@igel.co.jp>,
 Frank Li <Frank.Li@kernel.org>, Koichiro Den <den@valinux.co.jp>,
 Kishon Vijay Abraham I <kishon@kernel.org>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
 <apaOZeeDBIRlpB7b@ryzen>
 <akvzpivrbg3b3jra6ibga6j637pwqkwnnzs6q2ymcn5ixrdym6@wniqpspkcknt>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <akvzpivrbg3b3jra6ibga6j637pwqkwnnzs6q2ymcn5ixrdym6@wniqpspkcknt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/3/26 20:51, Manivannan Sadhasivam wrote:
> On Tue, Sep 01, 2026 at 10:35:49AM +0200, Niklas Cassel wrote:
>> On Tue, Sep 01, 2026 at 11:46:48AM +1000, alistair23@gmail.com wrote:
>>> From: Alistair Francis <alistair.francis@wdc.com>
>>>
>>> This series adds a VirtIO SCSI endpoint built on top of the VirtIO PCIe
>>> endpoint. This is a similar approach to the NVMe PCIe Endpoint
>>> (drivers/nvme/target/pci-epf.c) but for SCSI.
>>>
>>> This does end up being somewhat similar to the pci-epf.c code, but
>>> re-written for SCSI.
>>>
>>> This approach allows a PCIe Endpoint device (tested on a
>>> radxa-rock5b) to setup what appears to be a SCSI device, using an
>>> existing SCSI backend (tested using scsi_debug).
>>>
>>> At this point a host can connect over PCIe, ensure virtio_pci and
>>> virtio_scsi is loaded and on PCIe rescan will see a scsi device.
>>>
>>> There are a few pain points with this approach though:
>>>  1. We have to use the Legacy SCSI VirtIO driver. This is because the
>>>     Raxda Rock5b (and AFAIK all PCIe Endpoint hardware) can't add
>>>     capabilities. So we can't advertise the VirtIO Common configuration
>>>     capability, which means we can't be a modern VirtIO SCSI device.
>>>
>>>     This is unfortunate, but there doesn't seem to be any way around
>>>     this, at least with the current hardware.
>>>
>>>  1.2. Legacy virtio devices only have 32 feature bits and therefore can't
>>>     set the VIRTIO_F_ACCESS_PLATFORM (bit 33) feature. This means the
>>>     vring_use_map_api() function will return false.
>>>
>>>     Currently Linux endpoint devices use the legacy virtio interface as
>>>     they aren't able to advertise the Common configuration capability.
>>>     As most PCI endpoint capable PCIe controllers do not allow modifying the
>>>     capability list, and thus are unable to advertise the Common configuration
>>>     capability. This means the device's inbound TLPs fault on the host
>>>     SMMU because the vring descriptors carry raw physical addresses.
>>>
>>>     This series adds a quirk that forces a subset of legacy virtio devices
>>>     to use the DMA Map API (vring_use_map_api() will return true),
>>>     which fixes this issue.
>>>
>>>     It's unideal that we have to hard code a quirk to basically just
>>>     advertise the VIRTIO_F_ACCESS_PLATFORM feature, but (see 1) as we
>>>     are stuck with legacy virtio devices there isn't much else we can do.
>>>
>>>  2. We have to pin scsit_pci_epf_poll_cfg_thread() on a CPU in order to
>>>     respond fast enough to the host. This means we effectivly burn a CPU
>>>     to read and write some values. But as there are no intterupts
>>>     generated on these events and we need to be very quick there isn't
>>>     another option.
>>>
> 
> Most of these pain points will go away if you use virtio-msg [1] transport
> instead of the virtio-pci transport. Using the virtio-pci transport on a real
> PCIe device without a way to trap and emulate the config space requests will
> always be racy.

There is nothing inherently racy about the config space. It is about the fact
that most PCI endpoint controllers:
1) Do not raise an interrupt when PCI BARs or config space is written by the
host RC, and
2) All PCI endpoint controllers that Linux supports do not allow drivers to
create extended capabilities in the config space that can then be emulated in
the endpoint driver (enabling that would require 1 to be supported, obviously).

(2) can be delt with quirks. Not great, but simple enough. And in this case, we
need it more because of the virtio-pci specs, which are not great to start with.

And for (1), the only real problem that causes is that an endpoint driver needs
to poll PCI BARs/submission queues to see if the host issued commands. Again not
great, but that works just fine. Alistair's point about burning a CPU doing that
is simply so that we can reduce command latency and get good enough performance.

We went through all of that already with the NVMe PCI endpoint. Works well
enough and does what is intended, which is the same here for the virtio-scsi
endpoint driver: create a platform where one can emulate a SCSI device to
experiment with new features etc. This is all intended as a development/test
tool, not for production use.

I do not know virtio-msg. First time I hear about it. And I am not sure if there
is a standard way of exposing a SCSI host through that.


-- 
Damien Le Moal
Western Digital Research
