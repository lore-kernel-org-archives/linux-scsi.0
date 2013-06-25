From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error
 handling finished
Date: Tue, 25 Jun 2013 10:40:57 -0700
Message-ID: <1372182057.2806.43.camel@dabdike>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>
	   <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>
	   <51C8A668.3060700@cs.wisc.edu>
	  <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>
	  <51C95C79.2080804@acm.org> <1372167923.2806.13.camel@dabdike>
	 <51C9B7D1.9040702@acm.org>
	 <FBC61EDC-F703-4E3F-9980-70D41EE9484F@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37619 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab3FYRk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 13:40:59 -0400
In-Reply-To: <FBC61EDC-F703-4E3F-9980-70D41EE9484F@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

On Tue, 2013-06-25 at 11:13 -0500, Michael Christie wrote:
> On Jun 25, 2013, at 10:31 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> 
> > On 06/25/13 15:45, James Bottomley wrote:
> >> On Tue, 2013-06-25 at 11:01 +0200, Bart Van Assche wrote:
> >>> There is a difference though between moving the EH kthread_stop() call
> >>> and the patch at the start of this thread: moving the EH kthread_stop()
> >>> call does not prevent that an ioctl like SG_SCSI_RESET triggers an eh_*
> >>> callback after scsi_remove_host() has finished. However, the
> >>> scsi_begin_eh() / scsi_end_eh() functions do prevent that an ioctl can
> >>> cause an eh_* callback to be invoked after scsi_remove_device() finished.
> >> 
> >> OK, but this doesn't tell me what you're trying to achieve.
> >> 
> >> An eh function is allowable as long as the host hadn't had the release
> >> callback executed.  That means you must have to have a reference to the
> >> device/host to execute the eh function, which is currently guaranteed
> >> for all invocations.
> > 
> > That raises a new question: how is an LLD expected to clean up resources without triggering a race condition ? What you wrote means that it's not safe for an LLD to start cleaning up the resources needed by the eh_* callbacks immediately after scsi_remove_device() returns since it it not guaranteed that at that time all references to the device have already been dropped.
> > 
> 
> 
> A callback in the device/target/host (whatever is needed) release
> function would do this right? If I understand James right, I think he
> suggested something like this in another mail.

Exactly ... at least that's what we should do.

If I look at what we actually do: all the HBAs treat scsi_remove_host as
a waited for transition.  The reason this works is the loop over
__scsi_remove_device() in scsi_forget_host().  By the time that loop
returns, every scsi_device is gone (and so is every target).  Because
blk_cleanup_queue() induces a synchronous wait for the queue to die in
__scsi_remove_device(), there can be no outstanding I/O and no eh
activity for the device when it returns (and no possibility of starting
any).  Thus at the end of scsi_forget_host, we have no devices to start
I/O and no eh activity, so the final put will be the last.

James




