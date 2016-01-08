From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 01/23] devicetree: bindings: hisi_sas: add v2 HW bindings
Date: Fri, 8 Jan 2016 14:52:56 +0000
Message-ID: <20160108145256.GG3097@leverpostej>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
 <1452262542-64589-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452262542-64589-2-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 10:15:20PM +0800, John Garry wrote:
> Add the dt bindings for HiSi SAS controller v2 HW.
> 
> The main difference in the controllers from dt perspective
> is interrupts.
> 
> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  .../devicetree/bindings/scsi/hisilicon-sas.txt       | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> index 0a7a325..2695023 100644
> --- a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> @@ -5,6 +5,7 @@ The HiSilicon SAS controller supports SAS/SATA.
>  Main node required properties:
>    - compatible : value should be as follows:
>  	(a) "hisilicon,hip05-sas-v1" for v1 hw in hip05 chipset
> +	(b) "hisilicon,hip06-sas-v2" for v2 hw in hip06 chipset
>    - sas-addr : array of 8 bytes for host SAS address
>    - reg : Address and length of the SAS register
>    - hisilicon,sas-syscon: phandle of syscon used for sas control
> @@ -13,11 +14,11 @@ Main node required properties:
>    - ctrl-clock-ena-reg : offset to controller clock enable register in ctrl reg
>    - queue-count : number of delivery and completion queues in the controller
>    - phy-count : number of phys accessible by the controller
> -  - interrupts : Interrupts for phys, completion queues, and fatal
> +  - interrupts : For v1 hw: Interrupts for phys, completion queues, and fatal
>  		sources; the interrupts are ordered in 3 groups, as follows:
> -			- Phy interrupts
> -			- Completion queue interrupts
> -			- Fatal interrupts
> +		  - Phy interrupts
> +		  - Completion queue interrupts
> +		  - Fatal interrupts
>  		Phy interrupts : Each phy has 3 interrupt sources:
>  			- broadcast
>  			- phyup
> @@ -25,11 +26,28 @@ Main node required properties:
>  		The phy interrupts are ordered into groups of 3 per phy
>  		(broadcast, phyup, and abnormal) in increasing order.
>  		Completion queue interrupts : each completion queue has 1
> -			interrupt source.
> -			The interrupts are ordered in increasing order.
> +			interrupt source. The interrupts are ordered in
> +			increasing order.
>  		Fatal interrupts : the fatal interrupts are ordered as follows:
>  			- ECC
>  			- AXI bus
> +		For v2 hw: Interrupts for phys, Sata, and completion queues;
> +		the interrupts are ordered in 3 groups, as follows:
> +		  - Phy interrupts
> +		  - Sata interrupts
> +		  - Completion queue interrupts
> +		Phy interrupts : Each controller has 2 phy interrupts:
> +			- phy up/down
> +			- channel interrupt
> +		Sata interrupts : Each phy on the controller has 1 Sata
> +			interrupt. The interrupts are ordered in increasing
> +			order.
> +		Completion queue interrupts : each completion queue has 1
> +			interrupt source. The interrupts are ordered in
> +			increasing order.

There are no fatal interrupts in V2?

> +Optional main node properties:
> + - am-max-trans : limit controller for am max transmissions

Is this a boolean? Number?

Thanks,
Mark.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
