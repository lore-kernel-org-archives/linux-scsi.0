From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v11 5/6] add TC G210 platform driver
Date: Thu, 17 Mar 2016 09:55:51 -0500
Message-ID: <20160317145551.GA22021@rob-hp-laptop>
References: <f12dcbcb9b83881a5f71460e2d6e1ab0f1e326d8.1457352207.git.jpinto@synopsys.com>
 <09d60ef0a991150a2eba77f627f292f3c2c827fd.1457352207.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <09d60ef0a991150a2eba77f627f292f3c2c827fd.1457352207.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, arnd@arndb.de, mark.rutland@arm.com, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 07, 2016 at 12:09:20PM +0000, Joao Pinto wrote:
> This patch adds a glue platform driver for the Synopsys G210 Test Chip.
> 
> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> ---
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
drop the spaces               ^


> +		  complemented with the Controller IP version:
> +			"snps, dwc-ufshcd-1.40a"

ditto

> +		  complemented with the JEDEC version:
> +			"jedec,ufs-1.1"
> +			"jedec,ufs-2.0"
> +
> +- reg		: <registers mapping>
> +- interrupts	: <interrupt mapping for UFS host controller IRQ>
> +
> +Example for a setup using a 1.40a DWC Controller with a 6.00 G210 40-bit TC:
> +	dwc_ufs@d0000000 {
> +		compatible = "snps, g210-tc-6.00-40bit",
> +			     "snps, dwc-ufshcd-1.40a",

ditto

> +			     "jedec,ufs-2.0";
> +		reg = < 0xd0000000 0x10000 >;
> +		interrupts = < 24 >;
> +	};
