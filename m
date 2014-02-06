From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: [PATCH 01/15] block: rework flush sequencing for blk-mq
Date: Wed, 5 Feb 2014 18:08:37 -0800
Message-ID: <CAFR8ueegsgqiTruZkGxeSL4KCyxYzZUzqvWw42ZLiOZgUapH8w@mail.gmail.com>
References: <20140205124118.332902571@bombadil.infradead.org>
	<20140205124152.299135922@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40624 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaBFCIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 21:08:37 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so1102913pde.7
        for <linux-scsi@vger.kernel.org>; Wed, 05 Feb 2014 18:08:37 -0800 (PST)
In-Reply-To: <20140205124152.299135922@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Feb 5, 2014 at 4:41 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Switch to using a preallocated flush_rq for blk-mq similar to what's done
> with the old request path.  This allows us to set up the request properly
> with a tag from the actually allowed range and ->rq_disk as needed by
> some drivers.  To make life easier we also switch to dynamic allocation
> of ->flush_rq for the old path.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c       |   15 ++++++--
>  block/blk-flush.c      |   97 +++++++++++++++++-------------------------------
>  block/blk-mq.c         |   26 ++++++-------
>  block/blk-mq.h         |    1 +
>  block/blk-sysfs.c      |    2 +
>  include/linux/blk-mq.h |    2 +-
>  include/linux/blkdev.h |    9 +----
>  7 files changed, 65 insertions(+), 87 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index c00e0bd..d3eb330 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -693,11 +693,20 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
>         if (!uninit_q)
>                 return NULL;
>
> +       uninit_q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);


Shouldn't this be kzalloc_node()?

Rest in this patch looks ok...
