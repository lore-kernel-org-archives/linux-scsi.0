From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg list
	with different entry count [map count=13] [unmap count=10]
Date: Thu, 4 Jun 2009 20:07:36 +0200
Message-ID: <64bb37e0906041107i18faee5etd6dbb05838740bed@mail.gmail.com>
References: <64bb37e0906032312i5f6906dehc0f8dd4e748254a2@mail.gmail.com>
	 <20090604153253B.fujita.tomonori@lab.ntt.co.jp>
	 <4A277482.5070909@panasas.com>
	 <20090604164418F.fujita.tomonori@lab.ntt.co.jp>
	 <20090604075309.GU11363@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52678 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZFDSHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2009 14:07:36 -0400
In-Reply-To: <20090604075309.GU11363@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com, hancockrwd@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 4, 2009 at 9:53 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Jun 04 2009, FUJITA Tomonori wrote:
>> On Thu, 04 Jun 2009 10:15:14 +0300
>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> > On 06/04/2009 09:33 AM, FUJITA Tomonori wrote:
>> > > On Thu, 4 Jun 2009 08:12:34 +0200
>> > > Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
>> > >
>> > >> On Thu, Jun 4, 2009 at 2:02 AM, FUJITA Tomonori
>> > >> <fujita.tomonori@lab.ntt.co.jp> wrote:
>> > >>> On Wed, 3 Jun 2009 21:30:32 +0200
>> > >>> Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
>> > >>>> Still happens with 2.6.30-rc8 (see trace at the end of the email)
>> > >>>>
>> > >>>> As orig_n_elem is only used two times in libata-core.c I suspected a
>> > >>>> corruption of the qc->sg, but adding checks for this did not trigger.
>> > >>>> So I looked into lib/dma-debug.c.
>> > >>>> It seems add_dma_entry() does not protect against adding the same
>> > >>>> entry twice.
>> > >>> Do you mean that add_dma_entry() doesn't protect against adding a new
>> > >>> entry identical to the existing entry, right?
>> > >> Yes, as I read the hash bucket code in lib/dma-debug.c a second entry
>> > >> from the same device and the same address will just be added to the
>> > >> list and on unmap it will always return the first entry.
>> > >
>> > > It means that two different DMA operations will be performed against
>> > > the same dma addresss on the same device at the same time. It doesn't
>> > > happen unless there is a bug in a driver, an IOMMU or somewhere, as I
>> > > wrote in the previous mail.
>> > >
>> >
>> > What about the draining buffers used by libata. Are they not the same buffer
>> > for all devices for all requests?
>>
>> I'm not sure if the drain buffer is used like that. But is there
>> easier ways to see the same buffer; e.g. sending the same buffer twice
>> with DIO?
>
> I'm pretty sure we discussed this some months ago, the intel iommu
> driver had a similar bug iirc. Lets say you want to write the same 4kb
> block to two spots on the disk. You prepare and submit that with
> O_DIRECT and using aio. On a device with NCQ, that could easily map the
> same page twice. Or, perhaps more likely, doing 512b writes and not
> getting all of them merged.

I have a even better theory: RAID1
There are two disk on this sil24 controller that are uses as an RAID1
to form my root partition.

That also fits the pattern of the very large number of duplicate dma
mappings (as each data block needs to be written twice), but that the
DMA-API debug check only triggers during heavier load: Most of the
time both drives are in sync and so the write request should be
idential, so it does not matter which entry gets returned from the
hash bucket.
But when I run 'updatedb' to trigger this error the read request
disturb the pattern and the write requests also become asymetric.

>> As I wrote, I assume that he uses GART IOMMU;

[    0.010000] Checking aperture...
[    0.010000] No AGP bridge found
[    0.010000] Node 0: aperture @ a7f0000000 size 32 MB
[    0.010000] Aperture beyond 4GB. Ignoring.
[    0.010000] Your BIOS doesn't leave a aperture memory hole
[    0.010000] Please enable the IOMMU option in the BIOS setup
(sadly my BIOS does not have such an option...)
[    0.010000] This costs you 64 MB of RAM
[    0.010000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.010000] Memory: 4057512k/4718592k available (4674k kernel code,
524868k absent, 136212k reserved
, 2520k data, 1172k init)
[snip]
[    1.304386] DMA-API: preallocated 32768 debug entries
[    1.309439] DMA-API: debugging enabled by kernel config
[    1.310123] PCI-DMA: Disabling AGP.
[    1.313711] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    1.320002] PCI-DMA: using GART IOMMU.
[    1.323763] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.330640] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.340007] hpet0: 3 comparators, 32-bit 25.000000 MHz counter

>> it allocates an unique
>> dma address per dma mapping operation.
>>
>> However, dma-debug is broken wrt this, I guess.
>
> Seems so.

Yes, as the md code for RAID1 has a very good cause to send the same
memory page twice to this device.

Torsten
