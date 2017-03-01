From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v6] sd: Check for unaligned partial completion
Date: Wed,  1 Mar 2017 17:27:00 +0900
Message-ID: <20170301082700.20413-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:21234 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdCAI2g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 03:28:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

Commit <f2e767bb5d6e> ("mpt3sas: Force request partial completion
alignment") was not considering the case of commands not operating on
logical block size units (e.g. REQ_OP_ZONE_REPORT and its 64B aligned
partial replies). In this case, forcing alignment of resid to the
device logical block size can break the command result, e.g. in the
case of REQ_OP_ZONE_REPORT, the exact number of zone reported by the
device.

Move the partial completion alignement check of mpt3sas to a generic
implementation in sd_done(). The check is added within the default
section of the initial req_op() switch case so that the report and
reset zone commands are ignored. In addition, as sd_done() is not
called for passthrough requests, resid corrections are not done as
intended by the initial mpt3sas patch.

Fixes: f2e767bb5d6e ("mpt3sas: Force request partial completion alignment")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 ---------------
 drivers/scsi/sd.c                    | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 46e866c..69c29c5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4677,7 +4677,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
 	unsigned long flags;
-	unsigned int sector_sz;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 
@@ -4742,20 +4741,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	}
 
 	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
-
-	/* In case of bogus fw or device, we could end up having
-	 * unaligned partial completion. We can force alignment here,
-	 * then scsi-ml does not need to handle this misbehavior.
-	 */
-	sector_sz = scmd->device->sector_size;
-	if (unlikely(!blk_rq_is_passthrough(scmd->request) && sector_sz &&
-		     xfer_cnt % sector_sz)) {
-		sdev_printk(KERN_INFO, scmd->device,
-		    "unaligned partial completion avoided (xfer_cnt=%u, sector_sz=%u)\n",
-			    xfer_cnt, sector_sz);
-		xfer_cnt = round_down(xfer_cnt, sector_sz);
-	}
-
 	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
 	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
 		log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c7839f6..fb9b4d2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1783,6 +1783,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
 	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
+	unsigned int sector_size = SCpnt->device->sector_size;
+	unsigned int resid;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
 	struct request *req = SCpnt->request;
@@ -1813,6 +1815,21 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			scsi_set_resid(SCpnt, blk_rq_bytes(req));
 		}
 		break;
+	default:
+		/*
+		 * In case of bogus fw or device, we could end up having
+		 * an unaligned partial completion. Check this here and force
+		 * alignment.
+		 */
+		resid = scsi_get_resid(SCpnt);
+		if (resid & (sector_size - 1)) {
+			sd_printk(KERN_INFO, sdkp,
+				"Unaligned partial completion (resid=%u, sector_sz=%u)\n",
+				resid, sector_size);
+			resid = min(scsi_bufflen(SCpnt),
+				    round_up(resid, sector_size));
+			scsi_set_resid(SCpnt, resid);
+		}
 	}
 
 	if (result) {
-- 
2.9.3
