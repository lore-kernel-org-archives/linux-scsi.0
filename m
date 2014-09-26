From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH 2/8] scsi-mq: Add support for multiple hardware queues
Date: Fri, 26 Sep 2014 19:08:34 +0800
Message-ID: <CACVXFVMiYsW=dszQ6mE-o_L8fEDdkO59vJ5qeHKch5c33K_QXw@mail.gmail.com>
References: <541C27BF.6070609@acm.org>
	<541C281E.9090206@acm.org>
	<CAF9gx6JfP2bGyMauB6LzepZP_vKEvrd-sPZc5CRuOrtgQ_UCSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAF9gx6JfP2bGyMauB6LzepZP_vKEvrd-sPZc5CRuOrtgQ_UCSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Sep 20, 2014 at 2:05 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 9/19/2014 3:57 PM, Bart Van Assche wrote:
>> Allow a SCSI LLD to declare how many hardware queues it supports
>> by setting Scsi_Host.nr_hw_queues before calling scsi_add_host().
>>
>> Note: it is assumed that each hardware queue has a queue depth of
>> shost->can_queue. In other words, the total queue depth per host
>> is (number of hardware queues) * (shost->can_queue).
>>
>> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> ---
>>   drivers/scsi/scsi_lib.c  | 2 +-
>>   include/scsi/scsi_host.h | 4 ++++
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index d837dc1..b0b6117 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -2071,7 +2071,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>>
>>   memset(&shost->tag_set, 0, sizeof(shost->tag_set));
>>   shost->tag_set.ops = &scsi_mq_ops;
>> - shost->tag_set.nr_hw_queues = 1;
>> + shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
>>   shost->tag_set.queue_depth = shost->can_queue;
>>   shost->tag_set.cmd_size = cmd_size;
>>   shost->tag_set.numa_node = NUMA_NO_NODE;
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index ba20347..0a867d9 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -638,6 +638,10 @@ struct Scsi_Host {
>>   short unsigned int sg_prot_tablesize;
>>   unsigned int max_sectors;
>>   unsigned long dma_boundary;
>> + /*
>> + * In scsi-mq mode, the number of hardware queues supported by the LLD.
>> + */
>> + unsigned nr_hw_queues;
>>   /*
>>   * Used to assign serial numbers to the cmds.
>>   * Protected by the host lock.
>>
>
> I think this patch should be squashed with passing LLD hctx patch (in
> whatever form it ends up).

I suggest to apply this patch and related scsi-mq multi hw-queue
enablement patches first, so that any scsi drivers capable of
multi hw-queue can go without waiting for passing hctx
patches which may take a bit long since lots of drivers are involved,
as Jens said, the mapping from req to hctx is quite cheap.


Thanks,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
