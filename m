Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EECB477E57;
	Tue,  1 Sep 2026 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788254427; cv=none; b=lS+Z6t38T+pUGJNtzypx6rU9zlrClD0Qu8MPn969PLyompZpywznFc2FB8pEO8bc4NwVbiI2TUbOUyMJ4wi+I+I/g5znVo8t9DcTDXzBLdRzjUNKvLmBAwGDoRHNJjfNy3d/DYaNhaDhLHbNSorkssUUi10B51OrYJBs8088lLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788254427; c=relaxed/simple;
	bh=kRNrpV9Qtb2KPukdb6FfJmMDZD3CDoID1G7CWMaZfks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WBWCbSxhqpqI9BEQ90elUJjtePFFiW46za0sUbw5WLlOGBsFRgw1RYqyjP4EuK+70Pl50seAhYotfGmu6bN+XcpqwsMtif7oVmhrDvSP21gTT7syba6GCCOKSEaqfHnzLx6Zc2HHAlLzubujlzYQtIaoQFKCpe+/KiSwVNRcvrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaQqQw2e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaQqQw2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A1D1F000E9;
	Tue,  1 Sep 2026 09:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788254424;
	bh=35Tx3royXPUKEF43VkKTfP2g18QlbFqFvTcvVm8nuoU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gaQqQw2eJ5S8C1pKLjoWgDRUat8f5urE4BUokfAM5DJLQlYigA/3eyhJqTRhiiXo3
	 giDK0j2odLLC4wpK+Y2c5muJPpMxQruexSpQqEqXPUL5zOqPUu01YMAWaXKDH3Plg/
	 PyeRYSVawrJ+Rtujz6d/KAwWJaw6wVGoGw9P/R4D7vmJMxcjaFMfBRGzSLP+4O3dli
	 b1jPZ32tT88GbYBYr7z25ham9/t049q1AdFuAimu31u5PAh5KMuzUkAaINqQ9tEO9g
	 vQzXjCMhp0z2VZEkY7mmuJ+zKYDIFezc+g6vGMsw+g8fkiS0aTCMUYkVLorBVADtpC
	 C0Wqg5JMXi92Q==
Message-ID: <22635679-cc41-4214-a208-f3ecfcc8af81@kernel.org>
Date: Tue, 1 Sep 2026 18:20:21 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
To: alistair23@gmail.com, mst@redhat.com, eperezma@redhat.com,
 linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
 jasowangio@gmail.com, linux-scsi@vger.kernel.org, mkp@kernel.org,
 virtualization@lists.linux.dev, James.Bottomley@HansenPartnership.com
Cc: alistair@alistair23.me, Alistair Francis <alistair.francis@wdc.com>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260901014650.2728658-1-alistair.francis@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/1/26 10:46, alistair23@gmail.com wrote:
> From: Alistair Francis <alistair.francis@wdc.com>
> 
> This series adds a VirtIO SCSI endpoint built on top of the VirtIO PCIe
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
> There are a few pain points with this approach though:
>  1. We have to use the Legacy SCSI VirtIO driver. This is because the
>     Raxda Rock5b (and AFAIK all PCIe Endpoint hardware) can't add
>     capabilities. So we can't advertise the VirtIO Common configuration
>     capability, which means we can't be a modern VirtIO SCSI device.
> 
>     This is unfortunate, but there doesn't seem to be any way around
>     this, at least with the current hardware.
> 
>  1.2. Legacy virtio devices only have 32 feature bits and therefore can't
>     set the VIRTIO_F_ACCESS_PLATFORM (bit 33) feature. This means the
>     vring_use_map_api() function will return false.
> 
>     Currently Linux endpoint devices use the legacy virtio interface as
>     they aren't able to advertise the Common configuration capability.
>     As most PCI endpoint capable PCIe controllers do not allow modifying the
>     capability list, and thus are unable to advertise the Common configuration
>     capability. This means the device's inbound TLPs fault on the host
>     SMMU because the vring descriptors carry raw physical addresses.
> 
>     This series adds a quirk that forces a subset of legacy virtio devices
>     to use the DMA Map API (vring_use_map_api() will return true),
>     which fixes this issue.
> 
>     It's unideal that we have to hard code a quirk to basically just
>     advertise the VIRTIO_F_ACCESS_PLATFORM feature, but (see 1) as we
>     are stuck with legacy virtio devices there isn't much else we can do.
> 
>  2. We have to pin scsit_pci_epf_poll_cfg_thread() on a CPU in order to
>     respond fast enough to the host. This means we effectivly burn a CPU
>     to read and write some values. But as there are no intterupts
>     generated on these events and we need to be very quick there isn't
>     another option.
> 
> With two Raxda Rock5bs connected together and the IOMMU turned off I see
> performance numbers like this
> 
> root@radxa-rock5b:~# fio-test.sh /dev/sda
> Running on /dev/sda...
>   Rnd read,    4KB,  QD=1, 1 job :  IOPS=223, BW=895KiB/s (917kB/s)
>   Rnd read,    4KB, QD=32, 1 job :  IOPS=7415, BW=29.0MiB/s (30.4MB/s)
>   Rnd read,    4KB, QD=32, 4 jobs:  IOPS=20.2k, BW=79.0MiB/s (82.8MB/s)
>   Rnd read,  128KB,  QD=1, 1 job :  IOPS=213, BW=26.7MiB/s (28.0MB/s)
>   Rnd read,  128KB, QD=32, 1 job :  IOPS=1482, BW=185MiB/s (194MB/s)
>   Rnd read,  128KB, QD=32, 4 jobs:  IOPS=2599, BW=325MiB/s (341MB/s)
>   Rnd read,  512KB,  QD=1, 1 job :  IOPS=184, BW=92.1MiB/s (96.6MB/s)
>   Rnd read,  512KB, QD=32, 1 job :  IOPS=1079, BW=540MiB/s (566MB/s)
>   Rnd read,  512KB, QD=32, 4 jobs:  IOPS=1284, BW=642MiB/s (674MB/s)
>   Rnd write,   4KB,  QD=1, 1 job :  IOPS=222, BW=889KiB/s (911kB/s)
>   Rnd write,   4KB, QD=32, 1 job :  IOPS=7433, BW=29.0MiB/s (30.4MB/s)
>   Rnd write,   4KB, QD=32, 4 jobs:  IOPS=20.3k, BW=79.1MiB/s (83.0MB/s)
>   Rnd write, 128KB,  QD=1, 1 job :  IOPS=203, BW=25.5MiB/s (26.7MB/s)
>   Rnd write, 128KB, QD=32, 1 job :  IOPS=1521, BW=190MiB/s (199MB/s)
>   Rnd write, 128KB, QD=32, 4 jobs:  IOPS=2927, BW=366MiB/s (384MB/s)
>   Seq read,  128KB,  QD=1, 1 job :  IOPS=207, BW=25.9MiB/s (27.2MB/s)
>   Seq read,  128KB, QD=32, 1 job :  IOPS=1538, BW=192MiB/s (202MB/s)
>   Seq read,  512KB,  QD=1, 1 job :  IOPS=183, BW=91.7MiB/s (96.2MB/s)
>   Seq read,  512KB, QD=32, 1 job :  IOPS=1356, BW=678MiB/s (711MB/s)
>   Seq read,    1MB, QD=32, 1 job :  IOPS=646, BW=647MiB/s (678MB/s)
>   Seq write, 128KB,  QD=1, 1 job :  IOPS=209, BW=26.1MiB/s (27.4MB/s)
>   Seq write, 128KB, QD=32, 1 job :  IOPS=1576, BW=197MiB/s (207MB/s)
>   Seq write, 512KB,  QD=1, 1 job :  IOPS=166, BW=83.3MiB/s (87.4MB/s)
>   Seq write, 512KB, QD=32, 1 job :  IOPS=891, BW=446MiB/s (468MB/s)
>   Seq write,   1MB, QD=32, 1 job :  IOPS=539, BW=540MiB/s (566MB/s)
>   Rnd rdwr, 4K..1MB, QD=8, 4 jobs:  IOPS=453, BW=228MiB/s (239MB/s)
>  IOPS=478, BW=241MiB/s (253MB/s)
> 
> claude-opus-4-8 was used to parse the crash dumps and IOMMU faults
> during testing to narrow down where issues where are how to fix them
> 
> Alistair Francis (2):
>   virtio_pci: Add a quirk to force DMA Map API for certain legacy
>     devices
>   scsi: Initial commit of VirtIO PCIe Endpoint Driver
> 
>  drivers/scsi/Kconfig               |   12 +
>  drivers/scsi/Makefile              |    1 +
>  drivers/scsi/virtio-scsi-pci-epf.c | 3099 ++++++++++++++++++++++++++++
>  drivers/virtio/virtio_pci_legacy.c |   27 +
>  drivers/virtio/virtio_ring.c       |    7 +
>  include/linux/virtio.h             |    5 +
>  6 files changed, 3151 insertions(+)
>  create mode 100644 drivers/scsi/virtio-scsi-pci-epf.c

We need this documented too, with a reference to it in the PCI/endpoint
documentation.
See Documentation/PCI/endpoint/index.rst for what I did for the nvme endpoint
driver, with the main documentation for that driver in
Documentation/nvme/nvme-pci-endpoint-target.rst.

For this one, maybe add a similar file under Documentation/scsi ?


-- 
Damien Le Moal
Western Digital Research
