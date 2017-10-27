From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 2/5] dt-bindings: scsi: ufs: add document for hisi-ufs
Date: Thu, 26 Oct 2017 20:08:46 -0500
Message-ID: <20171027010846.iiybapc24qpotyyv@rob-hp-laptop>
References: <20171020085045.7737-1-liwei213@huawei.com>
 <20171020085045.7737-3-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:47303 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbdJ0BIs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2017 21:08:48 -0400
Content-Disposition: inline
In-Reply-To: <20171020085045.7737-3-liwei213@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Li Wei <liwei213@huawei.com>
Cc: mark.rutland@arm.com, xuwei5@hisilicon.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, eric@anholt.net, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, guodong.xu@linaro.org, fengbaopeng@hisilicon.com, lihuan41@hisilicon.com, wangyupeng4@hisilicon.com

On Fri, Oct 20, 2017 at 04:50:42PM +0800, Li Wei wrote:
> add ufs node document for Hisilicon.
> 
> Signed-off-by: Li Wei <liwei213@huawei.com>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 47 ++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> new file mode 100644
> index 000000000000..ee114a65143d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> @@ -0,0 +1,47 @@
> +* Hisilicon Universal Flash Storage (UFS) Host Controller
> +
> +UFS nodes are defined to describe on-chip UFS hardware macro.
> +Each UFS Host Controller should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains one of the following -
> +			"hisilicon,hi3660-ufs" for hisi ufs host controller
> +			 present on Hi3660 chipset.
> +- reg               : should contain UFS register address space & UFS SYS CTRL register address,
> +- interrupt-parent  : interrupt device
> +- interrupts        : interrupt number
> +- clocks	        : List of phandle and clock specifier pairs
> +- clock-names       : List of clock input name strings sorted in the same
> +		      order as the clocks property. "clk_ref", "clk_phy" is optional
> +- resets            : reset node register, one reset the clk and the other reset the controller
> +- reset-names       : describe reset node register
> +
> +Optional properties for board device:
> +- reset-gpio			: specifies to reset devices

reset-gpios is the preferred form.

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
> +		clocks = <&crg_ctrl HI3660_CLK_GATE_UFSIO_REF>,
> +			<&crg_ctrl HI3660_CLK_GATE_UFSPHY_CFG>;
> +		clock-names = "clk_ref", "clk_phy";
> +		freq-table-hz = <0 0>, <0 0>;

Not documented.

> +		/* offset: 0x84; bit: 12 */
> +		/* offset: 0x84; bit: 7  */
> +		resets = <&crg_rst 0x84 12>,
> +			<&crg_rst 0x84 7>;
> +		reset-names = "rst", "assert";
> +	};
> +
> +	&ufs {

Don't show the SoC/Board split in examples. That's just convention, not 
part of the binding.

> +		reset-gpio = <&gpio18 1 0>;
> +		status = "okay";

Plus it's wrong because the default is okay.

> +	};
> +
> -- 
> 2.11.0
> 
