Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB316C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 12:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DB8560F6D
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 12:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbhIPMji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 08:39:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239574AbhIPMjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 08:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631795897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yBKLYsV0N6z9rzcEtJE1EU2x2DGbJENSdnpMiAD5pkg=;
        b=gJgWgeG+DRFSlNzab4SmgujUxfpPOw1IuM+MNj7KjiAn8XzK/xgSK4hC7L+znbShmubhXg
        Pi008Q+oYSIkxRM1B736HzdMCJVC9Y8EAdKNLXkqdVTXbFrB+NvzgGDt/m706IOhFMmWhC
        Q60Rvb7U/Qr2qCil0A3GzdHtR2H6+BM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-wKpmBBD1MfGr6Weps-WZfA-1; Thu, 16 Sep 2021 08:38:14 -0400
X-MC-Unique: wKpmBBD1MfGr6Weps-WZfA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1F7713E0;
        Thu, 16 Sep 2021 12:38:12 +0000 (UTC)
Received: from T590 (ovpn-12-89.pek2.redhat.com [10.72.12.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E701A6A912;
        Thu, 16 Sep 2021 12:38:05 +0000 (UTC)
Date:   Thu, 16 Sep 2021 20:38:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <YUM6uFHqfjWMM5BH@T590>
References: <20210915092547.990285-1-ming.lei@redhat.com>
 <20210915134008.GA13933@lst.de>
 <YUKfl9Qqsluh+5FX@T590>
 <20210916101451.GA26782@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916101451.GA26782@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 16, 2021 at 12:14:51PM +0200, Christoph Hellwig wrote:
> On Thu, Sep 16, 2021 at 09:36:23AM +0800, Ming Lei wrote:
> > >From correctness viewpoint, we need to call blk_cleanup_queue
> > before releasing gendisk and after del_gendisk(). Now you have invented
> > blk_cleanup_disk(), do you plan to do the three in one helper? :-)
> 
> No.  In retrospective blk_cleanup_disk wan't the best idea for a few
> reasons.  But at least it consolidated some of the code.
> 
> > We don't have to put del_gendisk & blk_cleanup_queue together,
> 
> I don't want all of it together.  The important thing is that we have
> two different concepts:
> 
>  - the gendisk is required to do file system style I/O
>  - a standalone request_queue can be used for passthrough I/O.

request_queue is also abstract in block I/O's implementation, which
can be thought as one lower level concept of gendisk too, IMO.

> 
> > and it may cause other trouble at least for scsi disk since sd_shutdown()
> > follows del_gendisk() and has to be called before blk_cleanup_queue().
> 
> Yes.  So we need to move the bits of blk_cleanup_queue that deal with
> the file system I/O state to del_gendisk, and keep blk_cleanup_queue
> for anything actually needed for the low-level queue.

Can you explain what the bits are in blk_cleanup_queue() for dealing with FS
I/O state? blk_cleanup_queue() drains and shutdown the queue basically,
all shouldn't be related with gendisk, and it is fine to implement one
queue without gendisk involved, such as nvme admin, connect queue or
sort of stuff.

Wrt. this reported issue, rq_qos_exit() needs to run before releasing
gendisk, but queue has to put into freezing before calling
rq_qos_exit(), so looks you suggest to move the following code into
del_gendisk()?


        WARN_ON_ONCE(blk_queue_registered(q));

        /* mark @q DYING, no new request or merges will be allowed afterwards */
        blk_set_queue_dying(q);

        blk_queue_flag_set(QUEUE_FLAG_NOMERGES, q);
        blk_queue_flag_set(QUEUE_FLAG_NOXMERGES, q);

        /*
         * Drain all requests queued before DYING marking. Set DEAD flag to
         * prevent that blk_mq_run_hw_queues() accesses the hardware queues
         * after draining finished.
         */
        blk_freeze_queue(q);

        rq_qos_exit(q);

If we move the above into del_gendisk(), some corner cases have to be
taken care of, such as request queue without disk involved.

> 
> To take SCSI as the example.  We can unload the sd/sr drivers and the
> queue needs to still be around and work for use with the sg driver.
> 
> > BTW, you asked the reproducer of the issue, I just observed the issue
> > one or two time when running blktests block/009, but my scsi lifetime
> > bpftrace script does show that gendisk is released before blk_cleanup_queue().
> 
> Interesting.  What were the symptoms in this case?

It is same with recent report of 'general protection fault in wb_timer_fn'.


Thanks,
Ming

