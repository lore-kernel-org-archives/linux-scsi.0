From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: SCSI dynamic power management
Date: Mon, 19 Nov 2007 10:53:02 -0600
Message-ID: <1195491182.3283.17.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0711191130330.4806-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:33299 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753401AbXKSQxJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 11:53:09 -0500
In-Reply-To: <Pine.LNX.4.44L0.0711191130330.4806-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>


On Mon, 2007-11-19 at 11:46 -0500, Alan Stern wrote:
> On Mon, 19 Nov 2007, Salyzyn, Mark wrote:
> 
> > Alan Stern sez:
> > > Sure.  But that won't do any good if the requests get held on 
> > > the queue
> > > (or failed immediately) because the disk is supposedly "suspended".
> > > Somehow those requests have to be allowed to proceed while all others 
> > > are forced to wait (or to fail).
> > 
> > Not a failure. Not ready is reported back in a check condition on a
> > media based request, a spin-up request is issued, then a subsequent loop
> > sits there probing every second with a Test Unit ready to wait for the
> > drive to spin back up. There is ample time provided in this path for the
> > drive to spin-up.
> 
> You're talking about what the stack does now, but I'm talking about 
> what it will do once the dynamic power management code is in place.  
> Commands won't even get sent to the low-level driver, never mind coming 
> back with a check condition status.
> 
> Here's how it will work: scsi_prep_state_check() will see that the
> device is in a suspended state (probably a substate of SDEV_QUIESCE).  
> The return value will depend on the type of suspend:
> 
> 	For manual suspend or system suspend, the routine simply 
> 	returns BLKPREP_KILL.
> 
> 	For autosuspend, the routine will submit a workqueue request
> 	to autoresume the device and will return BLKPREP_DEFER.
> 
> The trick is somehow to allow the START-STOP UNIT commands get past 
> this filter.  Is this what the REQ_PREEMPT flag is intended for?

Um, that model is pretty host centric ... we wouldn't be able to use
that for power management of shared devices like SAS/SATA devices in an
expander or FC devices.  The basic problem with power management of
external devices (whether shared or not) is that it's not just what the
host did to them, it's also what the environment or administrator did to
them.

James


