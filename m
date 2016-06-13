From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Mon, 13 Jun 2016 01:07:20 -0700
Message-ID: <20160613080720.GA10214@infradead.org>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com>
 <yq160tgfoqr.fsf@sermon.lab.mkp.net>
 <575BE182.5010304@suse.de>
 <yq11t44f0hi.fsf@sermon.lab.mkp.net>
 <575C0DAE.7070502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842AbcFMIHY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2016 04:07:24 -0400
Content-Disposition: inline
In-Reply-To: <575C0DAE.7070502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu

On Sat, Jun 11, 2016 at 03:10:06PM +0200, Hannes Reinecke wrote:
> Well, the primary issue is that 'blk_cloned_rq_check_limits()' doesn't check
> for BLOCK_PC, so this particular check would be applied for every request.

So fix it..

> But as it turns out, even adding a check for BLOCK_PC doesn't help, so we're
> indeed seeing REQ_TYPE_FS requests with larger max_sector counts.
> 
> As to _why_ this happens I frankly have no idea. I have been staring at this
> particular code for over a year now (I've got another bug pending where we
> hit the _other_ if clause), but to no avail.
> So I've resolved to drop the check altogether, seeing that max_sector size
> is _not_ something which gets changed during failover.
> Therefore if the max_sector count is wrong for the cloned request it was
> already wrong for the original request, and we should've errored it out far
> earlier.
> The max_segments count, OTOH, _might_ change during failover (different
> hardware has different max_segments setting, and this is being changed
> during sg mapping), so there is some value to be had from testing it here.

I really think we need to drill down and figure out what's going on here
first.
