From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error
 handling finished
Date: Thu, 30 Jan 2014 21:58:56 -0800
Message-ID: <1391147936.2181.160.camel@dabdike.int.hansenpartnership.com>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>
	   <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>
	   <51C8A668.3060700@cs.wisc.edu>
	  <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>
	  <51C95C79.2080804@acm.org> <1372167923.2806.13.camel@dabdike>
	 <51C9B7D1.9040702@acm.org>
	 <FBC61EDC-F703-4E3F-9980-70D41EE9484F@cs.wisc.edu>
	 <52EAAC20.2040607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39385 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbaAaF7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jan 2014 00:59:00 -0500
In-Reply-To: <52EAAC20.2040607@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Michael Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2014-01-30 at 20:46 +0100, Bart Van Assche wrote:
> On 06/25/13 18:13, Michael Christie wrote:
> > On Jun 25, 2013, at 10:31 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> >> On 06/25/13 15:45, James Bottomley wrote:
> >>> On Tue, 2013-06-25 at 11:01 +0200, Bart Van Assche wrote:
> >>>> There is a difference though between moving the EH kthread_stop() call
> >>>> and the patch at the start of this thread: moving the EH kthread_stop()
> >>>> call does not prevent that an ioctl like SG_SCSI_RESET triggers an eh_*
> >>>> callback after scsi_remove_host() has finished. However, the
> >>>> scsi_begin_eh() / scsi_end_eh() functions do prevent that an ioctl can
> >>>> cause an eh_* callback to be invoked after scsi_remove_device() finished.
> >>>
> >>> OK, but this doesn't tell me what you're trying to achieve.
> >>>
> >>> An eh function is allowable as long as the host hadn't had the release
> >>> callback executed.  That means you must have to have a reference to the
> >>> device/host to execute the eh function, which is currently guaranteed
> >>> for all invocations.
> >>
> >> That raises a new question: how is an LLD expected to clean up resources
> >> without triggering a race condition ? What you wrote means that it's not
> >> safe for an LLD to start cleaning up the resources needed by the eh_*
> >> callbacks immediately after scsi_remove_device() returns since it it not
> >> guaranteed that at that time all references to the device have already
> >> been dropped.
> >
> > A callback in the device/target/host (whatever is needed) release function
> > would do this right? If I understand James right, I think he suggested
> > something like this in another mail.
> 
> (replying to an e-mail of seven months ago - see also
> http://thread.gmane.org/gmane.linux.scsi/82572/focus=82822)
> 
> Hello Mike,
> 
> Sorry but I'm afraid that making the SCSI core invoke a callback
> function from a device, target or host release function would create a
> new challenge, namely making sure that all these callback functions have
> finished before the module is unloaded that contains the SCSI host
> template and the code implementing such a callback function. That
> challenge is not specific to the SCSI infrastructure but is a general
> question that has not yet been solved in the Linux kernel (see e.g.
> "[PATCH] kobject: provide kobject_put_wait to fix module unload race"
> for a more general discussion about how to ensure that kobject release
> functions are invoked before the module is unloaded that owns the
> release function - http://thread.gmane.org/gmane.linux.kernel/1622885).

For callbacks, that's easy: it's module_get/module_put

> Or maybe this just means that I misunderstood you ?
> 
> In case it is not clear why I'm reviving this discussion: now that the
> "improved eh timeout handler" patch is upstream (commit
> e494f6a728394ab0df194342549ee20e6f0752df) there is an additional way in
> which the SCSI core can invoke an EH function concurrently with or after
> scsi_remove_host() has finished, namely from the TMF work queue
> (tmf_work_q).

But the fundamental guarantee is that the eh thread for the host (the eh
context if you will) has to be dead before the host can be removed and
the module unloaded.  The thread doesn't die until all the work is done.

James


