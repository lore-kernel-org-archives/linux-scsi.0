From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 4/4] block: add large command support
Date: Mon, 14 Apr 2008 10:41:54 -0400
Message-ID: <20080414144154.GB10288@osc.edu>
References: <20080414010112W.tomof@acm.org> <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1208170266-1676-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1208170266-1676-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1208170266-1676-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1208170266-1676-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:47855 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759905AbYDNOwG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2008 10:52:06 -0400
Content-Disposition: inline
In-Reply-To: <1208170266-1676-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, bharrosh@panasas.com, Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org

fujita.tomonori@lab.ntt.co.jp wrote on Mon, 14 Apr 2008 19:50 +0900:
> This patch changes rq->cmd from the static array to a pointer to
> support large commands.
> 
> We rarely handle large commands. So for optimization, a struct request
> still has a static array for a command. rq_init sets rq->cmd pointer
> to the static array.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jens Axboe <jens.axboe@oracle.com>
[..]
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index b3a58ad..5710ae4 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -215,8 +215,9 @@ struct request {
>  	/*
>  	 * when request is used as a packet command carrier
>  	 */
> -	unsigned int cmd_len;
> -	unsigned char cmd[BLK_MAX_CDB];
> +	unsigned short cmd_len;
> +	unsigned char __cmd[BLK_MAX_CDB];
> +	unsigned char *cmd;
>  
>  	unsigned int data_len;
>  	unsigned int extra_len;	/* length of alignment and padding */
> @@ -812,6 +813,13 @@ static inline void put_dev_sector(Sector p)
>  	page_cache_release(p.v);
>  }
>  
> +static inline void rq_set_cmd(struct request *rq, unsigned char *cmd,
> +			      unsigned short cmd_len)
> +{
> +	rq->cmd = cmd;
> +	rq->cmd_len = cmd_len;
> +}

Here's one way this will be used, in a patched bsg that understands
large commands.  Complication is the need to copy and hold onto the
big command across the duration of the request.

Submit time is fairly clean:

	/* buf, len from user request */
	rq = blk_get_request(..);
	rq->cmd_len = len;
	if (len > BLK_MAX_CDB) {
		rq->cmd = kmalloc(len);
		if (rq->cmd == NULL)
			goto out;
	}
	copy_from_user(rq->cmd, buf, len);

Completion time needs to know when to free rq->cmd:

	if (rq->cmd_len > BLK_MAX_CDB)
		kfree(rq->cmd);
	blk_put_request(rq);

Could use (rq->cmd != rq->__cmd) instead, but nothing had better
ever touch rq->cmd_len.

I don't think the helper rq_set_cmd() will be very useful, as the
caller (bsg) must think about allocation of the command buffer if it
is big.

One option would be to handle allocation/freeing of the big command
in rq_set_... functions, but I don't think you want to constrain the
interface like that.

Boaz's concern about big rq->cmd_len still worries me, although I
think this approach is better and worth solving bugs in drivers as
they arise.  It only matters in the case that someone adds, say, a
bsg interface to all block devices though.  The queuecommand of ub
shows a good example of how this will break.

In sum, this is a cleaner approach, and a bit easier for callers
with long commands to deal with.  And you could get rid of the
trivial helper.

		-- Pete
