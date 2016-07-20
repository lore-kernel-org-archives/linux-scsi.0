From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 20 Jul 2016 10:08:15 -0400
Message-ID: <20160720140815.GA19045@redhat.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbcGTOIR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2016 10:08:17 -0400
Content-Disposition: inline
In-Reply-To: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On Tue, Jul 19 2016 at  6:57pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Hello Mike,
> 
> If I run a fio data integrity test against kernel v4.7-rc7 then I
> see often that fio reports I/O errors if a path is removed despite
> queue_if_no_path having been set in /etc/multipath.conf. Further
> analysis showed that this happens because during SCSI device removal
> a SCSI device enters state SDEV_CANCEL before the block layer queue
> is marked as "dying". In that state I/O requests submitted to that
> SCSI device are failed with -EIO. The behavior for
> end_clone_request() in drivers/md/dm.c for such requests is as
> follows:
> - With multiqueue support disabled, call __blk_put_request() and ignore
>   the "error" argument passed to end_clone_request().

The __blk_put_request() isn't contributing to this blk-mq problem.  The
need for it is unique to the request_fn case.

> - With multiqueue support enabled, pass the "error" argument to
>   dm_complete_request().

The error arg is passed to dm_complete_request() regardless of queue
type but it is only immediately used by the blk-mq API (via
blk_mq_complete_request).

> Shouldn't end_clone_request() requeue failed requests in both cases
> instead of passing the I/O error to the submitter only if multiqueue
> is enabled?

Pretty sure you'll find it is _not_ blk-mq that is passing the error
up.  (But if I'm proven wrong that will be welcomed news).

The error passed to dm_complete_request() is always used to set
tio->error which is later used by dm_done().  DM core handles errors
later via softirq in dm_done() -- where the error is passed into the
target_type's rq_end_io hook.

So in DM multipath you'll see do_end_io() we do finally act on the error
we got from the lower layer.  And if the error is -EIO, noretry_error()
will return true and -EIO will be returned up the IO stack.

In the end we're relying on SCSI to properly categorize the underlying
faults as retryable vs not -- via SCSI's differentiated IO errors.

Unfortunately I'm not seeing anything that DM multipath can do
differently here.  -EIO is _always_ propagated up.

It is strange that all the dm-mq testing that has been done didn't ever
catch this.  The mptest testsuite is a baseline for validating DM
multipath (and request-based DM core) changes.  But I've also had Red
Hat's QE hammer dm-mq with heavy IO (in terms of the "dt" utility) on a
larger NetApp testbed in the face of regular controller faults.

Must be this scenario of SDEV_CANCEL is a race that is relatively
unique/rare to your testbed?

This raises the question: should SCSI be returning something other than
-EIO for this case?  E.g. an error that is retryable?

Mike
