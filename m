From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/8] qla2xxx: Additional residual-count corrections during UNDERRUN handling.
Date: Thu, 11 Sep 2008 21:22:52 -0700
Message-ID: <1221193374-77635-7-git-send-email-andrew.vasquez@qlogic.com>
References: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46751 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYILEXA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 00:23:00 -0400
In-Reply-To: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Add additional tightening of residual-count handling (originally
from commit 6acf8190025e9c4ea513d4084ff089d476112816) where the
driver should discard any lower SCSI-status during
firmware/transport residual-count mismatches.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 2a8db44..1b17161 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1060,8 +1060,9 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		resid = resid_len;
 		/* Use F/W calculated residual length. */
 		if (IS_FWI2_CAPABLE(ha)) {
-			if (scsi_status & SS_RESIDUAL_UNDER &&
-			    resid != fw_resid_len) {
+			if (!(scsi_status & SS_RESIDUAL_UNDER)) {
+				lscsi_status = 0;
+			} else if (resid != fw_resid_len) {
 				scsi_status &= ~SS_RESIDUAL_UNDER;
 				lscsi_status = 0;
 			}
-- 
1.6.0.1.294.gda06a

