Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F59C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 06:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbiBWG5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 01:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiBWG5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 01:57:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA24B2B272
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 22:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645599412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1EMmPJafXHXRzYqFZckhxf+uaKriOSTCcxW6+0fLvyE=;
        b=htwoj5ISHhsZOWOAlkYN43IGJQH61M8qSL8kvJ9ebnBRdv7xx08WhwZi5b9tRuHNe6Aao5
        b1/JoxVBPKNl+wG0C3tsicEa7MdyUj352Gi626tN9vaW9qqoYIOTNulc4gzpczU576g1bA
        LW2q8OUCJGdZghwHaFKVJXTfp2J5UbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-fAwJKovqNxKMqp2ZfTfcqA-1; Wed, 23 Feb 2022 01:56:51 -0500
X-MC-Unique: fAwJKovqNxKMqp2ZfTfcqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9BD51854E21;
        Wed, 23 Feb 2022 06:56:49 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7522D7A231;
        Wed, 23 Feb 2022 06:56:42 +0000 (UTC)
Date:   Wed, 23 Feb 2022 14:56:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 10/12] block: move blk_exit_queue into disk_release
Message-ID: <YhXapc7fuhb8mlwW@T590>
References: <20220222141450.591193-1-hch@lst.de>
 <20220222141450.591193-11-hch@lst.de>
 <4b9a4121-7f37-9bd3-036a-51892a456eef@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b9a4121-7f37-9bd3-036a-51892a456eef@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2022 at 10:29:47AM -0800, Bart Van Assche wrote:
> On 2/22/22 06:14, Christoph Hellwig wrote:
> > From: Ming Lei <ming.lei@redhat.com>
> > 
> > There can't be FS IO in disk_release(), so move blk_exit_queue() there.
> > 
> > We still need to freeze queue here since the request is freed after the
> > bio is completed and passthrough request rely on scheduler tags as well.
> > 
> > The disk can be released before or after queue is cleaned up, and we have
> > to free the scheduler request pool before blk_cleanup_queue returns,
> > while the static request pool has to be freed before exiting the
> > I/O scheduler.
> 
> This patch looks dubious to me because:
> - The blk_freeze_queue() call in blk_cleanup_queue() waits for pending
>   requests to finish, so why to move blk_exit_queue() from
>   blk_cleanup_queue() into disk_release()?

scsi disk may be released before calling blk_cleanup_queue(), and we
want to tear down all FS related stuff(cgroup, rqos, elevator) in disk_release().

And FS bios have been drained already when releasing disk.

> - I'm concerned that this patch will break user space, e.g. scripts that
>   try to unload an I/O scheduler kernel module immediately after having
>   removed a request queue.

When removing a request queue, the associated disk has been removed
already, and queue's kobject has been deleted too, so how can userspace
unload I/O scheduler at that time?

> 
> > +static void blk_mq_release_queue(struct request_queue *q)
> > +{
> > +	blk_mq_cancel_work_sync(q);
> > +
> > +	/*
> > +	 * There can't be any non non-passthrough bios in flight here, but
> > +	 * requests stay around longer, including passthrough ones so we
> > +	 * still need to freeze the queue here.
> > +	 */
> > +	blk_mq_freeze_queue(q);
> 
> The above comment should be elaborated since what matters in this context is
> not whether or not any bios are still in flight but what happens with the
> request structures.

Yeah, bios have been done, but request is done after bio is ended, see
blk_update_request(), that is why we added blk_mq_freeze_queue() here.

> As you know blk_queue_enter() fails after the DYING flag
> has been set, a flag that is set by blk_cleanup_queue().blk_cleanup_queue()
> already freezes the queue. So why is it necessary to call
> blk_mq_freeze_queue() from blk_mq_release_queue()?

disk may be released before calling blk_cleanup_queue().

But I admit here the name of blk_mq_release_queue() is very misleading,
maybe blk_mq_release_io_queue() is better?


Thanks,
Ming

