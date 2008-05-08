From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 5/5] Call flush_disk() after detecting an online resize.
Date: Thu, 08 May 2008 00:32:01 -0600
Message-ID: <20080508063201.3818.53226.stgit@bluto.andrew>
References: <20080508062930.3818.31401.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11619 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760878AbYEHGcC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 02:32:02 -0400
In-Reply-To: <20080508062930.3818.31401.stgit@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com

Call flush_disk() after detecting an online resize.

We call flush_disk() to make sure the buffer cache for the disk is
flushed after a disk resize. There are two resize cases, growing and
shrinking. Given that users can shrink/then grow a disk before
revalidate_disk() is called, we treat the grow case identically to
shrinking. We need to flush the buffer cache after an online shrink
because, as James Bottomley puts it,

     The two use cases for shrinking I can see are

     1. planned: the fs is already shrunk to within the new boundaries
        and all data is relocated, so invalidate is fine (any dirty
        buffers that might exist in the shrunk region are there only
        because they were relocated but not yet written to their
        original location).
     2. unplanned:  In this case, the fs is probably toast, so whether
        we invalidate or not isn't going to make a whole lot of
        difference; it's still going to try to read or write from
        sectors beyond the new size and get I/O errors.

Immediately invalidating shrunk disks will cause errors for outstanding
I/Os for reads/write beyond the new end of the disk to be generated
earlier then if we waited for the normal buffer cache operation. It also
removes a potential security hole where we might keep old data around
from beyond the end of the shrunk disk if the disk was not invalidated.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/block_dev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index eb2bc5c..41ef08d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -884,8 +884,8 @@ static void flush_disk(struct block_device *bdev)
 
 		if (bdev->bd_disk)
 			disk_name(bdev->bd_disk, 0, name);
-		printk(KERN_WARNING "VFS: busy inodes on changed media %s\n",
-		       name);
+		printk(KERN_WARNING "VFS: busy inodes on changed media or "
+		       "resized disk %s\n", name);
 	}
 
 	if (!bdev->bd_disk)
@@ -928,6 +928,7 @@ int revalidate_disk(struct gendisk *disk)
 		       "%s: detected capacity change from %lld to %lld\n",
 		       name, bdev_size, disk_size);
 		i_size_write(bdev->bd_inode, disk_size);
+		flush_disk(bdev);
 	}
 
 	mutex_unlock(&bdev->bd_mutex);

