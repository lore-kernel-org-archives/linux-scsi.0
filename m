From: Christoph Hellwig <hch@infradead.org>
Subject: Re: suspending I/Os to a device
Date: Sat, 17 Jul 2004 13:24:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040717122437.GA31551@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28025AB744@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:19626 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266566AbUGQMYl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jul 2004 08:24:41 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28025AB744@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Ely, Paul" <Paul.Ely@Emulex.Com>
Cc: "Smart, James" <James.Smart@Emulex.Com>, 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Mon, Jul 12, 2004 at 04:53:34PM -0400, Ely, Paul wrote:
> The proposal:
> 	o A new device state called SDEV_SUSPEND
> 		- The device's current state must be SDEV_CREATED or
> SDEV_RUNNING.
> 		- Once in SDEV_SUSPEND, the device state is allowed to
> transition
> 		  to SDEV_RUNNING or SDEV_CANCEL.
> 
> 	o A new routine called scsi_device_suspend to enter the SDEV_SUSPEND
> 	  state.
> 		- Called by scsi LLDs only.
> 		- scsi LLD must not hold any locks, including the host lock,
> 		  when calling this routine.
> 		- Routine can be called from interrupt context or normal
> kernel
> 		  context.
> 		- This routine calls into the scsi_device_set_state
> 		  function to handle the state transition.  Other
> functionality
> 		  is TBD.
> 
> 	o A routine that the scsi LLD calls to successfully transition from
> 	  SDEV_SUSPEND to SDEV_RUNNING state and restart scsi commands.  I
> am
> 	  proposing some alternatives.

This sounds fine to me.

> 		- Reuse scsi_device_resume.
> 			+ Overloads quiesce and suspend.  This may work
> since
> 			  the state machine will not allow transitions
> to/from
> 			  SDEV_QUIESCE and SDEV_SUSPEND.
> 
> 		OR
> 
> 		- Provide a new routine called scsi_device_continue 
> 			+ Analogous functionality as scsi_device_resume, but
> is
> 			  called specifically to transition out of
> SDEV_SUSPEND.

Please use separate functions.

> 	o Provide TMO control that limits the amount of time a device can 
> 	  disappear.  The timeout handling would clean up pending
> 	  commands on the device queue.  I am proposing some
> 	  alternatives here.
> 		- Require the scsi LLD to provide tmo functionality.
> Timeout 
> 		  value would be a driver default, but also settable via a
> sysfs
> 		  class transport attribute.  For example, Fibre Channel
> drivers
> 		  would use a FC transport value in sysfs.

Not sure if I parsed that correctly.  You want a timeout after which the
device gets unblocked again?  In that case the scsi_device should get a timer
that calls the unblock routine, sounds fine to me and can be done in the
scsi midlayer.
