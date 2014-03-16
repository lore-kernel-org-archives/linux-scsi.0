From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v18 3/4] ata: Add APM X-Gene SoC AHCI SATA host controller driver
Date: Sat, 15 Mar 2014 23:17:59 -0700
Message-ID: <CAPw-ZTksg3z8GY55jb7-yP1wfq2BF6apB9KBgbokpshKbiiAaw@mail.gmail.com>
References: <1394841201-29495-1-git-send-email-lho@apm.com>
	<1394841201-29495-3-git-send-email-lho@apm.com>
	<1394841201-29495-4-git-send-email-lho@apm.com>
	<201403151019.49316.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201403151019.49316.arnd@arndb.de>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

>> This patch adds support for the APM X-Gene SoC AHCI SATA host controller
>> driver. It requires the corresponding APM X-Gene SoC PHY driver. This
>> initial version only supports Gen3 speed.
>
> This version seems workable, thanks for the quick follow-up.
>
> The comment about Gen3 speed above reminds me that you took some
> shortcuts to get here and you removed support for some features
> as well as some bug workarounds in the process. I'm guessing some
> of them won't be necessary because they are only for prototype
> hardware or for early boot loader versions that don't yet set up
> the hardware right, but others actually need to come back.
>
> That is usually a good approach, but I'd also like to make sure we can
> deal with them nicely when you have to add them back later, and don't
> have to add ugly extensions to the DT binding to support the old dtb
> files.
>
> Can you list (also in the changelog) the parts of the driver that you
> have taken out for now and that you expect to add back at later
> stage? I think that would be helpful for perspective.
>

Here is an list of patches that we will be preparing for once the
basic driver is completed. Do you want me to re-generate the patch
change log with this info?

1. Support for Gen1/Gen2/Gen3
Solution: The simplest solution is to have the PHY framework support
setting the desire speed. I had argued with the TI folks but they are
reluctant to add this function to the framework. They argued that this
is still not generic enough. I will start the discussion again later
on. The other possibility (but not sure if this is doable) is to have
the PHY init function to be smarter and do the necessary operation
assuming the underlying PHY is capable in detecting the link up speed.
I will need to check the spec of this.

2. Retry COMRESET (hardreset) if failed first time
Solution: This code is purely in the host driver hardreset function.
It isn't for sure that we will need this. Given our current initial
board design, this seems to required 1 out of many, many power cycle
boot.

3. Cleaning the receiver line when SER_DISPARITY/SER_10B_8B error
during COMRESET (hardreset function call)
Solution: It is observed that during COMRESET, the receiver line can
report these errors and an clean up is required. For this, the code
will be with in the host driver and an call into the PHY layer. The
solution is the similar to #1 above.

4. IO flush before servicing completed operations (mostly read operations)
Solution: The read IO operations require an flush from the host
controller hardware side. For this, we will need to change the libahci
to call an function that is provided by the host driver if non-NULL.

5. PM (power management) support
Solution: Due to an errata in the host controller, stopping the
controller requires an slightly modified version in the way it detects
the host port completed the requested operation. For this we will have
to introduce an AHCI_HFLAG_XXX to detect the completion of FIS_RX
stopped by the CI register instead the PORT_CMD register or just delay
for 500ms.

> Regarding the support for multiple link speeds, how do you think
> it will be done?
> Can you have a driver-side link speed autoconfiguration,
> or do you have to add DT properties and let the driver know about
> the attached device?
>

See above #1.

-Loc
