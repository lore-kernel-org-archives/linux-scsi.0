From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/26] qla2xxx: Preserve an fcport's loop-id after terminate_rport_io().
Date: Tue, 24 Mar 2009 09:08:02 -0700
Message-ID: <1237910900-30817-9-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762256AbZCXQIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:31 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Since in some circumstances, login-retries may be occuring in the
background via the DPC routine.  This race, in the inadvertant
setting of the loop-id to 'NONE' breaks the existing retry logic.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ee9d401..664d610 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1036,12 +1036,10 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	 * At this point all fcport's software-states are cleared.  Perform any
 	 * final cleanup of firmware resources (PCBs and XCBs).
 	 */
-	if (fcport->loop_id != FC_NO_LOOP_ID) {
+	if (fcport->loop_id != FC_NO_LOOP_ID)
 		fcport->vha->hw->isp_ops->fabric_logout(fcport->vha,
 			fcport->loop_id, fcport->d_id.b.domain,
 			fcport->d_id.b.area, fcport->d_id.b.al_pa);
-		fcport->loop_id = FC_NO_LOOP_ID;
-	}
 
 	qla2x00_abort_fcport_cmds(fcport);
 }
-- 
1.6.2.rc0.55.g30aa4f

