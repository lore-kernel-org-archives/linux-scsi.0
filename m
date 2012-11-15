From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/iblock: Fix double iblock_complete_cmd callback
 bug
Date: Thu, 15 Nov 2012 14:36:30 -0800
Message-ID: <1353018990.11597.35.camel@haakon2.linux-iscsi.org>
References: <1352404739-22881-1-git-send-email-nab@linux-iscsi.org>
	 <20121115104922.GA28956@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39766 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2KOWgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2012 17:36:33 -0500
In-Reply-To: <20121115104922.GA28956@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>

On Thu, 2012-11-15 at 05:49 -0500, Christoph Hellwig wrote:
> On Thu, Nov 08, 2012 at 07:58:59PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch fixes a double completion bug where ibr->pending = 2 usage
> > plus the extra callback to iblock_complete_cmd() invoked after bio
> > submission in iblock_execute_rw() can interfere with the normal
> > bio->bi_done() -> iblock_bio_done() -> iblock_complete_cmd() completion
> > path, causing a double target_complete_cmd() call to occur.
> 
> How so exactly?  Please provide an explanation, and preferably a test
> case.
> 

So, I was getting a bit confused here while debugging Kelsey's issue
with dispatched multiple bios throwing an with a virtio-blk backend.

However, setting the default ibr->pending=2 value before dispatch, and
making a extra iblock_complete_cmd() call from iblock_execute_rw(),
while doing the normal iblock_complete_cmd() calls from
iblock_bio_done() is AFAICT a pointless extra atomic_dec_and_test() call
per I/O.

Was there a reason why you changed ->pending from 1 -> 2 during the
se_task removal in commit 5787cacd0bd5ee01..?

> > Also drop the bio_cnt >= IBLOCK_MAX_BIO_PER_TASK rolling call to
> > iblock_submit_bios() to avoid the exception case where outstanding
> > bios completing via iblock_bio_done() are not accounted for when
> > returning returning non zero from iblock_execute_rw().
> 
> This will cause deadlocks when we can't allocate enough bios for
> a too large request.
> 

Mmmm..

So the case this patch tries to avoid is where iblock_submit_bio() is
called multiple times before the final ibr->pending value is set, this
could potentially cause bios completion calls to decrement the value +
complete to core before iblock_execute_rw() is done incrementing
ibr->pending.

How about returning an exception here instead when IBLOCK_MAX_BIOS in
reached..?  Btw, where did the default of 32 for this come from..?

--nab

