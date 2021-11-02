Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D45DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 12:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 249646108F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 12:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhKBNBm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 09:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230336AbhKBNBl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 09:01:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635857946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ap4rayfMy+LgBzDf4WHAGO+fWE9T54+/CMboo6Kyto4=;
        b=bYUcVCO479MZ9wXO/XvBDc4VLjL4gaRcJ8Qy6MpSjn0+fLjPjSBGuC21FJVGVTMKQsA1X1
        H0VKTwMnAFFhH75ev8VzezEwJNjNmJohO3TURpAC+qdDEa4zH5xiXwKOxfT1pGHHZgl9Gp
        581YnplkKy2AlauwB6M7Ls9oiUsjhGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-AukYeLysOsOb8aApGnWQtQ-1; Tue, 02 Nov 2021 08:59:01 -0400
X-MC-Unique: AukYeLysOsOb8aApGnWQtQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B283E100B700;
        Tue,  2 Nov 2021 12:58:59 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 379F95D740;
        Tue,  2 Nov 2021 12:58:05 +0000 (UTC)
Date:   Tue, 2 Nov 2021 20:58:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/3] scsi: make sure that request queue queiesce and
 unquiesce balanced
Message-ID: <YYE12XJ66QWpr4Fo@T590>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
 <20211021145918.2691762-3-ming.lei@redhat.com>
 <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Mon, Nov 01, 2021 at 09:43:27PM -0400, James Bottomley wrote:
> On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
> > For fixing queue quiesce race between driver and block layer(elevator
> > switch, update nr_requests, ...), we need to support concurrent
> > quiesce
> > and unquiesce, which requires the two call balanced.
> > 
> > It isn't easy to audit that in all scsi drivers, especially the two
> > may
> > be called from different contexts, so do it in scsi core with one
> > per-device
> > bit flag & global spinlock, basically zero cost since request queue
> > quiesce
> > is seldom triggered.
> > 
> > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
> > quiesce/unquiesce")
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++----
> > ----
> >  include/scsi/scsi_device.h |  1 +
> >  2 files changed, 37 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 51fcd46be265..414f4daf8005 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -2638,6 +2638,40 @@ static int
> > __scsi_internal_device_block_nowait(struct scsi_device *sdev)
> >  	return 0;
> >  }
> >  
> > +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
> > +
> > +void scsi_start_queue(struct scsi_device *sdev)
> > +{
> > +	bool need_start;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
> > +	need_start = sdev->queue_stopped;
> > +	sdev->queue_stopped = 0;
> > +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
> > +
> > +	if (need_start)
> > +		blk_mq_unquiesce_queue(sdev->request_queue);
> 
> Well, this is a classic atomic pattern:
> 
> if (cmpxchg(&sdev->queue_stopped, 1, 0))
> 	blk_mq_unquiesce_queue(sdev->request_queue);
> 
> The reason to do it with atomics rather than spinlocks is
> 
>    1. no need to disable interrupts: atomics are locked
>    2. faster because a spinlock takes an exclusive line every time but the
>       read to check the value can be in shared mode in cmpxchg
>    3. it's just shorter and better code.

You are right, I agree.

> 
> The only minor downside is queue_stopped now needs to be a u32.

Yeah, that is the reason I don't take this atomic way since it needs to
add one extra u32 into 'struct scsi_device'.


Thanks,
Ming

