From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/31] block: Avoid that blk_exit_rl() triggers a
 use-after-free
Date: Wed, 24 May 2017 11:09:32 -0400
Message-ID: <20170524150932.GC24798@htj.duckdns.org>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-10-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35398 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932464AbdEXPJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 11:09:35 -0400
Content-Disposition: inline
In-Reply-To: <20170524003420.5381-10-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org

On Tue, May 23, 2017 at 05:33:58PM -0700, Bart Van Assche wrote:
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

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
