From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Sat, 15 Sep 2007 14:24:17 +0200
Message-ID: <46EBCEF1.4030702@s5r6.in-berlin.de>
References: <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753382AbXIOMZZ@vger.kernel.org>
In-Reply-To: <20070915114055.GP3563@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Sep 14, 2007 at 10:01:18PM +0200, Stefan Richter wrote:
>>  drivers/Kconfig               |    4 
>>  drivers/scsi/Kconfig          | 1589 ----------------------------------
>>  drivers/scsi/Kconfig.lowlevel | 1578 +++++++++++++++++++++++++++++++++
>>  3 files changed, 1588 insertions(+), 1583 deletions(-)
> 
> Nearly right.  ;-)
> 
> There are a few architectures not (yet) using drivers/Kconfig.

Right, the patch is wrong for those architectures which include
drivers/scsi/Kconfig directly, rather than indirectly via drivers/Kconfig.

[...]
>>  # drivers/Kconfig
>>  
>> +source "drivers/scsi/Kconfig"
>> +
>>  menu "Device Drivers"
>>  
>>  source "drivers/base/Kconfig"
>> @@ -22,7 +24,7 @@ source "drivers/misc/Kconfig"
>>  
>>  source "drivers/ide/Kconfig"
>>  
>> -source "drivers/scsi/Kconfig"
>> +source "drivers/scsi/Kconfig.lowlevel"
>>  
>>  source "drivers/ata/Kconfig"
>> ...
> 
> This way the order is wrong:
> 
> There should first be the lowlevel SCSI, SATA, USB etc. drivers, these 
> drivers should select CONFIG_SCSI, and then the menu offering support 
> for disk, CD,...

The order was inspired by

	# the protocols etc.
	"Networking"

	# the interconnects
	"Device Drivers"/ "Network device support"

So that order is wrong too?

However, there is also precedence for the order which you suggest:  The
partition and filesystems options come after device driver options.

[...]
>> +menu "Storage (core and SCSI commands)"
>>  
>>  config SCSI
>> -	tristate "SCSI device support"
>> +	tristate "Storage support (core and SCSI commands)"
>>  	depends on BLOCK
>>  	select SCSI_DMA if HAS_DMA
>>  	---help---
>> ...
> 
> What is "storage support"?
> SATA?
> PATA?
> USB mass storage?
> MMC?
> MTD?

What is "Networking"?  Ethernet?  Infiniband?  ...?

> Whether or not a driver uses the SCSI layer is an implementation detail 
> (it even differs for the two USB mass storage implementations and the 
> two PATA implementations in the kernel) the user shouldn't have to know 
> about.
> 
> I don't see any reason why CONFIG_SCSI should have to stay user-visible 
> at all after your patch.

Vice versa, I don't see any reason for "select SCSI" anywhere after my
patch.
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
