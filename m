From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] 2.4.27-pre2: another loss of SCSI I/O initiative and
	system freeze
Date: Tue, 04 May 2004 20:31:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1083717070.2942.5207.camel@compaq.xsintricity.com>
References: <OFA9ADACA9.EF1DD108-ONC1256E8A.005FBA48-C1256E8A.0063BC83@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:11747 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261900AbUEEAfa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2004 20:35:30 -0400
In-Reply-To: <OFA9ADACA9.EF1DD108-ONC1256E8A.005FBA48-C1256E8A.0063BC83@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>, andmike@us.ibm.com, axboe@suse.de, garloff@suse.de

On Tue, 2004-05-04 at 14:04, Martin Peschke3 wrote:
> 
> 
> Marcelo, Doug,
> 
> Please consider the following patch for inclusion. It fixes a severe
> loss-of-initiative SCSI problem that can cause a system freeze.

Marcelo, I have no objection to this, but I haven't personally verified
it either (and my bk trees are out of date so integrating it yourself is
probably quickest).

> The problem is that blk_finish_sectors() needs a valid block
> queue pointer in order to kick more I/Os off, while _scsi_insert_special()
> appears to have a license to kill the block queue pointers of SCSI
> requests.
> Hence, the problem is likely to occur if SCSI commands are retried,
> e.g. after a QUEUE_FULL or BUSY response. Since this hitch slowly
> builds up by losing more and more valid pointers and generating
> misfires more often, I also suspect a SCSI performance decrease
> prior to a total freeze.
> 
> The fix is to have blk_finish_sectors() take a block queue pointer
> instead of a request pointer.
> 
> We found the problem during tests and subsequent debugging
> with the zfcp driver on the SUSE Linux Enterprise Server.
> This is Jens' version of the fix, which made it into newer SUSE kernels.
> 
> Please apply.
> 
> Martin
> 
> 
> diff -ur linux-2.4.27-pre2-ref/drivers/block/ll_rw_blk.c linux-2.4.27-pre2/drivers/block/ll_rw_blk.c
> --- linux-2.4.27-pre2-ref/drivers/block/ll_rw_blk.c   2004-04-14 15:05:29.000000000 +0200
> +++ linux-2.4.27-pre2/drivers/block/ll_rw_blk.c 2004-05-04 19:13:42.000000000 +0200
> @@ -1465,7 +1465,7 @@
>       if ((bh = req->bh) != NULL) {
>             nsect = bh->b_size >> 9;
>             blk_finished_io(nsect);
> -           blk_finished_sectors(req, nsect);
> +           blk_finished_sectors(req->q, nsect);
>             req->bh = bh->b_reqnext;
>             bh->b_reqnext = NULL;
>             bh->b_end_io(bh, uptodate);
> diff -ur linux-2.4.27-pre2-ref/drivers/scsi/scsi_lib.c linux-2.4.27-pre2/drivers/scsi/scsi_lib.c
> --- linux-2.4.27-pre2-ref/drivers/scsi/scsi_lib.c     2004-04-14 15:05:31.000000000 +0200
> +++ linux-2.4.27-pre2/drivers/scsi/scsi_lib.c   2004-05-04 19:13:42.000000000 +0200
> @@ -378,7 +378,7 @@
>             if ((bh = req->bh) != NULL) {
>                   nsect = bh->b_size >> 9;
>                   blk_finished_io(nsect);
> -                 blk_finished_sectors(req, nsect);
> +                 blk_finished_sectors(q, nsect);
>                   req->bh = bh->b_reqnext;
>                   bh->b_reqnext = NULL;
>                   sectors -= nsect;
> diff -ur linux-2.4.27-pre2-ref/include/linux/blkdev.h linux-2.4.27-pre2/include/linux/blkdev.h
> --- linux-2.4.27-pre2-ref/include/linux/blkdev.h      2004-02-18 14:36:32.000000000 +0100
> +++ linux-2.4.27-pre2/include/linux/blkdev.h    2004-05-04 19:13:42.000000000 +0200
> @@ -323,9 +323,8 @@
>       }
>  }
> 
> -static inline void blk_finished_sectors(struct request *rq, int count)
> +static inline void blk_finished_sectors(request_queue_t *q, int count)
>  {
> -     request_queue_t *q = rq->q;
>       if (q && q->can_throttle) {
>             atomic_sub(count, &q->nr_sectors);
-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


