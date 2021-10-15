Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869F7C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63FE561040
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241108AbhJOQFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 12:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241102AbhJOQFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 12:05:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5D6C061570;
        Fri, 15 Oct 2021 09:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Od2a8TFTLmg9DGz72n8zhdlcSfRxQN9hmAR8G79f8WM=; b=zpoEuN51DFs4fhLm9POkiTQky4
        9O/oaqVH2laWoAs8xuwUdEKR4/qbrzR/U21xA9Xztch1OlsSCl0n4YInhg7MTTmOsrxQZwr/9xdRW
        ytuBXSaeO0eE3YnOi//wyLqxzUY2Wv7n4Tua7gKLfwf1ZOhzIFYYB6fbcX85qF4omi6wOeNsXYsAj
        P3AAaaFMtNaNmhXE1yzu5AVLWvZUXunFIpq9/MQV7ao2oZGOA7/msv+IKWQDmiTQp1rPYWu4uUlh6
        v2rV29C81WiKHBmadBY8UQNISQRNz/tZeTef+0rOelvrUedFIoDf+oKeQ66aaUW15yhBvRr706oy1
        QyzXgp/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbPg8-007zM4-Cn; Fri, 15 Oct 2021 16:03:28 +0000
Date:   Fri, 15 Oct 2021 09:03:28 -0700
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
Subject: Re: [RFC PATCH 1/3] blk-mq: Add blk_mq_complete_request_direct()
Message-ID: <YWmmULYUeo/Zd6Jl@infradead.org>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
 <20211015151412.3229037-2-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015151412.3229037-2-bigeasy@linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 15, 2021 at 05:14:10PM +0200, Sebastian Andrzej Siewior wrote:
> +void blk_mq_complete_request_direct(struct request *rq)
> +{
> +	WRITE_ONCE(rq->state, MQ_RQ_COMPLETE);
> +	rq->q->mq_ops->complete(rq);
> +}

As this is called by the driver we known what ->complete this helper
would call.  So instead of doing this we could just call
blk_mq_set_request_complete and the actual completion helper.
The comment above it will need some updates of course.
