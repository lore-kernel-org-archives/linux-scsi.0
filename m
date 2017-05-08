From: damien.lemoal@wdc.com
Subject: [PATCH v2] sd: Write lock zone for REQ_OP_WRITE_ZEROES
Date: Mon,  8 May 2017 15:48:19 +0900
Message-ID: <20170508064819.12414-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:7834 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdEHGsd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 02:48:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

For a zoned block device, sd_zbc_complete() handles zone write unlock
on completion of a REQ_OP_WRITE_ZEROES command but the zone write
locking is missing from sd_setup_write_zeroes_cmnd(). This patch fixes
this problem by locking the target zone of a REQ_OP_WRITE_ZEROES
request.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---

Changes from v1:
* Lock zone in all cases so that no warning is triggered in sd_zbc_complete()
  with unlocked zones for the unmap case.

 drivers/scsi/sd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e60a309..de9e2f2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -827,21 +827,32 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	int ret;
 
 	if (!(rq->cmd_flags & REQ_NOUNMAP)) {
 		switch (sdkp->zeroing_mode) {
 		case SD_ZERO_WS16_UNMAP:
-			return sd_setup_write_same16_cmnd(cmd, true);
+			ret = sd_setup_write_same16_cmnd(cmd, true);
+			goto out;
 		case SD_ZERO_WS10_UNMAP:
-			return sd_setup_write_same10_cmnd(cmd, true);
+			ret = sd_setup_write_same10_cmnd(cmd, true);
+			goto out;
 		}
 	}
 
 	if (sdp->no_write_same)
 		return BLKPREP_INVALID;
+
 	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff)
-		return sd_setup_write_same16_cmnd(cmd, false);
-	return sd_setup_write_same10_cmnd(cmd, false);
+		ret = sd_setup_write_same16_cmnd(cmd, false);
+	else
+		ret = sd_setup_write_same10_cmnd(cmd, false);
+
+out:
+	if (sd_is_zoned(sdkp) && ret == BLKPREP_OK)
+		return sd_zbc_write_lock_zone(cmd);
+
+	return ret;
 }
 
 static void sd_config_write_same(struct scsi_disk *sdkp)
-- 
2.9.3
