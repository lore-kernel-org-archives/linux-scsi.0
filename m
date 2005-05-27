From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: fix bad locking during eh_abort
Date: Fri, 27 May 2005 13:18:31 -0700
Message-ID: <20050527201831.GE16474@plap.qlogic.org>
References: <20050526231938.GA31205@plap.qlogic.org> <1117224371.7379.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:35208 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262573AbVE0USc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 16:18:32 -0400
Content-Disposition: inline
In-Reply-To: <1117224371.7379.21.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 27 May 2005, James Bottomley wrote:

> On Thu, 2005-05-26 at 16:19 -0700, Andrew Vasquez wrote:
> > Please apply, this should go in before 2.6.12 is released.
> 
> I've got it in the rc-fixes tree for scsi.  However:
> 
> > +	spin_unlock(&ha->hardware_lock);
> 
> Should be spin_unlock_irq(&ha->hardware_lock); shouldn't it?  Otherwise
> we could sleep with interrupts disabled and the kernel now squeaks about
> that.

Yes, with the latest changes being proposed/implemented by Jeff G.,
there would need to be some additional massaging of the driver's
eh_*() routines.

Are you planning on putting the host_lock-free changes in for -rc,
I figured that would be going into the next kernel rev.  I mention
that because I have a block of patches which I have queued-up to add
new chip support to the driver.

Jeff, could you drop the qla2xxx driver from your scrubing
host_lock-free changes.  I'll go ahead and post an updated patch
following the patches in my queue.

Thanks,
Andrew Vasquez
