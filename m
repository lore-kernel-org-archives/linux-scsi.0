Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AE6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 03:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA9A56108F
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 03:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244045AbhIQDlE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 23:41:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242037AbhIQDlD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 23:41:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631849981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B9r/+Zs88h2CfccJTBLTJgNfdwtNFfPY6UfBjfQU3/E=;
        b=Mp6aMp3JL7vVe0h3GQLlol+G61AaZvCg+ejCg3QgLgNEs1nzQy030r9d9KIq/qXY3mN9MH
        egzYBJwzbKFABstOMzpLttoBaJw+81aB4PsMl8zzL5oa8tOQdkVmPJoUmNgXsjRZ1xGDcs
        eb6WMJ3g/IdKbeUB0iTTs3G+fYF5k6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-S64eqPBnPpae_FmZr_hRmw-1; Thu, 16 Sep 2021 23:39:40 -0400
X-MC-Unique: S64eqPBnPpae_FmZr_hRmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CB0D8145E6;
        Fri, 17 Sep 2021 03:39:39 +0000 (UTC)
Received: from T590.Home (ovpn-12-120.pek2.redhat.com [10.72.12.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F64D5D9D3;
        Fri, 17 Sep 2021 03:39:35 +0000 (UTC)
Date:   Fri, 17 Sep 2021 11:39:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <YUQOBKa67R9pEunr@T590.Home>
References: <20210915092547.990285-1-ming.lei@redhat.com>
 <20210915134008.GA13933@lst.de>
 <YUKfl9Qqsluh+5FX@T590>
 <20210916101451.GA26782@lst.de>
 <YUM6uFHqfjWMM5BH@T590>
 <20210916142009.GA12603@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916142009.GA12603@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 16, 2021 at 04:20:09PM +0200, Christoph Hellwig wrote:
> On Thu, Sep 16, 2021 at 08:38:16PM +0800, Ming Lei wrote:
> > > > and it may cause other trouble at least for scsi disk since sd_shutdown()
> > > > follows del_gendisk() and has to be called before blk_cleanup_queue().
> > > 
> > > Yes.  So we need to move the bits of blk_cleanup_queue that deal with
> > > the file system I/O state to del_gendisk, and keep blk_cleanup_queue
> > > for anything actually needed for the low-level queue.
> > 
> > Can you explain what the bits are in blk_cleanup_queue() for dealing with FS
> > I/O state? blk_cleanup_queue() drains and shutdown the queue basically,
> > all shouldn't be related with gendisk, and it is fine to implement one
> > queue without gendisk involved, such as nvme admin, connect queue or
> > sort of stuff.
> > 
> > Wrt. this reported issue, rq_qos_exit() needs to run before releasing
> > gendisk, but queue has to put into freezing before calling
> > rq_qos_exit(),
> 
> I was curious what you hit, but yes rq_qos_exit is obvious.
> blk_flush_integrity also is very much about fs I/O state.
> 
> 
> 
> > so looks you suggest to move the following code into
> > del_gendisk()?
> 
> something like that.  I think we need to split the dying flag into
> one for the gendisk and one for the queue first, and make sure the
> queue freeze in del_gendisk is released again so that passthrough
> still works after.

If we do that, q->disk is really unnecessary, so looks the fix of
'd152c682f03c block: add an explicit ->disk backpointer to the request_queue'
isn't good. The original issue added in 'edb0872f44ec block: move the
bdi from the request_queue to the gendisk' can be fixed simply by moving
the two lines code in blk_unregister_queue() to blk_cleanup_queue():

        kobject_uevent(&q->kobj, KOBJ_REMOVE);
        kobject_del(&q->kobj);


Thanks,
Ming

