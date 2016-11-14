From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH] hpsa: scsi-mq support
Date: Mon, 14 Nov 2016 16:35:04 +0530
Message-ID: <6105636cc4a0ef42d47eb426d91634dd@mail.gmail.com>
References: <1478879194-32529-1-git-send-email-hare@suse.de>
 <20161111163532.GA14922@infradead.org> <39d1198d-eb49-71ed-9139-f0efd9eefd0d@suse.com>
 <20161112173223.GA22158@infradead.org> <cba051f8-3055-53c4-2860-ee4c51a7043d@suse.com>
 <20161113115841.GA4818@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35668 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932970AbcKNLFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 06:05:07 -0500
Received: by mail-qk0-f169.google.com with SMTP id n204so90830254qke.2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2016 03:05:07 -0800 (PST)
In-Reply-To: <20161113115841.GA4818@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Sunday, November 13, 2016 5:29 PM
> To: Hannes Reinecke
> Cc: Christoph Hellwig; Hannes Reinecke; Christoph Hellwig; Martin K.
Petersen;
> James Bottomley; Don Brace; linux-scsi@vger.kernel.org; Jens Axboe
> Subject: Re: [PATCH] hpsa: scsi-mq support
>
> On Sun, Nov 13, 2016 at 10:44:47AM +0100, Hannes Reinecke wrote:
> > One day to mark with bright red in the calendar.
> >
> > Christoph Hellwig is telling me _NOT_ to use scsi-mq.
>
> That's not what I'm doing.
>
> > This patch was done so see what would needed to be done to convert a
> > legacy driver.
> > As I was under the impression that scsi-mq is the way forward, seeing
> > that it should be enabled per default.
> > But I must have been mistaken. Apparently.
>
> What I am doing is to tell you you should not expose multiple queues
unless the
> hardware actually has multiple submissions queues.  The blk-mq and
scsi-mq
> code works just fine with a single submission queue, and the hpsa driver
in
> particular works really well with scsi-mq and a single submission queue.
E.g. the
> RAID HBA on slide 19 of this presentations is an hpsa one:

I have similar results for MegaRaid where seen MR driver gives significant
improvement for Single Submission Queue and multiple Completion Queue.
Having said that scsi-mq is enabled but with single Queue is more than
enough to maximize improvement of SCSI-MQ.

Major advantage was seen while IO load is cross the boundary of Physical
CPU socket.

>From this discussion I understood that - Similar logical changes proposed
for megaraid_sas  and we are not really going to gain with fake multiple
submission exposed to SML.

Kashyap

>
> http://events.linuxfoundation.org/sites/events/files/slides/scsi.pdf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of
> a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
