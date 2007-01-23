From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] add bsg queue resize
Date: Tue, 23 Jan 2007 09:34:03 +0100
Message-ID: <20070123083403.GC5486@kernel.dk>
References: <20070120232518E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:26582 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905AbXAWIca (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jan 2007 03:32:30 -0500
Content-Disposition: inline
In-Reply-To: <20070120232518E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Sat, Jan 20 2007, FUJITA Tomonori wrote:
> This enables bsg to resize the queue depth via
> SG_SET_COMMAND_Q. bsg_command structures are allocated via mempool
> because the previous way to use contiguous memory makes it difficult
> to resize the queue depth when a bsg_device has outstanding commands.

Overall the patch looks fine. I don't think we need a mempool though,
and allocations could just use GFP_USER from the user invoked queuing
paths. Just make it GFP_USER, we can always extend the
bsg_alloc_command() to take a gfp_t argument as well If you get rid of
the mempool, then resizing is simply just adjusting bd->max_queue.

-- 
Jens Axboe

