From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] drivers/scsi/qla1280.c; was Re: Buffered I/O to block device very slow and other SCSI issues...
Date: Mon, 12 May 2008 21:43:25 +1000
Message-ID: <20080512114325.GI155679365@sgi.com>
References: <20080319231654.GA103321673@sgi.com> <20080320010807.GA27620@sgi.com> <20080320032010.e640c52a.akpm@linux-foundation.org> <20080512061703.GC41683@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:59176 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751460AbYELLnn (ORCPT
	<rfc822;@relay.sgi.com:linux-scsi@vger.kernel.org>);
	Mon, 12 May 2008 07:43:43 -0400
Content-Disposition: inline
In-Reply-To: <20080512061703.GC41683@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, jes@sgi.com

On Sun, May 11, 2008 at 11:17:03PM -0700, Jeremy Higdon wrote:
> On Thu, Mar 20, 2008 at 03:20:10AM -0700, Andrew Morton wrote:
> > > > I also suspect that CTQ has not been set up correctly on this
> > > > kernel, because:
> > > > 
> > > > $ cat /sys/block/sdb/device/queue_depth
> > > > 3
> > > > $ ls -l /sys/block/sdb/device/queue_depth
> > > > -r--r--r-- 1 root root 0 Mar 20 09:59 /sys/block/sdb/device/queue_depth
> > > > $
> > > > 
> > > > It appears to be hard coded to 3 and can't be changed....
> > > 
> > > That's a bug in the qla1280 driver.  I thought that had gotten fixed.
> > > It's looking at the wrong mailbox register after setting device parameters.
> > 
> > Was there a patch anywhere?
> 
> Promised patch...
....
> After the fix, I found that my disks were getting a queue depth of
> 255, which is far too many.  Most SCSI disks are limited to 32 or
> 64.  In any case, there's no point, queueing up a bunch of commands
> to the adapter that will just result in queue full or starve other
> targets from being issued commands due to running out of internal
> memory.  So I dropped default queue depth to 32 (from which 1 is
> subtracted elsewhere, giving net of 31).
> 
> I tested with a Seagate ST336753LC, and results look good, so
> I'm satisfied with this patch.
> 
> Signed-off-by: Jeremy Higdon <jeremy@sgi.com>

Works fine here.

Tested-by: Dave Chinner <dgc@sgi.com>

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
