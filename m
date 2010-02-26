From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 22:37:33 -0500
Message-ID: <yq1ljegk6pu.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1002251436060.1686-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:33476 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935124Ab0BZDh5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 22:37:57 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002251436060.1686-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 25 Feb 2010 14:47:54 -0500 (EST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ramya Desai <ramya.desai@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> BTW, how come you didn't write it like this?

Alan> q->limits.max_hw_sectors = max_sectors;

Alan> 	if (max_sectors < BLK_DEF_MAX_SECTORS)
Alan>       q->limits.max_sectors = max_sectors;
Alan> 	else
Alan>       q->limits.max_sectors = BLK_DEF_MAX_SECTORS;

Alan> For me this is easier to understand.

No particular reason.  Once the test args were swapped the original code
was clear to me.

However, we could do:

	q->limits.max_hw_sectors = max_hw_sectors;
	q->limits.max_sectors = min(max_hw_sectors, BLK_DEF_MAX_SECTORS);

-- 
Martin K. Petersen	Oracle Linux Engineering
