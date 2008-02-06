From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
	isd200.c
Date: Wed, 06 Feb 2008 17:01:09 -0600
Message-ID: <1202338869.3112.138.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0802061708460.7110-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57704 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758246AbYBFXBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 18:01:15 -0500
In-Reply-To: <Pine.LNX.4.44L0.0802061708460.7110-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Boaz Harrosh <bharrosh@panasas.com>, Mark Glines <mark@glines.org>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


On Wed, 2008-02-06 at 17:18 -0500, Alan Stern wrote:
> On Wed, 6 Feb 2008, Matthew Dharm wrote:
> 
> > Maybe this is a crazy question, but...
> > 
> > Why is this not in the SCSI core?
> 
> Or even in the block core?
> 
> >  It's hardly USB-specific, and I'm
> > willing to bet that there are other HCDs (at least spb2) which need to do
> > this sort of thing...
> 
> James, do you have any idea?
> 
> What we're talking about is a routine that provides drivers a simple
> way to access the data in a scatter-gather buffer (which may lie in
> highmem or otherwise not be easily reachable).  The idea is that some 
> commands are emulated by the driver rather than carried out by the 
> device, and the driver needs some way to stick the results in the 
> transfer buffer.

Isn't that what scsi_kmap_sg() is designed for ... or do you need
something slightly different?

James


