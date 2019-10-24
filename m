Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41C7CA9EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 07:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E86721872
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 07:08:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XiG+28VY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437878AbfJXHIj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:08:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390502AbfJXHIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 03:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=on8jeZqkh/sjOECFsuF03sfHDh8Za7fyblqymu7HAvI=; b=XiG+28VYrnUPntR5xQqESHiC6
        cGjMhPySW1go8GiCgeAIGnNaVlJOp/pKSSZF8d/9+pMpYfCG2R1Wf9Pp+K5IlkkW/O6P9Cso0NM4W
        S9SnS0/1CNKWAlNdzD3EJlOU/Y3bM5YcUrLZ0+IUK+X2ijorO+Gjvo/kh2WGjKpk5sFaoUxSxPIlO
        B9111J06fIH/ofP3brmHHUyU4KgUJFqQj2bNAM9gScS66agwIOmlK403EPHiDk9SvSS2/F+/BLCQX
        EWw7l9t8pd50QF9db8Wcri3TydzQdt4GNrUpRJKvegufe43Pu8jQpzVp7fDt02PyTqm+7w0smOmXR
        Hk4KjR/wg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNXEc-0008Dq-6w; Thu, 24 Oct 2019 07:08:38 +0000
Date:   Thu, 24 Oct 2019 00:08:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/4] block: Enhance blk_revalidate_disk_zones()
Message-ID: <20191024070838.GA19572@infradead.org>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
 <20191024065006.8684-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024065006.8684-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 4bc5f260248a..293891b7068a 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -441,6 +441,57 @@ void blk_queue_free_zone_bitmaps(struct request_queue *q)
>  	q->seq_zones_wlock = NULL;
>  }
>  
> +/**
> + * blk_check_zone - Check a zone information
> + * @q:		request queue
> + * @zone:	the zone to  check
> + * @sector:	start sector of the zone
> + *
> + * Helper function to check zones of a zoned block device. Returns true if the
> + * zone is correct and false if a problem is detected.
> + */
> +static bool blk_check_zone(struct gendisk *disk, struct blk_zone *zone,
> +			   sector_t *sector)

Maybe call this blk_zone_valid?  Also in many places we don't really
do the verbose kerneldoc comments with the duplicated parameter names
for local functions, as the scripts only pick up non-stack ones anyway.

> +	/*
> +	 * All zones must have the same size, with the exception on an eventual
> +	 * smaller last zone.
> +	 */
> +	if (zone->start + zone_sectors < capacity &&
> +	    zone->len != zone_sectors) {
> +		pr_warn("%s: Invalid zone device with non constant zone size\n",
> +			disk->disk_name);
> +		return false;
> +	}

I think we should also move the power of two zone size check here
instead of leaving it in the driver.
