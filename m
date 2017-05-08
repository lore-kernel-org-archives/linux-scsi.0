From: damien.lemoal@wdc.com
Subject: [PATCH] sd: Write lock zone for REQ_OP_WRITE_ZEROES
Date: Mon,  8 May 2017 14:59:03 +0900
Message-ID: <20170508055903.28695-2-damien.lemoal@wdc.com>
References: <20170508055903.28695-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:37517 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752625AbdEHF74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 01:59:56 -0400
In-Reply-To: <20170508055903.28695-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

For a zoned block device, sd_zbc_complete() handles zone write unlock on
completion of a REQ_OP_WRITE_ZEROES command but the zone write locking is
missing from sd_setup_write_zeroes_cmnd(). This patch fixes this problem by
locking the target zone of a REQ_OP_WRITE_ZEROES request, ignoring the
unmap == true case (as in this case, the write same command will necessarily
be aligned on the entire zone and be equivalent to a discard which does not
write lock zones).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e60a309..b0a525d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -827,6 +827,7 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	int ret;
 
 	if (!(rq->cmd_flags & REQ_NOUNMAP)) {
 		switch (sdkp->zeroing_mode) {
@@ -839,9 +840,22 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 
 	if (sdp->no_write_same)
 		return BLKPREP_INVALID;
+
+	if (sd_is_zoned(sdkp)) {
+		ret = sd_zbc_write_lock_zone(cmd);
+		if (ret != BLKPREP_OK)
+			return ret;
+	}
+
 	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff)
-		return sd_setup_write_same16_cmnd(cmd, false);
-	return sd_setup_write_same10_cmnd(cmd, false);
+		ret = sd_setup_write_same16_cmnd(cmd, false);
+	else
+		ret = sd_setup_write_same10_cmnd(cmd, false);
+
+	if (sd_is_zoned(sdkp) && ret != BLKPREP_OK)
+		sd_zbc_write_unlock_zone(cmd);
+
+	return ret;
 }
 
 static void sd_config_write_same(struct scsi_disk *sdkp)
-- 
2.9.3
