Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC88C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE0C6109D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhKBOhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:37:43 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:52654 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhKBOhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 10:37:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635863708;
        bh=GepXFCj3FD9UKvVx+XVX09HMyEexOztb+lEVH3hh9SM=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=HJZpHkFVvtfwQ+ZPjZ0W0/TXFaLEyNHU9DV6afPBmNuUrYvY4Gh56xtbin3+ErqW6
         yKwgZ6aW8/rmsfnAx8p78zv8F8TvhT4DVPrSZm2fD4Zj0qyjroLs/rgSBqMnvcoM0x
         8QjZu5eg1jzD33LSVzrgSpc4RTGcTT4On9dkyNEc=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 115CA128100E;
        Tue,  2 Nov 2021 10:35:08 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RlsXLsslvKUA; Tue,  2 Nov 2021 10:35:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635863707;
        bh=GepXFCj3FD9UKvVx+XVX09HMyEexOztb+lEVH3hh9SM=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=i+cEFsCY21LDuBubzUv+FBjJPqaOa+Vnmh7qFCaKNO/rny4lpo5+YvUO3hD0l9NRH
         tKLYklh+54oYMhGWaM+FEVRYpXxmm/1AmdECRbIwmdDLjVYDerB9InkegzO71Dj21a
         FgMlhwIQIxYo4hb85+IY9lnS1f4Hq+RblE4/qqdQ=
Received: from jarvis.int.hansenpartnership.com (c-67-166-174-65.hsd1.va.comcast.net [67.166.174.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2813B128100B;
        Tue,  2 Nov 2021 10:35:07 -0400 (EDT)
Message-ID: <a7bae1c4c3d6b08487b96cb3aa86d4fab1a0abcc.camel@HansenPartnership.com>
Subject: Re: [PATCH 2/3] scsi: make sure that request queue queiesce and
 unquiesce balanced
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com
Date:   Tue, 02 Nov 2021 10:33:35 -0400
In-Reply-To: <8cbc1be6-15a5-ed34-53f1-081a05025d34@kernel.dk>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
         <20211021145918.2691762-3-ming.lei@redhat.com>
         <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
         <8cbc1be6-15a5-ed34-53f1-081a05025d34@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-11-02 at 06:59 -0600, Jens Axboe wrote:
> On 11/1/21 7:43 PM, James Bottomley wrote:
> > On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
> > > For fixing queue quiesce race between driver and block
> > > layer(elevator switch, update nr_requests, ...), we need to
> > > support concurrent quiesce and unquiesce, which requires the two
> > > call balanced.
> > > 
> > > It isn't easy to audit that in all scsi drivers, especially the
> > > two may be called from different contexts, so do it in scsi core
> > > with one per-device bit flag & global spinlock, basically zero
> > > cost since request queue quiesce is seldom triggered.
> > > 
> > > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > > Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
> > > quiesce/unquiesce")
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++
> > > ----
> > > ----
> > >  include/scsi/scsi_device.h |  1 +
> > >  2 files changed, 37 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 51fcd46be265..414f4daf8005 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -2638,6 +2638,40 @@ static int
> > > __scsi_internal_device_block_nowait(struct scsi_device *sdev)
> > >  	return 0;
> > >  }
> > >  
> > > +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
> > > +
> > > +void scsi_start_queue(struct scsi_device *sdev)
> > > +{
> > > +	bool need_start;
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
> > > +	need_start = sdev->queue_stopped;
> > > +	sdev->queue_stopped = 0;
> > > +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
> > > +
> > > +	if (need_start)
> > > +		blk_mq_unquiesce_queue(sdev->request_queue);
> > 
> > Well, this is a classic atomic pattern:
> > 
> > if (cmpxchg(&sdev->queue_stopped, 1, 0))
> > 	blk_mq_unquiesce_queue(sdev->request_queue);
> > 
> > The reason to do it with atomics rather than spinlocks is
> > 
> >    1. no need to disable interrupts: atomics are locked
> >    2. faster because a spinlock takes an exclusive line every time
> > but the
> >       read to check the value can be in shared mode in cmpxchg
> >    3. it's just shorter and better code.
> > 
> > The only minor downside is queue_stopped now needs to be a u32.
> 
> Are you fine with the change as-is, or do you want it redone? I
> can drop the SCSI parts and just queue up the dm fix. Personally
> I think it'd be better to get it fixed upfront.

Well, given the path isn't hot, I don't really care.  However, what I
don't want is to have to continually bat back patches from the make
work code churners trying to update this code for being the wrong
pattern.  I think at the very least it needs a comment saying why we
chose a suboptimal pattern to try to forestall this.

James


