From: brking@us.ibm.com
Subject: [PATCH 1/1] scsicam_getgeo_odd_sector_size
Date: Thu, 19 Aug 2004 18:02:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408192303.i7JN3cv9110958@northrelay02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:49031 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267491AbUHSXC1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 19:02:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The following BUG() was observed when a scsi disk formatted to 522 bytes/sector
was discovered attached to a sym2 adapter.

<2>kernel BUG in grow_buffers at fs/buffer.c:1271!

which corresponds to:

static inline int
grow_buffers(struct block_device *bdev, sector_t block, int size)
{
        struct page *page;
        pgoff_t index;
        int sizebits;

        /* Size must be multiple of hard sectorsize */
        if (size & (bdev_hardsect_size(bdev)-1))
                BUG();
        if (size < 512 || size > PAGE_SIZE)
                BUG();                      <----- line 1271 is here


The following patch fixes this by not attempting to read the partition table
of a device with an unsupported sector size.


Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8.1-bjking1/drivers/scsi/scsicam.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsicam.c~scsicam_getgeo_odd_sector_size drivers/scsi/scsicam.c
--- linux-2.6.8.1/drivers/scsi/scsicam.c~scsicam_getgeo_odd_sector_size	2004-08-17 11:28:31.000000000 -0500
+++ linux-2.6.8.1-bjking1/drivers/scsi/scsicam.c	2004-08-17 11:33:13.000000000 -0500
@@ -29,7 +29,10 @@ unsigned char *scsi_bios_ptable(struct b
 	unsigned char *res = kmalloc(66, GFP_KERNEL);
 	if (res) {
 		struct block_device *bdev = dev->bd_contains;
-		struct buffer_head *bh = __bread(bdev, 0, block_size(bdev));
+		struct buffer_head *bh = NULL;
+
+		if (get_capacity(bdev->bd_disk))
+			bh = __bread(bdev, 0, block_size(bdev));
 		if (bh) {
 			memcpy(res, bh->b_data + 0x1be, 66);
 			brelse(bh);
_
