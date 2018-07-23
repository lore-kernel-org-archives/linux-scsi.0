From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: Re: [PATCH] firewire: sbp2: Replace GFP_ATOMIC with GFP_KERNEL in
 sbp2_scsi_queuecommand()
Date: Mon, 23 Jul 2018 20:53:02 +0800
Message-ID: <78f1f5e5-1080-c801-eae5-72f5cbff0b63@gmail.com>
References: <20180723085801.6711-1-baijiaju1990@gmail.com>
 <20180723142418.4aef4910@kant>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180723142418.4aef4910@kant>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks for the reply :)


On 2018/7/23 20:24, Stefan Richter wrote:
> Adding Cc: LSML
>
> On Jul 23 Jia-Ju Bai wrote:
>> sbp2_scsi_queuecommand() is only set to .queuecommand of
>> "struct scsi_host_template", and this function pointer is never called
>> in atomic context.
> As far as I remember, scsi_host_template::queuecommand() can be invoked
> from either process context or tasklet context, predominantly the latter.
>
> I haven't followed recent developments of the block and scsi stack, hence
> don't know if this has changed fundamentally.
>
> But even if it is purely process context now and no spinlocks held, the
> memory allocation must be done so that the kernel does not go into memory
> reclaim. Otherwise this could deadlock.

Okay.
In fact, my tool does not find that queuecommand() can be called from 
tasklet context.
Maybe my tool is not very accurate when handling the function pointer call.

>
>> sbp2_scsi_queuecommand() calls kzalloc() with GFP_ATOMIC,
>> which is not necessary.
>> GFP_ATOMIC can be replaced with GFP_KERNEL.
>>
>> This is found by a static analysis tool named DCNS written by myself.
> I doubt that static analysis, even if very sophisticated, can detect
> deadlock scenarios such as I noted.

Sorry, I am not sure to understand the deadlock scenarios you mentioned.
Could you please give an example?
Maybe I can write a static tool to detect such deadlocks.

>
>> I also manually check the kernel code before reporting it.
> What does it mean?  Did you run-time test it, for which actual SBP-2
> hardware is required?  (Such a test could detect GFP-KERNEL use in atomic
> context, but would not reliably detect memory reclaim related deadlocks.)

Sorry, my description here may bring misunderstanding.
It means that I manually review the code and validated my report, 
instead of perform runtime testing, because I do not have the hardware.
Maybe I neglected something in my code review, so I am not very 
confident...

>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   drivers/firewire/sbp2.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
>> index 6bac03999fd4..a7cd9d87eb02 100644
>> --- a/drivers/firewire/sbp2.c
>> +++ b/drivers/firewire/sbp2.c
>> @@ -1463,7 +1463,7 @@ static int sbp2_scsi_queuecommand(struct Scsi_Host *shost,
>>   	struct sbp2_command_orb *orb;
>>   	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
>>   
>> -	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
>> +	orb = kzalloc(sizeof(*orb), GFP_KERNEL);
>>   	if (orb == NULL)
>>   		return SCSI_MLQUEUE_HOST_BUSY;
>>   
> NACK for GFP_KERNEL, but I am curious whether a weaker GFP set than ATOMIC
> is possible in scsi_host_template::queuecommand.

like what? GFP_NOIO or GFP_NOFS?


Best wishes,
Jia-Ju Bai
