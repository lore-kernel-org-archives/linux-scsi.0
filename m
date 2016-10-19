From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v3 04/11] blk-mq: Introduce blk_mq_quiesce_queue()
Date: Thu, 20 Oct 2016 07:47:46 +0800
Message-ID: <CACVXFVM1tRXPDkJZbrtxkgZ=Uy9iCAh3OvmHf5BC23RbJkbMKg@mail.gmail.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
 <e42a952c-f245-eb39-d0a1-0336035573f9@sandisk.com> <0718ec72-d525-2e75-a123-3bf9ea129319@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <0718ec72-d525-2e75-a123-3bf9ea129319@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 20, 2016 at 5:04 AM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 10/18/2016 02:50 PM, Bart Van Assche wrote:
>>
>> blk_mq_quiesce_queue() waits until ongoing .queue_rq() invocations
>> have finished. This function does *not* wait until all outstanding
>> requests have finished (this means invocation of request.end_io()).
>
>
> (replying to my own e-mail)
>
> The zero-day kernel test infrastructure reported to me that this patch
> causes a build failure with CONFIG_SRCU=n. Should I add "select SRCU" to
> block/Kconfig (excludes TINY_RCU) or should I rather modify this patch such

Select SRCU is fine, and you can see it is done in lots of
places(btrfs, net, quota, kvm, power,...)

> that a mutex or rwsem is used instead of SRCU?

Both should be much worse than SRCU, even not as good as atomic_t.

Thanks,
Ming

>
> Thanks,
>
> Bart.
>



-- 
Ming Lei
