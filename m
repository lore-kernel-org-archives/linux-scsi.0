From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/14] scsi: add support for a blk-mq based I/O path.
Date: Wed, 16 Jul 2014 13:16:02 +0200
Message-ID: <20140716111602.GA20623@lst.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-14-git-send-email-hch@lst.de> <53C65E51.3090003@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53C65E51.3090003@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2014 at 06:13:21AM -0500, Mike Christie wrote:
> I see the request timer is started before calling queue_rq, but I could
> not figure out what the cancel_delayed_work here is for exactly. It
> seems if the request were to time out and the eh started while queue_rq
> was running we could end up some nasty bugs like the requested requeued
> twice.
> 
> Is the cancel_delayed_work call just to be safe or is supposed to be
> handling a case where the abort_work could be queued at this time up due
> to a request timing out while queue_rq is running? Is this case mq specific?

It was cargo cult copy & paste from the old path.  I've merged a patch
from Bart to remove it from the old code, so it should go away here as well,
thanks for the reminder.
