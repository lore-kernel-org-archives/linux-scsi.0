From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 4/7] blk-mq: Introduce blk_quiesce_queue() and
 blk_resume_queue()
Date: Wed, 5 Oct 2016 12:05:48 -0700
Message-ID: <6d612be9-7ba7-888e-f9c6-f8aa4ef1606a@sandisk.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
 <a9eb4e95-6d77-e527-c42a-fd2e6f104bed@sandisk.com>
 <CACVXFVOO4P3RsnWci8XHdFoYBhNPq0KqjWJddsie-92+31bpEg@mail.gmail.com>
 <9fb67745-954c-a70f-a89a-d184c99ae9aa@sandisk.com>
 <CACVXFVMY19vuDjsECg2uX0_y_K7DUaaGqXPX9PYiBy5sfXmAEw@mail.gmail.com>
 <a11bb09a-6207-f4a8-cfd4-4fe5627c1700@sandisk.com>
 <09238e87-7d60-89c9-98b0-e51caa0c0839@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <09238e87-7d60-89c9-98b0-e51caa0c0839@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/05/2016 11:14 AM, Sagi Grimberg wrote:
>> Hello Ming,
>>
>> Can you have a look at the attached patch? That patch uses an srcu read
>> lock for all queue types, whether or not the BLK_MQ_F_BLOCKING flag has
>> been set. Additionally, I have dropped the QUEUE_FLAG_QUIESCING flag.
>> Just like previous versions, this patch has been tested.
>
> Hey Bart,
>
> Do we care about the synchronization of queue_rq and/or
> blk_mq_run_hw_queue of the hctx is not stopped?
>
> I'm wandering if we can avoid introducing new barriers in the
> submission path of its not absolutely needed.

Hello Sagi,

I'm not sure whether the new blk_quiesce_queue() function is useful 
without stopping all hardware contexts first. In other words, in my view 
setting BLK_MQ_F_BLOCKING flag before calling blk_quiesce_queue() is 
sufficient and I don't think that a new QUEUE_FLAG_QUIESCING flag is 
necessary.

Bart.
