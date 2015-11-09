From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v5 10/11] Documentation: devicetree: ufs: Add DT bindings
 for exynos UFS host controller
Date: Mon, 9 Nov 2015 10:23:12 -0600
Message-ID: <20151109162312.GA32748@rob-hp-laptop>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
 <1447046787-480-11-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447046787-480-11-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, gautam.vivek@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, kishon@ti.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 09, 2015 at 10:56:26AM +0530, Alim Akhtar wrote:
> From: Seungwon Jeon <essuuj@gmail.com>
> 
> This adds Exynos Universal Flash Storage (UFS) Host Controller DT bindings.
> 
> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../devicetree/bindings/ufs/ufs-exynos.txt         |  104 ++++++++++++++++++++
>  1 file changed, 104 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-exynos.txt b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> new file mode 100644
> index 000000000000..08e2d1497b1b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> @@ -0,0 +1,104 @@
> +* Exynos Universal Flash Storage (UFS) Host Controller
> +
> +UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible name, contains "samsung,exynos7-ufs"
> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
> +- reg               : Should contain HCI, vendor specific, UNIPRO and
> +		      UFS protector address space
> +- reg-names	    : "hci", "vs_hci", "unipro", "ufsp";

No phy for MPHY?

> +
> +Optional properties:
> +- vdd-hba-supply        : phandle to UFS host controller supply regulator node
> +- vcc-supply            : phandle to VCC supply regulator node
> +- vccq-supply           : phandle to VCCQ supply regulator node
> +- vccq2-supply          : phandle to VCCQ2 supply regulator node
> +- vcc-supply-1p8        : For embedded UFS devices, valid VCC range is 1.7-1.95V
> +                          or 2.7-3.6V. This boolean property when set, specifies
> +			  to use low voltage range of 1.7-1.95V. Note for external
> +			  UFS cards this property is invalid and valid VCC range is
> +			  always 2.7-3.6V.
> +- vcc-max-microamp      : specifies max. load that can be drawn from vcc supply
> +- vccq-max-microamp     : specifies max. load that can be drawn from vccq supply
> +- vccq2-max-microamp    : specifies max. load that can be drawn from vccq2 supply

Some of these are supplies to the flash chip, so you should make 
these common properties (in a common doc).

> +- <name>-fixed-regulator : boolean property specifying that <name>-supply is a fixed regulator

This should be determined from the regulator.

> +
> +- clocks                : List of phandle and clock specifier pairs
> +- clock-names           : List of clock input name strings sorted in the same
> +                          order as the clocks property.
> +			  "core", "sclk_unipro_main", "ref" and ref_parent
> +
> +- freq-table-hz		: Array of <min max> operating frequencies stored in the same
> +			  order as the clocks property. If this property is not
> +			  defined or a value in the array is "0" then it is assumed
> +			  that the frequency is set by the parent clock or a
> +			  fixed rate clock source.
> +- pclk-freq-avail-range : specifies available frequency range(min/max) for APB clock
> +- ufs,pwr-attr-mode : specifies mode value for power mode change, possible values are
> +			"FAST", "SLOW", "FAST_auto" and "SLOW_auto"

ufs is not a vendor. Use a '-' rather than ','.

> +- ufs,pwr-attr-lane : specifies lane count value for power mode change
> +		      allowed values are 1 or 2
> +- ufs,pwr-attr-gear : specifies gear count value for power mode change
> +		      allowed values are 1 or 2
> +- ufs,pwr-attr-hs-series : specifies HS rate series for power mode change
> +			   can be one of "HS_rate_b" or "HS_rate_a"
> +- ufs,pwr-local-l2-timer : specifies array of local UNIPRO L2 timer values
> +			   3 timers supported
> +			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
> +- ufs,pwr-remote-l2-timer : specifies array of remote UNIPRO L2 timer values
> +			   3 timers supported
> +			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
> +- ufs-rx-adv-fine-gran-sup_en : specifies support of fine granularity of MPHY,
> +			      this is a boolean property.
> +- ufs-rx-adv-fine-gran-step : specifies granularity steps of MPHY,
> +			      allowed step size is 0 to 3
> +- ufs-rx-adv-min-activate-time-cap : specifies rx advanced minimum activate time of MPHY
> +				     range is 1 to 9
> +- ufs-pa-granularity : specifies Granularity for PA_TActivate and PA_Hibern8Time
> +- ufs-pa-tacctivate : specifies time to wake-up remote M-RX
> +- ufs-pa-hibern8time : specifies minimum time to wait in HIBERN8 state

These are all M-PHY properties?

> +
> +Note: If above properties are not defined it can be assumed that the supply
> +regulators or clocks are always on.
> +
> +Example:
> +	ufshc@0x15570000 {
> +		compatible = "samsung,exynos7-ufs";
> +		reg = <0x15570000 0x100>,
> +		      <0x15570100 0x100>,
> +		      <0x15571000 0x200>,
> +		      <0x15572000 0x300>;
> +		reg-names = "hci", "vs_hci", "unipro", "ufsp";
> +		interrupts = <0 200 0>;
> +
> +		vdd-hba-supply = <&xxx_reg0>;
> +		vdd-hba-fixed-regulator;
> +		vcc-supply = <&xxx_reg1>;
> +		vcc-supply-1p8;
> +		vccq-supply = <&xxx_reg2>;
> +		vccq2-supply = <&xxx_reg3>;
> +		vcc-max-microamp = 500000;
> +		vccq-max-microamp = 200000;
> +		vccq2-max-microamp = 200000;
> +
> +		clocks = <&core 0>, <&ref 0>, <&iface 0>;
> +		clock-names = "core", "sclk_unipro_main", "ref", "ref_parent";
> +		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>, <0 0>;
> +
> +		pclk-freq-avail-range = <70000000 133000000>;
> +
> +		ufs,pwr-attr-mode = "FAST";
> +		ufs,pwr-attr-lane = <2>;
> +		ufs,pwr-attr-gear = <2>;
> +		ufs,pwr-attr-hs-series = "HS_rate_b";
> +		ufs,pwr-local-l2-timer = <8000 28000 20000>;
> +		ufs,pwr-remote-l2-timer = <12000 32000 16000>;
> +		ufs-rx-adv-fine-gran-sup_en = <1>;
> +		ufs-rx-adv-fine-gran-step = <3>;
> +		ufs-rx-adv-min-activate-time-cap = <9>;
> +		ufs-pa-granularity = <6>;
> +		ufs-pa-tacctivate = <6>;
> +		ufs-pa-hibern8time = <20>;
> +	};
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
