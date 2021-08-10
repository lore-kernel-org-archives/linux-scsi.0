Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BEDC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 16:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43655610A3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 16:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhHJQGk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 12:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhHJQGk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 12:06:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007B0C0613C1;
        Tue, 10 Aug 2021 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+Jv2/jgZobz77fOiD8+fY2ru4eleuTODaKvjUo/2u+I=; b=HRdFuY4DcvoUGHl6bV0gtVyH+9
        L5swwp66b//JG9wsDDrcQ2fc9jVXM38wBl0q9QAl7O3qDn2CMlKJcsC+S7XESBvy96aQ/GgQUd+I9
        xe2Mq920y5dmnLgq7LiWjs9nanmmyF3OFWhhA4MFdgsWYWwBBMrcHMUG+VKGKqrdu46bmzp2fNf1c
        jNWTu2xge0TIdv8/u74jDAwuAxUthYJqWyVZcTfQDwmKQzk2BVbw9TmQxnNO+vkRliYVipul6H7Nj
        th26o5TwUYwz3D18l6mDH5bwKW4xd9/NaVnRZmx+kSYowCZniqTgA3ihmhXwJ9FD5yUqZLBhRkPf6
        kpzI1yqg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDUD3-00CJUH-Hb; Tue, 10 Aug 2021 16:03:46 +0000
Date:   Tue, 10 Aug 2021 17:02:33 +0100
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Message-ID: <YRKjGeOZLVnTjQNv@infradead.org>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-2-damien.lemoal@wdc.com>
 <YRI3kMc39XPRLe/u@infradead.org>
 <DM6PR04MB7081844211DF94238A3FC6B4E7F79@DM6PR04MB7081.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB7081844211DF94238A3FC6B4E7F79@DM6PR04MB7081.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 10, 2021 at 11:03:41AM +0000, Damien Le Moal wrote:
> >> + * Dummy release function to make kobj happy.
> >> + */
> >> +static void blk_cranges_sysfs_nop_release(struct kobject *kobj)
> >> +{
> >> +}
> > 
> > How do we ensure the kobj is still alive while it is accessed?
> 
> q->sysfs_lock ensures that. This mutex is taken whenever revalidate registers
> new ranges (see blk_queue_set_cranges below), and is taken also when the ranges
> are unregistered (on revalidate if the ranges changed and when the request queue
> is unregistered). And blk_crange_sysfs_show() takes that lock too. So the kobj
> cannot be freed while it is being accessed (the sysfs inode lock also prevents
> it since kobj_del() will take the inode lock).

Does it?  It only protects the access inside of it, but not the object
lifetime.

> 
> > 
> >> +void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr)
> > 
> > s/blk_queue/disk/
> 
> Hmmm... The argument is a gendisk, but it is the request queue that is modified.
> So following other functions like this, isn't blk_queue_ prefix better ?

Do we have blk_queue_ functions that take a gendisk anywhere?  The
ones I noticed (and the ones I've recently added) all use disk_.
