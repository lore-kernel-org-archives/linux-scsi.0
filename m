From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 7/8] scsi: sd_zbc: Disable zone write locking with scsi-mq
Date: Fri,  1 Sep 2017 20:36:30 +0900
Message-ID: <20170901113631.12323-8-damien.lemoal@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:23872 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdIALiz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2017 07:38:55 -0400
In-Reply-To: <20170901113631.12323-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

In the case of a ZBC disk used with scsi-mq, zone write locking does
not prevent write reordering in sequential zones. Unlike the legacy
case, zone locking can only be done after the command request is
removed from the scheduler dispatch queue. That is, at the time of
zone locking, the write command may already be out of order.

Disable zone write locking in sd_zbc_write_lock_zone() if the disk is
used with scsi-mq. Write order guarantees can be provided by an
adapted I/O scheduler.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 3a9feadcc133..0f0a74fbd9c5 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -258,6 +258,10 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	    (sector & (zone_sectors - 1)) + blk_rq_sectors(rq) > zone_sectors)
 		return BLKPREP_KILL;
 
+	/* No write locking with scsi-mq */
+	if (rq->q->mq_ops)
+		return BLKPREP_OK;
+
 	/*
 	 * There is no write constraint on conventional zones, but do not issue
 	 * more than one write at a time per sequential zone. This avoids write
-- 
2.13.5
