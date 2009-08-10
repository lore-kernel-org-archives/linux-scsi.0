From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/7] Fix various bugs in the target code
Date: Mon, 10 Aug 2009 10:53:20 -0500
Message-ID: <1249919600.4089.111.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.0908101104080.3208-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48986 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755483AbZHJPxW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2009 11:53:22 -0400
In-Reply-To: <Pine.LNX.4.44L0.0908101104080.3208-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2009-08-10 at 11:08 -0400, Alan Stern wrote:
> This patch (as1276) fixes some bugs in the SCSI target code:
> 
> 	In scsi_alloc_target(), a newly-created target was added to
> 	the host's list of targets before the host's target_alloc()
> 	method was called.

So this one is the design way the target code works:  allocate and add
first so the transport and target code have a fully usable device.

> 	In the same routine, if a match was found with an old target
> 	in the DEL state then that target's reap_ref was mistakenly
> 	incremented.  This is harmless, but it shouldn't happen.

It's required for the state != DEL case ... the reap_ref loses
significance after the state moves to DEL, so it's by design.

> 	If we have to wait for an old target to disappear, instead of
> 	calling flush_scheduled_work() the patch calls
> 	schedule_timeout_uninterruptible(1).  After all, whatever is
> 	pinning the old target might not have anything to do with a
> 	workqueue.  Besides, flush_scheduled_work() is prone to
> 	deadlocks and should never be used by drivers.

I don't really buy this; it's not (yet) a documented restriction of
flush_scheduled_work() and we have a few drivers using it.  It only
deadlocks if you call it from a running workqueue.

> 	scsi_target_reap() changed starget->state outside the
> 	protection of the host lock.

So does everything else that manipulates the target state.

> 	__scsi_add_device() called scsi_alloc_target() outside the
> 	protection of the host's scan_mutex, meaning that it might
> 	find an incompletely-initialized target or it might create
> 	a duplicate target.

scan mutex isn't used as a determinant for this.  There can be a slight
race in initialisation, but really, it isn't important.

> 	scsi_sysfs_add_sdev() would call transport_configure_device()
> 	for a target each time a new device was added under that
> 	target.  The call has been moved to scsi_target_add(), where
> 	it will be made only once.

That, unfortunately is an SPI required feature ... we can't actually
configure the target until we have a device because of the way SPI
parameters work.

James


