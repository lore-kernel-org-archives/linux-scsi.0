From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 4/4] cdrom: revert commit 22a9189 (cdrom: use kmalloced buffers instead of buffers on stack)
Date: Tue, 20 May 2008 09:33:00 +0200
Message-ID: <87skwdv39v.fsf@denkblock.local>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1211259514-9131-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1211259514-9131-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1211259514-9131-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1211259514-9131-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1211259514-9131-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	(FUJITA Tomonori's message of "Tue, 20 May 2008 13:58:34 +0900")
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, akpm@linux-foundation.org, davem@davemloft.net
List-Id: linux-scsi@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> The commit 22a9189fd073db3d03a4cf8b8c098aa207602de1 (cdrom: use
> kmalloced buffers instead of buffers on stack) is introduced to use
> kmalloced buffers for packet commands to avoid stack corruption on non
> coherent platforms.
>
> SCSI cdrom uses blk_rq_map_kern (the commit
> 68154e90c9d1492d570671ae181d9a8f8530da55) post 2.6.25. So sr_packet
> uses allocated pages when necessary. IDE cdrom has a mechnism to
> handle alignment and padding. So we don't need this extra complexitiy
> in cdrom.c.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Jens Axboe <jens.axboe@oracle.com>
[...]
> @@ -837,14 +796,10 @@ static int cdrom_mrw_open_write(struct cdrom_device_info *cdi)
>  static int mo_open_write(struct cdrom_device_info *cdi)
>  {
>  	struct packet_command cgc;
> -	char *buffer;
> +	char buffer[255];
>  	int ret;
>  
> -	buffer = kmalloc(255, GFP_KERNEL);
> -	if (!buffer)
> -		return -ENOMEM;
> -
> -	init_cdrom_command(&cgc, buffer, 4, CGC_DATA_READ);
> +	init_cdrom_command(&cgc, &buffer, 4, CGC_DATA_READ);
				 ^
Careful here.

Regards,

Elias
