From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Thu, 20 Jan 2005 15:39:29 +0000
Message-ID: <20050120153929.GA3485@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F307@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:8878 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262161AbVATPjb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 10:39:31 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F307@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 20, 2005 at 10:27:54AM -0500, James.Smart@Emulex.Com wrote:
> > What console messages do you see?  Looks like we'd have to add another
> > allowed state transition from BLOCKED?
> 
> At one point we were seeing 
>    Synchronizing SCSI cache for disk sdc:
>     FAILED
>       status = 0, message = 00, host = 1, driver = 00
>       <5>
> messages. However, at this point, the sequencing in the driver for unload,
> scsi_host_removal, and datastructure teardown is such that we are avoiding
> this condition and removals are clean.

That was a bug in the scsi device statemachine and showed up on all hosts,
it has indeed been fixed for while.

> > I meant fc_target_attrs actually, which is scsi_target transport-data.
> > 
> > The point here is that the rport is a transport-class transport object
> > that every driver fully converted to fc_transport needs, so 
> > it's better
> > in transport data as well.
> 
> If I understand you - it's the recommendation that the remote port be
> part of the fc_target transport data.  I disagree. If anything, it would
> be the other way around. The port exists before any scsi target (thus it
> can't be part of the target allocation). The port can also exist without
> being a scsi target, so there's no scsi target structure at all.

No, sorry for have been unclear.  I want a pointer to the remote port
structure in the fc_target transport data.  Every driver needs the
linkage of these two, and instead of everyone having it in their
private data we'd better move it to the fc_transport data structure.

> > Now looking at lpfc_target given that the rport goes away we only
> > have the I/O counters left and the nodlist pointer.  The I/O counters
> > aren't really a driver thing and should probably move to the midlayer
> > which only leaves the nodelist as private data in the scsi_device.
> > 
> > Sounds like the way to go?
> 
> Nope. The counters are a scsi-thing (not fc-thing), so they make sense
> to go into the scsi_target.

That's what I meant.  In fact that way it's exposed in a driver-private
attributes isn't good at all.  What about dropping the counters temporarily
for submission and submit a patch later that adds them (and their sysfs
exposure) back at the midlayer?  In fact the actual accounting is better
done at the midlayer-level anyway.

