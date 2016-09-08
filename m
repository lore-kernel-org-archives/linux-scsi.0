From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Thu, 8 Sep 2016 14:39:43 +0200
Message-ID: <20160908123943.f7n3lurs7ovs5pup@c203.arch.suse.de>
References: <20160817101003.30055-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51837 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754493AbcIHMjp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Sep 2016 08:39:45 -0400
Content-Disposition: inline
In-Reply-To: <20160817101003.30055-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>

On Wed, Aug 17, 2016 at 12:09:59PM +0200, Sebastian Andrzej Siewior wrote:
> The driver creates its own per-CPU threads which are updated based on CPU
> hotplug events. It is also possible to use kworkers and remove some of the
> infrastructure get the same job done while saving a few lines of code.
> 
> The DECLARE_PER_CPU() definition is moved into the header file where it
> belongs. bnx2i_percpu_io_thread() becomes bnx2i_percpu_io_work() which is
> mostly the same code. The outer loop (kthread_should_stop()) gets removed and
> the remaining code is shifted to the left.
> bnx2i_queue_scsi_cmd_resp() is mostly the same. The code checked ->iothread to
> decide if there is an active per-CPU thread. With the kworkers this is no
> longer possible nor required.
> The allocation of struct bnx2i_work does not happen with ->p_work_lock held
> which is not required. I am unsure about the call-stack so I can't say
> if this qualifies it for the allocation with GFP_KERNEL instead of
> GFP_ATOMIC (it is not _bh lock but as I said, I don't know the context).
> The allocation case has been reversed so the inner if case is called on
> !bnx2i_work and is just the invocation one function since the lock is not
> held during allocation. The init of the new bnx2i_work struct is now
> done also without the ->p_work_lock held: it is a new object, nobody
> knows about it yet. It should be enough to hold the lock while adding
> this item to the list. I am unsure about that atomic_inc() so I keep
> things as they were.
> 
> The remaining part is the removal CPU hotplug notifier since it is taken
> care by the kworker code.
> 
> This patch was only compile-tested due to -ENODEV.
> 
> Cc: QLogic-Storage-Upstream@qlogic.com
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I'm sorry it took so long but for the whole series:
Tested-by: Johannes Thumshirn <jth@kernel.org>
Acked-by: Johannes Thumshirn <jth@kernel.org>

Testing was conducted by booting from a QLogic BCM57840 CNA.

	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
