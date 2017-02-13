From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/1] mpt3sas: Ignore unaligned completion length for ZBC_IN
Date: Mon, 13 Feb 2017 14:11:52 +0900
Message-ID: <20170213051152.27741-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:40917 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdBMFMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 00:12:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

The ZBC_IN command (REPORT ZONES) reply length is always a multiple of
64B and thus may not be aligned on the device LBA size.
For this command, retry due to the unaligned completion length is
incorrect so do not check alignment of the reply length.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0b5b423..f04b872 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4723,8 +4723,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	 * then scsi-ml does not need to handle this misbehavior.
 	 */
 	sector_sz = scmd->device->sector_size;
-	if (unlikely(scmd->request->cmd_type == REQ_TYPE_FS && sector_sz &&
-		     xfer_cnt % sector_sz)) {
+	if (scmd->request->cmd_type == REQ_TYPE_FS &&
+	    scmd->cmnd[0] != ZBC_IN &&
+	    sector_sz && xfer_cnt % sector_sz) {
 		sdev_printk(KERN_INFO, scmd->device,
 		    "unaligned partial completion avoided (xfer_cnt=%u, sector_sz=%u)\n",
 			    xfer_cnt, sector_sz);
-- 
2.9.3
