From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH 1/8] cciss: version number change
Date: Thu, 2 Nov 2006 09:17:43 -0600
Message-ID: <20061102151743.GB19352@beardog.cca.cpqcorp.net>
References: <20061101214913.GA29928@beardog.cca.cpqcorp.net> <20061102141045.GH13555@kernel.dk> <20061102144623.GC16430@beardog.cca.cpqcorp.net> <1162479914.14530.46.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:39876 "EHLO palrel13.hp.com")
	by vger.kernel.org with ESMTP id S1751333AbWKBPRo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2006 10:17:44 -0500
Content-Disposition: inline
In-Reply-To: <1162479914.14530.46.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Nov 02, 2006 at 04:05:14PM +0100, Arjan van de Ven wrote:
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

We getting hw soon that will support up to 1024 logical volumes. We thought
the test would actually save time with many volumes. Maybe not.

mikem
