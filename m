From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Thu, 17 May 2012 14:56:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205171448190.1169-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47552 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762376Ab2EQS45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 14:56:57 -0400
In-Reply-To: <Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 17 May 2012, Alan Stern wrote:

> On Thu, 17 May 2012, Lin Ming wrote:
> 
> > Add runtime pm suspend/resume callbacks to request queue.
> > As an example, implement these callbacks in sd driver.
> 
> This is not the way to do it.  The block subsystem should not use 
> suspend/resume callbacks.
> 
> Instead, there should be block functions that can be called by client
> drivers: block_pre_runtime_suspend, block_post_runtime_suspend,
> bock_pre_runtime_resume, and block_post_runtime_resume.
> 
> They should do something like this:
> 
> 	block_pre_runtime_suspend:
> 		If any requests are in the queue, return -EBUSY.
> 		Otherwise set q->rpm_status to RPM_SUSPENDING and
> 		return 0.
> 
> 	block_post_runtime_suspend:
> 		If the suspend succeeded then set q->rpm_status to 
> 		RPM_SUSPENDED.  Otherwise set it to RPM_ACTIVE and
> 		call pm_runtime_mark_last_busy().
> 
> 	block_pre_runtime_resume:
> 		Set q->rpm_status to RPM_RESUMING.
> 
> 	block_post_runtime_resume:
> 		If the resume succeeded then set q->rpm_status to
> 		RPM_ACTIVE and call pm_runtime_mark_last_busy() and
> 		pm_runtime_request_autosuspend().
> 		Otherwise set q->rpm_status to RPM_SUSPENDED.
> 
> There should also be an initialization function for client drivers to
> call.  block_runtime_pm_init() should call pm_runtime_mark_last_busy(),
> pm_runtime_use_autosuspend(), and pm_runtime_autosuspend().
> 
> Next, you have to modify the parts of the block layer that run when a 
> new request is added to the queue or a request is removed.
> 
> 	When a request is added:
> 		If q->rpm_status is RPM_SUSPENDED, or if q->rpm_status
> 		is RPM_SUSPENDING and the REQ_PM flag isn't set, call
> 		pm_runtime_request_resume().
> 
> 	When a request finishes:
> 		Call pm_runtime_mark_last_busy().
> 
> Next, you have to change the parts of the block layer responsible for
> taking a request from the queue and handing it to the lower-level
> driver (both peek and get).  If q->rpm_status is RPM_SUSPENDED, they
> shouldn't do anything -- act as though the queue is empty.  If
> q->rpm_status is RPM_SUSPENDING or RPM_RESUMING, they should hand over
> the request only if it has the REQ_PM flag set.
> 
> For this to work, the block layer has to know what struct device
> pointer to pass to the pm_runtime_* routines.  You'll have to add that
> information to the request_queue structure; I guess q->dev can get set
> by block_pm_runtime_init().  In fact, when that's done you won't need
> q->rpm_status any more.  You'll be able to use q->dev->power.rpm_status
> directly, and you won't have to update it because the PM core does that
> for you.
> 
> (Or maybe it would be easier to make q->rpm_status be a pointer to 
> q->dev->power.rpm_status.  That way, if CONFIG_PM_RUNTIME isn't enabled 
> or block_runtime_pm_init() hasn't been called, you can have 
> q->rpm_status simply point to a static value that is permanently set to 
> RPM_ACTIVE.)
> 
> I may have left some parts out from this brief description.  Hopefully 
> you'll be able to figure out the general idea and get it to work.

Oh, yes -- I knew I had forgotten something.

The client driver has to be changed.  That means scsi_sysfs_add_sdev() 
should call block_pm_runtime_init().

scsi_runtime_suspend() should call block_pre_runtime_suspend() and fail
if that routine returns an error.  Then after calling
scsi_dev_type_suspend(), it should call block_post_runtime_suspend() 
to let it know whether the suspend operation succeeded.

Similarly, scsi_runtime_resume() should call block_pre_runtime_resume() 
before scsi_dev_type_resume() and block_post_runtime_resume() 
afterward.

Once that's done, you can remove the scsi_autpm stuff from sd_open() 
and sd_release().

Alan Stern

