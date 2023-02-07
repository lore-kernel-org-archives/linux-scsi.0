Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3971C05027
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 00:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjBGATm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 19:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBGATl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 19:19:41 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EA02F793;
        Mon,  6 Feb 2023 16:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rNXmWC8G98biS+hnYw/MzGC4VskFT8ni/sXZahVZ2F0=; b=L4P+WXGCetq+g5B5BzNYKX6lMm
        21UztJ3OZP9CUAsew1DhDAyZtgbRaYMhR+Y/btVvEMdbw0Q4nkuPHlZlZfd32BwOkh/Uh+PZJw7RL
        tTzEoubRzV1tztZukLs8WM5T8zAaRFQoJCsfwThmKseroe+3O13iLnr39zJb656bxv5vhpvo6Ehvo
        aP1h73fs0xBEsPEzdooiZwjzSwrXZOiT+woVViJ188k3fd6N8JU5JST6qgLZodXNSttH5Z1Dg2TVm
        BMAv1/4Uoam/JBGo2bzzTGWkpwSdO8Pclf1jdQ25goAz4owbIqEonXJv0dGbqmPSNDZ1M1NlpdJql
        CIgnWLgg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPBhu-00AG1L-MF; Tue, 07 Feb 2023 00:19:34 +0000
Date:   Mon, 6 Feb 2023 16:19:34 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v4 2/7] block: Support configuring limits below the page
 size
Message-ID: <Y+GZFoHiUOQeq25d@bombadil.infradead.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-3-bvanassche@acm.org>
 <20230201235038.nnayavxpadq5yj34@garbanzo>
 <24b34999-8f7c-7821-0b15-fdfc3f508b13@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24b34999-8f7c-7821-0b15-fdfc3f508b13@acm.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 06, 2023 at 04:02:46PM -0800, Bart Van Assche wrote:
> On 2/1/23 15:50, Luis Chamberlain wrote:
> > On Mon, Jan 30, 2023 at 01:26:51PM -0800, Bart Van Assche wrote:
> > > @@ -122,12 +177,17 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
> > >   void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
> > >   {
> > >   	struct queue_limits *limits = &q->limits;
> > > +	unsigned int min_max_hw_sectors = PAGE_SIZE >> SECTOR_SHIFT;
> > >   	unsigned int max_sectors;
> > > -	if ((max_hw_sectors << 9) < PAGE_SIZE) {
> > > -		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
> > > -		printk(KERN_INFO "%s: set to minimum %d\n",
> > > -		       __func__, max_hw_sectors);
> > > +	if (max_hw_sectors < min_max_hw_sectors) {
> > > +		blk_enable_sub_page_limits(limits);
> > > +		min_max_hw_sectors = 1;
> > > +	}
> > 
> > Up to this part this a non-functional update, and so why not a
> > separate patch to clarify that.
> 
> Will do.
> 
> > > +
> > > +	if (max_hw_sectors < min_max_hw_sectors) {
> > > +		max_hw_sectors = min_max_hw_sectors;
> > > +		pr_info("%s: set to minimum %u\n", __func__, max_hw_sectors);
> > 
> > But if I understand correctly here we're now changing
> > max_hw_sectors from 1 to whatever the driver set on
> > blk_queue_max_hw_sectors() if its smaller than PAGE_SIZE.
> > 
> > To determine if this is a functional change it begs the
> > question as to how many block drivers have a max hw sector
> > smaller than the equivalent PAGE_SIZE and wonder if that
> > could regress.
> 
> If a block driver passes an argument to blk_queue_max_hw_sectors() or
> blk_queue_max_segment_size() that is smaller than what is supported by the
> block layer, data corruption will be triggered if the block driver or the
> hardware supported by the block driver does not support the larger values
> chosen by the block layer. Changing limits that will trigger data corruption
> into limits that may work seems like an improvement to me?

Wow, clearly! Without a doubt!

But I'm trying to do a careful review here.

The commit log did not describe what *does* happen in these situations today,
and you seem to now be suggesting in the worst case corruption can happen.
That changes the patch context quite a bit!

My question above still stands though, how many block drivers have a max
hw sector smaller than the equivalent PAGE_SIZE. If you make your
change, even if it fixes some new use case where corruption is seen, can
it regress some old use cases for some old controllers?

  Luis
