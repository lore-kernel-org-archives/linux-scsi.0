From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/6] qla2xxx: Correct vp_idx checking during PORT_UPDATE processing.
Date: Fri, 19 Mar 2010 16:59:17 -0700
Message-ID: <1269043161-2265-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46295 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752158Ab0CSX7X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 19:59:23 -0400
In-Reply-To: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Checks should only be done for NPIV-capable ISPs.  Original code
could result in PORT_UPDATEs being missed on non-NPIV-capable
ISPs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ab90329..295337d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -620,11 +620,10 @@ skip_rio:
 		 *           vp_idx does not match
 		 *       Event is not global, vp_idx does not match
 		 */
-		if ((mb[1] == 0xffff && (mb[3] & 0xff) != 0xff)
-			|| (mb[1] != 0xffff)) {
-			if (vha->vp_idx != (mb[3] & 0xff))
-				break;
-		}
+		if (IS_QLA2XXX_MIDTYPE(ha) &&
+		    ((mb[1] == 0xffff && (mb[3] & 0xff) != 0xff) ||
+			(mb[1] != 0xffff)) && vha->vp_idx != (mb[3] & 0xff))
+			break;
 
 		/* Global event -- port logout or port unavailable. */
 		if (mb[1] == 0xffff && mb[2] == 0x7) {
-- 
1.6.2.rc1.30.gd43c

