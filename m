From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 03/19] qla2xxx: Shutdown board on thermal shutdown aen.
Date: Wed, 6 Jul 2016 11:14:19 -0400
Message-ID: <1467818075-15246-4-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:19888 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbcGFP7r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:47 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |  2 +-
 drivers/scsi/qla2xxx/qla_def.h |  1 +
 drivers/scsi/qla2xxx/qla_isr.c |  7 +++++++
 drivers/scsi/qla2xxx/qla_os.c  | 10 ++++++++++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index b985fcb..0671f07 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -27,7 +27,7 @@
  * |                              |                    | 0x303a		|
  * | DPC Thread                   |       0x4023       | 0x4002,0x4013  |
  * | Async Events                 |       0x5089       | 0x502b-0x502f  |
- * |                              |                    | 0x505e         |
+ * |				  | 		       | 0x5047         |
  * |                              |                    | 0x5084,0x5075	|
  * |                              |                    | 0x503d,0x5044  |
  * |                              |                    | 0x507b,0x505f	|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7f86147..2b7e4f5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -829,6 +829,7 @@ struct mbx_cmd_32 {
 #define MBA_FW_RESTART_CMPLT	0x8060	/* Firmware restart complete */
 #define MBA_INIT_REQUIRED	0x8061	/* Initialization required */
 #define MBA_SHUTDOWN_REQUESTED	0x8062	/* Shutdown Requested */
+#define MBA_TEMPERATURE_ALERT	0x8070	/* Temperature Alert */
 #define MBA_DPORT_DIAGNOSTICS	0x8080	/* D-port Diagnostics */
 #define MBA_FW_INIT_FAILURE	0x8401	/* Firmware initialization failure */
 #define MBA_MIRROR_LUN_CHANGE	0x8402	/* Mirror LUN State Change
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5649c20..f1bfb42 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1158,6 +1158,13 @@ global_port_update:
 		    mb[1] == 2 ? "done (error)" : "other");
 		break;
 
+	case MBA_TEMPERATURE_ALERT:
+		ql_dbg(ql_dbg_async, vha, 0x505e,
+		    "TEMPERATURE ALERT: %04x %04x %04x\n", mb[1], mb[2], mb[3]);
+		if (mb[1] == 0x12)
+			schedule_work(&ha->board_disable);
+		break;
+
 	default:
 		ql_dbg(ql_dbg_async, vha, 0x5057,
 		    "Unknown AEN:%04x %04x %04x %04x\n",
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7c0b60c..dc608ce 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2901,6 +2901,10 @@ skip_dpc:
 	qlt_add_target(ha, base_vha);
 
 	clear_bit(PFLG_DRIVER_PROBING, &base_vha->pci_flags);
+
+	if (test_bit(UNLOADING, &base_vha->dpc_flags))
+		return -ENODEV;
+
 	return 0;
 
 probe_init_failed:
@@ -2947,7 +2951,10 @@ iospace_config_failed:
 	ha = NULL;
 
 probe_out:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
+	if (test_bit(UNLOADING, &base_vha->dpc_flags))
+		return -ENODEV;
 	return ret;
 }
 
@@ -5002,6 +5009,9 @@ qla2x00_do_dpc(void *data)
 		    "DPC handler waking up, dpc_flags=0x%lx.\n",
 		    base_vha->dpc_flags);
 
+		if (test_bit(UNLOADING, &base_vha->dpc_flags))
+			break;
+
 		qla2x00_do_work(base_vha);
 
 		if (IS_P3P_TYPE(ha)) {
-- 
2.7.2

