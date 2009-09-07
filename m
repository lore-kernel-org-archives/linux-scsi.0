From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH v2] drivers: convert libfc calling scsi_track_queue_full
Date: Mon, 07 Sep 2009 13:44:41 -0700
Message-ID: <20090907204440.6848.47177.stgit@vi1.jf.intel.com>
References: <20090903222247.24946.60577.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11873 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbZIGUoi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Sep 2009 16:44:38 -0400
In-Reply-To: <20090903222247.24946.60577.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This converts the libfc using scsi_track_queue_full to
track the queue full from the change_queue_depth callback.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index d748e03..6c189be 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1814,21 +1814,6 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			sc_cmd->result = DID_OK << 16;
 			if (fsp->scsi_resid)
 				CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
-		} else if (fsp->cdb_status == QUEUE_FULL) {
-			struct scsi_device *tmp_sdev;
-			struct scsi_device *sdev = sc_cmd->device;
-
-			shost_for_each_device(tmp_sdev, sdev->host) {
-				if (tmp_sdev->id != sdev->id)
-					continue;
-
-				if (tmp_sdev->queue_depth > 1) {
-					scsi_track_queue_full(tmp_sdev,
-							      tmp_sdev->
-							      queue_depth - 1);
-				}
-			}
-			sc_cmd->result = (DID_OK << 16) | fsp->cdb_status;
 		} else {
 			/*
 			 * transport level I/O was ok but scsi
@@ -2064,9 +2049,16 @@ EXPORT_SYMBOL(fc_slave_alloc);
 
 int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, qdepth);
+		break;
+	default:
 		return -EOPNOTSUPP;
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	}
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL(fc_change_queue_depth);

