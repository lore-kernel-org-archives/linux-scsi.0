From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/20] qla2xxx: Add 10Gb iiDMA support.
Date: Wed,  3 Jun 2009 09:55:22 -0700
Message-ID: <1244048131-56590-12-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbZFCQzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:37 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   |    3 +++
 drivers/scsi/qla2xxx/qla_init.c |   10 ++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 3dbb9e7..917534b 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1879,6 +1879,9 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 			case BIT_13:
 				list[i].fp_speed = PORT_SPEED_4GB;
 				break;
+			case BIT_12:
+				list[i].fp_speed = PORT_SPEED_10GB;
+				break;
 			case BIT_11:
 				list[i].fp_speed = PORT_SPEED_8GB;
 				break;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d145de0..cb4d952 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2248,7 +2248,8 @@ static void
 qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 #define LS_UNKNOWN      2
-	static char *link_speeds[5] = { "1", "2", "?", "4", "8" };
+	static char *link_speeds[] = { "1", "2", "?", "4", "8", "10" };
+	char *link_speed;
 	int rval;
 	uint16_t mb[6];
 	struct qla_hw_data *ha = vha->hw;
@@ -2271,10 +2272,15 @@ qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    fcport->port_name[6], fcport->port_name[7], rval,
 		    fcport->fp_speed, mb[0], mb[1]));
 	} else {
+		link_speed = link_speeds[LS_UNKNOWN];
+		if (fcport->fp_speed < 5)
+			link_speed = link_speeds[fcport->fp_speed];
+		else if (fcport->fp_speed == 0x13)
+			link_speed = link_speeds[5];
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "iIDMA adjusted to %s GB/s on "
 		    "%02x%02x%02x%02x%02x%02x%02x%02x.\n",
-		    link_speeds[fcport->fp_speed], fcport->port_name[0],
+		    link_speed, fcport->port_name[0],
 		    fcport->port_name[1], fcport->port_name[2],
 		    fcport->port_name[3], fcport->port_name[4],
 		    fcport->port_name[5], fcport->port_name[6],
-- 
1.6.3.1.244.gf9275

