From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH V2 09/15] qedf: Add bus_reset No-op.
Date: Wed, 31 May 2017 06:33:56 -0700
Message-ID: <20170531133402.16629-10-chad.dupuis@cavium.com>
References: <20170531133402.16629-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0089.outbound.protection.outlook.com ([104.47.37.89]:41385
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751151AbdEaNep (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 09:34:45 -0400
In-Reply-To: <20170531133402.16629-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

We need to add a bus reset no-op as without it some of the LUNs attached to a
vport may go offline when the error handler escalates to host reset due to not
having a bus reset handler in the driver. What happens is we escalate to host
reset which does a soft link down/link up to reset the adapter. However with
multiple vports attached it's been observed that if the vports do log back into
the target within 5 seconds, the SCSI layer offlines the devices most likely
due to a TUR timing out to verify that the device is online. Adding a bus
reset handler will cause the TUR to be sent after the bus reset handler where
the devices will still be online if the bus reset is initiated by sg_reset
(which is the case in the test that was failing). The bus reset will succeed
and not needlessly bring the device offline/online.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 99d8822..d762b9f 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -628,6 +628,16 @@ static int qedf_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	return qedf_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
 }
 
+static int qedf_eh_bus_reset(struct scsi_cmnd *sc_cmd)
+{
+	QEDF_ERR(NULL, "BUS RESET Issued...\n");
+	/*
+	 * Essentially a no-op but return SUCCESS to prevent
+	 * unnecessary escalation to the host reset handler.
+	 */
+	return SUCCESS;
+}
+
 void qedf_wait_for_upload(struct qedf_ctx *qedf)
 {
 	while (1) {
@@ -705,6 +715,7 @@ static int qedf_slave_configure(struct scsi_device *sdev)
 	.eh_abort_handler	= qedf_eh_abort,
 	.eh_device_reset_handler = qedf_eh_device_reset, /* lun reset */
 	.eh_target_reset_handler = qedf_eh_target_reset, /* target reset */
+	.eh_bus_reset_handler = qedf_eh_bus_reset,
 	.eh_host_reset_handler  = qedf_eh_host_reset,
 	.slave_configure	= qedf_slave_configure,
 	.dma_boundary = QED_HW_DMA_BOUNDARY,
-- 
1.8.5.6
