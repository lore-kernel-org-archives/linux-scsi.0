From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: PR API fixes for multipathing
Date: Sat, 16 Jul 2016 14:10:07 -0400
Message-ID: <20160716181007.GA14215@redhat.com>
References: <1467980631-18945-1-git-send-email-hch@lst.de>
 <yq1y452iuzp.fsf@sermon.lab.mkp.net>
 <20160716010844.GA29087@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbcGPSKJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jul 2016 14:10:09 -0400
Content-Disposition: inline
In-Reply-To: <20160716010844.GA29087@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Fri, Jul 15 2016 at  9:08pm -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Jul 15, 2016 at 03:03:54PM -0400, Martin K. Petersen wrote:
> > >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> > 
> > Christoph> I was a bit overeager to thing ALL_TG_PT would solve all our
> > Christoph> multipathing woes in respect to persistent reservation.
> > Christoph> Turns out that there are lots of possible setups where it
> > Christoph> doesn't work, and we'll have to ask device mapper to register
> > Christoph> all underlying devices instead.
> > 
> > Should I queue the sd patch or let Mike take both through the DM tree?
> 
> I think having both in the same tree would be very useful.  I don't care
> which one that is.

I've picked both of them up.  Staged for 4.8 merge and in linux-next via
linux-dm.git's 'for-next'.

(I added Martin's Acked-by to the sd patch header, Martin: if not OK, or
if you'd prefer Reviewed-by just let me know)

Christoph, I had to fix this:

drivers/md/dm.c:2564:12: warning: context imbalance in 'dm_call_pr' - different lock contexts for basic block

here is the incremental I folded in to the dm patch:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 214fa03..4dca5a7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2567,14 +2567,13 @@ static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
        struct mapped_device *md = bdev->bd_disk->private_data;
        struct dm_table *table;
        struct dm_target *ti;
-       int ret = 0, srcu_idx;
+       int ret = -ENOTTY, srcu_idx;

        table = dm_get_live_table(md, &srcu_idx);
        if (!table || !dm_table_get_size(table))
-               return -ENOTTY;
+               goto out;

        /* We only support devices that have a single target */
-       ret = -ENOTTY;
        if (dm_table_get_num_targets(table) != 1)
                goto out;
        ti = dm_table_get_target(table, 0);
@@ -2584,10 +2583,6 @@ static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
                goto out;

        ret = ti->type->iterate_devices(ti, fn, data);
-       if (ret)
-               goto out;
-
-       ret = 0;
 out:
        dm_put_live_table(md, srcu_idx);
        return ret;

Mike
