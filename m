From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Discussion: soft unbinding
Date: Sun, 04 May 2008 09:15:46 -0500
Message-ID: <1209910547.16283.10.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0805032219160.24318-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43446 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765AbYEDOPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 10:15:52 -0400
In-Reply-To: <Pine.LNX.4.44L0.0805032219160.24318-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2008-05-03 at 22:28 -0400, Alan Stern wrote:
> > > So I guess part of what I'm asking is whether the situation is now 
> > > significantly different.
> > 
> > Not really ... there's never been cause to make it so.  At the beginning
> > of the hotplug debate it was thought there was value in a wait for
> > unplug event ... some PCI busses have a little button you push and then
> > a light lights up to tell you everything's OK and you can remove the
> > card.
> > 
> > After a lot of back and forth, it was decided that the best thing for
> > the latter was for userland to quiesce and unmount the filesystem,
> > application or whatever and then tell the kernel it was gone, so in that
> > scenario, the two paths were identical.  I don't think anything's really
> > changed in that regard.
> 
> I still don't understand.  Let's say the user does unmount the
> filesystem and tell the kernel it is gone.  So the LLD calls
> scsi_unregister_host() and from that point on fails every call to
> queuecommand.  Then how does sd transmit its final FLUSH CACHE command
> to the device?  Are you saying that it doesn't need to, since
> unmounting the filesystem will cause a FLUSH CACHE to be sent anyway?

This is the sequence of events scsi_remove_host causes:

     1. Host goes into CANCEL state.  This has no real meaning to the
        mid-layer command processor really: it only checks device state
        for commands.
     2. it calls scsi_forget_host() which loops over all the hosts
        devices calling __scsi_remove_device().
     3. __scsi_remove_device puts the device into cancel mode (now only
        special commands get through).
     4. it unbinds bsg and calls device_unregister triggering the
        ->remove method of the driver
     5. the ->remove method of sd sends the flush cache as a special
        command (which still gets through).
     6. it removes the transport
     7. it calls device_del and sets the device state to DEL; now no
        commands will be permitted
     8. finally it calls transport destroy and slave destroy
     9. after this is done for every device the host goes into DEL

> Or let's put it the other way around.  Suppose the LLD doesn't start
> failing calls to queuecommand until after scsi_unregister_host() 
> returns.  Then what about the commands that were in flight when 
> scsi_unregister_host() was called?  The LLD thinks it owns them, and 
> the midlayer thinks that _it_ owns them and can unilaterally cancel 
> them.  They can't both be right.

This is a misunderstanding: there's no active cancellation (although
there was a long discussion about that too).  All it does is start
saying "no" to commands as they come down.  In flight commands are up to
the HBA driver to deal with (or the error handler will activate on
timeout if it doesn't).

James


