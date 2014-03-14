From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v17 3/4] ata: Add APM X-Gene SoC AHCI SATA host controller driver
Date: Fri, 14 Mar 2014 22:06:36 +0100
Message-ID: <201403142206.36611.arnd@arndb.de>
References: <1394655573-32645-1-git-send-email-lho@apm.com> <201403142005.52991.arnd@arndb.de> <CAPw-ZT=1KWEowD_i=qoWwg372XdzC4p227rpNo7ov+NwOYFUDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPw-ZT=1KWEowD_i=qoWwg372XdzC4p227rpNo7ov+NwOYFUDA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Cc: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>, Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Friday 14 March 2014, Loc Ho wrote:
> Hi,
> 
> >> > gets called. Can you clarify what this register access does?
> >> > If it's just setting a index into a mux output, would it make
> >> > sense to have an optional DT property containing an integer with
> >> > the mux setting you want to set? That way you wouldn't even
> >> > have to have two compatible strings but just do
> >> >
> >> >         ret = of_property_read_u32(node, "apm,ahci-mux", &mux);
> >> >         if (!ret)
> >> >                 xgene_ahci_mux_select(ctx, mux);
> >> >
> >>
> >> Given that fact that I will break up the resource. Let's just use the
> >> resource for the MUX to handle this. For the IP that doesn't existed,
> >> I will just not list it.
> >
> > Ah, that sounds good. It also means that if the firmware has set up
> > the mux already, you don't have to touch it again. That would probably
> > be the preferred case.
> >
> > I'm undecided about the value that you write in there. That could either
> > be passed through DT as I suggested above for extra flexibility, or you
> > can keep it hardcoded if you are absolutely sure that there will never
> > need to be a case where you have to set it to something other than '1',
> 
> It is only a mux between two IP's. Writing 1 is fine. For ACPI, it can
> be missing and handled by the firmware or can be handled just like the
> DTS way.

Why can't you have it handled by the firmware in the DTS case?

I still think it's rather unlikely that we will actually see ACPI support
on your platform, btw.

I'm willing to look at the patches you need for it, but I'm not very
optimistic, in particular because of the kind of hacks you need
for random bits of hardware.

> > Is there also an IOMMU, or just the PIM? If there is no IOMMU,
> > we will actually have to use the swiotlb code here, otherwise we
> > can rely on the IOMMU to do the translation so we can pretend that
> > there is always 64-bit DMA capability.
> >
> > In theory, the PIM could be dynamically reprogrammed for each
> > DMA, as an extremely primitive IOMMU implementation, but I don't
> > know what the impact on performance would be from doing that.
> > It would also prevent you from starting multiple concurrent DMAs,
> > although I suspect that is not an important case for SPI and SDIO.
> 
> This first generation don't support IOMMU and rely on swiotlb. In any
> case, for SDIO, the solution is to reprogram the PIM and limit to SDMA
> - single buffer - for each operation.

Ok, interesting. In that case, I suppose the DMA mask is actually 64-bit.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
