From: Alex Tomas <alexey@technomagesinc.com>
Subject: Re: hot scsi disk resize
Date: 04 Mar 2003 08:37:50 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3isuz8zf5.fsf@lexa.home.net>
References: <m3bs0s9xij.fsf@lexa.home.net>
	<20030303181536.A30199@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Dennis Gerasimov <denis@technomagesinc.com>


Hi!

>>>>> Christoph Hellwig (CH) writes:

 CH> On Mon, Mar 03, 2003 at 08:21:24PM +0300, Alex Tomas wrote:
 >> + if (err >= 0) + err = length; + } else if (!strncmp("rescan",
 >> buffer + 5, 6)) { + p = buffer + 12; + + host = simple_strtoul(p,
 >> &p, 0); + channel = simple_strtoul(p + 1, &p, 0); + id =
 >> simple_strtoul(p + 1, &p, 0); + lun = simple_strtoul(p + 1, &p,
 >> 0); + err = scsi_rescan_single_device(host, channel, id, lun); +
 >> if (err >= 0) + err = length;

 CH> Please don't add more procfs option.  A resize attribute for the
 CH> sysfs node of the scsi_device is the better choice in my opinion.

I like your idea.

 >> + buffer = kmalloc(512, GFP_DMA); + else + buffer = kmalloc(512,
 >> GFP_KERNEL); + + sd_read_capacity(sdkp, gd->disk_name, SRpnt,
 >> buffer); + set_capacity(gd, sdkp->capacity); +
 >> scsi_release_request(SRpnt); + kfree(buffer);

 CH> Don't you need some kind of serialization here?

Well. I think all changes sd_read_capacity() and set_capacity() make
need not to be protected. Am I right?

 >> --- linux/fs/block_dev.c Mon Jan 20 02:23:49 2003 +++
 >> edited/fs/block_dev.c Mon Mar 3 18:49:47 2003 @@ -623,6 +623,8 @@
 >> up(&whole->bd_sem); } } else { + if (!part) +
 >> bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);

 CH> This needs more explanation.

This is required because open("/dev/sd*",) should see new size of
disk being used. James Bottomley suggested to introduce new ioctl, but
I hope we may implmenent the feature w/o touching userspace tools.

with best regards, Alex


