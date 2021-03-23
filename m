Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74289C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 16:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FC24619C6
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 16:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhCWQaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbhCWQ36 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 12:29:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C0CC061574;
        Tue, 23 Mar 2021 09:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jy5Q0tzVq2jeE/iMm6pO4Acq7xDdQjJiBpJ5FvD39Rs=; b=FgqBlA2xw+Zp7gcGNtxTQz8iCO
        rqjZPWVqBKUWpR/8coxjzgbUgfF/gE+mFd2bhZb2fGYQk7UAzbz9RhjJOINu7PM4TJYnLY6L2d3zO
        QH0a9wIYZzBlHrsaKV66twmsOitEXrLMeOJzci++590bh2nb8as3ZwxH+E+3PtAjAoc5Vy15dogMv
        qDs7py7bKcQKgRKjAPve3iuIRHZX6aF9KYL5EiOfo9kn4gRS7u1gziDDxNuRWCVzTnLRU7E3Ehhpa
        0jaJw3d3CQ0duuU3QUBdby2qKnG7nBGYw9LHPBTxyXXZ7WgL9YrY+fNWsmHKatDI6tbaKbRJtXoyW
        xjzo81jA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOjtx-00AHHf-4I; Tue, 23 Mar 2021 16:29:19 +0000
Date:   Tue, 23 Mar 2021 16:29:05 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        David Disseldorp <ddiss@suse.com>,
        J??rgen Gro?? <jgross@suse.com>
Subject: Re: [PATCH] target: pscsi: avoid OOM in pscsi_map_sg()
Message-ID: <20210323162905.GA2449048@infradead.org>
References: <20210323162203.30942-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323162203.30942-1-mwilck@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 23, 2021 at 05:22:03PM +0100, mwilck@suse.com wrote:
> Avoid this by simply not resetting nr_pages to 0 after allocating the
> bio. This way, the client receives an IO error when it tries to send
> requests exceeding the devices max_sectors_kb, and eventually gets
> it right. The client must still limit max_sectors_kb e.g. by an udev
> rule if (like in my case) the driver doesn't report valid block
> limits, otherwise it encounters I/O errors.

FYI, I think the what you did here is correct, but not enough.
When pscsi_get_bio (that is bio_kmalloc) fails, this function needs
to unwind and return an error insted of blindly retrying the allocation,
else we can't recover from a memory shortage.
