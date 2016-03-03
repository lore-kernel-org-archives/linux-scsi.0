From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH v9 3/3] add support for DWC UFS Host Controller
Date: Thu, 3 Mar 2016 11:39:05 +0000
Message-ID: <56D82259.3020907@synopsys.com>
References: <cover.1455549221.git.jpinto@synopsys.com>
 <2698029.eKNCoG3LWy@wuerfel> <56D718F7.9060200@synopsys.com>
 <5606371.ipFvUUmgV9@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5606371.ipFvUUmgV9@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, mark.rutland@arm.com, robh@kernel.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Arnd,

On 3/2/2016 7:55 PM, Arnd Bergmann wrote:
> On Wednesday 02 March 2016 16:46:47 Joao Pinto wrote:
>> On 2/19/2016 3:03 PM, Arnd Bergmann wrote:
>>> On Thursday 18 February 2016 17:20:27 Joao Pinto wrote:

Facts:

- Test Chip type are currently not detectable in runtime through the controller
- In the future the Test Chip version will be available in the controller
- Test Chip initialization is different for each type
- The IP Core version is 1.40a
- Test Chip version is 6.00
- Teh UFS version is 2.0

Suggested driver architecture:

Platform setup:
 tc-dwc-g210-pltfrm --> tc-dwc-g210 --> ufshcd-dwc-pltfrm --> ufshcd-dwc --> ufs

The test chip platform driver could be called through 2 compatibility strings.
indicating the chip's version and bit type:
 "snps, g210-tc-6.00-20bit"
 "snps, g210-tc-6.00-40bit"

The device tree node would have additional info compatibility strings as the DWC
IP core version and UFS version:
 "snps, dwc-ufshcd-1.40a"
 "jedec, ufs-2.0"

PCI based setup:
 tc-dwc-g210-pci --> tc-dwc-g210 --> ufshcd-dwc-pci --> ufshcd-dwc --> ufs

The test chip type would be configured by a parameter to be passed in the kernel
boot args: tc_type = 20 (20-bit) or tc_type = 40 (40-bit)

Having this in mind the KConfig would be:

"config SCSI_UFS_DWC_HOOKS
	bool

config SCSI_UFS_DWC_PLAT
	tristate "DesignWare UFS controller platform glue driver"
	depends on SCSI_UFSHCD_PLATFORM
	select SCSI_UFS_DWC_HOOKS
	help
	  This selects the DesignWare UFS host controller platform glue driver.

	  Select this if you have a DesignWare UFS controller on Platform bus.
	  If unsure, say N.

config SCSI_UFS_DWC_PCI
	tristate "DesignWare UFS controller pci glue driver"
	depends on SCSI_UFSHCD_PCI
	select SCSI_UFS_DWC_HOOKS
	help
	  This selects the DesignWare UFS host controller pci glue driver.

	  Select this if you have a DesignWare UFS controller on pci bus.
	  If unsure, say N.

config SCSI_UFS_DWC_TC
	bool "Support for the Synopsys Test Chip"
	depends on SCSI_UFS_DWC_HOOKS && (SCSI_UFSHCD_PCI || SCSI_UFS_DWC_PLAT)
	---help---
	  Synopsys Test Chip is a Phy for prototyping purposes.
	  This selects the support for the Synopsys Test Chip.

	  Select this if you have a Synopsys Test Chip.
	  If unsure, say N."

Agree with the approach?

Thanks for the help.

Joao
