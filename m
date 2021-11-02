Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F780C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED79C60C4B
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhKBOuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:50:32 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:52658 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232283AbhKBOua (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 10:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635864475;
        bh=bdqpZX1jdEKlc2UZvw2bcuamssk0aFT388eI95SAPV0=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=xlTdgKcicov7JBP9ACg4fmoXC4n9KLsI6CCjD+xdgMv4XlVdX+c5pNz2c8QxX55Ab
         tdx+lLoHDU7JLJqOnA+uCOGLKSIhzVA2fYkRt7xRZXSzea6k0gGu/9nANHzxejGM1H
         ZaBzdOzFm4rzyB7nuNtSxlTOK1JqzNLeUgUHtBNc=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C205A128065E;
        Tue,  2 Nov 2021 10:47:55 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id H6rrzm6rGiUZ; Tue,  2 Nov 2021 10:47:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635864475;
        bh=bdqpZX1jdEKlc2UZvw2bcuamssk0aFT388eI95SAPV0=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=xlTdgKcicov7JBP9ACg4fmoXC4n9KLsI6CCjD+xdgMv4XlVdX+c5pNz2c8QxX55Ab
         tdx+lLoHDU7JLJqOnA+uCOGLKSIhzVA2fYkRt7xRZXSzea6k0gGu/9nANHzxejGM1H
         ZaBzdOzFm4rzyB7nuNtSxlTOK1JqzNLeUgUHtBNc=
Received: from jarvis.int.hansenpartnership.com (c-67-166-174-65.hsd1.va.comcast.net [67.166.174.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DBDF81280129;
        Tue,  2 Nov 2021 10:47:54 -0400 (EDT)
Message-ID: <461ac99c7d9d4493f37d2b8377ec3f05ce8a2735.camel@HansenPartnership.com>
Subject: Re: [PATCH 2/3] scsi: make sure that request queue queiesce and
 unquiesce balanced
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com
Date:   Tue, 02 Nov 2021 10:47:53 -0400
In-Reply-To: <042056b5-6fea-1bcf-bfae-274f23e9e5c5@kernel.dk>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
         <20211021145918.2691762-3-ming.lei@redhat.com>
         <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
         <8cbc1be6-15a5-ed34-53f1-081a05025d34@kernel.dk>
         <a7bae1c4c3d6b08487b96cb3aa86d4fab1a0abcc.camel@HansenPartnership.com>
         <1ab71603-0104-2071-02c9-d6c22e3aa275@kernel.dk>
         <042056b5-6fea-1bcf-bfae-274f23e9e5c5@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-11-02 at 08:41 -0600, Jens Axboe wrote:
> On 11/2/21 8:36 AM, Jens Axboe wrote:
> > On 11/2/21 8:33 AM, James Bottomley wrote:
> > > On Tue, 2021-11-02 at 06:59 -0600, Jens Axboe wrote:
> > > > On 11/1/21 7:43 PM, James Bottomley wrote:
> > > > > On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
> > > > > > For fixing queue quiesce race between driver and block
> > > > > > layer(elevator switch, update nr_requests, ...), we need to
> > > > > > support concurrent quiesce and unquiesce, which requires
> > > > > > the two
> > > > > > call balanced.
> > > > > > 
> > > > > > It isn't easy to audit that in all scsi drivers, especially
> > > > > > the two may be called from different contexts, so do it in
> > > > > > scsi core with one per-device bit flag & global spinlock,
> > > > > > basically zero cost since request queue quiesce is seldom
> > > > > > triggered.
> > > > > > 
> > > > > > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > > > > > Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
> > > > > > quiesce/unquiesce")
> > > > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > > > ---
> > > > > >  drivers/scsi/scsi_lib.c    | 45
> > > > > > ++++++++++++++++++++++++++++++
> > > > > > ----
> > > > > > ----
> > > > > >  include/scsi/scsi_device.h |  1 +
> > > > > >  2 files changed, 37 insertions(+), 9 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/scsi/scsi_lib.c
> > > > > > b/drivers/scsi/scsi_lib.c
> > > > > > index 51fcd46be265..414f4daf8005 100644
> > > > > > --- a/drivers/scsi/scsi_lib.c
> > > > > > +++ b/drivers/scsi/scsi_lib.c
> > > > > > @@ -2638,6 +2638,40 @@ static int
> > > > > > __scsi_internal_device_block_nowait(struct scsi_device
> > > > > > *sdev)
> > > > > >  	return 0;
> > > > > >  }
> > > > > >  
> > > > > > +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
> > > > > > +
> > > > > > +void scsi_start_queue(struct scsi_device *sdev)
> > > > > > +{
> > > > > > +	bool need_start;
> > > > > > +	unsigned long flags;
> > > > > > +
> > > > > > +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
> > > > > > +	need_start = sdev->queue_stopped;
> > > > > > +	sdev->queue_stopped = 0;
> > > > > > +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
> > > > > > +
> > > > > > +	if (need_start)
> > > > > > +		blk_mq_unquiesce_queue(sdev->request_queue);
> > > > > 
> > > > > Well, this is a classic atomic pattern:
> > > > > 
> > > > > if (cmpxchg(&sdev->queue_stopped, 1, 0))
> > > > > 	blk_mq_unquiesce_queue(sdev->request_queue);
> > > > > 
> > > > > The reason to do it with atomics rather than spinlocks is
> > > > > 
> > > > >    1. no need to disable interrupts: atomics are locked
> > > > >    2. faster because a spinlock takes an exclusive line every
> > > > > time but the
> > > > >       read to check the value can be in shared mode in
> > > > > cmpxchg
> > > > >    3. it's just shorter and better code.
> > > > > 
> > > > > The only minor downside is queue_stopped now needs to be a
> > > > > u32.
> > > > 
> > > > Are you fine with the change as-is, or do you want it redone? I
> > > > can drop the SCSI parts and just queue up the dm fix.
> > > > Personally I think it'd be better to get it fixed upfront.
> > > 
> > > Well, given the path isn't hot, I don't really care.  However,
> > > what I don't want is to have to continually bat back patches from
> > > the make work code churners trying to update this code for being
> > > the wrong pattern.  I think at the very least it needs a comment
> > > saying why we chose a suboptimal pattern to try to forestall
> > > this.
> > 
> > Right, with a comment it's probably better. And as you said, since
> > it's not a hot path, don't think we'd be revisiting it anyway.
> > 
> > I'll amend the patch with a comment.
> 
> I started adding the comment and took another look at this, and that
> made me change my mind. We really should make this a cmpxcgh, it's
> not even using a device lock here.
> 
> I've dropped the two SCSI patches for now, Ming can you resend? If
> James agrees, I really think queue_stopped should just have the type
> changed and the patch redone with that using cmpxcgh().

Well, that's what I suggested originally, so I agree ... I don't think
31 more bytes is going to be a huge burden to scsi_device.

James


