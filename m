From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2 4/7] blk-mq: Introduce blk_quiesce_queue() and blk_resume_queue()
Date: Thu, 6 Oct 2016 00:11:31 +0800
Message-ID: <CACVXFVPG4_mK=VuVsWqvuXPxw0Y0pTCd1ZTXZV=DxqzfXC-O5g@mail.gmail.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
 <a9eb4e95-6d77-e527-c42a-fd2e6f104bed@sandisk.com> <CACVXFVOO4P3RsnWci8XHdFoYBhNPq0KqjWJddsie-92+31bpEg@mail.gmail.com>
 <9fb67745-954c-a70f-a89a-d184c99ae9aa@sandisk.com> <CACVXFVMY19vuDjsECg2uX0_y_K7DUaaGqXPX9PYiBy5sfXmAEw@mail.gmail.com>
 <a11bb09a-6207-f4a8-cfd4-4fe5627c1700@sandisk.com> <CACVXFVO21wDRrZtB0A5qn5KEn-rjnewQxYyN_aAWoQrKSMvmig@mail.gmail.com>
 <b42d5056-c2cb-8f0f-1a65-70740605ff22@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b42d5056-c2cb-8f0f-1a65-70740605ff22@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 5, 2016 at 10:46 PM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 10/04/16 21:32, Ming Lei wrote:
>>
>> On Wed, Oct 5, 2016 at 12:16 PM, Bart Van Assche
>> <bart.vanassche@sandisk.com> wrote:
>>>
>>> On 10/01/16 15:56, Ming Lei wrote:
>>>>
>>>>
>>>> If we just call the rcu/srcu read lock(or the mutex) around .queue_rq(),
>>>> the above code needn't to be duplicated any more.
>>>
>>>
>>> Can you have a look at the attached patch? That patch uses an srcu read
>>> lock
>>> for all queue types, whether or not the BLK_MQ_F_BLOCKING flag has been
>>> set.
>>
>>
>> That is much cleaner now.
>>
>>> Additionally, I have dropped the QUEUE_FLAG_QUIESCING flag. Just like
>>> previous versions, this patch has been tested.
>>
>>
>> I think the flag of QUEUE_FLAG_QUIESCING is still needed because we
>> have to set this flag to prevent new coming .queue_rq() from being run,
>> and synchronize_srcu() won't wait for completion of that at all (see
>> section of 'Update-Side Primitives' in [1]).
>>
>> [1] https://lwn.net/Articles/202847/
>
>
> Hello Ming,
>
> How about using the existing flag BLK_MQ_S_STOPPED instead of introducing a
> new QUEUE_FLAG_QUIESCING flag? From the comment above blk_mq_quiesce_queue()

That looks fine, and we need to stop direct issue first after hw queue
becomes BLK_MQ_S_STOPPED.

> in the patch that was attached to my previous e-mail: "Additionally, it is
> not prevented that new queue_rq() calls occur unless the queue has been
> stopped first."
>
> Thanks,
>
> Bart.



-- 
Ming Lei
