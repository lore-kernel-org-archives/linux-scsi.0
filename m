From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v8 3/3] add support for DWC UFS Host Controller
Date: Thu, 18 Feb 2016 08:38:42 -0600
Message-ID: <20160218143842.GE9654@rob-hp-laptop>
References: <cover.1455549221.git.jpinto@synopsys.com>
 <5c806ca29340923831e05a729bbb6557d7ce83cb.1455549222.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5c806ca29340923831e05a729bbb6557d7ce83cb.1455549222.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, arnd@arndb.de, mark.rutland@arm.com, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 15, 2016 at 03:25:13PM +0000, Joao Pinto wrote:
> This patch has the goal to add support for DesignWare UFS Controller
> specific operations and to add specific platform and pci drivers.
> 
> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> ---
> Changes v7->v8 (Akinobu Mita):
> - DME sets were simplified for easier reading
> - CLK DIV default values definitions names were changed to match the
>  register's name
> - New line added to dev_err and dev_info statements
> Changes v6->v7 (Arnd Bergmann):
> - Changed DT node name (to ufs only) and the memory address (to 0xd000000)
> - Removed CONFIG_PM from the PCI glue driver (pm.h already does this)
> - No other changes are necessary in ufshcd.c because of the link up notify
>  function usage (it is simpler now)
> - Removed the PHY mentioning since the Test Chip is not a real PHY for real
>  world usage, since it is a test chip for prototyping with a very specific
>  usage
> - Added again the Test Chip 20-bit option
> Changes v5->v6:
> - Patch bad format fixed
> Changes v4->v5 (Akinobu Mita):
> - All functions used only locally in ufshcd-dwc are now declared as static
> - ufshcd_dwc_configuration() was removed in ufshcd-dwc and a notify
>  function (ufshcd_dwc_link_startup_notify) was created to deal with the
>  DWC specific init routines
> - 20-bit RMMI option was removed from Kconfig. Now if MPHY TC is selected
>  and 40-bit is not then it assumes a 20-bit config
> Changes v3->v4 (Arnd Bergmann and Mark Rutland):
> - SCSI_UFS_DWC_HOOKS is now silent and selected by the SCSI_UFS_DWC_PLAT
>  or SCSI_UFS_DWC_PCI
> - Compatibility string has the ufs core version for info purposes since
>  the driver is capable of getting the controller version from its 
>  registers
> - Created ufs-dwc-pci glue driver with specific DWC data
> - MPHY configuration remains in the ufshcd-dwc since it is unipro
>  attribute writting only not following the a linux phy framework logic
> Changes v2->v3 (Julian Calaby):
> - Implement a common DWC code to be used by the platform and pci glue
>  drivers
> - Synopsys ID & Class added to the existing pci driver and specific DWC
>  was also added to the pci driver
> Changes v1->v2 (Akinobu Mita):
> - Implement a platform driver that uses the existing UFS core driver
> - Add DWC specific code to the existing UFS core driver
> 
>  Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  19 +
>  MAINTAINERS                                       |   6 +
>  drivers/scsi/ufs/Kconfig                          |  51 +++
>  drivers/scsi/ufs/Makefile                         |   3 +
>  drivers/scsi/ufs/ufs-dwc-pci.c                    | 172 +++++++++
>  drivers/scsi/ufs/ufs-dwc.c                        |  96 +++++
>  drivers/scsi/ufs/ufshcd-dwc.c                     | 431 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd-dwc.h                     |  18 +
>  drivers/scsi/ufs/ufshci-dwc.h                     |  42 +++
>  drivers/scsi/ufs/unipro.h                         |  39 ++
>  10 files changed, 877 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-dwc.txt
>  create mode 100644 drivers/scsi/ufs/ufs-dwc-pci.c
>  create mode 100644 drivers/scsi/ufs/ufs-dwc.c
>  create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
>  create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
>  create mode 100644 drivers/scsi/ufs/ufshci-dwc.h
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> new file mode 100644
> index 0000000..59e9822
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> @@ -0,0 +1,19 @@
> +* Universal Flash Storage (UFS) DesignWare Host Controller
> +
> +DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list must contain "snps,ufshcd-dwc" and should
> +		      also contain the JEDEC version of the controller:
> +			"jedec,ufs-1.1"
> +			"jedec,ufs-2.0"

As I said before, this needs to mention also requiring an SoC specific 
compatible.

> +- reg               : <registers mapping>
> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
> +
> +Example:
> +	ufs@0xd0000000 {

Drop '0x'

> +		compatible = "jedec,ufs-2.0", "snps,dwc-ufshcd";

This should be reversed. Most specific first.

> +		reg = < 0xd0000000 0x10000 >;
> +		interrupts = < 24 >;
> +	};
