From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Add UFS platform driver for
 Cadence UFS
Date: Mon, 16 Jul 2018 10:11:12 -0600
Message-ID: <20180716161112.GA16292@rob-hp-laptop>
References: <B652B768-D5BC-460F-B0A4-64A2A76064CC@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B652B768-D5BC-460F-B0A4-64A2A76064CC@cadence.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Janek Kotas <jank@cadence.com>
Cc: "mark.rutland@arm.com" <mark.rutland@arm.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 12, 2018 at 11:58:04AM +0000, Janek Kotas wrote:
> This patch adds a device tree platform
> driver description for Cadence UFS Controller.

Bindings are not platform drivers...

> 
> Signed-off-by: Jan Kotas <jank@cadence.com>
> ---
>  .../devicetree/bindings/ufs/cdns,ufshc.txt         | 31 ++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> 
> diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> new file mode 100644
> index 0000000..cb6d62a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> @@ -0,0 +1,31 @@
> +* Cadence Universal Flash Storage (UFS) Controller
> +
> +UFS nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible	: compatible list, contains the following controller:
> +			"cdns,ufshc"
> +		  complemented with the JEDEC version:
> +			"jedec,ufs-2.0"
> +
> +- reg		: address and length of the UFS register set
> +- interrupts	: one interrupt mapping
> +- clocks	: List of phandle and clock specifier pairs.
> +- clock-names	: List of clock input name strings sorted in the same
> +		  order as the clocks property. "core" is mandatory.

And phy?

> +- freq-table-hz	: Array of <min max> operating frequencies stored in the same
> +		  order as the clocks property. If this property is not
> +		  defined or a value in the array is "0" then it is assumed
> +		  that the frequency is set by the parent clock or a
> +		  fixed rate clock source.

Don't define again here. Just refer to the common definition.

> +
> +Example:
> +	ufs@fd030000 {
> +		compatible = "cdns,ufshc", "jedec,ufs-2.0";
> +		reg = <0xfd030000 0x10000>;
> +		interrupts = <0 1 IRQ_TYPE_LEVEL_HIGH>;
> +		freq-table-hz = <0 0>, <0 0>;
> +		clocks = <&ufs_core_clk>, <&ufs_phy_clk>;
> +		clock-names = "core_clk", "phy_clk";

Doesn't match the doc.

> +	};
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
