From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 2/9] Remove get_device() / put_device() pair from
 scsi_request_fn()
Date: Mon, 24 Jun 2013 17:43:01 +0200
Message-ID: <51C86905.6000904@acm.org>
References: <51B86E26.6030108@acm.org> <51B86EB5.8030602@acm.org>  <1372041391.2386.20.camel@dabdike> <51C7F18C.7010904@acm.org> <1372080885.2013.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:55365 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3FXPnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 11:43:10 -0400
In-Reply-To: <1372080885.2013.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

On 06/24/13 15:34, James Bottomley wrote:
> On Mon, 2013-06-24 at 09:13 +0200, Bart Van Assche wrote:
>> On 06/24/13 04:36, James Bottomley wrote:
>>> On Wed, 2013-06-12 at 14:51 +0200, Bart Van Assche wrote:
>>>> Now that all scsi_request_fn() callers hold a reference on the
>>>> SCSI device that function is invoked for
>>>
>>> What makes you think that this is a true statement?  The usual caller is
>>> the block layer, which doesn't really know anything about the
>>> sdev->sdev_gendev.
>>
>> The reasoning behind that comment is as follows:
>> * The block layer guarantees that the reference count of a request
>>     queue is >= 1 as long as a request_fn() call is in progress (see also
>>     blk_cleanup_queue(), the __blk_drain_queue() call in that function
>>     and the loop in __blk_drain_queue() that waits until
>>     request_fn_active == 0).
>> * The SCSI core guarantees that blk_cleanup_queue() is invoked before
>>     the final put on sdev->sdev_gendev.
>
> That's still unclear.
>
> I think a clear explanation is something like:
>
>          scsi_devices may only be removed by by scsi_remove_device()
>          which has a call to blk_cleanup_queue() before the final put of
>          sdev->sdev_gendev.  Since blk_cleanup_queue() waits for the
>          block queue to drain and then tears it down, scsi_request_fn
>          cannot be active once blk_cleanup_queue() returns and hence the
>          get_device/put_device pairs in scsi_request_fn are unnecessary
>          because the final put will always be done by
>          scsi_remove_device().
>
> This, by the way, is an optimisation not a fix, so it shouldn't really
> be part of a series labelled "device removal fixes"

Thanks for the feedback. I will update the patch description and take 
this patch out of the device removal fixes patch series.

Bart.

