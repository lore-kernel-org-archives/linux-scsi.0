From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH 10/12] qla2xxx: Fix a bug that clears the interrupt status register for the base queue
Date: Thu, 6 Aug 2009 08:56:24 -0700
Message-ID: <7E6E03F3-C937-45D7-8F8D-202928F1AE2A@qlogic.com>
References: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com> <1249078174-1957-11-git-send-email-giridhar.malavali@qlogic.com> <1249419733.3939.47.camel@mulgrave.site>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:19465 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbZHFP40 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2009 11:56:26 -0400
In-Reply-To: <1249419733.3939.47.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

James,

Myself and Anirban re-sent the patches with the changes. Just wanted  
to check whether the patches looks fine. I can send the complete  
patches again in case it helps you. Please let me know.

Thanks,
Giridhar.M.B

On Aug 4, 2009, at 2:02 PM, James Bottomley wrote:

> On Fri, 2009-07-31 at 15:09 -0700, giridhar.malavali@qlogic.com wrote:
>> From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
>>
>> The interrupt handler clears the interrupt status register for  
>> response updates in the
>> base queue while working in the multique mode. This could lead to  
>> missing interrupt for
>> async events, mail box completions etc. as these are also handled  
>> in the base queue.
>> The fix ensures that the interrupt bit is not cleared for response  
>> updates in the ISR
>> when the driver is working in multiqueue mode.
>>
>> Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> ---
>> drivers/scsi/qla2xxx/qla_isr.c |    3 ++-
>> 1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/ 
>> qla_isr.c
>> index 40014f3..175b20b 100644
>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>> @@ -1769,7 +1769,8 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
>>
>> 	vha = qla25xx_get_host(rsp);
>> 	qla24xx_process_response_queue(vha, rsp);
>> -	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
>> +	if (!ha->mqenable)
>> +		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
>>
>> 	spin_unlock_irq(&ha->hardware_lock);
>
> Assuming this is the only thing that clears the interrupt line, isn't
> this asking for a re-interrupt in a posted write scenario?  Don't you
> want to do a read to flush the posted write before enabling  
> interrupts?
>
> James
>
>

