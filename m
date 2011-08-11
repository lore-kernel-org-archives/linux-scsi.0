From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
Date: Thu, 11 Aug 2011 09:33:47 -0500
Message-ID: <1313073227.4166.6.camel@mulgrave>
References: <4E420941.3080601@ce.jp.nec.com>
	 <1313005933.2785.12.camel@mulgrave> <4E432122.9050101@ce.jp.nec.com>
	 <4E4345F1.9040501@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57887 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab1HKOdu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2011 10:33:50 -0400
In-Reply-To: <4E4345F1.9040501@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: jaxboe@fusionio.com, roland@purestorage.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

On Thu, 2011-08-11 at 12:01 +0900, Jun'ichi Nomura wrote:
> Hi James,
> 
> On 08/11/11 09:24, Jun'ichi Nomura wrote:
> > On 08/11/11 04:52, James Bottomley wrote:
> >> On Wed, 2011-08-10 at 13:29 +0900, Jun'ichi Nomura wrote:
> >>>   2) SCSI to call blk_cleanup_queue() from device's ->release() callback
> >>>      (before 2.6.39, it used to work like this)
> >>>      https://lkml.org/lkml/2011/7/2/106
> >>
> >> Well, they both have documented objections.  I asked why we destroy the
> >> elevator in the del case and didn't get any traction, so let me show the
> >> actual patch which should fix all of these issues.
> >>
> >> Is there a good reason for not doing this as a bug fix now?
> ...
> > I think it doesn't work because elevator_exit() and
> > blk_throtl_exit() take &q->queue_lock, which may be freed
> > by LLD after blk_cleanup_queue, before blk_release_queue.
> 
> If the reason you moved scsi_free_queue into scsi_remove_device
> is marking the queue dead, how about the following patch?
> Do you think it's acceptable?

Well, it's just hiding the problem.  The essential problem is that only
block has the correctly refcounted knowledge to know the last release of
the queue reference.  Until that time, the holder of the reference can
use the queue regardless of whether blk_cleanup_queue() has been called.
This is the race you complain about since use of the queue involves the
lock which should be guarded by QUEUE_DEAD checks.

This is essentially unfixable with function calls.  The only way to fix
it is to have a callback model for freeing the external lock.

