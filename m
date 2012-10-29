From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/7] Fix race between starved list processing and device
 removal
Date: Sun, 28 Oct 2012 19:07:15 -0700
Message-ID: <20121029020715.GH5171@htj.dyndns.org>
References: <508A7B63.60608@acm.org>
 <508A7C6D.8070002@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37809 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab2J2CHU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Oct 2012 22:07:20 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3912872pbb.19
        for <linux-scsi@vger.kernel.org>; Sun, 28 Oct 2012 19:07:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <508A7C6D.8070002@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello, Bart.

On Fri, Oct 26, 2012 at 02:05:01PM +0200, Bart Van Assche wrote:
> The SCSI core maintains a "starved list" per SCSI host. This is a
> list of devices for which one or more requests have been queued
> but that have not yet been passed to the SCSI LLD. The function
> scsi_run_queue() examines all SCSI devices on the starved list.

New paragraph.

> Since scsi_remove_device() can be invoked concurrently with
> scsi_run_queue() it is important to avoid that a SCSI device is
> accessed by that function after it has been freed.

New paragraph.

> Avoid that the
> sdev reference count can drop to zero before the queue is run by
> scsi_run_queue() by inserting a get_device() / put_device() pair
> in that function. Move the code for removing a device from the
> starved list from scsi_device_dev_release_usercontext() to
> __scsi_remove_device() such that it is guaranteed that the newly
> added get_device() call succeeds.
>
> Reported-and-tested-by: Chanho Min <chanho.min@lge.com>
> Reference: http://lkml.org/lkml/2012/8/2/96
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Heh, for some reason, the commit message is a hard read for me but I
think it should do.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
