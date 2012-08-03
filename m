From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Thu, 02 Aug 2012 22:01:42 -0500
Message-ID: <501B3F16.3090308@cs.wisc.edu>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com>  <1343897839.5073.7.camel@dabdike.int.hansenpartnership.com>  <CAOAMb1C=fk_Ejm6TwOhoNLhP1TyRJ+QVi93VaqUmxoHsM1iXtQ@mail.gmail.com> <1343900093.5073.15.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37285 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab2HCDB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Aug 2012 23:01:56 -0400
In-Reply-To: <1343900093.5073.15.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Chanho Min <chanho0207@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>

On 08/02/2012 04:34 AM, James Bottomley wrote:
> On Thu, 2012-08-02 at 18:28 +0900, Chanho Min wrote:
>> On Thu, Aug 2, 2012 at 5:57 PM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>>> On Thu, 2012-08-02 at 17:41 +0900, Chanho Min wrote:
>>>> This patch is to fix a oops from a torn down device. When
>>>> scsi_run_queue process starved queues, scsi_request_fn can race with
>>>> scsi_remove_device. In this case, rarely, scsi_request_fn release the
>>>> last reference and set sdev->request_queue to NULL. It result in
>>>> NULL-pointer dereference when spin_unlock is tried with (NULL)->
>>>> queue_lock. We need to add an extra reference to the device on both
>>>> sides of the __blk_run_queue to hold reference until scsi_request_fn
>>>> is finished.
>>>
>>> You need a recent kernel with this patch:
>>>
>>> commit 940f5d47e2f2e1fa00443921a0abf4822335b54d
>>> Author: Bart Van Assche <bvanassche@acm.org>
>>> Date:   Fri Jun 29 15:34:26 2012 +0000
>>>
>>>     [SCSI] Avoid dangling pointer in scsi_requeue_command()
>>>
>>> James
>> It is different from my case. This is occured inside scsi_run_queue
>> and on processing starved_list.
>> Another sdev is obtained from starved_list.
> 
> Does it occur with that patch applied?
> 
> If it does, the likely fix would be to take a copy of the queue ... but
> I'd like to understand why first.  An active command has an automatic
> reference to the sdev_gendev, so it shouldn't be the normal case.  This
> was broken by unprep because it releases the command from the queue and
> drops the reference.  We may have another case like unjprep, but in that
> case, we need to find it ... trying to add extra get/put_device() calls
> will paper over the problem.
> 

I think the problem is that __scsi_remove_device will now wait for
commands to get dequeued and run, before proceeding but we do not take a
device off the starved list until scsi_device_dev_release_usercontext is
run, or maybe thinking about it another way scsi_kill_request does not
remove sdevs from the starved list if the device is being removed.

So lets say we hit the not_ready path in scsi_request_fn and put the
sdev on the starved list. Then we remove the device. We could end up
putting the device in SDEV_DEL, and then calling scsi_request_fn via
blk_cleanup_queue's drain queue call. scsi_request_fn would hit the
scsi_device_online check and fail the IO, but we never took the sdev off
the starved list from what I can tell.

Now, there is no IO in the queue and so __scsi_remove_device continues.
It then calls scsi_device_dev_release_usercontext at the same time some
other thread is calling scsi_run_queue. We then race. scsi_run_queue
splices the starved list with the sdev we are trying to remove and
deletes the list entry from the list and drops the host lock. But then
scsi_device_dev_release_usercontext grabs the host lock and ends up
running the entire function and freeing the queue. Then scsi_run_queue
tries to access the sdev and queue so it can grab the queue lock that
was just freed and kablewy.

