From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Tue, 10 Feb 2009 17:43:03 +0000
Message-ID: <1234287784.3268.31.camel@localhost.localdomain>
References: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1229185427-4130-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1229185427-4130-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55117 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084AbZBJRnI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2009 12:43:08 -0500
In-Reply-To: <1229185427-4130-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>

On Sun, 2008-12-14 at 01:23 +0900, FUJITA Tomonori wrote:
> Now we can unexport blk_rq_append_bio and remove 'SCSI-ml does
> something wrong' comment in blkdev.h. :)
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/blk-map.c        |    5 ++---
>  include/linux/blkdev.h |    6 ------
>  2 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index e1bb727..a70f7d8 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -9,8 +9,8 @@
>  
>  #include "blk.h"
>  
> -int blk_rq_append_bio(struct request_queue *q, struct request *rq,
> -		      struct bio *bio)
> +static int blk_rq_append_bio(struct request_queue *q, struct request *rq,
> +			     struct bio *bio)

There's a current barrier to this: osd_initiator has also become a
consumer of blk_rq_append_bio().

It seems to be emulating block internals, so I think the fix is twofold:

     1. adjust blk_rq_map_kern to call blk_rq_append_bio() instead of
        blk_rq_prep_bio() (with an extra failure path).
     2. make osd_initiator simply call it for additions.

I can code up a patch to see if it works.

James


