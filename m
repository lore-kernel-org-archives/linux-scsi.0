From: Christoph Hellwig <hch@lst.de>
Subject: Re: CPU lock-ups with 4.12.0+ kernels related to usb_storage
Date: Wed, 12 Jul 2017 18:52:00 +0200
Message-ID: <20170712165200.GA29145@lst.de>
References: <2b6dc4b0-71c8-28cb-383d-c01a9e896c7a@internode.on.net> <Pine.LNX.4.44L0.1707121152211.2118-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58207 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753723AbdGLQwC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Jul 2017 12:52:02 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1707121152211.2118-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>, Christoph Hellwig <hch@lst.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Wed, Jul 12, 2017 at 12:10:02PM -0400, Alan Stern wrote:
> This is pretty conclusive.  The problem comes about because
> usb_stor_control_thread() calls scsi_mq_done() while holding
> shost->host_lock, and then scsi_eh_scmd_add() tries to acquire that
> same lock.
> 
> I don't know why this didn't show up in earlier kernels.  I guess some
> element of the call chain listed above must be new in 4.12.
> 
> Christoph, what's the best way to fix this?  Should usb-storage release
> the host lock before issuing the ->scsi_done callback?  If so, does
> that change need to be applied to any kernels before 4.12?

4.12 switched to blk-mq by default, and while the old code used
a softirq for completions, which is always a difference context
the blk-mq code might execute in the same context it's called in.

So yes, for that we'd need to drop host_lock.  But I wonder how
many more of these are lingering somewhere and if we can find
another workaround.
