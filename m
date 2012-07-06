From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v4 2/4] block: add runtime pm helpers
Date: Fri, 06 Jul 2012 09:13:36 +0800
Message-ID: <1341537216.11117.10.camel@minggr>
References: <1341473199-3837-1-git-send-email-ming.m.lin@intel.com>
	 <1341473199-3837-3-git-send-email-ming.m.lin@intel.com>
	 <201207051511.20772.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201207051511.20772.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-07-05 at 15:11 +0200, Rafael J. Wysocki wrote:
> On Thursday, July 05, 2012, Lin Ming wrote:
> > Add runtime pm helper functions:
> > 
> > blk_pm_runtime_init()
> > blk_pre_runtime_suspend()
> > blk_post_runtime_suspend()
> > blk_pre_runtime_resume()
> > blk_post_runtime_suspend()
> 
> What exactly do you need these things for?  Please be specific.

Alan described these functions nicely, copied here.
http://marc.info/?l=linux-kernel&m=133727953025955&w=2

I'll add these function descriptions to the patch log.

====
This is not the way to do it.  The block subsystem should not use 
suspend/resume callbacks.

Instead, there should be block functions that can be called by client
drivers: block_pre_runtime_suspend, block_post_runtime_suspend,
bock_pre_runtime_resume, and block_post_runtime_resume.

They should do something like this:

	block_pre_runtime_suspend:
		If any requests are in the queue, return -EBUSY.
		Otherwise set q->rpm_status to RPM_SUSPENDING and
		return 0.

	block_post_runtime_suspend:
		If the suspend succeeded then set q->rpm_status to 
		RPM_SUSPENDED.  Otherwise set it to RPM_ACTIVE and
		call pm_runtime_mark_last_busy().

	block_pre_runtime_resume:
		Set q->rpm_status to RPM_RESUMING.

	block_post_runtime_resume:
		If the resume succeeded then set q->rpm_status to
		RPM_ACTIVE and call pm_runtime_mark_last_busy() and
		pm_runtime_request_autosuspend().
		Otherwise set q->rpm_status to RPM_SUSPENDED.

There should also be an initialization function for client drivers to
call.  block_runtime_pm_init() should call pm_runtime_mark_last_busy(),
pm_runtime_use_autosuspend(), and pm_runtime_autosuspend().

Next, you have to modify the parts of the block layer that run when a 
new request is added to the queue or a request is removed.

	When a request is added:
		If q->rpm_status is RPM_SUSPENDED, or if q->rpm_status
		is RPM_SUSPENDING and the REQ_PM flag isn't set, call
		pm_runtime_request_resume().

	When a request finishes:
		Call pm_runtime_mark_last_busy().

Next, you have to change the parts of the block layer responsible for
taking a request from the queue and handing it to the lower-level
driver (both peek and get).  If q->rpm_status is RPM_SUSPENDED, they
shouldn't do anything -- act as though the queue is empty.  If
q->rpm_status is RPM_SUSPENDING or RPM_RESUMING, they should hand over
the request only if it has the REQ_PM flag set.

For this to work, the block layer has to know what struct device
pointer to pass to the pm_runtime_* routines.  You'll have to add that
information to the request_queue structure; I guess q->dev can get set
by block_pm_runtime_init().  In fact, when that's done you won't need
q->rpm_status any more.  You'll be able to use q->dev->power.rpm_status
directly, and you won't have to update it because the PM core does that
for you.

(Or maybe it would be easier to make q->rpm_status be a pointer to 
q->dev->power.rpm_status.  That way, if CONFIG_PM_RUNTIME isn't enabled 
or block_runtime_pm_init() hasn't been called, you can have 
q->rpm_status simply point to a static value that is permanently set to 
RPM_ACTIVE.)

I may have left some parts out from this brief description.  Hopefully 
you'll be able to figure out the general idea and get it to work.
====

Thanks,
Lin Ming
