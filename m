Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4C2C4320E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 07:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3022A610A8
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 07:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhH1Hfg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Aug 2021 03:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhH1Hff (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Aug 2021 03:35:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917B2C0613D9;
        Sat, 28 Aug 2021 00:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=js+UWYNM8YPTLRZ9ERhhOXxsAZmGo7ttkBYVZv/l62E=; b=MtDOH/dQOYQf+MXWY+D5I7cimb
        fy2CtDFjdVWCJSJZeW/Rl27SSbUkyUrjto52ZO169qNA4fujxRkz0Kms4tueEF3gvcXnr25UPeEDi
        qDU19bQcmKoNRQVNAruP+mEqqE2ESkdMq5tdK6I5DYQ+YwO9YkK8K4d89WklXaPcP62ybMNyNO/if
        zoGFKk08exnNTbKFQS4wnvJTA0KuTRuvQA+29IZxpVKLOuRuqqL6xxLMTLgbBl1HulWZ5RXSqzqgZ
        zcPTqTVkvQI+gvE6tldn43E94bYVmTGPeUAvfvhx9LVWm2DZff3E2NSwpUj+IZYPn0EMwccIsj9Kc
        rYcMIPVg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJsp1-00FNRa-6I; Sat, 28 Aug 2021 07:32:22 +0000
Date:   Sat, 28 Aug 2021 08:32:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        martin.petersen@oracle.com, jejb@linux.ibm.com, kbusch@kernel.org,
        sagi@grimberg.me, adrian.hunter@intel.com, beanhuo@micron.com,
        ulf.hansson@linaro.org, avri.altman@wdc.com, swboyd@chromium.org,
        agk@redhat.com, snitzer@redhat.com, josef@toxicpanda.com,
        hare@suse.de, bvanassche@acm.org, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mmc@vger.kernel.org, dm-devel@redhat.com,
        nbd@other.debian.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] mmc/core/block: add error handling support for
 add_disk()
Message-ID: <YSnme1mfHS/HCguW@infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-7-mcgrof@kernel.org>
 <YSSN+eac2aCFXTAA@infradead.org>
 <YSkyHINtV/djFEej@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSkyHINtV/djFEej@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 27, 2021 at 11:42:36AM -0700, Luis Chamberlain wrote:
> > >  	if (area_type == MMC_BLK_DATA_AREA_MAIN)
> > >  		dev_set_drvdata(&card->dev, md);
> > > -	device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> > > +	ret = device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
> > > +	if (ret)
> > > +		goto out;
> > 
> > This needs to do a blk_cleanup_queue and also te kfree of md.
> 
> If mmc_blk_alloc_parts() fails mmc_blk_remove_req() is called which
> does both for us?

Yes, but only for the main gendisk, and those parts already added to
the list which happens after device_add_disk succeeded.
