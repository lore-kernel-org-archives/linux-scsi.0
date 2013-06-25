From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling
 finished
Date: Tue, 25 Jun 2013 17:31:29 +0200
Message-ID: <51C9B7D1.9040702@acm.org>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>   <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>   <51C8A668.3060700@cs.wisc.edu>  <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>  <51C95C79.2080804@acm.org> <1372167923.2806.13.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:40191 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3FYPbc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jun 2013 11:31:32 -0400
In-Reply-To: <1372167923.2806.13.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

On 06/25/13 15:45, James Bottomley wrote:
> On Tue, 2013-06-25 at 11:01 +0200, Bart Van Assche wrote:
>> There is a difference though between moving the EH kthread_stop() call
>> and the patch at the start of this thread: moving the EH kthread_stop()
>> call does not prevent that an ioctl like SG_SCSI_RESET triggers an eh_*
>> callback after scsi_remove_host() has finished. However, the
>> scsi_begin_eh() / scsi_end_eh() functions do prevent that an ioctl can
>> cause an eh_* callback to be invoked after scsi_remove_device() finished.
>
> OK, but this doesn't tell me what you're trying to achieve.
>
> An eh function is allowable as long as the host hadn't had the release
> callback executed.  That means you must have to have a reference to the
> device/host to execute the eh function, which is currently guaranteed
> for all invocations.

That raises a new question: how is an LLD expected to clean up resources 
without triggering a race condition ? What you wrote means that it's not 
safe for an LLD to start cleaning up the resources needed by the eh_* 
callbacks immediately after scsi_remove_device() returns since it it not 
guaranteed that at that time all references to the device have already 
been dropped.

Bart.

