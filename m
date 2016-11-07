From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PREEMPT-RT] [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Mon, 7 Nov 2016 17:38:48 +0100
Message-ID: <20161107163848.GA1421@lst.de>
References: <20160817101003.30055-1-bigeasy@linutronix.de> <20161107161901.GA12297@infradead.org> <alpine.DEB.2.20.1611071729030.3709@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57910 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753123AbcKGQiu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 11:38:50 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1611071729030.3709@nanos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@infradead.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>

On Mon, Nov 07, 2016 at 05:31:03PM +0100, Thomas Gleixner wrote:
> On Mon, 7 Nov 2016, Christoph Hellwig wrote:
> 
> > It seems like the whole damn driver should just use threaded interrupts.
> > Of course it's a giant beast and not just the iSCSI one.  But even
> > if we don't go all the way I'd much prefer workqueues.  kthread work
> > is simply the worst API ever and I'd prefer to not have it proliferate.
> 
> That's what the patch is doing. It uses INIT_WORK() and
> schedule_work[_on](). I can't find any reference to kthread work.

You're right it does - between the incorrect subject and the fact
that it still keeps the linked list of items arounds instead of fully
using the workqueue infrastructure I was a bit confused before my
first coffee this morning.  Same applies to patch 2.
