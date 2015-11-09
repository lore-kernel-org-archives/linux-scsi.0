From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 02/32] devicetree: bindings: scsi: HiSi SAS
Date: Mon, 9 Nov 2015 12:01:33 -0600
Message-ID: <20151109180133.GA23100@rob-hp-laptop>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
 <1447086757-147706-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447086757-147706-3-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 10, 2015 at 12:32:07AM +0800, John Garry wrote:
> Add devicetree bindings for HiSilicon SAS driver.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
>  .../devicetree/bindings/scsi/hisilicon-sas.txt     | 81 ++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> 
> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> new file mode 100644
> index 0000000..2333cc3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> @@ -0,0 +1,81 @@
> +* HiSilicon SAS controller
> +
> +The HiSilicon SAS controller supports SAS/SATA.
> +
> +Main node required properties:
> +  - compatible : value should be as follows:
> +	(a) "hisilicon,sas-controller-v1" for v1 of HiSilicon SAS controller IP

Please do a more specific compatible string with the SOC part number. 
Same versions of IP blocks can have different integration/process 
features/bugs.

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
> +		  - Phy interrupts
> +		  - Completion queue interrupts
> +		  - Fatal interrupts
> +		Phy interrupts : Each phy has 3 interrupt sources:
> +			- broadcast
> +			- phyup
> +			- abnormal
> +		The phy interrupts are ordered into groups of 3 per phy
> +		(broadcast, phyup, and abnormal) in increasing order.
> +		Completion queue interrupts : each completion queue has 1
> +			interrupt source. The interrupts are ordered in
> +			increasing order.
> +		Fatal interrupts : the fatal interrupts are ordered as follows:
> +			- ECC
> +			- AXI bus
> +
> +* HiSilicon SAS syscon
> +
> +Required properties:
> +- compatible: should be "hisilicon,sas-ctrl", "syscon"

Please add a more specific compatible here too.

Rob
