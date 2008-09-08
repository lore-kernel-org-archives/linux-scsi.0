From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/1] block: set req->timeout in blk_add_timer
Date: Mon, 8 Sep 2008 09:38:41 +0200
Message-ID: <20080908073839.GD20055@kernel.dk>
References: <1220680240-27724-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:59053 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYIHHin (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2008 03:38:43 -0400
Content-Disposition: inline
In-Reply-To: <1220680240-27724-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>

On Sat, Sep 06 2008, michaelc@cs.wisc.edu wrote:
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
> 
> This patch was made over James's scsi post tree.

Thanks Mike, I'll merge it into the original patch.

-- 
Jens Axboe

