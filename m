From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target/iblock: Fix double iblock_complete_cmd callback
 bug
Date: Fri, 16 Nov 2012 14:25:41 -0500
Message-ID: <20121116192541.GA25096@infradead.org>
References: <1352404739-22881-1-git-send-email-nab@linux-iscsi.org>
 <20121115104922.GA28956@infradead.org>
 <1353018990.11597.35.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35603
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264Ab2KPTZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Nov 2012 14:25:44 -0500
Content-Disposition: inline
In-Reply-To: <1353018990.11597.35.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>

On Thu, Nov 15, 2012 at 02:36:30PM -0800, Nicholas A. Bellinger wrote:
> However, setting the default ibr->pending=2 value before dispatch, and
> making a extra iblock_complete_cmd() call from iblock_execute_rw(),
> while doing the normal iblock_complete_cmd() calls from
> iblock_bio_done() is AFAICT a pointless extra atomic_dec_and_test() call
> per I/O.
> 
> Was there a reason why you changed ->pending from 1 -> 2 during the
> se_task removal in commit 5787cacd0bd5ee01..?

It is to avoid having the request completed before even submitting all
bios.  As soon as one is submitted it could on a very fast device
complete before we've incremented the count for the next bio.

It's a very common scheme used all over the kernel when submitting
I/O in smaller subdivisions.

> So the case this patch tries to avoid is where iblock_submit_bio() is
> called multiple times before the final ibr->pending value is set, this
> could potentially cause bios completion calls to decrement the value +
> complete to core before iblock_execute_rw() is done incrementing
> ibr->pending.

That's exacltly what we try to avoid here.

> How about returning an exception here instead when IBLOCK_MAX_BIOS in
> reached..?

Why?  As soon as we kicked the first batch off we're guaranteed to make
progress allocating more as sson as the first of the submitted ones
completes.

> Btw, where did the default of 32 for this come from..?

It's a random number, with the important property that it's considerably
smaller than IBLOCK_BIO_POOL_SIZE.

