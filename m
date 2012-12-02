From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 03/13] block: Avoid that request_fn is invoked on a
 dead queue
Date: Sun, 2 Dec 2012 05:23:20 -0800
Message-ID: <20121202132320.GC15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B60745.8060806@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:52274 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2LBNX1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:23:27 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so918398dak.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:23:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B60745.8060806@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On Wed, Nov 28, 2012 at 01:44:53PM +0100, Bart Van Assche wrote:
> A block driver may start cleaning up resources needed by its
> request_fn as soon as blk_cleanup_queue() finished, so request_fn
> must not be invoked after draining finished. This is important
> when blk_run_queue() is invoked without any requests in progress.
> As an example, if blk_drain_queue() and scsi_run_queue() run in
> parallel, blk_drain_queue() may have finished all requests after
> scsi_run_queue() has taken a SCSI device off the starved list but
> before that last function has had a chance to run the queue.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Chanho Min <chanho.min@lge.com>

Acked-by: Tejun Heo <tj@kernel.org>

> +inline void __blk_run_queue_uncond(struct request_queue *q)

Does this inline actually make a difference in the generated code?

Thanks.

-- 
tejun
