From: mike.miller@hp.com
Subject: [PATCH 2.6] cciss: CCISS_GETLUNINFO fix
Date: Mon, 29 Nov 2004 16:07:25 -0600
Message-ID: <20041129220725.GA32035@beardog.cca.cpqcorp.net>
Reply-To: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:65233 "EHLO palrel12.hp.com")
	by vger.kernel.org with ESMTP id S261826AbUK2WHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 17:07:52 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com

This patch addresses a problem with reading the partition table struct.
The last time this was submitted it was rejected on the grounds that the driver
has no business reading the partition table. I don't disagree with that, but
we have legacy apps to consider. Changing the ioctl would break those apps
already in customers hands.

Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>

 cciss.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)
--------------------------------------------------------------------------------
diff -urNp lx2610-rc1.orig/drivers/block/cciss.c lx2610-rc1-adrianb/drivers/block/cciss.c
--- lx2610-rc1.orig/drivers/block/cciss.c	2004-11-12 11:17:56.000000000 -0600
+++ lx2610-rc1-adrianb/drivers/block/cciss.c	2004-11-29 15:54:21.668060552 -0600
@@ -809,7 +809,7 @@ static int cciss_ioctl(struct inode *ino
  		luninfo.num_opens = drv->usage_count;
  		luninfo.num_parts = 0;
  		/* count partitions 1 to 15 with sizes > 0 */
- 		for(i=1; i <MAX_PART; i++) {
+ 		for(i=0; i < MAX_PART-1; i++) {
 			if (!disk->part[i])
 				continue;
 			if (disk->part[i]->nr_sects != 0)
