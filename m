From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: Re: [BUG] scsi/qla2xxx: a possible sleep-in-atomic bug in qlt_get_tag
Date: Wed, 13 Dec 2017 15:38:20 +0800
Message-ID: <e6dc47be-50ef-a0dd-a07b-95e60a3103a1@gmail.com>
References: <0363371c-db1c-169f-df5f-ca15b3839e41@gmail.com>
 <1513140121.3110.78.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513140121.3110.78.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, qla2xxx-upstream@qlogic.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 2017/12/13 12:42, James Bottomley wrote:
> On Wed, 2017-12-13 at 11:18 +0800, Jia-Ju Bai wrote:
>> The driver may sleep under a spinlock.
>> The function call paths are:
>> qlt_handle_abts_recv_work (acquire the spinlock)
>>     qlt_response_pkt_all_vps
>>       qlt_response_pkt
>>         qlt_handle_cmd_for_atio
>>           qlt_get_tag
>>             percpu_ida_alloc --> may sleep
>>
>> qla82xx_msix_rsp_q (acquire the spinlock)
>>     qla24xx_process_response_queue
>>       qlt_handle_abts_recv
>>         qlt_response_pkt_all_vps
>>           qlt_response_pkt
>>             qlt_handle_cmd_for_atio
>>               qlt_get_tag
>>                 percpu_ida_alloc --> may sleep-in-atomic
>>
>> qla24xx_intr_handler (acquire the spinlock)
>>     qla24xx_process_response_queue
>>       qlt_handle_abts_recv
>>         qlt_response_pkt
>>           qlt_handle_cmd_for_atio
>>             qlt_get_tag
>>               percpu_ida_alloc --> may sleep
>>
>> I do not find a good way to fix it, so I only report.
>> This possible bug is found by my static analysis tool (DSAC) and
>> checked by my code review.
> The report is incorrect: percpu_ida_alloc with state==TASK_RUNNING is
> atomic (and interrupt) safe which appears to be the case here.
>
> James
>

Thanks for your reply :)
I have checked the definition of percpu_ida_alloc, and I think you are 
right.
Sorry for my incorrect bug report.


Thanks,
Jia-Ju Bai
