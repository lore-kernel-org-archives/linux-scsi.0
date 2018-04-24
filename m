From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v9 2/5] dt-bindings: scsi: ufs: add document for hisi-ufs
Date: Tue, 24 Apr 2018 07:58:27 -0500
Message-ID: <20180424125827.k2dgeu6uon75wzni@rob-hp-laptop>
References: <20180417140814.38098-1-liwei213@huawei.com>
 <20180417140814.38098-3-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180417140814.38098-3-liwei213@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Li Wei <liwei213@huawei.com>
Cc: mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, zangleigang@hisilicon.com, gengjianfeng@hisilicon.com, guodong.xu@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 17, 2018 at 10:08:11PM +0800, Li Wei wrote:
> add ufs node document for Hisilicon.
> 
> Signed-off-by: Li Wei <liwei213@huawei.com>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 29 ++++++++++++++++++++++
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      | 10 +++++---
>  2 files changed, 36 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> new file mode 100644
> index 000000000000..d49ab7d8f31d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> @@ -0,0 +1,29 @@
> +* Hisilicon Universal Flash Storage (UFS) Host Controller
> +
> +UFS nodes are defined to describe on-chip UFS hardware macro.
> +Each UFS Host Controller should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains one of the following -
> +					"hisilicon,hi3660-ufs", "jedec,ufs-1.1" for hisi ufs
> +					host controller present on Hi36xx chipset.
> +- reg               : should contain UFS register address space & UFS SYS CTRL register address,
> +- interrupt-parent  : interrupt device
> +- interrupts        : interrupt number
> +- resets            : reset node register, the "arst" corresponds to reset the APB/AXI bus.

arst belongs in reset-names.

> +- reset-names       : describe reset node register

What happened to clocks? You still have to list which ones apply even if 
documented in the common binding.

> +
> +Example:
> +
> +	ufs: ufs@ff3b0000 {
> +		compatible = "hisilicon,hi3660-ufs", "jedec,ufs-1.1";
> +		/* 0: HCI standard */
> +		/* 1: UFS SYS CTRL */
> +		reg = <0x0 0xff3b0000 0x0 0x1000>,
> +			<0x0 0xff3b1000 0x0 0x1000>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>;
> +		/* offset: 0x84; bit: 7  */
> +		resets = <&crg_rst 0x84 7>;
> +		reset-names = "arst";
> +	};
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index c39dfef76a18..adcfb79f63f5 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -41,6 +41,8 @@ Optional properties:
>  -lanes-per-direction	: number of lanes available per direction - either 1 or 2.
>  			  Note that it is assume same number of lanes is used both
>  			  directions at once. If not specified, default is 2 lanes per direction.
> +- resets            : reset node register, the "rst" corresponds to reset the whole UFS IP.
> +- reset-names       : describe reset node register

Does your controller have 1 or 2 resets? There's no point in adding this 
here if it doesn't apply to your controller.


>  Note: If above properties are not defined it can be assumed that the supply
>  regulators or clocks are always on.
> @@ -61,9 +63,11 @@ Example:
>  		vccq-max-microamp = 200000;
>  		vccq2-max-microamp = 200000;
>  
> -		clocks = <&core 0>, <&ref 0>, <&iface 0>;
> -		clock-names = "core_clk", "ref_clk", "iface_clk";
> -		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>;
> +		clocks = <&core 0>, <&ref 0>, <&phy 0>, <&iface 0>;
> +		clock-names = "core_clk", "ref_clk", "phy_clk", "iface_clk";
> +		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>, <0 0>;
> +		resets = <&reset 0 1>;
> +		reset-names = "rst";
>  		phys = <&ufsphy1>;
>  		phy-names = "ufsphy";
>  	};
> -- 
> 2.15.0
> 
