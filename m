From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] remove blk_queue_activity_fn
Date: Tue, 5 Dec 2006 10:17:06 +0100
Message-ID: <20061205091705.GR4392@kernel.dk>
References: <45753738.3030607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:26385 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968104AbWLEJQW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Dec 2006 04:16:22 -0500
Content-Disposition: inline
In-Reply-To: <45753738.3030607@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Tue, Dec 05 2006, Boaz Harrosh wrote:
> While working on bidi support at struct request level
> I have found that blk_queue_activity_fn is actually never used.
> The only user is in ide-probe.c with this code:
> 
> 	/* enable led activity for disk drives only */
> 	if (drive->media == ide_disk && hwif->led_act)
> 		blk_queue_activity_fn(q, hwif->led_act, drive);
> 
> And led_act is never initialized anywhere.
> (Looking back at older kernels it was used in the PPC arch, but was removed around 2.6.18)
> Unless it is all for future use off course.
> (this patch is against linux-2.6-block.git as off 2006/12/4)

I didn't notice it had been removed from pmac in 2.6.18, since that is
the case we can kill it. Thanks, I've queued the patch for inclusion.

-- 
Jens Axboe

