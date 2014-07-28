From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] block: bsg.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Mon, 28 Jul 2014 10:31:09 -0400
Message-ID: <x49sillpnbm.fsf@segfault.boston.devel.redhat.com>
References: <1406383665-1670-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1406383665-1670-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 26 Jul 2014 16:07:45 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  block/bsg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/block/bsg.c b/block/bsg.c
> index ff46add..b2688c5 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -790,7 +790,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
>  	mutex_lock(&bsg_mutex);
>  	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
>  
> -	strncpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name) - 1);
> +	strlcpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name));
>  	dprintk("bound to <%s>, max queue %d\n",
>  		format_dev_t(buf, inode->i_rdev), bd->max_queue);

NACK

The bsg data structure is allocated using kzalloc, so that last byte
will be zero.
