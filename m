From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] udf_get_last_block decrement redundant maybe
Date: 27 Jul 2004 14:44:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090961087.4812.59.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:5102 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266631AbUG0UpK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 16:45:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Cc: linux-scsi@vger.kernel.org, linux_udf@hpesjro.fc.hp.com, Jens Axboe <axboe@suse.de>

Ben F:

Please dis/agree the following is a small correction.  I ask because,

I see ioctl CDROM_LAST_WRITTEN dynamically calls cdrom_get_last_written
of drivers/cdrom/cdrom.c.

I see cdrom_get_last_written gets its idea of max LBA from such places
as the ti.last_rec_address, which is an LBA written, not the LBA beyond,
i.e. is already the count of blocks written minus one, with no further
decrement required.

I see removing the udf_get_last_block decrement lets udf_find_anchor(sb)
work with an "AVDPs at  N-256,  N" UDF disc if only I also insert,
beforehand:

        UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);

Pat LaVarre

diff -urp -U 4 linux-2.6.8-rc2-bk2/fs/udf/lowlevel.c linux-2.6.8-rc2-bk5-pel/fs/udf/lowlevel.c
--- linux-2.6.8-rc2-bk2/fs/udf/lowlevel.c	2004-06-15 23:19:36.000000000 -0600
+++ linux-2.6.8-rc2-bk5-pel/fs/udf/lowlevel.c	2004-07-27 13:39:01.876811232 -0600
@@ -76,8 +76,8 @@ udf_get_last_block(struct super_block *s
 	if (ioctl_by_bdev(bdev, CDROM_LAST_WRITTEN, (unsigned long) &lblock))
 		lblock = bdev->bd_inode->i_size >> sb->s_blocksize_bits;
 
 	if (lblock)
-		return lblock - 1;
+		return lblock;
 	else
 		return 0;
 }


