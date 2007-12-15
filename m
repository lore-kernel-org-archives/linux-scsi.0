From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 07/24] arm: scsi convert to accessors and !use_sg
	cleanup
Date: Fri, 14 Dec 2007 19:27:38 -0500
Message-ID: <1197678458.3154.119.camel@localhost.localdomain>
References: <46E6F92D.2090409@panasas.com> <46E72AE7.4030507@panasas.com>
	 <20070912074205.GB2653@flint.arm.linux.org.uk>
	 <46EFE8FF.3010907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49934 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756956AbXLOOVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Dec 2007 09:21:17 -0500
In-Reply-To: <46EFE8FF.3010907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Russell King <rmk@arm.linux.org.uk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>


On Tue, 2007-09-18 at 17:04 +0200, Boaz Harrosh wrote:
> On Wed, Sep 12 2007 at 10:42 +0300, Russell King <rmk@arm.linux.org.uk> wrote:
> > On Wed, Sep 12, 2007 at 02:55:19AM +0300, Boaz Harrosh wrote:
> >> -		if (SCpnt->request_bufflen != len)
> >> +		if (scsi_bufflen(SCpnt) != len) {
> >> +			WARN_ON(1);
> > 
> > NAK.  The call trace generally doesn't provide any additional information
> > on the cause of the error.
> > 
> In my opinion this can not happen any more. If it does, I want to see that
> it is not through the regular scsi-ml .queuecommand mechanism.
> But if you insist than sure I will remove it.
> 
> >>  			printk(KERN_WARNING "scsi%d.%c: bad request buffer "
> >>  			       "length %d, should be %ld\n", SCpnt->device->host->host_no,
> >> -			       '0' + SCpnt->device->id, SCpnt->request_bufflen, len);
> >> -		SCpnt->request_bufflen = len;
> >> +			       '0' + SCpnt->device->id, scsi_bufflen(SCpnt), len);
> >> +		}
> >>  #endif
> >>  	} else {
> >> -		SCpnt->SCp.ptr = (unsigned char *)SCpnt->request_buffer;
> >> -		SCpnt->SCp.this_residual = SCpnt->request_bufflen;
> >> -		SCpnt->SCp.phase = SCpnt->request_bufflen;
> >> -	}
> >> -
> >> -	/*
> >> -	 * If the upper SCSI layers pass a buffer, but zero length,
> >> -	 * we aren't interested in the buffer pointer.
> >> -	 */
> >> -	if (SCpnt->SCp.this_residual == 0 && SCpnt->SCp.ptr) {
> >> -#if 0 //def BELT_AND_BRACES
> >> -		printk(KERN_WARNING "scsi%d.%c: zero length buffer passed for "
> >> -		       "command ", SCpnt->host->host_no, '0' + SCpnt->target);
> >> -		__scsi_print_command(SCpnt->cmnd);
> >> -#endif
> >>  		SCpnt->SCp.ptr = NULL;
> >> +		SCpnt->SCp.this_residual = 0;
> >> +		SCpnt->SCp.phase = 0;
> >>  	}
> >>  }
> > 
> > Also NAK.  This was added due to bad behaviour of the SCSI layer and
> > was found to be necessary.
> > 
> No! This check is no longer Relevant. The master if() is on bufflen() now,
> and only than do we ever set SCp.ptr. The else will always set both to Zero.
> (Which is what you want)
> 
> In any way this check is done in scsi-ml, and since 2.6.18 only scsi-ml
> can allocate and issue commands. All other sources of commands where removed.
> All upper layers issue requests now.

Russell, could you respond to this, please?  Boaz's points seem valid to
me and this conversion must be done soon otherwise these drivers will
break.

James


