From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/20] qla2xxx: Use 'proper' DID_* status code for dropped-frame scenarios.
Date: Wed,  3 Jun 2009 09:55:18 -0700
Message-ID: <1244048131-56590-8-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZFCQzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:36 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

The SCSI-midlayer's fast-fail codes consider an DID_ERROR status
as a driver-error and the failed I/O would then be retried in the
midlayer without being fast-failed to dm-multipath.  DID_BUS_BUSY
status returns would induce unneeded path-failures events being
propagated to the DM/MD.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index eb35d20..c8d0a17 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1211,7 +1211,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			/*
 			 * If RISC reports underrun and target does not report
 			 * it then we must have a lost frame, so tell upper
-			 * layer to retry it by reporting a bus busy.
+			 * layer to retry it by reporting an error.
 			 */
 			if (!(scsi_status & SS_RESIDUAL_UNDER)) {
 				DEBUG2(printk("scsi(%ld:%d:%d:%d) Dropped "
@@ -1221,7 +1221,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 					cp->device->id, cp->device->lun, resid,
 					scsi_bufflen(cp)));
 
-				cp->result = DID_BUS_BUSY << 16;
+				cp->result = DID_ERROR << 16;
 				break;
 			}
 
-- 
1.6.3.1.244.gf9275

