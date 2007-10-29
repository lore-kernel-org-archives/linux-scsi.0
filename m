From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SCSI/gdth: kill unneeded 'irq' argument
Date: Mon, 29 Oct 2007 11:22:27 +0200
Message-ID: <4725A653.8070404@panasas.com>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org> <bdd7a2edf0951f98b9dde3e3465e4fd9263db79e.1193390975.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa10.bezeqint.net ([192.115.104.24]:41297 "EHLO
	sa10.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXJ2JWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 05:22:40 -0400
In-Reply-To: <bdd7a2edf0951f98b9dde3e3465e4fd9263db79e.1193390975.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Fri, Oct 26 2007 at 11:40 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Neither gdth_get_status() nor __gdth_interrupt() need their 'irq'
> argument, so remove it.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/scsi/gdth.c |   21 +++++++++------------
>  1 files changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index b253b8c..65c21b1 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -141,7 +141,7 @@
>  static void gdth_delay(int milliseconds);
>  static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
>  static irqreturn_t gdth_interrupt(int irq, void *dev_id);
> -static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
> +static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
>                                      int gdth_from_wait, int* pIndex);
>  static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
>                                                                 Scsi_Cmnd *scp);
> @@ -165,7 +165,6 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
>  static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
>  
>  static void gdth_enable_int(gdth_ha_str *ha);
> -static unchar gdth_get_status(gdth_ha_str *ha, int irq);
>  static int gdth_test_busy(gdth_ha_str *ha);
>  static int gdth_get_cmd_index(gdth_ha_str *ha);
>  static void gdth_release_event(gdth_ha_str *ha);
> @@ -1334,14 +1333,12 @@ static void __init gdth_enable_int(gdth_ha_str *ha)
>  }
>  
>  /* return IStatus if interrupt was from this card else 0 */
> -static unchar gdth_get_status(gdth_ha_str *ha, int irq)
> +static unchar gdth_get_status(gdth_ha_str *ha)
>  {
>      unchar IStatus = 0;
>  
> -    TRACE(("gdth_get_status() irq %d ctr_count %d\n", irq, gdth_ctr_count));
> +    TRACE(("gdth_get_status() irq %d ctr_count %d\n", ha->irq, gdth_ctr_count));
>  
> -        if (ha->irq != (unchar)irq)             /* check IRQ */
> -            return false;
>          if (ha->type == GDT_EISA)
>              IStatus = inb((ushort)ha->bmic + EDOORREG);
>          else if (ha->type == GDT_ISA)
> @@ -1523,7 +1520,7 @@ static int gdth_wait(gdth_ha_str *ha, int index, ulong32 time)
>          return 1;                               /* no wait required */
>  
>      do {
> -        __gdth_interrupt(ha, (int)ha->irq, true, &wait_index);
> +        __gdth_interrupt(ha, true, &wait_index);
>          if (wait_index == index) {
>              answer_found = TRUE;
>              break;
> @@ -3036,7 +3033,7 @@ static void gdth_clear_events(void)
>  
>  /* SCSI interface functions */
>  
> -static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
> +static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
>                                      int gdth_from_wait, int* pIndex)
>  {
>      gdt6m_dpram_str __iomem *dp6m_ptr = NULL;
> @@ -3054,7 +3051,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
>      int act_int_coal = 0;       
>  #endif
>  
> -    TRACE(("gdth_interrupt() IRQ %d\n",irq));
> +    TRACE(("gdth_interrupt() IRQ %d\n", ha->irq));
>  
>      /* if polling and not from gdth_wait() -> return */
>      if (gdth_polling) {
> @@ -3067,7 +3064,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
>          spin_lock_irqsave(&ha->smp_lock, flags);
>  
>      /* search controller */
> -    if (0 == (IStatus = gdth_get_status(ha, irq))) {
> +    if (0 == (IStatus = gdth_get_status(ha))) {
>          /* spurious interrupt */
>          if (!gdth_polling)
>              spin_unlock_irqrestore(&ha->smp_lock, flags);
> @@ -3294,9 +3291,9 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
>  
>  static irqreturn_t gdth_interrupt(int irq, void *dev_id)
>  {
> -	gdth_ha_str *ha = (gdth_ha_str *)dev_id;
> +	gdth_ha_str *ha = dev_id;
>  
> -	return __gdth_interrupt(ha, irq, false, NULL);
> +	return __gdth_interrupt(ha, false, NULL);
>  }
>  
>  static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
ACK
I've done the last heavy lifting of gdth_interrupt. And I second this patch.
the irq was just redundant information to the ha pointer. Good riddance.

Boaz
 
