From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PREEMPT-RT] [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Mon, 7 Nov 2016 20:10:25 +0100
Message-ID: <20161107191025.GA5357@lst.de>
References: <20160817101003.30055-1-bigeasy@linutronix.de> <20161107161901.GA12297@infradead.org> <alpine.DEB.2.20.1611071729030.3709@nanos> <20161107163848.GA1421@lst.de> <20161107164628.jrft3ovlp5myfvs5@linutronix.de> <20161107164846.GA1966@lst.de> <20161107170420.gc6jhsewglgkfsdi@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59508 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932997AbcKGTK1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 14:10:27 -0500
Content-Disposition: inline
In-Reply-To: <20161107170420.gc6jhsewglgkfsdi@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>

On Mon, Nov 07, 2016 at 06:04:21PM +0100, Sebastian Andrzej Siewior wrote:
> So we keep things as they are right now or are we getting also rid of
> the internal list? This was tested by Johannes and Chad (claimed to do
> testing)

IFF the patches actually are tested as-is let's get them in.  I don't
think they are how we want the code to like in the long run, though.

> 
> Not sure what the last point is about.

It's about bnx2i and bnx2fc being clients of the main cnix driver,
which does the actual interrupt handling.  It seems we should actually
offloading things to a workqueue or threaded interrupts in that core
module instead of duplicating it in the clients.
