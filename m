Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359F2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 04:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 074E561058
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 04:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhICE3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Sep 2021 00:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhICE3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2021 00:29:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC71EC061575;
        Thu,  2 Sep 2021 21:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wZ2Hz0OCkOQo04Tv7XC9luk9+pT8IdikbL6e2p/MKw4=; b=MTzropaw7S1HoKtqiXLHAHD0fj
        tyjDT7d+7Ht4X3ys/wQnJn56toNXu3zPj+AqiHuy3XBWIaBb3B6phmNHDcf1OMFXOVIgj4TkYL50h
        lW64/PFmSyYxsEU3VvoXs9kcEyY3COTdJRriN7ZF2EM5ND7nxcaaFQVdUMgHUJI8FfU/vfELNgkj9
        E3qPqNF9DnmJH7BrzmMhE1xBjXmtjIDqduREc/hmqGmMhfeDknJf6sGJHrd1jKSytWUSXsOvWHL3Y
        LenatZhCTZFL6QI3zoDWfF5p4wnlXqciNBXjSNe7i+FElHxnjVxY8nLUwgyDSq4+edqaBjmkOusg2
        V5Ur+4Og==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mM0nW-0046yx-RU; Fri, 03 Sep 2021 04:27:43 +0000
Date:   Fri, 3 Sep 2021 05:27:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.14+ merge window
Message-ID: <YTGkLhfYWcvj4YRn@infradead.org>
References: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
 <CAHk-=wi99u+xj93-pLG0Na7SZmjvWg6n60Pq9Wt9PgO6=exdUA@mail.gmail.com>
 <26c12f13870a2276f41aebfea6e467d576f70860.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26c12f13870a2276f41aebfea6e467d576f70860.camel@HansenPartnership.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 02, 2021 at 04:23:43PM -0700, James Bottomley wrote:
> > 
> > Just checking that was fine, and I notice how *many* places do that.
> > 
> > Should the blk_execute_rq() function even take that "struct gendisk
> > *bd_disk" argument at all?

No, it shouldn't.  rq->rq_disk should go away and use rq->q->disk
instead.  This has been on my TODO list, but didn't make the cut for
this merge window.
