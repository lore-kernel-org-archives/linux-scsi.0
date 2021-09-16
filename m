Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCD5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 01:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E1ED61164
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 01:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhIPBhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 21:37:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhIPBhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 21:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631756180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uyUrL1cWGAPfM3Qq6PAJKxGx/9G1qMQnrrqjWkVJBcc=;
        b=fqDu4bJRDMQmVVNJLpcsUW/GRorF0Xo829gLCz8+GX08bOE65fAlW2iBuUNFpsfwDCwdu5
        pLES6nqljhA3wvSEbb6vrPRK943E2Fqb1JmdeqfsdCUkOGbCcrR682z8XbkVXXD4lnMQvS
        7trzther3QMCNmKYqqEMNLFasR4Goh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-CgrpFrYhMWanHQ9OtjgEpQ-1; Wed, 15 Sep 2021 21:36:19 -0400
X-MC-Unique: CgrpFrYhMWanHQ9OtjgEpQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 644BF9126D;
        Thu, 16 Sep 2021 01:36:18 +0000 (UTC)
Received: from T590 (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DA2F5453A;
        Thu, 16 Sep 2021 01:36:11 +0000 (UTC)
Date:   Thu, 16 Sep 2021 09:36:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <YUKfl9Qqsluh+5FX@T590>
References: <20210915092547.990285-1-ming.lei@redhat.com>
 <20210915134008.GA13933@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915134008.GA13933@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2021 at 03:40:08PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 15, 2021 at 05:25:47PM +0800, Ming Lei wrote:
> > gendisk instance has to be released after request queue is cleaned up
> > because bdi is referred from gendisk since commit edb0872f44ec ("block:
> > move the bdi from the request_queue to the gendisk").
> > 
> > For sd and sr, gendisk can be removed in the release handler(sd_remove/
> > sr_remove) of sdev->sdev_gendev, which is triggered in device_del(sdev->sdev_gendev)
> > in __scsi_remove_device(), when the request queue isn't cleaned up yet.
> > 
> > So kernel oops could be triggered when referring bdi via gendisk.
> > 
> > Fix the issue by moving blk_cleanup_queue() into sd_remove() and
> > sr_remove().
> 
> This looks like a bit of a bandaid to me.  I think the proper fix
> is to move the parts of blk_cleanup_queue that need a disk or bdi
> to del_gendisk.

From correctness viewpoint, we need to call blk_cleanup_queue
before releasing gendisk and after del_gendisk(). Now you have invented
blk_cleanup_disk(), do you plan to do the three in one helper? :-)

We don't have to put del_gendisk & blk_cleanup_queue together,
and it may cause other trouble at least for scsi disk since sd_shutdown()
follows del_gendisk() and has to be called before blk_cleanup_queue().

BTW, you asked the reproducer of the issue, I just observed the issue
one or two time when running blktests block/009, but my scsi lifetime
bpftrace script does show that gendisk is released before blk_cleanup_queue().

Thanks,
Ming

