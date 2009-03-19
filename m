From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCHSET  0/2] Don't let blk_put_request leak BIOs
Date: Thu, 19 Mar 2009 12:33:44 +0100
Message-ID: <20090319113343.GF27476@kernel.dk>
References: <49C21C5A.6030105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:46592 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbZCSLdr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2009 07:33:47 -0400
Content-Disposition: inline
In-Reply-To: <49C21C5A.6030105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

On Thu, Mar 19 2009, Boaz Harrosh wrote:
> Hi Jens
> 
> You never commented on these patches. Please have a look?
> 
> The issue is that if we map some memory into a request but then
> do not execute it. Then calling blk_put_request() will leak the bio(s)
> unless one does an ugly code like:
> -	struct bio *bio;
> -
> -	while ((bio = rq->bio) != NULL) {
> -		rq->bio = bio->bi_next;
> -		bio_endio(bio, 0);
> -	}

Sorry, I think this is a horrible design. blk_put_request() doesn't care
about any data attachments, in fact (if possible) it should go BUG() if
the request hasn't been completed in some way or other. It deals with
the deallocation part, blk_get_request() doesn't attach any data. The
end result with code like the above is an assymmetric API.

> This problem arise in OSD when we can fail to setup the write
> or the read side and then we must cleanup the other half.
> Same problem exist in bsg, on bidi commands. But there the bio
> is just leaked on the error path, it does not do the ugly loop above.

These drivers should just be fixed, then.

So if you have spotted this problem in eg bsg, then please send a patch
for that to Tomo!

-- 
Jens Axboe

