Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A10CC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 09:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3572961019
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 09:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345515AbhESJdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 05:33:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229668AbhESJdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 May 2021 05:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621416740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qlpb39jQa4GdpTT7KlX+ubz72bugjSJwDBVZqAQEUCA=;
        b=dTDo86IxSO4s7bkwzlQOlELAQBjpN0NOwpCaX6FyzxY8z9BnytIVdex/GNpgwuthUtfXbB
        /XvM2NwEpMdzhLRSI533bOmUCyixJcV6h+SjihoEawL15V4VzRUr5x6svSaFpx5XBHyAJj
        Tsena64cCxWp1Q2O7s+vRcB2JmDHyz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-KBZMHK_DPtGU6q7EIdK88w-1; Wed, 19 May 2021 05:32:18 -0400
X-MC-Unique: KBZMHK_DPtGU6q7EIdK88w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D08A21018F7F;
        Wed, 19 May 2021 09:32:16 +0000 (UTC)
Received: from T590 (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A350A60C04;
        Wed, 19 May 2021 09:32:06 +0000 (UTC)
Date:   Wed, 19 May 2021 17:32:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] block: move sync_blockdev from __blkdev_put to
 blkdev_put
Message-ID: <YKTbEuF4E4M0SpBP@T590>
References: <20210512061856.47075-1-hch@lst.de>
 <20210512061856.47075-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512061856.47075-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 12, 2021 at 08:18:50AM +0200, Christoph Hellwig wrote:
> Do the early unlocked syncing even earlier to move more code out of
> the recursive path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/block_dev.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index d053510d2f6a..95fde785dae7 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1553,16 +1553,6 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>  	struct gendisk *disk = bdev->bd_disk;
>  	struct block_device *victim = NULL;
>  
> -	/*
> -	 * Sync early if it looks like we're the last one.  If someone else
> -	 * opens the block device between now and the decrement of bd_openers
> -	 * then we did a sync that we didn't need to, but that's not the end
> -	 * of the world and we want to avoid long (could be several minute)
> -	 * syncs while holding the mutex.
> -	 */
> -	if (bdev->bd_openers == 1)
> -		sync_blockdev(bdev);
> -
>  	mutex_lock_nested(&bdev->bd_mutex, for_part);
>  	if (for_part)
>  		bdev->bd_part_count--;
> @@ -1589,6 +1579,16 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
>  {
>  	struct gendisk *disk = bdev->bd_disk;
>  
> +	/*
> +	 * Sync early if it looks like we're the last one.  If someone else
> +	 * opens the block device between now and the decrement of bd_openers
> +	 * then we did a sync that we didn't need to, but that's not the end
> +	 * of the world and we want to avoid long (could be several minute)
> +	 * syncs while holding the mutex.
> +	 */
> +	if (bdev->bd_openers == 1)
> +		sync_blockdev(bdev);
> +

The early sync on disk is killed in case of closing partition, but there
shouldn't much dirty data on disk, so looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

--
Ming

