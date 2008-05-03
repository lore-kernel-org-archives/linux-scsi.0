From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Discussion: soft unbinding
Date: Sat, 03 May 2008 17:32:31 -0500
Message-ID: <1209853951.3075.31.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0805031556360.20050-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51437 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755555AbYECWcg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 18:32:36 -0400
In-Reply-To: <Pine.LNX.4.44L0.0805031556360.20050-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2008-05-03 at 16:42 -0400, Alan Stern wrote:
> Of even more interest and relevance is this thread:
> 
>         http://marc.info/?t=109630920600005&r=1&w=2
> 
> In one of the messages in that thread, James Bottomley wrote:
> 
> ------------------------------------------------------------------------
> Right.  scsi_remove_host tells the mid-layer that it's OK to trash all
> inflight commands because you removed all their users before calling
> it.  It also tells us that you won't accept any future commands for
> this
> host (because you'll error any attempt in queuecommand).
> ------------------------------------------------------------------------
> 
> Later on Mike Anderson asked:
> 
> ------------------------------------------------------------------------
> Clarification. James, are you indicating that there needs to be a new
> scsi mid api that performs similar function to scsi_remove_host expect
> does not cancel commands?
> ------------------------------------------------------------------------
> 
> There was no real answer and things were left hanging.
> 
> So I guess part of what I'm asking is whether the situation is now 
> significantly different.

Not really ... there's never been cause to make it so.  At the beginning
of the hotplug debate it was thought there was value in a wait for
unplug event ... some PCI busses have a little button you push and then
a light lights up to tell you everything's OK and you can remove the
card.

After a lot of back and forth, it was decided that the best thing for
the latter was for userland to quiesce and unmount the filesystem,
application or whatever and then tell the kernel it was gone, so in that
scenario, the two paths were identical.  I don't think anything's really
changed in that regard.

James


