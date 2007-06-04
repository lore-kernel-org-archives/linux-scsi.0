From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Mon, 4 Jun 2007 16:04:15 +0200
Message-ID: <20070604140414.GI32105@kernel.dk>
References: <20070603221813U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:2227 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbXFDOF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jun 2007 10:05:57 -0400
Content-Disposition: inline
In-Reply-To: <20070603221813U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Sun, Jun 03 2007, FUJITA Tomonori wrote:
> The previous commit to fix a blocking read bug put a bug that leads a
> deadlock on discarding done commands. We don't need bsg_device's lock
> there.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/bsg.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 2f78d7d..9b5f6d7 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -466,11 +466,8 @@ static int bsg_complete_all_commands(str
>  	 */
>  	ret = 0;
>  	do {
> -		spin_lock_irq(&bd->lock);
> -		if (!bd->queued_cmds) {
> -			spin_unlock_irq(&bd->lock);
> +		if (!bd->queued_cmds)
>  			break;
> -		}
>  
>  		bc = bsg_get_done_cmd(bd);
>  		if (IS_ERR(bc))

int read should be atomic, but it probably still needs serialization.
I'd be more comfortable with just adding the appropriate
spin_unlock_irq() before bsg_get_done_cmd(). It's not a fast path
anyway, just for device going away.

-- 
Jens Axboe

