From: Jens Axboe <axboe@suse.de>
Subject: Re: Maximum_transfer_size and SCSI request buffer size parameters
Date: Thu, 24 Jul 2003 17:35:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030724153505.GC1063@suse.de>
References: <Pine.LNX.4.44L0.0307241035140.720-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:24718 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S271691AbTGXP1K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 11:27:10 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307241035140.720-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>, Harald Dunkel <harri@synopsys.COM>

On Thu, Jul 24 2003, Alan Stern wrote:
> I'm trying to solve the problem of a user whose USB disk drive crashes
> when it is asked to write 512K bytes in a single command.  A good way to
> solve this problem would be to have a maximum_transfer_size field as part 
> of the scsi_device structure.  Is it worthwhile adding such a feature?

First of all, you don't mention what kernel version you are talking
about...

Anyways, the feature is already there. It's called max_sectors, and it's
even in the host template for you to set. That handles block layer
requests, at least.

> In sd.c and sr.c, scmd->request_bufflen is the number of bytes to
> transfer.  Both files use the variable this_count to compute the number
> of sectors, stored in the command's CDB.  this_count is based on
> request_bufflen, but the values can disagree.  For example, if READ(6)  
> is used and request_bufflen corresponds to more than 255 sectors, 
> this_count will be reduced to 255.

That is in purpose, for cases like that you have to only do a part of
the entire request.

> Furthermore, sr.c goes to the trouble of adding up the lengths of all the
> scatter-gather blocks, and if the total disagrees with request_bufflen it
> sets request_bufflen equal to the total -- but it does this after storing
> this_count in the CDB.

It's a bug if they differ, that's why there's a printk there. Might be a
good idea to make that a harder error, though.

> A related issue is that in both sd.c and sr.c, the rw_intr() routine
> identifies the number of sectors correctly transferred as scmd->bufflen
> (if no error occurred).  Normally bufflen is initialized equal to
> request_bufflen.  But if this_count has been altered, the number of
> sectors will be different from bufflen.

The device will not transfer more data than what it is told from the
cdb. Aren't you getting a completed byte count from your hardware? Or
are you blindly assuming the device transferred what you initially told
you?

> If nobody objects, I will work on a patch to fix these problems.

Well..

-- 
Jens Axboe

