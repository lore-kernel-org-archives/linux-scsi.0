From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling finished
Date: Tue, 25 Jun 2013 11:13:38 -0500
Message-ID: <FBC61EDC-F703-4E3F-9980-70D41EE9484F@cs.wisc.edu>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>   <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>   <51C8A668.3060700@cs.wisc.edu>  <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>  <51C95C79.2080804@acm.org> <1372167923.2806.13.camel@dabdike> <51C9B7D1.9040702@acm.org>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59837 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3FYQOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jun 2013 12:14:15 -0400
In-Reply-To: <51C9B7D1.9040702@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>


On Jun 25, 2013, at 10:31 AM, Bart Van Assche <bvanassche@acm.org> wrote:

> On 06/25/13 15:45, James Bottomley wrote:
>> On Tue, 2013-06-25 at 11:01 +0200, Bart Van Assche wrote:
>>> There is a difference though between moving the EH kthread_stop() call
>>> and the patch at the start of this thread: moving the EH kthread_stop()
>>> call does not prevent that an ioctl like SG_SCSI_RESET triggers an eh_*
>>> callback after scsi_remove_host() has finished. However, the
>>> scsi_begin_eh() / scsi_end_eh() functions do prevent that an ioctl can
>>> cause an eh_* callback to be invoked after scsi_remove_device() finished.
>> 
>> OK, but this doesn't tell me what you're trying to achieve.
>> 
>> An eh function is allowable as long as the host hadn't had the release
>> callback executed.  That means you must have to have a reference to the
>> device/host to execute the eh function, which is currently guaranteed
>> for all invocations.
> 
> That raises a new question: how is an LLD expected to clean up resources without triggering a race condition ? What you wrote means that it's not safe for an LLD to start cleaning up the resources needed by the eh_* callbacks immediately after scsi_remove_device() returns since it it not guaranteed that at that time all references to the device have already been dropped.
> 


A callback in the device/target/host (whatever is needed) release function would do this right? If I understand James right, I think he suggested something like this in another mail.

