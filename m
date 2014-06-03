From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] sd: Limit transfer length
Date: Wed, 4 Jun 2014 00:10:27 +0900
Message-ID: <CAC5umyivST2BG7exCH+iCSyCJV-oKz+pW_=ujteCDW1vOTqirQ@mail.gmail.com>
References: <yq17g4z86te.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:58174 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaFCPK3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2014 11:10:29 -0400
Received: by mail-la0-f43.google.com with SMTP id mc6so3581467lab.16
        for <linux-scsi@vger.kernel.org>; Tue, 03 Jun 2014 08:10:27 -0700 (PDT)
In-Reply-To: <yq17g4z86te.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

2014-06-03 4:11 GMT+09:00 Martin K. Petersen <martin.petersen@oracle.com>:
> @@ -2755,6 +2765,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
>
>         blk_queue_flush(sdkp->disk->queue, flush);
>
> +       max_xfer = min_not_zero((unsigned int)sdp->host->max_sectors,
> +                               (unsigned int)sdkp->max_xfer_blocks);

Should we use queue_max_hw_sector(sdkp->disk->queue) instead of
sdp->host->max_sectors directly?  Because some low-level drivers (ipr
and pmcraid) may set different max_hw_sectors than host->max_sectors
in slave_configure().

> +       max_xfer <<= ilog2(sdp->sector_size) - 9;
> +       blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
>         set_capacity(disk, sdkp->capacity);
>         sd_config_write_same(sdkp);
>         kfree(buffer);
