From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH resend] bsg: Fix sense buffer bug in SG_IO
Date: Tue, 3 Feb 2009 07:48:35 +0100
Message-ID: <20090203064834.GP30821@kernel.dk>
References: <20090202131502.GH30821@kernel.dk> <49872DF3.3060401@panasas.com> <20090202185345.GM30821@kernel.dk> <4987E55F.4000606@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:23181 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZBCGuc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Feb 2009 01:50:32 -0500
Content-Disposition: inline
In-Reply-To: <4987E55F.4000606@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

On Tue, Feb 03 2009, Boaz Harrosh wrote:
> 
> When submitting requests via SG_IO, which does a sync io, a
> bsg_command is not allocated. So an in-Kernel sense_buffer was not
> set. However when calling blk_execute_rq() with no sense buffer
> one is provided from the stack. Now bsg at blk_complete_sgv4_hdr_rq()
> would check if rq->sense_len and a sense was requested by sg_io_v4
> the rq->sense was copy_user() back, but by now it is already mangled
> stack memory.
> 
> I have fixed that by forcing a sense_buffer when calling bsg_map_hdr().
> The bsg_command->sense is provided in the write/read path like before,
> and on-the-stack buffer is provided when doing SG_IO.
> 
> I have also fixed a dprintk message to print rq->errors in hex because
> of the scsi bit-field use of this member. For other block devices it
> does not matter anyway.

Thanks for the resend Boaz, I'll make sure it gets upstream for 2.6.29.

-- 
Jens Axboe

