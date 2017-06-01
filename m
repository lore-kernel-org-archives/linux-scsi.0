From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: Re: [PATCH] megaraid: Fix a sleep-in-atomic bug
Date: Thu, 01 Jun 2017 11:38:51 +0800
Message-ID: <592F8C4B.3080109@163.com>
References: <1496199416-2556-1-git-send-email-baijiaju1990@163.com> <ecd2b8137043d6c6b75c4f44b963bebd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ecd2b8137043d6c6b75c4f44b963bebd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/31/2017 06:18 PM, Sumit Saxena wrote:
>> -----Original Message-----
>> From: Jia-Ju Bai [mailto:baijiaju1990@163.com]
>> Sent: Wednesday, May 31, 2017 8:27 AM
>> To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
>> shivasharan.srikanteshwara@broadcom.com; jejb@linux.vnet.ibm.com;
>> martin.petersen@oracle.com
>> Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Jia-Ju Bai
>> Subject: [PATCH] megaraid: Fix a sleep-in-atomic bug
>>
>> The driver may sleep under a spin lock, and the function call path is:
>> mraid_mm_attach_buf (acquire the lock by spin_lock_irqsave)
>>   pci_pool_alloc(GFP_KERNEL) -->  may sleep
>>
>> To fix it, the "GFP_KERNEL" is replaced with "GFP_ATOMIC".
>>
>> Signed-off-by: Jia-Ju Bai<baijiaju1990@163.com>
>> ---
>> drivers/scsi/megaraid/megaraid_mm.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_mm.c
>> b/drivers/scsi/megaraid/megaraid_mm.c
>> index 4cf9ed9..c43afb8 100644
>> --- a/drivers/scsi/megaraid/megaraid_mm.c
>> +++ b/drivers/scsi/megaraid/megaraid_mm.c
>> @@ -574,7 +574,7 @@
>>
>> 	kioc->pool_index	= right_pool;
>> 	kioc->free_buf		= 1;
>> -	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
>> +	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_ATOMIC,
>> 							&kioc->buf_paddr);
>> 	spin_unlock_irqrestore(&pool->lock, flags);
> This is very old driver and reached EOL. Did you face any issue because of
> this bug or discover this through code review?
> Anyways patch looks good to me.
>
> Acked-by: Sumit Saxena<sumit.saxena@broadcom.com>
>
>> --
>> 1.7.9.5
>>
Hi,

This bug is found by a static analysis tool and my code review.

Jia-Ju Bai
