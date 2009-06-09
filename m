From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt handler
Date: Tue, 9 Jun 2009 13:34:23 -0700
Message-ID: <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local> <1244575944.12321.58.camel@mulgrave.site>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:38321 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZFIUeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 16:34:21 -0400
In-Reply-To: <1244575944.12321.58.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "douglas.w.styner@intel.com" <douglas.w.styner@intel.com>


On Jun 9, 2009, at 12:32 PM, James Bottomley wrote:

> On Tue, 2009-06-09 at 11:42 -0700, Anirban Chakraborty wrote:
>> Reverted back a change from spin_lock to spin_lock_irq* that was  
>> causing
>> the cycle times to go up.
>> The patch is based on scsi-misc-2.6.
>
> Some more explanation of this would be greatly appreciated.  The cause
> looks to be that holding off interrupts in the isr could potentially
> reduce latency (caused by taking a different interrupt while holding  
> the
> hardware lock) and increase the chance of coalescing (by holding off
> interrupts).  However, if that's the case, possibly using an
> IRQF_DISABLED isr rather than going back to spin_lock_irqsave()  
> would be
> a better fix?
The primary cause is, as you mentioned, the contention for the  
hardware lock in the isr.
I'll check it with IRQF_DISABLED too. However, I was wondering if  
there is any additional savings if we use IRQF_DISABLED vs. using the  
spin_lock_irqsave. In the former case, probably we'd enter the isr  
with interrupts disabled and in the latter case it would be done upon  
entering the isr.

>
>
>> Reported-and-checked-by: Douglas W. Styner <douglas.w.styner@intel.com 
>> >
>> Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
>> ---
>> drivers/scsi/qla2xxx/qla_isr.c |   30 ++++++++++++++++++------------
>> 1 files changed, 18 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/ 
>> qla_isr.c
>> index c8d0a17..bc92feb 100644
>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>> @@ -37,6 +37,7 @@ qla2100_intr_handler(int irq, void *dev_id)
>> 	uint16_t	hccr;
>> 	uint16_t	mb[4];
>> 	struct rsp_que *rsp;
>> +	unsigned long	flags;
>>
>> 	rsp = (struct rsp_que *) dev_id;
>> 	if (!rsp) {
>> @@ -49,7 +50,7 @@ qla2100_intr_handler(int irq, void *dev_id)
>> 	reg = &ha->iobase->isp;
>> 	status = 0;
>>
>> -	spin_lock(&ha->hardware_lock);
>> +	spin_lock_irqsave(&ha->hardware_lock, flags);
>> 	vha = pci_get_drvdata(ha->pdev);
>> 	for (iter = 50; iter--; ) {
>> 		hccr = RD_REG_WORD(&reg->hccr);
>> @@ -101,7 +102,7 @@ qla2100_intr_handler(int irq, void *dev_id)
>> 			RD_REG_WORD(&reg->hccr);
>> 		}
>> 	}
>> -	spin_unlock(&ha->hardware_lock);
>> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>>
>> 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>> 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>> @@ -133,6 +134,7 @@ qla2300_intr_handler(int irq, void *dev_id)
>> 	uint16_t	mb[4];
>> 	struct rsp_que *rsp;
>> 	struct qla_hw_data *ha;
>> +	unsigned long	flags;
>>
>> 	rsp = (struct rsp_que *) dev_id;
>> 	if (!rsp) {
>> @@ -145,7 +147,7 @@ qla2300_intr_handler(int irq, void *dev_id)
>> 	reg = &ha->iobase->isp;
>> 	status = 0;
>>
>> -	spin_lock(&ha->hardware_lock);
>> +	spin_lock_irqsave(&ha->hardware_lock, flags);
>> 	vha = pci_get_drvdata(ha->pdev);
>> 	for (iter = 50; iter--; ) {
>> 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
>> @@ -216,7 +218,7 @@ qla2300_intr_handler(int irq, void *dev_id)
>> 		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
>> 		RD_REG_WORD_RELAXED(&reg->hccr);
>> 	}
>> -	spin_unlock(&ha->hardware_lock);
>> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>>
>> 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>> 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>> @@ -1626,6 +1628,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
>> 	uint32_t	hccr;
>> 	uint16_t	mb[4];
>> 	struct rsp_que *rsp;
>> +	unsigned long	flags;
>>
>> 	rsp = (struct rsp_que *) dev_id;
>> 	if (!rsp) {
>> @@ -1638,7 +1641,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
>> 	reg = &ha->iobase->isp24;
>> 	status = 0;
>>
>> -	spin_lock(&ha->hardware_lock);
>> +	spin_lock_irqsave(&ha->hardware_lock, flags);
>> 	vha = pci_get_drvdata(ha->pdev);
>> 	for (iter = 50; iter--; ) {
>> 		stat = RD_REG_DWORD(&reg->host_status);
>> @@ -1688,7 +1691,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
>> 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
>> 		RD_REG_DWORD_RELAXED(&reg->hccr);
>> 	}
>> -	spin_unlock(&ha->hardware_lock);
>> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>>
>> 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>> 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>> @@ -1706,6 +1709,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
>> 	struct rsp_que *rsp;
>> 	struct device_reg_24xx __iomem *reg;
>> 	struct scsi_qla_host *vha;
>> +	unsigned long	flags;
>>
>> 	rsp = (struct rsp_que *) dev_id;
>> 	if (!rsp) {
>> @@ -1716,13 +1720,13 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
>> 	ha = rsp->hw;
>> 	reg = &ha->iobase->isp24;
>>
>> -	spin_lock_irq(&ha->hardware_lock);
>> +	spin_lock_irqsave(&ha->hardware_lock, flags);
>
> This doesn't make a lot of sense.  I can see in the ordinary isr  
> above,
> you were using spin_lock not spin_lock_irq, so you were going into the
> spin with other interrupts enabled.  However, in the MSIX case, the  
> net
> effect of the code (since we enter with interrupts enabled) is nil  
> plus
> the small latency saving and restoring the flags.
>
> I'm assuming Intel did the tests on a MSIX system, so I have a hard  
> time
> understanding how this could in any way fix their problem.
>
> James
>
They did their tests on a system with MSI enabled, for which the  
qla24xx_intr_handler gets invoked. So, the qla24xx_msix_rsp_q never  
got tested in that case. However, I do agree that spin_lock_irqsave is  
not needed in the MSI-X case as you mentioned that the interrupts are  
already disabled here.
Thanks,
-Anirban

