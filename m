From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Sat, 06 Jan 2007 10:28:35 -0600
Message-ID: <1168100915.2792.65.camel@mulgrave.il.steeleye.com>
References: <20070105034613.GA14118@lsil.com>
	 <1168097445.2792.53.camel@mulgrave.il.steeleye.com>
	 <20070106161017.GI24620@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47548 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426AbXAFQ2p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jan 2007 11:28:45 -0500
In-Reply-To: <20070106161017.GI24620@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Eric Moore <eric.moore@lsil.com>, linux-scsi@vger.kernel.org

On Sat, 2007-01-06 at 09:10 -0700, Matthew Wilcox wrote:
> On Sat, Jan 06, 2007 at 09:30:45AM -0600, James Bottomley wrote:
> > On Thu, 2007-01-04 at 20:46 -0700, Eric Moore wrote:
> > > -			if (scsi_status == MPI_SCSI_STATUS_BUSY)
> > > +			if (ioc->bus_type != SPI && scsi_status == MPI_SCSI_STATUS_BUSY)
> > >  				sc->result = (DID_BUS_BUSY << 16) | scsi_status;
> > >  			else
> > >  				sc->result = (DID_OK << 16) | scsi_status;
> > 
> > DID_BUS_BUSY causes an immediate retry, but it does debit the retry
> > count, so it shouldn't cause "infinite retries" ... if it does, there's
> > something else wrong here.
> 
> I wonder if this is the same bug I'm chasing (on ia64 machines,
> reproduced with both Montecito and Madison).  

I don't think so ... the done() breaks the stack chain by queueing it up
for the softirq to complete.  In order to get the recursion you see, we
have to go straight to requeue from dispatch_cmd.

At a rough guess I'd say what you're seeing could be a result of the
requeue in scsi_dispatch_cmd caused by the device being in SDEV_BLOCK.

James


