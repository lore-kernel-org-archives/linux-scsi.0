From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/2] block: export __blk_complete_request
Date: Fri, 15 Jun 2018 10:17:26 +0800
Message-ID: <CACVXFVMe4zSvfXfuSn0NFayeQqbmDwBBy1kcso=5iznT6EfpSA@mail.gmail.com>
References: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2018 at 9:57 AM, Jianchao Wang
<jianchao.w.wang@oracle.com> wrote:
> After f6e7d48 (block: remove BLK_EH_HANDLED), LLDD is responsible
> to complete the timed out request, however, for blk-legacy, the
> 'complete' is still marked, blk_complete_request will do nothing,
> we export __blk_complete_request for LLDD to complete the request
> in timeout path.
>
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> ---
>  block/blk-softirq.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/block/blk-softirq.c b/block/blk-softirq.c
> index 01e2b35..15c1f5e 100644
> --- a/block/blk-softirq.c
> +++ b/block/blk-softirq.c
> @@ -144,6 +144,7 @@ void __blk_complete_request(struct request *req)
>
>         local_irq_restore(flags);
>  }
> +EXPORT_SYMBOL(__blk_complete_request);
>
>  /**
>   * blk_complete_request - end I/O on a request
> --
> 2.7.4
>

Looks non-blk-mq timeout code need to convert to ref-counter
based approach too?

Thanks,
Ming Lei
