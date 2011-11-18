From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 13/14] qla2xxx: Submit all chained IOCBs for passthrough commands on request queue 0.
Date: Fri, 18 Nov 2011 09:02:21 -0800
Message-ID: <1321635742-16426-14-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:41340
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758208Ab1KRRPb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:31 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index dbec896..a4b267e 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -120,11 +120,10 @@ qla2x00_prep_cont_type0_iocb(struct scsi_qla_host *vha)
  * Returns a pointer to the continuation type 1 IOCB packet.
  */
 static inline cont_a64_entry_t *
-qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha)
+qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha, struct req_que *req)
 {
 	cont_a64_entry_t *cont_pkt;
 
-	struct req_que *req = vha->req;
 	/* Adjust ring index. */
 	req->ring_index++;
 	if (req->ring_index == req->length) {
@@ -292,7 +291,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, vha->req);
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 		}
@@ -684,7 +683,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, vha->req);
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 		}
@@ -2070,7 +2069,8 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 			* Five DSDs are available in the Cont.
 			* Type 1 IOCB.
 			       */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
+			    vha->hw->req_q_map[0]);
 			cur_dsd = (uint32_t *) cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 			cont_iocb_prsnt = 1;
@@ -2096,6 +2096,7 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 	int index;
 	uint16_t tot_dsds;
         scsi_qla_host_t *vha = sp->fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
 	struct fc_bsg_job *bsg_job = ((struct srb_ctx *)sp->ctx)->u.bsg_job;
 	int loop_iterartion = 0;
 	int cont_iocb_prsnt = 0;
@@ -2141,7 +2142,8 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 			* Five DSDs are available in the Cont.
 			* Type 1 IOCB.
 			       */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
+			    ha->req_q_map[0]);
 			cur_dsd = (uint32_t *) cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 			cont_iocb_prsnt = 1;
-- 
1.6.0.2


