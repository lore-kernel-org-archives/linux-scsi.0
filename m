From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] scsi_debug: fix map_region and unmap_region oops
Date: Tue, 29 Jun 2010 02:27:27 +0900
Message-ID: <20100629022513E.fujita.tomonori@lab.ntt.co.jp>
References: <20100628010219G.fujita.tomonori@lab.ntt.co.jp>
	<yq1ocevdqjn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:48827 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab0F1R1u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2010 13:27:50 -0400
In-Reply-To: <yq1ocevdqjn.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Mon, 28 Jun 2010 13:18:20 -0400
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> >>>>> "Tomo" == FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> 
> Tomo> = From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> Subject:
> Tomo> [PATCH] scsi_debug: fix map_region and unmap_region oops
> 
> Tomo> map_region and unmap_region could access to invalid memory area
> Tomo> since they don't check the size boundary.
> 
> Tomo> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> ---
> Tomo>  drivers/scsi/scsi_debug.c | 6 ++++-- 1 files changed, 4
> Tomo>  insertions(+), 2 deletions(-)
> 
> Tomo> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> Tomo> index 136329b..b02bdc6 100644
> Tomo> --- a/drivers/scsi/scsi_debug.c
> Tomo> +++ b/drivers/scsi/scsi_debug.c
> Tomo> @@ -1991,7 +1991,8 @@ static void map_region(sector_t lba,
> Tomo> unsigned int len)
> Tomo>  		block = lba + alignment; rem = do_div(block,
> Tomo>  		granularity);
>  
> Tomo> - set_bit(block, map_storep);
> Tomo> + if (block < map_size)
> Tomo> + set_bit(block, map_storep);
>  
> Tomo>  		lba += granularity - rem;
> Tomo>  	}
> Tomo> @@ -2011,7 +2012,8 @@ static void unmap_region(sector_t lba,
> Tomo> unsigned int len)
> Tomo>  		block = lba + alignment; rem = do_div(block,
> Tomo>  		granularity);
>  
> Tomo> - if (rem == 0 && lba + granularity <= end)
> Tomo> + if (rem == 0 && lba + granularity <= end &&
> Tomo> + block < map_size)
> Tomo>  			clear_bit(block, map_storep);
>  
> Tomo>  		lba += granularity - rem;
> 
> I'm ok with the patch but I'm interested in what you were doing causing
> it to access out of bounds?

I set unmap_granularity to 1 and then run mkfs.xfs.
