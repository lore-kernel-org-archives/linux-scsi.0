From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [OOPS] 2.6.11 - NMI lockup with CFQ scheduler
Date: Wed, 06 Apr 2005 14:20:07 -0400
Message-ID: <1112811607.5555.15.camel@mulgrave>
References: <20050329115405.97559.qmail@web52909.mail.yahoo.com>
	 <20050329120311.GO16636@suse.de> <1112804840.5476.16.camel@mulgrave>
	 <20050406175838.GC15165@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5785 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262273AbVDFSUS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2005 14:20:18 -0400
In-Reply-To: <20050406175838.GC15165@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Chris Rankin <rankincj@yahoo.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-04-06 at 19:58 +0200, Jens Axboe wrote:
> I rather like the queue lock being a pointer, so you can share at
> whatever level you want. Lets not grow the request_queue a full lock
> just to work around a bug elsewhere.

I'm not proposing that it not be a pointer, merely that it could be
intialiased to point to a lock structure within the request queue.

Doing this looks much simpler than your current patch ... one of the
problems with which looks to be that removing the scsi_driver module is
in trouble because we currently have the queue_release in the sdev
release (which won't get called while the queue holds a reference).

I think the correct model for all of this is that the block driver
shouldn't care (or be tied to) the scsi one.  Thus, as long as SCSI can
reject requests from a queue whose device has been released (without
checking the device) then everything is fine as long as we sort out the
lock lifetime problem.

James

