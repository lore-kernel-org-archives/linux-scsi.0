From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 11:37:49 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002251132170.1686-100000@iolanthe.rowland.org>
References: <yq1aauzopk2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52988 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932884Ab0BYQhy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 11:37:54 -0500
In-Reply-To: <yq1aauzopk2.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ramya Desai <ramya.desai@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Tue, 23 Feb 2010, Martin K. Petersen wrote:

> Alan> Are drivers supposed to assign values directly to
> Alan> q-> limits.max_sectors?  Shouldn't there be a cleaner API for all
> Alan> this?
> 
> Drivers are supposed to set the hard limit.  The soft limit is a
> fs/block layer value and none of the device driver's business.

_How_ are drivers supposed to set the hard limit?

If they call blk_queue_max_sectors() then both the hard and soft limits 
are affected, but at least the hard limit is set correctly.

If they call blk_queue_max_hw_sectors() then only the hard limit is 
affected, but it cannot be set to a value less than 1024 
(BLK_DEF_MAX_SECTORS).  Wouldn't it be more logical to allow the hard 
limit to be set to anything at least as large as the page size, and 
decrease the soft limit if it is larger than the new hard limit?

Alan Stern

