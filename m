From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: 04 Jun 2003 15:14:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054754103.2360.8.camel@mulgrave>
References: <1054742495.1674.18.camel@mulgrave>
	<20030604165146.GA1426@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:51463 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263854AbTFDTBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2003 15:01:35 -0400
In-Reply-To: <20030604165146.GA1426@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Wed, 2003-06-04 at 12:51, Mike Anderson wrote:
> Doesn't this patch just re-implement in the prep_fn what is already
> being done by sd and sr in there init_command functions.

Yes, it's a precursor to consolidating them.

> Why allow io after online goes to zero. The user could bring the device
> back online if they needed to send IO. I was counting on no IO so we could
> do faster cleanup in the scsi_remove_host function.

Fundamentally, a queue is an asynchronous thing.  It is difficult (but
not imposible) to make the setting offline atomically guarantee no more
commands will be sent down.

However, on a philosophical level, it isn't necessarily desirable. 
Suppose we use offline to disconnect from a mounted filesystem (say
USB/Firewire unplug).  The user level might want to probe the device
before setting the online flag (which will resume the unerrored fs
transactions).

> I having been looking at this, but it is not very clean. To use existing
> common functionality and avoid deadlock from calling back into the
> request_fn the command needs wasted preparation just to use common
> interfaces.

Yes, that's why I think forbidding *all* I/O after offlining is too much
effort.  Offlining should be a precursor to device destruction, but
actual destruction probably relys on detaching the queue from the block
device interface and sitting on it until all use counts drop to zero.

James


