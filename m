From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: Fri, 21 Nov 2003 11:17:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121101728.GI1106@suse.de>
References: <20031120085555.A20609@beaverton.ibm.com> <20031120181543.GA3728@beaverton.ibm.com> <20031120191651.GE1106@suse.de> <20031120135123.A2366@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:60298 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264351AbTKUKRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 05:17:46 -0500
Content-Disposition: inline
In-Reply-To: <20031120135123.A2366@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, dmitrik@users.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Thu, Nov 20 2003, Patrick Mansfield wrote:
> On Thu, Nov 20, 2003 at 08:16:51PM +0100, Jens Axboe wrote:
> > On Thu, Nov 20 2003, Mike Anderson wrote:
> > > Patrick Mansfield [patmans@us.ibm.com] wrote:
> > > > Don't retry SG_IO (REQ_BLOCK_PC) commands.
> > > 
> > > Should we also have the REQ_BLOCK_PC requests set REQ_FAILFAST? The
> > > patch to sd will imply the same behavior.
> > 
> > Definitely!
> 
> Should the setting of REQ_FAILFAST be expanded to prevent requeueing after
> a device or host reports queue full?

Not without extra hints.

> There are probably many SG_IO users that would want them retried, others
> (multimedia?) might not want a retry. Multi-path would *not* want them
> retried (well at least the host queue full).
> 
> For IO that cannot be sent to the device (if we have !scsi_dev_queue_ready()
> or !scsi_host_queue_ready()), it is unclear if REQ_FAILFAST should
> complete the IO without ever having sent it to the device.
> 
> If we expand the checks for REQ_FAILFAST, the SG_IO user interface should
> allow the conditional setting of it.

Yes, we would need to be able to pass that hint in from user space. A
SG_FLAG_NO_RETRY would work.

-- 
Jens Axboe

