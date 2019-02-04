From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] RDMA/srp: Rework SCSI device reset handling
Date: Mon, 4 Feb 2019 16:31:58 -0700
Message-ID: <20190204233158.GA14895@ziepe.ca>
References: <20190130220555.8949-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190130220555.8949-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 30, 2019 at 02:05:55PM -0800, Bart Van Assche wrote:
> Since .scsi_done() must only be called after scsi_queue_rq() has
> finished, make sure that the SRP initiator driver does not call
> .scsi_done() while scsi_queue_rq() is in progress. Although
> invoking sg_reset -d while I/O is in progress works fine with kernel
> v4.20 and before, that is not the case with kernel v5.0-rc1. This
> patch avoids that the following crash is triggered with kernel
> v5.0-rc1:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
> CPU: 0 PID: 360 Comm: kworker/0:1H Tainted: G    B             5.0.0-rc1-dbg+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> Workqueue: kblockd blk_mq_run_work_fn
> RIP: 0010:blk_mq_dispatch_rq_list+0x116/0xb10
> Call Trace:
>  blk_mq_sched_dispatch_requests+0x2f7/0x300
>  __blk_mq_run_hw_queue+0xd6/0x180
>  blk_mq_run_work_fn+0x27/0x30
>  process_one_work+0x4f1/0xa20
>  worker_thread+0x67/0x5b0
>  kthread+0x1cf/0x1f0
>  ret_from_fork+0x24/0x30
> 
> Cc: Sergey Gorenko <sergeygo@mellanox.com>
> Cc: Max Gurtovoy <maxg@mellanox.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 94a9174c630c ("IB/srp: reduce lock coverage of command completion") # v2.6.38
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> 
> Changes compared to v1: left out the code that waits until in-progress requests
>   have finished.

Applied to for-rc

Thanks,
Jason
