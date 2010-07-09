From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 09/24] bfa: fix rport speed setting
Date: Thu, 8 Jul 2010 19:51:28 -0700
Message-ID: <1278643888-30719-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:36248 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041Ab0GICvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:51:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

When a rport goes offline, its speed setting was not reset. Subsequently, if
the rport was not deleted due to it coming back online within rport del
timeout, previously discovered speed would continue to show up. The fix is to
reset the speed when processing rport offline transition.

In rport attributes, rport's with unknown speed were indicated as TRL
enforced.  The right thing do to would be to use TRL default speed to
determine if TRL is enforced, when TRL is enabled.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/lport_api.c  |   30 +++++++++++++++++++++---------
 drivers/scsi/bfa/rport_api.c  |   11 ++++++++---
 drivers/scsi/bfa/rport_ftrs.c |    1 +
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/bfa/lport_api.c b/drivers/scsi/bfa/lport_api.c
index d3907d1..72b3f50 100644
--- a/drivers/scsi/bfa/lport_api.c
+++ b/drivers/scsi/bfa/lport_api.c
@@ -137,6 +137,8 @@ bfa_fcs_port_get_rports(struct bfa_fcs_port_s *port, wwn_t rport_wwns[],
 /*
  * Iterate's through all the rport's in the given port to
  * determine the maximum operating speed.
+ *
+ * To be used in TRL Functionality only
  */
 enum bfa_pport_speed
 bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port)
@@ -146,7 +148,8 @@ bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port)
 	struct bfa_fcs_s *fcs;
 	enum bfa_pport_speed max_speed = 0;
 	struct bfa_pport_attr_s pport_attr;
-	enum bfa_pport_speed pport_speed;
+	enum bfa_pport_speed pport_speed, rport_speed;
+	bfa_boolean_t     trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
 
 	if (port == NULL)
 		return 0;
@@ -164,19 +167,28 @@ bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port)
 	qe = bfa_q_first(qh);
 
 	while (qe != qh) {
-		rport = (struct bfa_fcs_rport_s *)qe;
-		if ((bfa_os_ntoh3b(rport->pid) > 0xFFF000)
-		    || (bfa_fcs_rport_get_state(rport) == BFA_RPORT_OFFLINE)) {
+		rport = (struct bfa_fcs_rport_s *) qe;
+		if ((bfa_os_ntoh3b(rport->pid) > 0xFFF000) ||
+			(bfa_fcs_rport_get_state(rport) ==
+						BFA_RPORT_OFFLINE)) {
 			qe = bfa_q_next(qe);
 			continue;
 		}
 
-		if ((rport->rpf.rpsc_speed == BFA_PPORT_SPEED_8GBPS)
-		    || (rport->rpf.rpsc_speed > pport_speed)) {
-			max_speed = rport->rpf.rpsc_speed;
+		rport_speed = rport->rpf.rpsc_speed;
+		if ((trl_enabled) &&  (rport_speed ==
+						BFA_PPORT_SPEED_UNKNOWN)) {
+			/* Use default ratelim speed setting */
+			rport_speed =
+				bfa_fcport_get_ratelim_speed(port->fcs->bfa);
+		}
+
+		if ((rport_speed  == BFA_PPORT_SPEED_8GBPS) ||
+			(rport_speed > pport_speed)) {
+			max_speed = rport_speed;
 			break;
-		} else if (rport->rpf.rpsc_speed > max_speed) {
-			max_speed = rport->rpf.rpsc_speed;
+		} else if (rport_speed > max_speed) {
+			max_speed = rport_speed;
 		}
 
 		qe = bfa_q_next(qe);
diff --git a/drivers/scsi/bfa/rport_api.c b/drivers/scsi/bfa/rport_api.c
index a441f41..15e0c47 100644
--- a/drivers/scsi/bfa/rport_api.c
+++ b/drivers/scsi/bfa/rport_api.c
@@ -83,6 +83,7 @@ bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
 {
 	struct bfa_rport_qos_attr_s qos_attr;
 	struct bfa_fcs_port_s *port = rport->port;
+	enum bfa_pport_speed rport_speed = rport->rpf.rpsc_speed;
 
 	bfa_os_memset(rport_attr, 0, sizeof(struct bfa_rport_attr_s));
 
@@ -102,10 +103,14 @@ bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
 	rport_attr->qos_attr = qos_attr;
 
 	rport_attr->trl_enforced = BFA_FALSE;
+
 	if (bfa_fcport_is_ratelim(port->fcs->bfa)) {
-		if ((rport->rpf.rpsc_speed == BFA_PPORT_SPEED_UNKNOWN) ||
-			(rport->rpf.rpsc_speed <
-			bfa_fcs_port_get_rport_max_speed(port)))
+		if (rport_speed == BFA_PPORT_SPEED_UNKNOWN) {
+			/* Use default ratelim speed setting */
+			rport_speed =
+				bfa_fcport_get_ratelim_speed(rport->fcs->bfa);
+		}
+		if (rport_speed < bfa_fcs_port_get_rport_max_speed(port))
 			rport_attr->trl_enforced = BFA_TRUE;
 	}
 
diff --git a/drivers/scsi/bfa/rport_ftrs.c b/drivers/scsi/bfa/rport_ftrs.c
index acecab8..f2a9361 100644
--- a/drivers/scsi/bfa/rport_ftrs.c
+++ b/drivers/scsi/bfa/rport_ftrs.c
@@ -274,6 +274,7 @@ void  bfa_fcs_rpf_rport_offline(struct bfa_fcs_rport_s *rport)
 	if (__fcs_min_cfg(rport->port->fcs))
 		return;
 
+	rport->rpf.rpsc_speed = 0;
 	bfa_sm_send_event(&rport->rpf, RPFSM_EVENT_RPORT_OFFLINE);
 }
 
-- 
1.6.5.2

