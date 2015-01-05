From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Mon, 05 Jan 2015 12:38:04 -0700
Message-ID: <54AAE81C.2080402@kernel.dk>
References: <54A43CFB.2080705@oracle.com> <20150105091516.GA22226@lst.de> <54AADF6A.6090100@kernel.dk> <20150105193213.GA31955@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150105193213.GA31955@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sasha Levin <sasha.levin@oracle.com>, bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 01/05/2015 12:32 PM, Christoph Hellwig wrote:
> On Mon, Jan 05, 2015 at 12:00:58PM -0700, Jens Axboe wrote:
>> That's not quite true, the only guarantee is that it WILL execute on the
>> CPU (or CPUs) that are set in the mask. So unless it ends up offloading
>> the run to a specific workqueue, we'll disable preempt in the current
>> path before ->queue_rq() is called.
> 
> Oops.  Indeed, with those recent changes ->queue_rq can't safely block
> for memory allocatios anymore.
> 
> The patch below should fix it:
> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: scsi: ->queue_rq can't sleep
> 
> Since Linux 3.19 blk-mq may disable preemption before calling into
> ->queue_rq, so we can't actually sleep anymore.

That was true in earlier kernels as well, going back a few versions at
least, preempt was disabled on calling __blk_mq_run_hw_queue(). Just
checked, and 3.16 and later have that as the behaviour. The only change
in 3.19 some shuffling around to avoid double preempt_disable in some
cases, it's now using get_cpu() and friends.

So we probably want do mark that as stable so we reach back to when
scsi-mq was added, unless the originally referenced patch getting rid of
the gfp_t mask didn't have the issue.


-- 
Jens Axboe
