From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 3/8] nvmet: Use p2pmem in nvme target
Date: Tue, 4 Apr 2017 10:16:56 -0600
Message-ID: <ec05b7d9-8dfd-8227-84d2-7d391df32219@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-4-git-send-email-logang@deltatee.com>
 <bce6b009-7756-3cf7-5053-2628b26c8d97@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bce6b009-7756-3cf7-5053-2628b26c8d97-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



On 04/04/17 04:40 AM, Sagi Grimberg wrote:
> Hey Logan,
> 
>> We create a configfs attribute in each nvme-fabrics target port to
>> enable p2p memory use. When enabled, the port will only then use the
>> p2p memory if a p2p memory device can be found which is behind the
>> same switch as the RDMA port and all the block devices in use. If
>> the user enabled it an no devices are found, then the system will
>> silently fall back on using regular memory.
> 
> What should we do if we have more than a single device that satisfies
> this? I'd say that it would be better to have the user ask for a
> specific device and fail it if it doesn't meet the above conditions...

I hadn't done this yet but I think a simple closest device in the tree
would solve the issue sufficiently. However, I originally had it so the
user has to pick the device and I prefer that approach. But if the user
picks the device, then why bother restricting what he picks? Per the
thread with Sinan, I'd prefer to use what the user picks. You were one
of the biggest opponents to that so I'd like to hear your opinion on
removing the restrictions.

>> Ideally, we'd want to use an NVME CMB buffer as p2p memory. This would
>> save an extra PCI transfer as the NVME card could just take the data
>> out of it's own memory. However, at this time, cards with CMB buffers
>> don't seem to be available.
> 
> Even if it was available, it would be hard to make real use of this
> given that we wouldn't know how to pre-post recv buffers (for in-capsule
> data). But let's leave this out of the scope entirely...

I don't understand what you're referring to. We'd simply use the CMB
buffer as a p2pmem device, why does that change anything?

> Why do you need this? you have a reference to the
> queue itself.

This keeps track of whether the response was actually allocated with
p2pmem or not. It's needed for when we free the SGL because the queue
may have a p2pmem device assigned to it but, if the alloc failed and it
fell back on system memory then we need to know how to free it. I'm
currently looking at having SGLs having an iomem flag. In which case,
this would no longer be needed as the flag in the SGL could be used.


>> +    rsp->p2pmem = rsp->queue->p2pmem;
>>      status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
>> -            len);
>> +            len, rsp->p2pmem);
>> +
>> +    if (status && rsp->p2pmem) {
>> +        rsp->p2pmem = NULL;
>> +        status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
>> +                          len, rsp->p2pmem);
>> +    }
>> +
> 
> Not sure its a good practice to rely on rsp->p2pmem not being NULL...
> Would be nice if the allocation routines can hide it from us...

I'm not sure what the reasoning is behind your NULL comment.

Yes, I'm currently considering pushing an alloc/free sgl into the p2pmem
code.

>>      if (status)
>>          return status;
>>
>> @@ -984,6 +1009,7 @@ static void nvmet_rdma_free_queue(struct
>> nvmet_rdma_queue *queue)
>>                  !queue->host_qid);
>>      }
>>      nvmet_rdma_free_rsps(queue);
>> +    p2pmem_put(queue->p2pmem);
> 
> What does this pair with? p2pmem_find_compat()?

Yes, that's correct.


>> +static void nvmet_rdma_queue_setup_p2pmem(struct nvmet_rdma_queue
>> *queue)
>> +{
>> +    struct device **dma_devs;
>> +    struct nvmet_ns *ns;
>> +    int ndevs = 1;
>> +    int i = 0;
>> +    struct nvmet_subsys_link *s;
>> +
>> +    if (!queue->port->allow_p2pmem)
>> +        return;
>> +
>> +    list_for_each_entry(s, &queue->port->subsystems, entry) {
>> +        list_for_each_entry_rcu(ns, &s->subsys->namespaces, dev_link) {
>> +            ndevs++;
>> +        }
>> +    }
> 
> This code has no business in nvmet-rdma. Why not keep nr_ns in
> nvmet_subsys in the first place?

That makes sense.

>> +
>> +    dma_devs = kmalloc((ndevs + 1) * sizeof(*dma_devs), GFP_KERNEL);
>> +    if (!dma_devs)
>> +        return;
>> +
>> +    dma_devs[i++] = &queue->dev->device->dev;
>> +
>> +    list_for_each_entry(s, &queue->port->subsystems, entry) {
>> +        list_for_each_entry_rcu(ns, &s->subsys->namespaces, dev_link) {
>> +            dma_devs[i++] = disk_to_dev(ns->bdev->bd_disk);
>> +        }
>> +    }
>> +
>> +    dma_devs[i++] = NULL;
>> +
>> +    queue->p2pmem = p2pmem_find_compat(dma_devs);
> 
> This is a problem. namespaces can be added at any point in time. No one
> guarantee that dma_devs are all the namepaces we'll ever see.

Yeah, well restricting p2pmem based on all the devices in use is hard.
So we'd need a call into the transport every time an ns is added and
we'd have to drop the p2pmem if they add one that isn't supported. This
complexity is just one of the reasons I prefer just letting the user chose.

>> +
>> +    if (queue->p2pmem)
>> +        pr_debug("using %s for rdma nvme target queue",
>> +             dev_name(&queue->p2pmem->dev));
>> +
>> +    kfree(dma_devs);
>> +}
>> +
>>  static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
>>          struct rdma_cm_event *event)
>>  {
>> @@ -1199,6 +1271,8 @@ static int nvmet_rdma_queue_connect(struct
>> rdma_cm_id *cm_id,
>>      }
>>      queue->port = cm_id->context;
>>
>> +    nvmet_rdma_queue_setup_p2pmem(queue);
>> +
> 
> Why is all this done for each queue? looks completely redundant to me.

A little bit. Where would you put it?

>>      ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
>>      if (ret)
>>          goto release_queue;
> 
> You seemed to skip the in-capsule buffers for p2pmem (inline_page), I'm
> curious why?

Yes, the thinking was that these transfers were small anyway so there
would not be significant benefit to pushing them through p2pmem. There's
really no reason why we couldn't do that if it made sense to though.

Logan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
