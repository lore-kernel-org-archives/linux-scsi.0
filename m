Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66BCC61DA4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 02:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBGCIW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 21:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBGCIV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 21:08:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380C720065;
        Mon,  6 Feb 2023 18:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oFImphRAdIQZFhtXl/FfC1S5d+PrCvIrUBzsig6krl8=; b=vtYHM+Nhoev9muLTEUlBuZghzz
        NM2uvkhR5eUKHTRr07sTsPIChbHM1YY/H5IDbBbLt9foykSX7pbJdRC5Gwx3nN+I8vpoPeS08TlbF
        JdcTJRNEDjXItA2r1xshEjvHUKXSCsagpqXGXcImDXF5mUh9LhGjmwC7pePWZLTDeA/sED4pahHCR
        OmF29prRDb3MEkBcpZGiZbA8UYJFRgeQ2zAx0FS0h6FgN1YcnrkADzme6LWiCdFyFk+t9byWRURfv
        X79P1jHiFJhxAGmhaHeX6gjlrxOZ1KsxFcHx8665DwewMjTPyw9e+lWsWwZ1XCSxNHC204xxR660E
        VNKI561Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPDP6-00AT2G-04; Tue, 07 Feb 2023 02:08:16 +0000
Date:   Mon, 6 Feb 2023 18:08:15 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v4 2/7] block: Support configuring limits below the page
 size
Message-ID: <Y+Gyj5pFkhIKY32K@bombadil.infradead.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-3-bvanassche@acm.org>
 <20230201235038.nnayavxpadq5yj34@garbanzo>
 <24b34999-8f7c-7821-0b15-fdfc3f508b13@acm.org>
 <Y+GZFoHiUOQeq25d@bombadil.infradead.org>
 <bee64ad1-a465-123e-4208-013e7dd69e04@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bee64ad1-a465-123e-4208-013e7dd69e04@acm.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 06, 2023 at 04:31:58PM -0800, Bart Van Assche wrote:
> On 2/6/23 16:19, Luis Chamberlain wrote:
> > But I'm trying to do a careful review here.
> 
> That's appreciated :-)
> 
> > The commit log did not describe what *does* happen in these situations today,
> > and you seem to now be suggesting in the worst case corruption can happen.
> > That changes the patch context quite a bit!
> > 
> > My question above still stands though, how many block drivers have a max
> > hw sector smaller than the equivalent PAGE_SIZE. If you make your
> > change, even if it fixes some new use case where corruption is seen, can
> > it regress some old use cases for some old controllers?
> 
> The blk_queue_max_hw_sectors() change has been requested by a contributor to
> the MMC driver (I'm not familiar with the MMC driver).
> 
> I'm not aware of any storage controllers for which the maximum segment size
> is below 4 KiB.

Then the commit log should mention that. Because do you admit that it
could possible change their behaviour?

> For some storage controllers, e.g. the UFS Exynos controller, the maximum
> supported segment size is 4 KiB. This patch series makes such storage
> controllers compatible with larger page sizes, e.g. 16 KiB.
> 
> Does this answer your question?

Does mine answer the reason to why I am asking it? If we are sure these
don't exist then please mention it in the commit log. And also more
importantly the possible corruption issue you describe which could
happen! Was a corruption actually observed in real life or reported!?

  Luis
