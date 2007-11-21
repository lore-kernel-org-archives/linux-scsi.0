From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SCSI dynamic power management
Date: Wed, 21 Nov 2007 13:56:44 +0100
Message-ID: <20071121125643.GN6956@kernel.dk>
References: <20071119154650.GC12494@parisc-linux.org> <Pine.LNX.4.44L0.0711191054360.4806-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:20019 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXKUM7r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 07:59:47 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711191054360.4806-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Nov 19 2007, Alan Stern wrote:
> On Mon, 19 Nov 2007, Matthew Wilcox wrote:
> 
> > On Mon, Nov 19, 2007 at 10:36:19AM -0500, Alan Stern wrote:
> > > These are conflicting requirements.  How can we send the START-STOP 
> > > UNIT commands to spin the disk up/down through the request queue while 
> > > delaying or failing all others?
> > 
> > You can insert commands at the head of a request queue.
> 
> Sure.  But that won't do any good if the requests get held on the queue
> (or failed immediately) because the disk is supposedly "suspended".
> Somehow those requests have to be allowed to proceed while all others 
> are forced to wait (or to fail).

Yeah, head-of-queue or not has no relevance. But the SCSI layer has had
the notion of 'allow some commands, disallow others' for quite some time
already - grep for REQ_PREEMPT in scsi/

-- 
Jens Axboe

