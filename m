From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg
 list 	with different entry count [map count=13] [unmap count=10]
Date: Thu, 04 Jun 2009 10:15:14 +0300
Message-ID: <4A277482.5070909@panasas.com>
References: <64bb37e0906031230m22234268k9fdcd43dc1d35f18@mail.gmail.com>	<20090604090218Z.fujita.tomonori@lab.ntt.co.jp>	<64bb37e0906032312i5f6906dehc0f8dd4e748254a2@mail.gmail.com> <20090604153253B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:21791
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751935AbZFDHa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2009 03:30:29 -0400
In-Reply-To: <20090604153253B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: just.for.lkml@googlemail.com, hancockrwd@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 06/04/2009 09:33 AM, FUJITA Tomonori wrote:
> On Thu, 4 Jun 2009 08:12:34 +0200
> Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> 
>> On Thu, Jun 4, 2009 at 2:02 AM, FUJITA Tomonori
>> <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> On Wed, 3 Jun 2009 21:30:32 +0200
>>> Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
>>>> Still happens with 2.6.30-rc8 (see trace at the end of the email)
>>>>
>>>> As orig_n_elem is only used two times in libata-core.c I suspected a
>>>> corruption of the qc->sg, but adding checks for this did not trigger.
>>>> So I looked into lib/dma-debug.c.
>>>> It seems add_dma_entry() does not protect against adding the same
>>>> entry twice.
>>> Do you mean that add_dma_entry() doesn't protect against adding a new
>>> entry identical to the existing entry, right?
>> Yes, as I read the hash bucket code in lib/dma-debug.c a second entry
>> from the same device and the same address will just be added to the
>> list and on unmap it will always return the first entry.
> 
> It means that two different DMA operations will be performed against
> the same dma addresss on the same device at the same time. It doesn't
> happen unless there is a bug in a driver, an IOMMU or somewhere, as I
> wrote in the previous mail.
> 

What about the draining buffers used by libata. Are they not the same buffer
for all devices for all requests?

> 
>>> Then it's not a
>>> dma-debug bug (it might be better for dma-debug to check it though),
>>> that is, such situation should not happen.
>> At least the warning about the wrong unmap count is a bug in the
>> dma-debug, as that is not what happens on my system.
>>
>>> Probably, it's an IOMMU bug
>>> or a driver bug.
>> Could it be just a forgotten unmap?
>> That would leave the old entry in the dma-debug list, but from the
>> driver side it would be valid to map the same place again without
>> corrupting any data transfer to the harddisk.
> 
> Yeah, I thought about this possibility. However, you use GART IOMMU,
> right (you can see "PCI-DMA: using GART IOMMU." in a boot message if
> so)? If you use GART IOMMU, unmapped addresses are not reused.
> 
> 
>> What also would point in this direction, sometime I have seen this in my log:
>> [ 1004.061989] DMA-API: debugging out of memory - disabling
> 
> Sounds like there is a leak...

Boaz
