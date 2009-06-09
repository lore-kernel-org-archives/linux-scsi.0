From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
 handler
Date: Tue, 09 Jun 2009 19:32:24 +0000
Message-ID: <1244575944.12321.58.camel@mulgrave.site>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49927 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345AbZFITc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 15:32:27 -0400
In-Reply-To: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: linux-scsi@vger.kernel.org, douglas.w.styner@intel.com

On Tue, 2009-06-09 at 11:42 -0700, Anirban Chakraborty wrote:
> Reverted back a change from spin_lock to spin_lock_irq* that was causing
> the cycle times to go up.
> The patch is based on scsi-misc-2.6.

Some more explanation of this would be greatly appreciated.  The cause
looks to be that holding off interrupts in the isr could potentially
reduce latency (caused by taking a different interrupt while holding the
hardware lock) and increase the chance of coalescing (by holding off
interrupts).  However, if that's the case, possibly using an
IRQF_DISABLED isr rather than going back to spin_lock_irqsave() would be
a better fix?

> Reported-and-checked-by: Douglas W. Styner <douglas.w.styner@intel.com>
> Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c |   30 ++++++++++++++++++------------
>  1 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index c8d0a17..bc92feb 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -37,6 +37,7 @@ qla2100_intr_handler(int irq, void *dev_id)
>  	uint16_t	hccr;
>  	uint16_t	mb[4];
>  	struct rsp_que *rsp;
> +	unsigned long	flags;
>  
>  	rsp = (struct rsp_que *) dev_id;
>  	if (!rsp) {
> @@ -49,7 +50,7 @@ qla2100_intr_handler(int irq, void *dev_id)
>  	reg = &ha->iobase->isp;
>  	status = 0;
>  
> -	spin_lock(&ha->hardware_lock);
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
>  	vha = pci_get_drvdata(ha->pdev);
>  	for (iter = 50; iter--; ) {
>  		hccr = RD_REG_WORD(&reg->hccr);
> @@ -101,7 +102,7 @@ qla2100_intr_handler(int irq, void *dev_id)
>  			RD_REG_WORD(&reg->hccr);
>  		}
>  	}
> -	spin_unlock(&ha->hardware_lock);
> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
>  	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>  	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
> @@ -133,6 +134,7 @@ qla2300_intr_handler(int irq, void *dev_id)
>  	uint16_t	mb[4];
>  	struct rsp_que *rsp;
>  	struct qla_hw_data *ha;
> +	unsigned long	flags;
>  
>  	rsp = (struct rsp_que *) dev_id;
>  	if (!rsp) {
> @@ -145,7 +147,7 @@ qla2300_intr_handler(int irq, void *dev_id)
>  	reg = &ha->iobase->isp;
>  	status = 0;
>  
> -	spin_lock(&ha->hardware_lock);
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
>  	vha = pci_get_drvdata(ha->pdev);
>  	for (iter = 50; iter--; ) {
>  		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
> @@ -216,7 +218,7 @@ qla2300_intr_handler(int irq, void *dev_id)
>  		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
>  		RD_REG_WORD_RELAXED(&reg->hccr);
>  	}
> -	spin_unlock(&ha->hardware_lock);
> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
>  	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>  	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
> @@ -1626,6 +1628,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
>  	uint32_t	hccr;
>  	uint16_t	mb[4];
>  	struct rsp_que *rsp;
> +	unsigned long	flags;
>  
>  	rsp = (struct rsp_que *) dev_id;
>  	if (!rsp) {
> @@ -1638,7 +1641,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
>  	reg = &ha->iobase->isp24;
>  	status = 0;
>  
> -	spin_lock(&ha->hardware_lock);
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
>  	vha = pci_get_drvdata(ha->pdev);
>  	for (iter = 50; iter--; ) {
>  		stat = RD_REG_DWORD(&reg->host_status);
> @@ -1688,7 +1691,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
>  		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
>  		RD_REG_DWORD_RELAXED(&reg->hccr);
>  	}
> -	spin_unlock(&ha->hardware_lock);
> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
>  	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>  	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
> @@ -1706,6 +1709,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
>  	struct rsp_que *rsp;
>  	struct device_reg_24xx __iomem *reg;
>  	struct scsi_qla_host *vha;
> +	unsigned long	flags;
>  
>  	rsp = (struct rsp_que *) dev_id;
>  	if (!rsp) {
> @@ -1716,13 +1720,13 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
>  	ha = rsp->hw;
>  	reg = &ha->iobase->isp24;
>  
> -	spin_lock_irq(&ha->hardware_lock);
> +	spin_lock_irqsave(&ha->hardware_lock, flags);

This doesn't make a lot of sense.  I can see in the ordinary isr above,
you were using spin_lock not spin_lock_irq, so you were going into the
spin with other interrupts enabled.  However, in the MSIX case, the net
effect of the code (since we enter with interrupts enabled) is nil plus
the small latency saving and restoring the flags.

I'm assuming Intel did the tests on a MSIX system, so I have a hard time
understanding how this could in any way fix their problem.

James


