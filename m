Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AF2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2331460551
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241188AbhJOQRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 12:17:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51160 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237297AbhJOQRn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 12:17:43 -0400
Date:   Fri, 15 Oct 2021 18:15:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634314534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kMbTcK15uIz0HsQ3WSvQXeugdE8BLrV8aOC8u6pdZ/8=;
        b=q0ROeP04tkGDDHPqvulfbz8fOAbZrut06xJuDMEz0ABTlFNYodYzuc7gXedIjX8+nF0LDg
        FNquYrQGMXr8hgw1dVoHvGh8ftMLIWXAckzj+rEjPA/p/bbCuZGM2u0VtXl7V2inaKrZUA
        0e3oy43YrUANJyL53oF6Im7ecb96USf9QnVtPpj/FFKHUcJhCUVyKdyW1Hs+eR8dndHXoa
        m4JZA/fOLNXkDNgG7aD6TSuIUW1nCjjhB1SyVIV8CYCD/FL/Th5C3O46zNLojjI5KvNAjD
        lx4eJ4wKwizmyPlKERCiupGjBKSEXq843aQ7zQ+8kZdgDUA/io27u6x/nkVWWg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634314534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kMbTcK15uIz0HsQ3WSvQXeugdE8BLrV8aOC8u6pdZ/8=;
        b=6Z1CiNh3rp8CpisHQ7LlZ3PR91C7Zs+QQt4iul4IrwSkMRX6dq4ZeoGlgPRnWkNVwupwsN
        P8bwLTsl6SlTaTCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/3] blk-mq: Add blk_mq_complete_request_direct()
Message-ID: <20211015161533.5cnhqqd3asy3e3vg@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
 <20211015151412.3229037-2-bigeasy@linutronix.de>
 <YWmmULYUeo/Zd6Jl@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YWmmULYUeo/Zd6Jl@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-15 09:03:28 [-0700], Christoph Hellwig wrote:
> On Fri, Oct 15, 2021 at 05:14:10PM +0200, Sebastian Andrzej Siewior wrote:
> > +void blk_mq_complete_request_direct(struct request *rq)
> > +{
> > +	WRITE_ONCE(rq->state, MQ_RQ_COMPLETE);
> > +	rq->q->mq_ops->complete(rq);
> > +}
> 
> As this is called by the driver we known what ->complete this helper
> would call.  So instead of doing this we could just call
> blk_mq_set_request_complete and the actual completion helper.
> The comment above it will need some updates of course.

So
	blk_mq_set_request_complete();
	mmc_blk_mq_complete();

for the mmc driver and no fiddling in the blk-mq then.

Sebastian
