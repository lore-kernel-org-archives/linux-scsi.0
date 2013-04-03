From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] [SCSI] sd: workaround invalid OPTIMAL TRANSFER LENGTH
Date: Wed, 3 Apr 2013 16:21:24 -0400
Message-ID: <20130403202124.GB2197@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763054Ab3DCUV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Apr 2013 16:21:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Workaround disk firmware that improperly sets OPTIMAL TRANSFER LENGTH to
0xFFFFFFFF (aka UINT_MAX or 4294967295U) by assuming this _optional_
BLOCK LIMITS VPD field was not specified (0).

It should be noted that a disk firmware fix is being developed but that
these disks are already in the wild (and when optimal_io_size is so
large it prevents standard Linux distribution installers, e.g. Anaconda,
from creating partitions smaller than 4GB via libparted due to parted
looking to align the created partitions relative to optimal_io_size).

The disk model in this instance is "SEAGATE ST900MM0006".  The BLOCK
LIMITS VPD page for this disk is:
# sg_inq --vpd --page=0xb0 /dev/sdb
VPD INQUIRY: Block limits page (SBC)
  Optimal transfer length granularity: 1 blocks
  Maximum transfer length: 0 blocks
  Optimal transfer length: 4294967295 blocks
  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 0
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0

Before this fix:
# cat /sys/block/sdb/queue/optimal_io_size
4294966784

After this fix:
# cat /sys/block/sdb/queue/optimal_io_size
0

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/sd.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..34638c1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2516,6 +2516,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
  */
 static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
+	unsigned int optimal_transfer_length;
 	unsigned int sector_sz = sdkp->device->sector_size;
 	const int vpd_len = 64;
 	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
@@ -2527,8 +2528,11 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 	blk_queue_io_min(sdkp->disk->queue,
 			 get_unaligned_be16(&buffer[6]) * sector_sz);
+	optimal_transfer_length = get_unaligned_be32(&buffer[12]);
+	if (optimal_transfer_length == UINT_MAX)
+		optimal_transfer_length = 0; /* firmware bug, use 0 instead */
 	blk_queue_io_opt(sdkp->disk->queue,
-			 get_unaligned_be32(&buffer[12]) * sector_sz);
+			 optimal_transfer_length * sector_sz);
 
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
