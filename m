From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/8] qla2xxx: Correct synchronization of software/firmware fcport states.
Date: Wed, 13 Aug 2008 21:36:56 -0700
Message-ID: <1218688622-71361-2-git-send-email-andrew.vasquez@qlogic.com>
References: <20080814043632.GL61889@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57991 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYHNEhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 00:37:06 -0400
In-Reply-To: <20080814043632.GL61889@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Greg Wettstein (greg@enjellic.com) noted:

	http://article.gmane.org/gmane.linux.scsi/43409

on a reboot of a previously recognized SCST target, the initiator
driver would be unable to re-recognize the device as a target.
It turns out that prior to the SCST software reloading and
returning it's "target-capable" abilities in the PRLI payload,
the HBA would be re-initialized as an initiator-only type port.
Since initiators typically classify themselves as an FCP-2
capable device, both software and firmware do not perform an
explicit logout during port-loss.  Unfortunately, as can be seen
by the failure case, when the port (now target-capable) returns,
firmware performs an ADISC without a follow-on PRLI, leaving
stale 'initiator-only' data in the firmware's port database.

Correct the discrepancy by performing the explicit logout during
the transport's request to terminate-rport-io, thus synchronizing
port states and ensuring a follow-on PRLI is performed.

Reported-by: Greg Wettstein <greg@enjellic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a319a20..45e7dcb 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -993,6 +993,17 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 {
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 
+	/*
+	 * At this point all fcport's software-states are cleared.  Perform any
+	 * final cleanup of firmware resources (PCBs and XCBs).
+	 */
+	if (fcport->loop_id != FC_NO_LOOP_ID) {
+		fcport->ha->isp_ops->fabric_logout(fcport->ha, fcport->loop_id,
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa);
+		fcport->loop_id = FC_NO_LOOP_ID;
+	}
+
 	qla2x00_abort_fcport_cmds(fcport);
 	scsi_target_unblock(&rport->dev);
 }
-- 
1.6.0.rc2.22.g71b9

