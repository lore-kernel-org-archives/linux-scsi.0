Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D100EC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 07:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E66161181
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 07:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhDIHlQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 03:41:16 -0400
Received: from verein.lst.de ([213.95.11.211]:38643 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhDIHlO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Apr 2021 03:41:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D9BEA68B02; Fri,  9 Apr 2021 09:40:34 +0200 (CEST)
Date:   Fri, 9 Apr 2021 09:40:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] block: stop calling blk_queue_bounce for
 passthrough requests
Message-ID: <20210409074034.GA5636@lst.de>
References: <20210331073001.46776-1-hch@lst.de> <20210331073001.46776-9-hch@lst.de> <20210408214506.GA184625@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408214506.GA184625@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 08, 2021 at 02:45:06PM -0700, Guenter Roeck wrote:
> On Wed, Mar 31, 2021 at 09:30:01AM +0200, Christoph Hellwig wrote:
> > Instead of overloading the passthrough fast path with the deprecated
> > block layer bounce buffering let the users that combine an old
> > undermaintained driver with a highmem system pay the price by always
> > falling back to copies in that case.
> > 
> 
> Hmm, that price is pretty high. When trying to boot sh images from usb,
> it results in a traceback, followed by an i/o error, and the drive
> fails to open.

That's just because this warning is completely bogus, sorry.

Does this patch fix the boot for you?

diff --git a/block/blk-map.c b/block/blk-map.c
index dac78376acc899..3743158ddaeb76 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -485,9 +485,6 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 	struct bio_vec bv;
 	unsigned int nr_segs = 0;
 
-	if (WARN_ON_ONCE(rq->q->limits.bounce != BLK_BOUNCE_NONE))
-		return -EINVAL;
-
 	bio_for_each_bvec(bv, bio, iter)
 		nr_segs++;
 
