Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC78C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 20:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5866960FC0
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 20:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbhH3Unh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 16:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbhH3Ung (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 16:43:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B8DC061575;
        Mon, 30 Aug 2021 13:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=s8sN/nm91BxBuEePx1oK1Ip0xK3fNhEwWe4+zuk6ceg=; b=4v7ISjCjGyaDn8TkXmebdJ4hKv
        PYx8skNRQRgbxfe4rRQMsvdVqvz6VsOfG9X+ROPMHVGQ4OJA5hAo5lE2j0lBIGhBMuJO1IOmg+FTW
        Baz+6nCnSYe3ZmhnuxdkpAmokYK10l/Ya7AG5MqiR+lD1nmC8JOlQ969ZzIpbc1fur6demSAe5MMr
        C2BQu/AgInu/iK6+i6nB3CZiOREMoI+7P48WwQrSYGGvuhP+V5R6VnsWpAN/CQqgW38xrJ61oM8JV
        aPng4azQlAs9WpIqkFSGrCtxrK/b3zVILCxHQ9PBfuLp0BPIxBCinyxszKB9hpiE2mepEls2HYCFQ
        4ovZX2pA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKo6Z-000Wv2-7h; Mon, 30 Aug 2021 20:42:07 +0000
Date:   Mon, 30 Aug 2021 13:42:07 -0700
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
Message-ID: <YS1Cn6yMbpQGFOYe@bombadil.infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-7-mcgrof@kernel.org>
 <YSSN+eac2aCFXTAA@infradead.org>
 <YSkyHINtV/djFEej@bombadil.infradead.org>
 <YSnme1mfHS/HCguW@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSnme1mfHS/HCguW@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 28, 2021 at 08:32:11AM +0100, Christoph Hellwig wrote:
> On Fri, Aug 27, 2021 at 11:42:36AM -0700, Luis Chamberlain wrote:
> > > >  	if (area_type == MMC_BLK_DATA_AREA_MAIN)
> > > >  		dev_set_drvdata(&card->dev, md);
> > > > -	device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> > > > +	ret = device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> > > > +	if (ret)
> > > > +		goto out;
> > > 
> > > This needs to do a blk_cleanup_queue and also te kfree of md.
> > 
> > If mmc_blk_alloc_parts() fails mmc_blk_remove_req() is called which
> > does both for us?
> 
> Yes, but only for the main gendisk, and those parts already added to
> the list which happens after device_add_disk succeeded.

Ah yes I see that now. Will fix up. The tag also needs to be cleaned up.

  Luis
