From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: add sd_unprep_fn to free discard page
Date: Thu, 01 Jul 2010 16:40:52 +0300
Message-ID: <4C2C9AE4.1050803@panasas.com>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, snitzer@redhat.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/01/2010 01:49 PM, FUJITA Tomonori wrote:
> This patchset fixes page leak issue in discard commands with unprep
> facility that James posted:
> 
> http://marc.info/?l=linux-scsi&m=127791727508214&w=2
> 
> The 1/3 patch adds unprep facility to the block layer (identical to
> what James posted).
> 

Alternatively to this patch you could also call scsi_driver->done()
on all commands. There are only two users (sd sr) it's not that bad to add
an if (blk_pc_req()) inside these ->done() function.

> The 2/3 patch frees a page for discard commands by using the unprep
> facility. James' original patch doesn't work since it accesses to
> rq->bio in q->unprep_rq_fn. We hit oops since q->unprep_rq_fn is
> called when all the data buffer (req->bio and scsi_data_buffer) in the
> request is freed.
> 
> I use rq->buffer to keep track of an allocated page as the block layer
> sets rq->buffer to the address of bio's page. scsi-ml (and llds) don't
> use rq->buffer (rq->buffer is set to NULL). So I can't say that I like
> it lots. Any other way to do that?
> 

rq->buffer is intended for block-driver use as well as req->special.
sd+scsi-ml is the block-driver here. req->special is used by scsi-ml
and rq->buffer is set to NULL inside the call to
scsi_setup_blk_pc_cmnd/scsi_setup_fs_cmnd. Since you set the ->buffer
after the call to scsi_setup_blk_pc_cmnd you should be in the clear.

I think scsi-ml should stop setting rq->buffer to NULL and leave it
be for ULD use. It is left from the time that LLDs where converted
to use BIOs, just to make sure out-of-tree drivers crash.

Boaz
> The 3/3 path just removes the dead code.
> 
> This is against Jens' for-2.6.36.
> 
> The git tree is also available:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git unprep
> 
> I'll update the discard FS request conversion on the top of this soon. But this can be applied independently (and fixes the memory leak).
> 
> =
>  block/blk-core.c        |   25 +++++++++++++++++++++++++
>  block/blk-settings.c    |   17 +++++++++++++++++
>  drivers/scsi/scsi_lib.c |    2 +-
>  drivers/scsi/sd.c       |   25 +++++++++++++++----------
>  include/linux/blkdev.h  |    4 ++++
>  5 files changed, 62 insertions(+), 11 deletions(-)
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
