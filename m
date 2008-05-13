From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/10] qla2xxx: Revert "qla2xxx: Validate mid-layer 'underflow' during check-condition handling."
Date: Mon, 12 May 2008 22:21:15 -0700
Message-ID: <1210656076-54720-9-git-send-email-andrew.vasquez@qlogic.com>
References: <20080513051948.GN22377@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52305 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbYEMFVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 01:21:22 -0400
In-Reply-To: <20080513051948.GN22377@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

This reverts commit 8084fe168a5252548cdddf2ed181c337fecd0523.
The midlayer should be given the oppotunity to interpret the
check-condition and based on scsi_cmnd->resid determine if a
transfer should be retried or failed.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0793aa9..14bcd7c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1132,25 +1132,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 				break;
 
 			qla2x00_handle_sense(sp, sense_data, sense_len);
-
-			/*
-			 * In case of a Underrun condition, set both the lscsi
-			 * status and the completion status to appropriate
-			 * values.
-			 */
-			if (resid &&
-			    ((unsigned)(scsi_bufflen(cp) - resid) <
-			     cp->underflow)) {
-				DEBUG2(qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
-				    "detected (%x of %x bytes)...returning "
-				    "error status.\n", ha->host_no,
-				    cp->device->channel, cp->device->id,
-				    cp->device->lun, resid,
-				    scsi_bufflen(cp)));
-
-				cp->result = DID_ERROR << 16 | lscsi_status;
-			}
 		} else {
 			/*
 			 * If RISC reports underrun and target does not report
-- 
1.5.5.1.211.g65ea3

