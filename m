From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/9] qla2xxx: Skip RSCN processing if the event is global and vp_idx index
Date: Tue, 21 Jul 2009 12:03:39 -0700
Message-ID: <1248203025-507-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1248203025-507-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:37724 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754834AbZGUTDs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jul 2009 15:03:48 -0400
In-Reply-To: <1248203025-507-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Santosh Vernekar <santosh.vernekar@qlogic.com>

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

obtained does not belong to us.
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 417a9b9..00f23d2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -598,10 +598,26 @@ skip_rio:
 		break;
 
 	case MBA_PORT_UPDATE:		/* Port database update */
-		/* Only handle SCNs for our Vport index. */
-		if (mb[1] != 0xffff &&
-		    vha->vp_idx && vha->vp_idx != (mb[3] & 0xff))
-			break;
+		/*
+		 * Handle only global and vn-port update events
+		 *
+		 * Relevant inputs:
+		 * mb[1] = N_Port handle of changed port
+		 * OR 0xffff for global event
+		 * mb[2] = New login state
+		 * 7 = Port logged out
+		 * mb[3] = LSB is vp_idx, 0xff = all vps
+		 *
+		 * Skip processing if:
+		 *       Event is global, vp_idx is NOT all vps,
+		 *           vp_idx does not match
+		 *       Event is not global, vp_idx does not match
+		 */
+		if ((mb[1] == 0xffff && (mb[3] & 0xff) != 0xff)
+			|| (mb[1] != 0xffff)) {
+			if (vha->vp_idx != (mb[3] & 0xff))
+				break;
+		}
 
 		/* Global event -- port logout or port unavailable. */
 		if (mb[1] == 0xffff && mb[2] == 0x7) {
-- 
1.6.2.rc1.30.gd43c

