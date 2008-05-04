From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Discussion: soft unbinding
Date: Sun, 4 May 2008 17:14:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805041708110.8585-100000@netrider.rowland.org>
References: <1209910547.16283.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4574 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754010AbYEDVOV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 17:14:21 -0400
In-Reply-To: <1209910547.16283.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 4 May 2008, James Bottomley wrote:

> This is the sequence of events scsi_remove_host causes:
> 
>      1. Host goes into CANCEL state.  This has no real meaning to the
>         mid-layer command processor really: it only checks device state
>         for commands.
>      2. it calls scsi_forget_host() which loops over all the hosts
>         devices calling __scsi_remove_device().
>      3. __scsi_remove_device puts the device into cancel mode (now only
>         special commands get through).
>      4. it unbinds bsg and calls device_unregister triggering the
>         ->remove method of the driver
>      5. the ->remove method of sd sends the flush cache as a special
>         command (which still gets through).
>      6. it removes the transport
>      7. it calls device_del and sets the device state to DEL; now no
>         commands will be permitted
>      8. finally it calls transport destroy and slave destroy
>      9. after this is done for every device the host goes into DEL

That all sounds appropriate for a "soft" unbind.

What about the error handler?  It's still possible for the 
device-reset, bus-reset, and host-reset methods to be called after 
scsi_remove_host returns, isn't it?

Speaking of which, it's also possible for the error handler to remain
running when scsi_remove_host returns, right?  This would mean that the
host is in DEL_RECOVERY, not DEL -- which in turn means that commands
are still permitted.  Shouldn't scsi_remove_host wait for the host to
reach DEL before returning?

> > Or let's put it the other way around.  Suppose the LLD doesn't start
> > failing calls to queuecommand until after scsi_unregister_host() 
> > returns.  Then what about the commands that were in flight when 
> > scsi_unregister_host() was called?  The LLD thinks it owns them, and 
> > the midlayer thinks that _it_ owns them and can unilaterally cancel 
> > them.  They can't both be right.
> 
> This is a misunderstanding: there's no active cancellation (although
> there was a long discussion about that too).  All it does is start
> saying "no" to commands as they come down.  In flight commands are up to
> the HBA driver to deal with (or the error handler will activate on
> timeout if it doesn't).

Okay, good.  Once upon a time (i.e., back in 2004) there _was_ active 
cancellation.  It caused oopses; I'm glad to hear that it is gone.

Alan Stern

