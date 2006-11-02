From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/8] cciss: version number change
Date: Thu, 2 Nov 2006 16:45:52 +0100
Message-ID: <20061102154552.GO13555@kernel.dk>
References: <20061101214913.GA29928@beardog.cca.cpqcorp.net> <20061102141045.GH13555@kernel.dk> <20061102144623.GC16430@beardog.cca.cpqcorp.net> <1162479914.14530.46.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:41486 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1751408AbWKBPoC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2006 10:44:02 -0500
Content-Disposition: inline
In-Reply-To: <1162479914.14530.46.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Nov 02 2006, Arjan van de Ven wrote:
> On Thu, 2006-11-02 at 08:46 -0600, Mike Miller (OS Dev) wrote:
> > On Thu, Nov 02, 2006 at 03:10:45PM +0100, Jens Axboe wrote:
> > > On Wed, Nov 01 2006, Mike Miller (OS Dev) wrote:
> > > > 
> > > > PATCH 1/8
> > > > 
> > > > This patch changes the cciss version number to 3.6.14 to reflect the following
> > > > functionality changes added by the rest of the set. They include:
> > > 
> > > Mike, only some of your patches appeared to go out, both in personal
> > > mail and on the list.
> > 
> > I ran into some last minute issues so I stopped at 5. Still re-testing
> > the others.
> > This snippet seems to tbe the culprit.
> > +               if (blk_queue_stopped(h->gendisk[curr_queue]->queue) ||
> > +                   blk_queue_plugged(h->gendisk[curr_queue]->queue))
> > +                       blk_start_queue(h->gendisk[curr_queue]->queue);
> > 
> > We're testing to see if the queue is stopped or plugged so we don't
> > try to start am already running queue. Without the blk_queue_plugged
> > test it hangs every time. We added blk_queue_plugged and the first tests
> > seem to run ok. Then at the last minute something broke. Does this look
> > ok to you?
> 
> 
> it looks like a design mistake to me if a device driver needs to care
> about a queue being plugged at all....

The queue can't be plugged and stopped at the same time anyway, so the
code is confusing. But yes I agree, that should go.

-- 
Jens Axboe

