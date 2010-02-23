From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Tue, 23 Feb 2010 12:00:13 -0500
Message-ID: <yq1aauzopk2.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1002231143450.1308-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:16566 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0BWRBF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 12:01:05 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002231143450.1308-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Tue, 23 Feb 2010 11:49:21 -0500 (EST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ramya Desai <ramya.desai@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> James or Jens, is there a reason why this routine limits
Alan> max_sectors to 1024?

Alan> And is there a reason why it sets both max_sectors and
Alan> max_hw_sectors, leaving no way to change one without the other?

The rationale being that we don't want the default value to be too large
because it makes I/O choppy on single-spindle setups.  

If the device driver supports bigger requests we set the hard limit to
whatever they support.  But filesystem I/O is capped at the default
limit which is 1024 for modern devices (and 255 for crappy ones).

You can change the current soft limit on a per-device basis in
/sys/block/<dev>/queue/max_sectors_kb.

I agree it would be nice to have a system-wide default that's not a
#define.  But given that a lot of queues are created early that's not so
easy to do.


Alan> Are drivers supposed to assign values directly to
Alan> q-> limits.max_sectors?  Shouldn't there be a cleaner API for all
Alan> this?

Drivers are supposed to set the hard limit.  The soft limit is a
fs/block layer value and none of the device driver's business.

-- 
Martin K. Petersen	Oracle Linux Engineering
