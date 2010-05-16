From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/8] buffer: make invalidate_bdev() drain all percpu
 LRU add caches
Date: Sun, 16 May 2010 00:11:16 -0700 (PDT)
Message-ID: <20100516.001116.216765419.davem@davemloft.net>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-2-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:27 +0200

> invalidate_bdev() should release all page cache pages which are clean
> and not being used; however, if some pages are still in the percpu LRU
> add caches on other cpus, those pages are considered in used and don't
> get released.  Fix it by calling lru_add_drain_all() before trying to
> invalidate pages.
> 
> This problem was discovered while testing block automatic native
> capacity unlocking.  Null pages which were read before automatic
> unlocking didn't get released by invalidate_bdev() and ended up
> interfering with partition scan after unlocking.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
