From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Lsf] [LSF/MM TOPIC] block-mq issues with FC
Date: Fri, 8 Apr 2016 20:08:32 +0200
Message-ID: <20160408180832.GA22340@lst.de>
References: <57079616.4000202@suse.de> <20160408174006.GI2781@linux.intel.com> <1460138451.2340.60.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47116 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbcDHSIg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 14:08:36 -0400
Content-Disposition: inline
In-Reply-To: <1460138451.2340.60.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Hannes Reinecke <hare@suse.de>, lsf@lists.linux-foundation.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Apr 08, 2016 at 11:00:51AM -0700, James Bottomley wrote:
> >  - Inability to use all queues supported by a device.  Intel's P3700
> >    supports 31 queues, but block-mq insists on assigning an even multiple
> >    of CPUs to each queue.  So if you have 48 CPUs, it will use 24 queues.
> >    If you have 128 CPUs, it will only use 16 of the queues.
> > 
> >  - Interrupt steering needs to be controlled by block-mq instead of
> >    the driver.  It's pointless to have each driver implement its own
> >    policies on interrupt steering, irqbalanced remains a source of
> >    end-user frustration, and block-mq can change the queue<->cpu mapping
> >    without the driver's knowledge.
> > 
> > (thanks to Keith for his input on the first and suggestion of the second).
> 
> OK, what about two sessions, one for general bitching (the feedback
> sessions) and one for concrete proposals for improvements ... so rather
> than just complaining about the problem, if you have concrete ideas
> about fixing it, that would go into the second session.

We already have the blk-mq interrupt assignment session on the schedule,
which is about willy's item.  And my work in progress code to address
the issue also mostly addresses his item number 1, so I think we can
just keep the schedule most as is and just rename "multiqueue interrupt
assignment" into "multiqueue interrupt and queue assignment".

No need to blow it up into three slots.
