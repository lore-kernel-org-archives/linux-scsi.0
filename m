From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Discussion: soft unbinding
Date: Sun, 04 May 2008 22:42:05 -0500
Message-ID: <1209958925.16283.46.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0805041708110.8585-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60601 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbYEEDmK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 23:42:10 -0400
In-Reply-To: <Pine.LNX.4.44L0.0805041708110.8585-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 2008-05-04 at 17:14 -0400, Alan Stern wrote:
> On Sun, 4 May 2008, James Bottomley wrote:
> 
> > This is the sequence of events scsi_remove_host causes:
> > 
> >      1. Host goes into CANCEL state.  This has no real meaning to the
> >         mid-layer command processor really: it only checks device state
> >         for commands.
> >      2. it calls scsi_forget_host() which loops over all the hosts
> >         devices calling __scsi_remove_device().
> >      3. __scsi_remove_device puts the device into cancel mode (now only
> >         special commands get through).
> >      4. it unbinds bsg and calls device_unregister triggering the
> >         ->remove method of the driver
> >      5. the ->remove method of sd sends the flush cache as a special
> >         command (which still gets through).
> >      6. it removes the transport
> >      7. it calls device_del and sets the device state to DEL; now no
> >         commands will be permitted
> >      8. finally it calls transport destroy and slave destroy
> >      9. after this is done for every device the host goes into DEL
> 
> That all sounds appropriate for a "soft" unbind.
> 
> What about the error handler?  It's still possible for the 
> device-reset, bus-reset, and host-reset methods to be called after 
> scsi_remove_host returns, isn't it?

Yes ... that's one of the eh problems; although it can probably fixed
just by extending the offline state checking

> Speaking of which, it's also possible for the error handler to remain
> running when scsi_remove_host returns, right?  This would mean that the
> host is in DEL_RECOVERY, not DEL -- which in turn means that commands
> are still permitted.  Shouldn't scsi_remove_host wait for the host to
> reach DEL before returning?

No ... because the host state doesn't really matter for commands, only
the device state.

> > > Or let's put it the other way around.  Suppose the LLD doesn't start
> > > failing calls to queuecommand until after scsi_unregister_host() 
> > > returns.  Then what about the commands that were in flight when 
> > > scsi_unregister_host() was called?  The LLD thinks it owns them, and 
> > > the midlayer thinks that _it_ owns them and can unilaterally cancel 
> > > them.  They can't both be right.
> > 
> > This is a misunderstanding: there's no active cancellation (although
> > there was a long discussion about that too).  All it does is start
> > saying "no" to commands as they come down.  In flight commands are up to
> > the HBA driver to deal with (or the error handler will activate on
> > timeout if it doesn't).
> 
> Okay, good.  Once upon a time (i.e., back in 2004) there _was_ active 
> cancellation.  It caused oopses; I'm glad to hear that it is gone.

James


