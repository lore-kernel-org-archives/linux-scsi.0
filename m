From: Mark Lord <lkml@rtr.ca>
Subject: Re: HDIO_DRIVE_CMD and hdparm
Date: Thu, 10 May 2007 09:20:18 -0400
Message-ID: <46431C12.1030207@rtr.ca>
References: <Pine.LNX.4.62.0705101327170.759@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:3019 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760857AbXEJNUT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2007 09:20:19 -0400
In-Reply-To: <Pine.LNX.4.62.0705101327170.759@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Geert Uytterhoeven wrote:
> 	Hi,
> 
> `hdparm -t' uses HDIO_DRIVE_CMD(null) to flush the disk's buffer.

More correctly, that command is supposed to act like an I/O queue "barrier"
operation, not returning from the syscall until everything queued in front
of it has been issued/completed.

I believe that only the original IDE driver actually implements it, though.
And hdparm-7.4 (not released yet) will no longer complain about ENOTTY.

Note that current versions of hdparm use SG_IO/ATA_16 (SAT) for nearly everything
now, only falling back to the older ioctl's for drivers which reject the SAT attempt.

I'd love to find a USB drive enclosure that supports SAT.
Anyone know of one?

And does the USB storage layer actually pass the ATA_16 packets to the device?

Cheers
