From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 2.6.28-rc6] block: internal dequeue shouldn't start
	timer
Date: Mon, 1 Dec 2008 15:45:29 -0800
Message-ID: <20081201234529.GA14025@linux.vnet.ibm.com>
References: <492F6DFC.3010103@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45682 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYLAXpg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2008 18:45:36 -0500
Content-Disposition: inline
In-Reply-To: <492F6DFC.3010103@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

Tejun Heo <tj@kernel.org> wrote:
> blkdev_dequeue_request() and elv_dequeue_request() are equivalent and
> both start the timeout timer.  Barrier code dequeues the original
> barrier request but doesn't passes the request itself to lower level
> driver, only broken down proxy requests; however, as the original
> barrier code goes through the same dequeue path and timeout timer is
> started on it.  If barrier sequence takes long enough, this timer
> expires but the low level driver has no idea about this request and
> oops follows.
> 
> Timeout timer shouldn't have been started on the original barrier
> request as it never goes through actual IO.  This patch unexports
> elv_dequeue_request(), which has no external user anyway, and makes it
> operate on elevator proper w/o adding the timer and make
> blkdev_dequeue_request() call elv_dequeue_request() and add timer.
> Internal users which don't pass the request to driver - barrier code
> and end_that_request_last() - are converted to use
> elv_dequeue_request().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
> ---
> Mike, this should fix the problem you were seeing (blk_add_timer on
> requests w/o REQ_STARTED set).
> 

Yes this fixed the "w/o REQ_STARTED" error I was seeing on a distro kernel
and a mainline system. 

Thanks,

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
