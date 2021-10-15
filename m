Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A44C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29724611C8
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbhJOQGy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 12:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbhJOQGy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 12:06:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93D1C061570;
        Fri, 15 Oct 2021 09:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f31w9jlCa4y93qVpkbz4atwBJoIOyvuXZWoGFNfwrio=; b=1Zf1lSV8phFEyOjVWN2rwh12kw
        jMnFtMon9IMRbasfsba+nRBlEAf81YGkD7juzarsuXX0seU+fUBM6vfnh2HVNeiNQ8ijG0TJmunDs
        mJRVqi9mbnEabZkyOPoeqsFm9wnACfOS/B8D9KpOp3X75lsYCXLYNDvj6QrGuP9LjPXNO3U0skz0m
        DRVp/VsqmAxyzxxmg1Lo9ybLX0Rt6FZPBEcYqaqoRL3BpFz0V0gYcSrP/159JzJeNFClt1Hw7UNJC
        +opX+mN3uf5LJRAPRXdkl1VypXe/S2T+YOG+zBGeqXk0+LCTwXgcWl/rlrvK3/uV7pnnbPRpjW+Dv
        lSmMBBlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbPhP-007zTe-Fh; Fri, 15 Oct 2021 16:04:47 +0000
Date:   Fri, 15 Oct 2021 09:04:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] scsi, usb: storage: Complete the blk-request
 directly.
Message-ID: <YWmmn4MpTSGHRVOU@infradead.org>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
 <20211015151412.3229037-4-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015151412.3229037-4-bigeasy@linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart has been working on removing the ->scsi_done indirection, so this
will need to find a way to interact with that
