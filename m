From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] IB/srp: Fix a sleep-in-invalid-context bug
Date: Tue, 9 Jan 2018 07:43:02 +0100
Message-ID: <5c04bb31-1197-85ca-9a4e-5cdedeca96d4@suse.de>
References: <20180108185011.30018-1-bart.vanassche@wdc.com>
 <20180108185011.30018-5-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180108185011.30018-5-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/08/2018 07:50 PM, Bart Van Assche wrote:
> The previous two patches guarantee that srp_queuecommand() does not get
> invoked while reconnecting occurs. Hence remove the code from
> srp_queuecommand() that prevents command queueing while reconnecting.
> This patch avoids that the following can appear in the kernel log:
> 
> BUG: sleeping function called from invalid context at kernel/locking/mutex.c:747
> in_atomic(): 1, irqs_disabled(): 0, pid: 5600, name: scsi_eh_9
> 1 lock held by scsi_eh_9/5600:
>  #0:  (rcu_read_lock){....}, at: [<00000000cbb798c7>] __blk_mq_run_hw_queue+0xf1/0x1e0
> Preemption disabled at:
> [<00000000139badf2>] __blk_mq_delay_run_hw_queue+0x78/0xf0
> CPU: 9 PID: 5600 Comm: scsi_eh_9 Tainted: G        W        4.15.0-rc4-dbg+ #1
> Hardware name: Dell Inc. PowerEdge R720/0VWT90, BIOS 2.5.4 01/22/2016
> Call Trace:
>  dump_stack+0x67/0x99
>  ___might_sleep+0x16a/0x250 [ib_srp]
>  __mutex_lock+0x46/0x9d0
>  srp_queuecommand+0x356/0x420 [ib_srp]
>  scsi_dispatch_cmd+0xf6/0x3f0
>  scsi_queue_rq+0x4a8/0x5f0
>  blk_mq_dispatch_rq_list+0x73/0x440
>  blk_mq_sched_dispatch_requests+0x109/0x1a0
>  __blk_mq_run_hw_queue+0x131/0x1e0
>  __blk_mq_delay_run_hw_queue+0x9a/0xf0
>  blk_mq_run_hw_queue+0xc0/0x1e0
>  blk_mq_start_hw_queues+0x2c/0x40
>  scsi_run_queue+0x18e/0x2d0
>  scsi_run_host_queues+0x22/0x40
>  scsi_error_handler+0x18d/0x5f0
>  kthread+0x11c/0x140
>  ret_from_fork+0x24/0x30
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Doug Ledford <dledford@redhat.com>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
