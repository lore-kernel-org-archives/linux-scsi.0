Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A7CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 09:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD92E610CB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 09:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhKJJzQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 04:55:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229831AbhKJJzP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 04:55:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636537948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7oqI1vSf7oW8hr4gNp34G0zlAlDGH6S3+qYy9C5RByg=;
        b=c1jqmqH1HFHlRaVu63sLIMdJaSXy+YfYJmW/lW9CzoH6fpudMK5NJaCuOAG2ImxNfJmvBk
        tDcNVI/st5nf8goFFzwW1ZnXQNgqUmz2S7RIyznCMxxM/pASnTxJCpmPrRrY2n6I8I7TH1
        8SrIDtAVwcOXiVaTFa6QeBCgSQ9wDms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-pCtNLx6KN3WaiDesogfB7w-1; Wed, 10 Nov 2021 04:52:25 -0500
X-MC-Unique: pCtNLx6KN3WaiDesogfB7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07A50804141;
        Wed, 10 Nov 2021 09:52:24 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 118E410016F2;
        Wed, 10 Nov 2021 09:52:20 +0000 (UTC)
Date:   Wed, 10 Nov 2021 17:52:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: sorting out the freeze / quiesce mess
Message-ID: <YYuWTefkvpy5uYgs@T590>
References: <20211110091407.GA8396@lst.de>
 <YYuQ9mhHtDNDVFQ3@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYuQ9mhHtDNDVFQ3@T590>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 10, 2021 at 05:29:26PM +0800, Ming Lei wrote:
> On Wed, Nov 10, 2021 at 10:14:07AM +0100, Christoph Hellwig wrote:
> > Hi Jens and Ming,
> > 
> > I've been looking into properly supporting queue freezing for bio based
> > drivers (that is only release q_usage_counter on bio completion for them).
> > And the deeper I look into the code the more I'm confused by us having
> > the blk_mq_quiesce* interface in addition to blk_freeze_queue.  What
> > is a good reason to do a quiesce separately from a freeze?
> 
> freeze can make sure that all requests are done, quiesce can make sure that
> dispatch critical area(covered by hctx lock/unlock) is done.

Another difference: quiesce usually is used to stop to queue requests to
LLD, and driver needs no requets queued any more after the interface returns,
freeze can't do that.

Thanks,
Ming

