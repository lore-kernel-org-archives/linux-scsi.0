From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 02/32] devicetree: bindings: scsi: HiSi SAS
Date: Mon, 16 Nov 2015 07:56:19 -0600
Message-ID: <20151116135619.GA29577@rob-hp-laptop>
References: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
 <1447679178-220222-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447679178-220222-3-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 16, 2015 at 09:05:48PM +0800, John Garry wrote:
> Add devicetree bindings for HiSilicon SAS driver.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  .../devicetree/bindings/scsi/hisilicon-sas.txt     | 69 ++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> 
> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> new file mode 100644
> index 0000000..f67e761
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> @@ -0,0 +1,69 @@
> +* HiSilicon SAS controller
> +
> +The HiSilicon SAS controller supports SAS/SATA.
> +
> +Main node required properties:
> +  - compatible : value should be as follows:
> +	(a) "hisilicon,hip05-sas-v1" for v1 hw in hip05 chipset
> +  - sas-addr : array of 8 bytes for host SAS address
> +  - reg : Address and length of the SAS register
> +  - hisilicon,sas-syscon: phandle of syscon used for sas control
> +  - ctrl-reset-reg : offset to controller reset register in ctrl reg
> +  - ctrl-reset-sts-reg : offset to controller reset status register in ctrl reg
> +  - ctrl-clock-ena-reg : offset to controller clock enable register in ctrl reg
> +  - queue-count : number of delivery and completion queues in the controller
> +  - phy-count : number of phys accessible by the controller
> +  - interrupts : Interrupts for phys, completion queues, and fatal
> +		sources; the interrupts are ordered in 3 groups, as follows:
> +			- Phy interrupts
> +			- Completion queue interrupts
> +			- Fatal interrupts
> +		Phy interrupts : Each phy has 3 interrupt sources:
> +			- broadcast
> +			- phyup
> +			- abnormal
> +		The phy interrupts are ordered into groups of 3 per phy
> +		(broadcast, phyup, and abnormal) in increasing order.
> +		Completion queue interrupts : each completion queue has 1
> +			interrupt source.
> +			The interrupts are ordered in increasing order.
> +		Fatal interrupts : the fatal interrupts are ordered as follows:
> +			- ECC
> +			- AXI bus
> +
> +Example:
> +	sas0: sas@c1000000 {
> +		compatible = "hisilicon,hip05-sas-v1";
> +		sas-addr = [50 01 88 20 16 00 00 0a];
> +		reg = <0x0 0xc1000000 0x0 0x10000>;
> +		hisilicon,sas-syscon = <&pcie_sas>;
> +		ctrl-reset-reg = <0xa60>;
> +		ctrl-reset-sts-reg = <0x5a30>;
> +		ctrl-clock-ena-reg = <0x338>;
> +		queue-count = <32>;
> +		phy-count = <8>;
> +		dma-coherent;
> +		interrupt-parent = <&mbigen_dsa>;
> +		interrupts =    <259 4>,<263 4>,<264 4>,/* phy0 */
> +				<269 4>,<273 4>,<274 4>,/* phy1 */
> +				<279 4>,<283 4>,<284 4>,/* phy2 */
> +				<289 4>,<293 4>,<294 4>,/* phy3 */
> +				<299 4>,<303 4>,<304 4>,/* phy4 */
> +				<309 4>,<313 4>,<314 4>,/* phy5 */
> +				<319 4>,<323 4>,<324 4>,/* phy6 */
> +				<329 4>,<333 4>,<334 4>,/* phy7 */
> +				<336 1>,<337 1>,<338 1>,/* cq0-2 */
> +				<339 1>,<340 1>,<341 1>,/* cq3-5 */
> +				<342 1>,<343 1>,<344 1>,/* cq6-8 */
> +				<345 1>,<346 1>,<347 1>,/* cq9-11 */
> +				<348 1>,<349 1>,<350 1>,/* cq12-14 */
> +				<351 1>,<352 1>,<353 1>,/* cq15-17 */
> +				<354 1>,<355 1>,<356 1>,/* cq18-20 */
> +				<357 1>,<358 1>,<359 1>,/* cq21-23 */
> +				<360 1>,<361 1>,<362 1>,/* cq24-26 */
> +				<363 1>,<364 1>,<365 1>,/* cq27-29 */
> +				<366 1>,<367 1>/* cq30-31 */
> +				<376 4>,/* fatal ecc */
> +				<381 4>;/* fatal axi */
> +		status = "disabled";
> +	};
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
