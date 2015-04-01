From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v1] ata: ahci_xgene: Add AHCI Support for second
 generation of APM X-Gene SoC
Date: Wed, 1 Apr 2015 18:07:33 +0100
Message-ID: <20150401170733.GB10578@leverpostej>
References: <1427899682-10912-1-git-send-email-stripathi@apm.com>
 <1427899682-10912-2-git-send-email-stripathi@apm.com>
 <20150401161336.GS9974@htj.duckdns.org>
 <20150401163116.GT9974@htj.duckdns.org>
 <20150401163956.GE24899@n2100.arm.linux.org.uk>
 <20150401170032.GC28616@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150401170032.GC28616-M2fw3Uu6cmfZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>, "linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org" <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 01, 2015 at 06:00:33PM +0100, Catalin Marinas wrote:
> On Wed, Apr 01, 2015 at 05:39:56PM +0100, Russell King - ARM Linux wrote:
> > On Wed, Apr 01, 2015 at 12:31:16PM -0400, Tejun Heo wrote:
> > > On Wed, Apr 01, 2015 at 12:13:36PM -0400, Tejun Heo wrote:
> > > > > Signed-off-by : Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
> > > > 
> > > > Applied to libata/for-4.1 w/ minor edit.
> > > 
> > > Reverted due to build failure from missing asm/cputype.h.
> > 
> > I'm guessing this is some kind of ARM driver, which is why
> > linux-arm-kernel has been Cc'd - though I haven't seen the original
> > patch.
> > 
> > ARM has asm/cputype.h, and has had for a long time, so "missing
> > asm/cputype.h" doesn't make sense as a reason to revert it.  Maybe
> > it's trying to be built on x86 when it should be restricted to
> > only ARM?
> > 
> > Dunno without seeing the original patch.
> 
> First search result leads here:
> 
> https://www.mail-archive.com/devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg67774.html
> 
> The driver in general should not be ARM specific, though it runs on an
> ARMv8 platform. But looking at the patch it has some errata workarounds
> triggered based on the CPU id (MIDR). That looks dodgy as it doesn't
> even check the full ID, only the variant part.
> 
> But if they don't have any other way of identifying the hardware
> version (ideally some SoC or device identification), the driver should
> at least be made dependent on ARM64. Looking at the Kconfig entries,
> PHY_XGENE depends on (ARM64 || COMPILE_TEST). The COMPILE_TEST part
> should be dropped (I would still prefer a different way to handle this
> than checking MIDR but I'm not familiar with the hardware).

We should just add a new compatible string for the new revision of the
AHCI controller. Given the errata we're avoiding apply to the AHCI
controller and not the CPU, looking at the CPU ID is nonsense.

Mark.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
