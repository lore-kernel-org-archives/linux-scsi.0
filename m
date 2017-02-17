From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v5] sd: Check for unaligned partial completion
Date: Fri, 17 Feb 2017 09:01:30 +0900
Message-ID: <20170217000130.22471-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:65337 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbdBQAK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 19:10:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

Commit f2e767bb5d6e ("mpt3sas: Force request partial completion alignment")
was not considering the case of REQ_TYPE_FS commands not operating on
logical block size units (e.g. REQ_OP_ZONE_REPORT and its 64B aligned
partial replies). This could result is incorrectly retrying (forever)
those commands.

Move the partial completion alignement check of mpt3sas to a generic
implementation in sd_done so that the check ignores REQ_TYPE_FS
requests with special payload size handling (REQ_OP_DISCARD,
REQ_OP_WRITE_SAME, REQ_OP_ZONE_REPORT and REQ_OP_ZONE_RESET). For the
remaining REQ_OP_FLUSH, REQ_OP_READ and REQ_OP_WRITE, we only need to
check the resid alignment, correct it if necessary and then correct
good_bytes. Note that in this case, good_bytes will always initially be 0
or aligned on the device logical block size, so correcting resid alignment
will always result in good_bytes also being properly aligned.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Fixes: f2e767bb5d6e ("mpt3sas: Force request partial completion alignment")

---

Changes from v4:
- As suggested by Bart, make sure resid does not exceed good_bytes
- Use sd_printk for message instead of going through scsi log

Changes from v3:
- Moved check to initial switch-case so that commands with special payload
  handling are ignored.

Changes from v2:
- Fixed good_bytes calculation after correction of unaligned resid
  It should be good_bytes=scsi_buflen() - resid, and not good_bytes-=resid

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 ---------------
 drivers/scsi/sd.c                    | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0b5b423..1961535 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4658,7 +4658,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
 	unsigned long flags;
-	unsigned int sector_sz;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
@@ -4717,20 +4716,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	}
 
 	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
-
-	/* In case of bogus fw or device, we could end up having
-	 * unaligned partial completion. We can force alignment here,
-	 * then scsi-ml does not need to handle this misbehavior.
-	 */
-	sector_sz = scmd->device->sector_size;
-	if (unlikely(scmd->request->cmd_type == REQ_TYPE_FS && sector_sz &&
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
index 1f5d92a..525b162 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1790,6 +1790,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
 	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
+	unsigned int sector_size = SCpnt->device->sector_size;
+	unsigned int resid;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
 	struct request *req = SCpnt->request;
@@ -1820,6 +1822,21 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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
+			resid = min(good_bytes, round_up(resid, sector_size));
+			good_bytes -= resid;
+			scsi_set_resid(SCpnt, resid);
+		}
 	}
 
 	if (result) {
-- 
2.9.3
