Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5E8C636D3
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Feb 2023 16:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjBFQDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 11:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBFQD3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 11:03:29 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0FC173C;
        Mon,  6 Feb 2023 08:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/XDmeBQGsHiBzLGyz4tvahwp6/OdE+GSGoC+nuBRHOU=; b=pNr82lezarasWj/ydxawwIhzWB
        SeHuyhmNkuWyj3bCb9tfJadfMQagT4OG2UpTIRqWKJ600Jaef8233mU+UWTsCrFvy7yvVkCkT5uo1
        Ei0rMBB1GqJ08fBuUdL1a0snsbHyrZuS00BhYkkGjdwZMSUgSgtKZhXWn5jUAXQOoWCkIIIk2EM4y
        fk01JLPyRaJr5ihyJT3fzXIeredpsnvdGIAVgG3dkFcqfIMRYg7A9at0vqPjxEnagdFS8uyB/4k6B
        6nXyrA/svMPyO7sLh6C+qfB2mpd35cYlQ6q8s/tiQpTYLSMLSsuiKLiYkQvXoVFTPAoWI94u5yIjV
        kE1uJuKw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pP3xk-009AA3-1y; Mon, 06 Feb 2023 16:03:24 +0000
Date:   Mon, 6 Feb 2023 08:03:24 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v4 1/7] block: Introduce blk_mq_debugfs_init()
Message-ID: <Y+EkzOIVEaTmVvw7@bombadil.infradead.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-2-bvanassche@acm.org>
 <20230201205800.t3gpx7w3aw2ozab7@garbanzo>
 <20230201212332.p3mdb5ab3qisuo2x@garbanzo>
 <4c9b87dc-aeeb-43b6-0c18-4d04495683da@acm.org>
 <20230201235919.q5rhglvgw7uduexy@garbanzo>
 <ea0eff5f-5c05-ebca-58a4-1e772a6fa739@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea0eff5f-5c05-ebca-58a4-1e772a6fa739@acm.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 01, 2023 at 05:06:22PM -0800, Bart Van Assche wrote:
> On 2/1/23 15:59, Luis Chamberlain wrote:
> > My point was commit 85e0cbbb8a made blk_debugfs_root non-null always now
> > when debugfs is enabled for both request-based block drivers and for
> > make_request block drivers (multiqueue). My reading is that with your
> > patch blk_debugfs_root will not be created for request-based block
> > drivers.
> 
> Hi Luis,
> 
> The empty version of blk_mq_debugfs_init() in my patch is only selected if
> CONFIG_BLK_DEBUG_FS=n. I think that my patch preserves the behavior that
> /sys/kernel/debug/block/ is created independent of the type of request
> queues that is created. Am I perhaps misunderstanding your feedback?

Yes, my point is prior to this patch the debugfs directory is created
even if you have CONFIG_BLK_DEBUG_FS=n and I've mentioned the commit
which describes why, but the skinnys is blktrace.

  Luis
