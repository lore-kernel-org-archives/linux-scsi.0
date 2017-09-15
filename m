From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 11/12] scsi: sd_zbc: Disable zone write locking with scsi-mq
Date: Fri, 15 Sep 2017 19:06:44 +0900
Message-ID: <20170915100645.17999-12-damien.lemoal@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:23903 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdIOKJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 06:09:06 -0400
In-Reply-To: <20170915100645.17999-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

In the case of a ZBC disk used with scsi-mq, zone write locking does
not prevent write reordering in sequential zones. Unlike the legacy
case, zone locking is done after the command request is removed from
the scheduler dispatch queue. That is, at the time of zone locking,
the write command may already be out of order, making locking
ineffective. Write order guarantees can only be provided by an
adapted I/O scheduler.

Disable zone write locking in sd_zbc_write_lock_zone() if the disk is
used with scsi-mq. As the disk zones_wlock bitmap is not necessry,
do not allocate it.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sd_zbc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index c32a3a3d9138..de504026f2c0 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -279,7 +279,7 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	sector_t zone_sectors = sd_zbc_zone_sectors(sdkp);
-	unsigned int zno = sd_zbc_zone_no(sdkp, sector);
+	unsigned int zno;
 
 	/*
 	 * Note: Checks of the alignment of the write command on
@@ -291,6 +291,10 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	    (sector & (zone_sectors - 1)) + blk_rq_sectors(rq) > zone_sectors)
 		return BLKPREP_KILL;
 
+	/* No write locking with scsi-mq */
+	if (q->mq_ops)
+		return BLKPREP_OK;
+
 	/*
 	 * There is no write constraints on conventional zones. So any write
 	 * command can be sent. But do not issue more than one write command
@@ -298,6 +302,7 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	 * due to the unlocking of the request queue in the dispatch path of
 	 * legacy scsi path, as well as at the HBA level (e.g. AHCI).
 	 */
+	zno = sd_zbc_zone_no(sdkp, sector);
 	if (q->zoned.seq_zones && test_bit(zno, q->zoned.seq_zones))
 		return BLKPREP_OK;
 	if (sdkp->zones_wlock && test_and_set_bit(zno, sdkp->zones_wlock))
@@ -653,7 +658,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	if (sdkp->first_scan)
 		return 0;
 
-	if (!sdkp->zones_wlock) {
+	if (!q->mq_ops && !sdkp->zones_wlock) {
 		sdkp->zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
 		if (!sdkp->zones_wlock)
 			return -ENOMEM;
-- 
2.13.5
