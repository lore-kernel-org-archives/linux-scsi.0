From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
Date: Sun, 30 Aug 2009 15:12:09 +0400
Message-ID: <4A9A5E89.7070204@ru.mvista.com>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.713422216@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753322AbZH3LMT@vger.kernel.org>
In-Reply-To: <20090829231121.713422216@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Christoph Hellwig wrote:

> Add a prepare_discard function to sd that sends a WRITE SAME request with
> the unmap bit set to the device if it advertises thin provisioning support.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6/drivers/scsi/sd.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/sd.c	2009-08-29 19:19:36.067371669 -0300
> +++ linux-2.6/drivers/scsi/sd.c	2009-08-29 19:26:20.723754241 -0300
> @@ -911,6 +911,50 @@ static void sd_prepare_flush(struct requ
>  	rq->cmd_len = 10;
>  }
>  
> +static int sd_prepare_discard(struct request_queue *q, struct request *rq,
> +		struct bio *bio)
> +{
> +	struct scsi_device *sdp = q->queuedata;
> +	struct page *page = alloc_page(GFP_KERNEL);
> +
> +	if (!page)
> +		return -ENOMEM;
> +
> +	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> +	rq->timeout = SD_TIMEOUT;
> +	rq->cmd[0] = WRITE_SAME_16;
> +	rq->cmd[1] = 0x8; /* UNMAP bit */
> +	rq->cmd[2] = sizeof(bio->bi_sector) > 4 ?
> +			(unsigned char) (bio->bi_sector >> 56) & 0xff : 0;
> +	rq->cmd[3] = sizeof(bio->bi_sector) > 4 ?
> +			(unsigned char) (bio->bi_sector >> 48) & 0xff : 0;
> +	rq->cmd[4] = sizeof(bio->bi_sector) > 4 ?
> +			(unsigned char) (bio->bi_sector >> 40) & 0xff : 0;
> +	rq->cmd[5] = sizeof(bio->bi_sector) > 4 ?
> +			(unsigned char) (bio->bi_sector >> 32) & 0xff : 0;
> +	rq->cmd[6] = (unsigned char) (bio->bi_sector >> 24) & 0xff;
> +	rq->cmd[7] = (unsigned char) (bio->bi_sector >> 16) & 0xff;
> +	rq->cmd[8] = (unsigned char) (bio->bi_sector >> 8) & 0xff;
> +	rq->cmd[9] = (unsigned char) bio->bi_sector & 0xff;
> +	rq->cmd[10] = (unsigned char) (bio_sectors(bio) >> 24) & 0xff;
> +	rq->cmd[11] = (unsigned char) (bio_sectors(bio) >> 16) & 0xff;
> +	rq->cmd[12] = (unsigned char) (bio_sectors(bio) >> 8) & 0xff;
> +	rq->cmd[13] = (unsigned char) bio_sectors(bio) & 0xff;
> +	rq->cmd[14] = 0;
> +	rq->cmd[15] = 0;
> +	rq->cmd_len = 16;
> +
> +	printk(KERN_INFO "umap, lba = 0x%lld, len = %d\n",
>   

   So, is it hex or decimal? :-)

> +	       bio->bi_sector, bio_sectors(bio));
>   

   Since bio->bi_sector can either be 4 or 8 bytes, you need a cast to 
unsigned long long here.

MBR, Sergei
