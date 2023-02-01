Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6814FC636D4
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 23:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBAX7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 18:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBAX7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 18:59:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E8966F98;
        Wed,  1 Feb 2023 15:59:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76D8CB8235D;
        Wed,  1 Feb 2023 23:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A67C433D2;
        Wed,  1 Feb 2023 23:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675295961;
        bh=4RrX4dRd7JxnrlXpIbKRwoM3CCF6nLMnu6JpgdKvggY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E2a4RjfxbiQ9qY/54cPSBAYKW1bjvDSLR4xqk+/BvfMmM1Z/ygnntiosafvYRdSQ3
         e+m8a+uwcyW8apP9ETAMPcktfnUqyFXgb1xTKJ/6PdPl/WlxuyKlZNQjRFBP5bRhPA
         r4igfNn92j85pWmenuIMX4lneHA8mgk9co3cSK0VsYI6kL1YjHyUB99In1nnxBl4BA
         bIGp9z5r3P7Sqjb8B4LVvhIaDYgqfpYt8tDs3wBHNHs8VF/Ktx5P9PqJUX0SckXaYe
         /FCcJ1U3ue6oxsQuyoQjCNtqwyhqNd158z0fvupLcLdyxBcbMm13lmx5PZIR8dTTAu
         hocz1xH3vnMgA==
Date:   Wed, 1 Feb 2023 15:59:19 -0800
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
Message-ID: <20230201235919.q5rhglvgw7uduexy@garbanzo>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-2-bvanassche@acm.org>
 <20230201205800.t3gpx7w3aw2ozab7@garbanzo>
 <20230201212332.p3mdb5ab3qisuo2x@garbanzo>
 <4c9b87dc-aeeb-43b6-0c18-4d04495683da@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c9b87dc-aeeb-43b6-0c18-4d04495683da@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 01, 2023 at 02:01:18PM -0800, Bart Van Assche wrote:
> On 2/1/23 13:23, Luis Chamberlain wrote:
> > On Wed, Feb 01, 2023 at 12:58:00PM -0800, Luis Chamberlain wrote:
> > > On Mon, Jan 30, 2023 at 01:26:50PM -0800, Bart Van Assche wrote:
> > > > Move the code for creating the block layer debugfs root directory into
> > > > blk-mq-debugfs.c. This patch prepares for adding more debugfs
> > > > initialization code by introducing the function blk_mq_debugfs_init().
> > > > 
> > > > Cc: Christoph Hellwig <hch@lst.de>
> > > > Cc: Ming Lei <ming.lei@redhat.com>
> > > > Cc: Keith Busch <kbusch@kernel.org>
> > > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > > 
> > > Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> > 
> > Sorry but actually a neuron triggered after this to remind me of commit
> > 85e0cbbb8a  ("block: create the request_queue debugfs_dir on
> > registration") and so using the terminology on that commit, wouldn't
> > this not create now the root block debugfs dir for request-based block
> > drivers?
> 
> Hi Luis,
> 
> This patch should not change any behavior with CONFIG_DEBUG_FS=y.

Ignore CONFIG_DEBUG_FS=y. This is about blktrace which needs it for
both types of drivers.

> As one can see in include/linux/debugfs.h, debugfs_create_dir() does not
> create a directory with CONFIG_DEBUG_FS=n:
> 
> static inline struct dentry *debugfs_create_dir(const char *name,
> 						struct dentry *parent)
> {
> 	return ERR_PTR(-ENODEV);
> }
> 
> I think the only behavior change introduced by this patch is that
> blk_debugfs_root remains NULL with CONFIG_DEBUG_FS=n instead of being set to
> ERR_PTR(-ENODEV).

My point was commit 85e0cbbb8a made blk_debugfs_root non-null always now
when debugfs is enabled for both request-based block drivers and for
make_request block drivers (multiqueue). My reading is that with your
patch blk_debugfs_root will not be created for request-based block
drivers.

  Luis
