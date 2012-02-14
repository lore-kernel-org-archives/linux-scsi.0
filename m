From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Kernel crashing on eject SD card
Date: Tue, 14 Feb 2012 14:31:19 +0100
Message-ID: <20120214143119.345fead9@stein>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
	<20120212220836.6aa7fa4d@stein>
	<20120212222027.71651e8b@stein>
	<20120213021813.GA589@redhat.com>
	<1329154831.4f394b0f3c69c@www.imp.polymtl.ca>
	<4F3A4220.4010901@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54283 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2BNNcB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 08:32:01 -0500
In-Reply-To: <4F3A4220.4010901@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Naveen Goswamy <naveen.goswamy@polymtl.ca>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Feb 14 Jun'ichi Nomura wrote:
> According to the comments by Huajun Li:
> http://www.spinics.net/lists/linux-scsi/msg55698.html
> 
> The following commit has changed __blkdev_get() to end up calling
> sd_revalidate_disk() without getting a refcount of scsi_device:
> 
>   commit 1196f8b814f32cd04df334abf47648c2a9fd8324
>   Author: Tejun Heo <tj@kernel.org>
>   Date:   Thu Apr 21 20:54:45 2011 +0200
> 
>     block: rescan partitions on invalidated devices on -ENOMEDIA too
> 
> that could lead to oops like this:
> 
>   process A                  process B
>   ----------------------------------------------
>   sys_open
>     __blkdev_get
>       sd_open
>         returns -ENOMEDIUM
>                              scsi_remove_device
>                                <scsi_device torn down>
>       rescan_partitions
>         sd_revalidate_disk
>           <oops>
> 
> Should "revalidate_disk" of block_device_operations work
> without successful open()?
> 
> If so, sd_revalidate_disk() (and possibly other drivers) needs to be
> fixed. (e.g. use scsi_disk_get/put by itself)
> 
> If not, __blkdev_get() or rescan_partision() should avoid calling
> "revalidate_disk" for -ENOMEDIUM case.

It may very well be that not only sd_revalidate_disk is affected.

I have yet to check whether the "open -> unplug -> ioctl -> oops" bug from
http://www.spinics.net/lists/linux-scsi/msg56254.html
(a) happens under 3.3-rc still (was reported against 3.2-rc7),
(b) affects sd devices too (was reported against sr devices).
-- 
Stefan Richter
-=====-===-- --=- -===-
http://arcgraph.de/sr/
