From: mike.miller@hp.com
Subject: [PATCH] cciss 2.6: remove partition info from CCISS_GETLUNINFO
Date: Fri, 17 Jun 2005 14:02:08 -0500
Message-ID: <20050617190208.GA10465@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel8.hp.com ([156.153.255.206]:15532 "EHLO atlrel8.hp.com")
	by vger.kernel.org with ESMTP id S262089AbVFQUBh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 16:01:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, axboe@suse.de, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch fulfills a promise I made to Christoph sometime back. I am removing the partition info from the CCISS_GETLUNINFO ioctl as I was informed my "driver had no damn business reading that structure." ;)
The application folks are to use /proc or /sys for partition info from now on. I am only aware of a few apps that use this ioctl and I'm not sure they ever used the partition info.

Signed-off-by: Mike Miller <mike.miller@hp.com>

 cciss.c |    7 -------
 1 files changed, 7 deletions(-)
--------------------------------------------------------------------------------
diff -burNp lx2612-rc6-p002/drivers/block/cciss.c lx2612-rc6/drivers/block/cciss.c
--- lx2612-rc6-p002/drivers/block/cciss.c	2005-06-17 13:17:23.262424000 -0500
+++ lx2612-rc6/drivers/block/cciss.c	2005-06-17 13:51:47.347635712 -0500
@@ -792,13 +792,6 @@ static int cciss_ioctl(struct inode *ino
  		luninfo.LunID = drv->LunID;
  		luninfo.num_opens = drv->usage_count;
  		luninfo.num_parts = 0;
- 		/* count partitions 1 to 15 with sizes > 0 */
- 		for (i = 0; i < MAX_PART - 1; i++) {
-			if (!disk->part[i])
-				continue;
-			if (disk->part[i]->nr_sects != 0)
-				luninfo.num_parts++;
-		}
  		if (copy_to_user(argp, &luninfo,
  				sizeof(LogvolInfo_struct)))
  			return -EFAULT;
