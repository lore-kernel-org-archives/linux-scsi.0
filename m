From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/5] Fix to cleanup aborted IO to avoid device being offlined by mid-layer
Date: Mon, 14 Mar 2016 11:14:18 -0700
Message-ID: <1457979262-26571-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-5.cisco.com ([173.37.86.76]:57496 "EHLO
	rcdn-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbcCNSYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 14:24:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com, linux-scsi@vger.kernel.org

If an I/O times out and an abort issued by host, if the abort is
successful we need to set scsi status as DID_ABORT. Or else the
mid-layer error handler which looks for this error code, will
offline the device. Also if the original I/O is not found in fnic
firmware, we will consider the abort as successful.
Fnic driver version changed from 1.6.0.17a to 1.6.0.19,
version 1.6.0.18 has been skipped

Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_scsi.c | 32 +++++++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index ce129e5..52a53f8 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.17a"
+#define DRV_VERSION		"1.6.0.19"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 266b909..b9732b1 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1092,6 +1092,11 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 				atomic64_inc(
 					&term_stats->terminate_fw_timeouts);
 			break;
+		case FCPIO_ITMF_REJECTED:
+			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+				"abort reject recd. id %d\n",
+				(int)(id & FNIC_TAG_MASK));
+			break;
 		case FCPIO_IO_NOT_FOUND:
 			if (CMD_FLAGS(sc) & FNIC_IO_ABTS_ISSUED)
 				atomic64_inc(&abts_stats->abort_io_not_found);
@@ -1112,9 +1117,14 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 			spin_unlock_irqrestore(io_lock, flags);
 			return;
 		}
+
 		CMD_ABTS_STATUS(sc) = hdr_status;
 		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
 
+		/* If the status is IO not found consider it as success */
+		if (hdr_status == FCPIO_IO_NOT_FOUND)
+			CMD_ABTS_STATUS(sc) = FCPIO_SUCCESS;
+
 		atomic64_dec(&fnic_stats->io_stats.active_ios);
 		if (atomic64_read(&fnic->io_cmpl_skip))
 			atomic64_dec(&fnic->io_cmpl_skip);
@@ -1927,21 +1937,33 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 
+	start_time = io_req->start_time;
 	/*
 	 * firmware completed the abort, check the status,
-	 * free the io_req irrespective of failure or success
+	 * free the io_req if successful. If abort fails,
+	 * Device reset will clean the I/O.
 	 */
-	if (CMD_ABTS_STATUS(sc) != FCPIO_SUCCESS)
+	if (CMD_ABTS_STATUS(sc) == FCPIO_SUCCESS) {
+		CMD_SP(sc) = NULL;
+	}
+	else
+	{
 		ret = FAILED;
-
-	CMD_SP(sc) = NULL;
+		spin_unlock_irqrestore(io_lock, flags);
+		goto fnic_abort_cmd_end;
+	}
 
 	spin_unlock_irqrestore(io_lock, flags);
 
-	start_time = io_req->start_time;
 	fnic_release_ioreq_buf(fnic, io_req, sc);
 	mempool_free(io_req, fnic->io_req_pool);
 
+	if (sc->scsi_done) {
+	/* Call SCSI completion function to complete the IO */
+		sc->result = (DID_ABORT << 16);
+		sc->scsi_done(sc);
+	}
+
 fnic_abort_cmd_end:
 	FNIC_TRACE(fnic_abort_cmd, sc->device->host->host_no,
 		  sc->request->tag, sc,
-- 
2.4.3

