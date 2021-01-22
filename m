Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94001C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46321239D1
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbhAVI6F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 03:58:05 -0500
Received: from verein.lst.de ([213.95.11.211]:35677 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbhAVInC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Jan 2021 03:43:02 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 882E068AFE; Fri, 22 Jan 2021 09:42:09 +0100 (CET)
Date:   Fri, 22 Jan 2021 09:42:09 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: Re: [PATCH v3 1/3] block: introduce zone_write_granularity limit
Message-ID: <20210122084209.GA15710@lst.de>
References: <20210122080014.174391-1-damien.lemoal@wdc.com> <20210122080014.174391-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122080014.174391-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> @@ -864,18 +891,20 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
>  		 * partitions and zoned block device support is enabled, else
>  		 * we do nothing special as far as the block layer is concerned.
>  		 */
> -		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
> -		    disk_has_partitions(disk))
> -			model = BLK_ZONED_NONE;
> -		break;
> +		if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
> +		    !disk_has_partitions(disk))
> +			break;
> +		model = BLK_ZONED_NONE;
> +		fallthrough;
>  	case BLK_ZONED_NONE:
>  	default:
>  		if (WARN_ON_ONCE(model != BLK_ZONED_NONE))
>  			model = BLK_ZONED_NONE;
> +		q->limits.zone_write_granularity = 0;
>  		break;
>  	}
>  
> -	disk->queue->limits.zoned = model;
> +	q->limits.zoned = model;
>  }

This looks a little strange.  If we special case zoned vs not zoned
here anyway, why not set the zone_write_granularity to the logical
block size here by default.
