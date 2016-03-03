From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v9 3/3] add support for DWC UFS Host Controller
Date: Thu, 3 Mar 2016 13:52:39 +0000
Message-ID: <56D841A7.7050008@synopsys.com>
References: <cover.1455549221.git.jpinto@synopsys.com>
 <5606371.ipFvUUmgV9@wuerfel> <56D82259.3020907@synopsys.com>
 <10452689.JXS9XIs74z@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <10452689.JXS9XIs74z@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 3/3/2016 12:04 PM, Arnd Bergmann wrote:
> On Thursday 03 March 2016 11:39:05 Joao Pinto wrote:
>> Hi Arnd,
>>
>> On 3/2/2016 7:55 PM, Arnd Bergmann wrote:
>>> On Wednesday 02 March 2016 16:46:47 Joao Pinto wrote:
>>>> On 2/19/2016 3:03 PM, Arnd Bergmann wrote:
>>>>> On Thursday 18 February 2016 17:20:27 Joao Pinto wrote:
>>
>> Facts:
>>
>> - Test Chip type are currently not detectable in runtime through the controller
>> - In the future the Test Chip version will be available in the controller
>> - Test Chip initialization is different for each type
>> - The IP Core version is 1.40a
>> - Test Chip version is 6.00
>> - Teh UFS version is 2.0
> 
> Ok.
> 
>> Suggested driver architecture:
>>
>> Platform setup:
>>  tc-dwc-g210-pltfrm --> tc-dwc-g210 --> ufshcd-dwc-pltfrm --> ufshcd-dwc --> ufs
>>
>> The test chip platform driver could be called through 2 compatibility strings.
>> indicating the chip's version and bit type:
>>  "snps, g210-tc-6.00-20bit"
>>  "snps, g210-tc-6.00-40bit"
> 
> Yes, this sounds good. We can probably skip one of the middle layers,
> but basically that is what I was looking for.
> 
>> The device tree node would have additional info compatibility strings as the DWC
>> IP core version and UFS version:
>>  "snps, dwc-ufshcd-1.40a"
>>  "jedec, ufs-2.0"
>>
>> PCI based setup:
>>  tc-dwc-g210-pci --> tc-dwc-g210 --> ufshcd-dwc-pci --> ufshcd-dwc --> ufs
> 
> The tc-dwc-g210 portion probably shouldn't depend on both
> ufshcd-dwc-pltfrm and ufshcd-dwc-pci here, so how about leaving
> those two out?
> 
> 
> Then it becomes
> 
>    tc-dwc-g210-pci ---> tc-dwc-g210 --> ufshcd-dwc --> ufs
> tc-dwc-g210-pltfrm --/

Ok, understood. It becomes simpler without the pltfm and pci "middle layer".

> 
>> The test chip type would be configured by a parameter to be passed in the kernel
>> boot args: tc_type = 20 (20-bit) or tc_type = 40 (40-bit)
> 
> Right. With module_param() helper, this will be either a boot command
> line option, or a module load option, depending on whether the driver
> is built-on or not.
> 
> modprobe tc-dwc-g210-pci tc_type=20
> 
> command line: tc-dwc-g210-pci.tc_type=20
>  

Right, that was the idea.

>> Having this in mind the KConfig would be:
>>
>> "config SCSI_UFS_DWC_HOOKS
>> 	bool
> 
> I think we can now remove the config option for the hooks as well.
> 
>> config SCSI_UFS_DWC_PLAT
>> 	tristate "DesignWare UFS controller platform glue driver"
>> 	depends on SCSI_UFSHCD_PLATFORM
>> 	select SCSI_UFS_DWC_HOOKS
>> 	help
>> 	  This selects the DesignWare UFS host controller platform glue driver.
>>
>> 	  Select this if you have a DesignWare UFS controller on Platform bus.
>> 	  If unsure, say N.
>>
>> config SCSI_UFS_DWC_PCI
>> 	tristate "DesignWare UFS controller pci glue driver"
>> 	depends on SCSI_UFSHCD_PCI
>> 	select SCSI_UFS_DWC_HOOKS
>> 	help
>> 	  This selects the DesignWare UFS host controller pci glue driver.
>>
>> 	  Select this if you have a DesignWare UFS controller on pci bus.
>> 	  If unsure, say N.
>>
>> config SCSI_UFS_DWC_TC
>> 	bool "Support for the Synopsys Test Chip"
>> 	depends on SCSI_UFS_DWC_HOOKS && (SCSI_UFSHCD_PCI || SCSI_UFS_DWC_PLAT)
>> 	---help---
>> 	  Synopsys Test Chip is a Phy for prototyping purposes.
>> 	  This selects the support for the Synopsys Test Chip.
>>
>> 	  Select this if you have a Synopsys Test Chip.
>> 	  If unsure, say N."
>>
>> Agree with the approach?
> 
> This would work, but I think it's better to define the options in terms
> of the top-level drivers, i.e. SCSI_UFS_DWC_TC_PCI and SCSI_UFS_DWC_TC_PLATFORM,
> and then make the other options hidden and implicitly turned out by them.
> 

config SCSI_UFS_DWC
	bool

config SCSI_UFS_DWC_TC_PLATFORM
 	tristate "DesignWare platform support using a G210 Test Chip"
 	depends on SCSI_UFSHCD_PLATFORM
	select SCSI_UFS_DWC
 	---help---
 	  Synopsys Test Chip is a PHY for prototyping purposes.

 	  If unsure, say N."

config SCSI_UFS_DWC_TC_PCI
	tristate "DesignWare pci support using a G210 Test Chip"
	depends on SCSI_UFSHCD_PCI
	select SCSI_UFS_DWC
	---help---
	  Synopsys Test Chip is a PHY for prototyping purposes.

	  If unsure, say N."

I would keep SCSI_UFS_DWC to avoid building DWC specific source everytime.

Agree?

> 	Arnd
> 

Joao
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
