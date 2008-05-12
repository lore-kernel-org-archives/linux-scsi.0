From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi_scan: WARNING: at include/linux/blkdev.h:431
	blk_queue_init_tags+0x107/0x120()
Date: Mon, 12 May 2008 10:59:28 -0500
Message-ID: <1210607968.3078.15.camel@localhost.localdomain>
References: <alpine.LNX.1.00.0805020043130.1489@dragon.funnycrock.com>
	 <20080502111652T.tomof@acm.org>
	 <1210200026.3067.25.camel@localhost.localdomain>
	 <20080508125532W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60014 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755497AbYELRfT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2008 13:35:19 -0400
In-Reply-To: <20080508125532W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, jesper.juhl@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2008-05-08 at 12:55 +0900, FUJITA Tomonori wrote: 
> On Wed, 07 May 2008 17:40:26 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > The problem is that the commit 75ad23b expects that we hold the queue
> > > lock for __blk_queue_free_tags, blk_queue_free_tags and
> > > blk_queue_init_tags but we haven't.
> > > 
> > > The simple fix is using queue_flag_set/clear_unlocked for them, then
> > > it should work as before. However, it would be better to hold the
> > > queue lock for blk_queue_free_tags and blk_queue_init_tags (we can
> > > hold the queue lock in scsi_activate_tcq and scsi_deactivate_tcq).
> > 
> > So is this the fix that everyone agrees on?  And if so, whose tree is it
> > going through (I tend to think block, since the original breakage came
> > from the block tree).
> 
> The patch is fine from the perspective of the SCSI mid-layer. But it
> would be not from the perspective of the block layer. For example,
> blk_queue_init_tags is expected to be called with holding the queue
> lock (since it could call blk_queue_resize_tags internally) though
> only the SCSI mid-layer uses those APIs for now.

There are two cases for blk_queue_init_tags; one is for a shared tag map
and the other is for individual tag maps.  If you look at the code and
its use, blk_queue_resize_tags is *only* called for the individual tag
map case (or for the first caller in a shared tag map case).

The blk_queue_resize_tags() also returns -EBUSY on shared tag maps,
except the first one; which really exposes a bug in SCSI: we want to set
the shared tag map to some host specific depth and then carve off pieces
of it in the devices, so we don't want to adjust the queue down to
whatever the first seen device wants, and we don't want all other
devices to fail to adjust the scsi_queue depth the mid-layer uses.

This should fix up scsi.

James

---
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 110e776..cc0af0f 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -893,9 +893,11 @@ void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 
-	/* Check to see if the queue is managed by the block layer.
-	 * If it is, and we fail to adjust the depth, exit. */
+	/* Check to see if the queue is managed by the block layer,
+	 * and that we don't have a shared tag map.  If so, and we
+	 * fail to adjust the depth, exit. */
 	if (blk_queue_tagged(sdev->request_queue) &&
+	    !sdev->host->bqt &&
 	    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
 		goto out;
 



