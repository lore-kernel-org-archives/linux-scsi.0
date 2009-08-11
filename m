From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/7 ver 2] Fix various bugs in the target code
Date: Tue, 11 Aug 2009 10:48:36 -0500
Message-ID: <1250005716.4301.39.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.0908111130220.2562-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41416 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbZHKPsi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2009 11:48:38 -0400
In-Reply-To: <Pine.LNX.4.44L0.0908111130220.2562-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2009-08-11 at 11:32 -0400, Alan Stern wrote:
> This patch (as1276b) fixes two bugs in the SCSI target code and
> explains an obscure requirement:
> 
> 	If we have to wait for an old target to disappear, instead of
> 	calling flush_scheduled_work() the patch calls
> 	schedule_timeout_uninterruptible(1).  After all, whatever is
> 	pinning the old target might not have anything to do with a
> 	workqueue.  Besides, flush_scheduled_work() is prone to
> 	deadlocks and should never be used by drivers.

No for reasons already stated.

> 	__scsi_add_device() called scsi_alloc_target() outside the
> 	protection of the host's scan_mutex, meaning that it might
> 	find an incompletely-initialized target or it might create
> 	a duplicate target.

It's not a bug .. it works.  I'd actually like to kill the scan mutex
because it seems to be the source of quite a few async problems.  I
certainly don't want to extend its tentacles into target allocation.

> 	In scsi_sysfs_add_sdev(), the call to
> 	transport_configure_device() for the target appears wrong,
> 	since it will be called each time a device is added to the
> 	target.  But this is unavoidable for SPI, so a comment is
> 	added to explain the situation.

There's no rule requiring configure to be called once, so no explanation
is really necessary.  I also suspect the SPI case isn't unique.

James


