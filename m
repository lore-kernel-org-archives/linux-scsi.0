From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.6.11rc2 prints disksize twice
Date: Mon, 31 Jan 2005 09:05:46 -0800
Message-ID: <20050131170546.GA29904@us.ibm.com>
References: <20050131121537.GA32111@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:28914 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261263AbVAaRGe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 12:06:34 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0VH6XZ7589304
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 12:06:33 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0VH6XJb428702
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 10:06:33 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0VH6WO1022542
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 10:06:32 -0700
Content-Disposition: inline
In-Reply-To: <20050131121537.GA32111@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>, viro@zenII.linux.org.uk
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 31, 2005 at 01:15:37PM +0100, Olaf Hering wrote:
> I think its not a functional problem,
> but parts of the disk detection is printed twice.

Yes ...

> ...
> SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
> SCSI device sdc: drive cache: write through
> SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
> SCSI device sdc: drive cache: write through
> ...
> 

I looked into it some, there was a change from Al to always set
bd_invalidated in register_disk(), and then to call blkdev_get. This means
the block_dev.c do_open will call rescan_partitions, and in turn call
revalidate_disk even for non-removable media.

This change:

http://linux.bkbits.net:8080/linux-2.5/diffs/fs/partitions/check.c@1.127?nav=index.html|src/|src/fs|src/fs/partitions|hist/fs/partitions/check.c

The log comment from Al says "Work around devices with bogus media change
indication on the first open".

Al - What did that fix? Why was that done in the generic block code, and
not the affected driver (multiple revalidate_disk call in the
driver on device discovery)? 

I tested this patch with scsi fixed and removable disks with no problems,
but it could break whatever Al fixed. Otherwise it should work with any
block driver that calls (for removable/modifiable media) check_disk_change
on open and that has a revalidate_disk function and the device is not
broken (it looks like that is the correct use of the two functions, I'm
not certain).

diff -uprN -X /home/patman/dontdiff linux-2.6.11-rc1/fs/partitions/check.c no-double-sd-linux-2.6.11-rc1/fs/partitions/check.c
--- linux-2.6.11-rc1/fs/partitions/check.c	Fri Dec 24 13:35:28 2004
+++ no-double-sd-linux-2.6.11-rc1/fs/partitions/check.c	Fri Jan 21 11:19:00 2005
@@ -375,8 +375,6 @@ int rescan_partitions(struct gendisk *di
 	bdev->bd_invalidated = 0;
 	for (p = 1; p < disk->minors; p++)
 		delete_partition(disk, p);
-	if (disk->fops->revalidate_disk)
-		disk->fops->revalidate_disk(disk);
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	for (p = 1; p < state->limit; p++) {

-- Patrick Mansfield
