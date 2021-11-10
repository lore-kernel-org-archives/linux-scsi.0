Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB99AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 14:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D5460FD8
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 14:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhKJO7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 09:59:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232280AbhKJO7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 09:59:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636556207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7cJ877Sjjq5oc7jJvg2EQRkkagoEG/3Etdis5neQYc=;
        b=HXsytoZ8d+cVbHs2pc9qn7eC1qBOc19caALFQvR/TC2VtBYYTQbVRsXv411+yWXDOWYmDC
        sndEN2REMF0HLiMrFlToi7wys7RJlgo9+qQcARMt3uHdr2OfNbn1uSeqGLixnvNnN3GY6W
        pJAhMFCJc9MW65qYq5242WFCKIbXWQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-7TusmjS5M6qoNkhw4LdjIQ-1; Wed, 10 Nov 2021 09:56:44 -0500
X-MC-Unique: 7TusmjS5M6qoNkhw4LdjIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D544F100D680;
        Wed, 10 Nov 2021 14:56:42 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CF0460843;
        Wed, 10 Nov 2021 14:56:26 +0000 (UTC)
Date:   Wed, 10 Nov 2021 22:56:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: sorting out the freeze / quiesce mess
Message-ID: <YYvdlcHeWOxPACrK@T590>
References: <20211110091407.GA8396@lst.de>
 <YYuQ9mhHtDNDVFQ3@T590>
 <20211110125856.GA25614@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110125856.GA25614@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 10, 2021 at 01:58:56PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 10, 2021 at 05:29:26PM +0800, Ming Lei wrote:
> > On Wed, Nov 10, 2021 at 10:14:07AM +0100, Christoph Hellwig wrote:
> > > Hi Jens and Ming,
> > > 
> > > I've been looking into properly supporting queue freezing for bio based
> > > drivers (that is only release q_usage_counter on bio completion for them).
> > > And the deeper I look into the code the more I'm confused by us having
> > > the blk_mq_quiesce* interface in addition to blk_freeze_queue.  What
> > > is a good reason to do a quiesce separately from a freeze?
> > 
> > freeze can make sure that all requests are done, quiesce can make sure that
> > dispatch critical area(covered by hctx lock/unlock) is done.
> 
> Yeah, but why do we need to still call quiesce after we just did a
> freeze, which is about half of the users?

Because the caller need to make sure that dispatch critical area is
gone, otherwise dispatch code path may see intermediate state of the
change, such as switching elevator, and __blk_mq_update_nr_hw_queues()
may need quiesce too, I remember that there was kernel panic log in
some test.

Please see the point in commit 662156641bc4 ("block: don't drain
in-progress dispatch in blk_cleanup_queue()").


Thanks,
Ming

