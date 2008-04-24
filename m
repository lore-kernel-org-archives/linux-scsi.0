From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC 0/5] block large commands support continue
Date: Thu, 24 Apr 2008 13:31:21 +0900
Message-ID: <20080424133118Q.tomof@acm.org>
References: <480F4CC2.7070804@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <480F4CC2.7070804@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: bharrosh@panasas.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, pw@osc.edu, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 23 Apr 2008 17:50:42 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> The support for large commands was dropped from the for-2.6.26 branch
> and will probably not get accepted into next kernel.
> 
> I have tried to take all comments from Jens and Bart. and incorporate
> it into a new patchset. This is basically Tomo's patchset but with
> proposed changes.

Have you seen the patchset to remove request on the stack?

http://marc.info/?l=linux-ide&m=120882410712466&w=2


> They are based on current linux-block/master. They will probably conflict with
> latest patch sent by Tomo for the blk_get_request(). Once those patches
> get accepted at some git tree, (Where will that be?), I will rebase these
> on top of them. Please CC me of any progress.
> 
> [PATCH 1/5] block: no need to initialize rq->cmd
>   This is 2 of Tomo's patches squashed together as they are
>   small and do the same. Tomo is this OK?
> 
> [PATCH 2/5] block: replace sizeof(rq->cmd) with BLK_MAX_CDB
>   Tomos patch rebased to here
> 
> [PATCH 3/5] block: Export rq_init, rename to blk_init_rq
> [PATCH 4/5] block: Use new blk_init_rq
>   These patches are basically what Jens and Bart has suggested, that with
>   a small code change to blk-core.c we can memset at rq_init() and only set
>   none zero members. We can also export that initializer and use it all over
>   the ide tree where ever requests don't come from a request queue. (OK also
>   at scsi_error.c)

+void blk_init_rq(struct request_queue *q, struct request *rq, int cmd_flags)

Hmm, would it be better to modify the block layer to let rq_init just
memset() the request structure?


> [PATCH 5/5] block: add large command support
>   Now that all initialization goes through one place Tomos large command support
>   is trivial.
> 
> Bart. This is mostly ide changes, so please if you can test it. I do not have
> any legacy IDE devices here at the office, it is all new sata stuff.
> 
> I hope we can put this, and later the scsi stuff, on some tree that can be tested
> at -mm and hopefully be ready for 2.6.27
> 
> Thanks
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
