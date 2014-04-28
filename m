From: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Subject: Re: [PATCH v18 3/4] ata: Add APM X-Gene SoC AHCI SATA host controller driver
Date: Mon, 28 Apr 2014 16:12:02 -0700
Message-ID: <CAPw-ZTmGA5rtVmHx5jZedkey2iJD7L+3-905W=4G4rAJ=BeWgA@mail.gmail.com>
References: <1394841201-29495-1-git-send-email-lho@apm.com>
	<1394841201-29495-3-git-send-email-lho@apm.com>
	<1394841201-29495-4-git-send-email-lho@apm.com>
	<201403151019.49316.arnd@arndb.de>
	<CAPw-ZTksg3z8GY55jb7-yP1wfq2BF6apB9KBgbokpshKbiiAaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPw-ZTksg3z8GY55jb7-yP1wfq2BF6apB9KBgbokpshKbiiAaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>, balbi-l0cyMroinI0@public.gmane.org
Cc: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>, Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Kishon/Felipe,

> >> This patch adds support for the APM X-Gene SoC AHCI SATA host controller
> >> driver. It requires the corresponding APM X-Gene SoC PHY driver. This
> >> initial version only supports Gen3 speed.
> >
> > This version seems workable, thanks for the quick follow-up.
> >
> > The comment about Gen3 speed above reminds me that you took some
> > shortcuts to get here and you removed support for some features
> > as well as some bug workarounds in the process. I'm guessing some
> > of them won't be necessary because they are only for prototype
> > hardware or for early boot loader versions that don't yet set up
> > the hardware right, but others actually need to come back.
> >
> > That is usually a good approach, but I'd also like to make sure we can
> > deal with them nicely when you have to add them back later, and don't
> > have to add ugly extensions to the DT binding to support the old dtb
> > files.
> >
> > Can you list (also in the changelog) the parts of the driver that you
> > have taken out for now and that you expect to add back at later
> > stage? I think that would be helpful for perspective.
> >
>
> Here is an list of patches that we will be preparing for once the
> basic driver is completed. Do you want me to re-generate the patch
> change log with this info?
>
> 1. Support for Gen1/Gen2/Gen3
> Solution: The simplest solution is to have the PHY framework support
> setting the desire speed. I had argued with the TI folks but they are
> reluctant to add this function to the framework. They argued that this
> is still not generic enough. I will start the discussion again later
> on. The other possibility (but not sure if this is doable) is to have
> the PHY init function to be smarter and do the necessary operation
> assuming the underlying PHY is capable in detecting the link up speed.
> I will need to check the spec of this.


In order for the X-Gene SATA PHY to support SATA Gen1 and Gen2 speed,
we need an method to instruct the underlying PHY driver to switch to
an specified setting after link up. For this errata, Suman Tripathi
had submitted the patch [1]. It is not possible to hide this within
the PHY driver. Each instance of the PHY driver controls two ports. By
calling the exit function and then init function, it will affect the
other ports - which is not the correct behavior. At this point, we
don't see any solution besides introduce an PHY framework function
set_rate. Can you let us know if this solution is acceptable?

[1] https://lkml.org/lkml/2014/4/18/491

-Loc
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
