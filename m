Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCE3C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 07:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B89320663
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 07:20:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vVyXz8A5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgINHUh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 03:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgINHUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 03:20:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615F3C06174A;
        Mon, 14 Sep 2020 00:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MUWAlEmi/MuXlGVqQDqzK1uzCCg4uLG6hzsyDRuaup4=; b=vVyXz8A5FVQbR+FFyW4UP/3z3s
        uS6Yr9tXqEHUBM5wNkK1C8Y6KNoPfhvRsoLFNfe90Den0gXMddkupFZY1XFkhXd1F16Ztz77WIrUL
        SeUwbbhnH8i7Pl3VuE66TOwFZlgYw+a0bJMpICtj7Q8mNTzPeJQXXuxJYxP50N0fjbeXIRJJF4but
        G3Vh8DEKbu9byWpoFjzuAqXwCUK7FV16MP/vOq6RN/cANuQ1pqemL5xZVvgOGqbcIvdDQSALgeeC6
        o9vwL9JDPPFwSk3L3v7vYY1UyXvDc107T81qMb0fOGol5iANfkz0q1/8ykaEawaw04rlxkT+4ri9g
        1/kJz4Kg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHimw-0007Ou-4g; Mon, 14 Sep 2020 07:20:34 +0000
Date:   Mon, 14 Sep 2020 08:20:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v2 1/2] scsi: Fix handling of host-aware ZBC disks
Message-ID: <20200914072034.GA25808@infradead.org>
References: <20200914003448.471624-1-damien.lemoal@wdc.com>
 <20200914003448.471624-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914003448.471624-2-damien.lemoal@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 14, 2020 at 09:34:47AM +0900, Damien Le Moal wrote:
> When CONFIG_BLK_DEV_ZONED is disabled, allow using host-aware ZBC
> disks as regular disks. In this case, ensure that command completion
> is correctly executed by changing sd_zbc_complete() to return good_bytes
> instead of 0, causing a hang during device probe (endless retries).
> 
> When CONFIG_BLK_DEV_ZONED is enabled and a host-aware disk is detected
> to have partitions, it will be used as a regular disk. In this case,
> make sure to not do anything in sd_zbc_revalidate_zones() as that
> triggers warnings.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Fixes: b72053072c0b ("block: allow partitions on host aware zone devices")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Tested-by: Borislav Petkov <bp@suse.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  drivers/scsi/sd.c     | 28 ++++++++++++++++++++++------
>  drivers/scsi/sd.h     |  2 +-
>  drivers/scsi/sd_zbc.c |  6 +++++-
>  3 files changed, 28 insertions(+), 8 deletions(-)
> 
>  	} else {
>  		sdkp->zoned = (buffer[8] >> 4) & 3;
>  		if (sdkp->zoned == 1 && !disk_has_partitions(sdkp->disk)) {
> +			/*
> +			 * Host-aware disk without partition: use the disk as
> +			 * such if support for zoned block devices is enabled.
> +			 * Otherwise, use it as a regular disk.
> +			 */
> +			if (IS_ENABLED(CONFIG_BLK_DEV_ZONED))
> +				q->limits.zoned = BLK_ZONED_HA;
> +			else
> +				q->limits.zoned = BLK_ZONED_NONE;
>  		} else {
>  			/*
>  			 * Treat drive-managed devices and host-aware devices
>  			 * with partitions as regular block devices.
>  			 */
>  			q->limits.zoned = BLK_ZONED_NONE;
>  		}

I think we need to lift much of this into a block layer helper,
as the logic is way subtile.  Something like this (written in the MUA
editor, not even compile tested).

static inline void blk_queue_set_zoned(struct gendisk *disk,
		enum blk_zoned_model model)
{
	switch (model) {
	case BLK_ZONED_HM:
		WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED));
		break;
	/*
	 * Host aware drivers are neither fish nor fowl.  We can either
	 * treat them like a drive managed devices, in which case they
	 * aren't different from a normal block device, or we can try
	 * to take advantage of the Zone command set, but in that case
	 * we need to treat them like a host managed device.  We try
	 * the latter if there are not partitions and zoned block device
	 * set support is enabled, else we do nothing special as far as
	 * the block layer is concerned.
	 */
	case BLK_ZONED_HA:
		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
		    disk_has_partitions(disk)) {
			model = BLK_ZONED_NONE;
		break;
	default:
		break;

	disk->queue->limits.zoned = model;
}

Then in sd do:

	if (sdkp->device->type == TYPE_ZBC) {
		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);
	} else {
		sdkp->zoned = (buffer[8] >> 4) & 3;
		if (sdkp->zoned == 1)
			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HA);
		else
			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_NONE);
	}
