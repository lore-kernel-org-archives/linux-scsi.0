From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 0/2] blk request timeout handler: mv scsi timer code to  block layer
Date: Tue, 25 Jul 2006 11:24:01 +0200
Message-ID: <20060725092400.GK4044@suse.de>
References: <1153820377.4166.22.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:1064 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751544AbWGYJwT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 05:52:19 -0400
Content-Disposition: inline
In-Reply-To: <1153820377.4166.22.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 25 2006, Mike Christie wrote:
> For the request based multipath I thought I would need to run some code
> when a command times out. I did not want to duplicate the scsi code, so
> I did the following patches which move the scsi timer code to the block
> layer then convert scsi.
> 
> I have tested the scsi_error.c and normal paths with iscsi. And, I have
> tested the normal IO paths with libata. Since libata uses the strategy
> handler it needs to be tested a lot more. Some of the drivers that were
> touching the timeout_per_command field need to be compile tested still
> too. I converted them, but I think some still need a "#include
> blkdev.h".
> 
> The patches only move the scsi timer code to the block layer and hook it
> in so others can use it. I have not started on the abort, reset and
> quiesce code since it is not really needed for multipath. I wanted to
> see if the timer code move was ok on its own without the rest of the
> scsi eh move because I do not want to manage the patches out of tree
> with the other request multipath patches. I also wanted to check if the
> scsi timer code was ok in general. Maybe scsi got it wrong and needed to
> be rewritten :)

Excellent, one item off my TODO list :-). I had pending code, but not
completed yet.

I had intended to make the timer addition/deletion implicit from the
activate/deactive rq paths, both to have it happen automatically and
from a cleanliness POV. That makes the timer only active when the
request is in the driver, and should also make the deletion implicit for
when the request gets requeued.

-- 
Jens Axboe

