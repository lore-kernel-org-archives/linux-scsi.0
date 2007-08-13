From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/6] qla2xxx: Correct 8GB iIDMA support.
Date: Sun, 12 Aug 2007 18:22:55 -0700
Message-ID: <11869681771520-git-send-email-andrew.vasquez@qlogic.com>
References: <20070813012218.GD1067@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31599 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766000AbXHMBX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 21:23:26 -0400
In-Reply-To: <20070813012218.GD1067@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original implementation manipulated the FC_GS values for
port-speed.  Transition the codes to use the driver's own
internal representations as this makes for a reduction in
duplicate 'conversion' codes throughout the driver.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    1 -
 drivers/scsi/qla2xxx/qla_gs.c   |   24 +++++++++++++++-----
 drivers/scsi/qla2xxx/qla_init.c |   45 +++++++++-----------------------------
 3 files changed, 29 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 27ae3a5..c196486 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1502,7 +1502,6 @@ typedef struct {
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
 	uint8_t fabric_port_name[WWN_SIZE];
-	uint16_t fp_speeds;
 	uint16_t fp_speed;
 } sw_info_t;
 
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index b06cbb8..60bf239 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1821,7 +1821,7 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GFPN_ID */
-		list[i].fp_speeds = list[i].fp_speed = 0;
+		list[i].fp_speed = PORT_SPEED_UNKNOWN;
 
 		/* Prepare common MS IOCB */
 		ms_pkt = qla24xx_prep_ms_fm_iocb(ha, GPSC_REQ_SIZE,
@@ -1858,9 +1858,21 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 			}
 			rval = QLA_FUNCTION_FAILED;
 		} else {
-			/* Save portname */
-			list[i].fp_speeds = ct_rsp->rsp.gpsc.speeds;
-			list[i].fp_speed = ct_rsp->rsp.gpsc.speed;
+			/* Save port-speed */
+			switch (be16_to_cpu(ct_rsp->rsp.gpsc.speed)) {
+			case BIT_15:
+				list[i].fp_speed = PORT_SPEED_1GB;
+				break;
+			case BIT_14:
+				list[i].fp_speed = PORT_SPEED_2GB;
+				break;
+			case BIT_13:
+				list[i].fp_speed = PORT_SPEED_4GB;
+				break;
+			case BIT_11:
+				list[i].fp_speed = PORT_SPEED_8GB;
+				break;
+			}
 
 			DEBUG2_3(printk("scsi(%ld): GPSC ext entry - "
 			    "fpn %02x%02x%02x%02x%02x%02x%02x%02x speeds=%04x "
@@ -1873,8 +1885,8 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 			    list[i].fabric_port_name[5],
 			    list[i].fabric_port_name[6],
 			    list[i].fabric_port_name[7],
-			    be16_to_cpu(list[i].fp_speeds),
-			    be16_to_cpu(list[i].fp_speed)));
+			    be16_to_cpu(ct_rsp->rsp.gpsc.speeds),
+			    be16_to_cpu(ct_rsp->rsp.gpsc.speed)));
 		}
 
 		/* Last device exit. */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8da0586..1a058ec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2079,17 +2079,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 		}
 
 		/* Base iIDMA settings on HBA port speed. */
-		switch (ha->link_data_rate) {
-		case PORT_SPEED_1GB:
-			fcport->fp_speed = cpu_to_be16(BIT_15);
-			break;
-		case PORT_SPEED_2GB:
-			fcport->fp_speed = cpu_to_be16(BIT_14);
-			break;
-		case PORT_SPEED_4GB:
-			fcport->fp_speed = cpu_to_be16(BIT_13);
-			break;
-		}
+		fcport->fp_speed = ha->link_data_rate;
 
 		qla2x00_update_fcport(ha, fcport);
 
@@ -2130,38 +2120,25 @@ static void
 qla2x00_iidma_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
 #define LS_UNKNOWN      2
-	static char *link_speeds[5] = { "1", "2", "?", "4" };
+	static char *link_speeds[5] = { "1", "2", "?", "4", "8" };
 	int rval;
-	uint16_t port_speed, mb[6];
+	uint16_t mb[6];
 
 	if (!IS_IIDMA_CAPABLE(ha))
 		return;
 
-	switch (be16_to_cpu(fcport->fp_speed)) {
-	case BIT_15:
-		port_speed = PORT_SPEED_1GB;
-		break;
-	case BIT_14:
-		port_speed = PORT_SPEED_2GB;
-		break;
-	case BIT_13:
-		port_speed = PORT_SPEED_4GB;
-		break;
-	default:
+	if (fcport->fp_speed == PORT_SPEED_UNKNOWN) {
 		DEBUG2(printk("scsi(%ld): %02x%02x%02x%02x%02x%02x%02x%02x -- "
-		    "unsupported FM port operating speed (%04x).\n",
+		    "unsupported FM port operating speed.\n",
 		    ha->host_no, fcport->port_name[0], fcport->port_name[1],
 		    fcport->port_name[2], fcport->port_name[3],
 		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
-		    be16_to_cpu(fcport->fp_speed)));
-		port_speed = PORT_SPEED_UNKNOWN;
-		break;
-	}
-	if (port_speed == PORT_SPEED_UNKNOWN)
+		    fcport->port_name[6], fcport->port_name[7]));
 		return;
+	}
 
-	rval = qla2x00_set_idma_speed(ha, fcport->loop_id, port_speed, mb);
+	rval = qla2x00_set_idma_speed(ha, fcport->loop_id, fcport->fp_speed,
+	    mb);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(printk("scsi(%ld): Unable to adjust iIDMA "
 		    "%02x%02x%02x%02x%02x%02x%02x%02x -- %04x %x %04x %04x.\n",
@@ -2169,12 +2146,12 @@ qla2x00_iidma_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 		    fcport->port_name[2], fcport->port_name[3],
 		    fcport->port_name[4], fcport->port_name[5],
 		    fcport->port_name[6], fcport->port_name[7], rval,
-		    port_speed, mb[0], mb[1]));
+		    fcport->fp_speed, mb[0], mb[1]));
 	} else {
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "iIDMA adjusted to %s GB/s on "
 		    "%02x%02x%02x%02x%02x%02x%02x%02x.\n",
-		    link_speeds[port_speed], fcport->port_name[0],
+		    link_speeds[fcport->fp_speed], fcport->port_name[0],
 		    fcport->port_name[1], fcport->port_name[2],
 		    fcport->port_name[3], fcport->port_name[4],
 		    fcport->port_name[5], fcport->port_name[6],
-- 
1.5.3.rc4.41.g7efe

