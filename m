From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/7] block: clear drain buffer if draining for write
	command
Date: Mon, 11 Feb 2008 17:14:26 -0600
Message-ID: <1202771666.3122.83.camel@localhost.localdomain>
References: <12025212262892-git-send-email-htejun@gmail.com>
	 <12025212272956-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <12025212272956-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2008-02-09 at 10:40 +0900, Tejun Heo wrote:
> Clear drain buffer before chaining if the command in question is a
> write.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  block/blk-merge.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index d50cfc8..d0b9031 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -221,6 +221,9 @@ new_segment:
>  	} /* segments in rq */
>  
>  	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
> +		if (rq->cmd_flags & REQ_RW)
> +			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
> +

This is a bit performance impacting, isn't it?  If you're worried about
data security from a read overrun, then you could do a lazy clear on
read completion if the overrun was used (i.e. if there's any residual).

James


