From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] block: set req->timeout in blk_add_timer
Date: Sat, 06 Sep 2008 08:10:20 -0500
Message-ID: <1220706621.3430.1.camel@localhost.localdomain>
References: <1220680240-27724-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44432 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbYIFNKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Sep 2008 09:10:23 -0400
In-Reply-To: <1220680240-27724-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, Mike Christie <mchristi@redhat.com>

On Sat, 2008-09-06 at 00:50 -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> To prevent a reques from running forever, scsi-ml checks if
> a command has been running req->timeout * cmd->allowed + 1 seconds.
> If it has, scsi-ml will fail the request. From what I can tell
> it looks like in Jen's tree that the block layer is not setting
> this value, so a command is failed right away a lot of times because
> wait_for in scsi_softirq_done is zero seconds. It is only set by ioctls
> and passthrough.
> 
> This patch just copies the q timeout that is used, so any one
> checking it will still be able to see it.
> 
> For the scsi-ml req->timeout usage, I think we can move the retries and
> the infinite retry check from the scsi layer to the block layer. I was
> not sure if we should do that in this patch or a separate one. I can
> cook up another patch if people want. If it would be possible to do
> that after MikeA's patches it would probably be best though since
> he is working on that code too.

Sure, basically move all responsibility for retries to block.  That will
require a few other things like abstracting scsi_decide_disposition.  I
actually had an impression from one of the storage summits that someone
was working on this.

James


