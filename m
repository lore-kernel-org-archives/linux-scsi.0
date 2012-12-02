From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 05/13] block: Make blk_cleanup_queue() wait until
 request_fn finished
Date: Sun, 2 Dec 2012 05:28:07 -0800
Message-ID: <20121202132807.GE15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B607B5.7020808@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39536 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2LBN2N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:28:13 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1327006pad.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:28:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B607B5.7020808@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On Wed, Nov 28, 2012 at 01:46:45PM +0100, Bart Van Assche wrote:
> Some request_fn implementations, e.g. scsi_request_fn(), unlock
> the queue lock internally. This may result in multiple threads
> executing request_fn for the same queue simultaneously. Keep
> track of the number of active request_fn calls and make sure that
> blk_cleanup_queue() waits until all active request_fn invocations
> have finished. A block driver may start cleaning up resources
> needed by its request_fn as soon as blk_cleanup_queue() finished,
> so blk_cleanup_queue() must wait for all outstanding request_fn
> invocations to finish.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Reported-by: Chanho Min <chanho.min@lge.com>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
