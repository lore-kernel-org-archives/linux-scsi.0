From: "Ely, Paul" <Paul.Ely@Emulex.Com>
Subject: RE: suspending I/Os to a device
Date: Mon, 19 Jul 2004 16:04:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28025AB77C@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:7114 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S265234AbUGSUEn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jul 2004 16:04:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "Smart, James" <James.Smart@Emulex.Com>, 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Christoph,
 
Thanks for the feedback.

I was not clear enough on the TMO handling.  Yes, I 
do think a TMO value is necessary to prevent the scsi
lld from suspending the device indefinitely - if the
scsi lld could do this, the suspend functionality is
just block/unblock.  The intention of suspend is a
device loss that is transient.  Beyond the TMO value,
it is treated as a device removal.
 
I agree that the scsi device should get a timer and
call scsi_device_continue to transition back to 
SDEV_RUNNING and that it all belongs in the midlayer.
 
There is a condition that I have to work through for
scsi llds.  Suppose a scsi lld calls scsi_device_suspend,
and sets some internal state.  After the TMO value has
expired, the scsi lld has not called the scsi_device_continue.
The midlayer times out the suspend and starts queueing
scsi commands again.   There are a few scenerios:
 
 	1. The device is recovered in nearly the same time.  In
 	   this case, the scsi lld calls continue and the device
 	   state machine ignores the transition since it would be
 	   SDEV_RUNNING transition from current state SDEV_RUNNING,
 	   and the device would recover.
 
 	2. The device recovers within the midlayer's retry count.
 
 	3. The device recovers post-TMO.  Too late.  The midlayer believes
	   transitioned to SDEV_CANCEL.  

	4. The device never recovers.  Similar to scenerio 3.  In both 
	   cases, the driver needs a way to recover - possibly a hint
	   via scsi_device_continue failing.
 
I plan on submitting a patch for the work discussed so far this
week.
 
 Thanks,
 
 Paul

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Saturday, July 17, 2004 8:25 AM
> To: Ely, Paul
> Cc: Smart, James; 'James Bottomley'; Linux SCSI Reflector
> Subject: Re: suspending I/Os to a device
> 
> 
> On Mon, Jul 12, 2004 at 04:53:34PM -0400, Ely, Paul wrote:
> > The proposal:
> > 	o A new device state called SDEV_SUSPEND
> > 		- The device's current state must be SDEV_CREATED or
> > SDEV_RUNNING.
> > 		- Once in SDEV_SUSPEND, the device state is allowed to
> > transition
> > 		  to SDEV_RUNNING or SDEV_CANCEL.
> > 
> > 	o A new routine called scsi_device_suspend to enter the 
> SDEV_SUSPEND
> > 	  state.
> > 		- Called by scsi LLDs only.
> > 		- scsi LLD must not hold any locks, including 
> the host lock,
> > 		  when calling this routine.
> > 		- Routine can be called from interrupt context or normal
> > kernel
> > 		  context.
> > 		- This routine calls into the scsi_device_set_state
> > 		  function to handle the state transition.  Other
> > functionality
> > 		  is TBD.
> > 
> > 	o A routine that the scsi LLD calls to successfully 
> transition from
> > 	  SDEV_SUSPEND to SDEV_RUNNING state and restart scsi 
> commands.  I
> > am
> > 	  proposing some alternatives.
> 
> This sounds fine to me.
> 
> > 		- Reuse scsi_device_resume.
> > 			+ Overloads quiesce and suspend.  This may work
> > since
> > 			  the state machine will not allow transitions
> > to/from
> > 			  SDEV_QUIESCE and SDEV_SUSPEND.
> > 
> > 		OR
> > 
> > 		- Provide a new routine called scsi_device_continue 
> > 			+ Analogous functionality as 
> scsi_device_resume, but
> > is
> > 			  called specifically to transition out of
> > SDEV_SUSPEND.
> 
> Please use separate functions.
> 
> > 	o Provide TMO control that limits the amount of time a 
> device can 
> > 	  disappear.  The timeout handling would clean up pending
> > 	  commands on the device queue.  I am proposing some
> > 	  alternatives here.
> > 		- Require the scsi LLD to provide tmo functionality.
> > Timeout 
> > 		  value would be a driver default, but also 
> settable via a
> > sysfs
> > 		  class transport attribute.  For example, Fibre Channel
> > drivers
> > 		  would use a FC transport value in sysfs.
> 
> Not sure if I parsed that correctly.  You want a timeout 
> after which the
> device gets unblocked again?  In that case the scsi_device 
> should get a timer
> that calls the unblock routine, sounds fine to me and can be 
> done in the
> scsi midlayer.
> 
