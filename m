From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/9] qla2xxx: Validate mid-layer 'underflow' during check-condition handling.
Date: Thu, 19 Jul 2007 15:05:59 -0700
Message-ID: <11848827641168-git-send-email-andrew.vasquez@qlogic.com>
References: <20070719220456.GK4015@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27113 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763336AbXGSWHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 18:07:04 -0400
In-Reply-To: <20070719220456.GK4015@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fa21cd8..4a50b93 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1062,6 +1062,25 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			    cp->device->id, cp->device->lun, cp,
 			    cp->serial_number));
 
+			/*
+			 * In case of a Underrun condition, set both the lscsi
+			 * status and the completion status to appropriate
+			 * values.
+			 */
+			if (resid &&
+			    ((unsigned)(cp->request_bufflen - resid) <
+			     cp->underflow)) {
+				DEBUG2(qla_printk(KERN_INFO, ha,
+				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
+				    "detected (%x of %x bytes)...returning "
+				    "error status.\n", ha->host_no,
+				    cp->device->channel, cp->device->id,
+				    cp->device->lun, resid,
+				    cp->request_bufflen));
+
+				cp->result = DID_ERROR << 16 | lscsi_status;
+			}
+
 			if (sense_len)
 				DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
 				    CMD_ACTUAL_SNSLEN(cp)));
-- 
1.5.3.rc2.4.g726f9

