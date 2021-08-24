Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4911FC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 06:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2798C61262
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 06:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhHXGRr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 02:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhHXGRr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 02:17:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ECDC061575;
        Mon, 23 Aug 2021 23:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dQds9cSHSeE6kGx5MS02raO6iayqk63xe1w2A7iEq1M=; b=NAFLIm8m4aCi9SqoT2xstelsQt
        vDDY5oULL6Gmc1ZtN/gXrqKm8aT4pyL1HMdd/l2rqnGgXcV9wI4JDOqTNN4B9TBQDOR+FgwwGB+hC
        fVN/KSCGFY0auXuQHe7JihRBzo4EtOoqe2ZdAM3mAMsZk+1zS6mxXQtz21pklOJ9cM9Gq4EjMh2dC
        VNji9HAUzIQdgAkjytgO5wKENF8c6yy+BfZYUHRc1wJwRmWaSWdd5JxzsX07oeG29ZP7H46rvTk6j
        mURnUDtSYtcFQhIZ3HmOwQ46s6R9rtWUkAiy5MKh90yI8kvp0Wmvu5n28MAsamto4HyofHAZc1EFv
        5HJ8ucjg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIPgP-00Adf8-0Q; Tue, 24 Aug 2021 06:13:28 +0000
Date:   Tue, 24 Aug 2021 07:13:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com, hch@infradead.org, hare@suse.de,
        bvanassche@acm.org, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mmc@vger.kernel.org, dm-devel@redhat.com,
        nbd@other.debian.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] mmc/core/block: add error handling support for
 add_disk()
Message-ID: <YSSN+eac2aCFXTAA@infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-7-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823202930.137278-7-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 23, 2021 at 01:29:26PM -0700, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> The caller cleanups the disk already so all we need to do
> is just pass along the return value.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/mmc/core/block.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index 4c11f171e56d..4f12c6d1e1b5 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -2432,7 +2432,9 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
>  	/* used in ->open, must be set before add_disk: */
>  	if (area_type == MMC_BLK_DATA_AREA_MAIN)
>  		dev_set_drvdata(&card->dev, md);
> -	device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> +	ret = device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> +	if (ret)
> +		goto out;

This needs to do a blk_cleanup_queue and also te kfree of md.
