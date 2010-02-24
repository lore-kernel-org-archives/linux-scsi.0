From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Wed, 24 Feb 2010 11:30:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002241123220.2436-100000@iolanthe.rowland.org>
References: <3e7aae31002240507r5d5c4c2bj8e653a3d65fa6709@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51591 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757266Ab0BXQah (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2010 11:30:37 -0500
In-Reply-To: <3e7aae31002240507r5d5c4c2bj8e653a3d65fa6709@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Wed, 24 Feb 2010, Ramya Desai wrote:

> I did exactly. I removed the following statement from
> store_max_sectors (drivers/usb/storage/scsiglue.c) function.
> " && ms <= SCSI_DEFAULT_MAX_SECTORS". I also changed the .max_sectors
> = 2048 in the host template.
> 
> Then I restarted the system and build the usb-storage without any issue.
> 
> After inserting my device, I found 1024 in
> /sys/block/sdb/device/max_sectors. So, I tried to increase the value
> through echo 2048 > /sys/block/sdb/device/max_sectors. When I do this,
> it invoked the store_max_sectors() in the scsiglue.c file and able to
> see ms (the variable in the store_max_sectors()) is 2048. But, the
> value in the /sys/block/sdb/device/max_sectors is still 1024 only.

That's right.  Writing 2048 to that file sets max_hw_sectors to 2048 
while leaving max_sectors set at 1024.  The value displayed in the file 
is max_sectors -- it really ought to be max_hw_sectors.  You can fix 
this by editing the show_max_sectors() function in scsiglue.c: change 
"queue_max_sectors" to "queue_max_hw_sectors".

> When I looked into the /sys/block/sdb/queue/max_hw_sectors_kb, it
> shows 1024, which is 2048 sectors.

As it should be.

>  Then, I tried to increase the value
> in /sys/block/sdb/queue/max_sectors_kb through echo 1024 >
> /sys/block/sdb/queue/max_sectors_kb. After this, I saw 1024 in the
> /sys/block/sdb/queue/max_sectors_kb. When I see 1024 in
> /sys/block/sdb/queue/max_sectors_kb then I found 2048 in
> /sys/block/sdb/device/max_sectors.

Right, because that file displays max_sectors instead of 
max_hw_sectors.

>  However, this time, still my device
> received 512 KB (1024) data transfer buffers in scsi_command.

At this point everything was set up correctly.  I don't know why the 
transfer lengths are still 512 KB.  Maybe someone else has an idea.

Alan Stern

