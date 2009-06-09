From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt handler
Date: Tue, 9 Jun 2009 14:46:12 -0700
Message-ID: <6FEBF8A9-AA4F-496A-B549-AE5D4275A8A4@qlogic.com>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local> <1244575944.12321.58.camel@mulgrave.site> <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com> <1244580029.12321.138.camel@mulgrave.site> <alpine.OSX.1.00.0906091436120.4405@ac-mac.local> <20090609214342.GQ3274@parisc-linux.org>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46897 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZFIVqK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 17:46:10 -0400
In-Reply-To: <20090609214342.GQ3274@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "douglas.w.styner@intel.com" <douglas.w.styner@intel.com>


On Jun 9, 2009, at 2:43 PM, Matthew Wilcox wrote:

> On Tue, Jun 09, 2009 at 02:40:44PM -0700, Anirban Chakraborty wrote:
>> On Tue, 9 Jun 2009, James Bottomley wrote:
>>> It depends what the root cause is ... if it's really latency  
>>> introduced
>>> by other interrupts, then IRQF_DISABLED might be the better  
>>> course.  If
>>> it's purely interrupt problems in the spin locked critical sections,
>>> then spin_lock_irq might be the better solution ... what would be  
>>> useful
>>> is to have the test rig at intel which turned up the problem see  
>>> what
>>> happens to the results for each case.
>>
>> I have attached the patch with IRQF_DISABLED. In my setup, I didn't  
>> find any
>> significant difference in performance numbers between IRQF_DISABLED  
>> and
>> spin_lock_irqsave. It would be interesting to see the numbers from  
>> Douglas's
>> rig.
>> Doug, could you please run it once more with this patch and let us  
>> know the
>> numbers vs. the one you already tested with spin_lock_irqsave  
>> earlier.
>> Thanks much,
>> Anirban
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/ 
>> qla_isr.c
>> index c8d0a17..d07bd97 100644
>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>> @@ -1991,7 +1991,7 @@ skip_msix:
>> skip_msi:
>>
>> 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
>> -	    IRQF_SHARED, QLA2XXX_DRIVER_NAME, rsp);
>> +	    IRQF_DISABLED, QLA2XXX_DRIVER_NAME, rsp);
>> 	if (ret) {
>> 		qla_printk(KERN_WARNING, ha,
>> 		    "Failed to reserve interrupt %d already in use.\n",
>
> While I don't think Doug has MSI-X adapters, a complete patch would  
> change
> all request_irq() calls to use IRQF_DISABLED, right?
>
> --

The above patch takes care of replacing all the IRQF_SHARED flags in  
irq registrations with IRQF_DISABLED.
Thanks,
Anirban

