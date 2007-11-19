From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: SCSI dynamic power management
Date: Mon, 19 Nov 2007 11:46:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711191130330.4806-100000@iolanthe.rowland.org>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAB02@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44071 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752307AbXKSQqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 11:46:17 -0500
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAB02@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 19 Nov 2007, Salyzyn, Mark wrote:

> Alan Stern sez:
> > Sure.  But that won't do any good if the requests get held on 
> > the queue
> > (or failed immediately) because the disk is supposedly "suspended".
> > Somehow those requests have to be allowed to proceed while all others 
> > are forced to wait (or to fail).
> 
> Not a failure. Not ready is reported back in a check condition on a
> media based request, a spin-up request is issued, then a subsequent loop
> sits there probing every second with a Test Unit ready to wait for the
> drive to spin back up. There is ample time provided in this path for the
> drive to spin-up.

You're talking about what the stack does now, but I'm talking about 
what it will do once the dynamic power management code is in place.  
Commands won't even get sent to the low-level driver, never mind coming 
back with a check condition status.

Here's how it will work: scsi_prep_state_check() will see that the
device is in a suspended state (probably a substate of SDEV_QUIESCE).  
The return value will depend on the type of suspend:

	For manual suspend or system suspend, the routine simply 
	returns BLKPREP_KILL.

	For autosuspend, the routine will submit a workqueue request
	to autoresume the device and will return BLKPREP_DEFER.

The trick is somehow to allow the START-STOP UNIT commands get past 
this filter.  Is this what the REQ_PREEMPT flag is intended for?

Alan Stern

