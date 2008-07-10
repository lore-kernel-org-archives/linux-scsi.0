From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 16/18] qla2xxx: Verify the RISC is not in ROM code if firmware-load is disabled.
Date: Thu, 10 Jul 2008 16:56:01 -0700
Message-ID: <1215734163-40825-16-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646AbYGJX4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:16 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Add an additional check to verify that the current executing
firmware is in fact non-ROM code.  The non-ROM Get-ID mailbox
command is used for verification.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    7 +++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f8cfeb0..fd3ff5e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -334,6 +334,8 @@ static int
 qla2x00_isp_firmware(scsi_qla_host_t *ha)
 {
 	int  rval;
+	uint16_t loop_id, topo, sw_cap;
+	uint8_t domain, area, al_pa;
 
 	/* Assume loading risc code */
 	rval = QLA_FUNCTION_FAILED;
@@ -345,6 +347,11 @@ qla2x00_isp_firmware(scsi_qla_host_t *ha)
 
 		/* Verify checksum of loaded RISC code. */
 		rval = qla2x00_verify_checksum(ha, ha->fw_srisc_address);
+		if (rval == QLA_SUCCESS) {
+			/* And, verify we are not in ROM code. */
+			rval = qla2x00_get_adapter_id(ha, &loop_id, &al_pa,
+			    &area, &domain, &topo, &sw_cap);
+		}
 	}
 
 	if (rval) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index dc5788b..7d7de59 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -919,6 +919,8 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (mcp->mb[0] == MBS_COMMAND_ERROR)
 		rval = QLA_COMMAND_ERROR;
+	else if (mcp->mb[0] == MBS_INVALID_COMMAND)
+		rval = QLA_INVALID_COMMAND;
 
 	/* Return data. */
 	*id = mcp->mb[1];
-- 
1.5.6.2.292.ga9a3

