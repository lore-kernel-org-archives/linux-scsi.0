From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 11/13] Documentation: devicetree: ufs: Add DT bindings for exynos UFS host controller
Date: Thu, 01 Oct 2015 13:37:39 +0200
Message-ID: <1457698.WJ3mz2FHZZ@wuerfel>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com> <1443686970-28104-12-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443686970-28104-12-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 01 October 2015 13:39:28 Alim Akhtar wrote:
> From: Seungwon Jeon <essuuj@gmail.com>
> 
> This adds Exynos Universal Flash Storage (UFS) Host Controller DT bindings.
> 
> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../devicetree/bindings/ufs/ufs-exynos.txt         |   93 ++++++++++++++++++++
>  1 file changed, 93 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-exynos.txt b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> new file mode 100644
> index 0000000..00df72e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> @@ -0,0 +1,93 @@
> +* Exynos Universal Flash Storage (UFS) Host Controller
> +
> +UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible name, contains "samsung,exynos7-ufs"
> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
> +- reg               : <registers mapping>

This needs a list of all the register ranges, which order they are in
and what the respective strings must be.

> +- clocks                : List of phandle and clock specifier pairs
> +- clock-names           : List of clock input name strings sorted in the same
> +                          order as the clocks property.

You need to list the names you require here. Also the 'clock specifier' includes
the phandle, it's not a pair but just a list of specifiers.

> +- ufs,pwr-attr-mode : specifies mode value for power mode change
> +- ufs,pwr-attr-lane : specifies lane count value for power mode change
> +- ufs,pwr-attr-gear : specifies gear count value for power mode change
> +- ufs,pwr-attr-hs-series : specifies HS rate series for power mode change
> +- ufs,pwr-local-l2-timer : specifies array of local UNIPRO L2 timer values
> +			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
> +- ufs,pwr-remote-l2-timer : specifies array of remote UNIPRO L2 timer values
> +			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
> +- ufs-rx-adv-fine-gran-sup_en : specifies support of fine granularity of MPHY,
> +			      this is a boolean property.
> +- ufs-rx-adv-fine-gran-step : specifies granularity steps of MPHY
> +- ufs-rx-adv-min-activate-time-cap : specifies rx advanced minimum activate time of MPHY
> +- ufs-pa-granularity : specifies Granularity for PA_TActivate and PA_Hibern8Time
> +- ufs-pa-tacctivate : specifies time wake-up remote M-RX
> +- ufs-pa-hibern8time : specifies minimum time to wait in HIBERN8 state

These all require a specification of what the allowed values are and/or the units
for the numbers.

> +
> +		clocks = <&core 0>, <&ref 0>, <&iface 0>;
> +		clock-names = "core_clk", "ref_clk", "iface_clk";

Better rename them to "core", "ref" and "iface", no point requiring to
spell out "clk" here.

> +		ufs,pwr-attr-mode = "FAST";

A string is rather unusual here, what are the allowed values? Could you
use a boolean property instead?

> +		ufs,pwr-attr-lane = /bits/ 8 <2>;
> +		ufs,pwr-attr-gear = /bits/ 8 <2>;

Why the "/bits/ 8" ?


	Arnd
