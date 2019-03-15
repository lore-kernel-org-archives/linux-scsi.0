From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC PATCH] scsi: fix oops in scsi_uninit_cmd()
Date: Fri, 15 Mar 2019 15:56:56 +0800
Message-ID: <CACVXFVMWDD+8rrVh9TYnA6awLPQZNscC6OrYmpAizj9PxxuZJw@mail.gmail.com>
References: <20190219072743.13606-1-yanaijie@huawei.com> <1550595388.31902.133.camel@acm.org>
 <20190220151836.GA11695@infradead.org> <10ea95ec-e259-3511-44c4-58e4d255eb9f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <10ea95ec-e259-3511-44c4-58e4d255eb9f@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Dan Williams <dan.j.williams@intel.com>, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 21, 2019 at 4:55 PM Jason Yan <yanaijie@huawei.com> wrote:
>
> Hi, Christoph
>
> On 2019/2/20 23:18, Christoph Hellwig wrote:
> > [fullquote removed, please follow proper mail etiquette]
> >
> > On Tue, Feb 19, 2019 at 08:56:28AM -0800, Bart Van Assche wrote:
> >> regression in the SCSI sd driver due to the switch from the legacy block
> >> layer to scsi-mq. The above patch introduces two atomic operations in the
> >> hot path and hence would introduce a performance regression. I think this
> >> can be avoided by making sure that sd_uninit_command() gets called before
> >> the request tag is freed. What changes would be required to make the block
> >> layer core call sd_uninit_command() before the request tag is freed? Would
> >> introducing prep_rq_fn and unprep_rq_fn callbacks in struct blk_mq_ops and
> >> making sure that the SCSI core sets these callback function pointers
> >> appropriately be sufficient? Would such a change allow to simplify the NVMe
> >> initiator driver? Are there any alternatives to this approach that are more
> >> elegant?
> >
> > Additional indirect calls in the I/O fast path is something I'd rather
> > avoid.  But I don't fully understand the problem yet - where do
> > we release a disk reference from blk_update_request?
>
> When userspace close the fd after blk_update_request() and before
> scsi_mq_uninit_cmd(), a disk reference will be released. It is not the
> blk_update_request() directly released it.
>
> close
>     ->sd_release
>        ->scsi_disk_put
>          ->scsi_disk_release
>            ->disk->private_data = NULL;
>
> The userspace can close the fd because blk_update_request() returned the
> last IO , the userspace application does not have to stuck on read() or
> write(). The window is very small, but it can be reproduce every day
> in our testcases. So I'm very curious why. One possible explanation is
> that we enabled kernel preempt(CONFIG_PREEMPT).

Another solution is to drain in-flight FS IO in scsi_disk_release(),
and one counter
is needed for tracking in-flight passthrough IO, so we can use sdev->device_busy
- sdev->passthrough_ios to drain inflight FS IO.

>
> And why can't
> > we move that release to __blk_mq_end_request?

I think it is doable, then ending bio needs to be moved out of
blk_update_request(),
such as, add one list of rq->done_bio to track completed bio, then complete all
in free request.

And for partial completion, the completed bio can be done in
blk_update_request(),
since the remained bios will cause fs to hold the disk.


Thanks,
Ming Lei
