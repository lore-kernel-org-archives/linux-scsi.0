From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Wed, 29 Sep 2004 11:32:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929183214.GA5771@us.ibm.com>
References: <20040929183858.A15586@infradead.org> <Pine.LNX.4.44L0.0409291345420.1700-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:31185 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268798AbUI2Scz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 14:32:55 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0409291345420.1700-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Alan Stern [stern@rowland.harvard.edu] wrote:
> Mike, thanks for adding me to this thread...
> 
> On Wed, 29 Sep 2004, Christoph Hellwig wrote:
> 
> > > In some cases the knowledge would be in the driver would it not. When the
> > > drivers remove function is called the driver knows the state of the
> > > transport or in the case of the usb storage device it knows it will
> > > not process anymore commands. 
> > > 
> > > Alan / Matthew / others can correct if I have mis-read something in
> > > usb_stor_release_resources but it knows that it will not process anymore
> > > commands prior to calling scsi_remove_host so if we had a method to flag
> > > this it would help in our shutdown if we want to support both devices
> > > that can and cannot process commands.
> 
> That's right; when usb-storage calls scsi_remove_host it will not process 
> any more commands.
> 
> > Well, we're certainly not going to change the scsi_remove_host signature,
> > but we could add a separate one.
> > 
> > But I don't like that change at all as we would still have that problem
> > with all driver that don't have a way to magically find out.  We should
> > really try to make scsi_remove_host foolprof.
> 
> Please take a look at my questions in
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=109647697621208&w=2
> 
> Part of the problem here may be that ownership of SCSI commands isn't 
> clear during the host removal process.  As things stand, usb-storage has 
> no choice but to ignore commands queued after scsi_remove_host is called.  
> This certainly will cause problems if it means we have to wait around for 
> the commands to time out and be aborted.
> 

Is it possible usb storage could do something else beside just ignore
the commands like return them with DID_NO_CONNECT.

In storage_disconnect it looks like you set some state, wait for the
current command, but do not set anything that queuecommand can look at
to start rejecting commands.

-andmike
--
Michael Anderson
andmike@us.ibm.com

