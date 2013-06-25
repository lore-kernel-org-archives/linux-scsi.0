From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling
 finished
Date: Tue, 25 Jun 2013 11:01:45 +0200
Message-ID: <51C95C79.2080804@acm.org>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>  <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>  <51C8A668.3060700@cs.wisc.edu> <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:39025 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3FYJBu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jun 2013 05:01:50 -0400
In-Reply-To: <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

On 06/25/13 00:27, James Bottomley wrote:
> On Mon, 2013-06-24 at 15:04 -0500, Mike Christie wrote:
>> On 06/24/2013 02:19 PM, James Bottomley wrote:
>>> On Wed, 2013-06-12 at 14:55 +0200, Bart Van Assche wrote:
>>>> A SCSI LLD may start cleaning up host resources as soon as
>>>> scsi_remove_host() returns. These host resources may be needed by
>>>> the LLD in an implementation of one of the eh_* functions. So if
>>>> one of the eh_* functions is in progress when scsi_remove_host()
>>>> is invoked, wait until the eh_* function has finished. Also, do
>>>> not invoke any of the eh_* functions after scsi_remove_host() has
>>>> started.
>>>
>>> We already have state guards for this, don't we?  That's the
>>> SHOST_*_RECOVERY ones.  When eh functions are active, the host
>>> transitions to a recovery state, so the wait could just wait on that
>>> state rather than implement an open coded counting semaphore.
>>
>> That seems better. For the sg_reset_provider case we just would have to
>> also wait on the tmf_in_progress bit.
>
> The simplest way is may just be to move the kthread_stop() from release
> to remove.  That synchronously waits for the outstanding error handling
> to complete and the eh thread to stop.  Perhaps the eh thread should
> also wait for tmf in progress before it dies?

Regarding TMF that are in progress: my preference is to leave it to the 
LLD to wait for any TMF in progress if necessary. At least with SRP over 
RDMA it is possible to prevent receiving further TMF completion 
notifications by closing the connection over which these TMF were sent.

There is a difference though between moving the EH kthread_stop() call 
and the patch at the start of this thread: moving the EH kthread_stop() 
call does not prevent that an ioctl like SG_SCSI_RESET triggers an eh_* 
callback after scsi_remove_host() has finished. However, the 
scsi_begin_eh() / scsi_end_eh() functions do prevent that an ioctl can 
cause an eh_* callback to be invoked after scsi_remove_device() finished.

Bart.


