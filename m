From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Thu, 6 Sep 2012 11:27:10 -0500
Message-ID: <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu>
References: <5044BAD2.7060901@acm.org>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1486\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37666 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab2IFQ12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2012 12:27:28 -0400
In-Reply-To: <5044BAD2.7060901@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>


On Sep 3, 2012, at 9:12 AM, Bart Van Assche <bvanassche@acm.org> wrote:

> If the put_device() call in scsi_request_fn() drops the sdev refcount
> to zero then the spin_lock() call after the put_device() call triggers
> a use-after-free. Avoid that by making sure that blk_cleanup_queue()
> can only finish after all active scsi_request_fn() calls have returned.



If we have this patch
http://marc.info/?l=linux-scsi&m=134453905402413&w=2
it seems we have all the scsi layer callers of the request_fn/*blk_run_queue holding a reference to the device when they make the call. Right, or are there some other places missing?

What are the other places we can call the request_fn without already holding a reference to the device? Is it the block layer? Is that why we need this patch?