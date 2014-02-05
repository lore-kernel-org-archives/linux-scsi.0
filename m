From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/17] SCSI data path micro-optimizations
Date: Wed, 05 Feb 2014 15:41:04 -0800
Message-ID: <1391643664.2213.59.camel@dabdike.int.hansenpartnership.com>
References: <20140205123930.150608699@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46377 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbaBEXlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 18:41:07 -0500
In-Reply-To: <20140205123930.150608699@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, 2014-02-05 at 04:39 -0800, Christoph Hellwig wrote:
> This series contains various optimizations for the SCSI data I/O path.
> They increase the number of IOPS seen with iSCSI or SRP between 2%
> and 3.5% in workloads that previously hit the host_lock hard.  While this
> isn't a lot it now fully shifts the contention to the queue_lock, which
> will get out of the way later when the SCSI midlayer is converted to
> use the blk-mq infrastructure.

I will say that you do make the series hard to review by including
things that do code churn for no gain: like making all the error
handling goto based instead of the current in-place if () clause
based ... this doesn't do anything for optmisation, so why do it?  (I'm
not going to take sides on which is better, since we do both).

There's also a lot of extraneous stuff in here.  I'm assuming most of
the performance stuff is get/put removal and locking efficiency, things
like this

1 looks like a lost pm error path, that should go (separately from the
series) for review to the pm people (Alan Stern).

2,3,5 are allocation simplification.  In general it doesn't look so bad,
but it doesn't seem to be part of the series.  It needs an ACK from the
megaraid people since they're the only consumer of the interface you're
trying to eliminate

6,7 is a new interface for command allocation and a virtio consumer.
OK, as it goes, but also separable ... and preferably, if, as you say,
it's important for mq, some more users, also doesn't need to be part of
the series.

Some other procedural issues:

9,10 look like they aren't your patches, so they need an Author From:
field for git (9 needs your signoff, if you're sending it).

9,10,11 have uninformative titles.  Say what you're doing, which is
removing a get/put_device

James


