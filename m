From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] NCR5380: bit MR_DMA_MODE set twice in
 NCR5380_transfer_dma()
Date: Tue, 13 Oct 2009 16:40:17 -0700
Message-ID: <20091013164017.f666d9a2.akpm@linux-foundation.org>
References: <4ACBA5E7.3090000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbZJMXlF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 19:41:05 -0400
In-Reply-To: <4ACBA5E7.3090000@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Tue, 06 Oct 2009 22:17:43 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> Besides keeping the line short, the second setting of the
> MR_DMA_MODE bit was removed.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Please review, maybe some other bit should be set?

The only ones left are MR_BLOCK_DMA_MODE and MR_ARBITRATE.

No, I don't know if they hould have been set either.  Let that sleeping
dog lie, I suspect.


> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index f92da9f..5d2f148 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -1857,7 +1857,9 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase
>  #endif
>  	/* KLL May need eop and parity in 53c400 */
>  	if (hostdata->flags & FLAG_NCR53C400)
> -		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_ENABLE_PAR_CHECK | MR_ENABLE_PAR_INTR | MR_ENABLE_EOP_INTR | MR_DMA_MODE | MR_MONITOR_BSY);
> +		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE |
> +				MR_ENABLE_PAR_CHECK | MR_ENABLE_PAR_INTR |
> +				MR_ENABLE_EOP_INTR | MR_MONITOR_BSY);
>  	else
>  		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE);
>  #endif				/* def REAL_DMA */
