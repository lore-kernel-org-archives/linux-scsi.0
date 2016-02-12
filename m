From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 3/3] add support for DWC UFS Host Controller
Date: Fri, 12 Feb 2016 10:36:36 -0600
Message-ID: <20160212163636.GA31045@rob-hp-laptop>
References: <cover.1455192008.git.jpinto@synopsys.com>
 <ee97e9b0ece0d819debe403c752d233c6267e02e.1455192008.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ee97e9b0ece0d819debe403c752d233c6267e02e.1455192008.git.jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 11, 2016 at 12:13:06PM +0000, Joao Pinto wrote:
> This patch has the goal to add support for DesignWare UFS Controller
> specific operations and to add specific platform and pci drivers.
> 
> Signed-off-by: Joao Pinto <jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
> ---
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
>  Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  17 +
>  MAINTAINERS                                       |   6 +
>  drivers/scsi/ufs/Kconfig                          |  51 ++
>  drivers/scsi/ufs/Makefile                         |   3 +
>  drivers/scsi/ufs/ufs-dwc-pci.c                    | 172 +++++
>  drivers/scsi/ufs/ufs-dwc.c                        | 102 +++
>  drivers/scsi/ufs/ufshcd-dwc.c                     | 739 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd-dwc.h                     |  18 +
>  drivers/scsi/ufs/ufshci-dwc.h                     |  42 ++
>  drivers/scsi/ufs/unipro.h                         |  39 ++
>  10 files changed, 1189 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-dwc.txt
>  create mode 100644 drivers/scsi/ufs/ufs-dwc-pci.c
>  create mode 100644 drivers/scsi/ufs/ufs-dwc.c
>  create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
>  create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
>  create mode 100644 drivers/scsi/ufs/ufshci-dwc.h
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> new file mode 100644
> index 0000000..3cbfd77
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> @@ -0,0 +1,17 @@
> +* Universal Flash Storage (UFS) DesignWare Host Controller
> +
> +DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible string ("snps,ufshcd-1.0", "snps,ufshcd-1.1"
> +  or "snps,ufshcd-2.0")

History has taught us this needs to have a vendor specific compatible 
string as well. Don't necessarily have to define it now, but just state 
a vendor string is needed too.

> +- reg               : <registers mapping>
> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
> +
> +Example:
> +	ufs@0xd0000000 {
> +		compatible = "snps,ufshcd-2.0";
> +		reg = < 0xd0000000 0x10000 >;
> +		interrupts = < 24 >;
> +	};
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
