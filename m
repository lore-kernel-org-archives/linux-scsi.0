From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problem with an USB Stick and kernel 2.6.1
Date: Tue, 20 Jan 2004 09:56:11 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0401200948010.1204-100000@ida.rowland.org>
References: <1074289238.1884.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:516 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265516AbUATO4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 09:56:11 -0500
In-Reply-To: <1074289238.1884.29.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Regarding DRIVER_SENSE with NO_SENSE data:

On 16 Jan 2004, James Bottomley wrote:

> On Fri, 2004-01-16 at 16:27, Mike Anderson wrote:
> > This matches what I thought should be added to sd, but I did not hear an
> > answer from James / others if this is the way we should handle it.
> 
> Actually, perhaps we should treat it *exactly* the same as
> RECOVERED_ERROR (i.e. do the print_sense) so that if something goes
> wrong with ignoring NO_SENSE returns, we have a trace that it happened.

I'm concerned that these devices will provoke a driver sense on _every_
read or write, since they report an incorrect residue.  Is it reasonable
to print_sense on every I/O operation?

Also, in sd.c the code tests DRIVER_SENSE in a number of places, not all 
of which appear appropriate.  It looks like that test is used where 
SCSI_SENSE_VALID would be better.  Is this something that ought to be 
fixed?

Alan Stern

