From: damien.lemoal@wdc.com
Subject: [PATCH] sd: Unlock zone in case of error in sd_setup_write_same_cmnd()
Date: Mon,  8 May 2017 14:59:02 +0900
Message-ID: <20170508055903.28695-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60467 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdEHF7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 01:59:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

scsi_io_init() may fail, leaving a zone of a zoned block device locked.
Fix this by properly unlocking the write same request target zone if
scsi_io_init() fails.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/sd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f9d1432..e60a309 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -948,6 +948,10 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	rq->__data_len = sdp->sector_size;
 	ret = scsi_init_io(cmd);
 	rq->__data_len = nr_bytes;
+
+	if (sd_is_zoned(sdkp) && ret != BLKPREP_OK)
+		sd_zbc_write_unlock_zone(cmd);
+
 	return ret;
 }
 
-- 
2.9.3
