From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 27/27] libfc: fix statistics for FCP input/output megabytes
Date: Tue, 30 Nov 2010 16:20:18 -0800
Message-ID: <20101201002018.18369.70794.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0LAAUX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:20:23 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

The statistics for InputMegabytes and OutputMegabytes are
misnamed.  They're accumulating bytes, not megabytes.

The statistic returned via /sys must be in megabytes, however,
which is what the HBA-API wants.  The FCP code needs to accumulate
it in bytes and then divide by 1,000,000 (not 2^20) before it
presented via sysfs.

This affects fcoe.ko only, not fnic.  The fnic driver
correctly by accumulating bytes and then converts to megabytes.

I checked that libhbalinux is using the /sys file directly without
conversion.

BTW, qla2xxx does divide by 2^20, which I'm not fixing here.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c   |    4 ++--
 drivers/scsi/libfc/fc_lport.c |    8 ++++++--
 include/scsi/libfc.h          |    8 ++++----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 12b639d..72013d4 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1860,11 +1860,11 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		fsp->req_flags = FC_SRB_READ;
 		stats->InputRequests++;
-		stats->InputMegabytes += fsp->data_len;
+		stats->InputBytes += fsp->data_len;
 	} else if (sc_cmd->sc_data_direction == DMA_TO_DEVICE) {
 		fsp->req_flags = FC_SRB_WRITE;
 		stats->OutputRequests++;
-		stats->OutputMegabytes += fsp->data_len;
+		stats->OutputBytes += fsp->data_len;
 	} else {
 		fsp->req_flags = 0;
 		stats->ControlRequests++;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index b91a11e..c5a10f9 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -288,6 +288,8 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 	struct fc_lport *lport = shost_priv(shost);
 	struct timespec v0, v1;
 	unsigned int cpu;
+	u64 fcp_in_bytes = 0;
+	u64 fcp_out_bytes = 0;
 
 	fcoe_stats = &lport->host_stats;
 	memset(fcoe_stats, 0, sizeof(struct fc_host_statistics));
@@ -310,10 +312,12 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 		fcoe_stats->fcp_input_requests += stats->InputRequests;
 		fcoe_stats->fcp_output_requests += stats->OutputRequests;
 		fcoe_stats->fcp_control_requests += stats->ControlRequests;
-		fcoe_stats->fcp_input_megabytes += stats->InputMegabytes;
-		fcoe_stats->fcp_output_megabytes += stats->OutputMegabytes;
+		fcp_in_bytes += stats->InputBytes;
+		fcp_out_bytes += stats->OutputBytes;
 		fcoe_stats->link_failure_count += stats->LinkFailureCount;
 	}
+	fcoe_stats->fcp_input_megabytes = div_u64(fcp_in_bytes, 1000000);
+	fcoe_stats->fcp_output_megabytes = div_u64(fcp_out_bytes, 1000000);
 	fcoe_stats->lip_count = -1;
 	fcoe_stats->nos_count = -1;
 	fcoe_stats->loss_of_sync_count = -1;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 1463660..8d719e8 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -221,8 +221,8 @@ struct fc_rport_priv {
  * @InputRequests:         Number of input requests
  * @OutputRequests:        Number of output requests
  * @ControlRequests:       Number of control requests
- * @InputMegabytes:        Number of received megabytes
- * @OutputMegabytes:       Number of transmitted megabytes
+ * @InputBytes:            Number of received bytes
+ * @OutputBytes:           Number of transmitted bytes
  * @VLinkFailureCount:     Number of virtual link failures
  * @MissDiscAdvCount:      Number of missing FIP discovery advertisement
  */
@@ -241,8 +241,8 @@ struct fcoe_dev_stats {
 	u64		InputRequests;
 	u64		OutputRequests;
 	u64		ControlRequests;
-	u64		InputMegabytes;
-	u64		OutputMegabytes;
+	u64		InputBytes;
+	u64		OutputBytes;
 	u64		VLinkFailureCount;
 	u64		MissDiscAdvCount;
 };

