From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: call idr_pre_get() outside the lock.
Date: Sat, 18 Sep 2010 12:40:14 +0900
Message-ID: <20100918123721B.fujita.tomonori@lab.ntt.co.jp>
References: <m2eidda6bq.fsf@elisp.net>
	<20100916163735.ed8dbb51.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38957 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab0IRDkv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 23:40:51 -0400
In-Reply-To: <20100916163735.ed8dbb51.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: naota@elisp.net, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, axboe@kernel.dk, jkosina@suse.cz, gregkh@suse.de, daniel@caiaq.de, linux-scsi@vger.kernel.org

On Thu, 16 Sep 2010 16:37:35 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 01 Sep 2010 23:26:01 +0900
> Naohiro Aota <naota@elisp.net> wrote:
> 
> > The idr_pre_get() kernel-doc says "This function should be called
> > prior to locking and calling the idr_get_new* functions.", but the
> > idr_pre_get() calling in bsg_register_queue() is put inside
> > mutex_lock(). Let's fix it.
> > 
> 
> The idr_pre_get() kerneldoc is wrong.  Or at least, misleading.

Ah, thanks a lot. As usual, seems that there are few reliable
documents in kernel.


> The way this all works is that we precharge the tree via idr_pre_get()
> and we do this outside locks so we can use GFP_KERNEL.  Then we take
> the lock (a spinlock!) and then try to add an element to the tree,
> which will consume objects from the pool which was prefilled by
> idr_pre_get().
> 
> There's an obvious race here where someone else can get in and steal
> objects from the prefilled pool.  We can fix that with a retry loop:
> 
> 
> again:
> 	if (idr_pre_get(..., GFP_KERNEL) == NULL)
> 		return -ENOMEM;		/* We're really out-of-memory */
> 	spin_lock(lock);
> 	if (idr_get_new(...) == -EAGAIN) {
> 		spin_unlock(lock);
> 		goto again;		/* Someone stole our preallocation! */
> 	}
> 	...
> 
> this way we avoid the false -ENOMEM which the race would have caused. 
> We only declare -ENOMEM when we're REALLY out of memory.

Looks like there are many misuses idr_pre_get and idr_get_new; some
even calls idr_get_new without any lock (e.g. blk_alloc_devt).
