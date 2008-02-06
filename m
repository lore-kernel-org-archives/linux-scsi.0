From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
	isd200.c
Date: Wed, 06 Feb 2008 17:55:08 -0600
Message-ID: <1202342108.3112.146.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0802061820490.7110-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46488 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764366AbYBFXzO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 18:55:14 -0500
In-Reply-To: <Pine.LNX.4.44L0.0802061820490.7110-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Boaz Harrosh <bharrosh@panasas.com>, Mark Glines <mark@glines.org>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


On Wed, 2008-02-06 at 18:25 -0500, Alan Stern wrote:
> On Wed, 6 Feb 2008, James Bottomley wrote:
> 
> > > What we're talking about is a routine that provides drivers a simple
> > > way to access the data in a scatter-gather buffer (which may lie in
> > > highmem or otherwise not be easily reachable).  The idea is that some 
> > > commands are emulated by the driver rather than carried out by the 
> > > device, and the driver needs some way to stick the results in the 
> > > transfer buffer.
> > 
> > Isn't that what scsi_kmap_sg() is designed for ... or do you need
> > something slightly different?
> 
> I don't know -- I've never heard of scsi_kmap_sg().  And it doesn't 
> appear to exist anywhere in my kernel source.
> 
> Did you mean scsi_kmap_atomic_sg()?

Yes .. I replied from memory rather than looking in the source.

>   That appears to do only part of
> what usb_stor_access_xfer_buf() does.  In fact, all it does is map a
> single page.

Um, it does everything you asked about above.  It's designed as a helper
for SCSI devices that need to modify data for automatically generated
returns (RAID devices and INQUIRY strings for instance).  It's also used
by some of the less well automated devices that might need to do an
effective PIO feed on DMA engine halts.  It allows you to address a sg
list by offset and length (although it will adjust the length if there's
a mapping problem).  Since the only way to guarantee access to highmem
is by kmap_atomic (which has limited slots), any API that does this sort
of thing is necessarily page based and does single page mappings at a
time.  Why don't you tell me what you think is missing rather than me
having to dig around in the usb sources to try to work it out.

James


