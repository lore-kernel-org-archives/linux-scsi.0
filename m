From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 1/2] dt-bindings: ufs: Add bindings for Cadence UFS
Date: Mon, 13 Aug 2018 11:37:59 -0600
Message-ID: <20180813173759.GA7302@rob-hp-laptop>
References: <F39BF38C-FD85-4115-975C-8D923518A541@global.cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F39BF38C-FD85-4115-975C-8D923518A541@global.cadence.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Janek Kotas <jank@cadence.com>
Cc: "mark.rutland@arm.com" <mark.rutland@arm.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 09, 2018 at 01:25:15PM +0000, Janek Kotas wrote:
> This patch adds a DT binding documentation for
> Cadence UFS Host Controller.
> 
> Signed-off-by: Jan Kotas <jank@cadence.com>
> ---
>  .../devicetree/bindings/ufs/cdns,ufshc.txt         | 31 ++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> 
> diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> new file mode 100644
> index 00000000..a04a4989
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> @@ -0,0 +1,31 @@
> +* Cadence Universal Flash Storage (UFS) Controller
> +
> +UFS nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +Please see the ufshcd-pltfrm.txt for a list of all available properties.
> +
> +Required properties:
> +- compatible	: Compatible list, contains the following controller:
> +			"cdns,ufshc"
> +		  complemented with the JEDEC version:
> +			"jedec,ufs-2.0"
> +
> +- reg		: Address and length of the UFS register set.
> +- interrupts	: One interrupt mapping.
> +- freq-table-hz	: Clock frequency table.
> +		  See the ufshcd-pltfrm.txt for details.
> +- clocks	: List of phandle and clock specifier pairs.
> +- clock-names	: List of clock input name strings sorted in the same
> +		  order as the clocks property. "core_clk" is mandatory.
> +		  Depending on a type of a PHY,
> +		  the "phy_clk" clock can also be added, if needed.

Unfortunately, you went the wrong direction. The '_clk' part is 
redundant. Just 'core' and 'phy'.

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

> +
> +Example:
> +	ufs@fd030000 {
> +		compatible = "cdns,ufshc", "jedec,ufs-2.0";
> +		reg = <0xfd030000 0x10000>;
> +		interrupts = <0 1 IRQ_TYPE_LEVEL_HIGH>;
> +		freq-table-hz = <0 0>, <0 0>;
> +		clocks = <&ufs_core_clk>, <&ufs_phy_clk>;
> +		clock-names = "core_clk", "phy_clk";
> +	};
> -- 
> 2.15.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
