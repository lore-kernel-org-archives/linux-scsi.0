Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C763C05027
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 23:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjBAXuo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 18:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjBAXun (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 18:50:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAF668129;
        Wed,  1 Feb 2023 15:50:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C686A619B0;
        Wed,  1 Feb 2023 23:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61FDC433EF;
        Wed,  1 Feb 2023 23:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675295440;
        bh=LmczEOBgk7OncV5TDDBkm5FFb4gbq8qK7GD107BbFtQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fqxHU18ByfQAlONUAHa1XbooOD5Z8xb3KYpuvLh7UGYcX1HTUEeMKKzzPoBL0gJH6
         CIzkAGKw9Li3Gt9Jo7kr2g5aJZlHTvHrZ+MfufUSXt3gEEnfhfb/tw51cMtxMK1P2g
         WWde83ohA1DY7rbUKc/GfK9hpv+EAZwA1mLf0oxELRNtKrfsTIa6sqy/27yKRXWw52
         uhrGFxjAPTcL2rV9cltb9NyTPfKzik+VmtHihRBoOZZTQN3+Tb7Nc727jok+zN5aoA
         7nG+9Wl6flTUlLv/SACCC38mCTElmt+86YeEQU4Xl6sn+/GJYgPuxVXIZuYBbxPFIb
         GQoSsHpMM5Hug==
Date:   Wed, 1 Feb 2023 15:50:38 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>,
        Pankaj Raghav <p.raghav@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v4 2/7] block: Support configuring limits below the page
 size
Message-ID: <20230201235038.nnayavxpadq5yj34@garbanzo>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130212656.876311-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 30, 2023 at 01:26:51PM -0800, Bart Van Assche wrote:
> Allow block drivers to configure the following:
> * Maximum number of hardware sectors values smaller than
>   PAGE_SIZE >> SECTOR_SHIFT. With PAGE_SIZE = 4096 this means that values
>   below 8 are supported.
> * A maximum segment size below the page size. This is most useful
>   for page sizes above 4096 bytes.
> 
> The blk_sub_page_segments static branch will be used in later patches to
> prevent that performance of block drivers that support segments >=
> PAGE_SIZE and max_hw_sectors >= PAGE_SIZE >> SECTOR_SHIFT would be affected.

This commit log seems to not make it clear if there is a functional
change or not.

> @@ -100,6 +106,55 @@ void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce bounce)
>  }
>  EXPORT_SYMBOL(blk_queue_bounce_limit);
>  
> +/* For debugfs. */
> +int blk_sub_page_limit_queues_get(void *data, u64 *val)
> +{
> +	*val = READ_ONCE(blk_nr_sub_page_limit_queues);
> +
> +	return 0;
> +}
> +
> +/**
> + * blk_enable_sub_page_limits - enable support for max_segment_size values smaller than PAGE_SIZE and for max_hw_sectors values below PAGE_SIZE >> SECTOR_SHIFT

That's a really long line for kdoc, can't we just trim it?

And why not update the docs to reflect the change?

> @@ -122,12 +177,17 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
>  void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
>  {
>  	struct queue_limits *limits = &q->limits;
> +	unsigned int min_max_hw_sectors = PAGE_SIZE >> SECTOR_SHIFT;
>  	unsigned int max_sectors;
>  
> -	if ((max_hw_sectors << 9) < PAGE_SIZE) {
> -		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
> -		printk(KERN_INFO "%s: set to minimum %d\n",
> -		       __func__, max_hw_sectors);
> +	if (max_hw_sectors < min_max_hw_sectors) {
> +		blk_enable_sub_page_limits(limits);
> +		min_max_hw_sectors = 1;
> +	}

Up to this part this a non-functional update, and so why not a
separate patch to clarify that.

> +
> +	if (max_hw_sectors < min_max_hw_sectors) {
> +		max_hw_sectors = min_max_hw_sectors;
> +		pr_info("%s: set to minimum %u\n", __func__, max_hw_sectors);

But if I understand correctly here we're now changing
max_hw_sectors from 1 to whatever the driver set on
blk_queue_max_hw_sectors() if its smaller than PAGE_SIZE.

To determine if this is a functional change it begs the
question as to how many block drivers have a max hw sector
smaller than the equivalent PAGE_SIZE and wonder if that
could regress.

>  	}
>  
>  	max_hw_sectors = round_down(max_hw_sectors,
> @@ -282,10 +342,16 @@ EXPORT_SYMBOL_GPL(blk_queue_max_discard_segments);
>   **/
>  void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
>  {
> -	if (max_size < PAGE_SIZE) {
> -		max_size = PAGE_SIZE;
> -		printk(KERN_INFO "%s: set to minimum %d\n",
> -		       __func__, max_size);
> +	unsigned int min_max_segment_size = PAGE_SIZE;
> +
> +	if (max_size < min_max_segment_size) {
> +		blk_enable_sub_page_limits(&q->limits);
> +		min_max_segment_size = SECTOR_SIZE;
> +	}
> +
> +	if (max_size < min_max_segment_size) {
> +		max_size = min_max_segment_size;
> +		pr_info("%s: set to minimum %u\n", __func__, max_size);

And similar thing here.

  Luis
