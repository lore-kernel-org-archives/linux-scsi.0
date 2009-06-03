From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 16/20] qla2xxx: Avoid explicit LOGO during driver host tear-down.
Date: Wed,  3 Jun 2009 09:55:27 -0700
Message-ID: <1244048131-56590-17-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbZFCQzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:44 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

As firmware will ultimately terminate (stop) and port
states-cleared.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 74e6970..cbdafb0 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1465,7 +1465,8 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	 * At this point all fcport's software-states are cleared.  Perform any
 	 * final cleanup of firmware resources (PCBs and XCBs).
 	 */
-	if (fcport->loop_id != FC_NO_LOOP_ID)
+	if (fcport->loop_id != FC_NO_LOOP_ID &&
+	    !test_bit(UNLOADING, &fcport->vha->dpc_flags))
 		fcport->vha->hw->isp_ops->fabric_logout(fcport->vha,
 			fcport->loop_id, fcport->d_id.b.domain,
 			fcport->d_id.b.area, fcport->d_id.b.al_pa);
-- 
1.6.3.1.244.gf9275

