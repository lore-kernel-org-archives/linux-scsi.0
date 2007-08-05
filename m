From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold structure
Date: Sun, 05 Aug 2007 12:55:16 -0400
Message-ID: <46B600F4.7020601@torque.net>
References: <200708051531.l75FVnjP011717@mbox.iij4u.or.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbXHEQzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Aug 2007 12:55:36 -0400
In-Reply-To: <200708051531.l75FVnjP011717@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> unsigned short is too small for sizeof(struct scatterlist) *
> min(q->max_hw_segments, q->max_phys_segments).
> 
> This fixes memory leak with 4096 segments since 16 (likely sg size
> with x86) * 4096 sets sglist_len to zero.
> 
> This might not happen without sg chaining support.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/sg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 2fc24e7..2c44bb0 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -114,7 +114,7 @@ static struct class_interface sg_interface = {
>  
>  typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
>  	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
> -	unsigned short sglist_len; /* size of malloc'd scatter-gather list ++ */
> +	unsigned sglist_len; /* size of malloc'd scatter-gather list ++ */
>  	unsigned bufflen;	/* Size of (aggregate) data buffer */
>  	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
>  	struct scatterlist *buffer;/* scatter list */

Tomo,
Thanks.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

