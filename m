From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 07/24] arm: scsi convert to accessors and !use_sg
	cleanup
Date: Thu, 31 Jan 2008 12:09:35 -0600
Message-ID: <1201802975.3131.37.camel@localhost.localdomain>
References: <46E6F92D.2090409@panasas.com> <46E72AE7.4030507@panasas.com>
	 <20070912074205.GB2653@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41242 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760629AbYAaSKK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 13:10:10 -0500
In-Reply-To: <20070912074205.GB2653@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>


On Wed, 2007-09-12 at 08:42 +0100, Russell King wrote:
> On Wed, Sep 12, 2007 at 02:55:19AM +0300, Boaz Harrosh wrote:
> > -		if (SCpnt->request_bufflen != len)
> > +		if (scsi_bufflen(SCpnt) != len) {
> > +			WARN_ON(1);
> 
> NAK.  The call trace generally doesn't provide any additional information
> on the cause of the error.
> 
> >  			printk(KERN_WARNING "scsi%d.%c: bad request buffer "
> >  			       "length %d, should be %ld\n", SCpnt->device->host->host_no,
> > -			       '0' + SCpnt->device->id, SCpnt->request_bufflen, len);
> > -		SCpnt->request_bufflen = len;
> > +			       '0' + SCpnt->device->id, scsi_bufflen(SCpnt), len);
> > +		}
> >  #endif
> >  	} else {
> > -		SCpnt->SCp.ptr = (unsigned char *)SCpnt->request_buffer;
> > -		SCpnt->SCp.this_residual = SCpnt->request_bufflen;
> > -		SCpnt->SCp.phase = SCpnt->request_bufflen;
> > -	}
> > -
> > -	/*
> > -	 * If the upper SCSI layers pass a buffer, but zero length,
> > -	 * we aren't interested in the buffer pointer.
> > -	 */
> > -	if (SCpnt->SCp.this_residual == 0 && SCpnt->SCp.ptr) {
> > -#if 0 //def BELT_AND_BRACES
> > -		printk(KERN_WARNING "scsi%d.%c: zero length buffer passed for "
> > -		       "command ", SCpnt->host->host_no, '0' + SCpnt->target);
> > -		__scsi_print_command(SCpnt->cmnd);
> > -#endif
> >  		SCpnt->SCp.ptr = NULL;
> > +		SCpnt->SCp.this_residual = 0;
> > +		SCpnt->SCp.phase = 0;
> >  	}
> >  }
> 
> Also NAK.  This was added due to bad behaviour of the SCSI layer and
> was found to be necessary.

Time is up on this one: this driver now won't build in mainline because
of the promised sg_table updates.  Either you ack the changes or provide
your own.  If not, I'll mark the driver BROKEN.

James


