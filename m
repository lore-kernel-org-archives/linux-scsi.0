From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Actually using the sg table/chain code
Date: Tue, 15 Jan 2008 14:52:00 -0500
Message-ID: <478D0EE0.4070208@garzik.org>
References: <1200412337.9273.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45002 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbYAOTwD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2008 14:52:03 -0500
In-Reply-To: <1200412337.9273.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <Jens.Axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> 	if (BLK_DEF_MAX_SECTORS > max_sectors)
> 		q->max_hw_sectors = q->max_sectors = max_sectors;
>  	else {
> 		q->max_sectors = BLK_DEF_MAX_SECTORS;
> 		q->max_hw_sectors = max_sectors;
> 	}
> }
> 
> So it imposes a maximum possible setting of BLK_DEF_MAX_SECTORS which is
> defined in blkdev.h to .... 1024, thus also forcing the queue down to
> 128 scatterlist entries.
> 
> Once I raised this limit as well, I was able to transfer over 128
> scatterlist elements during benchmark test runs of normal I/O (actually
> kernel compiles seem best, they hit 608 scatterlist entries).
> 
> So my question, is there any reason not to raise this limit to something
> large (like 65536) or even eliminate it altogether?

ISTR a thread long ago, perhaps including Andrea A (as well as Jens), 
where 1024 sectors was arrived upon as a reasonable balance between 
tying up gobs of VM memory on a single command (multiplied, then, across 
N commands), and getting decent per-command throughput.

Jens probably recalls better than I...  but I'm pretty sure that the 
1024 limit played into "being nice with the VM" somehow.

	Jeff


