From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/14] qla2xxx: Enable queue-full throttling when UNDERRUN detected.
Date: Mon, 29 Jan 2007 10:22:27 -0800
Message-ID: <11700949514147-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXA2SWh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:37 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

As ISP24xx firmware can return a CS_DATA_UNDERRUN completion
status when the storage has returned a
SAM_STAT_TASK_SET_FULL scsi-status.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fe8a264..3cd34ba 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -991,6 +991,22 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		if (lscsi_status != 0) {
 			cp->result = DID_OK << 16 | lscsi_status;
 
+			if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
+				DEBUG2(printk(KERN_INFO
+				    "scsi(%ld): QUEUE FULL status detected "
+				    "0x%x-0x%x.\n", ha->host_no, comp_status,
+				    scsi_status));
+
+				/*
+				 * Adjust queue depth for all luns on the
+				 * port.
+				 */
+				fcport->last_queue_full = jiffies;
+				starget_for_each_device(
+				    cp->device->sdev_target, fcport,
+				    qla2x00_adjust_sdev_qdepth_down);
+				break;
+			}
 			if (lscsi_status != SS_CHECK_CONDITION)
 				break;
 
-- 
1.5.0.rc2.gdbaa0

