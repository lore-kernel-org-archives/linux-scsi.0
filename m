Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93109C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77AC960EB5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhH0Snv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 14:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhH0Snv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 14:43:51 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F26C061757;
        Fri, 27 Aug 2021 11:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RBmvAwPay+sXfU8kdltg7dsiThQ5ECrs+zL2VnxPj/I=; b=lgcsvGKlvlRPjm4XeXNlzIQlb5
        QOizv+m63NRPhUGgoDpLlprNnix7EU3Cz1GL3Dr13Yyi6Y3Nr3ZcwPqXlvo+FLXQro8rIPZF8R2NE
        br7T4+GN2+Iy0CWjeDe99nHKDDW+WmK9hBqupHrrsDPuAvNSfyGKm5l+1xhNnDcYa8EfWkyLUQJKG
        GwFI3fYMZklR57ielKept6nXS5jAmCG3O5g08pxOv90RKWehVeX3UdKf6uej4LC9vtg6/RMef71fY
        3xgKIlR8IdwVfwjRwU0ZwCodscgojLikAQkiS+jUjyBHBMc7lxOFxYMcLwoExFl6wGAE/e2wldljK
        aLHIm5Zw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJgoG-00Cyj5-C3; Fri, 27 Aug 2021 18:42:36 +0000
Date:   Fri, 27 Aug 2021 11:42:36 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] mmc/core/block: add error handling support for
 add_disk()
Message-ID: <YSkyHINtV/djFEej@bombadil.infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-7-mcgrof@kernel.org>
 <YSSN+eac2aCFXTAA@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSSN+eac2aCFXTAA@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2021 at 07:13:13AM +0100, Christoph Hellwig wrote:
> On Mon, Aug 23, 2021 at 01:29:26PM -0700, Luis Chamberlain wrote:
> > We never checked for errors on add_disk() as this function
> > returned void. Now that this is fixed, use the shiny new
> > error handling.
> > 
> > The caller cleanups the disk already so all we need to do
> > is just pass along the return value.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  drivers/mmc/core/block.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> > index 4c11f171e56d..4f12c6d1e1b5 100644
> > --- a/drivers/mmc/core/block.c
> > +++ b/drivers/mmc/core/block.c
> > @@ -2432,7 +2432,9 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
> >  	/* used in ->open, must be set before add_disk: */
> >  	if (area_type == MMC_BLK_DATA_AREA_MAIN)
> >  		dev_set_drvdata(&card->dev, md);
> > -	device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> > +	ret = device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> > +	if (ret)
> > +		goto out;
> 
> This needs to do a blk_cleanup_queue and also te kfree of md.

If mmc_blk_alloc_parts() fails mmc_blk_remove_req() is called which
does both for us?

 Luis
