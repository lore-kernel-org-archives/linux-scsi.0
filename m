From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH 04/14] uas: lock the abort handler
Date: Wed, 3 Feb 2016 11:53:54 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1602031146540.2041-100000@iolanthe.rowland.org>
References: <1454509736.1930.9.camel@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51284 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756281AbcBCQxz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 11:53:55 -0500
In-Reply-To: <1454509736.1930.9.camel@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org, kraxel@redhat.com, mdharm-usb@one-eyed-alien.net, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

On Wed, 3 Feb 2016, Oliver Neukum wrote:

> On Tue, 2016-01-26 at 10:28 -0500, Alan Stern wrote:
> > On Tue, 26 Jan 2016, Oliver Neukum wrote:
> 
> > > That is problematic. The ABORT_TMF does need IO for which we need
> > > to wait. And if we just submit and pretend the abort worked, the tag
> > > will be reused.
> > > Perhaps we could drop the spinlock. I think it is time to talk to
> > > the SCSI people.
> > 
> > The abort handler doesn't have to wait for the command to terminate.  
> > It merely has to initiate an abort and return.  The SCSI layer gets 
> > notified via the usual mechanism when the command eventually finishes, 
> > whether it was successful or not.
> 
> This is stange. I don't see how we can guarantee a command completion
> if eh_abort_handler() has sent the TMF.
> It was my understanding that returning from eh_abort_handler()
> means that a tag is considered free again and will be reused.
> Could you clarify?

I'm sorry, it looks like I misremembered how usb-storage works.

After checking the code, I see that the abort handler _does_ wait for 
the command to finish before returning.  The abort handler is called 
with no locks held, and it releases its spinlock while it waits.

Is there any reason uas can't do the same thing?

Alan Stern

