From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] scsicam_getgeo_odd_sector_size
Date: Wed, 13 Oct 2004 09:01:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416D3536.5030501@us.ibm.com>
References: <200408192303.i7JN3cv9110958@northrelay02.pok.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040101030806010103050508"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:42681 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269709AbUJMOB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 10:01:29 -0400
In-Reply-To: <200408192303.i7JN3cv9110958@northrelay02.pok.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040101030806010103050508
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch appears to have been dropped. Resending.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------040101030806010103050508
Content-Type: text/plain;
 name="scsicam_getgeo_odd_sector_size.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsicam_getgeo_odd_sector_size.patch"


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

 linux-2.6.9-rc4-bk1-bjking1/drivers/scsi/scsicam.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsicam.c~scsicam_getgeo_odd_sector_size drivers/scsi/scsicam.c
--- linux-2.6.9-rc4-bk1/drivers/scsi/scsicam.c~scsicam_getgeo_odd_sector_size	2004-10-13 08:57:46.000000000 -0500
+++ linux-2.6.9-rc4-bk1-bjking1/drivers/scsi/scsicam.c	2004-10-13 08:57:46.000000000 -0500
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

--------------040101030806010103050508--

