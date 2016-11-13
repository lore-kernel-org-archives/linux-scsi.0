From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] hpsa: scsi-mq support
Date: Sun, 13 Nov 2016 12:58:41 +0100
Message-ID: <20161113115841.GA4818@lst.de>
References: <1478879194-32529-1-git-send-email-hare@suse.de> <20161111163532.GA14922@infradead.org> <39d1198d-eb49-71ed-9139-f0efd9eefd0d@suse.com> <20161112173223.GA22158@infradead.org> <cba051f8-3055-53c4-2860-ee4c51a7043d@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37872 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933584AbcKML6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 13 Nov 2016 06:58:43 -0500
Content-Disposition: inline
In-Reply-To: <cba051f8-3055-53c4-2860-ee4c51a7043d@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Sun, Nov 13, 2016 at 10:44:47AM +0100, Hannes Reinecke wrote:
> One day to mark with bright red in the calendar.
>
> Christoph Hellwig is telling me _NOT_ to use scsi-mq.

That's not what I'm doing.

> This patch was done so see what would needed to be done to convert a legacy 
> driver.
> As I was under the impression that scsi-mq is the way forward, seeing that 
> it should be enabled per default.
> But I must have been mistaken. Apparently.

What I am doing is to tell you you should not expose multiple queues
unless the hardware actually has multiple submissions queues.  The blk-mq
and scsi-mq code works just fine with a single submission queue, and
the hpsa driver in particular works really well with scsi-mq and a single
submission queue.  E.g. the RAID HBA on slide 19 of this presentations is
an hpsa one:

http://events.linuxfoundation.org/sites/events/files/slides/scsi.pdf
