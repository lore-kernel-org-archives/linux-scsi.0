From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 14:05:58 -0500
Message-ID: <yq1iq9lkueh.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1002251324200.1686-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:64718 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab0BYTG5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 14:06:57 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002251324200.1686-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 25 Feb 2010 13:28:13 -0500 (EST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ramya Desai <ramya.desai@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> Why is max_sectors changed?  If it is already smaller than the new
Alan> value of max_hw_sectors, shouldn't it remain the same?

We have a lot of legacy device drivers kicking around in the tree so the
default max request size remains the conservative SAFE_MAX_SECTORS
(255).

When a low level driver explicitly tells us that it can support bigger
requests we take the opportunity to increase the soft limit to the block
layer default (1024).

Also, this function is generally called at block device creation time so
it's not like we're overwriting an existing user setting.

-- 
Martin K. Petersen	Oracle Linux Engineering
