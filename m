From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Mon, 19 Mar 2012 10:04:35 -0700
Message-ID: <20120319170435.GH11069@google.com>
References: <4F65E09D.6010600@acm.org>
 <20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F663BE3.4000503@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55297 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162083Ab2CSREk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2012 13:04:40 -0400
Received: by dajr28 with SMTP id r28so10142983daj.19
        for <linux-scsi@vger.kernel.org>; Mon, 19 Mar 2012 10:04:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4F663BE3.4000503@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hello,

On Sun, Mar 18, 2012 at 07:47:47PM +0000, Bart Van Assche wrote:
> Not servicing queued SCSI requests can e.g. cause user space processes
> to hang. See also http://lkml.org/lkml/2011/8/27/6 for an example. Hence
> commit 3308511c93e6ad0d3c58984ecd6e5e57f96b12c8 which causes pending
> SCSI commands to be killed just before blk_cleanup_queue() is invoked.
> However,

Thanks for the pointer.  It would be great if you can describe / link
the actual case the patch is trying to solve.

> there is still a tiny race window left by that patch - new
> requests can get queued after the SCSI request function has been invoked
> by scsi_free_queue() and before blk_cleanup_queue() gets invoked. Hence
> the proposal to change the block layer to make sure that all queued
> requests get processed eventually.

I don't think it's a good idea to push requests out to stopped queue.
Wouldn't aborting all pending requests be better?

Thanks.

-- 
tejun
