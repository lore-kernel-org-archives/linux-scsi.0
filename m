From: Mike Christie <mchristi@redhat.com>
Subject: Re: [dm-devel] [PATCH 19/32] block: add helper to get data dir from
 op
Date: Thu, 5 Nov 2015 11:34:07 -0600
Message-ID: <563B930F.7040705@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
 <1446674909-5371-20-git-send-email-mchristi@redhat.com>
 <563A8A33.3000002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <563A8A33.3000002@sandisk.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On 11/04/2015 04:44 PM, Bart Van Assche wrote:
> On 11/04/2015 02:08 PM, mchristi@redhat.com wrote:
>> From: Mike Christie <mchristi@redhat.com>
>>
>> In later patches the op will no longer be a bitmap, so we will
>> not have REQ_WRITE set for all non reads like discard, flush,
>> and write same. Drivers will still want to treat them as writes
>> for accounting reasons, so this patch adds a helper to translate
>> a op to a data direction.
>>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>> ---
>>   include/linux/blkdev.h | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 19c2e94..cf5f518 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -586,6 +586,18 @@ static inline void queue_flag_clear(unsigned int
>> flag, struct request_queue *q)
>>
>>   #define list_entry_rq(ptr)    list_entry((ptr), struct request,
>> queuelist)
>>
>> +/*
>> + * Non REQ_OP_WRITE requests like discard, write same, etc, are
>> + * considered WRITEs.
>> + */
>> +static inline int op_to_data_dir(int op)
>> +{
>> +    if (op == REQ_OP_READ)
>> +        return READ;
>> +    else
>> +        return WRITE;
>> +}
>> +
>>   #define rq_data_dir(rq)        ((int)((rq)->cmd_flags & 1))
>>
>>   /*
>>
> 
> How about introducing two functions - op_is_write() and op_is_read() ? I
> think that approach will result in shorter and easier to read code in
> the contexts where these functions are used.
> 

I can do that. You are right in how they are used. I just did the above,
to follow the other *_data_dir calls.

