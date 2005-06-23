From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] scsi host / scsi target state model update
Date: Thu, 23 Jun 2005 11:57:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506231118520.5737-100000@iolanthe.rowland.org>
References: <20050622234659.GA572@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:28394 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S262588AbVFWP5k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 11:57:40 -0400
In-Reply-To: <20050622234659.GA572@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 22 Jun 2005, Mike Anderson wrote:

> Alan Stern [stern@rowland.harvard.edu] wrote:
> > Mike:
> > 
> > In your first patch, you don't allow transitions from SHOST_RECOVERY to 
> > SHOST_CANCEL nor the other way around.  So this section of the patch looks 
> > suspicious:
> > 
> 
> Yes the host state model may need to allow this transition. The rest of
> the patch series removes scsi_host_cancel so I was not running this
> function when the series was fully applied.

I hadn't read the later patches when I wrote that last message.  Okay, it 
makes more sense now.  And yes, that transition is needed.

> > In fact there are lots of places in the patch where scsi_host_set_state 
> > is called and the return value is not checked.  They may end up causing 
> > trouble.
> > 
> 
> Yes, I am not sure what checking a return value will do in all cases (like
> in scsi_remove_host). I notice that most of scsi_device_set_state cases
> are not checked or have void function wrappers. It would appear that these
> functions (scsi_device_set_state and scsi_host_set_state) should be void
> functions with WARN_ONs to go correct the state model or the calling
> function.

That sounds like a good idea.  Just about everywhere those routines are 
called, the state transitions are mandatory.  Simply returning an error 
doesn't accomplish anything.


After reading through the complete set of your patches and comparing them
to my own, here's what I came up with:

     1. You didn't audit all the places where devices or targets
	can be added to make sure the scan_mutex is held and the host
	state is checked.  You missed the target creation in
	__scsi_add_device, the scsi_scan_target routine (needs
	separate public and private entry points, where the private
	entry point already owns the mutex), and target and device
	creation in scsi_get_host_dev.

     2. You didn't create separate public and private entry points for
	scsi_remove_device, again where the private entry point already
	owns the mutex.  Checking the host state isn't required since
	there's nothing wrong with removing a device during host removal.

     3. __scsi_add_device returns garbage if the host state check fails.

     4. You implemented a state model for targets, and allowed
	scsi_forget_host continue to remove all the targets.  This is
	not consistent with the way targets are refcounted and reaped
	automatically when their last child is gone.  James has said
	that targets shouldn't be part of a state model -- this needs
	to be settled one way or the other.

     5. Although the loop in scsi_forget_host doesn't use
	list_for_each_entry_safe and restarts after each change, the
	loop in __scsi_remove_target needs to be changed similarly.

     6.	In scsi_probe_and_add_lun there's an unchecked call to
	scsi_device_get.  If that call fails, the device needs to
	be removed.

You can determine the details for most of these by comparing my patch 
against yours.

Alan Stern

