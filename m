Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629D4C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 01:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJSBX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 21:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJSBX0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 21:23:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E43E070E
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 18:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666142604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMOprsDQUY4INvBuBGxV3T7LRHx+WHc/e/o7v3nW7u4=;
        b=IOJfI/xgpQvy0Lbs/CE8MPgi0LXj/Zoq4vY9qkqqfxSHKBrCnkkcITIYM7ew/dgM7seJXD
        cP3suDhHrV7fZhQ+pr9r2U7HRqcZcErtKlMzKaWVBB8RPbYhzif3IDMJfxy8R6Ppiccx+I
        cI5jxFlZWPe7mUiZ6jbl4aQCFDUg4xI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-kFCXiaauNs6sbrEKiLkEsA-1; Tue, 18 Oct 2022 21:23:13 -0400
X-MC-Unique: kFCXiaauNs6sbrEKiLkEsA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C247D884342;
        Wed, 19 Oct 2022 01:23:12 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 281C2200B408;
        Wed, 19 Oct 2022 01:23:06 +0000 (UTC)
Date:   Wed, 19 Oct 2022 09:23:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/4] scsi: remove an extra queue reference
Message-ID: <Y09Rdh0O23cvizeQ@T590>
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-3-hch@lst.de>
 <Y09QCb5A+iL/Igoj@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y09QCb5A+iL/Igoj@T590>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 19, 2022 at 09:16:57AM +0800, Ming Lei wrote:
> On Tue, Oct 18, 2022 at 03:57:18PM +0200, Christoph Hellwig wrote:
> > Now that blk_mq_destroy_queue does not release the queue reference, there
> > is no need for a second queue reference to be held by the scsi_device.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/scsi/scsi_scan.c  | 1 -
> >  drivers/scsi/scsi_sysfs.c | 1 -
> >  2 files changed, 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 5d27f5196de6f..0a95fa787fdf4 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -344,7 +344,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
> >  	sdev->request_queue = q;
> >  	q->queuedata = sdev;
> >  	__scsi_init_queue(sdev->host, q);
> > -	WARN_ON_ONCE(!blk_get_queue(q));
> >  
> >  	depth = sdev->host->cmd_per_lun ?: 1;
> >  
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 1214c6f07bc64..c95177ca6ed26 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -1478,7 +1478,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
> >  	mutex_unlock(&sdev->state_mutex);
> >  
> >  	blk_mq_destroy_queue(sdev->request_queue);
> > -	blk_put_queue(sdev->request_queue);
> 
> The above put is counter-pair of blk_get_queue() in scsi_alloc_sdev, and
> the original blk_put_queue() in blk_mq_destroy_queue() is counter-pair of
> the initial get in blk_alloc_queue().
> 
> Now blk_put_queue() is moved out of blk_mq_destroy_queue(), I am wondering
> how the scsi queue lifetime can work correctly with this patch? Or is there
> bug in current scsi code?

oops, the above blk_put_queue() is actually added in the 1st patch, so
this patch is fine, sorry for the noise.


thanks,
Ming

