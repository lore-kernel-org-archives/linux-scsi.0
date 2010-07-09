From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 10/24] bfa: fix prli retry issues
Date: Thu, 8 Jul 2010 19:52:00 -0700
Message-ID: <1278643920-31067-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:36259 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876Ab0GICwG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:52:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Add a max retry limit for PRLI retries. Max retry limit (5) is same as used
in rport PLOGI. Once the retries are exhausted, invoke rport offline so that
existing logic of rport re-discovery can kick-in. Also fixed a bug in rport.c
where one less retry was happening.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/fcpim.c                     |   13 +++++++++++--
 drivers/scsi/bfa/fcs_rport.h                 |    2 ++
 drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h |    1 +
 drivers/scsi/bfa/rport.c                     |    4 +---
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/fcpim.c b/drivers/scsi/bfa/fcpim.c
index 7a0207e..d090f7a 100644
--- a/drivers/scsi/bfa/fcpim.c
+++ b/drivers/scsi/bfa/fcpim.c
@@ -110,6 +110,7 @@ bfa_fcs_itnim_sm_offline(struct bfa_fcs_itnim_s *itnim,
 	switch (event) {
 	case BFA_FCS_ITNIM_SM_ONLINE:
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_prli_send);
+		itnim->prli_retries = 0;
 		bfa_fcs_itnim_send_prli(itnim, NULL);
 		break;
 
@@ -218,8 +219,16 @@ bfa_fcs_itnim_sm_prli_retry(struct bfa_fcs_itnim_s *itnim,
 
 	switch (event) {
 	case BFA_FCS_ITNIM_SM_TIMEOUT:
-		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_prli_send);
-		bfa_fcs_itnim_send_prli(itnim, NULL);
+		if (itnim->prli_retries < BFA_FCS_RPORT_MAX_RETRIES) {
+			itnim->prli_retries++;
+			bfa_trc(itnim->fcs, itnim->prli_retries);
+			bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_prli_send);
+			bfa_fcs_itnim_send_prli(itnim, NULL);
+		} else {
+			/* invoke target offline */
+			bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+			bfa_fcs_rport_logo_imp(itnim->rport);
+		}
 		break;
 
 	case BFA_FCS_ITNIM_SM_OFFLINE:
diff --git a/drivers/scsi/bfa/fcs_rport.h b/drivers/scsi/bfa/fcs_rport.h
index 9c8d1d2..5242ee0 100644
--- a/drivers/scsi/bfa/fcs_rport.h
+++ b/drivers/scsi/bfa/fcs_rport.h
@@ -24,6 +24,8 @@
 
 #include <fcs/bfa_fcs_rport.h>
 
+#define BFA_FCS_RPORT_MAX_RETRIES               (5)
+
 void bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
 			u16 len);
 void bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport);
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h b/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h
index e719f2c..9a35ecf 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h
@@ -41,6 +41,7 @@ struct bfa_fcs_itnim_s {
 	struct bfa_fcs_s      	*fcs;		/*  fcs instance         */
 	struct bfa_timer_s 	timer;		/*  timer functions      */
 	struct bfa_itnim_s 	*bfa_itnim;	/*  BFA itnim struct     */
+	u32                	prli_retries;   /*  max prli retry attempts */
 	bfa_boolean_t	 	seq_rec;	/*  seq recovery support */
 	bfa_boolean_t	 	rec_support;	/*  REC supported        */
 	bfa_boolean_t	 	conf_comp;	/*  FCP_CONF     support */
diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index 2796403..4e1fff2 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -36,8 +36,6 @@
 
 BFA_TRC_FILE(FCS, RPORT);
 
-#define BFA_FCS_RPORT_MAX_RETRIES		(5)
-
 /* In millisecs */
 static u32 bfa_fcs_rport_del_timeout =
 			BFA_FCS_RPORT_DEF_DEL_TIMEOUT * 1000;
@@ -356,8 +354,8 @@ bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
 		 */
 
 	case RPSM_EVENT_TIMEOUT:
-		rport->plogi_retries++;
 		if (rport->plogi_retries < BFA_FCS_RPORT_MAX_RETRIES) {
+			rport->plogi_retries++;
 			bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogi_sending);
 			bfa_fcs_rport_send_plogi(rport, NULL);
 		} else {
-- 
1.6.5.2

