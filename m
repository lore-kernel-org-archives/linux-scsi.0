Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2595AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 09:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456606AbiAYJMD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 04:12:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1453719AbiAYIze (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 03:55:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643100932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qbUXbdIpxR2xFT2q0NmyKpU21hdp1+TV9GE31xW0gGk=;
        b=Ow4CuFlhdlXFdtjy+bY9zf+jnQO5VBenrfEbLHLeEVChgNyp4k75tbS4Gx5bx+flCkqZ+W
        fJkXAFQULrbDBC4NM0f780BXVF6MvZPoKWrLonaojGqyv87sZGPUBKynxhrFxPZV+NufvG
        oqfnqs7yNkyItiWVOzzVXBonW3pgcjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-sZYhBf1lO---MmiEipssQg-1; Tue, 25 Jan 2022 03:55:31 -0500
X-MC-Unique: sZYhBf1lO---MmiEipssQg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEB19190A7A4;
        Tue, 25 Jan 2022 08:55:29 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 098C01F30C;
        Tue, 25 Jan 2022 08:54:48 +0000 (UTC)
Date:   Tue, 25 Jan 2022 16:54:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V2 09/13] scsi: force unfreezing queue into atomic mode
Message-ID: <Ye+605vZEyx3ofi2@T590>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-10-ming.lei@redhat.com>
 <20220124131516.GH27269@lst.de>
 <Ye80kxTBojm6GN8k@T590>
 <20220125072739.GA27777@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125072739.GA27777@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 08:27:39AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 25, 2022 at 07:21:55AM +0800, Ming Lei wrote:
> > > > @@ -3670,7 +3670,7 @@ static void scsi_disk_release(struct device *dev)
> > > >  	 * in case multiple processes open a /dev/sd... node concurrently.
> > > >  	 */
> > > >  	blk_mq_freeze_queue(q);
> > > > -	blk_mq_unfreeze_queue(q);
> > > > +	__blk_mq_unfreeze_queue(q, true);
> > > 
> > > I think the right thing here is to drop the freeze/unfreeze pair.
> > > Now that del_gendisk properly freezes the queue, we don't need this
> > > protection as the issue that Bart fixed with it can't happen any more.
> > 
> > As you see, the last patch removes freeze/unfreeze pair in del_gendisk(),
> > which looks not very useful: it can't drain IO on bio based driver, and
> > del_gendisk() is supposed to provide consistent behavior for both request
> > and bio based driver.
> 
> So what is the advantage of trying to remove the freeze from where
> it belongs (common unregister code) while keeping it where it is a bandaid
> (driver specific unregister code)?

freeze in common unregister code is actually not good, because it provide
nothing for bio based driver, so we can't move blk-cgroup shutdown into
del_gendisk. Also we can't move elevator shutdown to del_gendisk for
similar reason.

Secondly freeze is pretty slow in percpu mode, so why slow down removing every
disk just for scsi's bandaid?


Thanks,
Ming

