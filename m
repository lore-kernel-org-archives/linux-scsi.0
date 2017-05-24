From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/31] block: Avoid that blk_exit_rl() triggers a
 use-after-free
Date: Wed, 24 May 2017 07:55:52 +0200
Message-ID: <de6847ba-e58a-7fe5-a2d2-58b00daf5a46@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-10-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-10-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/24/2017 02:33 AM, Bart Van Assche wrote:
> Since the introduction of the .init_rq_fn() and .exit_rq_fn() it
> is essential that the memory allocated for struct request_queue
> stays around until all blk_exit_rl() calls have finished. Hence
> make blk_init_rl() take a reference on struct request_queue.
> 
> This patch fixes the following crash:
> 
> general protection fault: 0000 [#2] SMP
> CPU: 3 PID: 28 Comm: ksoftirqd/3 Tainted: G      D         4.12.0-rc2-dbg+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> task: ffff88013a108040 task.stack: ffffc9000071c000
> RIP: 0010:free_request_size+0x1a/0x30
> RSP: 0018:ffffc9000071fd38 EFLAGS: 00010202
> RAX: 6b6b6b6b6b6b6b6b RBX: ffff880067362a88 RCX: 0000000000000003
> RDX: ffff880067464178 RSI: ffff880067362a88 RDI: ffff880135ea4418
> RBP: ffffc9000071fd40 R08: 0000000000000000 R09: 0000000100180009
> R10: ffffc9000071fd38 R11: ffffffff81110800 R12: ffff88006752d3d8
> R13: ffff88006752d3d8 R14: ffff88013a108040 R15: 000000000000000a
> FS:  0000000000000000(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fa8ec1edb00 CR3: 0000000138ee8000 CR4: 00000000001406e0
> Call Trace:
>  mempool_destroy.part.10+0x21/0x40
>  mempool_destroy+0xe/0x10
>  blk_exit_rl+0x12/0x20
>  blkg_free+0x4d/0xa0
>  __blkg_release_rcu+0x59/0x170
>  rcu_process_callbacks+0x260/0x4e0
>  __do_softirq+0x116/0x250
>  smpboot_thread_fn+0x123/0x1e0
>  kthread+0x109/0x140
>  ret_from_fork+0x31/0x40
> 
> Fixes: commit e9c787e65c0c ("scsi: allocate scsi_cmnd structures as part of struct request")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: <stable@vger.kernel.org> # v4.11+
> ---
>  block/blk-cgroup.c |  2 +-
>  block/blk-core.c   | 10 ++++++++--
>  block/blk-sysfs.c  |  2 +-
>  block/blk.h        |  2 +-
>  4 files changed, 11 insertions(+), 5 deletions(-)
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
