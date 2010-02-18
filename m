From: giridhar.malavali@qlogic.com
Subject: [PATCH 5/8] qla2xxx: Correct loop-resync issues during SNS scans.
Date: Thu, 18 Feb 2010 08:38:31 -0800
Message-ID: <1266511114-307-6-git-send-email-giridhar.malavali@qlogic.com>
References: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:34764 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1758576Ab0BRQil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 11:38:41 -0500
In-Reply-To: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code could inadvertently skip the post processing of
port information returned from the SNS scan, if any link-flopping
asynchronous-events were received (noticed in FCAL topologies).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1128c8d..96a609b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2910,8 +2910,13 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		if (qla2x00_is_reserved_id(vha, loop_id))
 			continue;
 
-		if (atomic_read(&vha->loop_down_timer) || LOOP_TRANSITION(vha))
+		if (atomic_read(&vha->loop_down_timer) ||
+		    LOOP_TRANSITION(vha)) {
+			atomic_set(&vha->loop_down_timer, 0);
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			break;
+		}
 
 		if (swl != NULL) {
 			if (last_dev) {
-- 
1.6.2.rc1.30.gd43c

