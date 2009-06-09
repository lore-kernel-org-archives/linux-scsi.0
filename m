From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for potential
 bio leak"
Date: Tue, 09 Jun 2009 16:32:15 +0300
Message-ID: <4A2E645F.9090008@panasas.com>
References: <20090609194338S.fujita.tomonori@lab.ntt.co.jp>	<4A2E4D4F.90901@panasas.com> <20090609221019A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:6849
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752139AbZFINcR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 09:32:17 -0400
In-Reply-To: <20090609221019A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 06/09/2009 04:10 PM, FUJITA Tomonori wrote:
> On Tue, 09 Jun 2009 14:53:51 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Please do not revert. This is the point of all this.
>>
>> If there is no leak, You should NULL out the req->bio
>> for now, and for 2.6.31 change the code to do 
>> blk_end_request_all(). That's what blk_end_request does,
>> since you are doing your own completion then set req->bio
>> to null after you're done. (And before put_request)
>>
>> This stuff is good for error paths to catch leaks, please
>> leave it?
> 
> Has this your good stuff found any bio leak bugs in mainline? In
> addition, breaking working code is not a proper development style.
> 

It has found for me in error paths. That's why I put it.

I Issue bsg bidi commands every day all day, and never seen this.
What driver are you using? and can you post the stack trace.

The driver does something wrong. bsg over scsi-ml does not have this
problem. Why?

> Anyway, setting req->bio in bsg works. Either is fine by me.
> 
> 
> Jens, can you please send either patch to Linus now?
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] bsg: setting rq->bio to NULL
> 
> Due to commit 1cd96c242a829d52f7a5ae98f554ca9775429685 ("block: WARN
> in __blk_put_request() for potential bio leak"), BSG SMP requests get
> the false warnings:
> 
> WARNING: at block/blk-core.c:1068 __blk_put_request+0x52/0xc0()
> 
> This sets rq->bio to NULL to avoid that false warnings.
> 
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/bsg.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 206060e..dd81be4 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -315,6 +315,7 @@ out:
>  	blk_put_request(rq);
>  	if (next_rq) {
>  		blk_rq_unmap_user(next_rq->bio);

I do not understand this here please explain? We have called blk_rq_map_user()
and have bailed out on error later, without calling blk_execute_rq*. Now usually
the bios are *double* referenced, one for the usual call of blk_end_request() that will
release bios once, and second for the blk_rq_unmap_user() that will release second time.
But here you only call blk_rq_unmap_user() don't you need to call blk_end_request() also?

> +		next_rq->bio = NULL;
>  		blk_put_request(next_rq);
>  	}
>  	return ERR_PTR(ret);
> @@ -448,6 +449,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
>  		hdr->dout_resid = rq->data_len;
>  		hdr->din_resid = rq->next_rq->data_len;
>  		blk_rq_unmap_user(bidi_bio);
> +		rq->next_rq->bio = NULL;

These should have been NULL here, NO? otherwise they are a leak. Setting to NULL
will hide the leak.

>  		blk_put_request(rq->next_rq);
>  	} else if (rq_data_dir(rq) == READ)
>  		hdr->din_resid = rq->data_len;
> @@ -466,6 +468,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
>  	blk_rq_unmap_user(bio);
>  	if (rq->cmd != rq->__cmd)
>  		kfree(rq->cmd);
> +	rq->bio = NULL;

Same here

>  	blk_put_request(rq);
>  
>  	return ret;

Boaz
