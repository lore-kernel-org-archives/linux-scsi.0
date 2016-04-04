From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v12 8/9] add TC G210 platform driver
Date: Mon, 4 Apr 2016 00:15:46 -0500
Message-ID: <20160404051546.GE17806@rob-hp-laptop>
References: <cover.1459448160.git.jpinto@synopsys.com>
 <aa4c31ba977bc5c07f5706f12c4d9fbb1bb0ec36.1459448160.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aa4c31ba977bc5c07f5706f12c4d9fbb1bb0ec36.1459448160.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: tomas.winkler@intel.com, vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 31, 2016 at 07:57:21PM +0100, Joao Pinto wrote:
> This patch adds a glue platform driver for the Synopsys G210 Test Chip.
> 
> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> ---
> Changes v11->v12 (Tomas Winkler):
> - custom_phy_initialization replaced by phy_initialization
> Changes v10->v11 (Arnd Bergmann):
> - vops structs are now passed in .data
> Changes v0->v10:
> - This patch only appeared in v10
> 
>  .../devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt |  26 +++++
>  drivers/scsi/ufs/Kconfig                           |   9 ++
>  drivers/scsi/ufs/Makefile                          |   1 +
>  drivers/scsi/ufs/tc-dwc-g210-pltfrm.c              | 113 +++++++++++++++++++++
>  4 files changed, 149 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
>  create mode 100644 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
> 
> diff --git a/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt b/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
> new file mode 100644
> index 0000000..6ec9647
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
> @@ -0,0 +1,26 @@
> +* Universal Flash Storage (UFS) DesignWare Host Controller
> +
> +DWC_UFS nodes are defined to describe on-chip UFS host controllers and MPHY.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible	: compatible list must contain the PHY type & version:
> +			"snps, g210-tc-6.00-20bit"
> +			"snps, g210-tc-6.00-40bit"
Remove the space              ^

> +		  complemented with the Controller IP version:
> +			"snps, dwc-ufshcd-1.40a"

ditto

Combining the phy and controller compatible strings is a bit strange. 
Generally, they would be separate nodes using the common phy binding.

> +		  complemented with the JEDEC version:
> +			"jedec,ufs-1.1"
> +			"jedec,ufs-2.0"
> +
> +- reg		: <registers mapping>
> +- interrupts	: <interrupt mapping for UFS host controller IRQ>
> +
> +Example for a setup using a 1.40a DWC Controller with a 6.00 G210 40-bit TC:
> +	dwc_ufs@d0000000 {

No underscores please.

> +		compatible = "snps, g210-tc-6.00-40bit",
> +			     "snps, dwc-ufshcd-1.40a",
> +			     "jedec,ufs-2.0";
> +		reg = < 0xd0000000 0x10000 >;
> +		interrupts = < 24 >;
> +	};
