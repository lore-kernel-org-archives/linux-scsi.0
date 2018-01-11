From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 2/5] dt-bindings: scsi: ufs: add document for hisi-ufs
Date: Thu, 11 Jan 2018 14:34:59 -0600
Message-ID: <20180111203459.ylrozvecnb2owkmp@rob-hp-laptop>
References: <20180106095117.67907-1-liwei213@huawei.com>
 <20180106095117.67907-3-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180106095117.67907-3-liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org, riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zangleigang-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, gengjianfeng-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, guodong.xu-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fengbaopeng-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 06, 2018 at 05:51:14PM +0800, Li Wei wrote:
> add ufs node document for Hisilicon.
> 
> Signed-off-by: Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 43 ++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> new file mode 100644
> index 000000000000..175693e47d6b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> @@ -0,0 +1,43 @@
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
> +- clocks	        : List of phandle and clock specifier pairs
> +- clock-names       : List of clock input name strings sorted in the same
> +					order as the clocks property. "ref_clk", "phy_clk" is optional
> +- freq-table-hz		: Array of <min max> operating frequencies stored in the same
> +                          order as the clocks property. If this property is not
> +			  defined or a value in the array is "0" then it is assumed
> +			  that the frequency is set by the parent clock or a
> +			  fixed rate clock source.

Doesn't the assigned-clocks binding work here? I'd suggest dropping this 
until you really need it.

> +- resets            : reset node register, one reset the clk and the other reset the controller
> +- reset-names       : describe reset node register
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
> +		clock-names = "ref_clk", "phy_clk";
> +		freq-table-hz = <0 0>, <0 0>;
> +		/* offset: 0x84; bit: 12 */
> +		/* offset: 0x84; bit: 7  */
> +		resets = <&crg_rst 0x84 12>,
> +			<&crg_rst 0x84 7>;
> +		reset-names = "rst", "assert";
> +	};
> -- 
> 2.15.0
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
