From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Thu, 16 Jun 2005 14:00:57 +0200
Message-ID: <20050616120053.GB10764@suse.de>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com> <1118849292.5045.27.camel@mulgrave> <42B04A9C.7050503@us.ibm.com> <1118850458.5045.34.camel@mulgrave> <42B05330.7050406@us.ibm.com> <1118853899.5045.39.camel@mulgrave> <20050615170545.GB23912@us.ibm.com> <1118856207.5045.46.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:59355 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261625AbVFPL7r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 07:59:47 -0400
Content-Disposition: inline
In-Reply-To: <1118856207.5045.46.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, brking@us.ibm.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, haren@us.ibm.com

On Wed, Jun 15 2005, James Bottomley wrote:
> On Wed, 2005-06-15 at 10:05 -0700, Patrick Mansfield wrote:
> > First in scsi_alloc_queue, the flush/sync code is only used if we don't
> > have ordered tags, and if the adapter driver explicitly allows it
> > (shost->order_flush).
> > 
> > Plus we clear order_flush in scsi_host_alloc if can_queue > 1.
> > 
> > So ipr will never get those sync cache commands, correct?
> 
> Actually, yes.  I thought Jens turned it on globally, but apparently
> it's only set for the sata controllers.

Yeah, I figured most other scsi controllers supported TCQ...

> the can_queue check is a bit mysterious since non TCQ devices should
> have can_queue == 2 (so they have one command executing and one command
> ready to roll).

But that will cause the mid layer to invoke ->queuecommand() when you
already have one command queued, thus the driver needs to check if it
really can queue one more. I greatly prefer the driver setting the exact
depth instead. If you want to have the next command pre-setup, you
should do so in the mid layer.

> > And we default to QUEUE_ORDERED_NONE (0) if ordered_tag and ordered_flush
> > are not set.
> > 
> > But I can't find any where that we set ordered_tag at all, am I missing
> > something??? Let alone in ipr.
> 
> I think that was also added by the barrier patch set. Although it's well
> known what the difficulties of using ordered tag queueing to implement
> barriers are:
> 
> 1) Race in queuecommand() where barrier gets BUSY or QUEUE_FULL but next
> command is accepted before we see this.
> 2) Error handling is not robust to ordering.
> 3) Qerr bit of the control mode page needs to be set correctly.

Some work still left to fully supported barriers with tags, Tejun is
making great progress though.

-- 
Jens Axboe

