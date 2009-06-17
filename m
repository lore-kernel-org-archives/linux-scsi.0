From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/5] qla2xxx: Correct iiDMA-update calling conventions.
Date: Wed, 17 Jun 2009 10:30:29 -0700
Message-ID: <1245259832-8595-3-git-send-email-andrew.vasquez@qlogic.com>
References: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:16588 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759987AbZFQRaf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 13:30:35 -0400
In-Reply-To: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

* To set iiDMA speeds for ISP81XX, bits 5-0 are used whereas for
  other older ISPs bits 2-0 are used.
* Pass proper VP index

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2620261..f2ce8e3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2301,7 +2301,7 @@ qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	static char *link_speeds[] = { "1", "2", "?", "4", "8", "10" };
 	char *link_speed;
 	int rval;
-	uint16_t mb[6];
+	uint16_t mb[4];
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_IIDMA_CAPABLE(ha))
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 451ece0..779ce14 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2697,10 +2697,13 @@ qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
 	mcp->mb[0] = MBC_PORT_PARAMS;
 	mcp->mb[1] = loop_id;
 	mcp->mb[2] = BIT_0;
-	mcp->mb[3] = port_speed & (BIT_2|BIT_1|BIT_0);
-	mcp->mb[4] = mcp->mb[5] = 0;
-	mcp->out_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
+	if (IS_QLA81XX(vha->hw))
+		mcp->mb[3] = port_speed & (BIT_5|BIT_4|BIT_3|BIT_2|BIT_1|BIT_0);
+	else
+		mcp->mb[3] = port_speed & (BIT_2|BIT_1|BIT_0);
+	mcp->mb[9] = vha->vp_idx;
+	mcp->out_mb = MBX_9|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_3|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -2710,8 +2713,6 @@ qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
 		mb[0] = mcp->mb[0];
 		mb[1] = mcp->mb[1];
 		mb[3] = mcp->mb[3];
-		mb[4] = mcp->mb[4];
-		mb[5] = mcp->mb[5];
 	}
 
 	if (rval != QLA_SUCCESS) {
-- 
1.6.3.2.306.g4f4fa

