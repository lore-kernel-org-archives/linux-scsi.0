From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v11 2/9] Remove get_device() / put_device() pair from
 scsi_request_fn()
Date: Mon, 24 Jun 2013 13:34:46 +0000
Message-ID: <1372080885.2013.10.camel@dabdike.int.hansenpartnership.com>
References: <51B86E26.6030108@acm.org> <51B86EB5.8030602@acm.org>
	 <1372041391.2386.20.camel@dabdike> <51C7F18C.7010904@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:40698 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3FXNes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 09:34:48 -0400
In-Reply-To: <51C7F18C.7010904@acm.org>
Content-Language: en-US
Content-ID: <2466BCE82A1BA341B979DD57AE873B3E@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

On Mon, 2013-06-24 at 09:13 +0200, Bart Van Assche wrote:
> On 06/24/13 04:36, James Bottomley wrote:
> > On Wed, 2013-06-12 at 14:51 +0200, Bart Van Assche wrote:
> >> Now that all scsi_request_fn() callers hold a reference on the
> >> SCSI device that function is invoked for
> >
> > What makes you think that this is a true statement?  The usual caller is
> > the block layer, which doesn't really know anything about the
> > sdev->sdev_gendev.
> 
> The reasoning behind that comment is as follows:
> * The block layer guarantees that the reference count of a request
>    queue is >= 1 as long as a request_fn() call is in progress (see also
>    blk_cleanup_queue(), the __blk_drain_queue() call in that function
>    and the loop in __blk_drain_queue() that waits until
>    request_fn_active == 0).
> * The SCSI core guarantees that blk_cleanup_queue() is invoked before
>    the final put on sdev->sdev_gendev.

That's still unclear.

I think a clear explanation is something like:

        scsi_devices may only be removed by by scsi_remove_device()
        which has a call to blk_cleanup_queue() before the final put of
        sdev->sdev_gendev.  Since blk_cleanup_queue() waits for the
        block queue to drain and then tears it down, scsi_request_fn
        cannot be active once blk_cleanup_queue() returns and hence the
        get_device/put_device pairs in scsi_request_fn are unnecessary
        because the final put will always be done by
        scsi_remove_device().

This, by the way, is an optimisation not a fix, so it shouldn't really
be part of a series labelled "device removal fixes"

James


