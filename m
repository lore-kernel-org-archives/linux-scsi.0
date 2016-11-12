From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] hpsa: scsi-mq support
Date: Sat, 12 Nov 2016 09:32:23 -0800
Message-ID: <20161112173223.GA22158@infradead.org>
References: <1478879194-32529-1-git-send-email-hare@suse.de>
 <20161111163532.GA14922@infradead.org>
 <39d1198d-eb49-71ed-9139-f0efd9eefd0d@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50827 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966584AbcKLRcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2016 12:32:31 -0500
Content-Disposition: inline
In-Reply-To: <39d1198d-eb49-71ed-9139-f0efd9eefd0d@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Fri, Nov 11, 2016 at 07:22:05PM +0100, Hannes Reinecke wrote:
> Well, it's the same as with megasas and mpt3sas. Each of those have
> a single MMIO register where the driver writes the address of the
> command into. What exactly the hardware does in the back doesn't
> really matter here; the command is in memory and the hardware can
> access it as it sees fit. So from that point of view we can assume
> having a submission queue to match the completion queue;
> With that setup we do have a contention point on the single command
> register, but that's about it.
> We still should benefit from scsi-mq, though.

How do we benefit from scsi-mq in this case?  We still hit global
cachelines like commands_outstanding in the driver, and we lost the
batching done by the ctx -> hw_ctx layering for the single queue
blk-mq case.  We also get much less efficient merging and will not
have the chance of having and I/O schedule in the near future.

But back to my question from the last mail:  What workload is improved
by using this patch?
