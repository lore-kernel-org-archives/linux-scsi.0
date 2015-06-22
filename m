From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Mon, 22 Jun 2015 08:43:47 -0700
Message-ID: <1434987827.2237.71.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1506221050590.1799-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60592 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbbFVPnt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jun 2015 11:43:49 -0400
In-Reply-To: <Pine.LNX.4.44L0.1506221050590.1799-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, James Bottomley <JBottomley@Parallels.com>, Jun Itou <itou_jun@infoseek.jp>, Markus Rathgeb <maggu2810@gmail.com>, Matt <vickm78@hotmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Mon, 2015-06-22 at 10:55 -0400, Alan Stern wrote:
> Some USB mass-storage devices claim to have a write-back cache but
> don't support the SYNCHRONIZE CACHE command, which means there is no
> way to tell these devices to flush their caches out to permanent
> storage.  Unfortunately, there is nothing we can do about this.
> 
> Until recently this deficiency did not cause any noticeable problems.
> But following commit 89fb4cd1f717 ("scsi: handle flush errors
> properly"), the errors are propagated to userspace where they get
> reported as failures.
> 
> As a workaround, this patch adds a quirks flag for these devices to
> the usb-storage driver, and a corresponding SCSI device flag, to
> indicate the device can't handle SYNCHRONIZE CACHE.  If the flag is
> set, the sd driver will override the cache settings reported by the
> device, so that the device appears to be write-through.  This will
> prevent the unsupported command from being sent.
> 
> This addresses Bugzilla #89511.

I'm not sure I entirely like this:  we are back again treating data
corruption problems silently.

However, I also believe treating a single flush failure as a critical
filesystem error is also wrong:  The data's all there correctly; all it
does is introduce a potential window were the FS could get corrupted in
the unlikely event the system crashed.

Obviously, for a disk with a writeback cache that can't do flush, that
window is much wider and the real solution should be to try to switch
the cache to write through.
How about something like this patch?  It transforms FS FLUSH into a log
warning from an error but preserves the error on any other path.  You'll
still get a fairly continuous dump of warnings for one of these devices,
though ... do they respond to mode selects turning off the writeback?

James

---

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 20badd7..bb9f9f3 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -173,10 +173,21 @@ static bool blk_flush_complete_seq(struct request *rq,
 	BUG_ON(rq->flush.seq & seq);
 	rq->flush.seq |= seq;
 
-	if (likely(!error))
+	if (likely(!error)) {
 		seq = blk_flush_cur_seq(rq);
-	else
+	} else {
 		seq = REQ_FSEQ_DONE;
+		printk_ratelimited(KERN_ERR "%s: flush failed: data integrity problem\n",
+				   rq->rq_disk ? rq->rq_disk->disk_name : "?");
+		/*
+		 * returning an error to the FS is wrong: the data is all
+		 * there, it just might not be written out in the expected
+		 * order and thus have a window where the integrity is suspect
+		 * in a crash.  Given the small likelihood of actually
+		 * crashing, we should just log a warning here.
+		 */
+		error = 0;
+	}
 
 	switch (seq) {
 	case REQ_FSEQ_PREFLUSH:


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
