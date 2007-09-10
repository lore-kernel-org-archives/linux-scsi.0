From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patchset 0/5] Refactoring scsi_error to facilitate in synchronous
 REQUEST_SENSE
Date: Mon, 10 Sep 2007 11:58:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709101145110.2732-100000@iolanthe.rowland.org>
References: <46E5508B.7030108@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52720 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964834AbXIJP6L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 11:58:11 -0400
In-Reply-To: <46E5508B.7030108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Christoph Hellwig <hch@infradead.org>

On Mon, 10 Sep 2007, Boaz Harrosh wrote:

> In motivation to abstract scsi_cmnd members and insulate
> drivers/transports from scsi_cmnd internals. The last
> place left was the REQUEST_SENSE sequence when done
> synchronous, by drivers.
> 
> Also all these drivers would do a use_sg==0 command
> invocation, preventing from doing cleanups on these
> drivers/transports. So this patchset is left-overs
> from Christoph's 2.6.18 cleanups.
> 
> In this patchset I have re-factored scsi_error to
> make it possible for drivers to use an abstract
> (easy to use, I hope) API for invoking a REQUEST_SENSE
> command. The API is declared in scsi/scsi_eh.h

This is a good idea, but the implementation has a few problems.

A trivial problem is that quilt complains about patch 3, which leaves 
extra whitespace at the end of line 591 in transport.c.

More seriously, why make the caller define a static generic_sense 
array?  Why not put the array in scsi_eh_prep_cmnd(), where it can be 
used whenever copy_sense is nonzero?

The line initializing the sense buffer to zero should be inside the 
copy_sense conditional block.

The code setting the LUN bits in scmd[1] is wrong.  It should be like 
the code in scsi_dispatch_cmd(); i.e., those bits should not be set if 
the scsi_level is SCSI_UNKNOWN.

Finally, a really serious problem.  The code sets the buffer length for
the REQUEST SENSE command to be the length of scmd->sense_buffer, which
is 96.  But many USB devices won't work properly unless the requesed
sense data length is 18.  The appropriate adjustment must be added to 
transport.c in patch 3.

Alan Stern

