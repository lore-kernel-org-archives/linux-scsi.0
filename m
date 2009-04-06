From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: SCSI Hardware Handler and slow failover with large
	number of LUNS
Date: Mon, 06 Apr 2009 13:54:46 -0500
Message-ID: <49DA4FF6.50601@cs.wisc.edu>
References: <1238880636.11478.8.camel@chandra-ubuntu>	
	<49DA2331.8020609@cs.wisc.edu>
	<1239042098.25764.14.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1239042098.25764.14.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, "Moger,
	Babu" <Babu.Moger@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> Thanks for the response Mike.
> 
> On Mon, 2009-04-06 at 10:43 -0500, Mike Christie wrote:
>> Chandra Seetharaman wrote:
>>> Hello All,
>>>
>>> During testing with the latest SCSI DH Handler on a rdac storage, Babu
>>> found that the failover time with 100+ luns takes about 15 minutes,
>>> which is not good.
>>>
>>> We found that the problem is due to the fact that we serialize activate
>>> in dm on the work queue.
>>>
>> I thought we talked about this during the review?
> 
> Yes, we did and the results were compared to the virgin code (w.r.t rdac
> handler) and the results were good (also I used only 49 luns) :
> http://marc.info/?l=dm-devel&m=120889858019762&w=2
> 
> 
>>> We can solve the problem in rdac handler in 2 ways
>>>  1. batch up the activates (mode_selects) and send few of them.
>>>  2. Do mode selects in async mode.
>> I think most of the ugliness in the original async mode was due to 
>> trying to use the REQ_BLOCK* path. With the scsi_dh_activate path, it 
>> should now be easier because in the send path we do not have to worry 
>> about queue locks being held and context.
>>
> 
> little confused... we still are using REQ_TYPE_BLOCK_PC
> 

But we only have one level of requests. I am talking about when we tried 
to send a request with REQ_BLOCK_LINUX_BLOCK to the module to tell it to 
send another request/s with REQ_TYPE_BLOCK_PC. Now we just have the 
callout and then like you said we can fire REQ_TYPE_BLOCK_PC reuqests 
from there.

I think when I wrote easier above, I meant to write a cleaner 
implementation.



>> I think we could just use blk_execute_rq_nowait to send the IO. Then we 
>> would have a workqueue/thread per something (maybe per dh module I 
>> thought), that would be queued/notified when the IO completed. The 
>> thread could then process the IO and handle the next stage if needed.
>>
>> Why use the thread you might wonder? I think it fixes another issue with 
>> the original async mode, and makes it easier if the scsi_dh module has 
> 
> can you elaborate the issue ?


I think people did not like the complexity of trying to send IO with 
soft irq context with spin locks held, then also having the extra 
REQ_BLOCK_LINUX_BLOCK layering.


> 
>> to send more IO. When using the thread it would not have to worry about 
>> the queue_lock being held in the IO completion path and does not have to 
>> worry about being run from more restrictive contexts.
> 
> You think queue_lock contention is an issue ?
> 
> I agree with the restrictive context issue though.
> 
> So, your suggestion is to move everything to async ?
> 

Do mean vs #1 or would you want to seperate and send some stuff async 
and synchronously?

>>
>>> Just wondering if anybody had seen the same problem in other storages
>>> (EMC, HP and Alua). 
>> They should all have the same problem.
>>
>>
>>> Please share your experiences, so we can come up with a solution that
>>> works for all hardware handlers.
>>>
>>> regards,
>>>
>>> chandra
>>>
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
