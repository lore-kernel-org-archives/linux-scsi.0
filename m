From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: suspending I/Os to a device
Date: Wed, 5 May 2004 15:00:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F92D1@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:15298 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264765AbUEETBA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2004 15:01:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>, "Infante, Jon" <Jon.Infante@Emulex.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

James,

So I'm not clear on how this gets implemented...

I'm assuming that this would mirror the scsi_block/unblock_requests()
functions - but now on a scsi-device basis. The SUSPEND state would be an
internal state in the midlayer.  The driver would use the new attribute to
know when to call the unblock function.   And, wouldn't it make sense to
have a midlayer function that could be pointed at a scsi_host/scsi target id
value and have it recurse the block/unblock calls to all the related scsi
devices ?

How does this move forward ?  If we want to have this functionality, must we
put together a patch ? Who modifies the mid layer ?  What I'd like to avoid
is adding error queues that implement the suspend function in our driver.

-- James S



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@steeleye.com]
> Sent: Friday, April 23, 2004 7:29 PM
> To: Infante, Jon
> Cc: Linux SCSI Reflector
> Subject: RE: suspending I/Os to a device
> 
> 
> On Fri, 2004-04-23 at 18:12, Infante, Jon wrote:
> > Here is the senerio I am trying to handle within our Fibre 
> Channel driver.
> > In Fibre Channel, it is possible for the Target, or HBA, to 
> be disconnected
> > from one port on a switch and plugged into another port on 
> the same (or even
> > a different) switch. This transitition can happen with live 
> traffic and the
> > scsi subsystem / driver is supposed to recover gracefully, 
> without failing
> > all I/Os back up to applications that are running. In order 
> to accomplish
> > this, there is a configurable timer, that tells the driver 
> how long to wait
> > (at the Fibre Channel level), when a device disappears, to 
> give it a chance
> > to come back. Some OEMs / environments set this to a couple 
> seconds, some a
> > to couple of minutes.
> 
> Actually, there is no interface because no-one has had any prior
> requirements for this.
> 
> This is effectively a FC specific thing, and I believe you 
> know because
> you get a lip event telling you the target has gone, so it sounds like
> the ideal thing to handle in the FC transport class (since it would
> apply to all FC HBAs) The target reconnect timeout would then be a
> transport class property and we'd start failing I/Os when it 
> expired.  I
> would guess there needs to be an additional state in the device state
> model like SUSPEND (QUIESCE doesn't quite fit because it allows the
> pending queue to drain and the error handler to operate), but we can
> accomodate that.
> 
> By default, I would think the reconnect timeout should be zero because
> most FC operates in a multi-path environment and you want path failure
> notifications as fast as possible, so users requiring this 
> feature would
> need to set the timeout.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
