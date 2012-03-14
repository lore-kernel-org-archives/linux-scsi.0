From: <kgudipat@brocade.com>
Subject: [PATCH 6/9] bfa: Move service parameter programming logic into firmware.
Date: Tue, 13 Mar 2012 17:40:01 -0700
Message-ID: <1331685601-21922-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:53321 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760475Ab2CNBhp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2012 21:37:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Programming of the service parameters Tx credits etc., is now done in firmware.
	- Remove the logic of sending the service parameters to firmware from driver.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_svc.c |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index f92a85f..3abe2be 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -3084,33 +3084,6 @@ bfa_fcport_set_wwns(struct bfa_fcport_s *fcport)
 }
 
 static void
-bfa_fcport_send_txcredit(void *port_cbarg)
-{
-
-	struct bfa_fcport_s *fcport = port_cbarg;
-	struct bfi_fcport_set_svc_params_req_s *m;
-
-	/*
-	 * check for room in queue to send request now
-	 */
-	m = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
-	if (!m) {
-		bfa_trc(fcport->bfa, fcport->cfg.tx_bbcredit);
-		return;
-	}
-
-	bfi_h2i_set(m->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ,
-			bfa_fn_lpu(fcport->bfa));
-	m->tx_bbcredit = cpu_to_be16((u16)fcport->cfg.tx_bbcredit);
-	m->bb_scn = fcport->cfg.bb_scn;
-
-	/*
-	 * queue I/O message to firmware
-	 */
-	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT, m->mh);
-}
-
-static void
 bfa_fcport_qos_stats_swap(struct bfa_qos_stats_s *d,
 	struct bfa_qos_stats_s *s)
 {
@@ -3765,7 +3738,6 @@ bfa_fcport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit, u8 bb_scn)
 	fcport->cfg.bb_scn = bb_scn;
 	if (bb_scn)
 		fcport->bbsc_op_state = BFA_TRUE;
-	bfa_fcport_send_txcredit(fcport);
 }
 
 /*
-- 
1.7.3.rc1

