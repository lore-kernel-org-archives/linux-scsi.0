From: "Ely, Paul" <Paul.Ely@Emulex.Com>
Subject: RE: suspending I/Os to a device
Date: Mon, 12 Jul 2004 16:53:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28025AB744@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:3798 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S263019AbUGLUxn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 16:53:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>, 'James Bottomley' <James.Bottomley@steeleye.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

All,

As James Smart indicated at the bottom of this thread
entry:

http://marc.theaimsgroup.com/?l=linux-scsi&m=108940122907934&w=2

Here is the continuing conversation regarding storage devices that
disappear and then return.  Please reference this link for
Jon Infante's and Patrick Mansfield's discussion of this feature.

http://marc.theaimsgroup.com/?l=linux-scsi&m=108378376227530&w=2


I have been looking through the midlayer and block level code
to come up with enough detail to start a discussion on a design that
could address this requirement and has a nice fit in the scsi 
midlayer.  

I used the 2.6.7 kernel sources for the initial research.

Some scsi LLDs need a way to suspend all scsi commands sent by
the midlayer, including retries, during the time that a connected
device has disappeared.  The goal of this requirement is to 
prevent premature IO failures back to the application before 
the scsi LLD has a chance to recover the device.  The connected
device may not be recoverable making it necessary for the 
midlayer to detect a bad device.  Should the device be 
recovered by the scsi LLD, then traffic would resume normally
after the scsi LLD informs the midlayer of such an event.

The proposal:
	o A new device state called SDEV_SUSPEND
		- The device's current state must be SDEV_CREATED or
SDEV_RUNNING.
		- Once in SDEV_SUSPEND, the device state is allowed to
transition
		  to SDEV_RUNNING or SDEV_CANCEL.

	o A new routine called scsi_device_suspend to enter the SDEV_SUSPEND
	  state.
		- Called by scsi LLDs only.
		- scsi LLD must not hold any locks, including the host lock,
		  when calling this routine.
		- Routine can be called from interrupt context or normal
kernel
		  context.
		- This routine calls into the scsi_device_set_state
		  function to handle the state transition.  Other
functionality
		  is TBD.

	o A routine that the scsi LLD calls to successfully transition from
	  SDEV_SUSPEND to SDEV_RUNNING state and restart scsi commands.  I
am
	  proposing some alternatives.
		- Reuse scsi_device_resume.
			+ Overloads quiesce and suspend.  This may work
since
			  the state machine will not allow transitions
to/from
			  SDEV_QUIESCE and SDEV_SUSPEND.

		OR

		- Provide a new routine called scsi_device_continue 
			+ Analogous functionality as scsi_device_resume, but
is
			  called specifically to transition out of
SDEV_SUSPEND.

	  In either case, the function would transition the device back to
	  SDEV_RUNNING and goose the device queue.

	o Provide TMO control that limits the amount of time a device can 
	  disappear.  The timeout handling would clean up pending
	  commands on the device queue.  I am proposing some
	  alternatives here.
		- Require the scsi LLD to provide tmo functionality.
Timeout 
		  value would be a driver default, but also settable via a
sysfs
		  class transport attribute.  For example, Fibre Channel
drivers
		  would use a FC transport value in sysfs.

		OR

		- Require the scsi midlayer to provide tmo functionality.
		  Timeout value would be a default, but also settable via
		  a sysfs class transport attribute by the scsi LLD or an
		  admin.

		OR

		- Don't require a tmo on the continue and require the scsi
LLD to 
		  transition out of suspend just like scsi_block_requests
and 
		  scsi_unblock_requests.

Newly discovered devices or devices that get removed without suspend
requirements
require the scsi LLD to call scsi_add_device and scsi_remove_device and so
are
not addressed by this proposal.

Clearly there is more to this issue, but this seems like a good
place to start.

----------
Paul Ely
Emulex


-----Original Message-----
From: Smart, James 
Sent: Wednesday, May 05, 2004 3:01 PM
To: 'James Bottomley'; Infante, Jon
Cc: Linux SCSI Reflector
Subject: RE: suspending I/Os to a device


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
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
