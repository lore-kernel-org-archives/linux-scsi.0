From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: adding flag for 192 byte mode sense
Date: Mon, 22 Mar 2004 12:28:22 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0403221207430.8035-100000@ida.rowland.org>
References: <1079973105.2072.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:17156 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262149AbUCVR2X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2004 12:28:23 -0500
In-Reply-To: <1079973105.2072.42.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, mdharm-usb@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, usb-storage@lists.one-eyed-alien.net

On 22 Mar 2004, James Bottomley wrote:

> On Mon, 2004-03-22 at 11:16, Alan Stern wrote:
> > Do they look good?  Should they be applied?  One suggestion for a change: 
> > the flag could be renamed "use_192_bytes_for_ms" since we may end up 
> > wanting to use it for both page 0x3f and 0x08.
> 
> They already are in the scsi-misc-2.6 repository.

Great!  Were just the SCSI patches included or were the usb-storage 
changes put in as well?  When can I expect to see them in a distribution 
kernel?


> > 	3. When a USB mass storage device enters a state that requires a
> > device reset, what command completion code should the usb-storage driver
> > return to invoke the SCSI error handler?  And is there any way to do this
> > so that the error handler skips the initial TEST UNIT READY step and goes
> > directly to the device reset?
> 
> Anything that maps to FAILED in scsi_decide_disposition()

So for example, (DID_OK << 16) + (ABORT << 8) would do the trick, right?
Or (0xff << 16).  Is there any equivalent that expresses the intention
more clearly?


> What TEST UNIT READY?  The error handler only issues those *after*
> recovery, not before.

Hmm... apparently that disappeared while I wasn't looking.  I recall 
reading lots and lots of debugging logs in which the first thing that 
happened after a command timed out was a TEST UNIT READY.  But it doesn't 
matter.

Alan Stern

