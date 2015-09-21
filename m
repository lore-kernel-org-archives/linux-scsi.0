From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 01/11] phy: exynos-ufs: add UFS PHY driver for EXYNOS
 SoC
Date: Mon, 21 Sep 2015 09:33:28 -0500
Message-ID: <56001538.5030706@kernel.org>
References: <1442483137-32376-1-git-send-email-alim.akhtar@samsung.com>
 <1442483137-32376-2-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442483137-32376-2-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
List-Id: linux-scsi@vger.kernel.org

On 09/17/2015 04:45 AM, Alim Akhtar wrote:
> From: Seungwon Jeon <essuuj@gmail.com>
> 
> This patch introduces Exynos UFS PHY driver. This driver
> supports to deal with phy calibration and power control
> according to UFS host driver's behavior.
> 
> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  .../devicetree/bindings/phy/samsung-phy.txt        |   22 ++

It is preferred to put the binding in a separate patch.

>  drivers/phy/Kconfig                                |    7 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-exynos-ufs.c                       |  262 ++++++++++++++++++++
>  drivers/phy/phy-exynos-ufs.h                       |   85 +++++++
>  drivers/phy/phy-exynos7-ufs.h                      |   89 +++++++
>  include/linux/phy/phy-exynos-ufs.h                 |  107 ++++++++
>  7 files changed, 573 insertions(+)
>  create mode 100644 drivers/phy/phy-exynos-ufs.c
>  create mode 100644 drivers/phy/phy-exynos-ufs.h
>  create mode 100644 drivers/phy/phy-exynos7-ufs.h
>  create mode 100644 include/linux/phy/phy-exynos-ufs.h
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> index 60c6f2a..1abe2c4 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> @@ -174,3 +174,25 @@ Example:
>  		usbdrdphy0 = &usb3_phy0;
>  		usbdrdphy1 = &usb3_phy1;
>  	};
> +
> +Samsung Exynos7 soc serise UFS PHY Controller

s/serise/series/

> +---------------------------------------------
> +
> +UFS PHY nodes are defined to describe on-chip UFS Physical layer controllers.
> +Each UFS PHY controller should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains "samsung,exynos7-ufs-phy"
> +- reg : offset and length of the UFS PHY register set;
> +- reg-names : reg name(s) must be 'phy-pma';
> +- #phy-cells : must be zero
> +- samsung,syscon-phandle : a phandle to the PMU system controller, no arguments

How about samsung,pmu-syscon as syscon can mean a variety of things?

> +
> +Example:
> +	ufs_phy: ufs-phy@0x15571800 {
> +		compatible = "samsung,exynos7-ufs-phy";
> +		reg = <0x15571800 0x240>;
> +		reg-names = "phy-pma";
> +		samsung,syscon-phandle = <&pmu_system_controller>;
> +		#phy-cells = <0>;
> +	};
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 6b8dd16..7449376 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -358,4 +358,11 @@ config PHY_BRCMSTB_SATA
>  	  Enable this to support the SATA3 PHY on 28nm Broadcom STB SoCs.
>  	  Likely useful only with CONFIG_SATA_BRCMSTB enabled.
>  
> +config PHY_EXYNOS_UFS
> +	tristate "EXYNOS SoC series UFS PHY driver"
> +	depends on OF && ARCH_EXYNOS

|| COMPILE_TEST

> +	select GENERIC_PHY
> +	help
> +	  Support for UFS PHY on Samsung EXYNOS chipsets.
> +
>  endmenu
