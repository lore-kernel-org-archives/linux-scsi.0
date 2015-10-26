From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/32] devicetree: bindings: scsi: HiSi SAS
Date: Mon, 26 Oct 2015 14:55:55 +0000
Message-ID: <562E3EFB.6000409@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
 <1445868903-183817-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445868903-183817-3-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 26/10/2015 14:14, John Garry wrote:
> Add devicetree bindings for HiSilicon SAS driver.
>
> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   .../devicetree/bindings/scsi/hisilicon-sas.txt     | 70 ++++++++++++++++++++++
>   1 file changed, 70 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>
> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> new file mode 100644
> index 0000000..d1e7b2a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> @@ -0,0 +1,70 @@
> +* HiSilicon SAS controller
> +
> +The HiSilicon SAS controller supports SAS/SATA.
> +
> +Main node required properties:
> +  - compatible : value should be as follows:
> +	(a) "hisilicon,sas-controller-v1" for v1 of HiSilicon SAS controller IP
I accidently omitted new property sas-addr for v2 patchset; here is what 
it should look like:
	- sas-addr : array of 8 bytes for host SAS address
> +  - reg : Address and length of the SAS register
> +  - hisilicon,sas-syscon: phandle of syscon used for sas control
> +  - ctrl-reg : offset to the following SAS control registers (in order):
> +		- reset assert
> +		- clock disable
> +		- reset status
> +		- reset de-assert
> +		- clock enable
> +  - queue-count : number of delivery and completion queues in the controller
> +  - phy-count : number of phys accessible by the controller
> +  - interrupts : Interrupts for phys, completion queues, and fatal
> +		 interrupts:
> +		  - Each phy has 3 interrupt sources:
> +			- broadcast
> +			- phyup
> +			- abnormal
> +		  - Each completion queue has 1 interrupt source
> +		  - Each controller has 2 fatal interrupt sources:
> +			- ECC
> +			- AXI bus
> +
> +* HiSilicon SAS syscon
> +
> +Required properties:
> +- compatible: should be "hisilicon,sas-ctrl", "syscon"
> +- reg: offset and length of the syscon sas-ctrl registers
> +
> +
> +Example:
> +	sas_ctrl0: sas_ctrl@c0000000 {
> +		compatible = "hisilicon,sas-ctrl", "syscon";
> +		reg = <0x0 0xc0000000 0x0 0x10000>;
> +	};
> +
> +	sas0: sas@c1000000 {
> +		compatible = "hisilicon,sas-controller-v1";

		sas-addr = [50 01 88 20 16 00 00 0a];

> +		reg = <0x0 0xc1000000 0x0 0x10000>;
> +		hisilicon,sas-syscon = <&sas_ctrl0>;
> +		ctrl-reg = <0xa60 0x33c 0x5a30 0xa64 0x338>;
> +		queue-count = <32>;
> +		phy-count = <8>;
> +		dma-coherent;
> +		interrupt-parent = <&mbigen_dsa>;
> +		interrupts = <259 4>, <263 4>,<264 4>,/* phy irq(0~79) */
> +				<269 4>,<273 4>,<274 4>,/* phy irq(0~79) */
> +				<279 4>,<283 4>,<284 4>,/* phy irq(0~79) */
> +				<289 4>,<293 4>,<294 4>,/* phy irq(0~79) */
> +				<299 4>,<303 4>,<304 4>,/* phy irq(0~79) */
> +				<309 4>,<313 4>,<314 4>,/* phy irq(0~79) */
> +				<319 4>,<323 4>,<324 4>,/* phy irq(0~79) */
> +				<329 4>,<333 4>,<334 4>,/* phy irq(0~79) */
> +				<336 1>,<337 1>,<338 1>,<339 1>,<340 1>,
> +				<341 1>,<342 1>,<343 1>,/* cq irq (80~111) */
> +				<344 1>,<345 1>,<346 1>,<347 1>,<348 1>,
> +				<349 1>,<350 1>,<351 1>,/* cq irq (80~111) */
> +				<352 1>,<353 1>,<354 1>,<355 1>,<356 1>,
> +				<357 1>,<358 1>,<359 1>,/* cq irq (80~111) */
> +				<360 1>,<361 1>,<362 1>,<363 1>,<364 1>,
> +				<365 1>,<366 1>,<367 1>,/* cq irq (80~111) */
> +				<376 4>,/* chip fatal error irq(120) */
> +				<381 4>;/* chip fatal error irq(125) */
> +		status = "disabled";
> +	};
>

Comment on new property sas-addr added.

John

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
