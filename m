From: giridhar.malavali@qlogic.com
Subject: [PATCH 02/12] qla2xxx: Correctly handle 'global port-unavailable' AEN.
Date: Fri, 31 Jul 2009 15:09:24 -0700
Message-ID: <1249078174-1957-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36781 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031AbZGaWJg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 18:09:36 -0400
In-Reply-To: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Treat a global port-unavailable PORT_UPDATE (8014h) AEN as a
loop-down event.  For this case, within the FCoE domain, the
'logical' interface has been terminated, but the driver will
not receive the classic LOOP_DOWN AEN.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f966d54..417a9b9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -599,8 +599,36 @@ skip_rio:
 
 	case MBA_PORT_UPDATE:		/* Port database update */
 		/* Only handle SCNs for our Vport index. */
-		if (vha->vp_idx && vha->vp_idx != (mb[3] & 0xff))
+		if (mb[1] != 0xffff &&
+		    vha->vp_idx && vha->vp_idx != (mb[3] & 0xff))
+			break;
+
+		/* Global event -- port logout or port unavailable. */
+		if (mb[1] == 0xffff && mb[2] == 0x7) {
+			DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE.\n",
+			    vha->host_no));
+			DEBUG(printk(KERN_INFO
+			    "scsi(%ld): Port unavailable %04x %04x %04x.\n",
+			    vha->host_no, mb[1], mb[2], mb[3]));
+
+			if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
+				atomic_set(&vha->loop_state, LOOP_DOWN);
+				atomic_set(&vha->loop_down_timer,
+				    LOOP_DOWN_TIME);
+				vha->device_flags |= DFLG_NO_CABLE;
+				qla2x00_mark_all_devices_lost(vha, 1);
+			}
+
+			if (vha->vp_idx) {
+				atomic_set(&vha->vp_state, VP_FAILED);
+				fc_vport_set_state(vha->fc_vport,
+				    FC_VPORT_FAILED);
+			}
+
+			vha->flags.management_server_logged_in = 0;
+			ha->link_data_rate = PORT_SPEED_UNKNOWN;
 			break;
+		}
 
 		/*
 		 * If PORT UPDATE is global (received LIP_OCCURRED/LIP_RESET
-- 
1.6.2.rc1.30.gd43c

