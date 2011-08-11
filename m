From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
Date: Thu, 11 Aug 2011 10:05:31 -0500
Message-ID: <1313075131.4166.10.camel@mulgrave>
References: <Pine.LNX.4.44L0.1108111056540.1958-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49020 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419Ab1HKPFe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2011 11:05:34 -0400
In-Reply-To: <Pine.LNX.4.44L0.1108111056540.1958-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, jaxboe@fusionio.com, roland@purestorage.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

On Thu, 2011-08-11 at 10:59 -0400, Alan Stern wrote:
> On Thu, 11 Aug 2011, James Bottomley wrote:
> 
> > > If the reason you moved scsi_free_queue into scsi_remove_device
> > > is marking the queue dead, how about the following patch?
> > > Do you think it's acceptable?
> > 
> > Well, it's just hiding the problem.  The essential problem is that only
> > block has the correctly refcounted knowledge to know the last release of
> > the queue reference.  Until that time, the holder of the reference can
> > use the queue regardless of whether blk_cleanup_queue() has been called.
> > This is the race you complain about since use of the queue involves the
> > lock which should be guarded by QUEUE_DEAD checks.
> > 
> > This is essentially unfixable with function calls.  The only way to fix
> > it is to have a callback model for freeing the external lock.
> 
> Assuming the queue is associated with a device, the queue could take a
> reference to the device, dropping that reference when the queue is
> freed.  Then the lock could safely be freed at the same time as the 
> device.

If that assumption is correct, there's no point refcounting the queue at
all because its use is entirely subordinated to the lifecycle of the
associated device.  Plus all the wittering about my previous patch is
pointless, because blk_cleanup_queue() has to do the final put of the
queue in the lock free path (otherwise the assumption is violated).

However, much as I'd like to accept this rosy view, the original oops
that started all of this in 2.6.38 was someone caught something with a
reference to a SCSI queue after the device release function had been
called.

James


