From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 5/7] dt-bindings: scsi: ufs: Add document for
 ufs-mediatek
Date: Tue, 12 Mar 2019 08:31:13 -0500
Message-ID: <20190312133113.GA8956@bogus>
References: <1551252192-535-1-git-send-email-stanley.chu@mediatek.com>
 <1551252192-535-7-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1551252192-535-7-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, chunfeng.yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 27, 2019 at 03:23:10PM +0800, Stanley Chu wrote:
> Add UFS and UFS PHY node document for Mediatek SoC chips.
> 
> Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> ---
>  .../devicetree/bindings/ufs/ufs-mediatek.txt  | 47 +++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-mediatek.txt b/Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
> new file mode 100644
> index 000000000000..5fc985928b3e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
> @@ -0,0 +1,47 @@
> +* Mediatek Universal Flash Storage (UFS) Host Controller
> +
> +UFS nodes are defined to describe on-chip UFS hardware macro.
> +Each UFS Host Controller should have its own node.
> +
> +To bind UFS PHY with UFS host controller, the controller node should
> +contain a phandle reference to UFS M-PHY node.
> +
> +Required properties for UFS nodes:
> +- compatible         : Compatible list, contains the following controller:
> +                       "mediatek,ufshci"

Needs an SoC specific compatible string.

> +- reg                : Address and length of the UFS register set.
> +- interrupt-parent   : Interrupt device.

Drop this. It is implied or may be in a parent node.

> +- phys               : phandle to m-phy.
> +- clocks             : List of phandle and clock specifier pairs.
> +- clock-names        : List of clock input name strings sorted in the same
> +                       order as the clocks property. "ufs-clk" is mandatory.
> +- freq-table-hz      : Array of <min max> operating frequencies stored in the same
> +                       order as the clocks property. If this property is not
> +                       defined or a value in the array is "0" then it is assumed
> +                       that the frequency is set by the parent clock or a
> +                       fixed rate clock source.
> +- vcc-supply         : Power to the UFS device.
> +- vcc-fixed-regulator: Specify that vcc-supply is a fixed regulator.

Why is this needed? The driver could query the voltage range of the 
regulator or you could check the regulator node.

> +- lanes-per-direction: Number of lanes available per direction. Shall be 1.

If this can only be one value, then it can be implied by the compatible 
string.

> +
> +Example:
> +
> +	ufs_mphy: ufs_mphy@11fa0000 {
> +		...
> +	};
> +
> +	ufshci:ufshci@11270000 {
> +		compatible = "mediatek,ufshci";
> +		reg = <0 0x11270000 0 0x2300>;
> +		interrupts = <GIC_SPI 104 IRQ_TYPE_LEVEL_LOW>;
> +		phys = <&ufs_mphy>;
> +
> +		clocks = <&infracfg_ao INFRACFG_AO_UFS_CG>;
> +		clock-names = "ufs-clk";
> +		freq-table-hz = <0 0>;
> +
> +		vcc-supply = <&mt_pmic_vemc_ldo_reg>;
> +		vcc-fixed-regulator;
> +
> +		lanes-per-direction = <1>;
> +	};
> -- 
> 2.18.0
> 
