From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 20 Jan 2004 08:47:11 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120164711.GA1628@beaverton.ibm.com>
References: <20040120132052.GA6740@lst.de> <20040120155320.GA1478@beaverton.ibm.com> <20040120160058.GA8924@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:63205 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S265598AbUATQoX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 11:44:23 -0500
Content-Disposition: inline
In-Reply-To: <20040120160058.GA8924@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, gibbs@scsiguy.com, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> On Tue, Jan 20, 2004 at 07:53:20AM -0800, Mike Anderson wrote:
> > Christoph Hellwig [hch@lst.de] wrote:
> > > to get control first after a command timeout.  Justin, does this look
> > > okay for you?  BTW, your drivers are the last ones using scsi_add_timer
> > > from outside the midlayer, if we could get rid of that we'd be able to
> > > keep the interface private.
> > > 
> > 
> > If a LLDD uses this interface how does the scsi_cmnd get returned back
> > to the mid-layer?
> 
> My thoughts about this interface would be that the driver performs
> internals actions of whatever means and then calls scsi_eh_scmd_add
> anyway - that's why it moved out of scsi_priv.h
> 

Sorry I read the patch to fast and missed the move.

> > If one uses scsi_done without a timer set it will
> > believe that the error handler is running and not pass it on to
> > scsi_softirq.
> 
> We could change that by moving the guts of scsi_done to a new
> __scsi_done and then make scsi_done a tiny wrapper around it, e.g:
> 

I assume the wrapper would only help if we went the direction of having
the LLDD call __scsi_done directly under some recovery case?

-andmike
--
Michael Anderson
andmike@us.ibm.com

