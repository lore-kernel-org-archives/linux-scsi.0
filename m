From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: 01 Sep 2004 09:20:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094052028.27196.6.camel@patlinux.iomegacorp.com>
References: <A8E06BE4-F7BA-11D8-AC6B-00039398BB5E@ieee.org><Pine.LNX.4.44L0
	.0408271100590.1238-100000@ida.rowland.org><20040828143124.GB2518@suse.de>
	<1093715498.3682.4.camel@mulgrave><20040828175547.GA8339@suse.de> <109371 7
	255.3682.13.camel@mulgrave><20040828184104.GA8460@suse.de> <1093742128.16 7
	0.2.camel@mulgrave><20040829134505.GB10384@suse.de><8AE29B65-FAB0-11D8-85F1
	-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:44459 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266864AbUIAPVv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 11:21:51 -0400
In-Reply-To: <8AE29B65-FAB0-11D8-85F1-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>

Alan S:

> > interested in trying higher values, ...
> 
> a) whole revolution delays seen in bus traces
> b) no limit below 2 to 4 GiB in the standard for the bus
> c) device developers need xFFFF blocks per CDB

Also,

d) experience of lower values

I see usb-storage.ko runs 3X slow like ub.ko does if I ask to choke off
usb-storage at 4 KiB/CDB, same as ub.ko gives me by default today.

That is, we visibly run out of margin to allow for pointlessly
shattering streams into microscopic fragments at values maybe not far
enough from our max.

Pat LaVarre

$ sudo blockdev --flushbufs /dev/uba
BLKFLSBUF: Inappropriate ioctl for device
$ time sudo dd if=/dev/uba bs=64K skip=0 count=3200 >/dev/null
3200+0 records in
3200+0 records out
 
real    0m26.481s
user    0m0.007s
sys     0m0.598s
$ 
$ modprobe -r ub
$ modprobe usb-storage
$
$ ln -s /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:2.0/host1/1:0:0:0/max_sectors .
$ echo 240 | sudo dd of=max_sectors
0+1 records in
0+1 records out
$ cat max_sectors
240
$ sudo blockdev --flushbufs /dev/scd0
$ time sudo dd if=/dev/scd0 bs=1M skip=0 count=200 >/dev/null
200+0 records in
200+0 records out
 
real    0m8.420s
user    0m0.006s
sys     0m0.630s
$
$ echo 8 | sudo dd of=max_sectors
0+1 records in
0+1 records out
$ cat max_sectors
8
$ sudo blockdev --flushbufs /dev/scd0
$ time sudo dd if=/dev/scd0 bs=1M skip=0 count=200 >/dev/null
200+0 records in
200+0 records out
 
real    0m27.464s
user    0m0.002s
sys     0m0.766s
$
$ rm max_sectors
$


