From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2 05/12] pm80xx: MSI-X implementation for using 64 interrupts
Date: Thu, 14 Mar 2013 12:20:32 +0100
Message-ID: <5141B280.2070202@suse.de>
References: <5141AEA1.4030501@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab3CNLUi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Mar 2013 07:20:38 -0400
In-Reply-To: <5141AEA1.4030501@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Harry.Yang@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, sakthivel.sk@hcl.com, xjtuwjp@gmail.com, Vishwanath.Maram@pmcs.com, rich.Bono@pmcs.com

Sorry for the late reply.

On 03/14/2013 12:04 PM, Anand wrote:
>  From 62b6f575d1978a965339c69158bd10d0529815fb Mon Sep 17 00:00:00 20=
01
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Mon, 11 Mar 2013 20:20:19 +0530
> Subject: [PATCH V2 05/12] pm80xx: MSI-X implementation for using 64 i=
nterrupts
>
> Implementation of interrupt handlers and tasklets to support
> upto 64 interrupt for the device.
>
> Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
> Ack-by: Jack Wang <jack_wang@usish.com>
> ---
>   drivers/scsi/pm8001/pm8001_init.c |  456 ++++++++++++++++++++++++++=
+++++++++--
>   drivers/scsi/pm8001/pm8001_sas.h  |    1 +
>   2 files changed, 432 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/=
pm8001_init.c
> index e8a983f..95b6966 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -163,24 +163,33 @@ static void pm8001_free(struct pm8001_hba_info =
*pm8001_ha)
>   }
>
>   #ifdef PM8001_USE_TASKLET
> +
> +/**
> + * tasklet for 64 msi-x interrupt handler
> + * @opaque: the passed general host adapter struct
> + * Note: pm8001_tasklet is common for pm8001 & pm80xx
> + */
>   static void pm8001_tasklet(unsigned long opaque)
>   {
>   	struct pm8001_hba_info *pm8001_ha;
> +	u32 vec;
>   	pm8001_ha =3D (struct pm8001_hba_info *)opaque;
>   	if (unlikely(!pm8001_ha))
>   		BUG_ON(1);
> -	PM8001_CHIP_DISP->isr(pm8001_ha, 0);
> +	vec =3D pm8001_ha->int_vector;
> +	PM8001_CHIP_DISP->isr(pm8001_ha, vec);
>   }
>   #endif
>
> +/**
> + * pm8001_interrupt_handler_x -main interrupt handler invokde for al=
l interrupt.
> + * It obtains the vector number and calls the equivalent bottom half=
 or services
> + * directly.
> + * @vec: vector number; will be 0 for none msi-x operation
> + * @opaque: the passed general host adapter struct
> + */
>
> - /**
> -  * pm8001_interrupt - when HBA originate a interrupt,we should invo=
ke this
> -  * dispatcher to handle each case.
> -  * @irq: irq number.
> -  * @opaque: the passed general host adapter struct
> -  */
> -static irqreturn_t pm8001_interrupt(int irq, void *opaque)
> +static inline irqreturn_t pm8001_interrupt_handler_x(int vec, void *=
opaque)
>   {
>   	struct pm8001_hba_info *pm8001_ha;
>   	irqreturn_t ret =3D IRQ_HANDLED;
> @@ -190,6 +199,7 @@ static irqreturn_t pm8001_interrupt(int irq, void=
 *opaque)
>   		return IRQ_NONE;
>   	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
>   		return IRQ_NONE;
> +	pm8001_ha->int_vector =3D vec;
>   #ifdef PM8001_USE_TASKLET
>   	tasklet_schedule(&pm8001_ha->tasklet);
>   #else
> @@ -198,6 +208,365 @@ static irqreturn_t pm8001_interrupt(int irq, vo=
id *opaque)
>   	return ret;
>   }
>
> +/* 64 interrupt handlers for 64 msi-x vectors */
> +static irqreturn_t pm8001_interrupt_handler0(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(0, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler1(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(1, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler2(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(2, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler3(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(3, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler4(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(4, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler5(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(5, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler6(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(6, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler7(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(7, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler8(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(8, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler9(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(9, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler10(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(10, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler11(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(11, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler12(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(12, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler13(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(13, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler14(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(14, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler15(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(15, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler16(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(16, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler17(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(17, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler18(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(18, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler19(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(19, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler20(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(20, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler21(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(21, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler22(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(22, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler23(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(23, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler24(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(24, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler25(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(25, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler26(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(26, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler27(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(27, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler28(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(28, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler29(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(29, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler30(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(30, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler31(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(31, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler32(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(32, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler33(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(33, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler34(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(34, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler35(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(35, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler36(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(36, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler37(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(37, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler38(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(38, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler39(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(39, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler40(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(40, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler41(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(41, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler42(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(42, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler43(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(43, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler44(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(44, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler45(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(45, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler46(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(46, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler47(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(47, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler48(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(48, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler49(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(49, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler50(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(50, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler51(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(51, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler52(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(52, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler53(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(53, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler54(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(54, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler55(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(55, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler56(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(56, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler57(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(57, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler58(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(58, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler59(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(59, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler60(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(60, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler61(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(61, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler62(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(62, dev_id);
> +}
> +
> +static irqreturn_t pm8001_interrupt_handler63(int irq, void *dev_id)
> +{
> +	return pm8001_interrupt_handler_x(63, dev_id);
> +}
> +
> +/* array of 64 interrupt handlers used during request_irq for msi-x =
int */
> +/* pm8001_interrupt_handler0 routine is common for pm8001 & pm80xx *=
/
> +static irqreturn_t (*pm8001_interrupt[PM8001_MAX_MSIX_VEC])
> +		(int vec, void *dev_id) =3D {
> +	pm8001_interrupt_handler0, pm8001_interrupt_handler1,
> +	pm8001_interrupt_handler2, pm8001_interrupt_handler3,
> +	pm8001_interrupt_handler4, pm8001_interrupt_handler5,
> +	pm8001_interrupt_handler6, pm8001_interrupt_handler7,
> +	pm8001_interrupt_handler8, pm8001_interrupt_handler9,
> +	pm8001_interrupt_handler10, pm8001_interrupt_handler11,
> +	pm8001_interrupt_handler12, pm8001_interrupt_handler13,
> +	pm8001_interrupt_handler14, pm8001_interrupt_handler15,
> +	pm8001_interrupt_handler16, pm8001_interrupt_handler17,
> +	pm8001_interrupt_handler18, pm8001_interrupt_handler19,
> +	pm8001_interrupt_handler20, pm8001_interrupt_handler21,
> +	pm8001_interrupt_handler22, pm8001_interrupt_handler23,
> +	pm8001_interrupt_handler24, pm8001_interrupt_handler25,
> +	pm8001_interrupt_handler26, pm8001_interrupt_handler27,
> +	pm8001_interrupt_handler28, pm8001_interrupt_handler29,
> +	pm8001_interrupt_handler30, pm8001_interrupt_handler31,
> +	pm8001_interrupt_handler32, pm8001_interrupt_handler33,
> +	pm8001_interrupt_handler34, pm8001_interrupt_handler35,
> +	pm8001_interrupt_handler36, pm8001_interrupt_handler37,
> +	pm8001_interrupt_handler38, pm8001_interrupt_handler39,
> +	pm8001_interrupt_handler40, pm8001_interrupt_handler41,
> +	pm8001_interrupt_handler42, pm8001_interrupt_handler43,
> +	pm8001_interrupt_handler44, pm8001_interrupt_handler45,
> +	pm8001_interrupt_handler46, pm8001_interrupt_handler47,
> +	pm8001_interrupt_handler48, pm8001_interrupt_handler49,
> +	pm8001_interrupt_handler50, pm8001_interrupt_handler51,
> +	pm8001_interrupt_handler52, pm8001_interrupt_handler53,
> +	pm8001_interrupt_handler54, pm8001_interrupt_handler55,
> +	pm8001_interrupt_handler56, pm8001_interrupt_handler57,
> +	pm8001_interrupt_handler58, pm8001_interrupt_handler59,
> +	pm8001_interrupt_handler60, pm8001_interrupt_handler61,
> +	pm8001_interrupt_handler62, pm8001_interrupt_handler63
> +};
> +
>   /**
>    * pm8001_alloc - initiate our hba structure and 6 DMAs area.
>    * @pm8001_ha:our hba structure.

Close, but no banana.

Please merge the interrupt handler into a common function; the=20
handler is already called with the interrupt vector number, so you=20
only need to provide a mapping between MSI-X vector and the internal=20
MSI interrupt enumeration.
Than can you get rid of all of this 'allocating 64 identical=20
functions' nonsense.

Check drivers/scsi/hpsa.c, which does a similar thing.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
