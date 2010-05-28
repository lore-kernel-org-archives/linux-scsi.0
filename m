From: giridhar.malavali@qlogic.com
Subject: [PATCH 10/17] qla2xxx: Do not enable VP in non fabric topology.
Date: Fri, 28 May 2010 15:08:24 -0700
Message-ID: <1275084511-95266-11-git-send-email-giridhar.malavali@qlogic.com>
References: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52693 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751778Ab0E1WId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:33 -0400
In-Reply-To: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

After topology change ISP is reset and VPs are re-enabled.
If the topology is not fabric, VPs could falsely get enabled.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 8220e7b..d1618b4 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -136,7 +136,8 @@ qla24xx_enable_vp(scsi_qla_host_t *vha)
 
 	/* Check if physical ha port is Up */
 	if (atomic_read(&base_vha->loop_state) == LOOP_DOWN  ||
-		atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
+		atomic_read(&base_vha->loop_state) == LOOP_DEAD ||
+		!(ha->current_topology & ISP_CFG_F)) {
 		vha->vp_err_state =  VP_ERR_PORTDWN;
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_LINKDOWN);
 		goto enable_failed;
-- 
1.6.2.rc1.30.gd43c

