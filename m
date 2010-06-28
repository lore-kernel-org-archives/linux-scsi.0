From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: fix map_region and unmap_region oops
Date: Mon, 28 Jun 2010 13:18:20 -0400
Message-ID: <yq1ocevdqjn.fsf@sermon.lab.mkp.net>
References: <20100628010219G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:52901 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0F1RTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 13:19:37 -0400
In-Reply-To: <20100628010219G.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Mon, 28 Jun 2010 01:04:45 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dgilbert@interlog.com, martin.petersen@oracle.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

>>>>> "Tomo" == FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

Tomo> = From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> Subject:
Tomo> [PATCH] scsi_debug: fix map_region and unmap_region oops

Tomo> map_region and unmap_region could access to invalid memory area
Tomo> since they don't check the size boundary.

Tomo> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> ---
Tomo>  drivers/scsi/scsi_debug.c | 6 ++++-- 1 files changed, 4
Tomo>  insertions(+), 2 deletions(-)

Tomo> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
Tomo> index 136329b..b02bdc6 100644
Tomo> --- a/drivers/scsi/scsi_debug.c
Tomo> +++ b/drivers/scsi/scsi_debug.c
Tomo> @@ -1991,7 +1991,8 @@ static void map_region(sector_t lba,
Tomo> unsigned int len)
Tomo>  		block = lba + alignment; rem = do_div(block,
Tomo>  		granularity);
 
Tomo> - set_bit(block, map_storep);
Tomo> + if (block < map_size)
Tomo> + set_bit(block, map_storep);
 
Tomo>  		lba += granularity - rem;
Tomo>  	}
Tomo> @@ -2011,7 +2012,8 @@ static void unmap_region(sector_t lba,
Tomo> unsigned int len)
Tomo>  		block = lba + alignment; rem = do_div(block,
Tomo>  		granularity);
 
Tomo> - if (rem == 0 && lba + granularity <= end)
Tomo> + if (rem == 0 && lba + granularity <= end &&
Tomo> + block < map_size)
Tomo>  			clear_bit(block, map_storep);
 
Tomo>  		lba += granularity - rem;

I'm ok with the patch but I'm interested in what you were doing causing
it to access out of bounds?

-- 
Martin K. Petersen	Oracle Linux Engineering
