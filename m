From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v17 3/4] ata: Add APM X-Gene SoC AHCI SATA host controller driver
Date: Fri, 14 Mar 2014 13:27:23 -0700
Message-ID: <CAPw-ZT=1KWEowD_i=qoWwg372XdzC4p227rpNo7ov+NwOYFUDA@mail.gmail.com>
References: <1394655573-32645-1-git-send-email-lho@apm.com>
	<201403141241.16599.arnd@arndb.de>
	<CAPw-ZTnVE0B+hJKGX=EPP5mjoA7-diTvi9hxNhBuAFL2hANz+Q@mail.gmail.com>
	<201403142005.52991.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:39161 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754963AbaCNU1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2014 16:27:24 -0400
Received: by mail-qc0-f169.google.com with SMTP id i17so3532415qcy.28
        for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2014 13:27:23 -0700 (PDT)
In-Reply-To: <201403142005.52991.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

>> > gets called. Can you clarify what this register access does?
>> > If it's just setting a index into a mux output, would it make
>> > sense to have an optional DT property containing an integer with
>> > the mux setting you want to set? That way you wouldn't even
>> > have to have two compatible strings but just do
>> >
>> >         ret = of_property_read_u32(node, "apm,ahci-mux", &mux);
>> >         if (!ret)
>> >                 xgene_ahci_mux_select(ctx, mux);
>> >
>>
>> Given that fact that I will break up the resource. Let's just use the
>> resource for the MUX to handle this. For the IP that doesn't existed,
>> I will just not list it.
>
> Ah, that sounds good. It also means that if the firmware has set up
> the mux already, you don't have to touch it again. That would probably
> be the preferred case.
>
> I'm undecided about the value that you write in there. That could either
> be passed through DT as I suggested above for extra flexibility, or you
> can keep it hardcoded if you are absolutely sure that there will never
> need to be a case where you have to set it to something other than '1',

It is only a mux between two IP's. Writing 1 is fine. For ACPI, it can
be missing and handled by the firmware or can be handled just like the
DTS way.

>
>> > > +     /*
>> > > +      * Can't use devm_ioremap_resource due to overlapping region.
>> > > +      * 0xYYYY.0000 - host core
>> > > +      * 0xYYYY.7000 - Mux (if applicable)
>> > > +      * 0xYYYY.A000 - PHY indirect access
>> > > +      * 0xYYYY.C000 - Clock
>> > > +      * 0xYYYY.D000 - RAM shutdown removal
>> > > +      * As we map the entire region as one, it overlaps with the PHY driver.
>> > > +      */
>> > > +     ctx->csr_base = devm_ioremap(dev, res->start, resource_size(res));
>> > > +     if (!ctx->csr_base) {
>> > > +             dev_err(dev, "can't map %pR\n", res);
>> > > +             return -ENOMEM;
>> > > +     }
>> >
>> > I still think we should try not to have overlapping memory areas here.
>> > Could you split up the registers into another range in the reg property
>> > to leave the PHY registers out?
>>
>> Let me do this:
>>
>> 1. One resource for the RAM shutdown
>> 2. One resource for the host controller
>> 3. One optional resource for the MUX if needed.
>>
>> With #3, this also solved the MUX detection and avoid having another
>> node "apm,ahci-mux".
>
> My suggestion was not to have another device node, just a property that
> contains a value to be written into the mux register if present.
>
>> > Also, please read the thread named "[PATCH 0/7] of: setup dma
>> > parameters using dma-ranges and dma-coherent" and comment there
>> > about what you think we should do here. I assume we will have to
>> > add "dma-ranges" properties in a number of places to get this
>> > all to work fine any 64-bit SoC. Do you know if you have any
>> > DMA master devices in x-gene that are not 64-bit capable?
>> >
>>
>> I will read and follow later. We do have non-64-bit devices such as
>> SDIO and SPI. But these IP's have translation in the bus similar to
>> PCIe PIM.
>
> Is there also an IOMMU, or just the PIM? If there is no IOMMU,
> we will actually have to use the swiotlb code here, otherwise we
> can rely on the IOMMU to do the translation so we can pretend that
> there is always 64-bit DMA capability.
>
> In theory, the PIM could be dynamically reprogrammed for each
> DMA, as an extremely primitive IOMMU implementation, but I don't
> know what the impact on performance would be from doing that.
> It would also prevent you from starting multiple concurrent DMAs,
> although I suspect that is not an important case for SPI and SDIO.

This first generation don't support IOMMU and rely on swiotlb. In any
case, for SDIO, the solution is to reprogram the PIM and limit to SDMA
- single buffer - for each operation.

-Loc
