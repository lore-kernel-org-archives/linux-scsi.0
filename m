From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 10/22] qla2xxx: Fix issue with not displaying node name after system reboot.
Date: Wed, 30 Oct 2013 03:38:17 -0400
Message-ID: <1383118709-5569-11-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.156.153] ([67.231.156.153]:17174 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753016Ab3J3IL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:26 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_mr.c  |   18 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mr.h  |    3 +++
 drivers/scsi/qla2xxx/qla_os.c  |   10 ++++++++++
 5 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 149a1b5..66f6597 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -26,7 +26,7 @@
  * |                              |                    | 0x302d,0x3033  |
  * |                              |                    | 0x3036,0x3038  |
  * |                              |                    | 0x303a		|
- * | DPC Thread                   |       0x4022       | 0x4002,0x4013  |
+ * | DPC Thread                   |       0x4023       | 0x4002,0x4013  |
  * | Async Events                 |       0x5087       | 0x502b-0x502f  |
  * |                              |                    | 0x5047,0x5052  |
  * |                              |                    | 0x5084,0x5075	|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0fb01e1..ac62bca 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3370,6 +3370,7 @@ typedef struct scsi_qla_host {
 #define FX00_RESET_RECOVERY	23
 #define FX00_TARGET_SCAN	24
 #define FX00_CRITEMP_RECOVERY	25
+#define FX00_HOST_INFO_RESEND	26
 
 	uint32_t	device_flags;
 #define SWITCH_FOUND		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 4e418fc..3ac835e 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1612,6 +1612,22 @@ qlafx00_timer_routine(scsi_qla_host_t *vha)
 			ha->mr.fw_critemp_timer_tick--;
 		}
 	}
+	if (ha->mr.host_info_resend) {
+		/*
+		 * Incomplete host info might be sent to firmware
+		 * durinng system boot - info should be resend
+		 */
+		if (ha->mr.hinfo_resend_timer_tick == 0) {
+			ha->mr.host_info_resend = false;
+			set_bit(FX00_HOST_INFO_RESEND, &vha->dpc_flags);
+			ha->mr.hinfo_resend_timer_tick =
+			    QLAFX00_HINFO_RESEND_INTERVAL;
+			qla2xxx_wake_dpc(vha);
+		} else {
+			ha->mr.hinfo_resend_timer_tick--;
+		}
+	}
+
 }
 
 /*
@@ -1890,6 +1906,8 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 			    p_sysid->sysname, SYSNAME_LENGTH);
 			strncpy(phost_info->nodename,
 			    p_sysid->nodename, NODENAME_LENGTH);
+			if (!strcmp(phost_info->nodename, "(none)"))
+				ha->mr.host_info_resend = true;
 			strncpy(phost_info->release,
 			    p_sysid->release, RELEASE_LENGTH);
 			strncpy(phost_info->version,
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 79a93c5..a5ddea6 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -511,6 +511,8 @@ struct mr_data_fx00 {
 	uint32_t old_aenmbx0_state;
 	uint32_t critical_temperature;
 	bool extended_io_enabled;
+	bool host_info_resend;
+	uint8_t hinfo_resend_timer_tick;
 };
 
 #define QLAFX00_EXTENDED_IO_EN_MASK    0x20
@@ -537,6 +539,7 @@ struct mr_data_fx00 {
 #define QLAFX00_RESET_INTERVAL		120	/* number of seconds */
 #define QLAFX00_MAX_RESET_INTERVAL	600	/* number of seconds */
 #define QLAFX00_CRITEMP_INTERVAL	60	/* number of seconds */
+#define QLAFX00_HINFO_RESEND_INTERVAL	60	/* number of seconds */
 
 #define QLAFX00_CRITEMP_THRSHLD		80	/* Celsius degrees */
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9c5070e..ae447d9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2499,6 +2499,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mr.fw_reset_timer_tick = QLAFX00_RESET_INTERVAL;
 		ha->mr.fw_critemp_timer_tick = QLAFX00_CRITEMP_INTERVAL;
 		ha->mr.fw_hbt_en = 1;
+		ha->mr.host_info_resend = false;
+		ha->mr.hinfo_resend_timer_tick = QLAFX00_HINFO_RESEND_INTERVAL;
 	}
 
 	ql_dbg_pci(ql_dbg_init, pdev, 0x001e,
@@ -4872,6 +4874,14 @@ qla2x00_do_dpc(void *data)
 				ql_dbg(ql_dbg_dpc, base_vha, 0x401f,
 				    "ISPFx00 Target Scan End\n");
 			}
+			if (test_and_clear_bit(FX00_HOST_INFO_RESEND,
+				&base_vha->dpc_flags)) {
+				ql_dbg(ql_dbg_dpc, base_vha, 0x4023,
+				    "ISPFx00 Host Info resend scheduled\n");
+				qlafx00_fx_disc(base_vha,
+				    &base_vha->hw->mr.fcport,
+				    FXDISC_REG_HOST_INFO);
+			}
 		}
 
 		if (test_and_clear_bit(ISP_ABORT_NEEDED,
-- 
1.7.7

