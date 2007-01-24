From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] add bsg queue resize
Date: Wed, 24 Jan 2007 11:25:25 +0900 (JST)
Message-ID: <20070124111613M.fujita.tomonori@lab.ntt.co.jp>
References: <20070120232518E.fujita.tomonori@lab.ntt.co.jp>
	<20070123083403.GC5486@kernel.dk>
	<20070123152348.GD11995@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44845 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965622AbXAXCZq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 21:25:46 -0500
In-Reply-To: <20070123152348.GD11995@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] add bsg queue resize
Date: Tue, 23 Jan 2007 16:23:49 +0100

> On Tue, Jan 23 2007, Jens Axboe wrote:
> > On Sat, Jan 20 2007, FUJITA Tomonori wrote:
> > > This enables bsg to resize the queue depth via
> > > SG_SET_COMMAND_Q. bsg_command structures are allocated via mempool
> > > because the previous way to use contiguous memory makes it difficult
> > > to resize the queue depth when a bsg_device has outstanding commands.
> > 
> > Overall the patch looks fine. I don't think we need a mempool though,
> > and allocations could just use GFP_USER from the user invoked queuing
> > paths. Just make it GFP_USER, we can always extend the
> > bsg_alloc_command() to take a gfp_t argument as well If you get rid of
> > the mempool, then resizing is simply just adjusting bd->max_queue.
> 
> Like so.

Thanks. I thought that pre-allocating bsg_command structures would be
nice. But it doesn't matter much for me.

One minor comment is that we could simplify __bsg_alloc_command
failpath a bit?

---
>From 6cebe0e87adc90ba50067f017c52a233fb9262d6 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 24 Jan 2007 11:08:47 +0900
Subject: [PATCH] bsg: simplify __bsg_alloc_command failpath

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index e97e3ec..c85d961 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -128,7 +128,8 @@ static struct bsg_command *__bsg_alloc_command(struct bsg_device *bd)
 	bc = kmem_cache_alloc(bsg_cmd_cachep, GFP_USER);
 	if (unlikely(!bc)) {
 		spin_lock_irq(&bd->lock);
-		goto alloc_fail;
+		bd->queued_cmds--;
+		goto out;
 	}
 
 	memset(bc, 0, sizeof(*bc));
@@ -136,8 +137,6 @@ static struct bsg_command *__bsg_alloc_command(struct bsg_device *bd)
 	INIT_LIST_HEAD(&bc->list);
 	dprintk("%s: returning free cmd %p\n", bd->name, bc);
 	return bc;
-alloc_fail:
-	bd->queued_cmds--;
 out:
 	spin_unlock_irq(&bd->lock);
 	return bc;
-- 
1.4.4.3



