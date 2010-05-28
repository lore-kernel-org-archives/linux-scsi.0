From: giridhar.malavali@qlogic.com
Subject: [PATCH 06/17] qla2xxx: Limit rport-flaps during link-disruptions.
Date: Fri, 28 May 2010 15:08:20 -0700
Message-ID: <1275084511-95266-7-git-send-email-giridhar.malavali@qlogic.com>
References: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52689 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752212Ab0E1WId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:33 -0400
In-Reply-To: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cc73525..9d969b5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2651,7 +2651,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		if (test_bit(RSCN_UPDATE, &save_flags)) {
 			set_bit(RSCN_UPDATE, &vha->dpc_flags);
-			vha->flags.rscn_queue_overflow = 1;
+			if (!IS_ALOGIO_CAPABLE(ha))
+				vha->flags.rscn_queue_overflow = 1;
 		}
 	}
 
@@ -3209,8 +3210,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		if (qla2x00_is_reserved_id(vha, loop_id))
 			continue;
 
-		if (atomic_read(&vha->loop_down_timer) ||
-		    LOOP_TRANSITION(vha)) {
+		if (ha->current_topology == ISP_CFG_FL &&
+		    (atomic_read(&vha->loop_down_timer) ||
+		     LOOP_TRANSITION(vha))) {
 			atomic_set(&vha->loop_down_timer, 0);
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
-- 
1.6.2.rc1.30.gd43c

