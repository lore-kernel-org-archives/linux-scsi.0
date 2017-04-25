From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 29/37] smartpqi: map more raid errors to SCSI errors
Date: Tue, 25 Apr 2017 14:48:49 -0500
Message-ID: <149314972943.13903.12547252191952346399.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0073.outbound.protection.outlook.com ([104.47.41.73]:52160
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1430733AbdDYTtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:49:19 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

enhance mapping of RAID path errors to Linux SCSI host
error codes.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 790dfc4..e841c1b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2447,13 +2447,43 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 	scsi_status = error_info->status;
 	host_byte = DID_OK;
 
-	if (error_info->data_out_result == PQI_DATA_IN_OUT_UNDERFLOW) {
+	switch (error_info->data_out_result) {
+	case PQI_DATA_IN_OUT_GOOD:
+		break;
+	case PQI_DATA_IN_OUT_UNDERFLOW:
 		xfer_count =
 			get_unaligned_le32(&error_info->data_out_transferred);
 		residual_count = scsi_bufflen(scmd) - xfer_count;
 		scsi_set_resid(scmd, residual_count);
 		if (xfer_count < scmd->underflow)
 			host_byte = DID_SOFT_ERROR;
+		break;
+	case PQI_DATA_IN_OUT_UNSOLICITED_ABORT:
+	case PQI_DATA_IN_OUT_ABORTED:
+		host_byte = DID_ABORT;
+		break;
+	case PQI_DATA_IN_OUT_TIMEOUT:
+		host_byte = DID_TIME_OUT;
+		break;
+	case PQI_DATA_IN_OUT_BUFFER_OVERFLOW:
+	case PQI_DATA_IN_OUT_PROTOCOL_ERROR:
+	case PQI_DATA_IN_OUT_BUFFER_ERROR:
+	case PQI_DATA_IN_OUT_BUFFER_OVERFLOW_DESCRIPTOR_AREA:
+	case PQI_DATA_IN_OUT_BUFFER_OVERFLOW_BRIDGE:
+	case PQI_DATA_IN_OUT_ERROR:
+	case PQI_DATA_IN_OUT_HARDWARE_ERROR:
+	case PQI_DATA_IN_OUT_PCIE_FABRIC_ERROR:
+	case PQI_DATA_IN_OUT_PCIE_COMPLETION_TIMEOUT:
+	case PQI_DATA_IN_OUT_PCIE_COMPLETER_ABORT_RECEIVED:
+	case PQI_DATA_IN_OUT_PCIE_UNSUPPORTED_REQUEST_RECEIVED:
+	case PQI_DATA_IN_OUT_PCIE_ECRC_CHECK_FAILED:
+	case PQI_DATA_IN_OUT_PCIE_UNSUPPORTED_REQUEST:
+	case PQI_DATA_IN_OUT_PCIE_ACS_VIOLATION:
+	case PQI_DATA_IN_OUT_PCIE_TLP_PREFIX_BLOCKED:
+	case PQI_DATA_IN_OUT_PCIE_POISONED_MEMORY_READ:
+	default:
+		host_byte = DID_ERROR;
+		break;
 	}
 
 	sense_data_length = get_unaligned_le16(&error_info->sense_data_length);
