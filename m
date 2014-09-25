From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 29/35] qla2xxx: Restore WWPN in case of Loop Dead.
Date: Thu, 25 Sep 2014 05:17:00 -0400
Message-ID: <1411636626-7566-30-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:42065 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007AbaIYJv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:26 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

For FA-WWPN capable device, ISP2031 and ISP27XX, when loop
dead is detected by a driver, restore WWPN from NVRAM.

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    3 +--
 drivers/scsi/qla2xxx/qla_def.h  |    3 ++-
 drivers/scsi/qla2xxx/qla_init.c |    5 +++++
 drivers/scsi/qla2xxx/qla_isr.c  |   10 ++++++++++
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index b21adb3..5f25cf0 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,8 +11,7 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x017d       | 0x0141		|
- * |                              |                    | 0x0144,0x0146	|
+ * | Module Init and Probe        |       0x017d       | 0x0144,0x0146	|
  * |                              |                    | 0x015b-0x0160	|
  * |                              |                    | 0x016e-0x0170	|
  * | Mailbox commands             |       0x118d       | 0x1115-0x1116	|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d529510..a3bab3a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2945,7 +2945,8 @@ struct qla_hw_data {
 
 		uint32_t        mr_reset_hdlr_active:1;
 		uint32_t        mr_intr_valid:1;
-		/* 34 bits */
+		uint32_t	fawwpn_enabled:1;
+		/* 35 bits */
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 51cabb9..23f12dd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2202,6 +2202,11 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		if (IS_DPORT_CAPABLE(ha))
 			mid_init_cb->init_cb.firmware_options_1 |=
 			    cpu_to_le16(BIT_7);
+		/* Enable FA-WWPN */
+		ha->flags.fawwpn_enabled =
+		    (mid_init_cb->init_cb.firmware_options_1 & BIT_6) ? 1 : 0;
+		ql_dbg(ql_dbg_init, vha, 0x0141, "FA-WWPN Support: %s.\n",
+		    (ha->flags.fawwpn_enabled) ? "enabled" : "disabled");
 	}
 
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f15f87e..696e4a2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -752,6 +752,16 @@ skip_rio:
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 			atomic_set(&vha->loop_state, LOOP_DOWN);
 			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+			/*
+			 * In case of loop down, restore WWPN from
+			 * NVRAM in case of FA-WWPN capable ISP
+			 */
+			if (ha->flags.fawwpn_enabled) {
+				void *wwpn = ha->init_cb->port_name;
+
+				memcpy(vha->port_name, wwpn, WWN_SIZE);
+			}
+
 			vha->device_flags |= DFLG_NO_CABLE;
 			qla2x00_mark_all_devices_lost(vha, 1);
 		}
-- 
1.7.7

