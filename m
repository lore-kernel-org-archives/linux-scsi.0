From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PREEMPT-RT] [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Mon, 7 Nov 2016 17:48:46 +0100
Message-ID: <20161107164846.GA1966@lst.de>
References: <20160817101003.30055-1-bigeasy@linutronix.de> <20161107161901.GA12297@infradead.org> <alpine.DEB.2.20.1611071729030.3709@nanos> <20161107163848.GA1421@lst.de> <20161107164628.jrft3ovlp5myfvs5@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58008 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752174AbcKGQsr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 11:48:47 -0500
Content-Disposition: inline
In-Reply-To: <20161107164628.jrft3ovlp5myfvs5@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>

On Mon, Nov 07, 2016 at 05:46:29PM +0100, Sebastian Andrzej Siewior wrote:
> sorry for the confusion in the subject. If I remember correctly you said
> that we may not have enough room for a larger / work_struct struct and I
> should keep the list for now.

But that was for libfc where it only has a tiny bit of private data
i nthe skb - this is for cnix which has plenty of space, and in fact
probably should do the workqueue offload in the core before invoking
the protocol drivers.
