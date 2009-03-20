From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] WARN_ON if blk_put_request leaks BIOs
Date: Fri, 20 Mar 2009 21:45:43 +0100
Message-ID: <20090320204543.GE27476@kernel.dk>
References: <49C21C5A.6030105@panasas.com> <20090319113343.GF27476@kernel.dk> <49C272CE.1070408@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:40605 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZCTUpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2009 16:45:46 -0400
Content-Disposition: inline
In-Reply-To: <49C272CE.1070408@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>

On Thu, Mar 19 2009, Boaz Harrosh wrote:
> 
> Put a WARN_ON in __blk_put_request if it is about to
> leak bio(s). This is a serious bug that can happen in error
> handling code paths.
> 
> For this to work I have fixed a couple of places in block/ where
> request->bio != NULL ownership was not honored. And a small cleanup
> at sg_io() while at it.

Ho humm, not sure what to do about this. Honestly, in all the time that
I have been doing this, this would have found about zero bugs. And now
enforces a rule that ->bio must be cleared. Normal bio completion does
that automatically, so it's not a problem there, but it's still a new
rule just to satisfy this questionable debug mechanism.

But what the hell, it's simple enough. Kill the totally unrelated
scsi_ioctl.c change, and I'll toss it in for a spin.

-- 
Jens Axboe

