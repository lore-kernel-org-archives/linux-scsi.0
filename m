From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 17/35] qla2xxx: Add diagnostic port functionality.
Date: Thu, 25 Sep 2014 05:16:48 -0400
Message-ID: <1411636626-7566-18-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:50910 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbaIYJvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:22 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Add support for the D-port (diagnostic port) fabric switch feature.

(Fabric Switch initiates loopback style port testing)

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +++---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_fw.h   |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    6 +++---
 drivers/scsi/qla2xxx/qla_isr.c  |    8 ++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |    3 ++-
 7 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 868f4e5..677239f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1440,7 +1440,7 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	int rval = QLA_FUNCTION_FAILED;
-	uint16_t state[5];
+	uint16_t state[6];
 	uint32_t pstate;
 
 	if (IS_QLAFX00(vha->hw)) {
@@ -1456,8 +1456,8 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 	if (rval != QLA_SUCCESS)
 		memset(state, -1, sizeof(state));
 
-	return scnprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x\n", state[0],
-	    state[1], state[2], state[3], state[4]);
+	return scnprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
+	    state[0], state[1], state[2], state[3], state[4], state[5]);
 }
 
 static ssize_t
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index b33eec0..2d5610b 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -28,7 +28,7 @@
  * |                              |                    | 0x303a		|
  * | DPC Thread                   |       0x4023       | 0x4002,0x4013  |
  * | Async Events                 |       0x5087       | 0x502b-0x502f  |
- * |                              |                    | 0x5047,0x5052  |
+ * |                              |                    | 0x5047		|
  * |                              |                    | 0x5084,0x5075	|
  * |                              |                    | 0x503d,0x5044  |
  * |                              |                    | 0x507b,0x505f	|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e5baead..c161d60 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -803,6 +803,7 @@ struct mbx_cmd_32 {
 #define MBA_FW_RESTART_CMPLT	0x8060	/* Firmware restart complete */
 #define MBA_INIT_REQUIRED	0x8061	/* Initialization required */
 #define MBA_SHUTDOWN_REQUESTED	0x8062	/* Shutdown Requested */
+#define MBA_DPORT_DIAGNOSTICS	0x8080	/* D-port Diagnostics */
 #define MBA_FW_INIT_FAILURE	0x8401	/* Firmware initialization failure */
 #define MBA_MIRROR_LUN_CHANGE	0x8402	/* Mirror LUN State Change
 					   Notification */
@@ -948,6 +949,7 @@ struct mbx_cmd_32 {
 #define MBC_WRITE_SFP			0x30	/* Write SFP Data. */
 #define MBC_READ_SFP			0x31	/* Read SFP Data. */
 #define MBC_SET_TIMEOUT_PARAMS		0x32	/* Set FW timeouts. */
+#define MBC_DPORT_DIAGNOSTICS		0x47	/* D-Port Diagnostics */
 #define MBC_MID_INITIALIZE_FIRMWARE	0x48	/* MID Initialize firmware. */
 #define MBC_MID_GET_VP_DATABASE		0x49	/* MID Get VP Database. */
 #define MBC_MID_GET_VP_ENTRY		0x4a	/* MID Get VP Entry. */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index e8669aa..7f2e1c7 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -318,7 +318,7 @@ struct init_cb_24xx {
 	 * BIT 4  = Enable Target Mode
 	 * BIT 5  = Disable Initiator Mode
 	 * BIT 6  = Acquire FA-WWN
-	 * BIT 7  = Reserved
+	 * BIT 7  = Enable D-port Diagnostics
 	 *
 	 * BIT 8  = Reserved
 	 * BIT 9  = Non Participating LIP
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 748bd90..d5b10ec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2224,7 +2224,7 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 	unsigned long	wtime, mtime, cs84xx_time;
 	uint16_t	min_wait;	/* Minimum wait time if loop is down */
 	uint16_t	wait_time;	/* Wait time if loop is coming ready */
-	uint16_t	state[5];
+	uint16_t	state[6];
 	struct qla_hw_data *ha = vha->hw;
 
 	if (IS_QLAFX00(vha->hw))
@@ -2329,8 +2329,8 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 	} while (1);
 
 	ql_dbg(ql_dbg_taskm, vha, 0x803a,
-	    "fw_state=%x (%x, %x, %x, %x) " "curr time=%lx.\n", state[0],
-	    state[1], state[2], state[3], state[4], jiffies);
+	    "fw_state=%x (%x, %x, %x, %x %x) curr time=%lx.\n", state[0],
+	    state[1], state[2], state[3], state[4], state[5], jiffies);
 
 	if (rval && !(vha->device_flags & DFLG_NO_CABLE)) {
 		ql_log(ql_log_warn, vha, 0x803b,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 223c1a8..550ffdf 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1086,6 +1086,14 @@ skip_rio:
 		qla83xx_handle_8200_aen(vha, mb);
 		break;
 
+	case MBA_DPORT_DIAGNOSTICS:
+		ql_dbg(ql_dbg_async, vha, 0x5052,
+		    "D-Port Diagnostics: %04x %04x=%s\n", mb[0], mb[1],
+		    mb[1] == 0 ? "start" :
+		    mb[1] == 1 ? "done (ok)" :
+		    mb[1] == 2 ? "done (error)" : "other");
+		break;
+
 	default:
 		ql_dbg(ql_dbg_async, vha, 0x5057,
 		    "Unknown AEN:%04x %04x %04x %04x\n",
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2de901b..72971da 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1564,7 +1564,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(vha->hw))
-		mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+		mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	else
 		mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
@@ -1578,6 +1578,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 		states[2] = mcp->mb[3];
 		states[3] = mcp->mb[4];
 		states[4] = mcp->mb[5];
+		states[5] = mcp->mb[6];  /* DPORT status */
 	}
 
 	if (rval != QLA_SUCCESS) {
-- 
1.7.7

