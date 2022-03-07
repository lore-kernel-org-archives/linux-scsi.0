Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A61C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 02:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiCGCvS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 21:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiCGCvR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 21:51:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 098AF25C7E
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 18:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646621423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FJEcHpliK8hzc4zrepjvUVJb9/YWMH25+xvkMWj2sb4=;
        b=Ctg4miIM43ahTamCpPQvQxUi1EAztseNDorSUzcJV2wm3wEXgvCBkSEllxxcSLBD4QJowB
        jIjjwySUARiurv1mP9RlT2cs6tKVpfJ7lxs1Lnym/sXWORxm76ORB9jLCN8CHhuF0mHVp+
        idf5K+dICOUmlgs2jfx0Y+OE90plHQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-COH5RrKDMqSkgTWe8gV-GA-1; Sun, 06 Mar 2022 21:50:20 -0500
X-MC-Unique: COH5RrKDMqSkgTWe8gV-GA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDA4E108088A;
        Mon,  7 Mar 2022 02:50:18 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 601E83058B;
        Mon,  7 Mar 2022 02:50:14 +0000 (UTC)
Date:   Mon, 7 Mar 2022 10:50:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 14/14] block: move rq_qos_exit() into disk_release()
Message-ID: <YiVy4jk00NQJPoiX@T590>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-15-hch@lst.de>
 <85ea5b62-ac03-1d9a-f1bd-040e58235957@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85ea5b62-ac03-1d9a-f1bd-040e58235957@acm.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Mar 06, 2022 at 12:51:37PM -0800, Bart Van Assche wrote:
> On 3/4/22 08:03, Christoph Hellwig wrote:
> > From: Ming Lei <ming.lei@redhat.com>
> > 
> > There can't be FS IO in disk_release(), so it is safe to move rq_qos_exit()
> > there.
> 
> The commit message only explains why it is safe to move rq_qos_exit() but
> not why moving that function call is useful. Please add an explanation of
> why moving that function call is useful and/or necessary.
> 
> > diff --git a/block/genhd.c b/block/genhd.c
> > index 857e0a54da7dd..56f66c6fee943 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -627,7 +627,6 @@ void del_gendisk(struct gendisk *disk)
> >   	blk_mq_freeze_queue_wait(q);
> > -	rq_qos_exit(q);
> >   	blk_sync_queue(q);
> >   	blk_flush_integrity();
> >   	/*
> > @@ -1119,7 +1118,7 @@ static void disk_release_mq(struct request_queue *q)
> >   		elevator_exit(q);
> >   		mutex_unlock(&q->sysfs_lock);
> >   	}
> > -
> > +	rq_qos_exit(q);
> >   	__blk_mq_unfreeze_queue(q, true);
> >   }
> 
> Commit 8e141f9eb803 ("block: drain file system I/O on del_gendisk") removed
> the rq_qos_exit() call from blk_cleanup_queue(). This patch series does not
> restore the rq_qos_exit() call in blk_cleanup_queue(). I think that call
> should be restored since rq_qos_add() can be called before add_disk() is
> called. I'm referring to the following call chain:
> 
> __alloc_disk_node()
>   blkcg_init_queue()
>     blk_iolatency_init()
>       rq_qos_add()
> 
> sd_probe() is one of the functions that can take an error path after
> __alloc_disk_node() has returned and before device_add_disk() is called.

blkcg_exit_queue() is called in disk_release(), so this error handing is
covered since put_disk() should be called once __alloc_disk_node()
is successful, no matter disk is added or not.

We move rq_qos_exit() to disk_release() too, then every FS IO related
resources are released in disk_release().


Thanks,
Ming

